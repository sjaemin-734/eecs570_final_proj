`include "stack.sv"

// control module
module control # (
    parameter NUM_VARIABLE = 128,
    parameter VARIABLE_INDEX = 7-1;
    parameter VAR_PER_CLAUSE = 5
)(
    input clock,
    input reset,
    input start,
    output logic sat,                     // Have separate UNSAT/SAT variable just in case
    output logic unsat
);

enum logic [3:0]{
    IDLE,
    FIND_NEXT,
    DECICE,
    BCP_INIT,
    BCP_CORE,
    BACKPROP,
    BCP_WAIT,
    SAT,
    UNSAT
} state = IDLE;

logic [3:0] next_state;

logic conflict;
logic prop_val;
logic prop_var;
logic prop_type;

logic empty_imply;
logic full_imply;
logic pop_imply;

logic empty_trace;
logic full_trace;
logic pop_trace;
logic push_trace;

always_comb begin
    if (reset){
        conflict = 1'b0;
        prop_val = 1'b0;
        prop_var = VARIABLE_INDEX{1'b0};
        sat = 0;
        unsat = 0;
    }
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
        .var_out(),
        .type_out(),
        .val_out(),
        .empty(empty_trace),
        .full(full_trace)
    );


always_ff @(posedge clock) begin
    if (reset) begin 
        state <= IDLE;
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
                // Update Var State Table with unassign = 0 & val = prop_val
                next_state <= BCP_INIT;
            end
        end
        DECICE: begin
            push_trace <= 0'b1;
            // decide module gives prop_var, prop_val, prop_type (D)
            // Update Var State Table with unassign = 0 & val = prop_val
            next_state <= BCP_INIT;
        end
        BCP_INIT: begin
            push_trace <= 0'b0;
            // Receive start and end clause IDs for prop_var
            next_state <= BCP_CORE;
        end
        BCP_CORE: begin
            // Receive clause info
        end
        BACKPROP: begin
            conflict <= 0'b0;           // TODO: Where does this happen?
            // Send conflict line to Decide Module
            if (~prop_type) begin       // D == 0
                pop_trace <= 1'b0;
                next_state <= BCP_INIT;
                push_trace <= 1'b1;
                prop_type <= 1'b1;      // Change to F == 1
            end
            if (empty_trace) begin
                next_state <= UNSAT;
                pop_trace < = 1'b0;     // Stop popping from trace table
            end
        end
        BCP_WAIT: begin
            if (conflict)
                next_state <= BACKPROP;
                pop_trace < = 1'b1;
            else 
                next_state <= FIND_NEXT;
        end
        endcase
    end

end




endmodule