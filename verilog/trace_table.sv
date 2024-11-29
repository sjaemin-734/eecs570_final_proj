// 5 variables per clause, 1023 clauses

// Trace Table
module trace_table # (
    parameter NUM_VARIABLE = 128,
    parameter VARIABLE_INDEXES = 8
)
(
    input                 clk,
    input                 reset,
    input                 en,
    input                 rw,           // read/pop = 0, write/push = 1
    input                 type_in,      // Decide = 0, Forced = 1 
    input                 val,          // Assigned to be T or F
    input           [8:0] variable,
    output reg            type_out,
    output reg            val_out,      
    output reg      [8:0] variable_out,
    output reg            empty
);
    localparam bit [NUM_VARIABLE:0] COUNTER_RESET_VAL = 0;
    integer i;

    // data structure
    reg [NUM_VARIABLE:0] counter;                               // current index in stack
    reg [NUM_VARIABLE:0] stack[0:(VARIABLE_INDEXES+2)];         // [type [1],val [1], variable index [8:0]]

    always @(posedge clk) begin
        if (en == 0);
        else begin
            if (reset) begin
                counter <= COUNTER_RESET_VAL;
                empty <= 1'b1;
                for (i = 0; i < NUM_VARIABLE; i=i+1) begin
                    stack[i] = 0;
                end
            end else if (reset == 0) begin
                empty <= counter == 0 ? 1'b1: 1'b0;
                if (rw == 0 & ~empty) begin
                    variable_out <= stack[counter - 1][NUM_VARIABLE:0]; 
                    val_out <= stack[counter - 1][NUM_VARIABLE+1];
                    type_out <= stack[counter - 1][NUM_VARIABLE+2];
                    counter <= counter - 1;
                end else if (rw == 1) begin
                    stack[counter] <= [type_in, val, variable];
                    counter <= counter + 1;
                end
                
            end
        end
    end

endmodule