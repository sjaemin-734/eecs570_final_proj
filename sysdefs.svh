`ifndef __SYSDEFS_SVH__
`define __SYSDEFS_SVH__

`define MAX_VARS 512
`define MAX_VARS_BITS $clog2(`MAX_VARS)
`define MAX_CLAUSES 1024
`define MAX_CLAUSES_BITS $clog2(`MAX_CLAUSES)
`define VAR_PER_CLAUSE 5
`define CLAUSE_TABLE_SIZE 2056
`define CLAUSE_TABLE_BITS $clog2(`CLAUSE_TABLE_SIZE)


`endif // __SYSDEFS_SVH__