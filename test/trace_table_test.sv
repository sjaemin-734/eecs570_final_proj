module trace_table_test;

    // Inputs
    logic                 clk;
    logic                 reset;
    logic                 push;
    logic                 pop;
    logic                 t_type;       // D=0/F=1
    logic                 val;          // Assigned to be T or F
    logic           [8:0] variable;

    // Outputs
    logic          last;         // whether its the last to come out during backpropagation
    logic          type_out;
    logic          val_out;
    logic    [8:0] variable_out;
    logic          empty;
    logic          done;

    trace_table DUT(
        // Inputs
        .clk(clk),
        .reset(reset),
        .push(push),
        .pop(pop),
        .t_type(t_type),
        .val(val),
        .variable(variable),

        // Outputs
        .last(last),
        .type_out(type_out),
        .val_out(val_out),
        .variable_out(variable_out),
        .empty(empty),
        .done(done)
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