`timescale 1ns/1ps

module branch_tb;

    reg clk;
    reg reset;

    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/branch_tb.vcd");
        $dumpvars(0, branch_tb);

        clk = 0;
        reset = 1;

        // Reset
        #10;
        reset = 0;

        // Run branch program
        #60;

        $display("");
        $display("========================================");
        $display("       BRANCH VERIFICATION");
        $display("========================================");

        $display("x1 = %h", uut.registers.registers[1]);
        $display("x2 = %h", uut.registers.registers[2]);
        $display("x3 = %h", uut.registers.registers[3]);

        // x1 should be 5
        if (uut.registers.registers[1] == 32'd5)
            $display("PASS: x1 = 5");
        else
            $display("FAIL: x1 expected 5");

        // x2 should be 5
        if (uut.registers.registers[2] == 32'd5)
            $display("PASS: x2 = 5");
        else
            $display("FAIL: x2 expected 5");

        // x3 should be 10.
        // If branch failed, x3 would become 99.
        if (uut.registers.registers[3] == 32'd10)
            $display("PASS: BEQ taken, x3 = 10");
        else
            $display("FAIL: Branch did not work correctly");

        $display("========================================");

        $finish;
    end

endmodule
