#include "nth_prime.h"

bool is_prime(uint32_t n);

uint32_t nth(uint32_t n) {
  if (n < 1) {
    return 0;
  } else if (n < 3) {
    return n + 1;
  }

  n -= 2;
  uint32_t i = 6;

  while (true) {
    uint32_t fst = i - 1;
    if (is_prime(fst)) {
      n -= 1;
      if (n < 1) {
        return fst;
      }
    }

    uint32_t snd = i + 1;
    if (is_prime(snd)) {
      n -= 1;
      if (n < 1) {
        return snd;
      }
    }

    i += 6;
  }

  exit(1);
}

bool is_prime(uint32_t n) {
  if (n < 2) {
    return false;
  }

  uint32_t limit = sqrt(n);
  for (uint32_t i = 2; i <= limit; i += 1) {
    if (n % i == 0) {
      return false;
    }
  }
  return true;
}
