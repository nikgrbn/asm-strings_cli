.section .text
.globl pstrlen
.type pstrlen, @function
pstrlen:
    # Enter
    push %rbp
    mov %rsp, %rbp

    # Access the len field of the Pstring structure
    movzb (%rdi), %rax     # Load the byte from [rdi] into al

    # Leave
    mov %rbp, %rsp
    pop %rbp
    ret