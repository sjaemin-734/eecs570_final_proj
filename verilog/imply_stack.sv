// 5 variables per clause, 1023 clauses

// Imply Stack
module imply_stack # (
    parameter NUM_VARIABLE = 128,
    parameter VARIABLE_INDEXES = 8
)
(
    input              clock,
    input              reset,
    input              en,
    input              rw,           // read/pop = 0, write/push = 1
    input              val,          // Assigned to be T or F
    input        [8:0] variable,
    output             type_out,     //Always 1
    output             val_out,      
    output       [8:0] variable_out,
    output             empty_out
);
    localparam bit [NUM_VARIABLE:0] COUNTER_RESET_VAL = 0;
    integer i;

    // data structure
    logic [NUM_VARIABLE:0] counter;                               // current index in stack
    logic [NUM_VARIABLE:0] stack[0:(VARIABLE_INDEXES+1)];         // [val [1], variable index [8:0]]

    logic val;
    logic [8:0] variable;
    logic empty;


    always_comb begin
        type_out = 1'b1;
        val_out = val;
        variable_out = var_o;
        empty_out = empty;
    end


    always_ff @ (posedge clock) begin
        if (en == 0);
        else begin
            if (reset) begin
                counter <= COUNTER_RESET_VAL;
                for (i = 0; i < NUM_VARIABLE; i=i+1) begin
                    stack[i] = 0;
                end
            end else if (reset == 0) begin
                empty <= counter == 0 ? 1'b1: 1'b0;
                if (rw == 0 & ~empty) begin
                    var_o <= stack[counter - 1][VARIABLE_INDEXES:0]; 
                    val <= stack[counter - 1][VARIABLE_INDEXES+1];
                    counter <= counter - 1;
                end else if (rw == 1) begin
                    stack[counter] <= {val, variable};
                    counter <= counter + 1;
                end
                
            end                
            end
        end

endmodule