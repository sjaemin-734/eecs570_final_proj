`include "sysdefs.svh"
// located in sub_clause_eval.sv

module unit_clause_evaluator_test;
    // clock
    logic           clock;

    // Inputs
    logic           [`VAR_PER_CLAUSE-1:0] unassign;
    logic           [`VAR_PER_CLAUSE-1:0] clause_mask;
    logic           [`VAR_PER_CLAUSE-1:0] clause_pole;
    logic           [`VAR_PER_CLAUSE-1:0][`MAX_VARS_BITS-1:0] variable;

    // Outputs
    logic           new_val;
    logic           [`MAX_VARS_BITS-1:0] implied_variable;
    logic           is_unit_clause;

    unit_clause_evaluator DUT (
        .unassign(unassign),
        .clause_mask(clause_mask),
        .clause_pole(clause_pole),
        .variable(variable),
        .new_val(new_val),
        .implied_variable(implied_variable),
        .is_unit_clause(is_unit_clause)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10 ns clock period
    end

    // Test sequence
    initial begin  

        $monitor("INPUTS: unassign = %0b clause_mask = %0b clause_pole = %0b var1 = %0d var2 = %0d var3 = %0d var4 = %0d var5 = %0d\
                \nOUTPUTS: new_val = %0b implied_variable = %0d is_unit_clause = %0b\n",
                unassign, clause_mask, clause_pole, variable[0], variable[1], variable[2], variable[3], variable[4], new_val, implied_variable, is_unit_clause);

        $display("\nReset Test");
        // Reset test
        clock = 0;
        unassign = 5'b00000;
        clause_mask = 5'b00000;
        clause_pole = 5'b00000;
        for(integer i = 0; i < `VAR_PER_CLAUSE; i = i + 1) begin
            variable[i] = 0;
        end

        #10;

        // Only 1 assigned
        $display("\n Test 1  Expected new_val = 1 implied_variable = var5 is_unit_clause = 1");
        unassign = 5'b10000;
        clause_mask = 5'b11111;
        clause_pole = 5'b00000;
        for(integer i = 0; i < `VAR_PER_CLAUSE; i = i + 1) begin
            variable[i] = $random;
        end

        #10;
        
        $display("\n Test 2  Expected new_val = 0 implied_variable = var5 is_unit_clause = 1");
        unassign = 5'b10000;
        clause_mask = 5'b11111;
        clause_pole = 5'b11111;
        for(integer i = 0; i < `VAR_PER_CLAUSE; i = i + 1) begin
            variable[i] = $random;
        end

        #10;

        // Only 1 assigned
        $display("\n Test 1  Expected new_val = 1 implied_variable = var3 is_unit_clause = 1");
        unassign = 5'b00100;
        clause_mask = 5'b11110;
        clause_pole = 5'b00000;
        for(integer i = 0; i < `VAR_PER_CLAUSE; i = i + 1) begin
            variable[i] = $random;
        end

        #10;

        // More than 1 unassigned
        $display("\n Test 3  Expected is_unit_clause = 0");
        unassign = 5'b10001;
        clause_mask = 5'b11111;
        clause_pole = 5'b00000;
        for(integer i = 0; i < `VAR_PER_CLAUSE; i = i + 1) begin
            variable[i] = $random;
        end

        #10;

        $display("\n Test 4  Expected is_unit_clause = 0");
        unassign = 5'b11111;
        clause_mask = 5'b11111;
        clause_pole = 5'b00000;
        for(integer i = 0; i < `VAR_PER_CLAUSE; i = i + 1) begin
            variable[i] = $random;
        end

        #10;

        $finish;
    end
endmodule