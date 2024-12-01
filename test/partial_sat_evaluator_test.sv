`include "sysdefs.svh"
// located in sub_clause_eval.sv

module partial_sat_evaluator_test;

    // clock
    logic clock;
    
    // Inputs
    logic           [`VAR_PER_CLAUSE-1:0] unassign;
    logic           [`VAR_PER_CLAUSE-1:0] clause_mask;
    logic           [`VAR_PER_CLAUSE-1:0] val;
    logic           [`VAR_PER_CLAUSE-1:0] clause_pole;
    
    // Outputs
    logic    partial_sat;

    partial_sat_evaluator DUT (
        .unassign(unassign),
        .clause_mask(clause_mask),
        .val(val),
        .clause_pole(clause_pole),
        .partial_sat(partial_sat)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10 ns clock period
    end

    // Test sequence
    initial begin  

        $monitor("INPUTS: unassign = %0b clause_mask = %0b val = %0b clause_pole = %0b \
                \nOUTPUTS: parital sat = %0b\n",
                unassign, clause_mask, val, clause_pole, partial_sat);

        #10;

        $display("\nReset Test- Expected 0");
        // Reset test
        unassign = 5'b11111;
        clause_mask = 0;
        val = 0;
        clause_pole = 0;

        #10;

        $display("\nTest 1 One is True Expected 1");
        unassign = 5'b01111;
        clause_mask = 5'b11100;
        val = 5'b00000;
        clause_pole = 5'b11100;

        #10;

        $display("\nTest 1.5 Two is True Expected 1");
        unassign = 5'b01000;
        clause_mask = 5'b11100;
        val = 5'b01000;
        clause_pole = 5'b10100;

        #10;

        $display("\nTest 2 Four are False Expected 0");
        unassign = 5'b00100;
        clause_mask = 5'b11111;
        val = 5'b00011;
        clause_pole = 5'b00111;

        #10;

        $display("\nTest 3 None assigned Expected 0");
        unassign = 5'b11111;
        clause_mask = 5'b11111;
        val = 5'b00000;
        clause_pole = 5'b11100;

        #10;

        $display("\nTest 4 Empty Clause Expected 0");
        unassign = 5'b00000;
        clause_mask = 5'b00000;
        val = $random;
        clause_pole = $random;

        #10;


        $finish;
    end
endmodule