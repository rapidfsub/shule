#include "binary.h"
#include <string.h>

int convert(const char *input) {
  size_t len = strlen(input);
  int result = 0;

  for (size_t i = 0; i < len; i += 1) {
    result *= 2;

    switch (input[i]) {
    case '1':
      result += 1;
      break;
    case '0':
      break;
    default:
      return INVALID;
    }
  }

  return result;
}
