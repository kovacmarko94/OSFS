[org 0x7c00]

mov bx, HELLO
call print_string

jmp $

mov ah, 0x0e

print_string:
  mov al, [bx]
  cmp al, 0
  jne print
  ret

print:
  int 0x10
  add bx, 1
  jmp print_string

; data
HELLO:
    db 'Hello, World', 0

; padding and magic number
times 510-($-$$) db 0

dw 0xaa55
