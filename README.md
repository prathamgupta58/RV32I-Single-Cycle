# RV32I Single-Cycle RISC-V CPU

A 32-bit RISC-V RV32I single-cycle processor designed in Verilog HDL and verified through RTL simulation using Icarus Verilog and GTKWave.

## Project Overview

This project implements a basic single-cycle RISC-V processor based on the RV32I instruction set architecture (ISA).

The processor executes supported instructions through a single-cycle datapath containing a program counter, instruction memory, register file, immediate generator, ALU, control unit, data memory, and branch/jump logic.

The design was developed and verified at the RTL level before proceeding to FPGA implementation.

## Features

- 32-bit RISC-V architecture
- Single-cycle processor datapath
- Program Counter (PC)
- Instruction Memory
- 32-register Register File with x0 hardwired to zero
- Immediate Generator
- Arithmetic Logic Unit (ALU)
- Control Unit and instruction decoding
- Data Memory
- Branch and Jump Logic
- Load and Store operations
- LUI and AUIPC instructions
- RISC-V assembly integration
- RTL simulation using Icarus Verilog
- Waveform inspection using GTKWave
- RISC-V GNU Toolchain integration
- RTL prepared for the FPGA implementation workflow

## Supported Instructions

The following instructions are supported by the current design.

### R-Type Instructions

| Instruction | Operation |
|---|---|
| ADD | Addition |
| SUB | Subtraction |
| AND | Bitwise AND |
| OR | Bitwise OR |
| XOR | Bitwise XOR |
| SLL | Logical left shift |
| SRL | Logical right shift |
| SRA | Arithmetic right shift |
| SLT | Signed comparison |
| SLTU | Unsigned comparison |

### I-Type Instructions

| Instruction | Operation |
|---|---|
| ADDI | Add immediate |
| ANDI | AND immediate |
| ORI | OR immediate |
| XORI | XOR immediate |
| SLTI | Signed comparison with immediate |
| SLTIU | Unsigned comparison with immediate |
| SLLI | Logical left shift immediate |
| SRLI | Logical right shift immediate |
| SRAI | Arithmetic right shift immediate |

### Load and Store Instructions

| Instruction | Operation |
|---|---|
| LW | Load 32-bit word |
| SW | Store 32-bit word |

### Branch Instructions

| Instruction | Operation |
|---|---|
| BEQ | Branch if equal |
| BNE | Branch if not equal |
| BLT | Branch if less than, signed |
| BGE | Branch if greater than or equal, signed |
| BLTU | Branch if less than, unsigned |
| BGEU | Branch if greater than or equal, unsigned |

### Jump Instructions

| Instruction | Operation |
|---|---|
| JAL | Jump and link |
| JALR | Jump and link register |

### Upper Immediate Instructions

| Instruction | Operation |
|---|---|
| LUI | Load upper immediate |
| AUIPC | Add upper immediate to PC |

## CPU Architecture

The following diagram illustrates the datapath of the RV32I single-cycle RISC-V processor.

<p align="center">
  <img src="RV32I%20Single-Cycle%20CPU%20Datapath%20Diagram.png"
       alt="RV32I Single-Cycle CPU Datapath Diagram"
       width="100%">
</p>
## Project Structure

```text
RV32I-Single-Cycle/
├── rtl/
│   ├── alu.v
│   ├── control_unit.v
│   ├── cpu.v
│   ├── data_memory.v
│   ├── imm_gen.v
│   ├── instruction_memory.v
│   ├── pc.v
│   └── register_file.v
├── tb/
│   ├── alu_tb.v
│   ├── auipc_tb.v
│   ├── branch_all_tb.v
│   ├── branch_tb.v
│   ├── compare_tb.v
│   ├── control_unit_tb.v
│   ├── cpu_tb.v
│   ├── data_memory_tb.v
│   ├── full_cpu_tb.v
│   ├── imm_gen_tb.v
│   ├── instruction_memory_tb.v
│   ├── jal_tb.v
│   ├── jalr_tb.v
│   ├── load_store_tb.v
│   ├── lui_tb.v
│   ├── pc_tb.v
│   ├── register_file_tb.v
│   └── shift_tb.v
├── programs/
│   ├── test.S
│   ├── test.hex
│   ├── test.bin
│   ├── test.o
│   └── instruction_memory_backup.v
├── sim/
│   ├── final_cpu.vcd
│   ├── final_cpu.gtkw
│   ├── full_cpu_tb.out
│   └── archive/
└── README.md
```

