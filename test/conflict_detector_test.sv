module conflict_detector_test;

    logic [8:0] var_idx_in; // Implied Variable
    logic val_in; // Implied value
    logic clock;
    logic reset;
    logic en;

    logic conflict;
    logic [8:0] var_idx_out;
    logic val_out;
    logic imply_stack_push_en;


    conflict_detector DUT(
        .var_idx_in(var_idx_in), // Implied Variable
        .val_in(val_in), // Implied value
        .clock(clock),
        .reset(reset),
        .en(en),

        .conflict(conflict),
        .var_idx_out(var_idx_out),
        .val_out(val_out),
        .imply_stack_push_en(imply_stack_push_en)
    );

    // Testbench clock
    always begin
        #(`CLOCK_PERIOD/2.0);
        clock = ~clock;
    end

    // // Check correctness
    // logic correct;
    // typedef struct packed {
    //     logic conflict;
    //     logic [8:0] var_idx_out;
    //     logic val_out;
    // } expected_result;

    // expected_result expected_result;

    // always_comb begin
    //     correct = 1;
    //     // Stay correct if not done yet
    //     if (
    //         expected_result.conflict != conflict ||
    //         expected_result.var_idx_out != var_idx_out ||
    //         expected_result.val_out != val_out
    //     ) begin
    //         correct = 0;
    //     end
    // end

    // Output
    always @(posedge clock) begin
            #1// if (!correct) begin
            // $display("@@@Failed at time %4.0f", $time);

            // $display("expected_result.conflict: %b", expected_result.conflict);
            $display("conflict: %b\n", conflict);
            // $display("expected_result.var_idx_out: %d", expected_result.var_idx_out);
            $display("var_idx_out: %d\n", var_idx_out);
            // $display("expected_result.val_out: %b", expected_result.val_out);
            $display("val_out: %b\n", val_out);

            $display("imply_stack_push_en: %b\n", imply_stack_push_en);

            // $display("@@@FAILED");
            // $finish;
        // end
    end

    initial begin
        $display("Begin conflict_detector_test");
        reset = 1;
        clock = 0;
        en = 1;

        @(negedge clock);
        
        reset = 0;

        @(negedge clock);

        $display("0. Imply val for variable, then imply something different for different variable (no conflict)");
        var_idx_in = 8'h01;
        val_in = 1'b0;

        @(negedge clock);

        var_idx_in = 8'h02;
        val_in = 1'b1;

        @(negedge clock);

        $display("1. Imply val for variable, then imply something different for same variable (conflict)");

        var_idx_in = 8'h01;
        val_in = 1'b1;

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