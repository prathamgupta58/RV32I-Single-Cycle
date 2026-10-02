# RV32I Single-Cycle RISC-V CPU

A simple 32-bit RISC-V RV32I single-cycle processor designed in Verilog HDL and verified using Icarus Verilog and GTKWave.

## Project Overview

This project implements a basic single-cycle RISC-V processor based on the RV32I instruction set.

The CPU was designed at RTL level and tested using simulation before FPGA implementation.

## Main Features

- 32-bit RISC-V architecture
- RV32I instruction set
- Single-cycle CPU architecture
- Program Counter
- Instruction Memory
- Register File
- Immediate Generator
- ALU
- Control Unit
- Data Memory
- Branch and Jump Logic
- Load/Store support
- LUI and AUIPC support
- RISC-V assembly program support
- Icarus Verilog simulation
- GTKWave waveform verification
- FPGA/Vivado ready RTL

---

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
## CPU Architecture

The processor follows a basic single-cycle datapath.

```text
                 ┌──────────────────┐
                 │ Program Counter  │
                 └────────┬─────────┘
                          │
                          ▼
                 ┌──────────────────┐
                 │ Instruction Mem. │
                 └────────┬─────────┘
                          │
                          ▼
                 ┌──────────────────┐
                 │  Control Unit    │
                 └────────┬─────────┘
                          │
             ┌────────────┴────────────┐
             ▼                         ▼
      ┌──────────────┐         ┌──────────────┐
      │ Register File│         │ Immediate Gen│
      └──────┬───────┘         └──────┬───────┘
             └────────────┬────────────┘
                          ▼
                   ┌─────────────┐
                   │     ALU     │
                   └──────┬──────┘
                          │
                   ┌──────▼──────┐
                   │ Data Memory │
                   └──────┬──────┘
                          │
                          ▼
                   ┌─────────────┐
                   │ Write Back  │
                   └─────────────┘
Supported RV32I Instructions
R-Type
ADD
SUB
AND
OR
XOR
SLL
SRL
SRA
SLT
SLTU
I-Type
ADDI
ANDI
ORI
XORI
SLTI
SLTIU
SLLI
SRLI
SRAI
Load / Store
LW
SW
Branch
BEQ
BNE
BLT
BGE
BLTU
BGEU
Jump
JAL
JALR
Upper Immediate
LUI
AUIPC
## Assembly Program Flow

The RISC-V assembly program is converted into machine code and loaded into instruction memory.

```text
test.S
  │
  ▼
RISC-V GCC
  │
  ▼
test.o
  │
  ▼
test.bin
  │
  ▼
test.hex
  │
  ▼
Instruction Memory
  │
  ▼
RV32I CPU
| Tool                 | Purpose                       |
| -------------------- | ----------------------------- |
| Verilog HDL          | RTL hardware description      |
| Icarus Verilog       | RTL simulation                |
| GTKWave              | Waveform analysis             |
| RISC-V GNU Toolchain | Assembly compilation          |
| GCC                  | Machine-code generation       |
| Objdump              | Disassembly                   |
| Objcopy              | Binary generation             |
| VS Code              | Source-code development       |
| WSL Ubuntu           | Linux development environment |
| Git                  | Version control               |

## Build Instructions

Enter the project directory:

```bash
cd ~/RV32I-Single-Cycle
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -c programs/test.S -o programs/test.o
riscv64-unknown-elf-objcopy -O binary programs/test.o programs/test.bin
xxd -p -c 4 programs/test.bin | awk '{print substr($0,7,2) substr($0,5,2) substr($0,3,2) substr($0,1,2)}' > programs/test.hex

iverilog -o sim/full_cpu_tb.out rtl/*.v tb/full_cpu_tb.v
vvp sim/full_cpu_tb.out
## Verification

The complete processor was verified using a RISC-V assembly test program.

The test program verifies:

- Arithmetic operations
- Logical operations
- Shift operations
- Comparison operations
- Immediate operations
- Store and load operations
- Branch operation
- LUI
- AUIPC
- JAL
- Jump target execution

### Final Result

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
## GTKWave Verification

GTKWave was used to inspect the internal CPU signals during simulation.

Final waveform files:

```text
sim/final_cpu.vcd
sim/final_cpu.gtkw
Important signals include:

Clock
Reset
Program Counter
Instruction
ALU result
Register operands
Immediate value
Write-back data
Register write
Memory read/write
Branch
Jump
Branch taken
Next PC

Open the waveform with:
gtkwave sim/final_cpu.vcd
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

---
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
| Complete CPU | Complete |
| CPU Testbench | Complete |
| Assembly Integration | Complete |
| Icarus Verilog Simulation | Complete |
| GTKWave Verification | Complete |
| Documentation | Complete |
| Vivado Synthesis | Planned |
| FPGA Implementation | Planned |
| Hardware Testing | Planned |

---

## Future Work

The next stage is FPGA implementation.

Planned steps:

1. Synthesize the RTL using Xilinx Vivado.
2. Create an FPGA-specific top module.
3. Add clock and reset connections.
4. Create the required XDC constraints.
5. Run synthesis and implementation.
6. Generate the FPGA bitstream.
7. Program the FPGA board.
8. Perform hardware verification.

The exact top module and constraints will depend on the FPGA development board.

---

## Learning Objectives

This project provides practical experience with:

- RISC-V instruction set architecture
- CPU datapath design
- Single-cycle processor architecture
- Verilog RTL design
- Sequential and combinational logic
- Register-file design
- ALU design
- Instruction decoding
- Memory interfacing
- Branch and jump control
- Assembly-to-machine-code conversion
- RTL simulation
- Waveform debugging
- FPGA implementation workflow

---

## Project Goal

The main goal is to design and verify a functional **32-bit RV32I single-cycle RISC-V processor** from individual RTL components and demonstrate its operation using real RISC-V assembly instructions.

Future improvements may include:

- Pipelined RISC-V CPU
- Hazard detection
- Data forwarding
- Cache memory
- CSR support
- Interrupt handling
- FPGA hardware demonstration
- Hardware performance analysis

---

## Author

**RV32I Single-Cycle RISC-V CPU**

Academic hardware-design project developed using Verilog HDL, RISC-V assembly, Icarus Verilog, GTKWave, and WSL Ubuntu.

---

## License

This project is intended for educational and academic use.

