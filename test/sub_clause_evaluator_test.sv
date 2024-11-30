// located in sub_clause_eval.sv

module sub_clause_eval_test;

    parameter VAR_PER_CLAUSE = 5;
    parameter VAR_PER_CLAUSE_INDEX = VAR_PER_CLAUSE - 1;
    parameter NUM_VARIABLE = 128;
    parameter VARIABLE_INDEX = 7 - 1;
    parameter VARIABLE_INDEX = 6;

    // clock
    logic           clock;

    // Inputs
    logic           [VAR_PER_CLAUSE_INDEX:0] unassign;
    logic           [VAR_PER_CLAUSE_INDEX:0] clause_mask;
    logic           [VAR_PER_CLAUSE_INDEX:0] clause_pole;
    logic           [VAR_PER_CLAUSE_INDEX:0] val;
    logic           [VAR_PER_CLAUSE_INDEX:0][VARIABLE_INDEX:0] variable;

    // Outputs
    logic           new_val;
    logic           [VAR_PER_CLAUSE_INDEX:0] implied_variable;
    logic           unit_clause;

    unit_clause_eval #(
        .VAR_PER_CLAUSE(VAR_PER_CLAUSE),
        .NUM_VARIABLE(NUM_VARIABLE)
    ) DUT (
        .unassign(unassign),
        .clause_mask(clause_mask),
        .clause_pole(clause_pole),
        .val(val)
        .variable(variable),
        .new_val(new_val),
        .implied_variable(implied_variable),
        .unit_clause(unit_clause)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10 ns clock period
    end

    // Test sequence
    initial begin  

        $monitor("INPUTS: unassign = %0b clause_mask = %0b clause_pole = %0b val = %0b var1 = %0d var2 = %0d var3 = %0d var4 = %0d var5 = %0d\
                \nOUTPUTS: new_val = %0b implied_variable = %0d unit_clause = %0b\n",
                unassign, clause_mask, clause_pole, variable[0], variable[1], variable[2], variable[3], variable[4], new_val, implied_variable, unit_clause);

        $display("\nReset Test");
        // Reset test
        clock = 0;
        unassign = 5'b11111;
        clause_mask = 5'b00000;
        clause_pole = 5'b00000;
        val = 5'b00000;
        for(integer i = 0; i < VAR_PER_CLAUSE; i = i + 1) begin
            variable[i] = 0;
        end

        #10;

        // Only 1 assigned
        $display("\n Test 1  Expected new_val = 1 implied_variable = var5 unit_clause = 1");
        unassign = 5'b10000;
        clause_mask = 5'b11111;
        clause_pole = 5'b00000;
        val = 5'b00000; 
        for(integer i = 0; i < VAR_PER_CLAUSE; i = i + 1) begin
            variable[i] = $random;
        end

        #10;
        
        $display("\n Test 2  Expected new_val = 0 implied_variable = var5 unit_clause = 1");
        unassign = 5'b10000;
        clause_mask = 5'b11111;
        clause_pole = 5'b10000;
        val = 5'b00000; 
        for(integer i = 0; i < VAR_PER_CLAUSE; i = i + 1) begin
            variable[i] = $random;
        end

        #10;

        // Only 1 assigned
        $display("\n Test 1  Expected new_val = 1 implied_variable = var3 unit_clause = 1");
        unassign = 5'b00100;
        clause_mask = 5'b11110;
        clause_pole = 5'b00000;
        val = 5'b00000;
        for(integer i = 0; i < VAR_PER_CLAUSE; i = i + 1) begin
            variable[i] = $random;
        end

        #10;

        // Partial SAT but only 1 unassigned
        $display("\n Test 3  Expected unit_clause = 0");
        unassign = 5'b00001;
        clause_mask = 5'b11111;
        clause_pole = 5'b00000;
        val = 5'b11110;
        for(integer i = 0; i < VAR_PER_CLAUSE; i = i + 1) begin
            variable[i] = $random;
        end

        #10;

        $display("\n Test 3.5  Expected unit_clause = 0");
        unassign = 5'b00001;
        clause_mask = 5'b11111;
        clause_pole = 5'b00000;
        val = 5'b00010;
        for(integer i = 0; i < VAR_PER_CLAUSE; i = i + 1) begin
            variable[i] = $random;
        end

        #10;

        // None are assigned
        $display("\n Test 4  Expected unit_clause = 0");
        unassign = 5'b11111;
        clause_mask = 5'b11111;
        clause_pole = 5'b00000;
        val = 5'b00000;
        for(integer i = 0; i < VAR_PER_CLAUSE; i = i + 1) begin
            variable[i] = $random;
        end

        #10;

        $finish;
    end
endmodule