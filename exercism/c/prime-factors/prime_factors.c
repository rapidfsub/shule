#include "prime_factors.h"

bool is_prime(uint64_t n);

size_t find_factors(uint64_t n, uint64_t factors[static MAXFACTORS]) {
  size_t result = 0;
  while (n % 2 == 0) {
    factors[result] = 2;
    result += 1;
    n /= 2;
  }

  while (n % 3 == 0) {
    factors[result] = 3;
    result += 1;
    n /= 3;
  }

  uint64_t i = 6;
  while (n > 1) {
    uint64_t fst = i - 1;
    if (is_prime(fst)) {
      while (n % fst == 0) {
        factors[result] = fst;
        result += 1;
        n /= fst;
      }
    }

    uint64_t snd = i + 1;
    if (is_prime(snd)) {
      while (n % snd == 0) {
        factors[result] = snd;
        result += 1;
        n /= snd;
      }
    }
    i += 6;
  }

  return result;
}

bool is_prime(uint64_t n) {
  if (n < 2) {
    return false;
  }

  uint64_t limit = sqrt(n);
  for (uint64_t i = 2; i <= limit; i += 1) {
    if (n % i == 0) {
      return false;
    }
  }
  return true;
}
