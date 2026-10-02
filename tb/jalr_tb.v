`timescale 1ns/1ps

module jalr_tb;

    reg clk;
    reg reset;

    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/jalr_tb.vcd");
        $dumpvars(0, jalr_tb);

        clk = 0;
        reset = 1;

        // Reset CPU
        #10;
        reset = 0;

        // Run JALR program
        #50;

        $display("");
        $display("========================================");
        $display("          JALR VERIFICATION");
        $display("========================================");

        $display("x1 = %h", uut.registers.registers[1]);
        $display("x2 = %h", uut.registers.registers[2]);
        $display("x3 = %h", uut.registers.registers[3]);
        $display("PC = %h", uut.pc);

        // x1 should contain 12
        if (uut.registers.registers[1] == 32'd12)
            $display("PASS: x1 = 12");
        else
            $display("FAIL: x1 expected 12");

        // JALR should save PC + 4 = 8 into x2
        if (uut.registers.registers[2] == 32'd8)
            $display("PASS: JALR saved PC + 4 in x2");
        else
            $display("FAIL: x2 expected 8");

        // Address 8 should be skipped.
        // Therefore x3 should become 42, not 99.
        if (uut.registers.registers[3] == 32'd42)
            $display("PASS: JALR jumped to address 12");
        else
            $display("FAIL: JALR did not jump correctly");

        $display("========================================");

        $finish;
    end

endmodule