
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
;     cnt++;
      cc: 03 25 44 ff  	lw	a0, -12(s0)
      d0: 13 05 15 00  	addi	a0, a0, 1
      d4: 23 2a a4 fe  	sw	a0, -12(s0)
;     *LED_ADDR = cnt;
      d8: 03 25 44 ff  	lw	a0, -12(s0)
      dc: b7 c5 ad fb  	lui	a1, 1030876
      e0: 23 af a5 0e  	sw	a0, 254(a1)
      e4: 13 05 00 00  	mv	a0, zero
;     for (int i = 0; i < 60; ++i) {
      e8: 23 24 a4 fe  	sw	a0, -24(s0)
      ec: 6f 00 40 00  	j	0xf0 <.Lline_table_start0+0xf0>
      f0: 83 25 84 fe  	lw	a1, -24(s0)
      f4: 13 05 b0 03  	addi	a0, zero, 59
      f8: 63 4e b5 0c  	blt	a0, a1, 0x1d4 <.Lline_table_start0+0x1d4>
      fc: 6f 00 40 00  	j	0x100 <.Lline_table_start0+0x100>
;       while (!*KBD_READY_ADDR)
     100: 6f 00 40 00  	j	0x104 <.Lline_table_start0+0x104>
     104: 37 c5 ad fb  	lui	a0, 1030876
;       while (!*KBD_READY_ADDR)
     108: 03 45 e5 ee  	lbu	a0, -274(a0)
     10c: 93 05 00 00  	mv	a1, zero
     110: 63 16 b5 00  	bne	a0, a1, 0x11c <.Lline_table_start0+0x11c>
     114: 6f 00 40 00  	j	0x118 <.Lline_table_start0+0x118>
     118: 6f f0 df fe  	j	0x104 <.Lline_table_start0+0x104>
;       while (*KBD_READY_ADDR)
     11c: 6f 00 40 00  	j	0x120 <.Lline_table_start0+0x120>
     120: 37 c5 ad fb  	lui	a0, 1030876
;       while (*KBD_READY_ADDR)
     124: 03 45 e5 ee  	lbu	a0, -274(a0)
     128: 93 05 00 00  	mv	a1, zero
     12c: 63 0c b5 00  	beq	a0, a1, 0x144 <.Lline_table_start0+0x144>
     130: 6f 00 40 00  	j	0x134 <.Lline_table_start0+0x134>
     134: 37 c5 ad fb  	lui	a0, 1030876
;         res = *KBD_DATA_ADDR;
     138: 03 05 f5 ee  	lb	a0, -273(a0)
     13c: a3 03 a4 fe  	sb	a0, -25(s0)
;       while (*KBD_READY_ADDR)
     140: 6f f0 1f fe  	j	0x120 <.Lline_table_start0+0x120>
     144: 13 05 00 00  	mv	a0, zero
;       for (int j = 0; j < 80; ++j) {
     148: 23 20 a4 fe  	sw	a0, -32(s0)
     14c: 6f 00 40 00  	j	0x150 <.Lline_table_start0+0x150>
     150: 83 25 04 fe  	lw	a1, -32(s0)
     154: 13 05 f0 04  	addi	a0, zero, 79
     158: 63 44 b5 06  	blt	a0, a1, 0x1c0 <.Lline_table_start0+0x1c0>
     15c: 6f 00 40 00  	j	0x160 <.Lline_table_start0+0x160>
;         VRAM_ADDR[i * 80 + j] = colors[res % 6];
     160: 03 45 74 fe  	lbu	a0, -25(s0)
     164: b7 b5 aa aa  	lui	a1, 699051
     168: 93 85 b5 aa  	addi	a1, a1, -1365
     16c: b3 35 b5 02  	mulhu	a1, a0, a1
     170: 93 d5 25 00  	srli	a1, a1, 2
     174: 13 06 60 00  	addi	a2, zero, 6
     178: b3 85 c5 02  	mul	a1, a1, a2
     17c: b3 05 b5 40  	sub	a1, a0, a1
     180: 13 05 e4 fe  	addi	a0, s0, -18
     184: 33 05 b5 00  	add	a0, a0, a1
     188: 03 05 05 00  	lb	a0, 0(a0)
     18c: 83 25 84 fe  	lw	a1, -24(s0)
     190: 13 06 00 05  	addi	a2, zero, 80
     194: b3 85 c5 02  	mul	a1, a1, a2
     198: 03 26 04 fe  	lw	a2, -32(s0)
     19c: b3 85 c5 00  	add	a1, a1, a2
     1a0: 37 06 ad fb  	lui	a2, 1030864
     1a4: b3 85 c5 00  	add	a1, a1, a2
     1a8: 23 80 a5 00  	sb	a0, 0(a1)
;       }
     1ac: 6f 00 40 00  	j	0x1b0 <.Lline_table_start0+0x1b0>
;       for (int j = 0; j < 80; ++j) {
     1b0: 03 25 04 fe  	lw	a0, -32(s0)
     1b4: 13 05 15 00  	addi	a0, a0, 1
     1b8: 23 20 a4 fe  	sw	a0, -32(s0)
     1bc: 6f f0 5f f9  	j	0x150 <.Lline_table_start0+0x150>
;     }
     1c0: 6f 00 40 00  	j	0x1c4 <.Lline_table_start0+0x1c4>
;     for (int i = 0; i < 60; ++i) {
     1c4: 03 25 84 fe  	lw	a0, -24(s0)
     1c8: 13 05 15 00  	addi	a0, a0, 1
     1cc: 23 24 a4 fe  	sw	a0, -24(s0)
     1d0: 6f f0 1f f2  	j	0xf0 <.Lline_table_start0+0xf0>
     1d4: 37 a5 07 00  	lui	a0, 122
     1d8: 13 05 05 12  	addi	a0, a0, 288
;     sleep(1000 * 500);
     1dc: 97 00 00 00  	auipc	ra, 0
     1e0: e7 80 40 e3  	jalr	-460(ra)
;   while (1) {
     1e4: 6f f0 9f ee  	j	0xcc <.Lline_table_start0+0xcc>
