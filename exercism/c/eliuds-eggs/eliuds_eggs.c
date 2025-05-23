#include "eliuds_eggs.h"

unsigned int egg_count(unsigned int n) {
  unsigned int result = 0;
  while (n > 0) {
    if (n % 2 == 1) {
      result += 1;
    }
    n /= 2;
  }
  return result;
}
