/* The Decider receives a list of variable indices and their initial decision value.
   It goes down the list of indices and provides their value when the Control asks for it
   It can also reset its position to what the Control tells it to
*/


module decider(
    input [`MAX_VARS-1:0][1:0] dec_config, // List of variable indices and their decision values
    input rw, // Read = 0, Write = 1. If read, Control is asking for next values. If write, Control is replacing dec_idx
    input [`MAX_VARS_BITS-1:0] back_dec_idx, // Used by the Control when backtracking
    input clock,
    input reset,
    input en,

    output [`MAX_VARS_BITS-1:0] dec_idx_out,
    output [`MAX_VARS_BITS-1:0] var_idx_out,
    output  val_out
);

integer dec_idx;


assign var_idx = dec_config[dec_idx][0];
assign val = dec_config[dec_idx][1];
assign next_dec_idx = dec_idx +1;

always_ff @(posedge clock) begin
    if(reset) begin
        dec_idx <= 0;
    end
    elseif (en) begin
        if(rw) begin
            // Write
            dec_idx <= back_dec_idx;
        end
        else begin
            //Read
            dec_idx <= next_dec_idx;
        end
    end
end



endmodule