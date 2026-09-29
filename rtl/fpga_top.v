module fpga_top (
    input  wire       clk,
    input  wire       reset,
    output wire [7:0] led,
    output wire       uart_tx
);

    wire timer_tick;
    wire [31:0] debug_pc;

    soc_top u_soc (
        .clk        (clk),
        .reset      (reset),
        .gpio       (led),
        .uart_tx    (uart_tx),
        .timer_tick (timer_tick),
        .debug_pc   (debug_pc)
    );

endmodule