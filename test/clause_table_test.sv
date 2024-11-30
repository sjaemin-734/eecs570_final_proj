`include "sysdefs.svh"

module clause_table_test;

    // Inputs
    logic clock;
    logic reset;
    logic push;
    logic read;
    logic       [`CLAUSE_TABLE_BITS-1:0] index_in;
    logic        [`MAX_CLAUSES_BITS-1:0]  clause_in;
    // Outputs
    logic  [`MAX_CLAUSES_BITS-1:0]  clause_index_out;
    logic                          full;
    logic                         error;


    clause_table DUT (
        .clock(clock),
        .reset(reset),
        .push(push),
        .read(read),
        .index_in(index_in),
        .clause_in(clause_in),
        .clause_index_out(clause_index_out),
        .full(full),
        .error(error)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10 ns clock period
    end

    // Test sequence
    initial begin  

        $monitor("INPUTS: reset = %0d push = %0b read = %0b index_in = %0d clause_in = %0d \
                \nOUTPUTS: clause_index_out = %0d full = %0b error = %0b\n",
                reset, push, read, index_in, clause_in, clause_index_out, full, error);

        $display("\nReset Test");
        // Reset test
        clock = 0;
        reset = 1;
        read = 0;
        push = 0;

        @(negedge clock);

        reset = 0;
        @(negedge clock);

        $display("\nRandom Read: Expected error = 1");
        // Empty pop
        read = 1;
        index_in = $random;

        @(negedge clock);

        $display("\nPush random items in table");
        for(integer i = 0; i < 25; i = i + 1) begin
            read = 0;
            push = 1;
            clause_in = $random;

            @(negedge clock);
        end

        $display("\nRead past 25: Expected error = 1");
        push = 0;
        read = 1;
        clause_in = 0;
        index_in = 30;

        @(negedge clock);

        $display("\nRead at 25 (edge case): Expected error = 1");
        push = 0;
        read = 1;
        clause_in = 0;
        index_in = 25;

        @(negedge clock);

        $display("\nRead within: Check previously for last item");
        read = 1;
        index_in = 24;

        @(negedge clock);

        read = 1;
        index_in = 23;

        @(negedge clock);




        $finish;
    end
endmodule