`include "sysdefs.svh"

// control module
module control (
    input clock,
    input reset,
    input start,
    // BCP CORE
    input bcp_busy,
    input conflict,
    output logic [`MAX_CLAUSES_BITS-1:0] bcp_clause_idx,
    output logic reset_bcp,

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
    output logic write_vs,
    output logic [`MAX_VARS_BITS-1:0] var_in_vs,
    output logic val_in_vs,
    output logic unassign_in_vs,
    // VAR START END TABLE
    input [`MAX_CLAUSES_BITS-1:0] start_clause,
    input [`MAX_CLAUSES_BITS-1:0] end_clause,
    output logic read_var_start_end,
    output logic [`MAX_VARS_BITS-1:0] var_in_vse,
    // DECIDER
    input logic [`MAX_VARS_BITS-1:0] dec_idx_d,
    input logic [`MAX_VARS_BITS-1:0] var_idx_d,
    input logic val_d,
    output config_var dec_config, // A pair of variable inde and its decision value
    output writemem_d, // High when getting config data
    output read_d, // Control is asking for next value
    output write_d, // Control is replacing dec_idx
    output [`MAX_VARS_BITS-1:0] back_dec_idx_d, // Used by the Control when backtracking
    // DECIDER STACK

    // SAT Results
    output logic sat,                     // Have separate UNSAT/SAT variable just in case
    output logic unsat
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
logic [`MAX_CLAUSES_BITS-1:0] i;

always_comb begin
    if (reset) begin
        sat = 1'b0;
        unsat = 1'b0;
    end
    case(state)
        SAT: begin
            sat = 1'b1;
        end
        UNSAT:begin
            unsat = 1'b1;
        end
    endcase
end


always_ff @(posedge clock) begin
    if (reset) begin 
        state <= BCP_WAIT;
        next_state = BCP_WAIT;
        push_trace <= 1'b0;
        pop_imply <= 1'b0;
        pop_trace <= 1'b0;
        write_vs <= 1'b0;
    end else begin
        state <= next_state;
        case(state)
        IDLE: begin
            if (start) begin
                next_state <= FIND_NEXT;
                pop_imply <= 1'b1;
            end
        end
        FIND_NEXT: begin
            pop_imply <= 1'b0;
            if (empty_imply) begin
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
            push_trace <= 1'b1;
            // TODO:decide module gives var_out_imply, val_out_imply, type_out_imply (D)
            // TODO:Update Var State Table with unassign = 0 & val = val_out_imply
            next_state <= BCP_INIT;
        end
        BCP_INIT: begin
            reset_bcp <= 1'b1;
            push_trace <= 1'b0;
            write_vs <= 1'b0;
            // Receive start and end clause IDs for var_out_imply
            read_var_start_end <= 1'b1;
            var_in_vse <= var_in_bcp;
            i <= 0;
            next_state <= BCP_CORE;
        end
        BCP_CORE: begin
            read_var_start_end <= 1'b0;
            bcp_clause_idx <= start_clause + i;
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

                unassign_in_vs <= 1'b0;
                val_in_vs <= ~val_out_trace;
                var_in_vs <= var_out_trace;

                val_in_trace <= ~val_out_trace;
                var_in_trace <= var_out_trace;
                type_in_trace <= 1'b1;

                var_in_bcp <= var_out_trace;

                pop_trace <= 1'b0;

                next_state <= BCP_INIT;
            end else begin
                write_vs <= 1'b1;
                unassign_in_vs <= 1'b1;
                var_in_vs <= var_out_trace;
            end

        end
        BCP_WAIT: begin
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