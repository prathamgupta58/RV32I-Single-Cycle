.section .text
.globl _start

_start:

    # Load immediate values
    addi x1, x0, 10
    addi x2, x0, 5

    # Arithmetic
    add  x3, x1, x2
    sub  x4, x1, x2

    # Logical
    and  x5, x1, x2
    or   x6, x1, x2
    xor  x7, x1, x2

    # Shift
    sll  x8, x1, x2
    srl  x9, x1, x2

    # Comparison
    slt  x10, x1, x2

    # Immediate arithmetic
    addi x11, x1, 20

    # Store and load
    sw   x11, 0(x0)
    lw   x12, 0(x0)

    # Branch
    beq  x12, x11, branch_target
    addi x13, x0, 99

branch_target:
    addi x13, x0, 13

    # Upper immediate
    lui  x14, 0x12345

    # AUIPC
    auipc x15, 0x1

    # Jump
    jal  x16, jump_target
    addi x17, x0, 99

jump_target:
    addi x17, x0, 17

    # End
end:
    jal x0, end
