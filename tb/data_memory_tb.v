`timescale 1ns/1ps

module data_memory_tb;

    reg        clk;
    reg        mem_read;
    reg        mem_write;
    reg [31:0] address;
    reg [31:0] write_data;
    wire [31:0] read_data;

    data_memory uut (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/data_memory_tb.vcd");
        $dumpvars(0, data_memory_tb);

        clk = 0;
        mem_read = 0;
        mem_write = 0;
        address = 32'h00000000;
        write_data = 32'h00000000;

        // Read memory[0] = 100
        #10;
        mem_read = 1;
        address = 32'h00000000;

        // Read memory[1] = 200
        #10;
        address = 32'h00000004;

        // Read memory[2] = 300
        #10;
        address = 32'h00000008;

        // Write 1234 to memory[3]
        #10;
        mem_read = 0;
        mem_write = 1;
        address = 32'h0000000C;
        write_data = 32'h000004D2;

        #10;

        // Read memory[3] back
        mem_write = 0;
        mem_read = 1;
        address = 32'h0000000C;

        #10;

        $finish;
    end

endmodule
