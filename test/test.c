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

void sleep(uint32_t us) {
  uint32_t start = *CLOCK_ADDR;
  while (1) {
    if (*CLOCK_ADDR >= start + us) {
      break;
    }
  }
}

int main() {
  for (int i = 0; i < 1000; ++i) {
    *LED_ADDR = i;
    sleep(1000 * 500);
  }
}

