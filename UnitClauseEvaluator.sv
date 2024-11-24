module UnitClauseEvaluator (
    // Inputs
    input logic [4:0] clause_mask,     // Mask bits for valid variables in clause
    input logic [4:0] unassign,        // Unassigned variable flags
    input logic [4:0] clause_pole,     // Polarity bits for variables in clause
    
    // Outputs
    output logic [2:0] implied_variable, // Index of the implied variable
    output logic new_assignment,        // Value to assign to implied variable
    output logic unit_clause           // Indicates if clause is a unit clause
);

    // Internal signals
    logic [4:0] valid_unassigned;     // Variables that are both valid and unassigned
    logic [2:0] encoded_position;      // Position of the unassigned variable
    logic valid_unit;                  // If exactly one variable is valid and unassigned
    
    // Find which variables are both valid in the clause and unassigned
    assign valid_unassigned = clause_mask & unassign;
    
    // Count number of valid unassigned variables and encode position
    always_comb begin
        case (valid_unassigned)
            5'b00001: begin encoded_position = 3'd0; valid_unit = 1'b1; end
            5'b00010: begin encoded_position = 3'd1; valid_unit = 1'b1; end
            5'b00100: begin encoded_position = 3'd2; valid_unit = 1'b1; end
            5'b01000: begin encoded_position = 3'd3; valid_unit = 1'b1; end
            5'b10000: begin encoded_position = 3'd4; valid_unit = 1'b1; end
            default:  begin encoded_position = 3'd0; valid_unit = 1'b0; end
        endcase
    end

    // Output assignments
    assign implied_variable = encoded_position;
    assign new_assignment = ~clause_pole[encoded_position]; // Negate the polarity bit to get required assignment
    assign unit_clause = valid_unit;

endmodule