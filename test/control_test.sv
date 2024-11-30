module control_test;
    parameter NUM_VARIABLE = 128;
    parameter VARIABLE_INDEX = 7-1;

    // Inputs
    logic clock;
    logic reset;
    logic start;

    // Outputs
    logic sat;
    logic unsat;

    control #(
        .VARIABLE_INDEX(VARIABLE_INDEX),
        .NUM_VARIABLE(NUM_VARIABLE)
    ) DUT (
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

        $monitor("INPUTS: reset = %0b start = %0b \
                \nOUTPUTS: sat = %0b unsat %0b\n",
                reset, push, start, sat, unsat);

        $display("\nReset");
        // Reset test
        clock = 0;
        reset = 1;

        @(negedge clock);

        $display("\nStart Solver")
        reset = 0;
        start = 1;

        @negedge

        start = 0;

        @(negedge clock);

        // Wait until something happens???
        // TODO: Copy EECS 470 wait till something happens function to put here

        $finish;
    end
endmodule