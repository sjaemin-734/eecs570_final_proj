`include "sysdefs.svh"

// TODO: Expand into 5 ports? so that 5 var can be read at a time when reading clause info

module var_state(
    input                                clock,
    input                                reset,
    input                                read,
    // input                                multi_read,
    input                                write,
    // For write
    input                                val_in,
    input                                unassign_in,
    // Used by both
    input        [`MAX_VARS_BITS - 1:0]   var_in,
    // input        [VAR_PER_CLAUSE - 1:0][MAX_VARS_BITS - 1:0]   data_in,
    // For read
    output logic                         val_out,
    output logic                         unassign_out
    // output        [VAR_PER_CLAUSE - 1:0][1:0]        data_out
);

    logic [(`MAX_VARS-1):0][1:0] states;         // 2 bits unassign (Not assigned = 1, assigned = 0) + val (True = 1, False = 0)

    always_ff @(posedge clock) begin
        if (reset) begin
            for(integer i = 0; i < `MAX_VARS; i = i + 1) begin
                states[i] = 2'b10;
            end
        end else begin
            if (write) begin
                states[var_in] <= {unassign_in, val_in};
            end
        end
    end

    always_comb begin
      if (read) begin
            val_out = states[var_in][0];
            unassign_out = states[var_in][1];
      end else begin
            val_out = 1'b0;
            unassign_out = 1'b1;
      end
    end

endmodule