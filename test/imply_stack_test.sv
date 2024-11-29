module imply_stack_test;

    // Input
    logic                 clock;
    logic                 reset;
    logic                 en;
    logic                 rw;           // read/pop = 0, write/push = 1
    logic                 val;          // Assigned to be T or F
    logic           [8:0] variable;
    
    // Output
    logic            type_out;     //Always 1
    logic            val_out;     
    logic      [8:0] variable_out;
    logic            empty;

    imply_stack DUT(
        // Inputs
        .clock(clock),
        .reset(reset),
        .en(en),
        .rw(rw),
        .val(val),
        .variable(variable),

        // Outputs
        .type_out(type_out),
        .val_out(val_out),
        .variable_out(variable_out),
        .empty(empty)
    );

    always begin
        #(`CLOCK_PERIOD/2.0);
        clock = ~clock;
    end

    initial begin

        // Reset test
        clock = 0;
        reset = 1;

        $monitor("Hello. The test bench compiled.\n");
    end

endmodule