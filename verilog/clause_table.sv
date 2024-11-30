`include "sysdefs.svh"

module clause_table(
    input                                clock,
    input                                reset,
    input                                push,                  // as a way to insert things into table
    input                                read,
    // read
    input        [`CLAUSE_TABLE_BITS-1:0] index_in,
    // push
    input        [`MAX_CLAUSES_BITS-1:0]  clause_in,
    output logic [`MAX_CLAUSES_BITS-1:0]  clause_index_out,
    output logic                         full,
    output logic                         error
);

    logic [(`CLAUSE_TABLE_SIZE-1):0][`MAX_CLAUSES_BITS-1:0] clause_table;      // stores clause index
    logic [`CLAUSE_TABLE_BITS-1:0]  table_ptr;

    always_ff @(posedge clock) begin
        if (reset) begin
            table_ptr <= 0;
            full <= 0;

        end else begin
            if (push && !full) begin
                clause_table[table_ptr] <= clause_in;
                table_ptr        <= table_ptr + 1;

                if (table_ptr == `CLAUSE_TABLE_SIZE - 1) begin
                    full <= 1;
                end
            end
        end
    end

    always_comb begin
      if (read & index_in < table_ptr) begin
            error = 0;
            clause_index_out = clause_table[index_in];
      end else if (read & index_in >= table_ptr) begin
            error = 1;
      end else begin
            clause_index_out = {`MAX_CLAUSES_BITS{0'b0}};
            error = 0;
      end
    end

endmodule