`timescale 1ns/1ps

module full_cpu_tb;

    reg clk;
    reg reset;

    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin

        // ========================================
        // GTKWave waveform dump
        // ========================================
        $dumpfile("sim/final_cpu.vcd");
        $dumpvars(0, full_cpu_tb);

        // ========================================
        // RESET
        // ========================================
        clk = 0;
        reset = 1;

        #10;
        reset = 0;

        // ========================================
        // RUN COMPLETE RV32I PROGRAM
        // ========================================
        #230;

        // ========================================
        // DISPLAY RESULTS
        // ========================================
        $display("");
        $display("========================================");
        $display("       FINAL RV32I CPU VERIFICATION");
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
        $display("x11 = %h", uut.registers.registers[11]);
        $display("x12 = %h", uut.registers.registers[12]);
        $display("x13 = %h", uut.registers.registers[13]);
        $display("x14 = %h", uut.registers.registers[14]);
        $display("x15 = %h", uut.registers.registers[15]);
        $display("x16 = %h", uut.registers.registers[16]);
        $display("x17 = %h", uut.registers.registers[17]);

        $display("----------------------------------------");

        // ========================================
        // VERIFICATION
        // ========================================

        if (uut.registers.registers[1] == 32'd10)
            $display("PASS: ADDI x1");
        else
            $display("FAIL: ADDI x1");

        if (uut.registers.registers[2] == 32'd5)
            $display("PASS: ADDI x2");
        else
            $display("FAIL: ADDI x2");

        if (uut.registers.registers[3] == 32'd15)
            $display("PASS: ADD");
        else
            $display("FAIL: ADD");

        if (uut.registers.registers[4] == 32'd5)
            $display("PASS: SUB");
        else
            $display("FAIL: SUB");

        if (uut.registers.registers[5] == 32'd0)
            $display("PASS: AND");
        else
            $display("FAIL: AND");

        if (uut.registers.registers[6] == 32'd15)
            $display("PASS: OR");
        else
            $display("FAIL: OR");

        if (uut.registers.registers[7] == 32'd15)
            $display("PASS: XOR");
        else
            $display("FAIL: XOR");

        // x8 = 10 << 5 = 320
        if (uut.registers.registers[8] == 32'd320)
            $display("PASS: SLL");
        else
            $display("FAIL: SLL");

        // x9 = 10 >> 10 = 0
        if (uut.registers.registers[9] == 32'd0)
            $display("PASS: SRL");
        else
            $display("FAIL: SRL");

        // 10 < 5 = false
        if (uut.registers.registers[10] == 32'd0)
            $display("PASS: SLT");
        else
            $display("FAIL: SLT");

        // x11 = x1 + 20 = 30
        if (uut.registers.registers[11] == 32'd30)
            $display("PASS: ADDI immediate");
        else
            $display("FAIL: ADDI immediate");

        // x12 = memory[0] = 30
        if (uut.registers.registers[12] == 32'd30)
            $display("PASS: LW");
        else
            $display("FAIL: LW");

        // Branch result
        if (uut.registers.registers[13] == 32'd13)
            $display("PASS: BEQ branch");
        else
            $display("FAIL: BEQ branch");

        // LUI
        if (uut.registers.registers[14] == 32'h12345000)
            $display("PASS: LUI");
        else
            $display("FAIL: LUI");

        // AUIPC
        if (uut.registers.registers[15] == 32'h00001044)
            $display("PASS: AUIPC");
        else
            $display("FAIL: AUIPC");

        // JAL
        if (uut.registers.registers[16] == 32'd76)
            $display("PASS: JAL");
        else
            $display("FAIL: JAL");

        // JAL target
        if (uut.registers.registers[17] == 32'd17)
            $display("PASS: JAL target");
        else
            $display("FAIL: JAL target");

        // Store
        if (uut.dmem.memory[0] == 32'd30)
            $display("PASS: SW");
        else
            $display("FAIL: SW");

        $display("========================================");

        $finish;

    end

endmodule
