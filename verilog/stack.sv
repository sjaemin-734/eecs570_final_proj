
// To use this as an imply stack, tie val_in to 1.
// To use this as a trace table, leave everything as is.
module stack #(parameter VARIABLE_INDEXES = 8, parameter NUM_VARIABLE = 128)(
    input                                clock,
    input                                reset,
    input                                push,
    input                                pop,
    input                                type_in, //  Decide = 0, Forced = 1 
    input                                val_in,
    input        [VARIABLE_INDEXES-1:0]  var_in,
    output logic                         type_out,
    output logic                         val_out,
    output logic [VARIABLE_INDEXES-1:0]  var_out,           
    output logic                         empty,
    output logic                         full
);

    logic [(NUM_VARIABLE-1):0][VARIABLE_INDEXES+1:0] stack ; // 2 extra bits for val and type
    logic [$clog2(NUM_VARIABLE):0]  stack_ptr;

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

                if (stack_ptr == NUM_VARIABLE - 1) begin
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
            type_out = stack[stack_ptr - 1][VARIABLE_INDEXES+1];
            val_out = stack[stack_ptr - 1][VARIABLE_INDEXES];
            var_out = stack[stack_ptr - 1][VARIABLE_INDEXES-1:0];
      end else begin
            type_out = 1'b0;
            val_out = 1'b0;
            var_out = {VARIABLE_INDEXES{1'b0}};
      end
    end

endmodule