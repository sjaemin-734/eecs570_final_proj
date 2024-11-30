`include "verilog/stack.sv"

// control module
module control # (
    parameter NUM_VARIABLE = 128,
    parameter VARIABLE_INDEX = 7-1,
    parameter VAR_PER_CLAUSE = 5
)(
    input clock,
    input reset,
    input start,
    output logic sat,                     // Have separate UNSAT/SAT variable just in case
    output logic unsat
);

// state variables
enum logic [3:0]{
    IDLE,
    FIND_NEXT,
    DECICE,
    BCP_INIT,
    BCP_CORE,
    BACKPROP,
    BCP_WAIT,       // CHECK:Is it needed to for another transient state?
    SAT,
    UNSAT
} state;
logic [3:0] next_state;

// Conflict
logic conflict;

// Propogate variable + type + value
logic prop_val;
logic [VARIABLE_INDEX:0] prop_var;
logic prop_type;

// Update variable + type + value
logic update_val;
logic [VARIABLE_INDEX:0] update_var;
logic update_type;

// Imply Table variables
logic empty_imply;
logic full_imply;
logic pop_imply;

// Trace Table variables
logic empty_trace;
logic full_trace;
logic pop_trace;
logic push_trace;

always_comb begin
    if (reset) begin
        conflict = 1'b0;
        prop_val = 1'b0;
        prop_type = 1'b0;
        prop_var = {VARIABLE_INDEX{1'b0}};
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

stack #(
        .VARIABLE_INDEXES(VARIABLE_INDEX),              // TODO: SYNC THIS VARIABLE
        .NUM_VARIABLE(NUM_VARIABLE)
) imply_stack (
        .clock(clock),
        .reset(conflict),                               // TODO: Is Conflict Module doing this?
        .pop(pop_imply),
        .var_out(prop_var),
        .type_in(),
        .val_in(),
        .var_in(),
        .type_out(prop_type),
        .val_out(prop_val),
        .empty(empty_imply),
        .full(full_imply)
    );

stack #(
        .VARIABLE_INDEXES(VARIABLE_INDEX),              // TODO: SYNC THIS VARIABLE
        .NUM_VARIABLE(NUM_VARIABLE)
) trace_stack (
        .clock(clock),
        .reset(reset),
        .push(push_trace),
        .pop(pop_trace),
        .type_in(prop_type),
        .val_in(prop_val),
        .var_in(prop_var),
        .var_out(update_var),
        .type_out(update_type),
        .val_out(update_val),
        .empty(empty_trace),
        .full(full_trace)
    );


always_ff @(posedge clock) begin
    if (reset) begin 
        state <= IDLE;
        push_trace <= 0'b0;
        pop_imply <= 0'b0;
        pop_trace <= 0'b0;
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
            pop_imply <= 0'b0;
            if (empty_imply) begin
                next_state <= DECICE;
            end else begin
                push_trace <= 0'b1;
                // TODO:Update Var State Table with unassign = 0 & val = prop_val
                next_state <= BCP_INIT;
            end
        end
        DECICE: begin
            push_trace <= 0'b1;
            // TODO:decide module gives prop_var, prop_val, prop_type (D)
            // TODO:Update Var State Table with unassign = 0 & val = prop_val
            next_state <= BCP_INIT;
        end
        BCP_INIT: begin
            push_trace <= 0'b0;
            // TODO: Receive start and end clause IDs for prop_var
            next_state <= BCP_CORE;
        end
        BCP_CORE: begin
            // TODO: Receive clause info
        end
        BACKPROP: begin
            conflict <= 0'b0;           // TODO: Where & How does this happen? Clearing conflict variable
            // TODO:Send conflict line to Decide Module
            // TODO:Update Var State table from values coming from popping Trace Table
            if (~prop_type) begin       // D == 0
                pop_trace <= 1'b0;
                next_state <= BCP_INIT;
                push_trace <= 1'b1;         // TODO: Might need to wait a cycle aka add transient state between
                prop_var <= update_var;
                prop_type <= ~update_type;      // Change to F == 1
                prop_val <= update_val;
            end
            if (empty_trace) begin
                next_state <= UNSAT;
                pop_trace <= 1'b0;     // Stop popping from trace table
            end
        end
        BCP_WAIT: begin
            if (conflict) begin
                next_state <= BACKPROP;
                pop_trace <= 1'b1;
            end else if (1'b1) begin        // TODO: Get NOT BUSY LINES from clause_eval & conflict modules
                next_state <= FIND_NEXT;
                pop_imply <= 1'b1;
            end 
        end
        endcase
    end

end

endmodule