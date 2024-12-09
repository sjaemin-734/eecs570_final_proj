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
    logic [`MAX_VARS-1:0][`MAX_VARS_BITS:0] decide_config;      // {var_id, val}
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

    task SET_DECIDER;
        input [`MAX_VARS_BITS-1:0] config_index;
        input [`MAX_VARS_BITS:0] file_input_line;
        begin
            decide_config[config_index] = file_input_line;
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

        var_idx_d = decide_config[dec_idx_d_in][`MAX_VARS_BITS:1];
        val_d = decide_config[dec_idx_d_in][0];


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

        $display("\nReset");
        // Reset test
        @(negedge clock);
        RESET_RAMS();
        @(negedge clock);
        

        // SET VAR START END TABLE
        SET_VAR_START_END_TABLE(0, 26'b00000000000000000000000000);
        SET_VAR_START_END_TABLE(1, 26'b00000000000000000000000111);
        SET_VAR_START_END_TABLE(2, 26'b00000000001110000000001110);
        SET_VAR_START_END_TABLE(3, 26'b00000000011100000000010101);
        SET_VAR_START_END_TABLE(4, 26'b00000000101010000000011100);
        SET_VAR_START_END_TABLE(5, 26'b00000000111000000000100011);
        SET_VAR_START_END_TABLE(6, 26'b00000001000110000000101010);
        SET_VAR_START_END_TABLE(7, 26'b00000001010100000000110001);
        SET_VAR_START_END_TABLE(8, 26'b00000001100010000000111000);
        SET_VAR_START_END_TABLE(9, 26'b00000001110000000000111111);
        SET_VAR_START_END_TABLE(10, 26'b00000001111110000001000110);
        SET_VAR_START_END_TABLE(11, 26'b00000010001100000001001101);
        SET_VAR_START_END_TABLE(12, 26'b00000010011010000001010100);
        SET_VAR_START_END_TABLE(13, 26'b00000010101000000001011011);
        SET_VAR_START_END_TABLE(14, 26'b00000010110110000001100010);
        SET_VAR_START_END_TABLE(15, 26'b00000011000100000001101001);
        SET_VAR_START_END_TABLE(16, 26'b00000011010010000001110000);
        SET_VAR_START_END_TABLE(17, 26'b00000011100000000001110111);
        SET_VAR_START_END_TABLE(18, 26'b00000011101110000001111110);
        SET_VAR_START_END_TABLE(19, 26'b00000011111100000010000101);
        SET_VAR_START_END_TABLE(20, 26'b00000100001010000010001100);
        SET_VAR_START_END_TABLE(21, 26'b00000100011000000010010011);
        SET_VAR_START_END_TABLE(22, 26'b00000100100110000010011010);
        SET_VAR_START_END_TABLE(23, 26'b00000100110100000010100001);
        SET_VAR_START_END_TABLE(24, 26'b00000101000010000010101000);
        SET_VAR_START_END_TABLE(25, 26'b00000101010000000010101111);
        SET_VAR_START_END_TABLE(26, 26'b00000101011110000010110110);
        SET_VAR_START_END_TABLE(27, 26'b00000101101100000010111101);
        SET_VAR_START_END_TABLE(28, 26'b00000101111010000011000100);
        SET_VAR_START_END_TABLE(29, 26'b00000110001000000011001011);
        SET_VAR_START_END_TABLE(30, 26'b00000110010110000011010010);
        SET_VAR_START_END_TABLE(31, 26'b00000110100100000011011001);
        SET_VAR_START_END_TABLE(32, 26'b00000110110010000011100000);
        SET_VAR_START_END_TABLE(33, 26'b00000111000000000011100111);
        SET_VAR_START_END_TABLE(34, 26'b00000111001110000011101110);
        SET_VAR_START_END_TABLE(35, 26'b00000111011100000011110101);
        SET_VAR_START_END_TABLE(36, 26'b00000111101010000011111100);
        SET_VAR_START_END_TABLE(37, 26'b00000111111000000100000011);
        SET_VAR_START_END_TABLE(38, 26'b00001000000110000100001010);
        SET_VAR_START_END_TABLE(39, 26'b00001000010100000100010001);
        SET_VAR_START_END_TABLE(40, 26'b00001000100010000100011000);
        SET_VAR_START_END_TABLE(41, 26'b00001000110000000100011111);
        SET_VAR_START_END_TABLE(42, 26'b00001000111110000100100110);
        SET_VAR_START_END_TABLE(43, 26'b00001001001100000100101000);
        SET_VAR_START_END_TABLE(44, 26'b00001001010000000100101010);
        SET_VAR_START_END_TABLE(45, 26'b00001001010100000100101100);
        SET_VAR_START_END_TABLE(46, 26'b00001001011000000100101110);
        SET_VAR_START_END_TABLE(47, 26'b00001001011100000100110000);
        SET_VAR_START_END_TABLE(48, 26'b00001001100000000100110010);
        SET_VAR_START_END_TABLE(49, 26'b00001001100100000100110100);

        // SET CLAUSE DATABASE
        SET_CLAUSE_DATABASE(0, 55'b0000000000000000000000000000000000000000000000000000000);
        SET_CLAUSE_DATABASE(1, 55'b1100011111000000001000000111000000000000000000000000000);
        SET_CLAUSE_DATABASE(2, 55'b1100011111000000001000001101000000000000000000000000000);
        SET_CLAUSE_DATABASE(3, 55'b1100011111000000001000010011000000000000000000000000000);
        SET_CLAUSE_DATABASE(4, 55'b1100011111000000001000011001000000000000000000000000000);
        SET_CLAUSE_DATABASE(5, 55'b1100011111000000001000011111000000000000000000000000000);
        SET_CLAUSE_DATABASE(6, 55'b1100011111000000001000100101000000000000000000000000000);
        SET_CLAUSE_DATABASE(7, 55'b1100011111000000111000001101000000000000000000000000000);
        SET_CLAUSE_DATABASE(8, 55'b1100011111000000111000010011000000000000000000000000000);
        SET_CLAUSE_DATABASE(9, 55'b1100011111000000111000011001000000000000000000000000000);
        SET_CLAUSE_DATABASE(10, 55'b1100011111000000111000011111000000000000000000000000000);
        SET_CLAUSE_DATABASE(11, 55'b1100011111000000111000100101000000000000000000000000000);
        SET_CLAUSE_DATABASE(12, 55'b1100011111000001101000010011000000000000000000000000000);
        SET_CLAUSE_DATABASE(13, 55'b1100011111000001101000011001000000000000000000000000000);
        SET_CLAUSE_DATABASE(14, 55'b1100011111000001101000011111000000000000000000000000000);
        SET_CLAUSE_DATABASE(15, 55'b1100011111000001101000100101000000000000000000000000000);
        SET_CLAUSE_DATABASE(16, 55'b1100011111000010011000011001000000000000000000000000000);
        SET_CLAUSE_DATABASE(17, 55'b1100011111000010011000011111000000000000000000000000000);
        SET_CLAUSE_DATABASE(18, 55'b1100011111000010011000100101000000000000000000000000000);
        SET_CLAUSE_DATABASE(19, 55'b1100011111000011001000011111000000000000000000000000000);
        SET_CLAUSE_DATABASE(20, 55'b1100011111000011001000100101000000000000000000000000000);
        SET_CLAUSE_DATABASE(21, 55'b1100011111000011111000100101000000000000000000000000000);
        SET_CLAUSE_DATABASE(22, 55'b1100011111000000010000001000000000000000000000000000000);
        SET_CLAUSE_DATABASE(23, 55'b1100011111000000010000001110000000000000000000000000000);
        SET_CLAUSE_DATABASE(24, 55'b1100011111000000010000010100000000000000000000000000000);
        SET_CLAUSE_DATABASE(25, 55'b1100011111000000010000011010000000000000000000000000000);
        SET_CLAUSE_DATABASE(26, 55'b1100011111000000010000100000000000000000000000000000000);
        SET_CLAUSE_DATABASE(27, 55'b1100011111000000010000100110000000000000000000000000000);
        SET_CLAUSE_DATABASE(28, 55'b1100011111000001000000001110000000000000000000000000000);
        SET_CLAUSE_DATABASE(29, 55'b1100011111000001000000010100000000000000000000000000000);
        SET_CLAUSE_DATABASE(30, 55'b1100011111000001000000011010000000000000000000000000000);
        SET_CLAUSE_DATABASE(31, 55'b1100011111000001000000100000000000000000000000000000000);
        SET_CLAUSE_DATABASE(32, 55'b1100011111000001000000100110000000000000000000000000000);
        SET_CLAUSE_DATABASE(33, 55'b1100011111000001110000010100000000000000000000000000000);
        SET_CLAUSE_DATABASE(34, 55'b1100011111000001110000011010000000000000000000000000000);
        SET_CLAUSE_DATABASE(35, 55'b1100011111000001110000100000000000000000000000000000000);
        SET_CLAUSE_DATABASE(36, 55'b1100011111000001110000100110000000000000000000000000000);
        SET_CLAUSE_DATABASE(37, 55'b1100011111000010100000011010000000000000000000000000000);
        SET_CLAUSE_DATABASE(38, 55'b1100011111000010100000100000000000000000000000000000000);
        SET_CLAUSE_DATABASE(39, 55'b1100011111000010100000100110000000000000000000000000000);
        SET_CLAUSE_DATABASE(40, 55'b1100011111000011010000100000000000000000000000000000000);
        SET_CLAUSE_DATABASE(41, 55'b1100011111000011010000100110000000000000000000000000000);
        SET_CLAUSE_DATABASE(42, 55'b1100011111000100000000100110000000000000000000000000000);
        SET_CLAUSE_DATABASE(43, 55'b1100011111000000011000001001000000000000000000000000000);
        SET_CLAUSE_DATABASE(44, 55'b1100011111000000011000001111000000000000000000000000000);
        SET_CLAUSE_DATABASE(45, 55'b1100011111000000011000010101000000000000000000000000000);
        SET_CLAUSE_DATABASE(46, 55'b1100011111000000011000011011000000000000000000000000000);
        SET_CLAUSE_DATABASE(47, 55'b1100011111000000011000100001000000000000000000000000000);
        SET_CLAUSE_DATABASE(48, 55'b1100011111000000011000100111000000000000000000000000000);
        SET_CLAUSE_DATABASE(49, 55'b1100011111000001001000001111000000000000000000000000000);
        SET_CLAUSE_DATABASE(50, 55'b1100011111000001001000010101000000000000000000000000000);
        SET_CLAUSE_DATABASE(51, 55'b1100011111000001001000011011000000000000000000000000000);
        SET_CLAUSE_DATABASE(52, 55'b1100011111000001001000100001000000000000000000000000000);
        SET_CLAUSE_DATABASE(53, 55'b1100011111000001001000100111000000000000000000000000000);
        SET_CLAUSE_DATABASE(54, 55'b1100011111000001111000010101000000000000000000000000000);
        SET_CLAUSE_DATABASE(55, 55'b1100011111000001111000011011000000000000000000000000000);
        SET_CLAUSE_DATABASE(56, 55'b1100011111000001111000100001000000000000000000000000000);
        SET_CLAUSE_DATABASE(57, 55'b1100011111000001111000100111000000000000000000000000000);
        SET_CLAUSE_DATABASE(58, 55'b1100011111000010101000011011000000000000000000000000000);
        SET_CLAUSE_DATABASE(59, 55'b1100011111000010101000100001000000000000000000000000000);
        SET_CLAUSE_DATABASE(60, 55'b1100011111000010101000100111000000000000000000000000000);
        SET_CLAUSE_DATABASE(61, 55'b1100011111000011011000100001000000000000000000000000000);
        SET_CLAUSE_DATABASE(62, 55'b1100011111000011011000100111000000000000000000000000000);
        SET_CLAUSE_DATABASE(63, 55'b1100011111000100001000100111000000000000000000000000000);
        SET_CLAUSE_DATABASE(64, 55'b1100011111000000100000001010000000000000000000000000000);
        SET_CLAUSE_DATABASE(65, 55'b1100011111000000100000010000000000000000000000000000000);
        SET_CLAUSE_DATABASE(66, 55'b1100011111000000100000010110000000000000000000000000000);
        SET_CLAUSE_DATABASE(67, 55'b1100011111000000100000011100000000000000000000000000000);
        SET_CLAUSE_DATABASE(68, 55'b1100011111000000100000100010000000000000000000000000000);
        SET_CLAUSE_DATABASE(69, 55'b1100011111000000100000101000000000000000000000000000000);
        SET_CLAUSE_DATABASE(70, 55'b1100011111000001010000010000000000000000000000000000000);
        SET_CLAUSE_DATABASE(71, 55'b1100011111000001010000010110000000000000000000000000000);
        SET_CLAUSE_DATABASE(72, 55'b1100011111000001010000011100000000000000000000000000000);
        SET_CLAUSE_DATABASE(73, 55'b1100011111000001010000100010000000000000000000000000000);
        SET_CLAUSE_DATABASE(74, 55'b1100011111000001010000101000000000000000000000000000000);
        SET_CLAUSE_DATABASE(75, 55'b1100011111000010000000010110000000000000000000000000000);
        SET_CLAUSE_DATABASE(76, 55'b1100011111000010000000011100000000000000000000000000000);
        SET_CLAUSE_DATABASE(77, 55'b1100011111000010000000100010000000000000000000000000000);
        SET_CLAUSE_DATABASE(78, 55'b1100011111000010000000101000000000000000000000000000000);
        SET_CLAUSE_DATABASE(79, 55'b1100011111000010110000011100000000000000000000000000000);
        SET_CLAUSE_DATABASE(80, 55'b1100011111000010110000100010000000000000000000000000000);
        SET_CLAUSE_DATABASE(81, 55'b1100011111000010110000101000000000000000000000000000000);
        SET_CLAUSE_DATABASE(82, 55'b1100011111000011100000100010000000000000000000000000000);
        SET_CLAUSE_DATABASE(83, 55'b1100011111000011100000101000000000000000000000000000000);
        SET_CLAUSE_DATABASE(84, 55'b1100011111000100010000101000000000000000000000000000000);
        SET_CLAUSE_DATABASE(85, 55'b1100011111000000101000001011000000000000000000000000000);
        SET_CLAUSE_DATABASE(86, 55'b1100011111000000101000010001000000000000000000000000000);
        SET_CLAUSE_DATABASE(87, 55'b1100011111000000101000010111000000000000000000000000000);
        SET_CLAUSE_DATABASE(88, 55'b1100011111000000101000011101000000000000000000000000000);
        SET_CLAUSE_DATABASE(89, 55'b1100011111000000101000100011000000000000000000000000000);
        SET_CLAUSE_DATABASE(90, 55'b1100011111000000101000101001000000000000000000000000000);
        SET_CLAUSE_DATABASE(91, 55'b1100011111000001011000010001000000000000000000000000000);
        SET_CLAUSE_DATABASE(92, 55'b1100011111000001011000010111000000000000000000000000000);
        SET_CLAUSE_DATABASE(93, 55'b1100011111000001011000011101000000000000000000000000000);
        SET_CLAUSE_DATABASE(94, 55'b1100011111000001011000100011000000000000000000000000000);
        SET_CLAUSE_DATABASE(95, 55'b1100011111000001011000101001000000000000000000000000000);
        SET_CLAUSE_DATABASE(96, 55'b1100011111000010001000010111000000000000000000000000000);
        SET_CLAUSE_DATABASE(97, 55'b1100011111000010001000011101000000000000000000000000000);
        SET_CLAUSE_DATABASE(98, 55'b1100011111000010001000100011000000000000000000000000000);
        SET_CLAUSE_DATABASE(99, 55'b1100011111000010001000101001000000000000000000000000000);
        SET_CLAUSE_DATABASE(100, 55'b1100011111000010111000011101000000000000000000000000000);
        SET_CLAUSE_DATABASE(101, 55'b1100011111000010111000100011000000000000000000000000000);
        SET_CLAUSE_DATABASE(102, 55'b1100011111000010111000101001000000000000000000000000000);
        SET_CLAUSE_DATABASE(103, 55'b1100011111000011101000100011000000000000000000000000000);
        SET_CLAUSE_DATABASE(104, 55'b1100011111000011101000101001000000000000000000000000000);
        SET_CLAUSE_DATABASE(105, 55'b1100011111000100011000101001000000000000000000000000000);
        SET_CLAUSE_DATABASE(106, 55'b1100011111000000110000001100000000000000000000000000000);
        SET_CLAUSE_DATABASE(107, 55'b1100011111000000110000010010000000000000000000000000000);
        SET_CLAUSE_DATABASE(108, 55'b1100011111000000110000011000000000000000000000000000000);
        SET_CLAUSE_DATABASE(109, 55'b1100011111000000110000011110000000000000000000000000000);
        SET_CLAUSE_DATABASE(110, 55'b1100011111000000110000100100000000000000000000000000000);
        SET_CLAUSE_DATABASE(111, 55'b1100011111000000110000101010000000000000000000000000000);
        SET_CLAUSE_DATABASE(112, 55'b1100011111000001100000010010000000000000000000000000000);
        SET_CLAUSE_DATABASE(113, 55'b1100011111000001100000011000000000000000000000000000000);
        SET_CLAUSE_DATABASE(114, 55'b1100011111000001100000011110000000000000000000000000000);
        SET_CLAUSE_DATABASE(115, 55'b1100011111000001100000100100000000000000000000000000000);
        SET_CLAUSE_DATABASE(116, 55'b1100011111000001100000101010000000000000000000000000000);
        SET_CLAUSE_DATABASE(117, 55'b1100011111000010010000011000000000000000000000000000000);
        SET_CLAUSE_DATABASE(118, 55'b1100011111000010010000011110000000000000000000000000000);
        SET_CLAUSE_DATABASE(119, 55'b1100011111000010010000100100000000000000000000000000000);
        SET_CLAUSE_DATABASE(120, 55'b1100011111000010010000101010000000000000000000000000000);
        SET_CLAUSE_DATABASE(121, 55'b1100011111000011000000011110000000000000000000000000000);
        SET_CLAUSE_DATABASE(122, 55'b1100011111000011000000100100000000000000000000000000000);
        SET_CLAUSE_DATABASE(123, 55'b1100011111000011000000101010000000000000000000000000000);
        SET_CLAUSE_DATABASE(124, 55'b1100011111000011110000100100000000000000000000000000000);
        SET_CLAUSE_DATABASE(125, 55'b1100011111000011110000101010000000000000000000000000000);
        SET_CLAUSE_DATABASE(126, 55'b1100011111000100100000101010000000000000000000000000000);
        SET_CLAUSE_DATABASE(127, 55'b1111100000000000110000000101000000100000000011000101011);
        SET_CLAUSE_DATABASE(128, 55'b1110010011000101011000000010000000001000000000000000000);
        SET_CLAUSE_DATABASE(129, 55'b1111100000000001100000001011000001010000001001000101100);
        SET_CLAUSE_DATABASE(130, 55'b1110010011000101100000001000000000111000000000000000000);
        SET_CLAUSE_DATABASE(131, 55'b1111100000000010010000010001000010000000001111000101101);
        SET_CLAUSE_DATABASE(132, 55'b1110010011000101101000001110000001101000000000000000000);
        SET_CLAUSE_DATABASE(133, 55'b1111100000000011000000010111000010110000010101000101110);
        SET_CLAUSE_DATABASE(134, 55'b1110010011000101110000010100000010011000000000000000000);
        SET_CLAUSE_DATABASE(135, 55'b1111100000000011110000011101000011100000011011000101111);
        SET_CLAUSE_DATABASE(136, 55'b1110010011000101111000011010000011001000000000000000000);
        SET_CLAUSE_DATABASE(137, 55'b1111100000000100100000100011000100010000100001000110000);
        SET_CLAUSE_DATABASE(138, 55'b1110010011000110000000100000000011111000000000000000000);
        SET_CLAUSE_DATABASE(139, 55'b1111100000000101010000101001000101000000100111000110001);
        SET_CLAUSE_DATABASE(140, 55'b1110010011000110001000100110000100101000000000000000000);

        // SET CLAUSE TABLE
        SET_CLAUSE_TABLE(0, 10'b0000000001);
        SET_CLAUSE_TABLE(1, 10'b0000000010);
        SET_CLAUSE_TABLE(2, 10'b0000000011);
        SET_CLAUSE_TABLE(3, 10'b0000000100);
        SET_CLAUSE_TABLE(4, 10'b0000000101);
        SET_CLAUSE_TABLE(5, 10'b0000000110);
        SET_CLAUSE_TABLE(6, 10'b0010000000);
        SET_CLAUSE_TABLE(7, 10'b0000010110);
        SET_CLAUSE_TABLE(8, 10'b0000010111);
        SET_CLAUSE_TABLE(9, 10'b0000011000);
        SET_CLAUSE_TABLE(10, 10'b0000011001);
        SET_CLAUSE_TABLE(11, 10'b0000011010);
        SET_CLAUSE_TABLE(12, 10'b0000011011);
        SET_CLAUSE_TABLE(13, 10'b0010000000);
        SET_CLAUSE_TABLE(14, 10'b0000101011);
        SET_CLAUSE_TABLE(15, 10'b0000101100);
        SET_CLAUSE_TABLE(16, 10'b0000101101);
        SET_CLAUSE_TABLE(17, 10'b0000101110);
        SET_CLAUSE_TABLE(18, 10'b0000101111);
        SET_CLAUSE_TABLE(19, 10'b0000110000);
        SET_CLAUSE_TABLE(20, 10'b0001111111);
        SET_CLAUSE_TABLE(21, 10'b0001000000);
        SET_CLAUSE_TABLE(22, 10'b0001000001);
        SET_CLAUSE_TABLE(23, 10'b0001000010);
        SET_CLAUSE_TABLE(24, 10'b0001000011);
        SET_CLAUSE_TABLE(25, 10'b0001000100);
        SET_CLAUSE_TABLE(26, 10'b0001000101);
        SET_CLAUSE_TABLE(27, 10'b0001111111);
        SET_CLAUSE_TABLE(28, 10'b0001010101);
        SET_CLAUSE_TABLE(29, 10'b0001010110);
        SET_CLAUSE_TABLE(30, 10'b0001010111);
        SET_CLAUSE_TABLE(31, 10'b0001011000);
        SET_CLAUSE_TABLE(32, 10'b0001011001);
        SET_CLAUSE_TABLE(33, 10'b0001011010);
        SET_CLAUSE_TABLE(34, 10'b0001111111);
        SET_CLAUSE_TABLE(35, 10'b0001101010);
        SET_CLAUSE_TABLE(36, 10'b0001101011);
        SET_CLAUSE_TABLE(37, 10'b0001101100);
        SET_CLAUSE_TABLE(38, 10'b0001101101);
        SET_CLAUSE_TABLE(39, 10'b0001101110);
        SET_CLAUSE_TABLE(40, 10'b0001101111);
        SET_CLAUSE_TABLE(41, 10'b0001111111);
        SET_CLAUSE_TABLE(42, 10'b0000000001);
        SET_CLAUSE_TABLE(43, 10'b0000000111);
        SET_CLAUSE_TABLE(44, 10'b0000001000);
        SET_CLAUSE_TABLE(45, 10'b0000001001);
        SET_CLAUSE_TABLE(46, 10'b0000001010);
        SET_CLAUSE_TABLE(47, 10'b0000001011);
        SET_CLAUSE_TABLE(48, 10'b0010000010);
        SET_CLAUSE_TABLE(49, 10'b0000010110);
        SET_CLAUSE_TABLE(50, 10'b0000011100);
        SET_CLAUSE_TABLE(51, 10'b0000011101);
        SET_CLAUSE_TABLE(52, 10'b0000011110);
        SET_CLAUSE_TABLE(53, 10'b0000011111);
        SET_CLAUSE_TABLE(54, 10'b0000100000);
        SET_CLAUSE_TABLE(55, 10'b0010000010);
        SET_CLAUSE_TABLE(56, 10'b0000101011);
        SET_CLAUSE_TABLE(57, 10'b0000110001);
        SET_CLAUSE_TABLE(58, 10'b0000110010);
        SET_CLAUSE_TABLE(59, 10'b0000110011);
        SET_CLAUSE_TABLE(60, 10'b0000110100);
        SET_CLAUSE_TABLE(61, 10'b0000110101);
        SET_CLAUSE_TABLE(62, 10'b0010000001);
        SET_CLAUSE_TABLE(63, 10'b0001000000);
        SET_CLAUSE_TABLE(64, 10'b0001000110);
        SET_CLAUSE_TABLE(65, 10'b0001000111);
        SET_CLAUSE_TABLE(66, 10'b0001001000);
        SET_CLAUSE_TABLE(67, 10'b0001001001);
        SET_CLAUSE_TABLE(68, 10'b0001001010);
        SET_CLAUSE_TABLE(69, 10'b0010000001);
        SET_CLAUSE_TABLE(70, 10'b0001010101);
        SET_CLAUSE_TABLE(71, 10'b0001011011);
        SET_CLAUSE_TABLE(72, 10'b0001011100);
        SET_CLAUSE_TABLE(73, 10'b0001011101);
        SET_CLAUSE_TABLE(74, 10'b0001011110);
        SET_CLAUSE_TABLE(75, 10'b0001011111);
        SET_CLAUSE_TABLE(76, 10'b0010000001);
        SET_CLAUSE_TABLE(77, 10'b0001101010);
        SET_CLAUSE_TABLE(78, 10'b0001110000);
        SET_CLAUSE_TABLE(79, 10'b0001110001);
        SET_CLAUSE_TABLE(80, 10'b0001110010);
        SET_CLAUSE_TABLE(81, 10'b0001110011);
        SET_CLAUSE_TABLE(82, 10'b0001110100);
        SET_CLAUSE_TABLE(83, 10'b0010000001);
        SET_CLAUSE_TABLE(84, 10'b0000000010);
        SET_CLAUSE_TABLE(85, 10'b0000000111);
        SET_CLAUSE_TABLE(86, 10'b0000001100);
        SET_CLAUSE_TABLE(87, 10'b0000001101);
        SET_CLAUSE_TABLE(88, 10'b0000001110);
        SET_CLAUSE_TABLE(89, 10'b0000001111);
        SET_CLAUSE_TABLE(90, 10'b0010000100);
        SET_CLAUSE_TABLE(91, 10'b0000010111);
        SET_CLAUSE_TABLE(92, 10'b0000011100);
        SET_CLAUSE_TABLE(93, 10'b0000100001);
        SET_CLAUSE_TABLE(94, 10'b0000100010);
        SET_CLAUSE_TABLE(95, 10'b0000100011);
        SET_CLAUSE_TABLE(96, 10'b0000100100);
        SET_CLAUSE_TABLE(97, 10'b0010000100);
        SET_CLAUSE_TABLE(98, 10'b0000101100);
        SET_CLAUSE_TABLE(99, 10'b0000110001);
        SET_CLAUSE_TABLE(100, 10'b0000110110);
        SET_CLAUSE_TABLE(101, 10'b0000110111);
        SET_CLAUSE_TABLE(102, 10'b0000111000);
        SET_CLAUSE_TABLE(103, 10'b0000111001);
        SET_CLAUSE_TABLE(104, 10'b0010000011);
        SET_CLAUSE_TABLE(105, 10'b0001000001);
        SET_CLAUSE_TABLE(106, 10'b0001000110);
        SET_CLAUSE_TABLE(107, 10'b0001001011);
        SET_CLAUSE_TABLE(108, 10'b0001001100);
        SET_CLAUSE_TABLE(109, 10'b0001001101);
        SET_CLAUSE_TABLE(110, 10'b0001001110);
        SET_CLAUSE_TABLE(111, 10'b0010000011);
        SET_CLAUSE_TABLE(112, 10'b0001010110);
        SET_CLAUSE_TABLE(113, 10'b0001011011);
        SET_CLAUSE_TABLE(114, 10'b0001100000);
        SET_CLAUSE_TABLE(115, 10'b0001100001);
        SET_CLAUSE_TABLE(116, 10'b0001100010);
        SET_CLAUSE_TABLE(117, 10'b0001100011);
        SET_CLAUSE_TABLE(118, 10'b0010000011);
        SET_CLAUSE_TABLE(119, 10'b0001101011);
        SET_CLAUSE_TABLE(120, 10'b0001110000);
        SET_CLAUSE_TABLE(121, 10'b0001110101);
        SET_CLAUSE_TABLE(122, 10'b0001110110);
        SET_CLAUSE_TABLE(123, 10'b0001110111);
        SET_CLAUSE_TABLE(124, 10'b0001111000);
        SET_CLAUSE_TABLE(125, 10'b0010000011);
        SET_CLAUSE_TABLE(126, 10'b0000000011);
        SET_CLAUSE_TABLE(127, 10'b0000001000);
        SET_CLAUSE_TABLE(128, 10'b0000001100);
        SET_CLAUSE_TABLE(129, 10'b0000010000);
        SET_CLAUSE_TABLE(130, 10'b0000010001);
        SET_CLAUSE_TABLE(131, 10'b0000010010);
        SET_CLAUSE_TABLE(132, 10'b0010000110);
        SET_CLAUSE_TABLE(133, 10'b0000011000);
        SET_CLAUSE_TABLE(134, 10'b0000011101);
        SET_CLAUSE_TABLE(135, 10'b0000100001);
        SET_CLAUSE_TABLE(136, 10'b0000100101);
        SET_CLAUSE_TABLE(137, 10'b0000100110);
        SET_CLAUSE_TABLE(138, 10'b0000100111);
        SET_CLAUSE_TABLE(139, 10'b0010000110);
        SET_CLAUSE_TABLE(140, 10'b0000101101);
        SET_CLAUSE_TABLE(141, 10'b0000110010);
        SET_CLAUSE_TABLE(142, 10'b0000110110);
        SET_CLAUSE_TABLE(143, 10'b0000111010);
        SET_CLAUSE_TABLE(144, 10'b0000111011);
        SET_CLAUSE_TABLE(145, 10'b0000111100);
        SET_CLAUSE_TABLE(146, 10'b0010000101);
        SET_CLAUSE_TABLE(147, 10'b0001000010);
        SET_CLAUSE_TABLE(148, 10'b0001000111);
        SET_CLAUSE_TABLE(149, 10'b0001001011);
        SET_CLAUSE_TABLE(150, 10'b0001001111);
        SET_CLAUSE_TABLE(151, 10'b0001010000);
        SET_CLAUSE_TABLE(152, 10'b0001010001);
        SET_CLAUSE_TABLE(153, 10'b0010000101);
        SET_CLAUSE_TABLE(154, 10'b0001010111);
        SET_CLAUSE_TABLE(155, 10'b0001011100);
        SET_CLAUSE_TABLE(156, 10'b0001100000);
        SET_CLAUSE_TABLE(157, 10'b0001100100);
        SET_CLAUSE_TABLE(158, 10'b0001100101);
        SET_CLAUSE_TABLE(159, 10'b0001100110);
        SET_CLAUSE_TABLE(160, 10'b0010000101);
        SET_CLAUSE_TABLE(161, 10'b0001101100);
        SET_CLAUSE_TABLE(162, 10'b0001110001);
        SET_CLAUSE_TABLE(163, 10'b0001110101);
        SET_CLAUSE_TABLE(164, 10'b0001111001);
        SET_CLAUSE_TABLE(165, 10'b0001111010);
        SET_CLAUSE_TABLE(166, 10'b0001111011);
        SET_CLAUSE_TABLE(167, 10'b0010000101);
        SET_CLAUSE_TABLE(168, 10'b0000000100);
        SET_CLAUSE_TABLE(169, 10'b0000001001);
        SET_CLAUSE_TABLE(170, 10'b0000001101);
        SET_CLAUSE_TABLE(171, 10'b0000010000);
        SET_CLAUSE_TABLE(172, 10'b0000010011);
        SET_CLAUSE_TABLE(173, 10'b0000010100);
        SET_CLAUSE_TABLE(174, 10'b0010001000);
        SET_CLAUSE_TABLE(175, 10'b0000011001);
        SET_CLAUSE_TABLE(176, 10'b0000011110);
        SET_CLAUSE_TABLE(177, 10'b0000100010);
        SET_CLAUSE_TABLE(178, 10'b0000100101);
        SET_CLAUSE_TABLE(179, 10'b0000101000);
        SET_CLAUSE_TABLE(180, 10'b0000101001);
        SET_CLAUSE_TABLE(181, 10'b0010001000);
        SET_CLAUSE_TABLE(182, 10'b0000101110);
        SET_CLAUSE_TABLE(183, 10'b0000110011);
        SET_CLAUSE_TABLE(184, 10'b0000110111);
        SET_CLAUSE_TABLE(185, 10'b0000111010);
        SET_CLAUSE_TABLE(186, 10'b0000111101);
        SET_CLAUSE_TABLE(187, 10'b0000111110);
        SET_CLAUSE_TABLE(188, 10'b0010000111);
        SET_CLAUSE_TABLE(189, 10'b0001000011);
        SET_CLAUSE_TABLE(190, 10'b0001001000);
        SET_CLAUSE_TABLE(191, 10'b0001001100);
        SET_CLAUSE_TABLE(192, 10'b0001001111);
        SET_CLAUSE_TABLE(193, 10'b0001010010);
        SET_CLAUSE_TABLE(194, 10'b0001010011);
        SET_CLAUSE_TABLE(195, 10'b0010000111);
        SET_CLAUSE_TABLE(196, 10'b0001011000);
        SET_CLAUSE_TABLE(197, 10'b0001011101);
        SET_CLAUSE_TABLE(198, 10'b0001100001);
        SET_CLAUSE_TABLE(199, 10'b0001100100);
        SET_CLAUSE_TABLE(200, 10'b0001100111);
        SET_CLAUSE_TABLE(201, 10'b0001101000);
        SET_CLAUSE_TABLE(202, 10'b0010000111);
        SET_CLAUSE_TABLE(203, 10'b0001101101);
        SET_CLAUSE_TABLE(204, 10'b0001110010);
        SET_CLAUSE_TABLE(205, 10'b0001110110);
        SET_CLAUSE_TABLE(206, 10'b0001111001);
        SET_CLAUSE_TABLE(207, 10'b0001111100);
        SET_CLAUSE_TABLE(208, 10'b0001111101);
        SET_CLAUSE_TABLE(209, 10'b0010000111);
        SET_CLAUSE_TABLE(210, 10'b0000000101);
        SET_CLAUSE_TABLE(211, 10'b0000001010);
        SET_CLAUSE_TABLE(212, 10'b0000001110);
        SET_CLAUSE_TABLE(213, 10'b0000010001);
        SET_CLAUSE_TABLE(214, 10'b0000010011);
        SET_CLAUSE_TABLE(215, 10'b0000010101);
        SET_CLAUSE_TABLE(216, 10'b0010001010);
        SET_CLAUSE_TABLE(217, 10'b0000011010);
        SET_CLAUSE_TABLE(218, 10'b0000011111);
        SET_CLAUSE_TABLE(219, 10'b0000100011);
        SET_CLAUSE_TABLE(220, 10'b0000100110);
        SET_CLAUSE_TABLE(221, 10'b0000101000);
        SET_CLAUSE_TABLE(222, 10'b0000101010);
        SET_CLAUSE_TABLE(223, 10'b0010001010);
        SET_CLAUSE_TABLE(224, 10'b0000101111);
        SET_CLAUSE_TABLE(225, 10'b0000110100);
        SET_CLAUSE_TABLE(226, 10'b0000111000);
        SET_CLAUSE_TABLE(227, 10'b0000111011);
        SET_CLAUSE_TABLE(228, 10'b0000111101);
        SET_CLAUSE_TABLE(229, 10'b0000111111);
        SET_CLAUSE_TABLE(230, 10'b0010001001);
        SET_CLAUSE_TABLE(231, 10'b0001000100);
        SET_CLAUSE_TABLE(232, 10'b0001001001);
        SET_CLAUSE_TABLE(233, 10'b0001001101);
        SET_CLAUSE_TABLE(234, 10'b0001010000);
        SET_CLAUSE_TABLE(235, 10'b0001010010);
        SET_CLAUSE_TABLE(236, 10'b0001010100);
        SET_CLAUSE_TABLE(237, 10'b0010001001);
        SET_CLAUSE_TABLE(238, 10'b0001011001);
        SET_CLAUSE_TABLE(239, 10'b0001011110);
        SET_CLAUSE_TABLE(240, 10'b0001100010);
        SET_CLAUSE_TABLE(241, 10'b0001100101);
        SET_CLAUSE_TABLE(242, 10'b0001100111);
        SET_CLAUSE_TABLE(243, 10'b0001101001);
        SET_CLAUSE_TABLE(244, 10'b0010001001);
        SET_CLAUSE_TABLE(245, 10'b0001101110);
        SET_CLAUSE_TABLE(246, 10'b0001110011);
        SET_CLAUSE_TABLE(247, 10'b0001110111);
        SET_CLAUSE_TABLE(248, 10'b0001111010);
        SET_CLAUSE_TABLE(249, 10'b0001111100);
        SET_CLAUSE_TABLE(250, 10'b0001111110);
        SET_CLAUSE_TABLE(251, 10'b0010001001);
        SET_CLAUSE_TABLE(252, 10'b0000000110);
        SET_CLAUSE_TABLE(253, 10'b0000001011);
        SET_CLAUSE_TABLE(254, 10'b0000001111);
        SET_CLAUSE_TABLE(255, 10'b0000010010);
        SET_CLAUSE_TABLE(256, 10'b0000010100);
        SET_CLAUSE_TABLE(257, 10'b0000010101);
        SET_CLAUSE_TABLE(258, 10'b0010001100);
        SET_CLAUSE_TABLE(259, 10'b0000011011);
        SET_CLAUSE_TABLE(260, 10'b0000100000);
        SET_CLAUSE_TABLE(261, 10'b0000100100);
        SET_CLAUSE_TABLE(262, 10'b0000100111);
        SET_CLAUSE_TABLE(263, 10'b0000101001);
        SET_CLAUSE_TABLE(264, 10'b0000101010);
        SET_CLAUSE_TABLE(265, 10'b0010001100);
        SET_CLAUSE_TABLE(266, 10'b0000110000);
        SET_CLAUSE_TABLE(267, 10'b0000110101);
        SET_CLAUSE_TABLE(268, 10'b0000111001);
        SET_CLAUSE_TABLE(269, 10'b0000111100);
        SET_CLAUSE_TABLE(270, 10'b0000111110);
        SET_CLAUSE_TABLE(271, 10'b0000111111);
        SET_CLAUSE_TABLE(272, 10'b0010001011);
        SET_CLAUSE_TABLE(273, 10'b0001000101);
        SET_CLAUSE_TABLE(274, 10'b0001001010);
        SET_CLAUSE_TABLE(275, 10'b0001001110);
        SET_CLAUSE_TABLE(276, 10'b0001010001);
        SET_CLAUSE_TABLE(277, 10'b0001010011);
        SET_CLAUSE_TABLE(278, 10'b0001010100);
        SET_CLAUSE_TABLE(279, 10'b0010001011);
        SET_CLAUSE_TABLE(280, 10'b0001011010);
        SET_CLAUSE_TABLE(281, 10'b0001011111);
        SET_CLAUSE_TABLE(282, 10'b0001100011);
        SET_CLAUSE_TABLE(283, 10'b0001100110);
        SET_CLAUSE_TABLE(284, 10'b0001101000);
        SET_CLAUSE_TABLE(285, 10'b0001101001);
        SET_CLAUSE_TABLE(286, 10'b0010001011);
        SET_CLAUSE_TABLE(287, 10'b0001101111);
        SET_CLAUSE_TABLE(288, 10'b0001110100);
        SET_CLAUSE_TABLE(289, 10'b0001111000);
        SET_CLAUSE_TABLE(290, 10'b0001111011);
        SET_CLAUSE_TABLE(291, 10'b0001111101);
        SET_CLAUSE_TABLE(292, 10'b0001111110);
        SET_CLAUSE_TABLE(293, 10'b0010001011);
        SET_CLAUSE_TABLE(294, 10'b0001111111);
        SET_CLAUSE_TABLE(295, 10'b0010000000);
        SET_CLAUSE_TABLE(296, 10'b0010000001);
        SET_CLAUSE_TABLE(297, 10'b0010000010);
        SET_CLAUSE_TABLE(298, 10'b0010000011);
        SET_CLAUSE_TABLE(299, 10'b0010000100);
        SET_CLAUSE_TABLE(300, 10'b0010000101);
        SET_CLAUSE_TABLE(301, 10'b0010000110);
        SET_CLAUSE_TABLE(302, 10'b0010000111);
        SET_CLAUSE_TABLE(303, 10'b0010001000);
        SET_CLAUSE_TABLE(304, 10'b0010001001);
        SET_CLAUSE_TABLE(305, 10'b0010001010);
        SET_CLAUSE_TABLE(306, 10'b0010001011);
        SET_CLAUSE_TABLE(307, 10'b0010001100);

        // SET DECIDER
        SET_DECIDER(0, 10'b0000111100);
        SET_DECIDER(1, 10'b0000100001);
        SET_DECIDER(2, 10'b0000001100);
        SET_DECIDER(3, 10'b0000111001);
        SET_DECIDER(4, 10'b0000011110);
        SET_DECIDER(5, 10'b0000101010);
        SET_DECIDER(6, 10'b0000011011);
        SET_DECIDER(7, 10'b0001010110);
        SET_DECIDER(8, 10'b0001011011);
        SET_DECIDER(9, 10'b0000100111);
        SET_DECIDER(10, 10'b0001001011);
        SET_DECIDER(11, 10'b0000010110);
        SET_DECIDER(12, 10'b0000001010);
        SET_DECIDER(13, 10'b0001000001);
        SET_DECIDER(14, 10'b0001000100);
        SET_DECIDER(15, 10'b0000100011);
        SET_DECIDER(16, 10'b0000010100);
        SET_DECIDER(17, 10'b0001001111);
        SET_DECIDER(18, 10'b0000110111);
        SET_DECIDER(19, 10'b0000010011);
        SET_DECIDER(20, 10'b0001100000);
        SET_DECIDER(21, 10'b0000001000);
        SET_DECIDER(22, 10'b0000100101);
        SET_DECIDER(23, 10'b0001011000);
        SET_DECIDER(24, 10'b0000110101);
        SET_DECIDER(25, 10'b0000101001);
        SET_DECIDER(26, 10'b0001010011);
        SET_DECIDER(27, 10'b0000010000);
        SET_DECIDER(28, 10'b0000111110);
        SET_DECIDER(29, 10'b0000101111);
        SET_DECIDER(30, 10'b0001001001);
        SET_DECIDER(31, 10'b0000000101);
        SET_DECIDER(32, 10'b0000011000);
        SET_DECIDER(33, 10'b0000001110);
        SET_DECIDER(34, 10'b0000011100);
        SET_DECIDER(35, 10'b0001010000);
        SET_DECIDER(36, 10'b0000000110);
        SET_DECIDER(37, 10'b0001000110);
        SET_DECIDER(38, 10'b0000101101);
        SET_DECIDER(39, 10'b0000110010);
        SET_DECIDER(40, 10'b0001010101);
        SET_DECIDER(41, 10'b0001000011);
        SET_DECIDER(42, 10'b0000111010);
        SET_DECIDER(43, 10'b0000000010);
        SET_DECIDER(44, 10'b0001100011);
        SET_DECIDER(45, 10'b0000110001);
        SET_DECIDER(46, 10'b0001011110);
        SET_DECIDER(47, 10'b0001001100);
        SET_DECIDER(48, 10'b0001011100);

        max_var_test = 49;    // NUMBER OF VARIABLES IN PROBLEM

        @(negedge clock);
        clock = 0;
        reset = 1;
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


        @(negedge clock);
        $display("Expected SAT");

        $display("\nAssignment in Var State\n");
        for (integer i = 0; i < max_var_test+2; i = i+1) begin
            read_vs_test = 1;
            var_in_vs_test = i+1;
            $display("var%0d = %0b, (sanity check) assigned = %0b",i, val_out_vs, ~unassign_out_vs);
            @(negedge clock);
        end


        $finish;
    end
endmodule