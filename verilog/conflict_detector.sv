/*  Takes in a implication from a clause evaluator and
    checks whether the implied variable has been implied
    to another variable or not.

    Send whether there is a conflict or not to Solver

    If there is no conflict, the variable and its assignment
    will be sent to the Imply Stack
*/
`include "sysdefs.svh"

module conflict_detector(
    input [`MAX_VARS_BITS-1:0] var_idx_in,     // Implied Variable
    input val_in,               // Implied value
    input clock,
    input reset,
    input en,                   // From Clause Evaluator

    output logic conflict,
    output logic [`MAX_VARS_BITS-1:0] var_idx_out,
    output logic val_out,
    output logic imply_stack_push_en
);


// Internal Imply Memory
typedef struct packed {
    // logic [8:0] var_idx;
    logic val;
    logic valid;
} var_info;

var_info [`MAX_VARS-1:0] vals;

always_comb begin
    if (reset) begin
        conflict = 0;
    end else if (!conflict) begin
        conflict = vals[var_idx_in].valid && (val_in != vals[var_idx_in].val) && en;
    end
end


integer i;
always_ff @(posedge clock) begin

    if (reset) begin
        for (i=0; i < `MAX_VARS; i++) begin
            vals[i].valid <= 1'b0;
        end
        var_idx_out <= {`MAX_VARS_BITS-1{1'b0}};
        val_out <= 1'b0;
        imply_stack_push_en <= 0;
    end
    else if (!conflict) begin
        // Update local memory with variable value
        if (en) begin
            vals[var_idx_in].val <= val_in;
            vals[var_idx_in].valid <= 1'b1;
        end

        // Send variable index and value to imply stack
        var_idx_out <= var_idx_in;
        val_out <= val_in;
        imply_stack_push_en <= en;

    end
end


endmodule