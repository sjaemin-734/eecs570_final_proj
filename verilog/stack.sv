// To use this as an imply stack, tie type_in to 1.
// To use this as a trace table, leave everything as is.

`include "sysdefs.svh"
module stack (
    input                                clock,
    input                                reset,
    input                                push,
    input                                pop,
    input                                type_in, //  Decide = 0, Forced = 1 
    input                                val_in,
    input        [`MAX_VARS_BITS-1:0]  var_in,
    output logic                         type_out,
    output logic                         val_out,
    output logic [`MAX_VARS_BITS-1:0]  var_out,           
    output logic                         empty,
    output logic                         full
);

    logic [(`MAX_VARS-1):0][`MAX_VARS_BITS+1:0] stack ; // 2 extra bits for val and type
    logic [$clog2(`MAX_VARS):0]  stack_ptr;

    always_ff @(posedge clock) begin
        if (reset) begin
            stack_ptr <= 0;
            empty <= 1;
            full <= 0;

        end else begin
            if (push && !full) begin
                stack[stack_ptr] <= {type_in, val_in, var_in};
                stack_ptr        <= stack_ptr + 1;
                empty            <= 0;

                if (stack_ptr == `MAX_VARS - 1) begin
                    full <= 1;
                end

            end else if (pop && !empty) begin
                stack_ptr <= stack_ptr - 1;
                full      <= 0;

                if (stack_ptr == 1) begin
                    empty <= 1;
                end
            end
        end
    end

    always_comb begin
      if (!empty & pop) begin
            type_out = stack[stack_ptr-1][`MAX_VARS_BITS+1];
            val_out = stack[stack_ptr-1][`MAX_VARS_BITS];
            var_out = stack[stack_ptr-1][`MAX_VARS_BITS-1:0];
      end else begin
            type_out = 1'b0;
            val_out = 1'b0;
            var_out = {`MAX_VARS_BITS{1'b0}};
      end
    end

endmodule