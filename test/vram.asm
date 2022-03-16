
a.out:	file format elf32-littleriscv

Disassembly of section .text:

00000000 <_start>:
;   asm("mv sp, %0\n\t" ::"r"(&__stacktop));
       0: 37 15 00 20  	lui	a0, 131073
       4: 13 05 85 00  	addi	a0, a0, 8
       8: 13 01 05 00  	mv	sp, a0
;   asm("j %0\n\t" ::"i"(&main));
       c: 6f 00 c0 05  	j	0x68 <.Lline_table_start0+0x68>

00000010 <sleep>:
; void sleep(uint32_t us) {
      10: 13 01 01 ff  	addi	sp, sp, -16
      14: 23 26 11 00  	sw	ra, 12(sp)
      18: 23 24 81 00  	sw	s0, 8(sp)
      1c: 13 04 01 01  	addi	s0, sp, 16
      20: 23 2a a4 fe  	sw	a0, -12(s0)
      24: 37 c5 ad fb  	lui	a0, 1030876
;   uint32_t start = *CLOCK_ADDR;
      28: 03 25 f5 ed  	lw	a0, -289(a0)
      2c: 23 28 a4 fe  	sw	a0, -16(s0)
;   while (1) {
      30: 6f 00 40 00  	j	0x34 <.Lline_table_start0+0x34>
      34: 37 c5 ad fb  	lui	a0, 1030876
;     if (*CLOCK_ADDR >= start + us) {
      38: 03 25 f5 ed  	lw	a0, -289(a0)
      3c: 83 25 04 ff  	lw	a1, -16(s0)
      40: 03 26 44 ff  	lw	a2, -12(s0)
      44: b3 85 c5 00  	add	a1, a1, a2
      48: 63 66 b5 00  	bltu	a0, a1, 0x54 <.Lline_table_start0+0x54>
      4c: 6f 00 40 00  	j	0x50 <.Lline_table_start0+0x50>
;       break;
      50: 6f 00 80 00  	j	0x58 <.Lline_table_start0+0x58>
;   while (1) {
      54: 6f f0 1f fe  	j	0x34 <.Lline_table_start0+0x34>
; }
      58: 03 24 81 00  	lw	s0, 8(sp)
      5c: 83 20 c1 00  	lw	ra, 12(sp)
      60: 13 01 01 01  	addi	sp, sp, 16
      64: 67 80 00 00  	ret

00000068 <main>:
; int main() {
      68: 13 01 01 fe  	addi	sp, sp, -32
      6c: 23 2e 11 00  	sw	ra, 28(sp)
      70: 23 2c 81 00  	sw	s0, 24(sp)
      74: 13 04 01 02  	addi	s0, sp, 32
      78: 13 05 00 00  	mv	a0, zero
;   int cnt = 0;
      7c: 23 2a a4 fe  	sw	a0, -12(s0)
;   uint8_t colors[] = {r, g, b, y, p, w};
      80: 37 05 00 20  	lui	a0, 131072
      84: 03 05 05 00  	lb	a0, 0(a0)
      88: 23 07 a4 fe  	sb	a0, -18(s0)
      8c: 37 05 00 20  	lui	a0, 131072
      90: 03 05 15 00  	lb	a0, 1(a0)
      94: a3 07 a4 fe  	sb	a0, -17(s0)
      98: 37 05 00 20  	lui	a0, 131072
      9c: 03 05 25 00  	lb	a0, 2(a0)
      a0: 23 08 a4 fe  	sb	a0, -16(s0)
      a4: 37 05 00 20  	lui	a0, 131072
      a8: 03 05 35 00  	lb	a0, 3(a0)
      ac: a3 08 a4 fe  	sb	a0, -15(s0)
      b0: 37 05 00 20  	lui	a0, 131072
      b4: 03 05 45 00  	lb	a0, 4(a0)
      b8: 23 09 a4 fe  	sb	a0, -14(s0)
      bc: 37 05 00 20  	lui	a0, 131072
      c0: 03 05 55 00  	lb	a0, 5(a0)
      c4: a3 09 a4 fe  	sb	a0, -13(s0)
;   while (1) {
      c8: 6f 00 40 00  	j	0xcc <.Lline_table_start0+0xcc>
;     cnt ++;
      cc: 03 25 44 ff  	lw	a0, -12(s0)
      d0: 13 05 15 00  	addi	a0, a0, 1
      d4: 23 2a a4 fe  	sw	a0, -12(s0)
;     *LED_ADDR = cnt * 4;
      d8: 03 25 44 ff  	lw	a0, -12(s0)
      dc: 13 15 25 00  	slli	a0, a0, 2
      e0: b7 c5 ad fb  	lui	a1, 1030876
      e4: 23 af a5 0e  	sw	a0, 254(a1)
      e8: 13 05 00 00  	mv	a0, zero
;     for (int i = 0; i < 60; ++i) {
      ec: 23 24 a4 fe  	sw	a0, -24(s0)
      f0: 6f 00 40 00  	j	0xf4 <.Lline_table_start0+0xf4>
      f4: 83 25 84 fe  	lw	a1, -24(s0)
      f8: 13 05 b0 03  	addi	a0, zero, 59
      fc: 63 4a b5 0c  	blt	a0, a1, 0x1d0 <.Lline_table_start0+0x1d0>
     100: 6f 00 40 00  	j	0x104 <.Lline_table_start0+0x104>
     104: 13 05 00 00  	mv	a0, zero
;       for (int j = 0; j < 80; ++j) {
     108: 23 22 a4 fe  	sw	a0, -28(s0)
     10c: 6f 00 40 00  	j	0x110 <.Lline_table_start0+0x110>
     110: 83 25 44 fe  	lw	a1, -28(s0)
     114: 13 05 f0 04  	addi	a0, zero, 79
     118: 63 42 b5 0a  	blt	a0, a1, 0x1bc <.Lline_table_start0+0x1bc>
     11c: 6f 00 40 00  	j	0x120 <.Lline_table_start0+0x120>
;         if ((cnt + j + i) % 2 == 0)
     120: 03 25 44 ff  	lw	a0, -12(s0)
     124: 83 25 44 fe  	lw	a1, -28(s0)
     128: 33 05 b5 00  	add	a0, a0, a1
     12c: 83 25 84 fe  	lw	a1, -24(s0)
     130: 33 05 b5 00  	add	a0, a0, a1
     134: 93 55 f5 01  	srli	a1, a0, 31
     138: b3 05 b5 00  	add	a1, a0, a1
     13c: 93 f5 e5 ff  	andi	a1, a1, -2
     140: 33 05 b5 40  	sub	a0, a0, a1
     144: 93 05 00 00  	mv	a1, zero
     148: 63 1a b5 02  	bne	a0, a1, 0x17c <.Lline_table_start0+0x17c>
     14c: 6f 00 40 00  	j	0x150 <.Lline_table_start0+0x150>
;           VRAM_ADDR[i * 80 + j] = r;
     150: 37 05 00 20  	lui	a0, 131072
     154: 03 05 05 00  	lb	a0, 0(a0)
     158: 83 25 84 fe  	lw	a1, -24(s0)
     15c: 13 06 00 05  	addi	a2, zero, 80
     160: b3 85 c5 02  	mul	a1, a1, a2
     164: 03 26 44 fe  	lw	a2, -28(s0)
     168: b3 85 c5 00  	add	a1, a1, a2
     16c: 37 06 ad fb  	lui	a2, 1030864
     170: b3 85 c5 00  	add	a1, a1, a2
     174: 23 80 a5 00  	sb	a0, 0(a1)
     178: 6f 00 00 03  	j	0x1a8 <.Lline_table_start0+0x1a8>
;           VRAM_ADDR[i * 80 + j] = g;
     17c: 37 05 00 20  	lui	a0, 131072
     180: 03 05 15 00  	lb	a0, 1(a0)
     184: 83 25 84 fe  	lw	a1, -24(s0)
     188: 13 06 00 05  	addi	a2, zero, 80
     18c: b3 85 c5 02  	mul	a1, a1, a2
     190: 03 26 44 fe  	lw	a2, -28(s0)
     194: b3 85 c5 00  	add	a1, a1, a2
     198: 37 06 ad fb  	lui	a2, 1030864
     19c: b3 85 c5 00  	add	a1, a1, a2
     1a0: 23 80 a5 00  	sb	a0, 0(a1)
     1a4: 6f 00 40 00  	j	0x1a8 <.Lline_table_start0+0x1a8>
;       }
     1a8: 6f 00 40 00  	j	0x1ac <.Lline_table_start0+0x1ac>
;       for (int j = 0; j < 80; ++j) {
     1ac: 03 25 44 fe  	lw	a0, -28(s0)
     1b0: 13 05 15 00  	addi	a0, a0, 1
     1b4: 23 22 a4 fe  	sw	a0, -28(s0)
     1b8: 6f f0 9f f5  	j	0x110 <.Lline_table_start0+0x110>
;     }
     1bc: 6f 00 40 00  	j	0x1c0 <.Lline_table_start0+0x1c0>
;     for (int i = 0; i < 60; ++i) {
     1c0: 03 25 84 fe  	lw	a0, -24(s0)
     1c4: 13 05 15 00  	addi	a0, a0, 1
     1c8: 23 24 a4 fe  	sw	a0, -24(s0)
     1cc: 6f f0 9f f2  	j	0xf4 <.Lline_table_start0+0xf4>
     1d0: 37 45 0f 00  	lui	a0, 244
     1d4: 13 05 05 24  	addi	a0, a0, 576
;     sleep(1000 * 1000);
     1d8: 97 00 00 00  	auipc	ra, 0
     1dc: e7 80 80 e3  	jalr	-456(ra)
;   while (1) {
     1e0: 6f f0 df ee  	j	0xcc <.Lline_table_start0+0xcc>
