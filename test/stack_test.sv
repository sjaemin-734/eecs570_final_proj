`include "sysdefs.svh"

module stack_test;

    // Inputs
    logic clock;
    logic reset;
    logic push;
    logic pop;
    logic type_in;
    logic val_in;
    logic [`MAX_VARS_BITS-1:0] var_in;

    // Outputs
    logic [`MAX_VARS_BITS-1:0] var_out;
    logic type_out;
    logic val_out;
    logic empty;
    logic full;

    stack DUT (
        .clock(clock),
        .reset(reset),
        .push(push),
        .pop(pop),
        .type_in(type_in),
        .val_in(val_in),
        .var_in(var_in),
        .var_out(var_out),
        .type_out(type_out),
        .val_out(val_out),
        .empty(empty),
        .full(full)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10 ns clock period
    end

    // Test sequence
    initial begin  

        $monitor("INPUTS: reset = %0d, push = %0d, pop = %0d, type_in = %0d, val_in = %0d, var_in = %0d \
                \nOUTPUTS: type_out = %0d, val_out = %0d, var_out = %0d, empty = %0d, full = %0d\n",
                reset, push, pop, type_in, val_in, var_in, type_out, val_out, var_out, empty, full);

        $display("\nReset Test");
        // Reset test
        clock = 0;
        reset = 1;
        push = 0;
        pop = 0;
        var_in = 0;
        val_in = 0;
        type_in = 0;

        @(negedge clock);

        $display("\nEmpty Pop");
        // Empty pop
        reset = 0;
        pop = 1;

        @(negedge clock);

        $display("\nPush");
        // Push and Pop
        pop = 0;
        push = 1;
        val_in = 1; // true
        var_in = 69;
        type_in = 1; // Forced

        @(negedge clock);

        $display("\nPop");
        pop = 1;
        push = 0;

        @(negedge clock);

        $display("\nPush 1");
        // Push-Push Pop-Pop
        pop = 0;
        push = 1;
        val_in = 0; // true
        var_in = 12;
        type_in = 0; // Decide

        @(negedge clock);

        $display("\nPush 2");
        val_in = 1; // true
        var_in = 13;
        type_in = 1; // Forced

        @(negedge clock);

        $display("\nPop 1");
        push = 0;
        pop = 1;

        @(negedge clock);

        $display("\nPop 2");
        @(negedge clock);

        $display("\nPush3");
        push = 1;
        pop = 0;
        val_in = 1; // true
        var_in = 14;
        type_in = 1; // Forced
        @(negedge clock);

        $display("\nPush4");
        val_in = 0; // true
        var_in = 15;
        type_in = 0; // Forced
        @(negedge clock);

        $display("\nPush5");
        val_in = 0; // true
        var_in = 16;
        type_in = 1; // Forced
        @(negedge clock);

        $display("\nPush6");
        val_in = 1; // true
        var_in = 17;
        type_in = 0; // Forced
        @(negedge clock);

        $display("\nPop3");
        push = 0;
        pop = 1;
        @(negedge clock);

        $display("\nPop4");
        @(negedge clock);

        $display("\nPop5");
        @(negedge clock);

        $display("\nPop6");
        @(negedge clock);


        $finish;
    end
endmodule