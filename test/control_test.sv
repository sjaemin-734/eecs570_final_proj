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
    logic bcp_en;

    // IMPLY
    logic empty_imply;
    logic full_imply;
    logic [`MAX_VARS_BITS-1:0] var_out_imply;
    logic val_out_imply;
    logic type_out_imply;
    logic pop_imply;
    // IMPLY ADDITIONAL (Not for control)
    logic push_imply;
    logic [`MAX_VARS_BITS-1:0] var_in_imply;
    logic val_in_imply;
    // TRACE
    logic reset_trace;
    logic empty_trace;
    logic full_trace;
    logic [`MAX_VARS_BITS-1:0] var_out_trace;
    logic val_out_trace;
    logic type_out_trace;
    logic pop_trace;
    // Connected to test
    logic [`MAX_VARS_BITS-1:0] var_in_trace_test;
    logic val_in_trace_test;
    logic type_in_trace_test;
    logic push_trace_test;
    // Connected to control
    logic [`MAX_VARS_BITS-1:0] var_in_trace_c;
    logic val_in_trace_c;
    logic type_in_trace_c;
    logic push_trace_c;

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
    logic [`CLAUSE_TABLE_BITS-1:0] start_clause;
    logic [`CLAUSE_TABLE_BITS-1:0] end_clause;
    logic read_var_start_end;
    logic [`MAX_VARS_BITS-1:0] var_in_vse;

    // DECIDER MEMORY MODULE
    logic [`MAX_VARS_BITS-1:0] var_idx_d;
    logic val_d;
    logic read_d; // Control is asking for next value
    logic [`MAX_VARS_BITS-1:0] dec_idx_d_in; // Used by the Control to access memory module
    
    // DECIDER STACK
    logic [`MAX_VARS_BITS-1:0] dec_idx_ds_out;
    logic empty_ds;
    logic push_ds;
    logic pop_ds;
    logic [`MAX_VARS_BITS-1:0] dec_idx_ds_in;

    // SAT Results
    logic sat;                     // Have separate UNSAT/SAT variable just in case
    logic unsat;

    //State debug
    logic [3:0] state_out;

    control DUT (
        .clock(clock),
        .reset(reset),
        .start(start),

        .bcp_busy(bcp_busy),
        .conflict(conflict),
        .bcp_clause_idx(bcp_clause_idx),
        .reset_bcp(reset_bcp),
        .bcp_en(bcp_en),

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
        .push_trace(push_trace_c),
        .var_in_trace(var_in_trace_c),
        .val_in_trace(val_in_trace_c),
        .type_in_trace(type_in_trace_c),

        .write_vs(write_vs),
        .var_in_vs(var_in_vs),
        .val_in_vs(val_in_vs),
        .unassign_in_vs(unassign_in_vs),

        .start_clause(start_clause),
        .end_clause(end_clause),
        .read_var_start_end(read_var_start_end),
        .var_in_vse(var_in_vse),

        .var_idx_d(var_idx_d),
        .val_d(val_d),
        .read_d(read_d),
        .dec_idx_d_in(dec_idx_d_in),

        .dec_idx_ds_out(dec_idx_ds_out),
        .empty_ds(empty_ds),
        .push_ds(push_ds),
        .pop_ds(pop_ds),
        .dec_idx_ds_in(dec_idx_ds_in),

        .sat(sat),
        .unsat(unsat),
        .state_out(state_out)
    );

    stack imply_stack (
        .clock(clock),
        .reset(reset_bcp),
        .push(push_imply),
        .pop(pop_imply),
        .type_in(1'b1),
        .val_in(val_in_imply),
        .var_in(var_in_imply),
        .type_out(type_out_imply),
        .val_out(val_out_imply),
        .var_out(var_out_imply),
        .empty(empty_imply),
        .full(full_imply)
    );

    stack trace_stack (
        .clock(clock),
        .reset(reset_trace),
        .push(push_trace),
        .pop(pop_trace),
        .type_in(type_in_trace),
        .val_in(val_in_trace),
        .var_in(var_in_trace),
        .type_out(type_out_trace),
        .val_out(val_out_trace),
        .var_out(var_out_trace),
        .empty(empty_trace),
        .full(full_trace)
    );

    decider_stack ds(
    .clock(clock),
    .reset(reset),
    .push(push_ds),
    .pop(pop_ds),
    .dec_idx_in(dec_idx_ds_in), // Index for the Decider
    .dec_idx_out(dec_idx_ds_out),           
    .empty(empty_ds)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10 ns clock period
    end

    task PUSH_TO_IMPLY;
        input [`MAX_VARS_BITS-1:0] var_in;
        input val_in;
        begin
            push_imply = 1'b1;
            var_in_imply = var_in;
            val_in_imply = val_in;
            @(negedge clock);
            push_imply = 1'b0;
            var_in_imply = 0;
            val_in_imply = 0;
            @(negedge clock);
        end
    endtask

    task PUSH_TO_TRACE;
        input [`MAX_VARS_BITS-1:0] var_in;
        input val_in;
        input type_in;
        begin
            push_trace_test = 1'b1;
            var_in_trace_test = var_in;
            val_in_trace_test = val_in;
            type_in_trace_test = type_in;
            @(negedge clock);
            push_trace_test = 1'b0;
            var_in_trace_test = 0;
            val_in_trace_test = 0;
            type_in_trace_test = 0;
            @(negedge clock);

        end
    endtask

    always @(posedge clock) begin
        $display("INITIALIZE: reset = %0b start = %0b state = %0d \
                \nBCP_CORE: bcp_busy = %0b conflict = %0b bcp_clause_idx = %0d reset_bcp = %0d bcp_en = %0b \
                \nIMPLY: empty = %0b var_out = %0d val_out = %0b type_out = %0b pop = %0b \
                \nTRACE: empty = %0b var_out = %0d val_out = %0b type_out = %0b pop = %0b push = %0b var_in = %0d val_in = %0b type_in = %0b \
                \nVAR STATE: write = %0b var_in = %0d val_in = %0b unassign_in = %0b \
                \nVAR START END TABLE: start = %0d end = %0d read = %0b var_in = %0d \
                \nRESULTS: sat = %0b unsat %0b\n",
                reset, start, state_out,
                bcp_busy, conflict, bcp_clause_idx, reset_bcp, bcp_en,
                empty_imply, var_out_imply, val_out_imply, type_out_imply, pop_imply,
                empty_trace, var_out_trace, val_out_trace, type_out_trace, pop_trace, push_trace, var_in_trace,val_in_trace,type_in_trace,
                write_vs, var_in_vs, val_in_vs, unassign_in_vs,
                start_clause, end_clause, read_var_start_end, var_in_vse,
                sat, unsat);
    end


    always_comb begin
        if (reset) begin
            reset_trace = reset;
        end else begin
            reset_trace = 0;
        end
        push_trace = push_trace_c | push_trace_test;
        val_in_trace = push_trace_test ? val_in_trace_test : val_in_trace_c;
        var_in_trace = push_trace_test ? var_in_trace_test : var_in_trace_c;
        type_in_trace = push_trace_test ? type_in_trace_test : type_in_trace_c;
    end

    // Test sequence
    initial begin  

        // $monitor("INITIALIZE: reset = %0b start = %0b \
        //         \nBCP_CORE: bcp_busy = %0b conflict = %0b bcp_clause_idx = %0d reset_bcp = %0d \
        //         \nIMPLY: empty = %0b var_out = %0d val_out = %0b type_out = %0b pop = %0b \
        //         \nTRACE: empty = %0b var_out = %0d val_out = %0b type_out = %0b pop = %0b push = %0b var_in = %0d val_in = %0b type_in = %0b \
        //         \nVAR STATE: write = %0b var_in = %0d val_in = %0b unassign_in = %0b \
        //         \nVAR START END TABLE: start = %0d end = %0d read = %0b var_in = %0d \
        //         \nRESULTS: sat = %0b unsat %0b\n",
        //         reset, start, 
        //         bcp_busy, conflict, bcp_clause_idx, reset_bcp,
        //         empty_imply, var_out_imply, val_out_imply, type_out_imply, pop_imply,
        //         empty_trace, var_out_trace, val_out_trace, type_out_trace, pop_trace, push_trace, var_in_trace,val_in_trace,type_in_trace,
        //         write_vs, var_in_vs, val_in_vs, unassign_in_vs,
        //         start_clause, end_clause, read_var_start_end, var_in_vse,
        //         sat, unsat);

        $display("\nReset");
        // Reset test
        clock = 0;
        reset = 1;
        start_clause = 0;
        end_clause = 0;

        @(negedge clock);

        $display("\nStart Solver at BCP WAIT");

        reset = 0;
        conflict = 0;
        bcp_busy = 1;

        @(negedge clock);

        bcp_busy = 0;

        @(negedge clock);

        @(negedge clock);
        $display("\nAttempt to pop imply");

        @(negedge clock);
        reset = 1;
        @(negedge clock);


        reset = 0;
        conflict = 1;
        bcp_busy = 1;

        @(negedge clock);

        bcp_busy = 0;

        for (integer i = 0; i < 4; i = i + 1) begin
            @(negedge clock);
        end
        $display("\nShould see UNSAT above here and attemp to pop trace");

        reset = 1;
        bcp_busy = 1;
        @(negedge clock);
        reset = 0;
        conflict = 0;
        for (integer i = 0; i < 3; i = i + 1) begin
            PUSH_TO_TRACE($random, $random, 1);
        end
        PUSH_TO_TRACE($random, $random, 0);
        @(negedge clock);
        conflict = 1;
        bcp_busy = 0;

        @(negedge clock);
        for (integer i = 0; i < 3; i = i + 1) begin
            @(negedge clock);
        end

        $display("\nShould unassign variables above");

        @(negedge clock);
        $display("\nShould assign variable opposite val and be forced");
        @(negedge clock);
        start_clause = 0;
        end_clause = 10;
        $display("\nShould send var to var start end");
        @(negedge clock);
        bcp_busy = 1;

        for (integer i = 0; i < 13; i = i + 1) begin
            @(negedge clock);
        end

        bcp_busy = 0;
        conflict = 1;

        for (integer i = 0; i < 4; i = i + 1) begin
            @(negedge clock);
        end
        $display("\nShould see unsat again");

        


        // Wait until something happens???
        // TODO: Copy EECS 470 wait till something happens function to put here

        $finish;
    end
endmodule