The `sim/` directory contains simulation artifacts. Generated files such as `.out`, `.vcd`, and `.gtkw` files may be recreated during testing.

## Tools and Technologies

| Tool | Purpose |
|---|---|
| Verilog HDL | RTL hardware description |
| Icarus Verilog | RTL compilation and simulation |
| GTKWave | Waveform analysis |
| RISC-V GNU Toolchain | Assembly compilation and machine-code generation |
| GNU Objdump | Machine-code disassembly |
| GNU Objcopy | Object-file conversion |
| VS Code | Source-code development |
| WSL 2 with Ubuntu | Linux development environment on Windows |
| Git | Version control |
| Xilinx Vivado | Planned synthesis and FPGA implementation |

## Build and Simulation Instructions

### 1. Open the project directory

Run the following commands in the Ubuntu terminal:

```bash
cd ~/RV32I-Single-Cycle
```

### 2. Compile the assembly program

```bash
riscv64-unknown-elf-gcc \
  -march=rv32i \
  -mabi=ilp32 \
  -c programs/test.S \
  -o programs/test.o
```

This command assembles the program into a relocatable RISC-V object file.

### 3. Convert the object file to binary

```bash
riscv64-unknown-elf-objcopy \
  -O binary \
  programs/test.o \
  programs/test.bin
```

For a production-ready build flow, use a linker script or explicit section placement so the program's instruction addresses and memory layout match the CPU's instruction memory.

### 4. Generate the hexadecimal file

The following command converts each four-byte instruction into a little-endian hexadecimal word:

```bash
xxd -p -c 4 programs/test.bin |
awk '{
  if (length($0) == 8)
    print substr($0,7,2) substr($0,5,2) \
          substr($0,3,2) substr($0,1,2)
}' > programs/test.hex
```

Ensure the generated hex format matches the format expected by the instruction memory. The instruction memory must also be configured to load this file if assembly integration is being tested.

### 5. Compile the full CPU testbench

```bash
iverilog -o sim/full_cpu_tb.out \
  rtl/*.v tb/full_cpu_tb.v
```

### 6. Run the simulation

```bash
vvp sim/full_cpu_tb.out
```

Review the simulation output and confirm that the expected checks pass.

## Verification

The processor has been tested using individual module testbenches and a complete CPU testbench.

The recorded final verification output reports **18 out of 18 checks passing**.

```text
========================================
       FINAL RV32I CPU VERIFICATION
========================================

PASS: ADDI x1
PASS: ADDI x2
PASS: ADD
PASS: SUB
PASS: AND
PASS: OR
PASS: XOR
PASS: SLL
PASS: SRL
PASS: SLT
PASS: ADDI immediate
PASS: LW
PASS: BEQ branch
PASS: LUI
PASS: AUIPC
PASS: JAL
PASS: JAL target
PASS: SW

========================================
             18 / 18 PASS
========================================
```

### Verification Coverage

The project's testbenches cover the following areas:

- Arithmetic operations
- Logical operations
- Shift operations
- Signed and unsigned comparisons
- Immediate operations
- Load and Store operations
- Branch instructions
- Upper immediate instructions
- Jump and jump-target execution
- Individual RTL modules and integrated CPU operation

The 18/18 result represents the checks shown in the recorded final test output. It should not be interpreted as exhaustive verification of every supported instruction or every possible input condition.

## GTKWave Waveform Analysis

GTKWave is used to inspect internal CPU signals and understand the processor's operation during simulation.

### Open the waveform

```bash
gtkwave sim/final_cpu.vcd
```

If the waveform does not exist, regenerate it by compiling and running a testbench that contains the appropriate `$dumpfile` and `$dumpvars` statements.

### Important Signals

