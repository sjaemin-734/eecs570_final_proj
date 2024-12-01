`include "sysdefs.svh"

module clause_database_test;

    // Inputs
    logic clock;
    logic reset;
    logic push;
    logic read;
    logic        [`VAR_PER_CLAUSE-1:0] mask_in;
    logic        [`VAR_PER_CLAUSE-1:0] pole_in;
    logic        [`VAR_PER_CLAUSE-1:0][`MAX_VARS_BITS-1:0] var_in;
    logic        [`MAX_CLAUSES_BITS-1:0]  index_in;
    // Outputs
    logic [`VAR_PER_CLAUSE-1:0] mask_out;
    logic [`VAR_PER_CLAUSE-1:0] pole_out;
    logic [`VAR_PER_CLAUSE-1:0][`MAX_VARS_BITS-1:0] var_out;
    logic                         full;
    logic                         error;


    clause_database DUT (
        .clock(clock),
        .reset(reset),
        .push(push),
        .read(read),
        .mask_in(mask_in),
        .pole_in(pole_in),
        .var_in(var_in),
        .index_in(index_in),
        .mask_out(mask_out),
        .pole_out(pole_out),
        .var_out(var_out),
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

        $monitor("INPUTS: reset = %0d push = %0b read = %0b mask_in = %0b pole_in = %0b 
                \nvar1 = %0d var2 = %0d var3 = %0d var4 = %0d var5 = %0d \
                \nOUTPUTS: mask_out = %0b pole_out = %0b 
                \nvar1 = %0d var2 = %0d var3 = %0d var4 = %0d var5 = %0d 
                \nfull = %0b error = %0b\n",
                reset, push, read, mask_in, pole_in,
                var_in[0], var_in[1], var_in[2], var_in[3], var_in[4],
                index_in, 
                mask_out, pole_out,
                var_out[0], var_out[1], var_out[2], var_out[3], var_out[4],
                full, error);

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
            for(integer j = 0; j < `VAR_PER_CLAUSE; j = j + 1) begin
                mask_in[j] = $random;
                if mask_in[j] begin
                    pole_in[j] = $random;
                    var_in[j] = $random;
                end else begin
                    pole_in[j] = 0;
                    var_in[j] = 0;
                end
            end

            @(negedge clock);
        end

        mask_in = 0;
        pole_in = 0;
        for (integer i = 0; i < `VAR_PER_CLAUSE; i = i + 1) begin
            var_in[i] = 0;
        end

        $display("\nRead past 25: Expected error = 1");
        push = 0;
        read = 1;
        index_in = 30;

        @(negedge clock);

        $display("\nRead at 25 (edge case): Expected error = 1");
        push = 0;
        read = 1;
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