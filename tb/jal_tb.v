`timescale 1ns/1ps

module jal_tb;

    reg clk;
    reg reset;

    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/jal_tb.vcd");
        $dumpvars(0, jal_tb);

        clk = 0;
        reset = 1;

        // Reset CPU
        #10;
        reset = 0;

        // Run JAL program
        #50;

        $display("");
        $display("========================================");
        $display("          JAL VERIFICATION");
        $display("========================================");

        $display("x1 = %h", uut.registers.registers[1]);
        $display("x2 = %h", uut.registers.registers[2]);
        $display("PC = %h", uut.pc);

        // JAL should store PC + 4 = 4 in x1
        if (uut.registers.registers[1] == 32'd4)
            $display("PASS: JAL saved PC + 4 in x1");
        else
            $display("FAIL: x1 expected 4");

        // The instruction at address 4 should be skipped.
        // x2 should therefore become 42, not 99.
        if (uut.registers.registers[2] == 32'd42)
            $display("PASS: JAL jumped to address 8");
        else
            $display("FAIL: JAL did not jump correctly");

        $display("========================================");

        $finish;
    end

endmodule