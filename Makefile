# $@ = target file
# $< = first dependency
# $^ = all dependencies

all: run

boot/bin/bootsect.bin: boot/bootsect.asm
	mkdir boot/bin && nasm $< -f bin -o $@

kernel/kernel.o: kernel/kernel.c
	gcc -m32 -fno-pie -ffreestanding -c $< -o $@ 

kernel/kernel_entry.o: kernel/kernel_entry.asm
	nasm $< -f elf -o $@

kernel/bin/kernel.bin: kernel/kernel_entry.o kernel/kernel.o
	mkdir kernel/bin && ld -m elf_i386 -s -o $@ -Ttext 0x1000 $^ --oformat binary

os-image.bin: boot/bin/bootsect.bin kernel/bin/kernel.bin
	cat $^ > $@

run: os-image.bin
	qemu-system-i386 -fda $<

clean:
	rm os-image.bin boot/bin/bootsect.bin kernel/kernel.o kernel/kernel_entry.o kernel/bin/kernel.bin && rmdir boot/bin kernel/bin
