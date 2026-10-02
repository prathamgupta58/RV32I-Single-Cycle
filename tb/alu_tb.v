`timescale 1ns/1ps

module alu_tb;

    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] alu_control;

    wire [31:0] result;
    wire zero;

    alu uut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    initial begin
        $dumpfile("sim/alu_tb.vcd");
        $dumpvars(0, alu_tb);

        // ADD: 10 + 5 = 15
        a = 32'd10;
        b = 32'd5;
        alu_control = 4'b0000;
        #10;

        // SUB: 10 - 5 = 5
        alu_control = 4'b0001;
        #10;

        // AND
        a = 32'hF0F0F0F0;
        b = 32'h0F0F0F0F;
        alu_control = 4'b0010;
        #10;

        // OR
        alu_control = 4'b0011;
        #10;

        // XOR
        alu_control = 4'b0100;
        #10;

        // SLT: 5 < 10 = 1
        a = 32'd5;
        b = 32'd10;
        alu_control = 4'b0101;
        #10;

        // Zero flag: 10 - 10 = 0
        a = 32'd10;
        b = 32'd10;
        alu_control = 4'b0001;
        #10;

        $finish;
    end

endmodule
