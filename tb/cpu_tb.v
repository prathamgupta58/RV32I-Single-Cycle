`timescale 1ns/1ps

module cpu_tb;

    reg clk;
    reg reset;

    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/cpu_tb.vcd");
        $dumpvars(0, cpu_tb);

        clk = 0;
        reset = 1;

        // Reset CPU
        #10;
        reset = 0;

        // Allow CPU to execute instructions
        #60;

        $display("");
        $display("========================================");
        $display("       RV32I CPU VERIFICATION");
        $display("========================================");

        $display("x1 = %h", uut.registers.registers[1]);
        $display("x2 = %h", uut.registers.registers[2]);
        $display("x3 = %h", uut.registers.registers[3]);
        $display("x4 = %h", uut.registers.registers[4]);

        // Check x1
        if (uut.registers.registers[1] == 32'd1)
            $display("PASS: x1 = 1");
        else
            $display("FAIL: x1 expected 1");

        // Check x2
        if (uut.registers.registers[2] == 32'd2)
            $display("PASS: x2 = 2");
        else
            $display("FAIL: x2 expected 2");

        // Check x3
        if (uut.registers.registers[3] == 32'd3)
            $display("PASS: x3 = 3");
        else
            $display("FAIL: x3 expected 3");

        // Check x4
        if (uut.registers.registers[4] == 32'd3)
            $display("PASS: x4 = 3");
        else
            $display("FAIL: x4 expected 3");

        // Check x0
        if (uut.registers.registers[0] == 32'd0)
            $display("PASS: x0 = 0");
        else
            $display("FAIL: x0 is not zero");

        $display("========================================");

        $finish;
    end

endmodule
