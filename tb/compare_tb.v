`timescale 1ns/1ps

module compare_tb;

    reg clk;
    reg reset;

    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;

        #10;
        reset = 0;

        // Run comparison program
        #100;

        $display("");
        $display("========================================");
        $display("     COMPARISON INSTRUCTIONS TEST");
        $display("========================================");

        $display("x1  = %h", uut.registers.registers[1]);
        $display("x2  = %h", uut.registers.registers[2]);
        $display("x3  = %h", uut.registers.registers[3]);
        $display("x4  = %h", uut.registers.registers[4]);
        $display("x5  = %h", uut.registers.registers[5]);
        $display("x6  = %h", uut.registers.registers[6]);
        $display("x7  = %h", uut.registers.registers[7]);
        $display("x8  = %h", uut.registers.registers[8]);
        $display("x9  = %h", uut.registers.registers[9]);
        $display("x10 = %h", uut.registers.registers[10]);

        if (uut.registers.registers[3] == 32'd1)
            $display("PASS: SLT 5 < 10");
        else
            $display("FAIL: SLT 5 < 10");

        if (uut.registers.registers[4] == 32'd0)
            $display("PASS: SLT 10 < 5");
        else
            $display("FAIL: SLT 10 < 5");

        if (uut.registers.registers[7] == 32'd1)
            $display("PASS: SLT -1 < 1");
        else
            $display("FAIL: SLT -1 < 1");

        if (uut.registers.registers[8] == 32'd0)
            $display("PASS: SLTU 0xFFFFFFFF < 1 is false");
        else
            $display("FAIL: SLTU 0xFFFFFFFF < 1");

        if (uut.registers.registers[9] == 32'd1)
            $display("PASS: SLTI 5 < 10");
        else
            $display("FAIL: SLTI 5 < 10");

        if (uut.registers.registers[10] == 32'd0)
            $display("PASS: SLTI 10 < 5");
        else
            $display("FAIL: SLTI 10 < 5");

        $display("========================================");

        $finish;

    end

endmodule