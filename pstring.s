# 337762421 Nikita Grebenchuk

.extern printf

.section .rodata
.align 8
invalid_input:
    .string	"invalid input!\n"
invalid_cat_msg:
    .string "cannot concatenate strings!\n"
msg:
    .string "DEBUG: i=%hhu j=%hhu\n"


.section .text
.globl pstrlen
.type pstrlen, @function
pstrlen:
    # Enter
    push %rbp
    mov %rsp, %rbp

    # Access the len field of the Pstring structure
    movzb (%rdi), %rax # Load the byte from [rdi] into rax

    # Leave
    mov %rbp, %rsp
    pop %rbp
    ret


.globl swapCase
.type swapCase, @function
swapCase:
    # Enter
    push %rbp
    mov %rsp, %rbp
    movq %rdi, %rax # keep struct pointer in rax

    movzb (%rdi), %rcx # Set iterator to string length
    leaq 1(%rdi), %rsi # Load address of string into rsi (we skip the byte length)
.loop_swap:
    cmpb $0, %cl
    je .end_swap

    # Iterate each letter in the string
    movb (%rsi), %dl
    cmpb $0x61, %dl # Check if letter >= 'a'
    jl .not_lower
    cmpb $0x7A, %dl # Check if letter <= 'z'
    ja .not_lower

    # If came here, letter is lowercase. Switch to upper.
    subb $0x20, %dl
    jmp .next

.not_lower:
    cmpb $0x41, %dl # Check if letter >= 'A'
    jl .next
    cmpb $0x5A, %dl # Check if letter <= 'Z'
    ja .next

    # If came here, letter is uppercase. Switch to lower.
    addb $0x20, %dl
    jmp .next

# Insert letter by pointer and increment the pointer
.next:
    movb %dl, (%rsi)
    inc %rsi
    dec %rcx
    jmp .loop_swap

.end_swap:
    # Leave
    mov %rbp, %rsp
    pop %rbp
    ret


.globl pstrijcpy
.type pstrijcpy, @function
pstrijcpy:
    # Enter
    push %rbp
    mov %rsp, %rbp

    # Save pointer to &str1 so it can be returned later
    movq %rdi, %r8

    # Check if i is valid
    cmpb $0, %dl
    jl .invalid_cpy # i < 0
    cmpb %cl, %dl
    ja .invalid_cpy # i > j

    # Check if j is valid
    cmpb (%rdi), %cl
    jae .invalid_cpy # j > str1 length
    cmpb (%rsi), %cl
    jae .invalid_cpy # j > str2 length

    incq %rdi # Skip length byte
    incq %rsi # Skip length byte
    xorb %al, %al
.inc_str_cpy: # Increment string pointers until i
    cmpb %dl, %al
    jae .loop_cpy

    incb %al
    incq %rdi
    incq %rsi
    jmp .inc_str_cpy

.loop_cpy:
    # Insert src[i] into dest[i]
    xor %rax, %rax
    movb (%rsi), %al
    movb %al, (%rdi)

    # Check if we reached j
    cmpb %cl, %dl
    jae .end_cpy

    # Iterate to next letter
    incb %dl
    inc %rdi
    inc %rsi
    jmp .loop_cpy

.invalid_cpy:
    # Print invalid message
    movq $invalid_input, %rdi
    xorq %rax, %rax
    call printf

.end_cpy:
    # Leave
    movq %r8, %rax # Return pointer to &str1
    mov %rbp, %rsp
    pop %rbp
    ret


.globl pstrcat
.type pstrcat, @function
pstrcat:
    # Enter
    push %rbp
    mov %rsp, %rbp

    # Save pointer to &str1 so it can be returned later
    movq %rdi, %r8

    # Get the lengths
    movzb (%rdi), %rdx
    movzb (%rsi), %rcx

    # Comapre length sum to 255
    add %rdx, %rcx
    cmp $255, %rcx
    jae .invalid_cat

    # Update new length of &str1
    movb %cl, (%rdi)
    inc %rdi # Skip length byte
    inc %rsi # Skip length byte

    # Increment str1 pointer until the end of the string
    xorb %al, %al
.inc_str_cat:
    cmpb %dl, %al
    jae .loop_cat

    incb %al
    incq %rdi
    jmp .inc_str_cat

.loop_cat:
    # Insert src[j] into dest[i]
    xor %rax, %rax
    movb (%rsi), %al
    movb %al, (%rdi)

    # Check if we reached j
    cmpb %cl, %dl
    jae .end_cat

    # Iterate to next letter
    incb %dl
    inc %rdi
    inc %rsi
    jmp .loop_cat

.invalid_cat:
    # Print invalid message
    movq $invalid_cat_msg, %rdi
    xorq %rax, %rax
    call printf

.end_cat:
    # Leave
    movq %r8, %rax # Return pointer to &str1
    mov %rbp, %rsp
    pop %rbp
    ret

