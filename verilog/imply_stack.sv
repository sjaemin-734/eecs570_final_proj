// 5 variables per clause, 1023 clauses

// Imply Stack
module trace_table # (
    paramter NUM_VARIABLE = 128,
    paramter VARIABLE_INDEXES = 8
)
(
    input                 clk,
    input                 reset,
    input                 push,
    input                 pop,
    input                 t_type,       // D=0/F=1
    input                 val,          // Assigned to be T or F
    input           [8:0] variable,
    output logic          last,         // whether its the last to come out during backpropagation
    output logic          type_out,
    output logic          val_out,
    output logic    [8:0] variable_out,
    output logic          empty,
    output logic          done
);

endmodule