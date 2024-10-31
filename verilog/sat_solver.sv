// 5 variables per clause, 1023 clauses

// Partial SAT Evaluator
module partial_sat_evaluator(
    input           [4:0] unassign,
    input           [4:0] clause_mask,
    input           [4:0] assignment,
    input           [4:0] clause_pole,
    output logic    partial_sat    
);
    // Intermediate values that feed into the OR
    // gate in the partial_sat module
    logic [4:0] or_inputs;

    // Since we're dealing with indiviual bits here, bitwise (&) and logical (&&)
    // operators should be interchangable. For consistency, stick to bitwise.

    // TODO: check if these should be nonblocking <= or assign statments
    for(int i = 0; i < 5; i = i + 1) begin
        assign or_inputs[i] = (~unassign[i] & clause_mask[i]) & ~(assignment[i] & clause_pole[i])
    end

    // or_inputs is a packed array so this will OR all of the values in it
    assign partial_sat = |or_inputs;

endmodule

module unit_clause_evaluator(

);
endmodule