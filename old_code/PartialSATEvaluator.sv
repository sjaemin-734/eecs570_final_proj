module PartialSATEvaluator (
    // Inputs
    input logic [4:0] clause_mask,    // Mask bits for valid variables in clause
    input logic [4:0] unassign,       // Unassigned variable flags
    input logic [4:0] assignment,     // Current assignment values
    input logic [4:0] clause_pole,    // Polarity bits for variables in clause
    
    // Output
    output logic partial_sat          // Indicates if clause is partially satisfied
);

    // Intermediate signals
    wire [4:0] valid_vars;      // Variables that are valid in this clause
    wire [4:0] assigned_vars;   // Variables that have been assigned
    wire [4:0] satisfied_vals;  // Values that satisfy the clause (considering polarity)
    wire [4:0] eval_result;     // Final evaluation per variable position
    
    // Find which variables are valid for this clause
    assign valid_vars = clause_mask;
    
    // Find which variables have assignments
    assign assigned_vars = ~unassign;
    
    // Check which assignments satisfy the clause (considering polarity)
    assign satisfied_vals = assignment ^ clause_pole;
    
    // Combine all conditions - variable must be:
    // 1. Valid in clause (valid_vars)
    // 2. Have an assignment (assigned_vars)
    // 3. Assignment satisfies clause (satisfied_vals)
    assign eval_result = valid_vars & assigned_vars & satisfied_vals;
    
    // Clause is partially satisfied if any variable satisfies all conditions
    assign partial_sat = |eval_result;

endmodule