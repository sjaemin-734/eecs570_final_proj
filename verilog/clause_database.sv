`include "sysdefs.svh"

module clause_database(
    input                                clock,
    input                                reset,
    input                                push,                  // as a way to insert things into table
    input                                read,
    // push
    input        [`VAR_PER_CLAUSE-1:0] mask_in,
    input        [`VAR_PER_CLAUSE-1:0] pole_in,
    input        [`VAR_PER_CLAUSE-1:0][`MAX_VARS_BITS-1:0] var_in,
    // read
    input        [`MAX_CLAUSES_BITS-1:0]  index_in,
    output logic [`VAR_PER_CLAUSE-1:0] mask_out,
    output logic [`VAR_PER_CLAUSE-1:0] pole_out,
    output logic [`VAR_PER_CLAUSE-1:0][`MAX_VARS_BITS-1:0] var_out,
    output logic                         full,
    output logic                         error
);

    logic [(`MAX_CLAUSES-1):0][`CLAUSE_DATA_BITS-1:0] clause_database;      // stores clause info [mask [5], pole[5], var_id [5][`MAX_VAR_BITS]]
    logic [`MAX_CLAUSES_BITS-1:0]  table_ptr;
    logic [(`MAX_VARS_BITS*`VAR_PER_CLAUSE - 1):0] var_line;

    always_ff @(posedge clock) begin
        if (reset) begin
            table_ptr <= 0;
            full <= 0;

        end else begin
            if (push && !full) begin
                clause_database[table_ptr] <= {mask_in, pole_in, var_in[4], var_in[3], var_in[2], var_in[1], var_in[0]};    // TODO: Is there a way to not hard code like this?
                table_ptr        <= table_ptr + 1;

                if (table_ptr == `MAX_CLAUSES - 1) begin
                    full <= 1;
                end
            end
        end
    end

    always_comb begin
      if (read & index_in < table_ptr) begin
            error = 0;
            mask_out = clause_database[index_in][`CLAUSE_DATA_BITS-1:`CLAUSE_DATA_BITS-5];
            pole_out = clause_database[index_in][`CLAUSE_DATA_BITS-6:`CLAUSE_DATA_BITS-10];
            var_out[0] = clause_database[index_in][`MAX_VARS_BITS - 1:0];
            var_out[1] = clause_database[index_in][`MAX_VARS_BITS*2 - 1:`MAX_VARS_BITS];
            var_out[2] = clause_database[index_in][`MAX_VARS_BITS*3 - 1:`MAX_VARS_BITS*2];
            var_out[3] = clause_database[index_in][`MAX_VARS_BITS*4 - 1:`MAX_VARS_BITS*3];
            var_out[4] = clause_database[index_in][`MAX_VARS_BITS*5 - 1:`MAX_VARS_BITS*4];
            
      end else if (read & index_in >= table_ptr) begin
            error = 1;
      end else begin
            mask_out = {`VAR_PER_CLAUSE{1'b0}};
            pole_out = {`VAR_PER_CLAUSE{1'b0}};
            for (integer i = 0; i < `VAR_PER_CLAUSE; i = i+1) begin
                var_out[i] = {`MAX_VARS_BITS{1'b0}};
            end 
            error = 0;
      end
    end

endmodule