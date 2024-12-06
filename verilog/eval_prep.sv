/* Receives a clause from the Clause Database (via the Controller)
   Gets the variable values from the Variable State Table and sends
   the clause and variable info to the Clause Evaluator
*/

`include "sysdefs.svh"

module eval_prep(
    input [`CLAUSE_DATA_BITS-1:0] clause_info_in, // From Control
    input [`VAR_PER_CLAUSE - 1:0] unassign_in, // From Var State Table
    input [`VAR_PER_CLAUSE - 1:0] val_in, // From Var State Table

    input clock,
    input reset,
    input en,

    output logic [`VAR_PER_CLAUSE - 1:0][`MAX_VARS_BITS - 1:0] idx_out, // To Var State Table

   // To Clause Evaluator
    output logic [`VAR_PER_CLAUSE-1:0] clause_mask_out,
    output logic [`VAR_PER_CLAUSE-1:0] clause_pole_out,
    output logic [`VAR_PER_CLAUSE-1:0][`MAX_VARS_BITS-1:0] variable_out, // Addresses
    output logic [`VAR_PER_CLAUSE-1:0] unassign_out,
    output logic [`VAR_PER_CLAUSE-1:0] val_out,
    output logic es_en // Eval enable and also Var State Table multiread

);

wire [`VAR_PER_CLAUSE-1:0] clause_mask;
wire [`VAR_PER_CLAUSE-1:0] clause_pole;
wire [`VAR_PER_CLAUSE-1:0][`MAX_VARS_BITS-1:0] variable; // Addresses
wire [`VAR_PER_CLAUSE-1:0] unassign;
wire [`VAR_PER_CLAUSE-1:0] val;
    
assign clause_mask = clause_info_in[`CLAUSE_DATA_BITS-1:`CLAUSE_DATA_BITS-5];
assign clause_pole = clause_info_in[`CLAUSE_DATA_BITS-6:`CLAUSE_DATA_BITS-10];
assign variable = clause_info_in[`CLAUSE_DATA_BITS-11:0];
assign unassign = unassign_in;
assign val = val_in;

assign idx_out = clause_info_in[`CLAUSE_DATA_BITS-11:0]; // To the Var State Table

always_ff @(posedge clock) begin
      if(reset) begin
         clause_mask_out <= 0;
         clause_pole_out <= 0;
         variable_out <= 0; // Addresses
         unassign_out <= 0;
         val_out <= 0;
      end
      else if(en) begin
         clause_mask_out <= clause_mask;
         clause_pole_out <= clause_pole;
         variable_out <= variable; // Addresses
         unassign_out <= unassign;
         val_out <= val;
      end
      es_en <= en;

end


endmodule