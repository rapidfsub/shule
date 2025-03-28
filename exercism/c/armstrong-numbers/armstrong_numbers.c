#include "armstrong_numbers.h"
#include <math.h>

int get_exp(int candidate);
int int_pow(int num, int exp);
int calculate(int candidate);

bool is_armstrong_number(int candidate) {
  return calculate(candidate) == candidate;
}

int get_exp(int candidate) { return (int)trunc(1 + log10(candidate)); }

int int_pow(int num, int exp) {
  int result = 1;
  while (exp > 0) {
    result *= num;
    exp -= 1;
  }
  return result;
}

int calculate(int candidate) {
  int exp = get_exp(candidate);
  int result = 0;
  while (candidate > 0) {
    result += int_pow(candidate % 10, exp);
    candidate /= 10;
  }
  return result;
}
