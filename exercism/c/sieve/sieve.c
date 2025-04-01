#include "sieve.h"

uint32_t sieve(uint32_t limit, uint32_t *primes, size_t max_primes) {
  if (limit < 2) {
    return 0;
  }

  bool sieve[limit + 1];
  memset(sieve, 0, sizeof(sieve));
  for (size_t i = 2; i <= limit; i += 1) {
    if (!sieve[i]) {
      for (size_t j = i * 2; j <= limit; j += i) {
        sieve[j] = true;
      }
    }
  }

  uint32_t result = 0;
  for (size_t i = 2; i <= limit; i += 1) {
    if (sieve[i]) {
      continue;
    } else if (result < max_primes) {
      primes[result] = i;
      result += 1;
    } else {
      break;
    }
  }
  return result;
}
