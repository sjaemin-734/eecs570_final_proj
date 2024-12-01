/* The Decider receives a list of variable indices and their initial decision value.
   It goes down the list of indices and provides their value when the Control asks for it
   It can also reset its position to what the Control tells it to
*/
`include "sysdefs.svh"

module decider(
    input config_var [`MAX_VARS-1:0] dec_config, // List of variable indices and their decision values
    input read, // Control is asking for next value
    input write, // Control is replacing dec_idx
    input [`MAX_VARS_BITS-1:0] back_dec_idx, // Used by the Control when backtracking
    input clock,
    input reset,

    output logic [`MAX_VARS_BITS-1:0] dec_idx_out,
    output logic [`MAX_VARS_BITS-1:0] var_idx_out,
    output logic val_out
);

integer dec_idx;

wire [`MAX_VARS_BITS-1:0] var_idx;
wire val;
wire [`MAX_VARS_BITS-1:0] next_dec_idx;

assign var_idx = dec_config[dec_idx].var_idx;
assign val = dec_config[dec_idx].val;
assign next_dec_idx = dec_idx + 1;

always_ff @(posedge clock) begin
    if(reset) begin
        dec_idx <= 0;
    end
    else if (write) begin
        dec_idx <= back_dec_idx;
    end
    else if (read) begin
        dec_idx_out <= dec_idx;
        var_idx_out <= var_idx;
        val_out <= val;
        dec_idx <= next_dec_idx;
    end
end



endmodule