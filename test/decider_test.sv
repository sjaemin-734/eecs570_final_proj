`include "sysdefs.svh"

module decider_test;

    config_var [`MAX_VARS-1:0] dec_config; // List of variable indices and their decision values
    logic read;
    logic write;
    logic [`MAX_VARS_BITS-1:0] back_dec_idx; // Used by the Control when backtracking
    logic clock;
    logic reset;

    logic [`MAX_VARS_BITS-1:0] dec_idx_out;
    logic [`MAX_VARS_BITS-1:0] var_idx_out;
    logic  val_out;


    decider DUT(
        .dec_config(dec_config), // List of variable indices and their decision values
        .read(read),
        .write(write),
        .back_dec_idx(back_dec_idx), // Used by the Control when backtracking
        .clock(clock),
        .reset(reset),

        .dec_idx_out(dec_idx_out),
        .var_idx_out(var_idx_out),
        .val_out(val_out)
    );

    // Testbench clock
    always begin
        #(`CLOCK_PERIOD/2.0);
        clock = ~clock;
    end

    // Fill in the config with values
    logic [`MAX_VARS_BITS-1:0] counter = 0;

    // Output
    always @(posedge clock) begin
            #1// if (!correct) begin

            $display("dec_idx_out: %d\n", dec_idx_out);

            $display("var_idx_out: %d\n", var_idx_out);
            $display("val_out: %d\n", val_out);

        // end
    end

    initial begin
        
        for (integer i=0; i < `MAX_VARS; i++) begin
            dec_config[i].var_idx = counter;
            dec_config[i].val = counter[0];
            counter = counter + 1'b1;
        end

        $display("Begin decider_test");
        reset = 1;
        clock = 0;
        read = 0;
        write = 0;
        back_dec_idx = 0;

        @(negedge clock);
        
        reset = 0;

        $display("0. Read the data, should be incrementing and the val should be if it's odd or not (in this case)");
        read = 1;

        @(negedge clock);

        @(negedge clock);

        @(negedge clock);

        @(negedge clock);


        $display("1. Read, but also try to change the back_dec_idx (but it should still just increment)");

        back_dec_idx = 1;

        @(negedge clock);

        back_dec_idx = 11;

        @(negedge clock);

        back_dec_idx = 20;

        @(negedge clock);

        back_dec_idx = 409;

        @(negedge clock);

        $display("2. Write back_dec_idx, then read, should change");

        read = 0;
        write = 1;

        back_dec_idx = 1;

        @(negedge clock);

        read = 1;
        write = 0;

        @(negedge clock);

        read = 0;
        write = 1;

        back_dec_idx = 11;

        @(negedge clock);

        read = 1;
        write = 0;

        @(negedge clock);

        read = 0;
        write = 1;

        back_dec_idx = 20;

        @(negedge clock);

        read = 1;
        write = 0;

        @(negedge clock);

        read = 0;
        write = 1;

        back_dec_idx = 409;

        @(negedge clock);

        read = 1;
        write = 0;

        @(negedge clock);

        $display("3. Let the clock run without read or write, nothing should change");

        read = 0;

        @(negedge clock);

        @(negedge clock);

        @(negedge clock);

        @(negedge clock);


        $display("4. reset, and read some more (should go back to 0, then increment)");

        reset = 1;

        @(negedge clock);

        reset = 0;
        read = 1;

        @(negedge clock);

        @(negedge clock);

        @(negedge clock);

        @(negedge clock);

        $display("Test ended");
        $finish;
    end

endmodule