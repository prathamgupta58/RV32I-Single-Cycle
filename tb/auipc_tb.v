`timescale 1ns/1ps

module auipc_tb;

    reg clk;
    reg reset;

    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("sim/auipc_tb.vcd");
        $dumpvars(0, auipc_tb);

        clk = 0;
        reset = 1;

        // Reset CPU
        #10;
        reset = 0;

        // Run AUIPC program
        #30;

        $display("");
        $display("========================================");
        $display("          AUIPC VERIFICATION");
        $display("========================================");

        $display("x5 = %h", uut.registers.registers[5]);
        $display("PC = %h", uut.pc);

        // AUIPC x5, 0x12345
        //
        // At PC = 0:
        // x5 = 0 + 0x12345000
        //
        // Expected:
        // x5 = 0x12345000

        if (uut.registers.registers[5] == 32'h12345000)
            $display("PASS: AUIPC calculated PC + immediate correctly");
        else
            $display("FAIL: x5 expected 0x12345000");

        $display("========================================");

        $finish;

    end

endmodule