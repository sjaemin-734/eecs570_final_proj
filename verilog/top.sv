`include "sysdefs.svh"
`include "verilog/control.sv"
`include "verilog/stack.sv"
`include "verilog/decider.sv"
`include "verilog/sub_clause_eval.sv"
`include "verilog/decider_stack.sv"
`include "verilog/var_state.sv"

// top level module

module top(
    input                                clock,
    input                                reset,
    // input                                init,
    input                                start,
    output logic                         sat,
    output logic                         unsat
);

    // control variables
    logic reset_c;
    // BCP CORE
    logic bcp_busy;
    logic [`MAX_CLAUSES_BITS-1:0] bcp_clause_idx;
    logic reset_bcp;
    logic bcp_en;       // read from clause database
    // output
    logic sat_c;
    logic unsat_c;
    
    logic [3:0] state_out;

    // Var Start End Table variables
    output [`CLAUSE_TABLE_BITS*2-1:0] data_out_vse;

    // Clause Table variables
    output [`MAX_CLAUSES_BITS-1:0] data_out_ct;

    // Clause Database variables
    // output
    output [`CLAUSE_DATA_BITS-1:0] clause_info;

    // Var State variables
    // inputs
    logic reset_vs;
    logic read_vs;
    logic multi_read_vs;
    logic write_vs;
    logic val_in_vs;
    logic unassign_in_vs;
    // Used by both
    logic [`MAX_VARS_BITS - 1:0] var_in_vs;
    logic [`VAR_PER_CLAUSE - 1:0][`MAX_VARS_BITS - 1:0] multi_var_in_vs;
    // outputs
    logic val_out_vs;
    logic unassign_out_vs;
    logic [`VAR_PER_CLAUSE - 1:0] multi_val_out_vs;
    logic [`VAR_PER_CLAUSE - 1:0] multi_unassign_out_vs;


    // Decider variables
    // inputs
    // logic config_var dec_config_d; // A pair of variable inde and its decision value
    // logic writemem_d; // High when getting config data
    // logic read_d; // Control is asking for next value
    // logic write_d; // Control is replacing dec_idx
    // logic [`MAX_VARS_BITS-1:0] back_dec_idx_d; // Used by the Control when backtracking
    // logic reset_d;
    // // outputs
    // logic [`MAX_VARS_BITS-1:0] dec_idx_out_d;
    // logic [`MAX_VARS_BITS-1:0] var_idx_out_d;
    // logic val_out_d;

    // Decider stack variables
    // inputs
    logic reset_ds;
    logic push_ds;
    logic pop_ds;
    logic [`MAX_VARS_BITS-1:0]  dec_idx_in_ds; // Index for the Decider
    // outputs
    logic [`MAX_VARS_BITS-1:0]  dec_idx_out_ds;           
    logic empty_ds;

    // Clause Evaluator variables
    // inputs
    logic en_ce;
    logic [`VAR_PER_CLAUSE-1:0] unassign_ce;
    logic [`VAR_PER_CLAUSE-1:0] clause_mask_ce;
    logic [`VAR_PER_CLAUSE-1:0] clause_pole_ce;
    logic [`VAR_PER_CLAUSE-1:0] val_ce;
    logic [`VAR_PER_CLAUSE-1:0][`MAX_VARS_BITS-1:0] variable_ce;
    // ouputs
    logic new_val_ce;
    logic [`MAX_VARS_BITS-1:0] implied_variable_ce;
    // logic unit_clause; // connects to en_cd


    // Conflict Detector variables
    // Many variables are shared with imply and clause evaluator
    // inputs
    logic reset_cd;
    logic en_cd;
    // outputs
    logic conflict_cd;

    // Imply Table variables
    logic pop_imply;
    logic push_imply;
    logic type_in_imply; //  Decide = 0, Forced = 1 
    logic val_in_imply;
    logic [`MAX_VARS_BITS-1:0]  var_in_imply;
    //outputs
    logic type_out_imply;
    logic val_out_imply;
    logic [`MAX_VARS_BITS-1:0]  var_out_imply;
    logic empty_imply;
    logic full_imply;

    // Trace Table variables
    // inputs
    logic pop_trace;
    logic push_trace;
    logic type_in_trace; //  Decide = 0, Forced = 1 
    logic val_in_trace;
    logic [`MAX_VARS_BITS-1:0]  var_in_trace;
    //outputs
    logic type_out_trace;
    logic val_out_trace;
    logic [`MAX_VARS_BITS-1:0]  var_out_trace;
    logic empty_trace;
    logic full_trace;



    // Modules
    control DUT (
        .clock(clock),
        .reset(reset),
        .start(start),

        .bcp_busy(bcp_busy),
        .conflict(conflict_cd),
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

        .var_idx_d(var_idx_d),
        .val_d(val_d),
        .read_d(read_d),
        .dec_idx_d_in(dec_idx_d_in),

        .dec_idx_ds_out(dec_idx_out_ds),
        .empty_ds(empty_ds),
        .push_ds(push_ds),
        .pop_ds(pop_ds),
        .dec_idx_ds_in(dec_idx_in_ds),

        .sat(sat),
        .unsat(unsat),
        .state_out(state_out)
    );

    // decider decider (
    //     .dec_config(dec_config_d), // List of variable indices and their decision values
    //     .writemem(writemem_d),
    //     .read(read_d),
    //     .write(write_d),
    //     .back_dec_idx(back_dec_idx_d), // Used by the Control when backtracking
    //     .clock(clock),
    //     .reset(reset_d),

    //     .dec_idx_out(dec_idx_out_d),
    //     .var_idx_out(var_idx_out_d),
    //     .val_out(val_out_d)
    // );

    decider_stack decide_stack (
        .clock(clock),
        .reset(reset_ds),
        .push(push_ds),
        .pop(pop_ds),
        .dec_idx_in(dec_idx_in_ds),

        .dec_idx_out(dec_idx_out_ds),
        .empty(empty_ds)
    );

    var_start_ram vse (
        .clock(clock),
        .wren(1'b0),
        .data(26'h0),
        .address(var_in_vse),     //variable index
        .q(data_out_vse)            // Output
    );

    clause_table_ram ct (
        .clock(clock),
        .wren(1'b0),
        .data(26'h0),
        .address(bcp_clause_idx),     //variable index
        .q(data_out_ct) 
    );

    clause_db_ram cdb (
        .clock(clock),
        .wren(1'b0),        // Never write to cdb
        .data(55'h0),       // Never write to cdb
        .address(data_out_vse),       // Clause index
        .q(clause_info)     //output
    );

    var_state vs (
        .clock(clock),
        .reset(reset_vs),
        .read(read_vs),
        .multi_read(multi_read_vs),
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
        .clause_info_in(clause_info), // From Control
        .unassign_in(multi_unassign_out_vs), // From Var State Table
        .val_in(multi_val_out_vs), // From Var State Table

        .clock(clock),
        .reset(reset_bcp),
        .en(bcp_en),

        .idx_out(multi_var_in_vs), // To Var State Table

        // To Clause Evaluator
        .clause_mask_out(clause_mask_ce),
        .clause_pole_out(clause_pole_ce),
        .variable_out(variable_ce), // Addresses
        .unassign_out(unassign_ce),
        .val_out(val_ce),
        .es_en(en_ce)

    );

    sub_clause_evaluator ce (
        .en(en_ce),
        .unassign(unassign_ce),
        .clause_mask(clause_mask_ce),
        .clause_pole(clause_pole_ce),
        .val(val_ce),
        .variable(variable_ce),
        .new_val(new_val_ce),
        .implied_variable(implied_variable_ce),
        .unit_clause(en_cd)
    );

    conflict_detector cd (
        .var_idx_in(implied_variable_ce), // Implied Variable
        .val_in(new_val_ce), // Implied value
        .clock(clock),
        .reset(reset_cd),
        .en(en_cd),
        .conflict(conflict_cd),
        .var_idx_out(var_in_imply),
        .val_out(val_in_imply),
        .imply_stack_push_en(push_imply)
    );

    stack imply_stack (
        .clock(clock),
        .reset(reset_imply),                              // TODO: Is Conflict Module doing this?
        .push(push_imply),
        .pop(pop_imply),
        .type_in(1'b1),         // Always forced 
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

    var_state var_state_table (
        .clock(clock),
        .reset(reset_vs),
        .read(read_vs),
        .write(write_vs),
        .val_in(val_in_vs),
        .unassign_in(unassign_in_vs),
        .var_in(var_in_vs),
        .val_out(val_out_vs),
        .unassign_out(unassign_out_vs)
    );


    always_comb begin
        if (reset) begin
            unsat = 1'b0;
            sat = 1'b0;
        end else begin
            unsat = unsat_c;
            sat = sat_c;
            start_clause = data_out_vse[`CLAUSE_TABLE_BITS-1:0];
            end_clause = data_out_vse[`CLAUSE_TABLE_BITS*2-1:`CLAUSE_TABLE_BITS];
            reset_imply = conflict_cd;
            bcp_busy =  en_ce | en_cd | push_imply   // | en_
        end
    end

endmodule