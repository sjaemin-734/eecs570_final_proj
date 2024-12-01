`include "sysdefs.svh"

module var_start_end (
    input                                clock,
    input                                reset,
    input                                read,
    input                                write,                  // as a way to insert things into table
    // read
    input        [`MAX_VAR_BITS-1:0] var_in,
    // push
    input        [`CLAUSE_TABLE_BITS-1:0]  start_in,
    input        [`CLAUSE_TABLE_BITS-1:0]  end_in,
    output logic [`CLAUSE_TABLE_BITS-1:0]  start_out,
    output logic [`CLAUSE_TABLE_BITS-1:0]  end_out
);

    logic [(`MAX_VARS-1):0][(`CLAUSE_TABLE_BITS + `CLAUSE_TABLE_BITS - 1):0] var_start_end_table;      // stores start and end indexes of clause table

    always_ff @(posedge clock) begin
        if (reset) begin
            for(integer i = 0; i < MAX_VARS; i=i+1) begin
                var_start_end_table[i] = 0;
            end

        end else begin
            if (write) begin
                var_start_end_table[var_in] <= {start_in, end_in};
            end
        end
    end

    always_comb begin
      if (read) begin
            start_out = var_start_end_table[var_in][(`CLAUSE_TABLE_BITS + `CLAUSE_TABLE_BITS - 1):`CLAUSE_DATA_BITS];
            end_out = var_start_end_table[var_in][`CLAUSE_TABLE_BITS-1:0];
      end else begin
            start_out = {`CLAUSE_TABLE_BITS{0'b0}};
            end_out = {`CLAUSE_TABLE_BITS{0'b0}};
      end
    end

endmodule