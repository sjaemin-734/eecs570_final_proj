`include "sysdefs.svh"

module var_start_end_test;

    // Inputs
    logic clock;
    logic reset;
    logic read;
    logic write;
    logic start_in;
    logic end_in;
    logic [`MAX_VARS_BITS-1:0] var_in;

    // Outputs
    logic start_out;
    logic end_out;

    var_start_end DUT (
        .clock(clock),
        .reset(reset),
        .read(read),
        .write(write),
        .start_in(start_in),
        .end_in(end_in),
        .var_in(var_in),
        .start_out(start_out),
        .end_out(end_out)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10 ns clock period
    end

    // Test sequence
    initial begin  

        $monitor("INPUTS: reset = %0d read = %0b write %0b start_in = %0b end_in %0b var_in = %0d \
                \nOUTPUTS: start_out = %0b end_out = %0b\n",
                reset, read, write, start_in, end_in, var_in, start_out, end_out);

        $display("\nReset Test");
        // Reset test
        clock = 0;
        reset = 1;
        read = 0;
        write = 0;

        @(negedge clock);

        reset = 0;
        @(negedge clock);

        $display("\nRandom Read: Expected start_out = 0 end_out = 0");
        // Empty pop
        read = 1;
        var_in = $random;

        @(negedge clock);
        $display("\nWrite then read: 12, 19");

        read = 0;
        write = 1;
        var_in = 18;
        start_in = 12;
        end_in = 19;

        @(negedge clock);

        write = 0;
        read = 1;
        var_in = 18;

        @(negedge clock);

        $display("\nWrite then read 2: 12, 19 / 2, 5");

        read = 0;
        write = 1;
        var_in = 11;
        start_in = 2;
        end_in = 5;

        @(negedge clock);

        write = 0;
        read = 1;
        var_in = 18;

        @(negedge clock);

        var_in = 11;

        @(negedge clock);


        $finish;
    end
endmodule