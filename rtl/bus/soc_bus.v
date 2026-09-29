module soc_bus (

    input clk,
    input reset,

    // CPU instruction interface
    input  [31:0] imem_addr,
    output [31:0] imem_rdata,

    // CPU data interface
    input         dmem_we,
    input         dmem_re,
    input  [31:0] dmem_addr,
    input  [31:0] dmem_wdata,
    output [31:0] dmem_rdata,

    // GPIO
    output        gpio_write,
    output [31:0] gpio_wdata,
    input  [31:0] gpio_rdata,

    // UART
    output        uart_send,
    output [7:0]  uart_data,

    // Timer
    output        timer_write,
    output [31:0] timer_wdata,
    input  [31:0] timer_rdata,

    // RAM
    output        ram_write,
    output [31:0] ram_addr,
    output [31:0] ram_wdata,
    input  [31:0] ram_rdata,

    // ROM
    input [31:0] rom_rdata

);

    // ------------------------------------------------
    // Instruction bus
    // ------------------------------------------------

    assign imem_rdata = rom_rdata;

    // ------------------------------------------------
    // Address decoding
    // ------------------------------------------------

    wire select_ram;
    wire select_gpio;
    wire select_uart;
    wire select_timer;

    assign select_ram =
        (dmem_addr >= 32'h00001000) &&
        (dmem_addr <  32'h00002000);

    assign select_gpio =
        (dmem_addr == 32'h00002000);

    assign select_uart =
        (dmem_addr == 32'h00003000);

    assign select_timer =
        (dmem_addr == 32'h00004000);

    // ------------------------------------------------
    // RAM
    // ------------------------------------------------

    assign ram_write =
        dmem_we && select_ram;

    assign ram_addr =
        dmem_addr - 32'h00001000;

    assign ram_wdata =
        dmem_wdata;

    // ------------------------------------------------
    // GPIO
    // ------------------------------------------------

    assign gpio_write =
        dmem_we && select_gpio;

    assign gpio_wdata =
        dmem_wdata;

    // ------------------------------------------------
    // UART
    // ------------------------------------------------

    assign uart_send =
        dmem_we && select_uart;

    assign uart_data =
        dmem_wdata[7:0];

    // ------------------------------------------------
    // Timer
    // ------------------------------------------------

    assign timer_write =
        dmem_we && select_timer;

    assign timer_wdata =
        dmem_wdata;

    // ------------------------------------------------
    // Read multiplexer
    // ------------------------------------------------

    reg [31:0] read_data_mux;

    always @(*) begin

        read_data_mux = 32'd0;

        if (dmem_re) begin

            if (select_ram)

                read_data_mux = ram_rdata;

            else if (select_gpio)

                read_data_mux = gpio_rdata;

            else if (select_timer)

                read_data_mux = timer_rdata;

            else

                read_data_mux = 32'd0;

        end

    end

    assign dmem_rdata =
        read_data_mux;

endmodule