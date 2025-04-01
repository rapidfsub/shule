#include "square_root.h"

const size_t MAX_ITERATIONS = 10000;

int square_root(int n) {
  int result = n;
  for (size_t i = 0; i < MAX_ITERATIONS; i += 1) {
    result = (result + n / result) / 2;
    if (result * result == n) {
      return result;
    }
  }
  exit(1);
}
