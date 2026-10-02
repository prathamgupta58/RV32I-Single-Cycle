`timescale 1ns/1ps

module lui_tb;

    reg clk;
    reg reset;

    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("sim/lui_tb.vcd");
        $dumpvars(0, lui_tb);

        clk = 0;
        reset = 1;

        // Reset CPU
        #10;
        reset = 0;

        // Run LUI program
        #30;

        $display("");
        $display("========================================");
        $display("           LUI VERIFICATION");
        $display("========================================");

        $display("x5 = %h", uut.registers.registers[5]);

        // LUI x5, 0x12345
        // Expected: 0x12345000
        if (uut.registers.registers[5] == 32'h12345000)
            $display("PASS: LUI loaded 0x12345000 into x5");
        else
            $display("FAIL: x5 expected 0x12345000");

        $display("========================================");

        $finish;

    end

endmodule