// 5 variables per clause, 1023 clauses

// Trace Table
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
    localparam bit [NUM_VARIABLE:0] COUNTER_RESET_VAL = 0;

    // state logic
    enum logic {
        IDLE,
        POP,
        PUSH
    } state = IDLE;

    // data structure
    reg [NUM_VARIABLE:0] counter;               // current index in stack
    reg [NUM_VARIABLE:0][(VARIABLE_INDEXES+2):0] trace_stack;         // [type [1], val [1], variable index [8:0]]

    always @(posedge clk) begin
        if (reset) begin
            counter <= COUNTER_RESET_VAL;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    last <= 1'b0;
                    if (pop) begin
                        counter <= counter - 1;
                        state <= POP;
                    end
                    if (push) state <= PUSH;
                end
                POP: begin
                    trace_stack[counter] <= [t_type, val, variable];
                    counter <= counter + 1;
                    done <= 1'b1;
                    state <= IDLE;
                end
                PUSH: begin
                    val_out <= trace[stack][VARIABLE_INDEXES + 2];
                    type_out <= trace[stack][VARIABLE_INDEXES + 1];
                    variable_out <= trace[stack][VARIABLE_INDEXES:0];
                    done <= 1'b1;
                    if (~trace[stack][VARIABLE_INDEXES + 1]) begin
                        last <= 1'b1;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        counter <= counter - 1;
                    end
                    
                end
            endcase
        end
    end

endmodule