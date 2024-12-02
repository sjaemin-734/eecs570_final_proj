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
    // input
    logic reset_c;
    logic bcp_busy;
    // output
    logic sat_c;
    logic unsat_c;

    // Var State variables
    // inputs
    logic reset_vs;
    logic read_vs;
    // logic multi_read;
    logic write_vs;
    logic val_in_vs;
    logic unassign_in_vs;
    // Used by both
    logic [`MAX_VARS_BITS - 1:0] var_in_vs;
    // logic [VAR_PER_CLAUSE - 1:0][MAX_VARS_BITS - 1:0]   data_in;
    // outputs
    logic val_out_vs;
    logic unassign_out_vs;
    // logic [VAR_PER_CLAUSE - 1:0][1:0] data_out;


    // Decider variables
    // inputs
    logic config_var dec_config_d; // A pair of variable inde and its decision value
    logic writemem_d; // High when getting config data
    logic read_d; // Control is asking for next value
    logic write_d; // Control is replacing dec_idx
    logic [`MAX_VARS_BITS-1:0] back_dec_idx_d; // Used by the Control when backtracking
    logic reset_c;
    // outputs
    logic [`MAX_VARS_BITS-1:0] dec_idx_out_d;
    logic [`MAX_VARS_BITS-1:0] var_idx_out_d;
    logic val_out_d;

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
    control controller (
        .clock(clock),
        .reset(reset_c),
        .start(start),
        .bcp_busy(bcp_busy),
        .empty_imply(empty_imply)
        .sat(sat_cd),
        .unsat(unsat_cd)
    );

    decider decider (
        .dec_config(dec_config_d), // List of variable indices and their decision values
        .writemem(writemem_d),
        .read(read_d),
        .write(write_d),
        .back_dec_idx(back_dec_idx_d), // Used by the Control when backtracking
        .clock(clock),
        .reset(reset_d),

        .dec_idx_out(dec_idx_out_d),
        .var_idx_out(var_idx_out_d),
        .val_out(val_out_d)
    );

    decider_stack decide_stack (
        .clock(clock),
        .reset(reset_ds),
        .push(push_ds),
        .pop(pop_ds),
        .dec_idx_in(dec_idx_in_ds),

        .dec_idx_out(dec_idx_out_ds),
        .empty(empty_ds)
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
            unsat = c_unsat;
            sat = c_sat;
            reset_imply = conflict_cd;
            bcp_busy =  en_ce | en_cd | push_imply   // | en_
        end
    end

endmodule