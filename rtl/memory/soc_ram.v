module soc_ram (
    input clk,

    input        we,
    input [31:0] addr,
    input [31:0] wdata,

    output [31:0] rdata
);

    reg [31:0] memory [0:255];

    integer i;

    initial begin

        for (i = 0; i < 256; i = i + 1)
            memory[i] = 32'd0;

    end

    always @(posedge clk) begin

        if (we)
            memory[addr[9:2]] <= wdata;

    end

    assign rdata = memory[addr[9:2]];

endmodule