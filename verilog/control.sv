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

always_comb begin
    if (reset){
        conflict = 1'b0;
        prop_val = 1'b0;
        prop_var = VARIABLE_INDEX{1'b0};
    }
end

always_ff @(posedge clock) begin
    if (reset) begin 
        state <= IDLE;
        sat <= 0;
        unsat <= 0;
    end else begin
        state <= next_state;
        case(state)
        IDLE: begin
            if (start) next_state <= FIND_NEXT;
        end
        FIND_NEXT: begin
        end
        DECICE: begin
        end
        BCP_INIT: begin
        end
        BCP_CORE: begin
        end
        BACKPROP: begin
        end
        BCP_WAIT: begin
            next_state <= 
        end
        SAT: begin
            sat <= 1'b1;            // CHECK: Shouldn't matter that it latches on next cycle?
        end
        UNSAT: begin
            unsat <= 1'b1;          // CHECK: Shouldn't matter that it latches on next cycle?
        end


        endcase
    end

end




endmodule