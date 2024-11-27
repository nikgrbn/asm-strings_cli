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
.loop:
    cmpb $0, %cl
    je .end

    # Iterate each letter in the string
    movb (%rsi), %dl
    cmpb $0x61, %dl # Check if letter >= 'a'
    jl .not_lower
    cmpb $0x7A, %dl # Check if letter <= 'z'
    jg .not_lower

    # If came here, letter is lowercase. Switch to upper.
    subb $0x20, %dl
    jmp .next

.not_lower:
    cmpb $0x41, %dl # Check if letter >= 'A'
    jl .next
    cmpb $0x5A, %dl # Check if letter <= 'Z'
    jg .next

    # If came here, letter is uppercase. Switch to lower.
    addb $0x20, %dl
    jmp .next

# Insert letter by pointer and increment the pointer
.next:
    movb %dl, (%rsi)
    inc %rsi
    dec %rcx
    jmp .loop

.end:
    # Leave
    mov %rbp, %rsp
    pop %rbp
    ret