`include "sysdefs.svh"

module control_test;

    logic clock;
    logic reset;
    logic start;
    logic [`MAX_VARS_BITS-1:0] max_var_test;
    // BCP CORE
    logic bcp_busy;
    logic conflict;
    logic [`MAX_CLAUSES_BITS-1:0] bcp_clause_idx;
    logic reset_bcp;
    logic bcp_en;
    // for testing
    logic bcp_busy_test;

    // IMPLY
    logic reset_imply;
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

    // For conflict detector
    logic push_imply_cd;
    logic [`MAX_VARS_BITS-1:0] var_in_imply_cd;
    logic val_in_imply_cd;
    // For testing
    logic push_imply_test;
    logic [`MAX_VARS_BITS-1:0] var_in_imply_test;
    logic val_in_imply_test;
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
    // Self
    logic read_vs;
    logic val_out_vs;
    logic unassign_out_vs;
    // not included in control
    logic [`VAR_PER_CLAUSE - 1:0][`MAX_VARS_BITS - 1:0] multi_var_in_vs;
    logic [`VAR_PER_CLAUSE - 1:0] multi_val_out_vs; // For Eval Prep
    logic [`VAR_PER_CLAUSE - 1:0] multi_unassign_out_vs; // For Eval Prep
    // Extra for testing
    // For control
    logic read_vs_c;
    logic [`MAX_VARS_BITS-1:0] var_in_vs_c;
    // For test
    logic read_vs_test;
    logic [`MAX_VARS_BITS-1:0] var_in_vs_test;

    // VAR START END TABLE
    logic [`CLAUSE_TABLE_BITS-1:0] start_clause;
    logic [`CLAUSE_TABLE_BITS-1:0] end_clause;
    logic read_var_start_end;
    logic [`MAX_VARS_BITS-1:0] var_in_vse;

    // EVAL PREP
    logic [`CLAUSE_DATA_BITS-1:0] clause_info_in;

    // CLAUSE EVAL
    // inputs
    logic [`VAR_PER_CLAUSE-1:0] clause_mask_in_ce;
    logic [`VAR_PER_CLAUSE-1:0] clause_pole_in_ce;
    logic [`VAR_PER_CLAUSE-1:0][`MAX_VARS_BITS-1:0] variable_in_ce; // Addresses
    logic [`VAR_PER_CLAUSE-1:0] unassign_in_ce;
    logic [`VAR_PER_CLAUSE-1:0] val_in_ce;
    // outputs
    logic new_val;
    logic [`MAX_VARS_BITS-1:0] implied_variable;
    logic unit_clause;

    // CONFLICT DETECTOR


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

    // RAMs
    logic reset_ram;
    logic [`MAX_VARS-1:0][`MAX_VARS_BITS-1:0] decide_config;
    logic [`MAX_VARS-1:0][`CLAUSE_TABLE_BITS*2-1:0] var_start_end_table;
    logic [`CLAUSE_TABLE_SIZE-1:0][`MAX_CLAUSES_BITS-1:0] clause_table;
    logic [`MAX_CLAUSES-1:0][`CLAUSE_DATA_BITS-1:0] clause_database;

    // BCP Pipeline extra vars to connect
    logic [`MAX_CLAUSES_BITS-1:0] bcp_clause_id;

    control DUT (
        .clock(clock),
        .reset(reset),
        .start(start),
        .max_var_test(max_var_test),

        .bcp_busy(bcp_en || ce_en || unit_clause || push_imply),            // TODO
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
        .var_in_vs(var_in_vs_c),
        .val_in_vs(val_in_vs),
        .unassign_in_vs(unassign_in_vs),
        .read_vs(read_vs_c),
        .val_out_vs(val_out_vs),
        .unassign_out_vs(unassign_out_vs),

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

    var_state vs (
        .clock(clock),
        .reset(reset),
        .read(read_vs),
        .multi_read(bcp_en),
        .write(write_vs),
        .val_in(val_in_vs),
        .unassign_in(unassign_in_vs),
        .multi_var_in(multi_var_in_vs),
        .var_in(var_in_vs),

        .val_out(val_out_vs),
        .unassign_out(unassign_out_vs),
        .multi_val_out(multi_val_out_vs),
        .multi_unassign_out(multi_unassign_out_vs)
    );

    eval_prep ep (
        .clause_info_in(clause_info_in),
        .unassign_in(multi_unassign_out_vs), // From Var State Table
        .val_in(multi_val_out_vs), // From Var State Table

        .clock(clock),
        .reset(reset_bcp),
        .en(bcp_en),

        .idx_out(multi_var_in_vs), // To Var State Table

        // To Clause Evaluator
        .clause_mask_out(clause_mask_in_ce),
        .clause_pole_out(clause_pole_in_ce),
        .variable_out(variable_in_ce), // Addresses
        .unassign_out(unassign_in_ce),
        .val_out(val_in_ce),
        .es_en(ce_en)
    );

    sub_clause_evaluator ce (
        .en(ce_en),
        .unassign(unassign_in_ce),
        .clause_mask(clause_mask_in_ce),
        .clause_pole(clause_pole_in_ce),
        .val(val_in_ce),
        .variable(variable_in_ce),
        .new_val(new_val),
        .implied_variable(implied_variable),
        .unit_clause(unit_clause)
    );

    conflict_detector cd (
        .var_idx_in(implied_variable), // Implied Variable
        .val_in(new_val), // Implied value
        .clock(clock),
        .reset(reset_bcp),
        .en(unit_clause),

        .conflict(conflict),
        .var_idx_out(var_in_imply_cd), // for stack
        .val_out(val_in_imply_cd),
        .imply_stack_push_en(push_imply_cd)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10 ns clock period
    end

    task RESET_RAMS;
        begin
            for (integer i = 0; i < `MAX_VARS; i = i + 1) begin
                decide_config[i] = i+1;
                var_start_end_table[i] = 0;
            end
            for (integer i = 0; i < `MAX_CLAUSES; i = i + 1) begin
                clause_database[i] = 0;
            end
            for (integer i = 0; i < `CLAUSE_TABLE_SIZE; i = i + 1) begin
                clause_table[i] = 0;
            end
        end
    endtask

    task SET_CLAUSE_DATABASE;
        input [`MAX_CLAUSES_BITS-1:0] clause_id;
        input [`CLAUSE_DATA_BITS-1:0] file_input_line;
        begin
            clause_database[clause_id] = file_input_line;
            @(negedge clock);
        end
    endtask

    task SET_CLAUSE_TABLE;
        input [`CLAUSE_TABLE_BITS-1:0] table_idx;
        input [`MAX_CLAUSES_BITS-1:0] file_input_line;
        begin
            clause_table[table_idx] = file_input_line;
            @(negedge clock);
        end
    endtask

    task SET_VAR_START_END_TABLE;
        input [`MAX_VARS_BITS-1:0] var_id;
        input [`CLAUSE_TABLE_BITS*2-1:0] file_input_line;
        begin
            var_start_end_table[var_id] = file_input_line;
            @(negedge clock);
        end
    endtask

    task INITIALIZE_CLAUSE_DATABASE;
        input [`MAX_CLAUSES-1:0] clause_id;
        input [`VAR_PER_CLAUSE-1:0] mask;
        input [`VAR_PER_CLAUSE-1:0] pole;
        input [`MAX_VARS_BITS-1:0] var1;
        input [`MAX_VARS_BITS-1:0] var2;
        input [`MAX_VARS_BITS-1:0] var3;
        input [`MAX_VARS_BITS-1:0] var4;
        input [`MAX_VARS_BITS-1:0] var5;
        begin
            clause_database[clause_id] = {mask, pole, var1, var2, var3, var4, var5};
            @(negedge clock);
        end
    endtask

    task INITIALIZE_CLAUSE_TABLE;
        input [`CLAUSE_TABLE_BITS-1:0] table_idx;
        input [`MAX_CLAUSES_BITS-1:0] clause_id;
        begin
            clause_table[table_idx] = clause_id;
            @(negedge clock);
        end
    endtask

    task INITIALIZE_VAR_START_END;
        input [`MAX_VARS_BITS-1:0] var_id;
        input [`CLAUSE_TABLE_BITS*2-1:`CLAUSE_TABLE_BITS] start_clause_id;
        input [`CLAUSE_TABLE_BITS-1:0] end_clause_id;
        begin
            var_start_end_table[var_id] = {start_clause_id, end_clause_id};
            @(negedge clock);
        end
    endtask

    task INITIALIZE_DECIDE_CONFIG;
        input [`MAX_VARS_BITS-1:0] config_index;
        input [`MAX_VARS_BITS-1:0] var_id;
        begin
            decide_config[config_index] = var_id;
            @(negedge clock);
        end
    endtask

    task PUSH_TO_IMPLY;
        input [`MAX_VARS_BITS-1:0] var_in;
        input val_in;
        begin
            push_imply_test = 1'b1;
            var_in_imply_test = var_in;
            val_in_imply_test = val_in;
            @(negedge clock);
            push_imply_test = 1'b0;
            var_in_imply_test = 0;
            val_in_imply_test = 0;
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

    task SHOW_DEBUG;
        begin
            $display("INITIALIZE: reset = %0b start = %0b state = %0d \
                \nDECIDE: dec_idx_d_in = %0d var_idx_d = %0d val_d = %0b \
                \nBCP_CORE: bcp_busy = %0b conflict = %0b bcp_clause_idx = %0d bcp_clause_id = %0d reset_bcp = %0d bcp_en = %0b \
                \nDEBUG: bcp_en = %0b ce_en = %0b unit_clause = %0b push_imply = %0b bcp_busy_test = %0b \
                \nCLAUSE_BCP_INFO: id = %0d mask = %0b pole = %0b var1 = %0d var2 = %0d var3 = %0d var4 = %0d var5 = %0d \
                \nCLAUSE_EVAL_INPUTS: unassign = %0b clause_mask = %0b clause_pole = %0b val = %0b var1 = %0d var2 = %0d var3 = %0d var4 = %0d var5 = %0d \
                \nCLAUSE_EVAL: ce_en = %0b unit_clause = %0b implied_var = %0d new_val = %0b \
                \nIMPLY: empty = %0b var_out = %0d val_out = %0b type_out = %0b pop = %0b push = %0b var_in = %0d val_in = %0b \
                \nTRACE: empty = %0b var_out = %0d val_out = %0b type_out = %0b pop = %0b push = %0b var_in = %0d val_in = %0b type_in = %0b \
                \nVAR STATE: write = %0b var_in = %0d val_in = %0b unassign_in = %0b read_vs = %0b val_out_vs = %0b unassign_out_vs = %0b \
                \nVAR START END TABLE: start = %0d end = %0d read = %0b var_in = %0d \
                \nRESULTS: sat = %0b unsat %0b\n",
                reset, start, state_out,
                dec_idx_d_in, var_idx_d, val_d,
                bcp_busy, conflict, bcp_clause_idx, bcp_clause_id, reset_bcp, bcp_en,
                bcp_en, ce_en, unit_clause, push_imply, bcp_busy_test,
                bcp_clause_id, clause_info_in[`CLAUSE_DATA_BITS-1:`CLAUSE_DATA_BITS-5], clause_info_in[`CLAUSE_DATA_BITS-6:`CLAUSE_DATA_BITS-10], clause_info_in[`MAX_VARS_BITS*5-1:`MAX_VARS_BITS*4], clause_info_in[`MAX_VARS_BITS*4-1:`MAX_VARS_BITS*3], clause_info_in[`MAX_VARS_BITS*3-1:`MAX_VARS_BITS*2], clause_info_in[`MAX_VARS_BITS*2-1:`MAX_VARS_BITS], clause_info_in[`MAX_VARS_BITS-1:0], 
                unassign_in_ce, clause_mask_in_ce, clause_pole_in_ce, val_in_ce, variable_in_ce[4], variable_in_ce[3], variable_in_ce[2], variable_in_ce[1], variable_in_ce[0],
                ce_en, unit_clause, implied_variable, new_val,
                empty_imply, var_out_imply, val_out_imply, type_out_imply, pop_imply, push_imply, var_in_imply, val_in_imply,
                empty_trace, var_out_trace, val_out_trace, type_out_trace, pop_trace, push_trace, var_in_trace, val_in_trace, type_in_trace,
                write_vs, var_in_vs, val_in_vs, unassign_in_vs, read_vs, val_out_vs, unassign_out_vs,
                start_clause, end_clause, read_var_start_end, var_in_vse,
                sat, unsat);
        end
    endtask

    // always @(posedge clock) begin
    //     $display("INITIALIZE: reset = %0b start = %0b state = %0d \
    //             \nDECIDE: dec_idx_d_in = %0d var_idx_d = %0d val_d = %0b \
    //             \nBCP_CORE: bcp_busy = %0b conflict = %0b bcp_clause_idx = %0d bcp_clause_id = %0d reset_bcp = %0d bcp_en = %0b \
    //             \nDEBUG: bcp_en = %0b ce_en = %0b unit_clause = %0b push_imply = %0b bcp_busy_test = %0b \
    //             \nCLAUSE_BCP_INFO: id = %0d mask = %0b pole = %0b var1 = %0d var2 = %0d var3 = %0d var4 = %0d var5 = %0d \
    //             \nCLAUSE_EVAL_INPUTS: unassign = %0b clause_mask = %0b clause_pole = %0b val = %0b var1 = %0d var2 = %0d var3 = %0d var4 = %0d var5 = %0d \
    //             \nCLAUSE_EVAL: ce_en = %0b unit_clause = %0b implied_var = %0d new_val = %0b \
    //             \nIMPLY: empty = %0b var_out = %0d val_out = %0b type_out = %0b pop = %0b push = %0b var_in = %0d val_in = %0b \
    //             \nTRACE: empty = %0b var_out = %0d val_out = %0b type_out = %0b pop = %0b push = %0b var_in = %0d val_in = %0b type_in = %0b \
    //             \nVAR STATE: write = %0b var_in = %0d val_in = %0b unassign_in = %0b read_vs = %0b val_out_vs = %0b unassign_out_vs = %0b \
    //             \nVAR START END TABLE: start = %0d end = %0d read = %0b var_in = %0d \
    //             \nRESULTS: sat = %0b unsat %0b\n",
    //             reset, start, state_out,
    //             dec_idx_d_in, var_idx_d, val_d,
    //             bcp_busy, conflict, bcp_clause_idx, bcp_clause_id, reset_bcp, bcp_en,
    //             bcp_en, ce_en, unit_clause, push_imply, bcp_busy_test,
    //             bcp_clause_id, clause_info_in[`CLAUSE_DATA_BITS-1:`CLAUSE_DATA_BITS-5], clause_info_in[`CLAUSE_DATA_BITS-6:`CLAUSE_DATA_BITS-10], clause_info_in[`MAX_VARS_BITS*5-1:`MAX_VARS_BITS*4], clause_info_in[`MAX_VARS_BITS*4-1:`MAX_VARS_BITS*3], clause_info_in[`MAX_VARS_BITS*3-1:`MAX_VARS_BITS*2], clause_info_in[`MAX_VARS_BITS*2-1:`MAX_VARS_BITS], clause_info_in[`MAX_VARS_BITS-1:0], 
    //             unassign_in_ce, clause_mask_in_ce, clause_pole_in_ce, val_in_ce, variable_in_ce[4], variable_in_ce[3], variable_in_ce[2], variable_in_ce[1], variable_in_ce[0],
    //             ce_en, unit_clause, implied_variable, new_val,
    //             empty_imply, var_out_imply, val_out_imply, type_out_imply, pop_imply, push_imply, var_in_imply, val_in_imply,
    //             empty_trace, var_out_trace, val_out_trace, type_out_trace, pop_trace, push_trace, var_in_trace, val_in_trace, type_in_trace,
    //             write_vs, var_in_vs, val_in_vs, unassign_in_vs, read_vs, val_out_vs, unassign_out_vs,
    //             start_clause, end_clause, read_var_start_end, var_in_vse,
    //             sat, unsat);
    // end


    always_comb begin

        if (reset) begin
            reset_trace = reset;
        end else begin
            reset_trace = 0;
        end
        start_clause = var_start_end_table[var_in_vse][`CLAUSE_TABLE_BITS*2 - 1:`CLAUSE_TABLE_BITS];
        end_clause = var_start_end_table[var_in_vse][`CLAUSE_TABLE_BITS-1:0];

        bcp_clause_id = clause_table[bcp_clause_idx];

        clause_info_in = clause_database[bcp_clause_id];

        var_idx_d = dec_idx_d_in+1;
        val_d = 1'b0;

        bcp_busy = bcp_en || ce_en || unit_clause || push_imply || bcp_busy_test;

        push_trace = push_trace_c || push_trace_test;
        val_in_trace = push_trace_test ? val_in_trace_test : val_in_trace_c;
        var_in_trace = push_trace_test ? var_in_trace_test : var_in_trace_c;
        type_in_trace = push_trace_test ? type_in_trace_test : type_in_trace_c;
        
        push_imply = push_imply_cd || push_imply_test;
        val_in_imply = push_imply_test ? val_in_imply_test : val_in_imply_cd;
        var_in_imply = push_imply_test ? var_in_imply_test : var_in_imply_cd;

        read_vs = read_vs_c || read_vs_test;
        var_in_vs = read_vs_test ? var_in_vs_test : var_in_vs_c;
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
        @(negedge clock);
        RESET_RAMS();
        @(negedge clock);
        // SET VAR START END TABLE
        SET_VAR_START_END_TABLE(0, 26'b00000000000000000000000000);
        SET_VAR_START_END_TABLE(1, 26'b00000000000000000000000100);
        SET_VAR_START_END_TABLE(2, 26'b00000000001000000000001000);
        SET_VAR_START_END_TABLE(3, 26'b00000000010000000000001100);
        SET_VAR_START_END_TABLE(4, 26'b00000000011000000000010000);
        SET_VAR_START_END_TABLE(5, 26'b00000000100000000000010100);
        SET_VAR_START_END_TABLE(6, 26'b00000000101000000000011000);
        SET_VAR_START_END_TABLE(7, 26'b00000000110000000000011100);
        SET_VAR_START_END_TABLE(8, 26'b00000000111000000000100000);
        SET_VAR_START_END_TABLE(9, 26'b00000001000000000000100100);
        SET_VAR_START_END_TABLE(10, 26'b00000001001000000000101000);
        SET_VAR_START_END_TABLE(11, 26'b00000001010000000000101100);
        SET_VAR_START_END_TABLE(12, 26'b00000001011000000000110000);

        // SET CLAUSE DATABASE
        SET_CLAUSE_DATABASE(0, 55'b0000000000000000000000000000000000000000000000000000000);
        SET_CLAUSE_DATABASE(1, 55'b1110000011000000001000000010000000011000000000000000000);
        SET_CLAUSE_DATABASE(2, 55'b1110000011000000100000000101000000110000000000000000000);
        SET_CLAUSE_DATABASE(3, 55'b1110000011000000111000001000000001001000000000000000000);
        SET_CLAUSE_DATABASE(4, 55'b1110000011000001010000001011000001100000000000000000000);
        SET_CLAUSE_DATABASE(5, 55'b1100011111000000001000000100000000000000000000000000000);
        SET_CLAUSE_DATABASE(6, 55'b1100011111000000001000000111000000000000000000000000000);
        SET_CLAUSE_DATABASE(7, 55'b1100011111000000001000001010000000000000000000000000000);
        SET_CLAUSE_DATABASE(8, 55'b1100011111000000100000000111000000000000000000000000000);
        SET_CLAUSE_DATABASE(9, 55'b1100011111000000100000001010000000000000000000000000000);
        SET_CLAUSE_DATABASE(10, 55'b1100011111000000111000001010000000000000000000000000000);
        SET_CLAUSE_DATABASE(11, 55'b1100011111000000010000000101000000000000000000000000000);
        SET_CLAUSE_DATABASE(12, 55'b1100011111000000010000001000000000000000000000000000000);
        SET_CLAUSE_DATABASE(13, 55'b1100011111000000010000001011000000000000000000000000000);
        SET_CLAUSE_DATABASE(14, 55'b1100011111000000101000001000000000000000000000000000000);
        SET_CLAUSE_DATABASE(15, 55'b1100011111000000101000001011000000000000000000000000000);
        SET_CLAUSE_DATABASE(16, 55'b1100011111000001000000001011000000000000000000000000000);
        SET_CLAUSE_DATABASE(17, 55'b1100011111000000011000000110000000000000000000000000000);
        SET_CLAUSE_DATABASE(18, 55'b1100011111000000011000001001000000000000000000000000000);
        SET_CLAUSE_DATABASE(19, 55'b1100011111000000011000001100000000000000000000000000000);
        SET_CLAUSE_DATABASE(20, 55'b1100011111000000110000001001000000000000000000000000000);
        SET_CLAUSE_DATABASE(21, 55'b1100011111000000110000001100000000000000000000000000000);
        SET_CLAUSE_DATABASE(22, 55'b1100011111000001001000001100000000000000000000000000000);

        // SET CLAUSE TABLE
        SET_CLAUSE_TABLE(0, 10'b0000000001);
        SET_CLAUSE_TABLE(1, 10'b0000000101);
        SET_CLAUSE_TABLE(2, 10'b0000000110);
        SET_CLAUSE_TABLE(3, 10'b0000000111);
        SET_CLAUSE_TABLE(4, 10'b0000000001);
        SET_CLAUSE_TABLE(5, 10'b0000001011);
        SET_CLAUSE_TABLE(6, 10'b0000001100);
        SET_CLAUSE_TABLE(7, 10'b0000001101);
        SET_CLAUSE_TABLE(8, 10'b0000000001);
        SET_CLAUSE_TABLE(9, 10'b0000010001);
        SET_CLAUSE_TABLE(10, 10'b0000010010);
        SET_CLAUSE_TABLE(11, 10'b0000010011);
        SET_CLAUSE_TABLE(12, 10'b0000000010);
        SET_CLAUSE_TABLE(13, 10'b0000000101);
        SET_CLAUSE_TABLE(14, 10'b0000001000);
        SET_CLAUSE_TABLE(15, 10'b0000001001);
        SET_CLAUSE_TABLE(16, 10'b0000000010);
        SET_CLAUSE_TABLE(17, 10'b0000001011);
        SET_CLAUSE_TABLE(18, 10'b0000001110);
        SET_CLAUSE_TABLE(19, 10'b0000001111);
        SET_CLAUSE_TABLE(20, 10'b0000000010);
        SET_CLAUSE_TABLE(21, 10'b0000010001);
        SET_CLAUSE_TABLE(22, 10'b0000010100);
        SET_CLAUSE_TABLE(23, 10'b0000010101);
        SET_CLAUSE_TABLE(24, 10'b0000000011);
        SET_CLAUSE_TABLE(25, 10'b0000000110);
        SET_CLAUSE_TABLE(26, 10'b0000001000);
        SET_CLAUSE_TABLE(27, 10'b0000001010);
        SET_CLAUSE_TABLE(28, 10'b0000000011);
        SET_CLAUSE_TABLE(29, 10'b0000001100);
        SET_CLAUSE_TABLE(30, 10'b0000001110);
        SET_CLAUSE_TABLE(31, 10'b0000010000);
        SET_CLAUSE_TABLE(32, 10'b0000000011);
        SET_CLAUSE_TABLE(33, 10'b0000010010);
        SET_CLAUSE_TABLE(34, 10'b0000010100);
        SET_CLAUSE_TABLE(35, 10'b0000010110);
        SET_CLAUSE_TABLE(36, 10'b0000000100);
        SET_CLAUSE_TABLE(37, 10'b0000000111);
        SET_CLAUSE_TABLE(38, 10'b0000001001);
        SET_CLAUSE_TABLE(39, 10'b0000001010);
        SET_CLAUSE_TABLE(40, 10'b0000000100);
        SET_CLAUSE_TABLE(41, 10'b0000001101);
        SET_CLAUSE_TABLE(42, 10'b0000001111);
        SET_CLAUSE_TABLE(43, 10'b0000010000);
        SET_CLAUSE_TABLE(44, 10'b0000000100);
        SET_CLAUSE_TABLE(45, 10'b0000010011);
        SET_CLAUSE_TABLE(46, 10'b0000010101);
        SET_CLAUSE_TABLE(47, 10'b0000010110);


        @(negedge clock);
        clock = 0;
        reset = 1;
        max_var_test = 12;
        bcp_busy_test = 0;
        push_imply_test = 0;
        read_vs_test = 0;
        push_trace_test = 0;

        @(negedge clock);

        $display("\nStart Solver at IDLE");

        reset = 0;
        start = 1;
        @(negedge clock);
        start = 0;
        @(negedge clock);

        while (!unsat && !sat) begin
            @(negedge clock);
        end
        SHOW_DEBUG();


        // for (integer i = 0; i < 999; i = i + 1) begin
        //     if (unsat | sat) break;
        //     @(negedge clock);
        // end
        @(negedge clock);
        $display("Expected UNSAT");

        // Wait until something happens???
        // TODO: Copy EECS 470 wait till something happens function to put here
        $display("\nAssignment in Var State\n");
        for (integer i = 0; i < max_var_test; i = i+1) begin
            read_vs_test = 1;
            var_in_vs_test = i+1;
            $display("var%0d = %0b, (sanity check) assigned = %0b",i+1, val_out_vs, unassign_out_vs);
            @(negedge clock);
        end

        // bcp_busy_test = 1;
        // @(negedge clock);
        // bcp_busy_test = 0;

        $finish;
    end
endmodule