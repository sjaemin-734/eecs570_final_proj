`include "sysdefs.svh"

module top_test;

    // Inputs
    logic clock;
    logic reset;
    logic start;

    // Outputs
    logic sat;
    logic unsat;

    top DUT (
        .clock(clock),
        .reset(reset),
        .start(start),
        .sat(sat),
        .unsat(unsat)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10 ns clock period
    end

    // Test sequence
    initial begin  

        $monitor("INPUTS: reset = %0d, start = %0b \
                \nOUTPUTS: sat = %0b, unsat = %0b\n",
                reset, start, sat, unsat);

        $display("\nReset Test");
        // Reset test
        clock = 0;
        reset = 1;

        @(negedge clock);

        reset = 0;
        start = 1;

        for(integer i = 0; i < 99; i = i + 1) begin
            @(negedge clock);
        end






        $finish;
    end
endmodule