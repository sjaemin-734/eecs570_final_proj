/* Holds the decisons made by the Decider in stack (FILO) order
   Needed when a conflict occurs and backtracing needs to happen
   Tells the Decider where to start deciding again (Through the control)

   Modified from stack.sv
*/
`include "sysdefs.svh"

module decider_stack (
    input                                clock,
    input                                reset,
    input                                push,
    input                                pop,
    input        [`MAX_VARS_BITS-1:0]  dec_idx_in, // Index for the Decider

    output logic [`MAX_VARS_BITS-1:0]  dec_idx_out,           
    output logic                         empty
    // output logic                         full
);

    logic [(`MAX_VARS-1):0][`MAX_VARS_BITS:0] stack;
    logic [`MAX_VARS_BITS:0]  stack_ptr;

    always_ff @(posedge clock) begin
        if (reset) begin
            stack_ptr <= 0;
            empty <= 1;
            // full <= 0;

        end else begin
            if (push) begin
                stack[stack_ptr] <= dec_idx_in;
                stack_ptr        <= stack_ptr + 1;
                empty            <= 0;

                // if (stack_ptr == NUM_VARIABLE - 1) begin
                //     full <= 1;
                // end

            end else if (pop && !empty) begin
                stack_ptr <= stack_ptr - 1;
                // full      <= 0;
                if (stack_ptr == 1) begin
                    empty <= 1;
                end
            end
        end
    end

    always_comb begin
      if (!empty & pop) begin
            dec_idx_out = stack[stack_ptr-1][`MAX_VARS_BITS-1:0];
      end else begin
            dec_idx_out = {`MAX_VARS_BITS{1'b0}};
      end
    end

endmodule