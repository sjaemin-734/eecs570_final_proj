/* The Decider receives a list of variable indices and their initial decision value.
   It goes down the list of indices and provides their value when the Control asks for it
   It can also reset its position to what the Control tells it to
*/
`include "sysdefs.svh"

module decider(
    input config_var dec_config, // A pair of variable inde and its decision value
    input writemem, // High when getting config data
    input read, // Control is asking for next value
    input write, // Control is replacing dec_idx
    input [`MAX_VARS_BITS-1:0] back_dec_idx, // Used by the Control when backtracking
    input clock,
    input reset,

    output logic [`MAX_VARS_BITS-1:0] dec_idx_out,
    output logic [`MAX_VARS_BITS-1:0] var_idx_out,
    output logic val_out
);

integer dec_idx; // Used by Control to ask for a decision
integer mem_idx; // Used when filling up the dec_configs initially

config_var [`MAX_VARS-1:0] dec_configs; // Holds the configs

// Instantiate for assign
wire [`MAX_VARS_BITS-1:0] var_idx;
wire val;
wire [`MAX_VARS_BITS-1:0] next_dec_idx;

// Intermediate Outputs
assign var_idx = dec_configs[dec_idx].var_idx;
assign val = dec_configs[dec_idx].val;
assign next_dec_idx = dec_idx + 1;

integer i;
always_ff @(posedge clock) begin
    if(reset) begin
        dec_idx <= 0;
        for (i=0; i < `MAX_VARS; i++) begin
            dec_configs[i].var_idx <= 8'b0;
            dec_configs[i].val <= 1'b0;
        end
        mem_idx <= 0;
    end
    else if (writemem) begin
        dec_configs[mem_idx] <= dec_config;
        mem_idx++;
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