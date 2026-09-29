module soc_top (

    input clk,
    input reset,

    output [7:0] gpio,

    output uart_tx,

    output timer_tick,

    output [31:0] debug_pc

);

    // ------------------------------------------------
    // CPU instruction bus
    // ------------------------------------------------

    wire [31:0] imem_addr;
    wire [31:0] imem_rdata;

    // ------------------------------------------------
    // CPU data bus
    // ------------------------------------------------

    wire        dmem_we;
    wire        dmem_re;

    wire [31:0] dmem_addr;
    wire [31:0] dmem_wdata;
    wire [31:0] dmem_rdata;

    // ------------------------------------------------
    // ROM
    // ------------------------------------------------

    wire [31:0] rom_rdata;

    soc_rom rom (

        .addr(imem_addr),

        .data(rom_rdata)

    );

    // ------------------------------------------------
    // RAM
    // ------------------------------------------------

    wire        ram_write;
    wire [31:0] ram_addr;
    wire [31:0] ram_wdata;
    wire [31:0] ram_rdata;

    soc_ram ram (

        .clk(clk),

        .we(ram_write),

        .addr(ram_addr),
        .wdata(ram_wdata),

        .rdata(ram_rdata)

    );

    // ------------------------------------------------
    // GPIO
    // ------------------------------------------------

    wire        gpio_write;
    wire [31:0] gpio_wdata;
    wire [31:0] gpio_rdata;

    gpio gpio_unit (

        .clk(clk),
        .reset(reset),

        .write_en(gpio_write),
        .read_en(1'b0),

        .write_data(gpio_wdata),

        .read_data(gpio_rdata),

        .gpio_out(gpio)

    );

    // ------------------------------------------------
    // UART
    // ------------------------------------------------

    wire       uart_send;
    wire [7:0] uart_data;

    uart_tx #(
        .CLK_DIV(10)
    ) uart_unit (

        .clk(clk),
        .reset(reset),

        .send(uart_send),
        .data(uart_data),

        .tx(uart_tx),
        .busy()

    );

    // ------------------------------------------------
    // Timer
    // ------------------------------------------------

    wire        timer_write;
    wire [31:0] timer_wdata;
    wire [31:0] timer_rdata;

    timer timer_unit (

        .clk(clk),
        .reset(reset),

        .write_en(timer_write),
        .write_data(timer_wdata),

        .read_data(timer_rdata),

        .tick(timer_tick)

    );

    // ------------------------------------------------
    // Bus
    // ------------------------------------------------

    soc_bus bus (

        .clk(clk),
        .reset(reset),

        .imem_addr(imem_addr),
        .imem_rdata(imem_rdata),

        .dmem_we(dmem_we),
        .dmem_re(dmem_re),

        .dmem_addr(dmem_addr),
        .dmem_wdata(dmem_wdata),

        .dmem_rdata(dmem_rdata),

        .gpio_write(gpio_write),
        .gpio_wdata(gpio_wdata),
        .gpio_rdata(gpio_rdata),

        .uart_send(uart_send),
        .uart_data(uart_data),

        .timer_write(timer_write),
        .timer_wdata(timer_wdata),
        .timer_rdata(timer_rdata),

        .ram_write(ram_write),
        .ram_addr(ram_addr),
        .ram_wdata(ram_wdata),
        .ram_rdata(ram_rdata),

        .rom_rdata(rom_rdata)

    );

    // ------------------------------------------------
    // CPU
    // ------------------------------------------------

    riscv_core cpu (

        .clk(clk),
        .reset(reset),

        .imem_addr(imem_addr),
        .imem_rdata(imem_rdata),

        .dmem_we(dmem_we),
        .dmem_re(dmem_re),

        .dmem_addr(dmem_addr),
        .dmem_wdata(dmem_wdata),

        .dmem_rdata(dmem_rdata),

        .debug_pc(debug_pc)

    );

endmodule