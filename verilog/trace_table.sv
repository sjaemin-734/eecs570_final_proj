// 5 variables per clause, 1023 clauses

// Trace Table
module trace_table # (
    parameter NUM_VARIABLE = 128,
    parameter VARIABLE_INDEXES = 8
)
(
    input                                clock,
    input                                reset,
    input                                en,
    input                                rw,           // read/pop = 0, write/push = 1
    input                                type_in,      // Decide = 0, Forced = 1 
    input                                val_in,          // Assigned to be T or F
    input           [VARIABLE_INDEXES:0] variable,
    output logic                         type_out,
    output logic                         val_out,      
    output logic    [VARIABLE_INDEXES:0] variable_out,
    output logic                         empty_out
);
    localparam bit [NUM_VARIABLE:0] COUNTER_RESET_VAL = 0;
    integer i;

    // data structure
    logic [NUM_VARIABLE:0] counter;                               // current index in stack
    logic [NUM_VARIABLE:0] stack[0:(VARIABLE_INDEXES+2)];         // [type [1],val [1], variable index [8:0]]

    // internal variables
    logic type_temp;
    logic val;   
    logic [VARIABLE_INDEXES:0] variable;
    logic empty;
    
    // output
    always_comb begin
        type_out = type_temp;
        val_out = val;
        variable_out = variable;
        empty_out = empty;
    end

    always @(posedge clock) begin
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
                    variable <= stack[counter - 1][VARIABLE_INDEXES:0]; 
                    val <= stack[counter - 1][VARIABLE_INDEXES+1];
                    type_temp <= stack[counter - 1][VARIABLE_INDEXES+2];
                    counter <= counter - 1;
                end else if (rw == 1) begin
                    stack[counter] <= [type_in, val, variable];
                    counter <= counter + 1;
                end
                
            end
        end
    end

endmodule