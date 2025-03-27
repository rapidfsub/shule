#include "perfect_numbers.h"

kind classify_number(int n) {
  if (n < 1) {
    return ERROR;
  } else if (n == 1) {
    return DEFICIENT_NUMBER;
  }

  int lim = (int)sqrt(n);
  int sum = -n;
  for (int i = 1; i <= lim; i += 1) {
    if (n % i == 0) {
      sum += i;
      int pair = n / i;
      if (pair != i) {
        sum += pair;
      }
    }
  }

  if (sum > n) {
    return ABUNDANT_NUMBER;
  } else if (sum == n) {
    return PERFECT_NUMBER;
  } else {
    return DEFICIENT_NUMBER;
  }
}
