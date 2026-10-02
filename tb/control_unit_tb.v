`timescale 1ns/1ps

module control_unit_tb;

    reg [6:0] opcode;
    reg [2:0] funct3;
    reg       funct7_bit5;

    wire      reg_write;
    wire      mem_read;
    wire      mem_write;
    wire      mem_to_reg;
    wire      alu_src;
    wire      branch;
    wire      jump;
    wire [3:0] alu_control;

    control_unit uut (
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

    initial begin
        $dumpfile("sim/control_unit_tb.vcd");
        $dumpvars(0, control_unit_tb);

        // R-type ADD
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7_bit5 = 1'b0;
        #10;

        // R-type SUB
        funct7_bit5 = 1'b1;
        #10;

        // I-type ADDI
        opcode = 7'b0010011;
        funct3 = 3'b000;
        funct7_bit5 = 1'b0;
        #10;

        // LW
        opcode = 7'b0000011;
        funct3 = 3'b010;
        #10;

        // SW
        opcode = 7'b0100011;
        funct3 = 3'b010;
        #10;

        // BEQ
        opcode = 7'b1100011;
        funct3 = 3'b000;
        #10;

        // JAL
        opcode = 7'b1101111;
        funct3 = 3'b000;
        #10;

        // LUI
        opcode = 7'b0110111;
        #10;

        $finish;
    end

endmodule
