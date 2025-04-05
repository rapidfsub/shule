#include "all_your_base.h"

size_t rebase(int8_t *digits, int16_t input_base, int16_t output_base,
              size_t input_length) {
  if (input_base < 2 || output_base < 2 || input_length < 1) {
    return 0;
  }

  int value = 0;
  for (size_t i = 0; i < input_length; i += 1) {
    if (digits[i] >= 0 && digits[i] < input_base) {
      value *= input_base;
      value += digits[i];
    } else {
      return 0;
    }
  }

  if (value < 1) {
    return 1;
  }

  size_t result = log2(value) / log2(output_base) + 1;
  for (size_t i = 1; i <= result; i += 1) {
    digits[result - i] = value % output_base;
    value /= output_base;
  }
  return result;
}
