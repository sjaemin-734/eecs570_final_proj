`include "sysdefs.svh"

module decider_stack_test;

    logic                                clock,
    logic                                reset,
    logic                                push,
    logic                                pop,
    logic        [`MAX_VARS_BITS-1:0]  dec_idx_in, // Index for the Decider
    logic [`MAX_VARS_BITS-1:0]  dec_idx_out,           
    logic                         empty,
    // logic                         full


    decider_stack DUT(
        .clock(clock),
        .reset(reset),
        .push(push),
        .pop(pop),
        .dec_idx_in(dec_idx_in),

        .dec_idx_out(dec_idx_out),
        .empty(empty)
    );

    // Testbench clock
    always begin
        #(`CLOCK_PERIOD/2.0);
        clock = ~clock;
    end

    // Output
    always @(posedge clock) begin
            #1// if (!correct) begin

            $display("dec_idx_out: %b\n", conflict);

            $display("empty: %d\n", empty);

        // end
    end

    initial begin
        $display("Begin decider_stack_test");
        reset = 1;
        clock = 0;
        push = 0;
        pop = 0;

        @(negedge clock);
        
        reset = 0;
        $display("0. Push a bunch of data in without setting the push bit high (Should be empty)");
        dec_idx = 1;

        @(negedge clock);

        dec_idx = 2;

        @(negedge clock);

        dec_idx = 5;

        @(negedge clock);

        dec_idx = 7;

        @(negedge clock);

        $display("1. Push data in with the push bit set high (not empty and dec_index_out is 0)");

        dec_idx = 1;
        push = 1;

        @(negedge clock);

        dec_idx = 2;

        @(negedge clock);

        dec_idx = 5;

        @(negedge clock);

        dec_idx = 7;

        @(negedge clock);

        $display("2. Imply val for variable, then imply something different for different variable (no conflict)");

        var_idx_in = 8'h03;
        val_in = 1'b1;

        @(negedge clock);

        $display("3. Imply val for variable, then imply something different for same variable (conflict)");

        var_idx_in = 8'h01;
        val_in = 1'b1;

        @(negedge clock);

        $display("4. Run reset and then imply the conflict triggering case (no conflict)");

        reset = 1;

        @(negedge clock);

        reset = 0;
        var_idx_in = 8'h01;
        val_in = 1'b1;

        @(negedge clock);

        $display("5. Set enable to 0 (no conflict, and no enable)");

        en = 0;

        @(negedge clock);

        $display("6. With enable at 0, try to trigger a conflict (no conflict, and no enable)");

        var_idx_in = 8'h01;
        val_in = 1'b1;

        @(negedge clock);

        $display("7.  Reset, Set enable to 1, send a variable and value, then set enable to 0 and try to trigger a conflict (no conflict, and no enable)");

        reset = 1;
        en = 1;

        @(negedge clock);

        reset = 0;
        var_idx_in = 8'h01;
        val_in = 1'b1;

        @(negedge clock);

        en = 0;
        var_idx_in = 8'h01;
        val_in = 1'b1;

        @(negedge clock);


        $display("Test ended");
        $finish;
    end

endmodule