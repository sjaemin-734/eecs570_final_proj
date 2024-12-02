`include "sysdefs.svh"

module control_test;

    logic clock;
    logic reset;
    logic start;
    // BCP CORE
    logic bcp_busy;
    logic conflict;
    logic [`MAX_CLAUSES_BITS-1:0] bcp_clause_idx;
    logic reset_bcp;

    // IMPLY
    logic empty_imply;
    logic [`MAX_VARS_BITS-1:0] var_out_imply;
    logic val_out_imply;
    logic type_out_imply;
    logic pop_imply;
    // TRACE
    logic empty_trace;
    logic [`MAX_VARS_BITS-1:0] var_out_trace;
    logic val_out_trace;
    logic type_out_trace;
    logic pop_trace;
    logic push_trace;
    logic [`MAX_VARS_BITS-1:0] var_in_trace;
    logic val_in_trace;
    logic type_in_trace;
    // VAR STATE
    logic write_vs;
    logic [`MAX_VARS_BITS-1:0] var_in_vs;
    logic val_in_vs;
    logic unassign_in_vs;
    // VAR START END TABLE
    logic [`MAX_CLAUSES_BITS-1:0] start_clause;
    logic [`MAX_CLAUSES_BITS-1:0] end_clause;
    logic read_var_start_end;
    logic [`MAX_VARS_BITS-1:0] var_in_vse;

    // SAT Results
    logic sat;                     // Have separate UNSAT/SAT variable just in case
    logic unsat;

    control DUT (
        .clock(clock),
        .reset(reset),
        .start(start),

        .bcp_busy(bcp_busy),
        .conflict(conflict),
        .bcp_clause_idx(bcp_clause_idx),
        .reset_bcp(reset_bcp),

        .empty_imply(empty_imply),
        .var_out_imply(var_out_imply),
        .val_out_imply(val_out_imply),
        .type_out_imply(type_out_imply),
        .pop_imply(pop_imply),

        .empty_trace(empty_trace),
        .var_out_trace(var_out_trace),
        .val_out_trace(val_out_trace),
        .type_out_trace(type_out_trace),
        .pop_trace(pop_trace),
        .push_trace(push_trace),
        .var_in_trace(var_in_trace),
        .val_in_trace(val_in_trace),
        .type_in_trace(type_in_trace),

        .write_vs(write_vs),
        .var_in_vs(var_in_vs),
        .val_in_vs(val_in_vs),
        .unassign_in_vs(unassign_in_vs),

        .start_clause(start_clause),
        .end_clause(end_clause),
        .read_var_start_end(read_var_start_end),
        .var_in_vse(var_in_vse),

        .sat(sat),
        .unsat(unsat)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10 ns clock period
    end

    // Test sequence
    initial begin  

        $monitor("INITIALIZE: reset = %0b start = %0b \
                \nBCP_CORE: bcp_busy = %0b conflict = %0b bcp_clause_idx = %0d reset_bcp = %0d \
                \nIMPLY: empty = %0b var_out = %0d val_out = %0b type_out = %0b pop = %0b \
                \nTRACE: empty = %0b var_out = %0d val_out = %0b type_out = %0b pop = %0b push = %0b var_in = %0d val_in = %0b type_in = %0b \
                \nVAR STATE: write = %0b var_in = %0d val_in = %0b unassign_in = %0b \
                \nVAR START END TABLE: start = %0d end = %0d read = %0b var_in = %0d \
                \nRESULTS: sat = %0b unsat %0b\n",
                reset, start, 
                bcp_busy, conflict, bcp_clause_idx, reset_bcp,
                empty_imply, var_out_imply, val_out_imply, type_out_imply, pop_imply,
                empty_trace, var_out_trace, val_out_trace, type_out_trace, pop_trace, push_trace, var_in_trace,val_in_trace,type_in_trace,
                write_vs, var_in_vs, val_in_vs, unassign_in_vs,
                start_clause, end_clause, read_var_start_end, var_in_vse,
                sat, unsat);

        $display("\nReset");
        // Reset test
        clock = 0;
        reset = 1;

        @(negedge clock);

        $display("\nStart Solver at BCP WAIT");

        reset = 0;
        conflict = 0;
        bcp_busy = 1;

        @(negedge clock);

        bcp_busy = 0;

        @(negedge clock);
        $display("\nAttempt to pop imply");

        @(negedge clock);
        reset = 1;
        @(negedge clock);


        reset = 0;
        empty_trace = 1;
        conflict = 1;
        bcp_busy = 1;

        @(negedge clock);

        bcp_busy = 0;

        for (integer i = 0; i < 4; i = i + 1) begin
            @(negedge clock);
        end
        $display("\nShould see UNSAT above here and attemp to pop trace");

        reset = 1;
        @(negedge clock);
        reset = 0;
        bcp_busy = 1;
        conflict = 1;

        empty_trace = 0;
        type_out_trace = 1;

        for(integer i = 0; i < 5; i = i + 1) begin
            var_out_trace = $random;
            @(negedge clock);
        end
        $display("\nShould unassign variables above");
        type_out_trace = 0;
        val_out_trace = 1;
        var_out_trace = 23;

        @(negedge clock);
        $display("\nShould assign variable opposite val and be forced");
        @(negedge clock);
        $display("\nShould send var to var start end");
        @(negedge clock);
        start_clause = 0;
        end_clause = 10;
        bcp_busy = 1;

        for (integer i = 0; i < 13; i = i + 1) begin
            @(negedge clock);
        end

        bcp_busy = 0;
        conflict = 1;
        empty_trace = 1;

        for (integer i = 0; i < 4; i = i + 1) begin
            @(negedge clock);
        end
        $display("\nShould see unsat again");

        


        // Wait until something happens???
        // TODO: Copy EECS 470 wait till something happens function to put here

        $finish;
    end
endmodule