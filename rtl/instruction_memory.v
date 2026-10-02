module instruction_memory (
    input  wire [31:0] address,
    output wire [31:0] instruction
);

    reg [31:0] memory [0:255];

    integer i;

    initial begin

        // Fill unused instruction memory with NOPs
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 32'h00000013;

        // Load machine code generated from programs/test.S
        $readmemh("programs/test.hex", memory);

    end

    // Each instruction is 4 bytes
    assign instruction = memory[address[9:2]];

endmodule
