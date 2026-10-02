module control_unit (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire       funct7_bit5,

    output reg        reg_write,
    output reg        mem_read,
    output reg        mem_write,
    output reg        mem_to_reg,
    output reg        alu_src,
    output reg        branch,
    output reg        jump,
    output reg [3:0]  alu_control
);

    always @(*) begin

        // Default values
        reg_write   = 1'b0;
        mem_read    = 1'b0;
        mem_write   = 1'b0;
        mem_to_reg  = 1'b0;
        alu_src     = 1'b0;
        branch      = 1'b0;
        jump        = 1'b0;
        alu_control = 4'b0000;

        case (opcode)

            // =================================================
            // R-TYPE
            // =================================================
            7'b0110011: begin

                reg_write = 1'b1;
                alu_src   = 1'b0;

                case (funct3)

                    3'b000: begin
                        if (funct7_bit5)
                            alu_control = 4'b0001; // SUB
                        else
                            alu_control = 4'b0000; // ADD
                    end

                    3'b111: alu_control = 4'b0010; // AND
                    3'b110: alu_control = 4'b0011; // OR
                    3'b100: alu_control = 4'b0100; // XOR
                    3'b010: alu_control = 4'b0101; // SLT
                    3'b011: alu_control = 4'b1001; // SLTU

                    // SLL
                    3'b001:
                        alu_control = 4'b0110;

                    // SRL / SRA
                    3'b101: begin
                        if (funct7_bit5)
                            alu_control = 4'b1000; // SRA
                        else
                            alu_control = 4'b0111; // SRL
                    end

                    default:
                        alu_control = 4'b0000;

                endcase
            end


            // =================================================
            // I-TYPE ALU INSTRUCTIONS
            // =================================================
            7'b0010011: begin

                reg_write = 1'b1;
                alu_src   = 1'b1;

                case (funct3)

                    3'b000: alu_control = 4'b0000; // ADDI
                    3'b111: alu_control = 4'b0010; // ANDI
                    3'b110: alu_control = 4'b0011; // ORI
                    3'b100: alu_control = 4'b0100; // XORI
                    3'b010: alu_control = 4'b0101; // SLTI
                    3'b011: alu_control = 4'b1001; // SLTIU

                    // SLLI
                    3'b001:
                        alu_control = 4'b0110;

                    // SRLI / SRAI
                    3'b101: begin
                        if (funct7_bit5)
                            alu_control = 4'b1000; // SRAI
                        else
                            alu_control = 4'b0111; // SRLI
                    end

                    default:
                        alu_control = 4'b0000;

                endcase
            end


            // =================================================
            // LOAD WORD
            // =================================================
            7'b0000011: begin

                reg_write   = 1'b1;
                mem_read    = 1'b1;
                mem_to_reg  = 1'b1;
                alu_src     = 1'b1;
                alu_control = 4'b0000;

            end


            // =================================================
            // STORE WORD
            // =================================================
            7'b0100011: begin

                mem_write   = 1'b1;
                alu_src     = 1'b1;
                alu_control = 4'b0000;

            end


            // =================================================
            // BRANCH INSTRUCTIONS
            // =================================================
            7'b1100011: begin

                branch  = 1'b1;
                alu_src = 1'b0;

                case (funct3)

                    3'b000: alu_control = 4'b0001; // BEQ
                    3'b001: alu_control = 4'b0001; // BNE
                    3'b100: alu_control = 4'b0101; // BLT
                    3'b101: alu_control = 4'b0101; // BGE
                    3'b110: alu_control = 4'b0101; // BLTU
                    3'b111: alu_control = 4'b0101; // BGEU

                    default:
                        alu_control = 4'b0001;

                endcase

            end


            // =================================================
            // JAL
            // =================================================
            7'b1101111: begin

                reg_write   = 1'b1;
                jump        = 1'b1;
                alu_control = 4'b0000;

            end


            // =================================================
            // JALR
            // =================================================
            7'b1100111: begin

                reg_write   = 1'b1;
                jump        = 1'b1;
                alu_src     = 1'b1;
                alu_control = 4'b0000;

            end


            // =================================================
            // LUI
            // =================================================
            7'b0110111: begin

                reg_write   = 1'b1;
                alu_src     = 1'b1;
                alu_control = 4'b0000;

            end


            // =================================================
            // AUIPC
            // =================================================
            7'b0010111: begin

                reg_write = 1'b1;

            end


            // =================================================
            // DEFAULT
            // =================================================
            default: begin
                // Keep default control signals
            end

        endcase

    end

endmodule