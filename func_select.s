# 337762421 Nikita Grebenchuk

.extern printf
.extern pstrlen
.extern swapCase

.section .rodata
.align 8
msg:
    .string	"Option %d selected\n"
msg_31:
    .string "first pstring length: %d, second pstring length: %d\n"
msg_33:
    .string "length: %d, string: %s\n"
invalid_msg:
    .string	"Invalid option!\n"

jmp_table:
    .quad .c_31  # Case 31: call pstrlen
    .quad .c_def # Case 32: default
    .quad .c_33  # Case 33: call swapCase
    .quad .c_34  # Case 34: call pstrijcpy
    .quad .c_def # Case 35: default
    .quad .c_def # Case 36: default
    .quad .c_37  # Case 37: call pstrcat


.section .text
.globl run_func
.type run_func, @function
run_func:
    # Enter
    push %rbp
    mov %rsp, %rbp

    # Save pstrings pointers on the stack
    subq $16, %rsp
    movq %rsi, -8(%rbp)
    movq %rdx, -16(%rbp)

    # Load the option number
    leaq -31(%rdi), %rsi
    cmpq $6, %rsi   # 6 is for rsi offset
    ja .c_def
    jmp *jmp_table(,%rsi,8)

# Case 31: call pstrlen
.c_31:
    # Pass &pstr1 as argument to pstrlen
    movq -8(%rbp), %rdi
    xorq %rax, %rax
    call pstrlen
    pushq %rax # Save the return value

    # Pass &pstr2 as argument to pstrlen
    movq -16(%rbp), %rdi
    xorq %rax, %rax
    call pstrlen
    pushq %rax # Save the return value

    # Print the lengths
    movq $msg_31, %rdi
    popq %rdx # Pop &pstr2 length into rdx
    popq %rsi # Pop &pstr1 length into rsi
    xorq %rax, %rax
    call printf

    jmp .leave

# Case 33: call swapCase
.c_33:
    # Pass &pstr1 as argument to swapCase
    movq -8(%rbp), %rdi
    xorq %rax, %rax
    call swapCase

    # Print swapped string
    movq $msg_33, %rdi
    movq -8(%rbp), %rsi
    movzb (%rsi), %rsi # Pass first byte (string length) as argument
    movq %rax, %rdx # Move swapCase() return value to rdx
    xorq %rax, %rax
    call printf

    # Pass &pstr2 as argument to swapCase
    movq -16(%rbp), %rdi
    xorq %rax, %rax
    call swapCase

    # Print swapped string
    movq $msg_33, %rdi
    movq -16(%rbp), %rsi
    movzb (%rsi), %rsi # Pass first byte (string length) as argument
    movq %rax, %rdx # Move swapCase() return value to rdx
    xorq %rax, %rax
    call printf

    jmp .leave

# Case 34: call pstrijcpy
.c_34:
	movq $msg, %rdi
	movq $34, %rsi
	xorq %rax, %rax
	call printf
    jmp .leave

# Case 37: call pstrcat
.c_37:
	movq $msg, %rdi
	movq $37, %rsi
	xorq %rax, %rax
	call printf
    jmp .leave

# Case 32: default
.c_def:
	movq $invalid_msg, %rdi
	xorq %rax, %rax
	call printf
    jmp .leave

.leave:
    # Leave
    mov %rbp, %rsp
    pop %rbp
    ret