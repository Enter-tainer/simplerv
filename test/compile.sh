#!/bin/bash

clang -T app.lds --target=riscv32-unknown-unknown "./$1.c" -march=rv32im -ffreestanding -fno-builtin -nostdlib  -mno-relax -fno-PIE -G=0 -g
llvm-objcopy ./a.out --dump-section .text="$1.rom.bin" --dump-section .data="$1.ram.bin"
llvm-objdump -S a.out > "$1.asm"
od -w4 -An --endian little -v -t x4 ./"$1.rom.bin" > "$1.rom.hex"
od -w4 -An --endian little -v -t x4 ./"$1.ram.bin" > "$1.ram.hex"
