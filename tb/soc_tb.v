`timescale 1ns/1ps

module soc_tb;

    reg clk;
    reg reset;

    wire [7:0]  gpio;
    wire        uart_tx;
    wire        timer_tick;
    wire [31:0] debug_pc;

    // =========================================================
    // DUT
    // =========================================================

    soc_top dut (
        .clk(clk),
        .reset(reset),
        .gpio(gpio),
        .uart_tx(uart_tx),
        .timer_tick(timer_tick),
        .debug_pc(debug_pc)
    );

    // =========================================================
    // CLOCK
    // =========================================================
always @(posedge clk) begin
    if (!reset) begin
        $display(
            "PC=%h | INST=%h | dmem_we=%b | dmem_addr=%h | dmem_wdata=%h | GPIO=%h",
            debug_pc,
            dut.cpu.instruction,
            dut.cpu.dmem_we,
            dut.cpu.dmem_addr,
            dut.cpu.dmem_wdata,
            gpio
        );
    end
end
    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end

    // =========================================================
    // RESET
    // =========================================================

    initial begin

        reset = 1'b1;

        #100;

        reset = 1'b0;

    end

    // =========================================================
    // CPU MONITOR
    // =========================================================

    always @(posedge clk) begin

        $display(
            "TIME=%0t | PC=%h | GPIO=%h | UART=%b | TIMER=%b",
            $time,
            debug_pc,
            gpio,
            uart_tx,
            timer_tick
        );

    end

    // =========================================================
    // REGISTER FILE VERIFICATION
    // =========================================================

    initial begin

        #1000;

        $display("");
        $display("======================================");
        $display("      REGISTER FILE VERIFICATION");
        $display("======================================");

        $display(
            "x1 = %0d",
            dut.cpu.regfile.registers[1]
        );

        $display(
            "x2 = %0d",
            dut.cpu.regfile.registers[2]
        );

        $display(
            "x3 = %0d",
            dut.cpu.regfile.registers[3]
        );

        $display("======================================");
        $display("");

    end

    // =========================================================
    // VCD WAVEFORM
    // =========================================================

    initial begin

        $dumpfile(
            "simulation/waveforms/soc.vcd"
        );

        $dumpvars(
            0,
            soc_tb
        );

    end
    initial begin

    #1000;

    $display("");
    $display("======================================");
    $display("         GPIO VERIFICATION");
    $display("======================================");

    $display(
        "GPIO = 0x%h",
        gpio
    );

    if (gpio == 8'h55) begin

        $display("GPIO TEST: PASS");

    end
    else begin

        $display("GPIO TEST: FAIL");

    end

    $display("======================================");
    $display("");

end

    // =========================================================
    // END SIMULATION
    // =========================================================

    initial begin

        #5000;

        $display("");
        $display("======================================");
        $display("     RISC-V SoC SIMULATION COMPLETE");
        $display("======================================");
        $display("");

        $finish;

    end

endmodule