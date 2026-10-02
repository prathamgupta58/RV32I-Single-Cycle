`timescale 1ns/1ps

module shift_tb;

    reg clk;
    reg reset;

    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("sim/shift_tb.vcd");
        $dumpvars(0, shift_tb);

        clk = 0;
        reset = 1;

        // Reset CPU
        #10;
        reset = 0;

        // Run shift program
        #100;

        $display("");
        $display("========================================");
        $display("       SHIFT INSTRUCTIONS TEST");
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

        // SLL
        if (uut.registers.registers[3] == 32'd8)
            $display("PASS: SLL");
        else
            $display("FAIL: SLL");

        // SRL
        if (uut.registers.registers[5] == 32'd2)
            $display("PASS: SRL");
        else
            $display("FAIL: SRL");

        // SRA
        if (uut.registers.registers[7] == 32'hFFFFFFFE)
            $display("PASS: SRA");
        else
            $display("FAIL: SRA");

        // SLLI
        if (uut.registers.registers[8] == 32'd16)
            $display("PASS: SLLI");
        else
            $display("FAIL: SLLI");

        // SRLI
        if (uut.registers.registers[9] == 32'd4)
            $display("PASS: SRLI");
        else
            $display("FAIL: SRLI");

        // SRAI
        if (uut.registers.registers[10] == 32'hFFFFFFFC)
            $display("PASS: SRAI");
        else
            $display("FAIL: SRAI");

        $display("========================================");

        $finish;

    end

endmodule