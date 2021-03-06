[bits 16]
switch_to_pm:
  ; We must switch of interrupts until we have
  ; set -up the protected mode interrupt vector
  ; otherwise interrupts will run riot.
  cli

  ; Load our global descriptor table, which defines
  ; the protected mode segments (e.g. for code and data)
  lgdt [gdt_descriptor]

  ; To make the switch to protected mode, we set
  ; the first bit of CR0, a control register
  mov eax, cr0 
  or eax, 0x1 
  mov cr0, eax
  jmp CODE_SEG:init_pm

[bits 32]
init_pm:
  mov ax, DATA_SEG
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ebp, 0x90000
  mov esp, ebp
  call BEGIN_PM
