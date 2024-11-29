`include "sat_solver.sv"

// Sub Clause Evaluator
module sub_clause_evaluator # (
    parameter NUM_VARIABLE = 128,
    parameter VARIABLE_INDEX = $clog(NUM_VARIABLE) - 1,
    parameter VAR_PER_CLAUSE = 5,
    parameter VAR_PER_CLAUSE_INDEX = VAR_PER_CLAUSE - 1
    )(
    input           [VAR_PER_CLAUSE_INDEX:0] unassign,
    input           [VAR_PER_CLAUSE_INDEX:0] clause_mask,
    input           [VAR_PER_CLAUSE_INDEX:0][VARIABLE_INDEX:0] variable,
    input           [VAR_PER_CLAUSE_INDEX:0] clause_pole,
    input           [VAR_PER_CLAUSE_INDEX:0] assignment,
    output logic    new_assignment,
    output logic    [VARIABLE_INDEX:0] implied_variable,
    output logic    unit_clause
);
    // Intermediate values that feed into the AND
    logic partial_sat;
    logic candidate_unit;

    partial_sat_evaluator # (
        .VAR_PER_CLAUSE(VAR_PER_CLAUSE)
    )
    pse(
        .unassign(unassign),
        .clause_mask(clause_mask),
        .assignment(assignment),
        .clause_pole(clause_pole),
        .partial_sat(partial_sat)    
    );

    unit_clause_evaluator # (
        .VAR_PER_CLAUSE(VAR_PER_CLAUSE),
        .NUM_VARIABLE(NUM_VARIABLE)
    ) uce(
        .unassign(unassign),
        .clause_mask(clause_mask),
        .variable(variable),
        .clause_pole(clause_pole),
        .new_assignment(new_assignment),
        .implied_variable(implied_variable),
        .candidate_unit(candidate_unit)
    );

    assign unit_clause = ~partial_sat & candidate_unit;


    
endmodule