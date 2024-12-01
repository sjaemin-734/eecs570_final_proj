`ifndef __SYSDEFS_SVH__
`define __SYSDEFS_SVH__

`define MAX_VARS 512
`define MAX_VARS_BITS $clog2(`MAX_VARS)
`define MAX_CLAUSES 1024
`define MAX_CLAUSES_BITS $clog2(`MAX_CLAUSES)
`define VAR_PER_CLAUSE 5
`define CLAUSE_DATA_BITS (`VAR_PER_CLAUSE + `VAR_PER_CLAUSE + `VAR_PER_CLAUSE * `MAX_VARS_BITS)
`define CLAUSE_TABLE_SIZE `VAR_PER_CLAUSE * `MAX_CLAUSES
`define CLAUSE_TABLE_BITS $clog2(`CLAUSE_TABLE_SIZE)

typedef struct packed {
    logic [8:0] var_idx;
    logic val;
} config_var;

`endif // __SYSDEFS_SVH__