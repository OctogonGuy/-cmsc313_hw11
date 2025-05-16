section .data
inputBuf db 0x83, 0x6A, 0x88, 0xDE, 0x9A, 0xC3, 0x54, 0x9A

section .bss
outputBuf resb 80

section .text
global _start

_start:
    ; Set source (SI) to inputBuf and destination (DI) to outputBuf
    mov esi, inputBuf
    mov edi, outputBuf

    ; Set counter for 8 bytes
    mov ecx, 8

translate_loop:
    ; Load byte from inputBuf
    mov al, [esi]

    ; Convert to ASCII hex (high nibble)
    mov ah, al
    shr al, 4        ; shift right to get high nibble
    and al, 0x0F     ; mask to get single hex digit
    add al, '0'      ; convert to ASCII
    cmp al, '9'      ; if greater than '9', adjust to A-F
    jg convert_high

write_high:
    mov [edi], al
    inc edi
    jmp convert_low

convert_high:
    add al, 7
    mov [edi], al
    inc edi

convert_low:
    ; Convert low nibble
    mov al, ah
    and al, 0x0F     ; mask to get single hex digit
    add al, '0'      ; convert to ASCII
    cmp al, '9'      ; if greater than '9', adjust to A-F
    jg convert_low_high

write_low:
    mov [edi], al
    inc edi
    jmp next_byte

convert_low_high:
    add al, 7
    mov [edi], al
    inc edi

next_byte:
    ; Add a space after each byte except the last
    dec ecx
    jz finish
    mov byte [edi], ' '
    inc edi

    ; Move to next byte in inputBuf
    inc esi
    jmp translate_loop

finish:
    ; Add newline
    mov byte [edi], 0x0A
    inc edi

    ; Write to stdout
    mov eax, 4          ; sys_write
    mov ebx, 1          ; file descriptor (stdout)
    mov ecx, outputBuf  ; buffer
    sub edi, outputBuf  ; calculate length
    mov edx, edi
    int 0x80

    ; Exit program
    mov eax, 1          ; sys_exit
    xor ebx, ebx
    int 0x80
