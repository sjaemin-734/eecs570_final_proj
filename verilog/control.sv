`include "sysdefs.svh"

// control module
module control (
    input clock,
    input reset,
    input start,
    input [`MAX_VARS_BITS-1:0] max_var_test,
    // BCP CORE
    input bcp_busy,
    input conflict,
    output logic [`MAX_CLAUSES_BITS-1:0] bcp_clause_idx,
    output logic reset_bcp,
    output logic bcp_en,

    // IMPLY
    input empty_imply,
    input [`MAX_VARS_BITS-1:0] var_out_imply,
    input val_out_imply,
    input type_out_imply,
    output logic pop_imply,
    // TRACE
    input empty_trace,
    input [`MAX_VARS_BITS-1:0] var_out_trace,
    input val_out_trace,
    input type_out_trace,
    output logic pop_trace,
    output logic push_trace,
    output logic [`MAX_VARS_BITS-1:0] var_in_trace,
    output logic val_in_trace,
    output logic type_in_trace,
    // VAR STATE
    input val_out_vs,
    input unassign_out_vs,
    output logic write_vs,
    output logic read_vs,
    output logic [`MAX_VARS_BITS-1:0] var_in_vs,
    output logic val_in_vs,
    output logic unassign_in_vs,
    // VAR START END TABLE
    input [`CLAUSE_TABLE_BITS-1:0] start_clause,
    input [`CLAUSE_TABLE_BITS-1:0] end_clause,
    output logic read_var_start_end,
    output logic [`MAX_VARS_BITS-1:0] var_in_vse,
    // DECIDER MEMORY MODULE
    input  [`MAX_VARS_BITS-1:0] var_idx_d,
    input val_d,
    output logic read_d, // Control is asking for next value
    output logic [`MAX_VARS_BITS-1:0] dec_idx_d_in, // Used by the Control to access memory module
    // DECIDER STACK
    input [`MAX_VARS_BITS-1:0] dec_idx_ds_out,
    input empty_ds,
    output logic push_ds,
    output logic pop_ds,
    output logic [`MAX_VARS_BITS-1:0] dec_idx_ds_in,
    // SAT Results
    output logic sat,                     // Have separate UNSAT/SAT variable just in case
    output logic unsat,
    // State debug
    output logic [3:0] state_out
    // is_conflict
);

// state variables
enum logic [3:0]{
    IDLE,
    FIND_NEXT,
    DECIDE,
    BCP_INIT,
    BCP_CORE,
    BACKPROP,
    BCP_WAIT,       // CHECK:Is it needed to for another transient state?
    SAT,
    UNSAT
} state;
logic [3:0] next_state;

// variable to use for BCP
logic [`MAX_VARS_BITS-1:0] var_in_bcp;

// Index through start to end
logic [`CLAUSE_TABLE_BITS-1:0] i;

// Keep conflict line
// logic is_conflict;

// Tells Decider which index to use
logic from_decider;

always_comb begin
    if (reset) begin
        state = IDLE;
        state_out = IDLE;
        sat = 1'b0;
        unsat = 1'b0;
        // is_conflict = 1'b0;
    end else begin
        state = next_state;
        state_out = next_state;
        // if (conflict) is_conflict = 1'b1;
        case(state)
            DECIDE: begin
                from_decider = 1'b1;
            end
            BACKPROP: begin
                // is_conflict = 1'b0;
                from_decider = 1'b0;
            end
            SAT: begin
                sat = 1'b1;
            end
            UNSAT:begin
                unsat = 1'b1;
            end
        endcase
    end
end


