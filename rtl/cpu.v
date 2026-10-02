module cpu (
    input wire clk,
    input wire reset
);

    // =========================================================
    // PROGRAM COUNTER
    // =========================================================

    wire [31:0] pc;
    reg  [31:0] next_pc;

    pc pc_unit (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );


    // =========================================================
    // INSTRUCTION MEMORY
    // =========================================================

    wire [31:0] instruction;

    instruction_memory imem (
        .address(pc),
        .instruction(instruction)
    );


    // =========================================================
    // INSTRUCTION FIELDS
    // =========================================================

    wire [6:0] opcode;
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [2:0] funct3;
    wire       funct7_bit5;

    assign opcode      = instruction[6:0];
    assign rd          = instruction[11:7];
    assign funct3      = instruction[14:12];
    assign rs1         = instruction[19:15];
    assign rs2         = instruction[24:20];
    assign funct7_bit5 = instruction[30];


    // =========================================================
    // CONTROL UNIT
    // =========================================================

    wire       reg_write;
    wire       mem_read;
    wire       mem_write;
    wire       mem_to_reg;
    wire       alu_src;
    wire       branch;
    wire       jump;
    wire [3:0] alu_control;

    control_unit control (
        .opcode(opcode),
        .funct3(funct3),
        .funct7_bit5(funct7_bit5),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump),
        .alu_control(alu_control)
    );


    // =========================================================
    // REGISTER FILE
    // =========================================================

    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] write_back_data;

    register_file registers (
        .clk(clk),
        .reset(reset),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_back_data),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );


    // =========================================================
    // IMMEDIATE GENERATOR
    // =========================================================

    wire [31:0] immediate;

    imm_gen immediate_generator (
        .instruction(instruction),
        .immediate(immediate)
    );


    // =========================================================
    // LUI / AUIPC DETECTION
    // =========================================================

    wire is_lui;
    wire is_auipc;

    assign is_lui   = (opcode == 7'b0110111);
    assign is_auipc = (opcode == 7'b0010111);


    // =========================================================
    // ALU INPUT SELECTION
    // =========================================================

    wire [31:0] alu_input_b;

    assign alu_input_b = alu_src ? immediate : read_data2;


    // =========================================================
    // ALU
    // =========================================================

    wire [31:0] alu_result;
    wire        zero;

    alu alu_unit (
        .a(read_data1),
        .b(alu_input_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero)
    );


    // =========================================================
    // DATA MEMORY
    // =========================================================

    wire [31:0] memory_read_data;

    data_memory dmem (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(alu_result),
        .write_data(read_data2),
        .read_data(memory_read_data)
    );


    // =========================================================
    // PC TARGET CALCULATIONS
    // =========================================================

    wire [31:0] pc_plus_4;
    wire [31:0] branch_target;
    wire [31:0] jump_target;

    assign pc_plus_4 = pc + 32'd4;

    assign branch_target = pc + immediate;


    // =========================================================
    // JUMP TARGET
    // =========================================================

    // JAL:
    //     PC = PC + immediate
    //
    // JALR:
    //     PC = (rs1 + immediate) & ~1

    assign jump_target =
        (opcode == 7'b1100111) ?
        ((read_data1 + immediate) & 32'hFFFFFFFE) :
        (pc + immediate);


    // =========================================================
    // WRITE-BACK
    // =========================================================

    // JAL/JALR -> PC + 4
    // LW       -> memory data
    // LUI      -> immediate
    // AUIPC    -> PC + immediate
    // Others   -> ALU result

    assign write_back_data =
        jump       ? pc_plus_4 :
        mem_to_reg ? memory_read_data :
        is_lui     ? immediate :
        is_auipc   ? (pc + immediate) :
                     alu_result;


    // =========================================================
    // BRANCH CONDITION LOGIC
    // =========================================================

    reg branch_taken;

    always @(*) begin

        branch_taken = 1'b0;

        if (branch) begin

            case (funct3)

                // BEQ: Branch if Equal
                3'b000:
                    branch_taken = zero;

                // BNE: Branch if Not Equal
                3'b001:
                    branch_taken = ~zero;

                // BLT: Branch if Less Than (signed)
                3'b100:
                    branch_taken =
                        ($signed(read_data1) < $signed(read_data2));

                // BGE: Branch if Greater or Equal (signed)
                3'b101:
                    branch_taken =
                        ($signed(read_data1) >= $signed(read_data2));

                // BLTU: Branch if Less Than (unsigned)
                3'b110:
                    branch_taken =
                        (read_data1 < read_data2);

                // BGEU: Branch if Greater or Equal (unsigned)
                3'b111:
                    branch_taken =
                        (read_data1 >= read_data2);

                default:
                    branch_taken = 1'b0;

            endcase

        end

    end


    // =========================================================
    // NEXT PC LOGIC
    // =========================================================

    always @(*) begin

        // Default:
        // Go to next instruction
        next_pc = pc_plus_4;

        // Taken branch
        if (branch && branch_taken)
            next_pc = branch_target;

        // JAL or JALR
        if (jump)
            next_pc = jump_target;

    end

endmodule