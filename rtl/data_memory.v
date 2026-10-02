module data_memory (
    input  wire        clk,
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire [31:0] address,
    input  wire [31:0] write_data,
    output wire [31:0] read_data
);

    reg [31:0] memory [0:255];

    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 32'h00000000;

        // Sample initial memory values
        memory[0] = 32'h00000064;   // 100
        memory[1] = 32'h000000C8;   // 200
        memory[2] = 32'h0000012C;   // 300
    end

    // Read operation
    assign read_data = mem_read ? memory[address[9:2]] : 32'h00000000;

    // Write operation
    always @(posedge clk) begin
        if (mem_write)
            memory[address[9:2]] <= write_data;
    end

endmodule
