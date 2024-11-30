`include "sysdefs.svh"

module stack_test;

    // Inputs
    logic clock;
    logic reset;
    logic read;
    logic write;
    logic val_in;
    logic unassign_in;
    logic [`MAX_VARS_BITS-1:0] var_in;

    // Outputs
    logic val_out;
    logic unassign_out;

    var_state DUT (
        .clock(clock),
        .reset(reset),
        .read(read),
        .write(write),
        .val_in(val_in),
        .unassign_in(unassign_in),
        .var_in(var_in),
        .val_out(val_out),
        .unassign_out(unassign_out)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10 ns clock period
    end

    // Test sequence
    initial begin  

        $monitor("INPUTS: reset = %0d read = %0b write %0b val_in = %0b unassign_in %0b var_in = %0d \
                \nOUTPUTS: val_out = %0b unassign_out = %0b\n",
                reset, read, write, val_in, unassign_in, var_in, val_out, unassign_out);

        $display("\nReset Test");
        // Reset test
        clock = 0;
        reset = 1;
        read = 0;
        write = 0;

        @(negedge clock);

        reset = 0;
        @(negedge clock);

        $display("\nRandom Read: Expected val_out = 0 unassign_out = 1");
        // Empty pop
        read = 1;
        var_in = $random;

        @(negedge clock);
        $display("\nWrite then read: Expected val_out = 1 unassign_out = 0");

        read = 0;
        write = 1;
        var_in = 18;
        val_in = 1;
        unassign_in = 0;

        @(negedge clock);

        write = 0;
        read = 1;
        var_in = 18;

        @(negedge clock);

        $display("\nWrite then read 2: Expected val_out = 1 unassign_out = 0");

        read = 0;
        write = 1;
        var_in = 18;
        val_in = 1;
        unassign_in = 0;

        @(negedge clock);

        write = 0;
        read = 1;
        var_in = 10;

        @(negedge clock);

        var_in = 18;

        @(negedge clock);

        $display("\nTwo Writes then read: Expected val_out = 0 unassign_out = 0");

        read = 0;
        write = 1;
        var_in = 18;
        val_in = 0;
        unassign_in = 0;

        @(negedge clock);

        var_in = 23;
        val_in = 1;
        unassign_in = 0;

        @(negedge clock);
        
        write = 0;
        read = 1;
        var_in = 18;

        @(negedge clock);



        $finish;
    end
endmodule