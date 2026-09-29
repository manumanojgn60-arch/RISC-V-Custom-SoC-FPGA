module soc_rom (
    input  [31:0] addr,
    output [31:0] data
);

    reg [31:0] memory [0:255];

    integer i;

    initial begin

        for (i = 0; i < 256; i = i + 1)
            memory[i] = 32'h00000013;

        $readmemh("software/program.hex", memory);

    end

    assign data = memory[addr[9:2]];

endmodule