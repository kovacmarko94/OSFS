# $@ = target file
# $< = first dependency
# $^ = all dependencies

all: run

boot/bin/bootsect.bin: boot/bootsect.asm
	nasm $< -f bin -o $@

kernel/kernel.o: kernel/kernel.c
	gcc -ffreestanding -c $< -o $@

kernel/kernel_entry.o: kernel/kernel_entry.asm
	nasm $< -f elf -o $@

kernel/bin/kernel.bin: kernel/kernel_entry.o kernel/kernel.o
	ld -o $@ -Ttext 0x1000 $^ --oformat binary

os-image.bin: boot/bin/bootsect.bin kernel/bin/kernel.bin
	cat $^ > $@

run: os-image.bin
	qemu-system-i386 -fda $<

clean:
	rm os-image.bin boot/bin/bootsect.bin kernel/kernel.o kernel/kernel_entry.o kernel/bin/kernel.bin 