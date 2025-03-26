#include "grains.h"

uint64_t square(uint8_t i) {
  if (i < 1) {
    return 0;
  }

  uint64_t result = 1;
  while (i > 1) {
    result *= 2;
    i -= 1;
  }
  return result;
}

uint64_t total(void) { return square(65) - 1; }
