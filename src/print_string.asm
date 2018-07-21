print_string:
  pusha
  mov ah, 0x0e

is_done:
  mov al, [bx]
  cmp al, 0
  je done
  jmp print

print:
  int 0x10
  add bx, 1
  jmp is_done

done:
  popa
  ret
