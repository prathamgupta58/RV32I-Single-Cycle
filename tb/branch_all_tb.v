`timescale 1ns/1ps

module branch_all_tb;

    reg clk;
    reg reset;

    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("sim/branch_all_tb.vcd");
        $dumpvars(0, branch_all_tb);

        clk = 0;
        reset = 1;

        // Reset CPU
        #10;
        reset = 0;

        // Run program
        #180;

        $display("");
        $display("========================================");
        $display("       BRANCH INSTRUCTIONS TEST");
        $display("========================================");

        $display("x1 = %h", uut.registers.registers[1]);
        $display("x2 = %h", uut.registers.registers[2]);
        $display("x3 = %h", uut.registers.registers[3]);
        $display("x4 = %h", uut.registers.registers[4]);
        $display("x5 = %h", uut.registers.registers[5]);
        $display("x6 = %h", uut.registers.registers[6]);
        $display("x7 = %h", uut.registers.registers[7]);

        // Check results

        if (uut.registers.registers[1] == 32'd5)
            $display("PASS: x1 = 5");
        else
            $display("FAIL: x1 expected 5");

        if (uut.registers.registers[2] == 32'd10)
            $display("PASS: x2 = 10");
        else
            $display("FAIL: x2 expected 10");

        if (uut.registers.registers[3] == 32'd1)
            $display("PASS: BNE");
        else
            $display("FAIL: BNE");

        if (uut.registers.registers[4] == 32'd2)
            $display("PASS: BLT");
        else
            $display("FAIL: BLT");

        if (uut.registers.registers[5] == 32'd3)
            $display("PASS: BGE");
        else
            $display("FAIL: BGE");

        if (uut.registers.registers[6] == 32'd4)
            $display("PASS: BLTU");
        else
            $display("FAIL: BLTU");

        if (uut.registers.registers[7] == 32'd5)
            $display("PASS: BGEU");
        else
            $display("FAIL: BGEU");

        $display("========================================");

        $finish;

    end

endmodule