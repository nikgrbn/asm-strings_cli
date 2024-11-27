# 337762421 Nikita Grebenchuk

.extern printf


.section .rodata
.align 8
msg:	.string	"Option %d selected\n"
invalid_msg:	.string	"Invalid option!\n"

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

    leaq -31(%rdi), %rsi
    cmpq $6, %rsi   # 6 is for rsi offset
    ja .c_def
    jmp *jmp_table(,%rsi,8)

# Case 31: call pstrlen
.c_31:
	movq $msg, %rdi
	movq $31, %rsi
	xorq %rax, %rax
	call printf
    jmp .leave

# Case 33: call swapCase
.c_33:
	movq $msg, %rdi
	movq $33, %rsi
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