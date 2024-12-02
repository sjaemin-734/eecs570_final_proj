`include "sysdefs.svh"

module eval_prep_test;

    // For Eval Prep
    logic [`CLAUSE_DATA_BITS-1:0] clause_info_in; // From Control

    logic en;

    logic [`VAR_PER_CLAUSE - 1:0][`MAX_VARS_BITS - 1:0] idx_out; // To Var State Table

        // To Clause Evaluator
    logic [`VAR_PER_CLAUSE-1:0] clause_mask_out;
    logic [`VAR_PER_CLAUSE-1:0] clause_pole_out;
    logic [`VAR_PER_CLAUSE-1:0][`MAX_VARS_BITS-1:0] variable_out; // Addresses
    logic [`VAR_PER_CLAUSE-1:0] ce_unassign_out;
    logic [`VAR_PER_CLAUSE-1:0] ce_val_out;
    logic es_en; // Eval enable and also Var State Table multiread

    // For Var State Table
    logic read;
    logic write;
    logic val_in;
    logic unassign_in;
    logic [`MAX_VARS_BITS-1:0] var_in;

    logic val_out;
    logic unassign_out;
    logic [`VAR_PER_CLAUSE - 1:0]   multi_val_out; // For Eval Prep
    logic [`VAR_PER_CLAUSE - 1:0]   multi_unassign_out; // For Eval Prep

    //Both
    logic clock;
    logic reset;

    eval_prep ep (
        .clause_info_in(clause_info_in), // From Control
        .unassign_in(multi_unassign_out), // From Var State Table
        .val_in(multi_val_out), // From Var State Table

        .clock(clock),
        .reset(reset),
        .en(en),

        .idx_out(idx_out), // To Var State Table

        // To Clause Evaluator
        .clause_mask_out(clause_mask_out),
        .clause_pole_out(clause_pole_out),
        .variable_out(variable_out), // Addresses
        .unassign_out(ce_unassign_out),
        .val_out(ce_val_out),
        .es_en(es_en)

    );

    var_state vs (
        .clock(clock),
        .reset(reset),
        .read(read),
        .multi_read(es_en),
        .write(write),
        .val_in(val_in),
        .unassign_in(unassign_in),
        .multi_var_in(idx_out),
        .var_in(var_in),

        .val_out(val_out),
        .unassign_out(unassign_out),
        .multi_val_out(multi_val_out),
        .multi_unassign_out(multi_unassign_out)
    );

     // Testbench clock
    always begin
        #(`CLOCK_PERIOD/2.0);
        clock = ~clock;
    end

    // Output
    always @(posedge clock) begin
            #1// if (!correct) begin
            $display("-----Eval Prep Outputs-----");
            $display("idx_out: %d\n", idx_out);
            $display("clause_mask_out: %b\n", clause_mask_out);
            $display("clause_pole_out: %b\n", clause_pole_out);
            $display("variable_out: %d\n", variable_out);
            $display("ce_unassign_out: %b\n", ce_unassign_out);
            $display("ce_val_out: %b\n", ce_val_out);
            
            $display("es_en: %d\n", es_en);

            $display("-----Var State Table Outputs-----");
            $display("val_out: %b\n", val_out);
            $display("unassign_out: %b\n", unassign_out);
            $display("multi_val_out: %b\n", multi_val_out);
            $display("multi_unassign_out: %b\n", multi_unassign_out);
    end

    initial begin
        $display("Begin eval_prep_test");
        reset = 1;
        clock = 0;

        @(negedge clock);
        
        reset = 0;

        @(negedge clock);

        $display("0. Write some values to var state table");
        write = 1;
        var_in = 1;
        val_in = 1;
        unassign_in = 0;

        @(negedge clock);
        var_in = 2;
        val_in = 1;
        unassign_in = 0;

        @(negedge clock);
        var_in = 3;
        val_in = 0;
        unassign_in = 0;

        @(negedge clock);
        var_in = 4;
        val_in = 1;
        unassign_in = 0;

        @(negedge clock);
        var_in = 5;
        val_in = 0;
        unassign_in = 0;

        @(negedge clock);
        var_in = 6;
        val_in = 0;
        unassign_in = 0;

        @(negedge clock);
        var_in = 7;
        val_in = 1;
        unassign_in = 0;

        @(negedge clock);
        var_in = 8;
        val_in = 1;
        unassign_in = 0;

        @(negedge clock);
        var_in = 9;
        val_in = 0;
        unassign_in = 0;

        @(negedge clock);

        $display("1. Supply the Eval Prep with clause variables of address 1, 2, 3, 4, 5 (multi_val_out: 11010, multi_unassign_out: 00000)");

        en = 1;
        clause_info_in = 55'b11111_00000_000000001_000000010_000000011_000000100_000000101;

        @(negedge clock);

        $display("2. Supply the Eval Prep with clause variables of address 2, 4, 6, 8, 10 (multi_val_out: 11010, multi_unassign_out: 00001)");

        clause_info_in = 55'b11111_00000_000000010_000000100_000000110_000001000_000001100;

        @(negedge clock);

        $display("3. Supply the Eval Prep with clause variables of address 5, 3, 1, 9, 7 (multi_val_out: 00101, multi_unassign_out: 00000)");

        clause_info_in = 55'b11111_00000_000000101_000000011_000000001_000001001_000000111;

        @(negedge clock);

        $display("4. Supply the Eval Prep with clause variables of address 11, 30, 21, 10, 87 (multi_val_out: 00000, multi_unassign_out: 11111)");

        clause_info_in = 55'b11111_00000_000001011_000011110_000010101_000001010_001010111;

        @(negedge clock);

        $display("5. Reset, and supply the Eval Prep with clause variables of address 1, 2, 3, 4, 5 (multi_val_out: 00000, multi_unassign_out: 11111)");
        reset = 1;
        
        @(negedge clock);

        reset = 0;
        clause_info_in = 55'b11111_00000_000000001_000000010_000000011_000000100_000000101;

        @(negedge clock);

        $display("Test ended");
        $finish;
    end

endmodule