/*  Takes in a implication from a clause evaluator and
    checks whether the implied variable has been implied
    to another variable or not.

    Send whether there is a conflict or not to Solver

    If there is no conflict, the variable and its assignment
    will be sent to the Imply Stack
*/
`define MAX_VAR_COUNT 512

module conflict_detector(
    input logic [8:0] var_idx_in, // Implied Variable
    input logic val_in, // Implied value
    input logic clock,
    input logic reset,

    output logic conflict
    output logic [8:0] var_idx_out,
    output logic val_out,
);


// Internal Imply Memory
typedef struct packed {
    // logic [8:0] var_idx;
    logic val;
    logic valid = 0;
} var_info;

var_info [MAX_VAR_COUNT-1:0] vals;

assign conflict = vals[var_idx_in].valid && (val_in == vals[var_idx_in].val);

integer i
always_ff @(posedge clock) begin

    if (reset) begin
        for (i=0; i < MAX_VAR_COUNT; i++) begin
            vals[i].valid <= 0'b1;
        end
    end
    else if (!conflict) begin
        // Update local memory with variable value 
        vals[var_idx_in].val <= val_in;
        vals[var_idx_in].valid <= 1'b1;

        // Send variable index and value to imply stack
        var_idx_out <= var_idx_in;
        val_out <= val_in;
    end
end





endmodule