| Signal | Purpose |
|---|---|
| Clock | Synchronizes sequential operations |
| Reset | Initializes the processor |
| Program Counter | Holds the current instruction address |
| Instruction | Contains the fetched machine instruction |
| ALU Result | Holds the ALU output |
| Register Operands | Values read from the register file |
| Immediate Value | Sign-extended or otherwise decoded immediate |
| Write-Back Data | Data written to the destination register |
| Register Write | Enables register-file writes |
| Memory Read/Write | Controls data-memory access |
| Branch | Indicates branch control |
| Jump | Indicates jump control |
| Branch Taken | Indicates a taken conditional branch |
| Next PC | Address selected for the next instruction |

Waveform analysis helps verify instruction sequencing, register updates, ALU operations, memory accesses, and control-flow changes.

## Example RISC-V Assembly Program

The following example demonstrates arithmetic, logical, shift, comparison, memory, branch, upper-immediate, and jump instructions.

```asm
addi x1, x0, 10
addi x2, x0, 5

add  x3, x1, x2
sub  x4, x1, x2

and  x5, x1, x2
or   x6, x1, x2
xor  x7, x1, x2

sll  x8, x1, x2
srl  x9, x1, x2

slt  x10, x1, x2

addi x11, x1, 20

sw   x11, 0(x0)
lw   x12, 0(x0)

beq  x12, x11, branch_target

branch_target:
addi x13, x0, 13

lui   x14, 0x12345
auipc x15, 0x1

jal x16, jump_target

jump_target:
addi x17, x0, 17
```

This is an illustrative instruction sequence. To use it as a standalone program, place it in `programs/test.S`, assemble and link it appropriately, and ensure the generated instruction memory image matches the RTL memory initialization format.

## Current Project Status

| Component | Status |
|---|---|
| Program Counter | Complete |
| Instruction Memory | Complete |
| Register File | Complete |
| Immediate Generator | Complete |
| ALU | Complete |
| Control Unit | Complete |
| Data Memory | Complete |
| Branch Logic | Complete |
| Jump Logic | Complete |
| Integrated CPU | Complete |
| CPU Testbench | Complete |
| Assembly Integration | Implemented; further integration checks recommended |
| Icarus Verilog Simulation | Complete |
| GTKWave Verification | Complete |
| Documentation | Complete |
| Vivado Synthesis | Planned |
| FPGA Implementation | Planned |
| Physical Hardware Testing | Planned |

## Future Work: FPGA Implementation

The next stage is to implement the processor on a compatible FPGA development board.

1. Select a supported FPGA development board.
2. Create or adapt the FPGA top-level module.
3. Connect the board clock and reset signals.
4. Define the appropriate Xilinx Design Constraints (XDC).
5. Run RTL synthesis in Vivado.
6. Review timing reports, utilization, and synthesis warnings.
7. Run implementation and timing analysis.
8. Generate the FPGA bitstream.
9. Program the FPGA board.
10. Verify CPU operation on physical hardware.

The exact top module, clock configuration, pin assignments, and constraints depend on the selected board. FPGA implementation and physical hardware operation are not yet claimed as completed.

## Learning Outcomes

This project provides practical experience in:

- RISC-V instruction set architecture
- Single-cycle CPU design
- Datapath and control-unit implementation
- Verilog RTL development
- Combinational and sequential logic
- Register-file and ALU design
- Instruction decoding
- Memory interfacing
- Branch and jump control
- Assembly-to-machine-code conversion
- Simulation and waveform debugging
- Testbench-based verification
- FPGA synthesis and implementation workflow

## Future Improvements

Potential extensions include:

- Pipelined RISC-V processor
- Hazard detection and data forwarding
- Cache memory
- Control and Status Registers (CSRs)
- Interrupt handling
- Expanded automated instruction-level testing
- FPGA hardware demonstration
- Timing and resource-utilization analysis
- Performance comparison between single-cycle and pipelined designs

## Project Goal

The goal is to design and verify a functional **32-bit RV32I single-cycle RISC-V processor** from individual RTL components, execute RISC-V instructions, and inspect its operation through simulation and waveform analysis.

The next milestone is FPGA implementation and hardware verification.

## Author

**RV32I Single-Cycle RISC-V CPU**

Academic hardware-design project developed using Verilog HDL, RISC-V assembly, Icarus Verilog, GTKWave, and Ubuntu under WSL 2.

## License

This project is intended for educational and academic use. No specific open-source license is granted by this statement. Add an explicit license file if you intend to permit reuse or redistribution under defined terms.
