# $@ = target file
# $< = first dependency
# $^ = all dependencies

C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
# Nice syntax for file extension replacement
OBJ = ${C_SOURCES:.c=.o}

all: run

boot/bin/bootsect.bin: boot/bootsect.asm
	mkdir boot/bin && nasm $< -f bin -o $@

kernel/kernel.o: kernel/kernel.c
	gcc -m32 -fno-pie -ffreestanding -c $< -o $@ 

kernel/kernel_entry.o: kernel/kernel_entry.asm
	nasm $< -f elf -o $@

kernel/bin/kernel.bin: kernel/kernel_entry.o kernel/kernel.o ${OBJ}
	mkdir kernel/bin && ld -m elf_i386 -s -o $@ -Ttext 0x1000 $^ --oformat binary

os-image.bin: boot/bin/bootsect.bin kernel/bin/kernel.bin
	cat $^ > $@

run: os-image.bin
	qemu-system-i386 -fda $<

%.o: %.c ${HEADERS}
	gcc -m32 -fno-pie -ffreestanding -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -o $@

clean:
	rm drivers/*.o os-image.bin boot/bin/bootsect.bin kernel/kernel.o kernel/kernel_entry.o kernel/bin/kernel.bin && rmdir boot/bin kernel/bin
