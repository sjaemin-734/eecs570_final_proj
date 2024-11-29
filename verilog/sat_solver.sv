// 5 variables per clause, 1023 clauses

// Partial SAT Evaluator
module partial_sat_evaluator # (
    parameter VAR_PER_CLAUSE = 5
    )(
    input           [(VAR_PER_CLAUSE - 1):0] unassign,
    input           [(VAR_PER_CLAUSE - 1):0] clause_mask,
    input           [(VAR_PER_CLAUSE - 1):0] assignment,
    input           [(VAR_PER_CLAUSE - 1):0] clause_pole,
    output logic    partial_sat    
);
    // Intermediate values that feed into the OR
    // gate in the partial_sat module
    logic [(VAR_PER_CLAUSE - 1):0] or_inputs;

    // Since we're dealing with indiviual bits here, bitwise (&) and logical (&&)
    // operators should be interchangable. For consistency, stick to bitwise.

    // TODO: check if these should be nonblocking <= or assign statments
    for(int i = 0; i < VAR_PER_CLAUSE; i = i + 1) begin
        assign or_inputs[i] = (~unassign[i] & clause_mask[i]) & ~(assignment[i] & clause_pole[i])
    end

    // or_inputs is a packed array so this will OR all of the values in it
    assign partial_sat = |or_inputs;

endmodule

// Unit Clause valuator
module unit_clause_evaluator # (
    parameter VAR_PER_CLAUSE = 5,
    parameter NUM_VARIABLE = 128,
    parameter VARIABLE_INDEX = $clog(NUM_VARIABLE)

    )(
    input           [(VAR_PER_CLAUSE - 1):0] unassign,
    input           [(VAR_PER_CLAUSE - 1):0] clause_mask,
    input           [(VAR_PER_CLAUSE - 1):0][(VARIABLE_INDEX-1):0] variable,
    input           [(VAR_PER_CLAUSE - 1):0] clause_pole,
    output logic    new_assignment,
    output logic    [(VARIABLE_INDEX-1):0] implied_variable,
    output logic    is_unit_clause
);
    // Intermediate values that feed into the encoder
    logic [(VAR_PER_CLAUSE-1):0] encoder_inputs;
    logic [2:0] mux_input;

    // Since we're dealing with indiviual bits here, bitwise (&) and logical (&&)
    // operators should be interchangable. For consistency, stick to bitwise.

    // TODO: check if these should be nonblocking <= or assign statments
    for(int i = 0; i < VAR_PER_CLAUSE; i = i + 1) begin
        assign encoder_inputs[i] = unassign[i] & clause_mask[i]
    end


    // Check if only ONE variable has been unassigned
    always_comb begin
        case (encoder_inputs[4:0]) begin
            5'b00001 : mux_input = 3'b000
            5'b00010 : mux_input = 3'b001
            5'b00100 : mux_input = 3'b010
            5'b01000: mux_input = 3'b011
            5'b10000 : mux_input = 3'b100
            default : mux_input = 3'b111        // Don't select any variable and its assignment
        endcase
    end
    
    // Output if unit clause
    assign is_unit_clause = mux_input && 3'b111 ? 0 : 1;

    // Select the variable to be assigned
    assign implied_variable = is_unit_clause ? 0 : variable[mux_input];
    assign new_assignment = is_unit_clause ? 0 : clause_pole[mux_input];
endmodule