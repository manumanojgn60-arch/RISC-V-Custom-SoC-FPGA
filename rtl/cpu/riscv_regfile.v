module riscv_regfile (
    input  wire        clk,
    input  wire        reset,

    // Read ports
    input  wire [4:0]  rs1_addr,
    input  wire [4:0]  rs2_addr,

    output wire [31:0] rs1_data,
    output wire [31:0] rs2_data,

    // Write port
    input  wire        reg_write,
    input  wire [4:0]  rd_addr,
    input  wire [31:0] rd_data
);

    // 32 registers, each 32 bits
    reg [31:0] registers [0:31];

    integer i;

    // Write operation
    always @(posedge clk) begin

        if (reset) begin

            // Reset all registers
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'h00000000;

        end
        else begin

            // x0 is always zero
            if (reg_write && (rd_addr != 5'd0))
                registers[rd_addr] <= rd_data;

        end

    end

    // Read operations
    // x0 always returns zero
    assign rs1_data =
        (rs1_addr == 5'd0) ?
        32'h00000000 :
        registers[rs1_addr];

    assign rs2_data =
        (rs2_addr == 5'd0) ?
        32'h00000000 :
        registers[rs2_addr];

endmodule