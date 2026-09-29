module riscv_decoder (

    input [31:0] instruction,

    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg alu_src,

    output reg branch,
    output reg jump,

    output reg [3:0] alu_sel,
    output reg [2:0] imm_type

);

    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;
    localparam ALU_AND = 4'b0010;
    localparam ALU_OR  = 4'b0011;
    localparam ALU_XOR = 4'b0100;
    localparam ALU_SLT = 4'b0101;
    localparam ALU_SLL = 4'b0110;
    localparam ALU_SRL = 4'b0111;
    localparam ALU_SRA = 4'b1000;

    localparam IMM_I = 3'b000;
    localparam IMM_S = 3'b001;
    localparam IMM_B = 3'b010;
    localparam IMM_U = 3'b011;
    localparam IMM_J = 3'b100;

    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];

    always @(*) begin

        reg_write = 1'b0;
        mem_read  = 1'b0;
        mem_write = 1'b0;
        alu_src   = 1'b0;

        branch = 1'b0;
        jump   = 1'b0;

        alu_sel  = ALU_ADD;
        imm_type = IMM_I;

        case (opcode)

            // ADDI / ANDI / ORI / XORI / SLTI
            7'b0010011: begin

                reg_write = 1'b1;
                alu_src   = 1'b1;
                imm_type  = IMM_I;

                case (funct3)

                    3'b000: alu_sel = ALU_ADD;
                    3'b111: alu_sel = ALU_AND;
                    3'b110: alu_sel = ALU_OR;
                    3'b100: alu_sel = ALU_XOR;
                    3'b010: alu_sel = ALU_SLT;

                    default:
                        alu_sel = ALU_ADD;

                endcase

            end

            // R-Type
            7'b0110011: begin

                reg_write = 1'b1;
                alu_src   = 1'b0;

                case (funct3)

                    3'b000:
                        alu_sel =
                        (funct7 == 7'b0100000) ?
                        ALU_SUB : ALU_ADD;

                    3'b111:
                        alu_sel = ALU_AND;

                    3'b110:
                        alu_sel = ALU_OR;

                    3'b100:
                        alu_sel = ALU_XOR;

                    3'b010:
                        alu_sel = ALU_SLT;

                    3'b001:
                        alu_sel = ALU_SLL;

                    3'b101:
                        alu_sel =
                        (funct7 == 7'b0100000) ?
                        ALU_SRA : ALU_SRL;

                    default:
                        alu_sel = ALU_ADD;

                endcase

            end

            // LW
            7'b0000011: begin

                reg_write = 1'b1;
                mem_read  = 1'b1;
                alu_src   = 1'b1;
                alu_sel   = ALU_ADD;
                imm_type  = IMM_I;

            end

            // SW
            7'b0100011: begin

                mem_write = 1'b1;
                alu_src   = 1'b1;
                alu_sel   = ALU_ADD;
                imm_type  = IMM_S;

            end

            // BEQ
            7'b1100011: begin

                branch   = 1'b1;
                alu_sel  = ALU_SUB;
                imm_type = IMM_B;

            end

            // JAL
            7'b1101111: begin

                reg_write = 1'b1;
                jump      = 1'b1;
                imm_type  = IMM_J;

            end

            // LUI
            7'b0110111: begin

                reg_write = 1'b1;
                alu_src   = 1'b1;
                imm_type  = IMM_U;
                alu_sel   = ALU_ADD;

            end

            default: begin
            end

        endcase

    end

endmodule