always_ff @(posedge clock) begin
    if (reset) begin
        next_state <= IDLE;
        push_trace <= 1'b0;
        pop_imply <= 1'b0;
        pop_trace <= 1'b0;
        write_vs <= 1'b0;
        val_in_vs <= 1'b0;
        dec_idx_d_in <= 1'b0;
        bcp_en <= 1'b0;
        read_var_start_end <= 1'b0;
        reset_bcp = 1'b1;

    end else begin
        case(state)
        IDLE: begin
            if (start) begin
                next_state <= FIND_NEXT;
                pop_imply <= 1'b1;
                reset_bcp <= 1'b0;
            end
        end
        FIND_NEXT: begin
            pop_imply <= 1'b0;
            if (empty_imply) begin
                read_d <= 1'b1;
                next_state <= DECIDE;
            end else begin
                push_trace <= 1'b1;
                write_vs <= 1'b1;
                // TODO:Update Var State Table with unassign = 0 & val = val_out_imply
                unassign_in_vs <= 1'b0;
                val_in_vs <= val_out_imply;
                var_in_vs <= var_out_imply;

                val_in_trace <= val_out_imply;
                var_in_trace <= var_out_imply;
                type_in_trace <= type_out_imply;

                var_in_bcp <= var_out_imply;

                next_state <= BCP_INIT;
            end
        end
        DECIDE: begin
            read_vs <= 1'b1;
            var_in_vs <= var_idx_d;
            if (dec_idx_d_in == max_var_test) begin
                next_state = SAT;
            end else if(unassign_out_vs) begin
                push_trace <= 1'b1;
                write_vs <= 1'b1;
                read_d <= 1'b0;
                push_ds <= 1'b1;

                unassign_in_vs <= 1'b0;
                val_in_vs <= val_d;
                var_in_vs <= var_idx_d;

                val_in_trace <= val_d;
                var_in_trace <= var_idx_d;
                type_in_trace <= 1'b0;

                dec_idx_ds_in <= dec_idx_d_in;

                var_in_bcp <= var_idx_d;

                next_state <= BCP_INIT;
            end else begin
                dec_idx_d_in <= dec_idx_d_in+1;
            end
            // TODO:decide module gives var_out_imply, val_out_imply, type_out_imply (D)
            // TODO:Update Var State Table with unassign = 0 & val = val_out_imply
        end
        BCP_INIT: begin
            reset_bcp <= 1'b0;
            push_trace <= 1'b0;
            write_vs <= 1'b0;
            read_vs <= 1'b0;
            push_ds <= 1'b0;
            pop_ds <= 1'b0;
            // Receive start and end clause IDs for var_out_imply

            dec_idx_d_in <= from_decider ? dec_idx_d_in+1 : dec_idx_ds_out;
            read_var_start_end <= 1'b1;
            var_in_vse <= var_in_bcp;
            i <= 0;
            next_state <= BCP_CORE;
        end
        BCP_CORE: begin
            read_var_start_end <= 1'b0;
            bcp_clause_idx <= start_clause + i;     // Input of Clause Database (index)
            bcp_en <= 1'b1;     // Connected to Clause Database (read)
            if (start_clause + i == end_clause - 1) begin
                next_state <= BCP_WAIT;
            end
            i <= i + 1;         // TODO: Check if this increment messes with previous lines
            
        end
        BACKPROP: begin
            reset_bcp <= 1'b1;           // TODO: Where & How does this happen? Clearing conflict variable
            // Send conflict line to Decide Module

            //Update Var State table from values coming from popping Trace Table
            if (empty_trace) begin
                next_state <= UNSAT;
                pop_trace <= 1'b0;     // Stop popping from trace table
            end else if (~type_out_trace) begin
                pop_trace <= 1'b0;
                push_trace <= 1'b1;
                write_vs <= 1'b1;
                pop_ds <= 1'b1;

                unassign_in_vs <= 1'b0;
                val_in_vs <= ~val_out_trace;
                var_in_vs <= var_out_trace;

                val_in_trace <= ~val_out_trace;
                var_in_trace <= var_out_trace;
                type_in_trace <= 1'b1;

                var_in_bcp <= var_out_trace;

                next_state <= BCP_INIT;
            end else begin
                write_vs <= 1'b1;
                unassign_in_vs <= 1'b1;
                var_in_vs <= var_out_trace;
            end

        end
        BCP_WAIT: begin
            bcp_en <= 1'b0;
            if (conflict) begin
                next_state <= BACKPROP;
                pop_trace <= 1'b1;
            end else if (~bcp_busy) begin
                next_state <= FIND_NEXT;
                pop_imply <= 1'b1;
            end 
        end
        endcase
    end

end

endmodule