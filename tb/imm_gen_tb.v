`timescale 1ns/1ps

module imm_gen_tb;

    reg [31:0] instruction;
    wire [31:0] immediate;

    imm_gen uut (
        .instruction(instruction),
        .immediate(immediate)
    );

    initial begin
        $dumpfile("sim/imm_gen_tb.vcd");
        $dumpvars(0, imm_gen_tb);

        // I-type: ADDI x1, x0, 10
        instruction = 32'h00A00093;
        #10;

        // I-type negative immediate: ADDI x1, x0, -1
        instruction = 32'hFFF00093;
        #10;

        // S-type example
        instruction = 32'h00102223;
        #10;

        // B-type example
        instruction = 32'h00208463;
        #10;

        // U-type: LUI
        instruction = 32'h123450B7;
        #10;

        // J-type example
        instruction = 32'h008000EF;
        #10;

        $finish;
    end

endmodule
