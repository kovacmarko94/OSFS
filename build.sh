#!/bin/bash
nasm src/boot_sect.asm -f bin -o bin/boot_sect.bin && cat bin/boot_sect.bin src/kernel/kernel.bin > os-image.bin
