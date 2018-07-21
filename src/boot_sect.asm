[org 0x7c00]

jmp $

%include "src/print/print_string.asm"
%include "src/print/print_hex.asm"
%include "src/disk_load.asm"

times 510-($-$$) db 0

dw 0xaa55