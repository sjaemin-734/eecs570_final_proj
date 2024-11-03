`include "sat_solver.sv"

// Sub Clause Evaluator
module sub_clause_evaluator(
    input           [4:0] unassign,
    input           [4:0] clause_mask,
    input           [4:0][8:0] variable,
    input           [4:0] clause_pole,
    input           [4:0] assignment,
    output logic    new_assignment,
    output logic    [8:0] implied_variable,
    output logic    unit_clause
);
    // Intermediate values that feed into the AND
    logic partial_sat;
    logic candidate_unit;

    partial_sat_evaluator(
        unassign [4:0],
        clause_mask [4:0],
        assignment [4:0],
        clause_pole [4:0],
        partial_sat    
    );

    unit_clause_evaluator(
        unassign [4:0],
        clause_mask [4:0],
        variable [4:0][8:0],
        clause_pole [4:0],
        new_assignment,
        implied_variable [8:0],
        candidate_unit
    );

    assign unit_clause = ~partial_sat & candidate_unit;


    
endmodule