`include "sysdefs.svh"

module decider_stack_test;

    logic   clock;
    logic   reset;
    logic   push;
    logic   pop;
    logic   [`MAX_VARS_BITS-1:0]  dec_idx_in; // Index for the Decider
    logic   [`MAX_VARS_BITS-1:0]  dec_idx_out;           
    logic   empty;
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

            $display("dec_idx_out: %d\n", dec_idx_out);

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
        dec_idx_in = 1;

        @(negedge clock);

        dec_idx_in = 2;

        @(negedge clock);

        dec_idx_in = 5;

        @(negedge clock);

        dec_idx_in = 7;

        @(negedge clock);

        $display("1. Push data in with the push bit set high (not empty and dec_index_out is 0)");

        dec_idx_in = 1;
        push = 1;

        @(negedge clock);

        dec_idx_in = 2;

        @(negedge clock);

        dec_idx_in = 5;

        @(negedge clock);

        dec_idx_in = 7;

        @(negedge clock);

        $display("2. pop data (7, 5, 2, 1), should be empty after last pop");

        push = 0;
        pop = 1;

        @(negedge clock);

        @(negedge clock);

        @(negedge clock);

        @(negedge clock);

        $display("3. pop when empty (should be empty and dec_inx_out is 0)");

        @(negedge clock);


        $display("4. push data and then reset");

        push = 1;
        pop = 0;
        dec_idx_in = 11;

        @(negedge clock);

        dec_idx_in = 32;

        @(negedge clock);

        dec_idx_in = 45;

        @(negedge clock);

        push = 0;
        reset = 1;

        @(negedge clock);

        $display("5. pop, (Should be empty)");

        reset = 0;
        pop = 1;

        @(negedge clock);

        $display("6. Push new values, then pop, the ones before the reset should be gone");

        pop = 0;
        push = 1;
        dec_idx_in = 100;

        @(negedge clock);

        dec_idx_in = 101;

        @(negedge clock);

        dec_idx_in = 102;

        @(negedge clock);

        push = 0;
        pop = 1;

        @(negedge clock);

        @(negedge clock);

        @(negedge clock);

        @(negedge clock);

        $display("Test ended");
        $finish;
    end

endmodule