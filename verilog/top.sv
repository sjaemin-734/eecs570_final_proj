`include "sysdefs.svh"

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
    logic c_sat;
    logic c_unsat;

    // Imply Table variables
    logic empty_imply;
    logic full_imply;
    logic pop_imply;

    // Trace Table variables
    logic empty_trace;
    logic full_trace;
    logic pop_trace;
    logic push_trace;





    // Modules
    control controller (

    );

    decider decider (
        .dec_config(dec_config), // List of variable indices and their decision values
        .writemem(writemem),
        .read(read),
        .write(write),
        .back_dec_idx(back_dec_idx), // Used by the Control when backtracking
        .clock(clock),
        .reset(reset),

        .dec_idx_out(dec_idx_out),
        .var_idx_out(var_idx_out),
        .val_out(val_out)
    );

    sub_clause_evaluator ce (
        .unassign(unassign),
        .clause_mask(clause_mask),
        .clause_pole(clause_pole),
        .val(val),
        .variable(variable),
        .new_val(new_val),
        .implied_variable(implied_variable),
        .unit_clause(unit_clause)
    );

    conflict_detector cd (
        .var_idx_in(var_idx_in_cd), // Implied Variable
        .val_in(val_in_cd), // Implied value
        .clock(clock),
        .reset(reset_cd),
        .en(en_cd),
        .conflict(conflict_cd),
        .var_idx_out(var_idx_out_cd),
        .val_out(val_out_cd),
        .imply_stack_push_en(imply_stack_push_en)
    );

    decider_stack decide_stack (
        .clock(clock),
        .reset(reset_decide),
        .push(push_decide),
        .pop(pop_decide),
        .dec_idx_in(dec_idx_in),

        .dec_idx_out(dec_idx_out),
        .empty(empty_decide)
    );

    stack imply_stack (
        .clock(clock),
        .reset(reset_imply),                              // TODO: Is Conflict Module doing this?
        .push(push_imply),
        .pop(pop_imply),
        .type_in(type_in_imply),
        .val_in(val_in_imply),
        .var_in(var_in_imply),
        .type_out(type_out_imply),
        .val_out(var_out_imply),
        .var_out(var_out_imply),
        .empty(empty_imply),
        .full(full_imply)
    );

    stack trace_stack (
        .clock(clock),
        .reset(reset),
        .push(push_trace),
        .pop(pop_trace),
        .type_in(type_in_trace),
        .val_in(val_in_trace),
        .var_in(var_in_trace),
        .var_out(var_out_trace),
        .type_out(type_out_trace),
        .val_out(val_out_trace),
        .empty(empty_trace),
        .full(full_trace)
    );


    always_comb begin
        if (reset) begin
            unsat = 1'b0;
            sat = 1'b0;
        end else begin
            unsat = c_unsat;
            sat = c_sat;
        end
    end

endmodule