
// Unit Clause valuator
module unit_clause_evaluator(
    input           [4:0] unassign,
    input           [4:0] clause_mask,
    input           [4:0][8:0] variable,
    input           [4:0] clause_pole,
    output logic    new_assignment,
    output logic    [8:0] implied_variable,
    output logic    is_unit_clause
);
    // Intermediate values that feed into the encoder
    // gate in the partial_sat module
    logic [4:0] encoder_inputs;
    logic [2:0] mux_input;

    // Since we're dealing with indiviual bits here, bitwise (&) and logical (&&)
    // operators should be interchangable. For consistency, stick to bitwise.

    // TODO: check if these should be nonblocking <= or assign statments
    for(int i = 0; i < 5; i = i + 1) begin
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
    assign is_unit_clause = mux_input && 3'b111 ? 0 : 1

    // Select the variable to be assigned
    assign implied_variable = is_unit_clause ? variable[mux_input]
    assign new_assignment = is_unit_clause ? 0 : clause_pole[mux_input]
endmodule