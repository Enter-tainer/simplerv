// #include <inttypes.h>
#include <stdint.h>
#define CLOCK_ADDR ((uint32_t *)0xfbadbedf)
#define LED_ADDR ((uint32_t *)0xfbadc0fe)
#define VRAM_ADDR ((uint8_t *)0xfbad0000)
#define KBD_READY_ADDR ((uint8_t *)0xfbadbeee)
#define KBD_DATA_ADDR ((uint8_t *)0xfbadbeef)
// top of stack
extern unsigned __stacktop;
// initial stack pointer is first address of program
__attribute__((section(".stack"), used)) unsigned *__stack_init = &__stacktop;
int main();

__attribute__((naked)) void _start() {
  asm("mv sp, %0\n\t" ::"r"(&__stacktop));
  asm("j %0\n\t" ::"i"(&main));
}

void sleep(uint32_t us) {
  uint32_t start = *CLOCK_ADDR;
  while (1) {
    if (*CLOCK_ADDR >= start + us) {
      break;
    }
  }
}
uint8_t r = 0b11000000;
uint8_t g = 0b00110000;
uint8_t b = 0b00001100;
uint8_t y = 0b11110000;
uint8_t p = 0b11001100;
uint8_t w = 0b11111100;
int main() {
  int cnt = 0;
  uint8_t colors[] = {r, g, b, y, p, w};
  for (int i = 0; i < 60; ++i) {
    *LED_ADDR = i;
    for (int j = 0; j < 80; ++j) {
      if (j % 2 == 0)
        VRAM_ADDR[i * 80 + j] = 0b11000000;
      else
        VRAM_ADDR[i * 80 + j] = 0b00110000;
    }
  }
  while (1) {
    cnt ++;
    *LED_ADDR = cnt;
    sleep(1000 * 500);
  }
}
