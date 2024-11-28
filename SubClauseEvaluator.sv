module SubClauseEvaluator (
    // Inputs
    input logic [4:0] clause_mask,     // Mask bits for valid variables in clause
    input logic [4:0] unassign,        // Unassigned variable flags
    input logic [4:0] assignment,      // Current assignment values
    input logic [4:0] clause_pole,     // Polarity bits for variables in clause
    input logic [8:0] var1,            // 9-bit index of first variable
    input logic [8:0] var2,            // 9-bit index of second variable
    input logic [8:0] var3,            // 9-bit index of third variable
    input logic [8:0] var4,            // 9-bit index of fourth variable
    input logic [8:0] var5,            // 9-bit index of fifth variable
    
    // Outputs
    output logic unit_clause,          // Indicates if clause is a unit clause
    output logic [8:0] implied_variable, // 9-bit index of variable to be implied
    output logic new_assignment        // Value to assign to implied variable
);

    // Internal signals
    logic partial_sat;
    logic [8:0] var_indices [4:0];    // Array to hold the 9-bit variable indices
    logic unit_clause_pre;
    logic [2:0] encoded_position;      // Position (0-4) of unit variable
    logic new_assignment_pre;
    
    // Store variable indices in array for easier indexing
    always_comb begin
        var_indices[0] = var1;
        var_indices[1] = var2;
        var_indices[2] = var3;
        var_indices[3] = var4;
        var_indices[4] = var5;
    end

    // Instantiate Partial SAT Evaluator
    PartialSATEvaluator partial_sat_eval (
        .clause_mask(clause_mask),
        .unassign(unassign),
        .assignment(assignment),
        .clause_pole(clause_pole),
        .partial_sat(partial_sat)
    );
    
    // Instantiate Unit Clause Evaluator
    UnitClauseEvaluator unit_clause_eval (
        .clause_mask(clause_mask),
        .unassign(unassign),
        .clause_pole(clause_pole),
        .unit_clause(unit_clause_pre),
        .implied_variable(encoded_position),
        .new_assignment(new_assignment_pre)
    );
    
    // Map position to actual variable index when unit clause is found
    always_comb begin
        if (unit_clause_pre && !partial_sat) begin
            implied_variable = var_indices[encoded_position];
        end else begin
            implied_variable = 9'b0;
        end
    end

    // If clause is partially satisfied, it cannot be a unit clause
    assign unit_clause = unit_clause_pre & ~partial_sat;
    assign new_assignment = new_assignment_pre & ~partial_sat;

endmodule
