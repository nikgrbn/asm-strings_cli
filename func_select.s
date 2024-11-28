# 337762421 Nikita Grebenchuk

.extern printf
.extern scanf
.extern pstrlen
.extern swapCase
.extern pstrijcpy
.extern pstrcat

.section .rodata
.align 8
msg:
    .string	"res - %hhu %hhu \n"
msg_31:
    .string "first pstring length: %d, second pstring length: %d\n"
msg_str:
    .string "length: %d, string: %s\n"
msg_def:
    .string	"Invalid option!\n"
inp_34:
    .string "%hhu %hhu"

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
    subq $32, %rsp # 16 bytes for pstrings, 16 bytes for functions usage
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
    movq %rax, %rdi # Move swapCase() return value to rdi
    xorq %rax, %rax
    call print_pstring

    # Pass &pstr2 as argument to swapCase
    movq -16(%rbp), %rdi
    xorq %rax, %rax
    call swapCase

    # Print swapped string
    movq %rax, %rdi # Move swapCase() return value to rdi
    xorq %rax, %rax
    call print_pstring

    jmp .leave

# Case 34: call pstrijcpy
.c_34:
    # Get input interval
    movq $inp_34, %rdi
    leaq -24(%rbp), %rsi # Save i on stack
    leaq -32(%rbp), %rdx # Save j on stack
    xor %rax, %rax
    call scanf

    # Call pstrijcpy
    movq -8(%rbp), %rdi
    movq -16(%rbp), %rsi
    movq -24(%rbp), %rdx
    movq -32(%rbp), %rcx
    xorq %rax, %rax
    call pstrijcpy

    # Print pstrings
    movq -8(%rbp), %rdi
    xorq %rax, %rax
    call print_pstring
    movq -16(%rbp), %rdi
    xorq %rax, %rax
    call print_pstring

    jmp .leave

# Case 37: call pstrcat
.c_37:
    # Call pstrcat
    movq -8(%rbp), %rdi
    movq -16(%rbp), %rsi
    xorq %rax, %rax
    call pstrcat

    # Print the result
    movq -8(%rbp), %rdi
    xorq %rax, %rax
    call print_pstring
    movq -16(%rbp), %rdi
    xorq %rax, %rax
    call print_pstring

    jmp .leave

# Case 32: default
.c_def:
	movq $msg_def, %rdi
	xorq %rax, %rax
	call printf
    jmp .leave

.leave:
    # Leave
    mov %rbp, %rsp
    pop %rbp
    ret


.type print_pstring, @function
print_pstring: # Recieves a pstring pointer and prints its length and string
    push %rbp
    mov %rsp, %rbp

    # Pass pstring length and string to arguments
    movzb (%rdi), %rsi
    inc %rdi
    movq %rdi, %rdx

    # Print the string
    movq $msg_str, %rdi
    xorq %rax, %rax
    call printf

    # Leave
    mov %rbp, %rsp
    pop %rbp
    ret
