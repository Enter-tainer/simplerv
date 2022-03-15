// #include <inttypes.h>
#include <stdint.h>
#define CLOCK_ADDR ((uint32_t *)0xfbadbedf)
#define LED_ADDR ((uint32_t *)0xfbadc0fe)
// top of stack
extern unsigned __stacktop;
// initial stack pointer is first address of program
__attribute__((section(".stack"), used)) unsigned *__stack_init = &__stacktop;
int main();

__attribute__((naked)) void _start() {
  asm("mv sp, %0\n\t" ::"r"(&__stacktop));
  asm("j %0\n\t" ::"i"(&main));
}

int data_seg[16] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};

void sleep(uint32_t us) {
  uint32_t start = *CLOCK_ADDR;
  while (1) {
    if (*CLOCK_ADDR >= start + us) {
      break;
    }
  }
}

int f(int cnt) {
  static int f[4] = {0};
  if (f[0] == 0) {
    f[0] = 0x11;
    f[1] = 0x22;
    f[2] = 0x33;
    f[3] = 0x44;
  }
  return f[cnt];
}

int main() {
  for (int i = 0; i < 4; ++i) {
    *LED_ADDR = data_seg[i];
    *LED_ADDR = f(i);
    // sleep(1000 * 500);
  }
}
