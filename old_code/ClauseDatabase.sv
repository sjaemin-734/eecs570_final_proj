/*  Clause database stores the info about each clause
    in the CNF formula. It communicates with the Solver
    module by sending/receiving clauses.

    Input: 1 clause at a time
    Output: 1 clause at a time
*/

// TODO: create a struct to hold a clause and its data
`define DB_SIZE 512

module clause_database(
    input [4:0] mask_in,
    input [4:0] pole_in,
    input [8:0] var1_in,
    input [8:0] var2_in,
    input [8:0] var3_in,
    input [8:0] var4_in,
    input [8:0] var5_in,
    input [$clog2(DB_SIZE)-1:0] clause_sel, // Choose which clause to access
    input reset,

    output [4:0] mask_out,
    output [4:0] pole_out,
    output [8:0] var1_out,
    output [8:0] var2_out,
    output [8:0] var3_out,
    output [8:0] var4_out,
    output [8:0] var5_out
);

    // Keeps track of # of clauses in DB. Used to determine which row
    // the next input clause goes
    logic [$clog2(DB_SIZE)-1:0] clause_count;

    // This actually holds the clauses


    // Mask: states that there is a variable present (one-hot encoded)
    // Pole: polarity of variable (negation or not)

    

endmodule