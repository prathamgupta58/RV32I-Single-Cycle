`timescale 1ns/1ps

module register_file_tb;

    reg clk;
    reg reset;

    reg [4:0] rs1;
    reg [4:0] rs2;

    reg [4:0] rd;
    reg [31:0] write_data;
    reg reg_write;

    wire [31:0] read_data1;
    wire [31:0] read_data2;

    register_file uut (
        .clk(clk),
        .reset(reset),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/register_file_tb.vcd");
        $dumpvars(0, register_file_tb);

        clk = 0;
        reset = 1;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        write_data = 0;
        reg_write = 0;

        #10;

        // Release reset
        reset = 0;

        // Write 10 to x1
        rd = 5'd1;
        write_data = 32'd10;
        reg_write = 1;
        #10;

        // Write 20 to x2
        rd = 5'd2;
        write_data = 32'd20;
        reg_write = 1;
        #10;

        // Stop writing and read x1 and x2
        reg_write = 0;
        rs1 = 5'd1;
        rs2 = 5'd2;
        #10;

        // Read x0 (must always be 0)
        rs1 = 5'd0;
        rs2 = 5'd0;
        #10;

        $finish;
    end

endmodule
