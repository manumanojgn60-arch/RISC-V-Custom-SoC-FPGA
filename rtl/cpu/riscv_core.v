module riscv_core (

    input clk,
    input reset,

    // Instruction interface
    output [31:0] imem_addr,
    input  [31:0] imem_rdata,

    // Data interface
    output reg        dmem_we,
    output reg        dmem_re,
    output reg [31:0] dmem_addr,
    output reg [31:0] dmem_wdata,

    input [31:0] dmem_rdata,

    output [31:0] debug_pc

);

    reg [31:0] pc;

    wire [31:0] instruction;

    assign instruction = imem_rdata;

    // ------------------------------------------------
    // Instruction fields
    // ------------------------------------------------

    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;

    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd  = instruction[11:7];

    // ------------------------------------------------
    // Decoder
    // ------------------------------------------------

    wire reg_write;
    wire mem_read;
    wire mem_write;
    wire alu_src;
    wire branch;
    wire jump;

    wire [3:0] alu_sel;
    wire [2:0] imm_type;

    riscv_decoder decoder (

        .instruction(instruction),

        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),

        .branch(branch),
        .jump(jump),

        .alu_sel(alu_sel),
        .imm_type(imm_type)

    );

    // ------------------------------------------------
    // Register file
    // ------------------------------------------------

    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    reg [31:0] writeback_data;

    riscv_regfile regfile (

        .clk(clk),
        .reset(reset),

        .rs1_addr(rs1),
        .rs2_addr(rs2),

        .rs1_data(rs1_data),
        .rs2_data(rs2_data),

        .reg_write(reg_write),
        .rd_addr(rd),
        .rd_data(writeback_data)

    );

    // ------------------------------------------------
    // Immediate generation
    // ------------------------------------------------

    reg [31:0] immediate;

    always @(*) begin

        case (imm_type)

            // I-Type
            3'b000:

                immediate =
                    {{20{instruction[31]}},
                     instruction[31:20]};

            // S-Type
            3'b001:

                immediate =
                    {{20{instruction[31]}},
                     instruction[31:25],
                     instruction[11:7]};

            // B-Type
            3'b010:

                immediate =
                    {{19{instruction[31]}},
                     instruction[31],
                     instruction[7],
                     instruction[30:25],
                     instruction[11:8],
                     1'b0};

            // U-Type
            3'b011:

                immediate =
                    {instruction[31:12],12'b0};

            // J-Type
            3'b100:

                immediate =
                    {{11{instruction[31]}},
                     instruction[31],
                     instruction[19:12],
                     instruction[20],
                     instruction[30:21],
                     1'b0};

            default:

                immediate = 32'd0;

        endcase

    end

    // ------------------------------------------------
    // ALU
    // ------------------------------------------------

    wire [31:0] alu_b;
    wire [31:0] alu_result;
    wire alu_zero;

    assign alu_b =
        alu_src ? immediate : rs2_data;

    riscv_alu alu (

        .a(rs1_data),
        .b(alu_b),

        .alu_sel(alu_sel),

        .result(alu_result),
        .zero(alu_zero)

    );

    // ------------------------------------------------
    // Data memory interface
    // ------------------------------------------------

    always @(*) begin

        dmem_we    = mem_write;
        dmem_re    = mem_read;

        dmem_addr  = alu_result;
        dmem_wdata = rs2_data;

    end

    // ------------------------------------------------
    // Writeback
    // ------------------------------------------------

    always @(*) begin

        if (mem_read)

            writeback_data = dmem_rdata;

        else if (jump)

            writeback_data = pc + 32'd4;

        else if (imm_type == 3'b011)

            writeback_data = immediate;

        else

            writeback_data = alu_result;

    end

    // ------------------------------------------------
    // Program counter
    // ------------------------------------------------

    always @(posedge clk) begin

        if (reset) begin

            pc <= 32'd0;

        end
        else begin

            if (jump)

                pc <= pc + immediate;

            else if (branch && alu_zero)

                pc <= pc + immediate;

            else

                pc <= pc + 32'd4;

        end

    end

    assign imem_addr = pc;

    assign debug_pc = pc;

endmodule