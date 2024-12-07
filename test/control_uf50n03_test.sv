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
                \nVAR STATE: write = %0b var_in = %0d val_in = %0b unassign_in = %0b \
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
                write_vs, var_in_vs, val_in_vs, unassign_in_vs,
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
    //             \nVAR STATE: write = %0b var_in = %0d val_in = %0b unassign_in = %0b \
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
    //             write_vs, var_in_vs, val_in_vs, unassign_in_vs,
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
        SET_VAR_START_END_TABLE(1, 26'b00000000000000000000001111);
        SET_VAR_START_END_TABLE(2, 26'b00000000011110000000011100);
        SET_VAR_START_END_TABLE(3, 26'b00000000111000000000100110);
        SET_VAR_START_END_TABLE(4, 26'b00000001001100000000110100);
        SET_VAR_START_END_TABLE(5, 26'b00000001101000000001000101);
        SET_VAR_START_END_TABLE(6, 26'b00000010001010000001001110);
        SET_VAR_START_END_TABLE(7, 26'b00000010011100000001011001);
        SET_VAR_START_END_TABLE(8, 26'b00000010110010000001100101);
        SET_VAR_START_END_TABLE(9, 26'b00000011001010000001111101);
        SET_VAR_START_END_TABLE(10, 26'b00000011111010000010001001);
        SET_VAR_START_END_TABLE(11, 26'b00000100010010000010010110);
        SET_VAR_START_END_TABLE(12, 26'b00000100101100000010101000);
        SET_VAR_START_END_TABLE(13, 26'b00000101010000000010110011);
        SET_VAR_START_END_TABLE(14, 26'b00000101100110000011000010);
        SET_VAR_START_END_TABLE(15, 26'b00000110000100000011001011);
        SET_VAR_START_END_TABLE(16, 26'b00000110010110000011010110);
        SET_VAR_START_END_TABLE(17, 26'b00000110101100000011101000);
        SET_VAR_START_END_TABLE(18, 26'b00000111010000000011110110);
        SET_VAR_START_END_TABLE(19, 26'b00000111101100000100000001);
        SET_VAR_START_END_TABLE(20, 26'b00001000000010000100001011);
        SET_VAR_START_END_TABLE(21, 26'b00001000010110000100011110);
        SET_VAR_START_END_TABLE(22, 26'b00001000111100000100100111);
        SET_VAR_START_END_TABLE(23, 26'b00001001001110000100110011);
        SET_VAR_START_END_TABLE(24, 26'b00001001100110000101000110);
        SET_VAR_START_END_TABLE(25, 26'b00001010001100000101010110);
        SET_VAR_START_END_TABLE(26, 26'b00001010101100000101100110);
        SET_VAR_START_END_TABLE(27, 26'b00001011001100000101111010);
        SET_VAR_START_END_TABLE(28, 26'b00001011110100000110001011);
        SET_VAR_START_END_TABLE(29, 26'b00001100010110000110010101);
        SET_VAR_START_END_TABLE(30, 26'b00001100101010000110011100);
        SET_VAR_START_END_TABLE(31, 26'b00001100111000000110101101);
        SET_VAR_START_END_TABLE(32, 26'b00001101011010000110111011);
        SET_VAR_START_END_TABLE(33, 26'b00001101110110000111000100);
        SET_VAR_START_END_TABLE(34, 26'b00001110001000000111001100);
        SET_VAR_START_END_TABLE(35, 26'b00001110011000000111010011);
        SET_VAR_START_END_TABLE(36, 26'b00001110100110000111100011);
        SET_VAR_START_END_TABLE(37, 26'b00001111000110000111110101);
        SET_VAR_START_END_TABLE(38, 26'b00001111101010000111111101);
        SET_VAR_START_END_TABLE(39, 26'b00001111111010001000001110);
        SET_VAR_START_END_TABLE(40, 26'b00010000011100001000011010);
        SET_VAR_START_END_TABLE(41, 26'b00010000110100001000100010);
        SET_VAR_START_END_TABLE(42, 26'b00010001000100001000101111);
        SET_VAR_START_END_TABLE(43, 26'b00010001011110001000111001);
        SET_VAR_START_END_TABLE(44, 26'b00010001110010001001000011);
        SET_VAR_START_END_TABLE(45, 26'b00010010000110001001010000);
        SET_VAR_START_END_TABLE(46, 26'b00010010100000001001011101);
        SET_VAR_START_END_TABLE(47, 26'b00010010111010001001100111);
        SET_VAR_START_END_TABLE(48, 26'b00010011001110001001111010);
        SET_VAR_START_END_TABLE(49, 26'b00010011110100001010000010);
        SET_VAR_START_END_TABLE(50, 26'b00010100000100001010001110);

        // SET CLAUSE DATABASE
        SET_CLAUSE_DATABASE(0, 55'b0000000000000000000000000000000000000000000000000000000);
        SET_CLAUSE_DATABASE(1, 55'b1110011111000101101000100101000000001000000000000000000);
        SET_CLAUSE_DATABASE(2, 55'b1110010011000101000000010101000100111000000000000000000);
        SET_CLAUSE_DATABASE(3, 55'b1110001111000100010000001000000001101000000000000000000);
        SET_CLAUSE_DATABASE(4, 55'b1110011011000010000000010101000000101000000000000000000);
        SET_CLAUSE_DATABASE(5, 55'b1110010011000010110000100100000010000000000000000000000);
        SET_CLAUSE_DATABASE(6, 55'b1110010011000101110000010011000001011000000000000000000);
        SET_CLAUSE_DATABASE(7, 55'b1110001111000011001000110000000011011000000000000000000);
        SET_CLAUSE_DATABASE(8, 55'b1110011111000011011000011111000000010000000000000000000);
        SET_CLAUSE_DATABASE(9, 55'b1110011111000011100000000111000000010000000000000000000);
        SET_CLAUSE_DATABASE(10, 55'b1110001011000110000000000101000011101000000000000000000);
        SET_CLAUSE_DATABASE(11, 55'b1110010111000100110000011100000010101000000000000000000);
        SET_CLAUSE_DATABASE(12, 55'b1110010011000000100000110000000011010000000000000000000);
        SET_CLAUSE_DATABASE(13, 55'b1110011111000011001000100110000000011000000000000000000);
        SET_CLAUSE_DATABASE(14, 55'b1110001111000001000000000011000110010000000000000000000);
        SET_CLAUSE_DATABASE(15, 55'b1110011011000000010000100000000100101000000000000000000);
        SET_CLAUSE_DATABASE(16, 55'b1110001011000100000000100001000101110000000000000000000);
        SET_CLAUSE_DATABASE(17, 55'b1110000111000011110000100010000010001000000000000000000);
        SET_CLAUSE_DATABASE(18, 55'b1110010111000011100000100111000001111000000000000000000);
        SET_CLAUSE_DATABASE(19, 55'b1110001111000010111000010110000101100000000000000000000);
        SET_CLAUSE_DATABASE(20, 55'b1110010011000000101000100001000001010000000000000000000);
        SET_CLAUSE_DATABASE(21, 55'b1110001011000001011000101100000100101000000000000000000);
        SET_CLAUSE_DATABASE(22, 55'b1110011011000011001000011010000110010000000000000000000);
        SET_CLAUSE_DATABASE(23, 55'b1110011011000010011000001001000000010000000000000000000);
        SET_CLAUSE_DATABASE(24, 55'b1110001011000011000000001100000100101000000000000000000);
        SET_CLAUSE_DATABASE(25, 55'b1110001011000101101000100111000110001000000000000000000);
        SET_CLAUSE_DATABASE(26, 55'b1110011111000001001000101001000000101000000000000000000);
        SET_CLAUSE_DATABASE(27, 55'b1110000011000001100000010110000011010000000000000000000);
        SET_CLAUSE_DATABASE(28, 55'b1110010011000011001000100000000010000000000000000000000);
        SET_CLAUSE_DATABASE(29, 55'b1110010111000101010000100111000010000000000000000000000);
        SET_CLAUSE_DATABASE(30, 55'b1110010011000101101000000001000100111000000000000000000);
        SET_CLAUSE_DATABASE(31, 55'b1110000011000000101000001101000001001000000000000000000);
        SET_CLAUSE_DATABASE(32, 55'b1110011111000001001000010011000011011000000000000000000);
        SET_CLAUSE_DATABASE(33, 55'b1110001111000101001000000100000010110000000000000000000);
        SET_CLAUSE_DATABASE(34, 55'b1110011111000001010000010110000011001000000000000000000);
        SET_CLAUSE_DATABASE(35, 55'b1110001111000011001000101101000011111000000000000000000);
        SET_CLAUSE_DATABASE(36, 55'b1110010011000011111000101011000101111000000000000000000);
        SET_CLAUSE_DATABASE(37, 55'b1110001011000101101000001011000010111000000000000000000);
        SET_CLAUSE_DATABASE(38, 55'b1110011111000001011000100100000000110000000000000000000);
        SET_CLAUSE_DATABASE(39, 55'b1110011011000010010000000001000001000000000000000000000);
        SET_CLAUSE_DATABASE(40, 55'b1110000111000010111000000001000000010000000000000000000);
        SET_CLAUSE_DATABASE(41, 55'b1110011111000100101000101100000100000000000000000000000);
        SET_CLAUSE_DATABASE(42, 55'b1110001111000100110000011011000101100000000000000000000);
        SET_CLAUSE_DATABASE(43, 55'b1110001011000001100000001001000010111000000000000000000);
        SET_CLAUSE_DATABASE(44, 55'b1110001111000000100000000111000001111000000000000000000);
        SET_CLAUSE_DATABASE(45, 55'b1110000011000010010000010101000101010000000000000000000);
        SET_CLAUSE_DATABASE(46, 55'b1110011111000001001000001010000101111000000000000000000);
        SET_CLAUSE_DATABASE(47, 55'b1110001011000011000000011110000000111000000000000000000);
        SET_CLAUSE_DATABASE(48, 55'b1110010011000000101000000001000001101000000000000000000);
        SET_CLAUSE_DATABASE(49, 55'b1110001011000101010000010101000001001000000000000000000);
        SET_CLAUSE_DATABASE(50, 55'b1110010011000110000000110001000011100000000000000000000);
        SET_CLAUSE_DATABASE(51, 55'b1110010011000101011000011011000001011000000000000000000);
        SET_CLAUSE_DATABASE(52, 55'b1110000011000010011000101001000100001000000000000000000);
        SET_CLAUSE_DATABASE(53, 55'b1110011111000011101000001101000010111000000000000000000);
        SET_CLAUSE_DATABASE(54, 55'b1110001111000101011000100000000001100000000000000000000);
        SET_CLAUSE_DATABASE(55, 55'b1110010011000001000000100100000101010000000000000000000);
        SET_CLAUSE_DATABASE(56, 55'b1110000111000100100000010001000101110000000000000000000);
        SET_CLAUSE_DATABASE(57, 55'b1110010011000011001000101011000100000000000000000000000);
        SET_CLAUSE_DATABASE(58, 55'b1110000011000011100000001101000011011000000000000000000);
        SET_CLAUSE_DATABASE(59, 55'b1110000011000001100000100010000011101000000000000000000);
        SET_CLAUSE_DATABASE(60, 55'b1110001011000010100000000111000001110000000000000000000);
        SET_CLAUSE_DATABASE(61, 55'b1110010011000101001000110000000001001000000000000000000);
        SET_CLAUSE_DATABASE(62, 55'b1110001011000100100000011100000000100000000000000000000);
        SET_CLAUSE_DATABASE(63, 55'b1110010011000010101000000101000010001000000000000000000);
        SET_CLAUSE_DATABASE(64, 55'b1110011011000001110000100011000000011000000000000000000);
        SET_CLAUSE_DATABASE(65, 55'b1110010011000001110000010001000011111000000000000000000);
        SET_CLAUSE_DATABASE(66, 55'b1110001011000110010000001100000001001000000000000000000);
        SET_CLAUSE_DATABASE(67, 55'b1110001011000010100000100001000101000000000000000000000);
        SET_CLAUSE_DATABASE(68, 55'b1110001011000011011000010100000101011000000000000000000);
        SET_CLAUSE_DATABASE(69, 55'b1110000111000011111000011100000001110000000000000000000);
        SET_CLAUSE_DATABASE(70, 55'b1110000111000100101000101000000010011000000000000000000);
        SET_CLAUSE_DATABASE(71, 55'b1110000011000001110000010110000101000000000000000000000);
        SET_CLAUSE_DATABASE(72, 55'b1110000111000101001000000010000001110000000000000000000);
        SET_CLAUSE_DATABASE(73, 55'b1110010111000010101000011010000100010000000000000000000);
        SET_CLAUSE_DATABASE(74, 55'b1110010111000010010000101110000001001000000000000000000);
        SET_CLAUSE_DATABASE(75, 55'b1110010111000011011000001001000001111000000000000000000);
        SET_CLAUSE_DATABASE(76, 55'b1110010111000000100000101001000100011000000000000000000);
        SET_CLAUSE_DATABASE(77, 55'b1110010111000010001000001011000011010000000000000000000);
        SET_CLAUSE_DATABASE(78, 55'b1110000011000010101000100000000000111000000000000000000);
        SET_CLAUSE_DATABASE(79, 55'b1110001111000110001000100101000010100000000000000000000);
        SET_CLAUSE_DATABASE(80, 55'b1110010011000000100000110000000010011000000000000000000);
        SET_CLAUSE_DATABASE(81, 55'b1110001111000110000000000111000011000000000000000000000);
        SET_CLAUSE_DATABASE(82, 55'b1110011111000011100000001010000010101000000000000000000);
        SET_CLAUSE_DATABASE(83, 55'b1110010111000010101000110000000101110000000000000000000);
        SET_CLAUSE_DATABASE(84, 55'b1110001011000011010000101010000000010000000000000000000);
        SET_CLAUSE_DATABASE(85, 55'b1110011111000000110000011100000010111000000000000000000);
        SET_CLAUSE_DATABASE(86, 55'b1110000011000101111000000001000100011000000000000000000);
        SET_CLAUSE_DATABASE(87, 55'b1110011011000001011000101100000011011000000000000000000);
        SET_CLAUSE_DATABASE(88, 55'b1110001111000010111000000011000001111000000000000000000);
        SET_CLAUSE_DATABASE(89, 55'b1110000011000001100000010010000011101000000000000000000);
        SET_CLAUSE_DATABASE(90, 55'b1110010111000010001000011001000100101000000000000000000);
        SET_CLAUSE_DATABASE(91, 55'b1110001111000011010000010101000011111000000000000000000);
        SET_CLAUSE_DATABASE(92, 55'b1110001011000011100000000001000101010000000000000000000);
        SET_CLAUSE_DATABASE(93, 55'b1110010011000010110000000100000011011000000000000000000);
        SET_CLAUSE_DATABASE(94, 55'b1110001011000011000000100001000100100000000000000000000);
        SET_CLAUSE_DATABASE(95, 55'b1110010011000001011000001100000011110000000000000000000);
        SET_CLAUSE_DATABASE(96, 55'b1110010011000011100000010111000001001000000000000000000);
        SET_CLAUSE_DATABASE(97, 55'b1110001011000001111000001110000110000000000000000000000);
        SET_CLAUSE_DATABASE(98, 55'b1110010011000101010000110001000110000000000000000000000);
        SET_CLAUSE_DATABASE(99, 55'b1110001011000000010000000011000000001000000000000000000);
        SET_CLAUSE_DATABASE(100, 55'b1110000111000001111000001001000100100000000000000000000);
        SET_CLAUSE_DATABASE(101, 55'b1110010011000101000000100101000001011000000000000000000);
        SET_CLAUSE_DATABASE(102, 55'b1110000111000000101000100111000100110000000000000000000);
        SET_CLAUSE_DATABASE(103, 55'b1110001011000011000000110010000011111000000000000000000);
        SET_CLAUSE_DATABASE(104, 55'b1110011111000100100000011101000000011000000000000000000);
        SET_CLAUSE_DATABASE(105, 55'b1110010011000101011000101110000001000000000000000000000);
        SET_CLAUSE_DATABASE(106, 55'b1110011111000010000000110000000000100000000000000000000);
        SET_CLAUSE_DATABASE(107, 55'b1110010011000110010000000001000010001000000000000000000);
        SET_CLAUSE_DATABASE(108, 55'b1110011011000010011000011011000011001000000000000000000);
        SET_CLAUSE_DATABASE(109, 55'b1110000011000110010000100001000011111000000000000000000);
        SET_CLAUSE_DATABASE(110, 55'b1110001011000000010000001100000001000000000000000000000);
        SET_CLAUSE_DATABASE(111, 55'b1110011011000011010000000101000001101000000000000000000);
        SET_CLAUSE_DATABASE(112, 55'b1110000011000001000000011110000001001000000000000000000);
        SET_CLAUSE_DATABASE(113, 55'b1110001111000110001000100011000100111000000000000000000);
        SET_CLAUSE_DATABASE(114, 55'b1110001111000011001000100010000010010000000000000000000);
        SET_CLAUSE_DATABASE(115, 55'b1110001111000010001000100101000110001000000000000000000);
        SET_CLAUSE_DATABASE(116, 55'b1110000011000101000000010101000101010000000000000000000);
        SET_CLAUSE_DATABASE(117, 55'b1110001011000001011000001000000000001000000000000000000);
        SET_CLAUSE_DATABASE(118, 55'b1110000111000011111000011110000000010000000000000000000);
        SET_CLAUSE_DATABASE(119, 55'b1110001011000000100000011100000010011000000000000000000);
        SET_CLAUSE_DATABASE(120, 55'b1110000111000001001000110000000101010000000000000000000);
        SET_CLAUSE_DATABASE(121, 55'b1110010011000101100000001100000001000000000000000000000);
        SET_CLAUSE_DATABASE(122, 55'b1110001111000000110000011000000010000000000000000000000);
        SET_CLAUSE_DATABASE(123, 55'b1110001111000011000000010111000011011000000000000000000);
        SET_CLAUSE_DATABASE(124, 55'b1110010111000001010000101101000000111000000000000000000);
        SET_CLAUSE_DATABASE(125, 55'b1110001011000100010000011001000100100000000000000000000);
        SET_CLAUSE_DATABASE(126, 55'b1110000111000001011000011000000010011000000000000000000);
        SET_CLAUSE_DATABASE(127, 55'b1110010111000011010000001110000000101000000000000000000);
        SET_CLAUSE_DATABASE(128, 55'b1110000011000100101000101011000010100000000000000000000);
        SET_CLAUSE_DATABASE(129, 55'b1110010011000101011000011100000000110000000000000000000);
        SET_CLAUSE_DATABASE(130, 55'b1110000111000100110000100111000101110000000000000000000);
        SET_CLAUSE_DATABASE(131, 55'b1110011011000011111000011000000110010000000000000000000);
        SET_CLAUSE_DATABASE(132, 55'b1110010111000011111000010001000010101000000000000000000);
        SET_CLAUSE_DATABASE(133, 55'b1110000011000100001000101100000100010000000000000000000);
        SET_CLAUSE_DATABASE(134, 55'b1110001111000001100000110010000011101000000000000000000);
        SET_CLAUSE_DATABASE(135, 55'b1110010111000100110000100101000011000000000000000000000);
        SET_CLAUSE_DATABASE(136, 55'b1110001011000001001000101000000001010000000000000000000);
        SET_CLAUSE_DATABASE(137, 55'b1110010011000010000000010100000010001000000000000000000);
        SET_CLAUSE_DATABASE(138, 55'b1110001011000011100000100110000010010000000000000000000);
        SET_CLAUSE_DATABASE(139, 55'b1110010011000001101000000001000011001000000000000000000);
        SET_CLAUSE_DATABASE(140, 55'b1110011011000011010000000101000001010000000000000000000);
        SET_CLAUSE_DATABASE(141, 55'b1110010111000100011000101111000001000000000000000000000);
        SET_CLAUSE_DATABASE(142, 55'b1110000011000101101000010100000001111000000000000000000);
        SET_CLAUSE_DATABASE(143, 55'b1110001111000100100000100001000000111000000000000000000);
        SET_CLAUSE_DATABASE(144, 55'b1110001011000011011000000111000101110000000000000000000);
        SET_CLAUSE_DATABASE(145, 55'b1110010011000011000000010111000010001000000000000000000);
        SET_CLAUSE_DATABASE(146, 55'b1110001011000000010000000110000000001000000000000000000);
        SET_CLAUSE_DATABASE(147, 55'b1110000111000000101000101101000011000000000000000000000);
        SET_CLAUSE_DATABASE(148, 55'b1110011011000100111000101010000001100000000000000000000);
        SET_CLAUSE_DATABASE(149, 55'b1110010011000101001000010101000001100000000000000000000);
        SET_CLAUSE_DATABASE(150, 55'b1110001011000110001000101101000100000000000000000000000);
        SET_CLAUSE_DATABASE(151, 55'b1110001011000010100000011110000001000000000000000000000);
        SET_CLAUSE_DATABASE(152, 55'b1110010011000011000000101010000000011000000000000000000);
        SET_CLAUSE_DATABASE(153, 55'b1110011111000011011000110010000000001000000000000000000);
        SET_CLAUSE_DATABASE(154, 55'b1110000111000101011000100100000001111000000000000000000);
        SET_CLAUSE_DATABASE(155, 55'b1110011011000001110000010101000011110000000000000000000);
        SET_CLAUSE_DATABASE(156, 55'b1110000011000101111000000101000100101000000000000000000);
        SET_CLAUSE_DATABASE(157, 55'b1110001111000001100000110000000010001000000000000000000);
        SET_CLAUSE_DATABASE(158, 55'b1110000011000011000000010101000011011000000000000000000);
        SET_CLAUSE_DATABASE(159, 55'b1110010111000010010000000010000000111000000000000000000);
        SET_CLAUSE_DATABASE(160, 55'b1110010111000010001000010011000110001000000000000000000);
        SET_CLAUSE_DATABASE(161, 55'b1110010011000000100000001010000100111000000000000000000);
        SET_CLAUSE_DATABASE(162, 55'b1110011011000001111000011010000001011000000000000000000);
        SET_CLAUSE_DATABASE(163, 55'b1110011111000001000000001110000011010000000000000000000);
        SET_CLAUSE_DATABASE(164, 55'b1110011111000000101000100011000001011000000000000000000);
        SET_CLAUSE_DATABASE(165, 55'b1110010011000000011000001010000100101000000000000000000);
        SET_CLAUSE_DATABASE(166, 55'b1110011011000000011000100000000001010000000000000000000);
        SET_CLAUSE_DATABASE(167, 55'b1110010111000000111000010101000100000000000000000000000);
        SET_CLAUSE_DATABASE(168, 55'b1110010111000101101000011001000001100000000000000000000);
        SET_CLAUSE_DATABASE(169, 55'b1110010011000100001000010000000011111000000000000000000);
        SET_CLAUSE_DATABASE(170, 55'b1110000011000100000000000100000011111000000000000000000);
        SET_CLAUSE_DATABASE(171, 55'b1110011111000101000000000110000100010000000000000000000);
        SET_CLAUSE_DATABASE(172, 55'b1110001011000010100000000101000000001000000000000000000);
        SET_CLAUSE_DATABASE(173, 55'b1110010111000100111000100101000100100000000000000000000);
        SET_CLAUSE_DATABASE(174, 55'b1110011011000101110000101111000001100000000000000000000);
        SET_CLAUSE_DATABASE(175, 55'b1110011011000110000000010101000010001000000000000000000);
        SET_CLAUSE_DATABASE(176, 55'b1110001011000011111000011100000011000000000000000000000);
        SET_CLAUSE_DATABASE(177, 55'b1110011011000101100000101110000011011000000000000000000);
        SET_CLAUSE_DATABASE(178, 55'b1110010111000000101000100100000101000000000000000000000);
        SET_CLAUSE_DATABASE(179, 55'b1110000011000100000000010000000110000000000000000000000);
        SET_CLAUSE_DATABASE(180, 55'b1110010111000000101000011001000011010000000000000000000);
        SET_CLAUSE_DATABASE(181, 55'b1110010111000001101000101010000010011000000000000000000);
        SET_CLAUSE_DATABASE(182, 55'b1110000111000010100000001110000010001000000000000000000);
        SET_CLAUSE_DATABASE(183, 55'b1110001011000010010000101111000101001000000000000000000);
        SET_CLAUSE_DATABASE(184, 55'b1110010111000101011000001110000011001000000000000000000);
        SET_CLAUSE_DATABASE(185, 55'b1110010011000110010000011010000000100000000000000000000);
        SET_CLAUSE_DATABASE(186, 55'b1110011111000010101000001001000101000000000000000000000);
        SET_CLAUSE_DATABASE(187, 55'b1110011111000010010000100111000101111000000000000000000);
        SET_CLAUSE_DATABASE(188, 55'b1110001111000110000000101111000010111000000000000000000);
        SET_CLAUSE_DATABASE(189, 55'b1110010111000110000000101010000000110000000000000000000);
        SET_CLAUSE_DATABASE(190, 55'b1110010111000100101000100111000001101000000000000000000);
        SET_CLAUSE_DATABASE(191, 55'b1110001011000010010000001110000010110000000000000000000);
        SET_CLAUSE_DATABASE(192, 55'b1110001111000100000000011101000110000000000000000000000);
        SET_CLAUSE_DATABASE(193, 55'b1110000111000001010000011000000000010000000000000000000);
        SET_CLAUSE_DATABASE(194, 55'b1110010011000001100000101100000100111000000000000000000);
        SET_CLAUSE_DATABASE(195, 55'b1110011011000100100000101101000001101000000000000000000);
        SET_CLAUSE_DATABASE(196, 55'b1110000011000011111000001001000100000000000000000000000);
        SET_CLAUSE_DATABASE(197, 55'b1110000111000000100000000110000110010000000000000000000);
        SET_CLAUSE_DATABASE(198, 55'b1110011011000011111000011011000000001000000000000000000);
        SET_CLAUSE_DATABASE(199, 55'b1110000011000010000000000100000101110000000000000000000);
        SET_CLAUSE_DATABASE(200, 55'b1110011111000011101000100111000101110000000000000000000);
        SET_CLAUSE_DATABASE(201, 55'b1110010011000001001000010010000101110000000000000000000);
        SET_CLAUSE_DATABASE(202, 55'b1110011011000001100000011000000011001000000000000000000);
        SET_CLAUSE_DATABASE(203, 55'b1110010011000010010000100111000001001000000000000000000);
        SET_CLAUSE_DATABASE(204, 55'b1110011011000100110000001001000001110000000000000000000);
        SET_CLAUSE_DATABASE(205, 55'b1110001011000100011000011100000100111000000000000000000);
        SET_CLAUSE_DATABASE(206, 55'b1110011111000010001000011011000011010000000000000000000);
        SET_CLAUSE_DATABASE(207, 55'b1110011111000001001000110010000011000000000000000000000);
        SET_CLAUSE_DATABASE(208, 55'b1110010011000010001000011100000010010000000000000000000);
        SET_CLAUSE_DATABASE(209, 55'b1110001011000100101000000110000011111000000000000000000);
        SET_CLAUSE_DATABASE(210, 55'b1110010111000000011000011101000101101000000000000000000);
        SET_CLAUSE_DATABASE(211, 55'b1110000111000110000000010001000001001000000000000000000);
        SET_CLAUSE_DATABASE(212, 55'b1110010111000010110000001001000101111000000000000000000);
        SET_CLAUSE_DATABASE(213, 55'b1110011111000011010000011000000001101000000000000000000);
        SET_CLAUSE_DATABASE(214, 55'b1110011111000010000000100100000100101000000000000000000);
        SET_CLAUSE_DATABASE(215, 55'b1110001011000001110000101000000001010000000000000000000);
        SET_CLAUSE_DATABASE(216, 55'b1110010111000101000000011101000011011000000000000000000);
        SET_CLAUSE_DATABASE(217, 55'b1110010111000101101000010111000100100000000000000000000);
        SET_CLAUSE_DATABASE(218, 55'b1110011011000011011000101100000010010000000000000000000);

        // SET CLAUSE TABLE
        SET_CLAUSE_TABLE(0, 10'b0000000001);
        SET_CLAUSE_TABLE(1, 10'b0000011110);
        SET_CLAUSE_TABLE(2, 10'b0000100111);
        SET_CLAUSE_TABLE(3, 10'b0000101000);
        SET_CLAUSE_TABLE(4, 10'b0000110000);
        SET_CLAUSE_TABLE(5, 10'b0001010110);
        SET_CLAUSE_TABLE(6, 10'b0001011100);
        SET_CLAUSE_TABLE(7, 10'b0001100011);
        SET_CLAUSE_TABLE(8, 10'b0001101011);
        SET_CLAUSE_TABLE(9, 10'b0001110101);
        SET_CLAUSE_TABLE(10, 10'b0010001011);
        SET_CLAUSE_TABLE(11, 10'b0010010010);
        SET_CLAUSE_TABLE(12, 10'b0010011001);
        SET_CLAUSE_TABLE(13, 10'b0010101100);
        SET_CLAUSE_TABLE(14, 10'b0011000110);
        SET_CLAUSE_TABLE(15, 10'b0000001000);
        SET_CLAUSE_TABLE(16, 10'b0000001001);
        SET_CLAUSE_TABLE(17, 10'b0000001111);
        SET_CLAUSE_TABLE(18, 10'b0000010111);
        SET_CLAUSE_TABLE(19, 10'b0000101000);
        SET_CLAUSE_TABLE(20, 10'b0001001000);
        SET_CLAUSE_TABLE(21, 10'b0001010100);
        SET_CLAUSE_TABLE(22, 10'b0001100011);
        SET_CLAUSE_TABLE(23, 10'b0001101110);
        SET_CLAUSE_TABLE(24, 10'b0001110110);
        SET_CLAUSE_TABLE(25, 10'b0010010010);
        SET_CLAUSE_TABLE(26, 10'b0010011111);
        SET_CLAUSE_TABLE(27, 10'b0011000001);
        SET_CLAUSE_TABLE(28, 10'b0000001101);
        SET_CLAUSE_TABLE(29, 10'b0000001110);
        SET_CLAUSE_TABLE(30, 10'b0001000000);
        SET_CLAUSE_TABLE(31, 10'b0001011000);
        SET_CLAUSE_TABLE(32, 10'b0001100011);
        SET_CLAUSE_TABLE(33, 10'b0001101000);
        SET_CLAUSE_TABLE(34, 10'b0010011000);
        SET_CLAUSE_TABLE(35, 10'b0010100101);
        SET_CLAUSE_TABLE(36, 10'b0010100110);
        SET_CLAUSE_TABLE(37, 10'b0011010010);
        SET_CLAUSE_TABLE(38, 10'b0000001100);
        SET_CLAUSE_TABLE(39, 10'b0000100001);
        SET_CLAUSE_TABLE(40, 10'b0000101100);
        SET_CLAUSE_TABLE(41, 10'b0000111110);
        SET_CLAUSE_TABLE(42, 10'b0001001100);
        SET_CLAUSE_TABLE(43, 10'b0001010000);
        SET_CLAUSE_TABLE(44, 10'b0001011101);
        SET_CLAUSE_TABLE(45, 10'b0001101010);
        SET_CLAUSE_TABLE(46, 10'b0001110111);
        SET_CLAUSE_TABLE(47, 10'b0010100001);
        SET_CLAUSE_TABLE(48, 10'b0010101010);
        SET_CLAUSE_TABLE(49, 10'b0010111001);
        SET_CLAUSE_TABLE(50, 10'b0011000101);
        SET_CLAUSE_TABLE(51, 10'b0011000111);
        SET_CLAUSE_TABLE(52, 10'b0000000100);
        SET_CLAUSE_TABLE(53, 10'b0000001010);
        SET_CLAUSE_TABLE(54, 10'b0000010100);
        SET_CLAUSE_TABLE(55, 10'b0000011010);
        SET_CLAUSE_TABLE(56, 10'b0000011111);
        SET_CLAUSE_TABLE(57, 10'b0000110000);
        SET_CLAUSE_TABLE(58, 10'b0000111111);
        SET_CLAUSE_TABLE(59, 10'b0001100110);
        SET_CLAUSE_TABLE(60, 10'b0001101111);
        SET_CLAUSE_TABLE(61, 10'b0001111111);
        SET_CLAUSE_TABLE(62, 10'b0010001100);
        SET_CLAUSE_TABLE(63, 10'b0010010011);
        SET_CLAUSE_TABLE(64, 10'b0010011100);
        SET_CLAUSE_TABLE(65, 10'b0010100100);
        SET_CLAUSE_TABLE(66, 10'b0010101100);
        SET_CLAUSE_TABLE(67, 10'b0010110010);
        SET_CLAUSE_TABLE(68, 10'b0010110100);
        SET_CLAUSE_TABLE(69, 10'b0000100110);
        SET_CLAUSE_TABLE(70, 10'b0001010101);
        SET_CLAUSE_TABLE(71, 10'b0001111010);
        SET_CLAUSE_TABLE(72, 10'b0010000001);
        SET_CLAUSE_TABLE(73, 10'b0010010010);
        SET_CLAUSE_TABLE(74, 10'b0010101011);
        SET_CLAUSE_TABLE(75, 10'b0010111101);
        SET_CLAUSE_TABLE(76, 10'b0011000101);
        SET_CLAUSE_TABLE(77, 10'b0011010001);
        SET_CLAUSE_TABLE(78, 10'b0000001001);
        SET_CLAUSE_TABLE(79, 10'b0000101100);
        SET_CLAUSE_TABLE(80, 10'b0000101111);
        SET_CLAUSE_TABLE(81, 10'b0000111100);
        SET_CLAUSE_TABLE(82, 10'b0001001110);
        SET_CLAUSE_TABLE(83, 10'b0001010001);
        SET_CLAUSE_TABLE(84, 10'b0001111100);
        SET_CLAUSE_TABLE(85, 10'b0010001111);
        SET_CLAUSE_TABLE(86, 10'b0010010000);
        SET_CLAUSE_TABLE(87, 10'b0010011111);
        SET_CLAUSE_TABLE(88, 10'b0010100111);
        SET_CLAUSE_TABLE(89, 10'b0000000011);
        SET_CLAUSE_TABLE(90, 10'b0000001110);
        SET_CLAUSE_TABLE(91, 10'b0000100111);
        SET_CLAUSE_TABLE(92, 10'b0000110111);
        SET_CLAUSE_TABLE(93, 10'b0001101001);
        SET_CLAUSE_TABLE(94, 10'b0001101110);
        SET_CLAUSE_TABLE(95, 10'b0001110000);
        SET_CLAUSE_TABLE(96, 10'b0001110101);
        SET_CLAUSE_TABLE(97, 10'b0001111001);
        SET_CLAUSE_TABLE(98, 10'b0010001101);
        SET_CLAUSE_TABLE(99, 10'b0010010111);
        SET_CLAUSE_TABLE(100, 10'b0010100011);
        SET_CLAUSE_TABLE(101, 10'b0000010111);
        SET_CLAUSE_TABLE(102, 10'b0000011010);
        SET_CLAUSE_TABLE(103, 10'b0000011111);
        SET_CLAUSE_TABLE(104, 10'b0000100000);
        SET_CLAUSE_TABLE(105, 10'b0000101011);
        SET_CLAUSE_TABLE(106, 10'b0000101110);
        SET_CLAUSE_TABLE(107, 10'b0000110001);
        SET_CLAUSE_TABLE(108, 10'b0000111101);
        SET_CLAUSE_TABLE(109, 10'b0001000010);
        SET_CLAUSE_TABLE(110, 10'b0001001010);
        SET_CLAUSE_TABLE(111, 10'b0001001011);
        SET_CLAUSE_TABLE(112, 10'b0001100000);
        SET_CLAUSE_TABLE(113, 10'b0001100100);
        SET_CLAUSE_TABLE(114, 10'b0001110000);
        SET_CLAUSE_TABLE(115, 10'b0001111000);
        SET_CLAUSE_TABLE(116, 10'b0010001000);
        SET_CLAUSE_TABLE(117, 10'b0010111010);
        SET_CLAUSE_TABLE(118, 10'b0011000100);
        SET_CLAUSE_TABLE(119, 10'b0011001001);
        SET_CLAUSE_TABLE(120, 10'b0011001011);
        SET_CLAUSE_TABLE(121, 10'b0011001100);
        SET_CLAUSE_TABLE(122, 10'b0011001111);
        SET_CLAUSE_TABLE(123, 10'b0011010011);
        SET_CLAUSE_TABLE(124, 10'b0011010100);
        SET_CLAUSE_TABLE(125, 10'b0000010100);
        SET_CLAUSE_TABLE(126, 10'b0000100010);
        SET_CLAUSE_TABLE(127, 10'b0000101110);
        SET_CLAUSE_TABLE(128, 10'b0001010010);
        SET_CLAUSE_TABLE(129, 10'b0001111100);
        SET_CLAUSE_TABLE(130, 10'b0010001000);
        SET_CLAUSE_TABLE(131, 10'b0010001100);
        SET_CLAUSE_TABLE(132, 10'b0010100001);
        SET_CLAUSE_TABLE(133, 10'b0010100101);
        SET_CLAUSE_TABLE(134, 10'b0010100110);
        SET_CLAUSE_TABLE(135, 10'b0011000001);
        SET_CLAUSE_TABLE(136, 10'b0011010111);
        SET_CLAUSE_TABLE(137, 10'b0000000110);
        SET_CLAUSE_TABLE(138, 10'b0000010101);
        SET_CLAUSE_TABLE(139, 10'b0000100101);
        SET_CLAUSE_TABLE(140, 10'b0000100110);
        SET_CLAUSE_TABLE(141, 10'b0000110011);
        SET_CLAUSE_TABLE(142, 10'b0001001101);
        SET_CLAUSE_TABLE(143, 10'b0001010111);
        SET_CLAUSE_TABLE(144, 10'b0001011111);
        SET_CLAUSE_TABLE(145, 10'b0001100101);
        SET_CLAUSE_TABLE(146, 10'b0001110101);
        SET_CLAUSE_TABLE(147, 10'b0001111110);
        SET_CLAUSE_TABLE(148, 10'b0010100010);
        SET_CLAUSE_TABLE(149, 10'b0010100100);
        SET_CLAUSE_TABLE(150, 10'b0000011000);
        SET_CLAUSE_TABLE(151, 10'b0000011011);
        SET_CLAUSE_TABLE(152, 10'b0000101011);
        SET_CLAUSE_TABLE(153, 10'b0000110110);
        SET_CLAUSE_TABLE(154, 10'b0000111011);
        SET_CLAUSE_TABLE(155, 10'b0001000010);
        SET_CLAUSE_TABLE(156, 10'b0001011001);
        SET_CLAUSE_TABLE(157, 10'b0001011111);
        SET_CLAUSE_TABLE(158, 10'b0001101110);
        SET_CLAUSE_TABLE(159, 10'b0001111001);
        SET_CLAUSE_TABLE(160, 10'b0010000110);
        SET_CLAUSE_TABLE(161, 10'b0010010100);
        SET_CLAUSE_TABLE(162, 10'b0010010101);
        SET_CLAUSE_TABLE(163, 10'b0010011101);
        SET_CLAUSE_TABLE(164, 10'b0010101000);
        SET_CLAUSE_TABLE(165, 10'b0010101110);
        SET_CLAUSE_TABLE(166, 10'b0011000010);
        SET_CLAUSE_TABLE(167, 10'b0011001010);
        SET_CLAUSE_TABLE(168, 10'b0000000011);
        SET_CLAUSE_TABLE(169, 10'b0000011111);
        SET_CLAUSE_TABLE(170, 10'b0000110000);
        SET_CLAUSE_TABLE(171, 10'b0000110101);
        SET_CLAUSE_TABLE(172, 10'b0000111010);
        SET_CLAUSE_TABLE(173, 10'b0001101111);
        SET_CLAUSE_TABLE(174, 10'b0010001011);
        SET_CLAUSE_TABLE(175, 10'b0010110101);
        SET_CLAUSE_TABLE(176, 10'b0010111110);
        SET_CLAUSE_TABLE(177, 10'b0011000011);
        SET_CLAUSE_TABLE(178, 10'b0011010101);
        SET_CLAUSE_TABLE(179, 10'b0000111100);
        SET_CLAUSE_TABLE(180, 10'b0001000000);
        SET_CLAUSE_TABLE(181, 10'b0001000001);
        SET_CLAUSE_TABLE(182, 10'b0001000101);
        SET_CLAUSE_TABLE(183, 10'b0001000111);
        SET_CLAUSE_TABLE(184, 10'b0001001000);
        SET_CLAUSE_TABLE(185, 10'b0001100001);
        SET_CLAUSE_TABLE(186, 10'b0001111111);
        SET_CLAUSE_TABLE(187, 10'b0010011011);
        SET_CLAUSE_TABLE(188, 10'b0010100011);
        SET_CLAUSE_TABLE(189, 10'b0010110110);
        SET_CLAUSE_TABLE(190, 10'b0010111000);
        SET_CLAUSE_TABLE(191, 10'b0010111111);
        SET_CLAUSE_TABLE(192, 10'b0011001100);
        SET_CLAUSE_TABLE(193, 10'b0011010111);
        SET_CLAUSE_TABLE(194, 10'b0000010010);
        SET_CLAUSE_TABLE(195, 10'b0000101100);
        SET_CLAUSE_TABLE(196, 10'b0001001011);
        SET_CLAUSE_TABLE(197, 10'b0001011000);
        SET_CLAUSE_TABLE(198, 10'b0001100001);
        SET_CLAUSE_TABLE(199, 10'b0001100100);
        SET_CLAUSE_TABLE(200, 10'b0010001110);
        SET_CLAUSE_TABLE(201, 10'b0010011010);
        SET_CLAUSE_TABLE(202, 10'b0010100010);
        SET_CLAUSE_TABLE(203, 10'b0000000100);
        SET_CLAUSE_TABLE(204, 10'b0000000101);
        SET_CLAUSE_TABLE(205, 10'b0000011100);
        SET_CLAUSE_TABLE(206, 10'b0000011101);
        SET_CLAUSE_TABLE(207, 10'b0001101010);
        SET_CLAUSE_TABLE(208, 10'b0001111010);
        SET_CLAUSE_TABLE(209, 10'b0010001001);
        SET_CLAUSE_TABLE(210, 10'b0010101001);
        SET_CLAUSE_TABLE(211, 10'b0010110011);
        SET_CLAUSE_TABLE(212, 10'b0011000111);
        SET_CLAUSE_TABLE(213, 10'b0011010110);
        SET_CLAUSE_TABLE(214, 10'b0000010001);
        SET_CLAUSE_TABLE(215, 10'b0000111000);
        SET_CLAUSE_TABLE(216, 10'b0000111111);
        SET_CLAUSE_TABLE(217, 10'b0001000001);
        SET_CLAUSE_TABLE(218, 10'b0001001101);
        SET_CLAUSE_TABLE(219, 10'b0001011010);
        SET_CLAUSE_TABLE(220, 10'b0001101011);
        SET_CLAUSE_TABLE(221, 10'b0001110011);
        SET_CLAUSE_TABLE(222, 10'b0010000100);
        SET_CLAUSE_TABLE(223, 10'b0010001001);
        SET_CLAUSE_TABLE(224, 10'b0010010001);
        SET_CLAUSE_TABLE(225, 10'b0010011101);
        SET_CLAUSE_TABLE(226, 10'b0010100000);
        SET_CLAUSE_TABLE(227, 10'b0010101111);
        SET_CLAUSE_TABLE(228, 10'b0010110110);
        SET_CLAUSE_TABLE(229, 10'b0011001110);
        SET_CLAUSE_TABLE(230, 10'b0011010000);
        SET_CLAUSE_TABLE(231, 10'b0011010011);
        SET_CLAUSE_TABLE(232, 10'b0000100111);
        SET_CLAUSE_TABLE(233, 10'b0000101101);
        SET_CLAUSE_TABLE(234, 10'b0001001010);
        SET_CLAUSE_TABLE(235, 10'b0001011001);
        SET_CLAUSE_TABLE(236, 10'b0001110010);
        SET_CLAUSE_TABLE(237, 10'b0010001010);
        SET_CLAUSE_TABLE(238, 10'b0010011111);
        SET_CLAUSE_TABLE(239, 10'b0010110111);
        SET_CLAUSE_TABLE(240, 10'b0010111011);
        SET_CLAUSE_TABLE(241, 10'b0010111111);
        SET_CLAUSE_TABLE(242, 10'b0011001001);
        SET_CLAUSE_TABLE(243, 10'b0011001011);
        SET_CLAUSE_TABLE(244, 10'b0011010000);
        SET_CLAUSE_TABLE(245, 10'b0011011010);
        SET_CLAUSE_TABLE(246, 10'b0000000110);
        SET_CLAUSE_TABLE(247, 10'b0000010111);
        SET_CLAUSE_TABLE(248, 10'b0000100000);
        SET_CLAUSE_TABLE(249, 10'b0000110100);
        SET_CLAUSE_TABLE(250, 10'b0001000110);
        SET_CLAUSE_TABLE(251, 10'b0001010000);
        SET_CLAUSE_TABLE(252, 10'b0001101100);
        SET_CLAUSE_TABLE(253, 10'b0001110111);
        SET_CLAUSE_TABLE(254, 10'b0001111110);
        SET_CLAUSE_TABLE(255, 10'b0010100000);
        SET_CLAUSE_TABLE(256, 10'b0010110101);
        SET_CLAUSE_TABLE(257, 10'b0000111100);
        SET_CLAUSE_TABLE(258, 10'b0001000011);
        SET_CLAUSE_TABLE(259, 10'b0001000100);
        SET_CLAUSE_TABLE(260, 10'b0001001111);
        SET_CLAUSE_TABLE(261, 10'b0010000000);
        SET_CLAUSE_TABLE(262, 10'b0010001001);
        SET_CLAUSE_TABLE(263, 10'b0010001110);
        SET_CLAUSE_TABLE(264, 10'b0010010111);
        SET_CLAUSE_TABLE(265, 10'b0010101100);
        SET_CLAUSE_TABLE(266, 10'b0010110110);
        SET_CLAUSE_TABLE(267, 10'b0000000010);
        SET_CLAUSE_TABLE(268, 10'b0000000100);
        SET_CLAUSE_TABLE(269, 10'b0000001011);
        SET_CLAUSE_TABLE(270, 10'b0000101101);
        SET_CLAUSE_TABLE(271, 10'b0000110001);
        SET_CLAUSE_TABLE(272, 10'b0000111111);
        SET_CLAUSE_TABLE(273, 10'b0001001001);
        SET_CLAUSE_TABLE(274, 10'b0001001110);
        SET_CLAUSE_TABLE(275, 10'b0001010010);
        SET_CLAUSE_TABLE(276, 10'b0001010011);
        SET_CLAUSE_TABLE(277, 10'b0001011011);
        SET_CLAUSE_TABLE(278, 10'b0001110100);
        SET_CLAUSE_TABLE(279, 10'b0010000100);
        SET_CLAUSE_TABLE(280, 10'b0010010101);
        SET_CLAUSE_TABLE(281, 10'b0010011011);
        SET_CLAUSE_TABLE(282, 10'b0010011110);
        SET_CLAUSE_TABLE(283, 10'b0010100111);
        SET_CLAUSE_TABLE(284, 10'b0010101111);
        SET_CLAUSE_TABLE(285, 10'b0010111010);
        SET_CLAUSE_TABLE(286, 10'b0000000101);
        SET_CLAUSE_TABLE(287, 10'b0000010011);
        SET_CLAUSE_TABLE(288, 10'b0000011011);
        SET_CLAUSE_TABLE(289, 10'b0000100001);
        SET_CLAUSE_TABLE(290, 10'b0000100010);
        SET_CLAUSE_TABLE(291, 10'b0001000111);
        SET_CLAUSE_TABLE(292, 10'b0001011101);
        SET_CLAUSE_TABLE(293, 10'b0010111111);
        SET_CLAUSE_TABLE(294, 10'b0011010100);
        SET_CLAUSE_TABLE(295, 10'b0000010011);
        SET_CLAUSE_TABLE(296, 10'b0000100101);
        SET_CLAUSE_TABLE(297, 10'b0000101000);
        SET_CLAUSE_TABLE(298, 10'b0000101011);
        SET_CLAUSE_TABLE(299, 10'b0000110101);
        SET_CLAUSE_TABLE(300, 10'b0001010101);
        SET_CLAUSE_TABLE(301, 10'b0001011000);
        SET_CLAUSE_TABLE(302, 10'b0001100000);
        SET_CLAUSE_TABLE(303, 10'b0001111011);
        SET_CLAUSE_TABLE(304, 10'b0010010001);
        SET_CLAUSE_TABLE(305, 10'b0010111100);
        SET_CLAUSE_TABLE(306, 10'b0011011001);
        SET_CLAUSE_TABLE(307, 10'b0000011000);
        SET_CLAUSE_TABLE(308, 10'b0000101111);
        SET_CLAUSE_TABLE(309, 10'b0001010001);
        SET_CLAUSE_TABLE(310, 10'b0001011110);
        SET_CLAUSE_TABLE(311, 10'b0001100111);
        SET_CLAUSE_TABLE(312, 10'b0001111010);
        SET_CLAUSE_TABLE(313, 10'b0001111011);
        SET_CLAUSE_TABLE(314, 10'b0001111110);
        SET_CLAUSE_TABLE(315, 10'b0010000011);
        SET_CLAUSE_TABLE(316, 10'b0010000111);
        SET_CLAUSE_TABLE(317, 10'b0010010001);
        SET_CLAUSE_TABLE(318, 10'b0010010011);
        SET_CLAUSE_TABLE(319, 10'b0010011000);
        SET_CLAUSE_TABLE(320, 10'b0010011110);
        SET_CLAUSE_TABLE(321, 10'b0010110000);
        SET_CLAUSE_TABLE(322, 10'b0011000001);
        SET_CLAUSE_TABLE(323, 10'b0011001010);
        SET_CLAUSE_TABLE(324, 10'b0011001111);
        SET_CLAUSE_TABLE(325, 10'b0011010101);
        SET_CLAUSE_TABLE(326, 10'b0000000111);
        SET_CLAUSE_TABLE(327, 10'b0000001101);
        SET_CLAUSE_TABLE(328, 10'b0000010110);
        SET_CLAUSE_TABLE(329, 10'b0000011100);
        SET_CLAUSE_TABLE(330, 10'b0000100010);
        SET_CLAUSE_TABLE(331, 10'b0000100011);
        SET_CLAUSE_TABLE(332, 10'b0000111001);
        SET_CLAUSE_TABLE(333, 10'b0001011010);
        SET_CLAUSE_TABLE(334, 10'b0001101100);
        SET_CLAUSE_TABLE(335, 10'b0001110010);
        SET_CLAUSE_TABLE(336, 10'b0001111101);
        SET_CLAUSE_TABLE(337, 10'b0010001011);
        SET_CLAUSE_TABLE(338, 10'b0010101000);
        SET_CLAUSE_TABLE(339, 10'b0010110100);
        SET_CLAUSE_TABLE(340, 10'b0010111000);
        SET_CLAUSE_TABLE(341, 10'b0011001010);
        SET_CLAUSE_TABLE(342, 10'b0000001100);
        SET_CLAUSE_TABLE(343, 10'b0000010110);
        SET_CLAUSE_TABLE(344, 10'b0000011011);
        SET_CLAUSE_TABLE(345, 10'b0001001001);
        SET_CLAUSE_TABLE(346, 10'b0001001101);
        SET_CLAUSE_TABLE(347, 10'b0001010100);
        SET_CLAUSE_TABLE(348, 10'b0001011011);
        SET_CLAUSE_TABLE(349, 10'b0001101111);
        SET_CLAUSE_TABLE(350, 10'b0001111111);
        SET_CLAUSE_TABLE(351, 10'b0010001100);
        SET_CLAUSE_TABLE(352, 10'b0010100010);
        SET_CLAUSE_TABLE(353, 10'b0010100011);
        SET_CLAUSE_TABLE(354, 10'b0010110100);
        SET_CLAUSE_TABLE(355, 10'b0010111001);
        SET_CLAUSE_TABLE(356, 10'b0011001110);
        SET_CLAUSE_TABLE(357, 10'b0011010101);
        SET_CLAUSE_TABLE(358, 10'b0000000111);
        SET_CLAUSE_TABLE(359, 10'b0000001000);
        SET_CLAUSE_TABLE(360, 10'b0000100000);
        SET_CLAUSE_TABLE(361, 10'b0000101010);
        SET_CLAUSE_TABLE(362, 10'b0000110011);
        SET_CLAUSE_TABLE(363, 10'b0000111010);
        SET_CLAUSE_TABLE(364, 10'b0001000100);
        SET_CLAUSE_TABLE(365, 10'b0001001011);
        SET_CLAUSE_TABLE(366, 10'b0001010111);
        SET_CLAUSE_TABLE(367, 10'b0001011101);
        SET_CLAUSE_TABLE(368, 10'b0001101100);
        SET_CLAUSE_TABLE(369, 10'b0001111011);
        SET_CLAUSE_TABLE(370, 10'b0010010000);
        SET_CLAUSE_TABLE(371, 10'b0010011001);
        SET_CLAUSE_TABLE(372, 10'b0010011110);
        SET_CLAUSE_TABLE(373, 10'b0010110001);
        SET_CLAUSE_TABLE(374, 10'b0011000110);
        SET_CLAUSE_TABLE(375, 10'b0011001110);
        SET_CLAUSE_TABLE(376, 10'b0011011000);
        SET_CLAUSE_TABLE(377, 10'b0011011010);
        SET_CLAUSE_TABLE(378, 10'b0000001001);
        SET_CLAUSE_TABLE(379, 10'b0000001011);
        SET_CLAUSE_TABLE(380, 10'b0000010010);
        SET_CLAUSE_TABLE(381, 10'b0000110010);
        SET_CLAUSE_TABLE(382, 10'b0000111010);
        SET_CLAUSE_TABLE(383, 10'b0000111110);
        SET_CLAUSE_TABLE(384, 10'b0001000101);
        SET_CLAUSE_TABLE(385, 10'b0001010010);
        SET_CLAUSE_TABLE(386, 10'b0001010101);
        SET_CLAUSE_TABLE(387, 10'b0001011100);
        SET_CLAUSE_TABLE(388, 10'b0001100000);
        SET_CLAUSE_TABLE(389, 10'b0001110111);
        SET_CLAUSE_TABLE(390, 10'b0010000001);
        SET_CLAUSE_TABLE(391, 10'b0010001010);
        SET_CLAUSE_TABLE(392, 10'b0010110000);
        SET_CLAUSE_TABLE(393, 10'b0011001101);
        SET_CLAUSE_TABLE(394, 10'b0011010000);
        SET_CLAUSE_TABLE(395, 10'b0000001010);
        SET_CLAUSE_TABLE(396, 10'b0000110101);
        SET_CLAUSE_TABLE(397, 10'b0000111011);
        SET_CLAUSE_TABLE(398, 10'b0001011001);
        SET_CLAUSE_TABLE(399, 10'b0001101000);
        SET_CLAUSE_TABLE(400, 10'b0010000110);
        SET_CLAUSE_TABLE(401, 10'b0011000000);
        SET_CLAUSE_TABLE(402, 10'b0011001000);
        SET_CLAUSE_TABLE(403, 10'b0011010010);
        SET_CLAUSE_TABLE(404, 10'b0011011000);
        SET_CLAUSE_TABLE(405, 10'b0000010001);
        SET_CLAUSE_TABLE(406, 10'b0000101111);
        SET_CLAUSE_TABLE(407, 10'b0001011111);
        SET_CLAUSE_TABLE(408, 10'b0001110000);
        SET_CLAUSE_TABLE(409, 10'b0001110110);
        SET_CLAUSE_TABLE(410, 10'b0010010111);
        SET_CLAUSE_TABLE(411, 10'b0010011011);
        SET_CLAUSE_TABLE(412, 10'b0000001000);
        SET_CLAUSE_TABLE(413, 10'b0000100011);
        SET_CLAUSE_TABLE(414, 10'b0000100100);
        SET_CLAUSE_TABLE(415, 10'b0001000001);
        SET_CLAUSE_TABLE(416, 10'b0001000101);
        SET_CLAUSE_TABLE(417, 10'b0001011011);
        SET_CLAUSE_TABLE(418, 10'b0001100111);
        SET_CLAUSE_TABLE(419, 10'b0001101101);
        SET_CLAUSE_TABLE(420, 10'b0001110110);
        SET_CLAUSE_TABLE(421, 10'b0010000011);
        SET_CLAUSE_TABLE(422, 10'b0010000100);
        SET_CLAUSE_TABLE(423, 10'b0010101001);
        SET_CLAUSE_TABLE(424, 10'b0010101010);
        SET_CLAUSE_TABLE(425, 10'b0010110000);
        SET_CLAUSE_TABLE(426, 10'b0011000100);
        SET_CLAUSE_TABLE(427, 10'b0011000110);
        SET_CLAUSE_TABLE(428, 10'b0011010001);
        SET_CLAUSE_TABLE(429, 10'b0000001111);
        SET_CLAUSE_TABLE(430, 10'b0000010000);
        SET_CLAUSE_TABLE(431, 10'b0000011100);
        SET_CLAUSE_TABLE(432, 10'b0000101001);
        SET_CLAUSE_TABLE(433, 10'b0000110110);
        SET_CLAUSE_TABLE(434, 10'b0000111001);
        SET_CLAUSE_TABLE(435, 10'b0001001110);
        SET_CLAUSE_TABLE(436, 10'b0010010110);
        SET_CLAUSE_TABLE(437, 10'b0010100110);
        SET_CLAUSE_TABLE(438, 10'b0010100111);
        SET_CLAUSE_TABLE(439, 10'b0010101010);
        SET_CLAUSE_TABLE(440, 10'b0010110011);
        SET_CLAUSE_TABLE(441, 10'b0011000000);
        SET_CLAUSE_TABLE(442, 10'b0011000100);
        SET_CLAUSE_TABLE(443, 10'b0000010000);
        SET_CLAUSE_TABLE(444, 10'b0000010100);
        SET_CLAUSE_TABLE(445, 10'b0000110100);
        SET_CLAUSE_TABLE(446, 10'b0001000011);
        SET_CLAUSE_TABLE(447, 10'b0001011110);
        SET_CLAUSE_TABLE(448, 10'b0001101101);
        SET_CLAUSE_TABLE(449, 10'b0010000101);
        SET_CLAUSE_TABLE(450, 10'b0010001111);
        SET_CLAUSE_TABLE(451, 10'b0010101001);
        SET_CLAUSE_TABLE(452, 10'b0000000011);
        SET_CLAUSE_TABLE(453, 10'b0000010001);
        SET_CLAUSE_TABLE(454, 10'b0000111011);
        SET_CLAUSE_TABLE(455, 10'b0001001001);
        SET_CLAUSE_TABLE(456, 10'b0001110010);
        SET_CLAUSE_TABLE(457, 10'b0001111101);
        SET_CLAUSE_TABLE(458, 10'b0010000101);
        SET_CLAUSE_TABLE(459, 10'b0010101011);
        SET_CLAUSE_TABLE(460, 10'b0001000000);
        SET_CLAUSE_TABLE(461, 10'b0001001100);
        SET_CLAUSE_TABLE(462, 10'b0001010110);
        SET_CLAUSE_TABLE(463, 10'b0001110001);
        SET_CLAUSE_TABLE(464, 10'b0010001101);
        SET_CLAUSE_TABLE(465, 10'b0010100100);
        SET_CLAUSE_TABLE(466, 10'b0011001101);
        SET_CLAUSE_TABLE(467, 10'b0000000101);
        SET_CLAUSE_TABLE(468, 10'b0000100110);
        SET_CLAUSE_TABLE(469, 10'b0000110111);
        SET_CLAUSE_TABLE(470, 10'b0000111000);
        SET_CLAUSE_TABLE(471, 10'b0000111110);
        SET_CLAUSE_TABLE(472, 10'b0001011110);
        SET_CLAUSE_TABLE(473, 10'b0001100100);
        SET_CLAUSE_TABLE(474, 10'b0001101000);
        SET_CLAUSE_TABLE(475, 10'b0001111101);
        SET_CLAUSE_TABLE(476, 10'b0010001111);
        SET_CLAUSE_TABLE(477, 10'b0010011010);
        SET_CLAUSE_TABLE(478, 10'b0010101101);
        SET_CLAUSE_TABLE(479, 10'b0010110010);
        SET_CLAUSE_TABLE(480, 10'b0011000011);
        SET_CLAUSE_TABLE(481, 10'b0011010110);
        SET_CLAUSE_TABLE(482, 10'b0011011001);
        SET_CLAUSE_TABLE(483, 10'b0000000001);
        SET_CLAUSE_TABLE(484, 10'b0000001111);
        SET_CLAUSE_TABLE(485, 10'b0000010101);
        SET_CLAUSE_TABLE(486, 10'b0000011000);
        SET_CLAUSE_TABLE(487, 10'b0000101001);
        SET_CLAUSE_TABLE(488, 10'b0001000110);
        SET_CLAUSE_TABLE(489, 10'b0001001111);
        SET_CLAUSE_TABLE(490, 10'b0001011010);
        SET_CLAUSE_TABLE(491, 10'b0001100101);
        SET_CLAUSE_TABLE(492, 10'b0001110011);
        SET_CLAUSE_TABLE(493, 10'b0010000000);
        SET_CLAUSE_TABLE(494, 10'b0010000111);
        SET_CLAUSE_TABLE(495, 10'b0010011100);
        SET_CLAUSE_TABLE(496, 10'b0010100101);
        SET_CLAUSE_TABLE(497, 10'b0010101101);
        SET_CLAUSE_TABLE(498, 10'b0010111110);
        SET_CLAUSE_TABLE(499, 10'b0011010001);
        SET_CLAUSE_TABLE(500, 10'b0011010110);
        SET_CLAUSE_TABLE(501, 10'b0000001011);
        SET_CLAUSE_TABLE(502, 10'b0000001101);
        SET_CLAUSE_TABLE(503, 10'b0000101010);
        SET_CLAUSE_TABLE(504, 10'b0001100110);
        SET_CLAUSE_TABLE(505, 10'b0010000010);
        SET_CLAUSE_TABLE(506, 10'b0010000111);
        SET_CLAUSE_TABLE(507, 10'b0010001010);
        SET_CLAUSE_TABLE(508, 10'b0011001100);
        SET_CLAUSE_TABLE(509, 10'b0000000010);
        SET_CLAUSE_TABLE(510, 10'b0000010010);
        SET_CLAUSE_TABLE(511, 10'b0000011001);
        SET_CLAUSE_TABLE(512, 10'b0000011101);
        SET_CLAUSE_TABLE(513, 10'b0000011110);
        SET_CLAUSE_TABLE(514, 10'b0001100110);
        SET_CLAUSE_TABLE(515, 10'b0001110001);
        SET_CLAUSE_TABLE(516, 10'b0010000010);
        SET_CLAUSE_TABLE(517, 10'b0010010100);
        SET_CLAUSE_TABLE(518, 10'b0010100001);
        SET_CLAUSE_TABLE(519, 10'b0010101101);
        SET_CLAUSE_TABLE(520, 10'b0010111011);
        SET_CLAUSE_TABLE(521, 10'b0010111110);
        SET_CLAUSE_TABLE(522, 10'b0011000010);
        SET_CLAUSE_TABLE(523, 10'b0011001000);
        SET_CLAUSE_TABLE(524, 10'b0011001011);
        SET_CLAUSE_TABLE(525, 10'b0011001101);
        SET_CLAUSE_TABLE(526, 10'b0000000010);
        SET_CLAUSE_TABLE(527, 10'b0001000011);
        SET_CLAUSE_TABLE(528, 10'b0001000110);
        SET_CLAUSE_TABLE(529, 10'b0001000111);
        SET_CLAUSE_TABLE(530, 10'b0001100101);
        SET_CLAUSE_TABLE(531, 10'b0001110100);
        SET_CLAUSE_TABLE(532, 10'b0010001000);
        SET_CLAUSE_TABLE(533, 10'b0010101011);
        SET_CLAUSE_TABLE(534, 10'b0010110010);
        SET_CLAUSE_TABLE(535, 10'b0010111010);
        SET_CLAUSE_TABLE(536, 10'b0011010111);
        SET_CLAUSE_TABLE(537, 10'b0011011000);
        SET_CLAUSE_TABLE(538, 10'b0000011010);
        SET_CLAUSE_TABLE(539, 10'b0000100001);
        SET_CLAUSE_TABLE(540, 10'b0000110100);
        SET_CLAUSE_TABLE(541, 10'b0000111101);
        SET_CLAUSE_TABLE(542, 10'b0001001000);
        SET_CLAUSE_TABLE(543, 10'b0001001100);
        SET_CLAUSE_TABLE(544, 10'b0010010101);
        SET_CLAUSE_TABLE(545, 10'b0010110111);
        SET_CLAUSE_TABLE(546, 10'b0000011101);
        SET_CLAUSE_TABLE(547, 10'b0000101101);
        SET_CLAUSE_TABLE(548, 10'b0000110001);
        SET_CLAUSE_TABLE(549, 10'b0000110111);
        SET_CLAUSE_TABLE(550, 10'b0001010100);
        SET_CLAUSE_TABLE(551, 10'b0001011100);
        SET_CLAUSE_TABLE(552, 10'b0001100010);
        SET_CLAUSE_TABLE(553, 10'b0001110100);
        SET_CLAUSE_TABLE(554, 10'b0001111000);
        SET_CLAUSE_TABLE(555, 10'b0010010100);
        SET_CLAUSE_TABLE(556, 10'b0010011000);
        SET_CLAUSE_TABLE(557, 10'b0010110101);
        SET_CLAUSE_TABLE(558, 10'b0010111101);
        SET_CLAUSE_TABLE(559, 10'b0000100100);
        SET_CLAUSE_TABLE(560, 10'b0000110011);
        SET_CLAUSE_TABLE(561, 10'b0000110110);
        SET_CLAUSE_TABLE(562, 10'b0000111001);
        SET_CLAUSE_TABLE(563, 10'b0001000100);
        SET_CLAUSE_TABLE(564, 10'b0001101001);
        SET_CLAUSE_TABLE(565, 10'b0010000000);
        SET_CLAUSE_TABLE(566, 10'b0010000001);
        SET_CLAUSE_TABLE(567, 10'b0010011010);
        SET_CLAUSE_TABLE(568, 10'b0010111000);
        SET_CLAUSE_TABLE(569, 10'b0000010011);
        SET_CLAUSE_TABLE(570, 10'b0000010101);
        SET_CLAUSE_TABLE(571, 10'b0000101001);
        SET_CLAUSE_TABLE(572, 10'b0000101010);
        SET_CLAUSE_TABLE(573, 10'b0001010111);
        SET_CLAUSE_TABLE(574, 10'b0001111001);
        SET_CLAUSE_TABLE(575, 10'b0010000101);
        SET_CLAUSE_TABLE(576, 10'b0010110001);
        SET_CLAUSE_TABLE(577, 10'b0011000010);
        SET_CLAUSE_TABLE(578, 10'b0011011010);
        SET_CLAUSE_TABLE(579, 10'b0000000001);
        SET_CLAUSE_TABLE(580, 10'b0000011001);
        SET_CLAUSE_TABLE(581, 10'b0000011110);
        SET_CLAUSE_TABLE(582, 10'b0000100011);
        SET_CLAUSE_TABLE(583, 10'b0000100101);
        SET_CLAUSE_TABLE(584, 10'b0001111100);
        SET_CLAUSE_TABLE(585, 10'b0010001110);
        SET_CLAUSE_TABLE(586, 10'b0010010011);
        SET_CLAUSE_TABLE(587, 10'b0010010110);
        SET_CLAUSE_TABLE(588, 10'b0010101000);
        SET_CLAUSE_TABLE(589, 10'b0011000011);
        SET_CLAUSE_TABLE(590, 10'b0011010010);
        SET_CLAUSE_TABLE(591, 10'b0011011001);
        SET_CLAUSE_TABLE(592, 10'b0000000110);
        SET_CLAUSE_TABLE(593, 10'b0000010000);
        SET_CLAUSE_TABLE(594, 10'b0000111000);
        SET_CLAUSE_TABLE(595, 10'b0001001010);
        SET_CLAUSE_TABLE(596, 10'b0001010011);
        SET_CLAUSE_TABLE(597, 10'b0001101001);
        SET_CLAUSE_TABLE(598, 10'b0010000010);
        SET_CLAUSE_TABLE(599, 10'b0010010000);
        SET_CLAUSE_TABLE(600, 10'b0010101110);
        SET_CLAUSE_TABLE(601, 10'b0010110001);
        SET_CLAUSE_TABLE(602, 10'b0011000111);
        SET_CLAUSE_TABLE(603, 10'b0011001000);
        SET_CLAUSE_TABLE(604, 10'b0011001001);
        SET_CLAUSE_TABLE(605, 10'b0000100100);
        SET_CLAUSE_TABLE(606, 10'b0000101110);
        SET_CLAUSE_TABLE(607, 10'b0001010110);
        SET_CLAUSE_TABLE(608, 10'b0010001101);
        SET_CLAUSE_TABLE(609, 10'b0010011100);
        SET_CLAUSE_TABLE(610, 10'b0010101110);
        SET_CLAUSE_TABLE(611, 10'b0010110111);
        SET_CLAUSE_TABLE(612, 10'b0010111011);
        SET_CLAUSE_TABLE(613, 10'b0010111100);
        SET_CLAUSE_TABLE(614, 10'b0011010100);
        SET_CLAUSE_TABLE(615, 10'b0000000111);
        SET_CLAUSE_TABLE(616, 10'b0000001010);
        SET_CLAUSE_TABLE(617, 10'b0000001100);
        SET_CLAUSE_TABLE(618, 10'b0000110010);
        SET_CLAUSE_TABLE(619, 10'b0000111101);
        SET_CLAUSE_TABLE(620, 10'b0001010000);
        SET_CLAUSE_TABLE(621, 10'b0001010001);
        SET_CLAUSE_TABLE(622, 10'b0001010011);
        SET_CLAUSE_TABLE(623, 10'b0001100001);
        SET_CLAUSE_TABLE(624, 10'b0001100010);
        SET_CLAUSE_TABLE(625, 10'b0001101010);
        SET_CLAUSE_TABLE(626, 10'b0001111000);
        SET_CLAUSE_TABLE(627, 10'b0010011101);
        SET_CLAUSE_TABLE(628, 10'b0010101111);
        SET_CLAUSE_TABLE(629, 10'b0010110011);
        SET_CLAUSE_TABLE(630, 10'b0010111100);
        SET_CLAUSE_TABLE(631, 10'b0010111101);
        SET_CLAUSE_TABLE(632, 10'b0011000000);
        SET_CLAUSE_TABLE(633, 10'b0011010011);
        SET_CLAUSE_TABLE(634, 10'b0000011001);
        SET_CLAUSE_TABLE(635, 10'b0000110010);
        SET_CLAUSE_TABLE(636, 10'b0001001111);
        SET_CLAUSE_TABLE(637, 10'b0001100010);
        SET_CLAUSE_TABLE(638, 10'b0001110001);
        SET_CLAUSE_TABLE(639, 10'b0001110011);
        SET_CLAUSE_TABLE(640, 10'b0010010110);
        SET_CLAUSE_TABLE(641, 10'b0010100000);
        SET_CLAUSE_TABLE(642, 10'b0000001110);
        SET_CLAUSE_TABLE(643, 10'b0000010110);
        SET_CLAUSE_TABLE(644, 10'b0001000010);
        SET_CLAUSE_TABLE(645, 10'b0001100111);
        SET_CLAUSE_TABLE(646, 10'b0001101011);
        SET_CLAUSE_TABLE(647, 10'b0001101101);
        SET_CLAUSE_TABLE(648, 10'b0010000011);
        SET_CLAUSE_TABLE(649, 10'b0010000110);
        SET_CLAUSE_TABLE(650, 10'b0010011001);
        SET_CLAUSE_TABLE(651, 10'b0010111001);
        SET_CLAUSE_TABLE(652, 10'b0011000101);
        SET_CLAUSE_TABLE(653, 10'b0011001111);




        @(negedge clock);
        clock = 0;
        reset = 1;
        max_var_test = 50;
        bcp_busy_test = 0;
        push_imply_test = 0;
        read_vs_test = 0;
        push_trace_test = 0;

        @(negedge clock);

        $display("\nStart Solver at IDLE");

        reset = 0;
        start = 1;
        SHOW_DEBUG();
        @(negedge clock);
        start = 0;
        SHOW_DEBUG();
        @(negedge clock);

        while (!unsat && !sat) begin
            // SHOW_DEBUG();
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
        for (integer i = 0; i < max_var_test+2; i = i+1) begin
            read_vs_test = 1;
            var_in_vs_test = i+1;
            $display("var%0d = %0b, (sanity check) assigned = %0b",i, val_out_vs, ~unassign_out_vs);
            @(negedge clock);
        end

        // bcp_busy_test = 1;
        // @(negedge clock);
        // bcp_busy_test = 0;

        $finish;
    end
endmodule