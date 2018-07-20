[org 0x7c00]

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

jmp $

times 510 - ($ - $$) db 0

dw 0xaa55

times 256 dw 0xdada
