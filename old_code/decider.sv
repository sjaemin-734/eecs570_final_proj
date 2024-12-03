/* NOTICE: THIS MODULE HAS BEEN ABSORBED INTO THE CONTROL LOGIC
   BECAUSE A MEMORY MODULE HAS BEEN CREATED TO REPLACE IT
*/
/* The Decider receives a list of variable indices and their initial decision value.
   It goes down the list of indices and provides their value when the Control asks for it
   It can also reset its position to what the Control tells it to
*/
`include "sysdefs.svh"

module decider(
    input config_var dec_config, // A pair of variable index and its decision value, from Decider Config
    input read, // Control is asking for next value
    input write, // Control is replacing back_dec_idx
    input [`MAX_VARS_BITS-1:0] back_dec_idx, // Used by the Control when backtracking
    input clock,
    input reset,

    // To Control
    output logic [`MAX_VARS_BITS-1:0] dec_idx_out,
    output logic [`MAX_VARS_BITS-1:0] var_idx_out,
    output logic val_out,

    // To Decider Config
    output logic read_config;
    output logic address;

);

integer dec_idx; // Used by Control to ask for a decision

// Instantiate for assign
wire [`MAX_VARS_BITS-1:0] var_idx;
wire val;
wire [`MAX_VARS_BITS-1:0] next_dec_idx;

// Intermediate Outputs
assign var_idx = dec_config.var_idx;
assign val = dec_config.val;
assign next_dec_idx = dec_idx + 1;
assign read_config = read;
assign address = dec_idx;

integer i;
always_ff @(posedge clock) begin
    if(reset) begin
        dec_idx <= 0;
        dec_idx_out <= 0;
        var_idx_out <= 0;
        val_out <= 0;
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