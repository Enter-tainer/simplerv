#!/bin/bash

clang -T app.lds --target=riscv32-unknown-unknown "./$1.c" -march=rv32im -ffreestanding -fno-builtin -nostdlib  -mno-relax -fno-PIE -G=0
llvm-objcopy ./a.out --dump-section .text="$1_rom.bin" --dump-section .data="$1_ram.bin"
od -w4 -An --endian little -v -t x4 ./"$1_rom.bin" > "$1_rom.hex"
od -w4 -An --endian little -v -t x4 ./"$1_ram.bin" > "$1_ram.hex"
