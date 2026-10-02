`timescale 1ns/1ps

module load_store_tb;

    reg clk;
    reg reset;

    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/load_store_tb.vcd");
        $dumpvars(0, load_store_tb);

        clk = 0;
        reset = 1;

        // Reset CPU
        #10;
        reset = 0;

        // Run program
        #60;

        $display("");
        $display("========================================");
        $display("       LOAD / STORE VERIFICATION");
        $display("========================================");

        $display("x1 = %h", uut.registers.registers[1]);
        $display("x2 = %h", uut.registers.registers[2]);
        $display("x3 = %h", uut.registers.registers[3]);

        // x1 should contain 42
        if (uut.registers.registers[1] == 32'd42)
            $display("PASS: x1 = 42");
        else
            $display("FAIL: x1 expected 42");

        // x2 should contain the value loaded from memory
        if (uut.registers.registers[2] == 32'd42)
            $display("PASS: LW loaded 42 into x2");
        else
            $display("FAIL: LW did not load 42 into x2");

        // x3 should contain 43
        if (uut.registers.registers[3] == 32'd43)
            $display("PASS: x3 = 43");
        else
            $display("FAIL: x3 expected 43");

        // Check memory location 0
        if (uut.dmem.memory[0] == 32'd42)
            $display("PASS: Memory[0] = 42");
        else
            $display("FAIL: Memory[0] expected 42");

        $display("========================================");

        $finish;
    end

endmodule