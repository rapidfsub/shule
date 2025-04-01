#include "luhn.h"

bool luhn(const char *num) {
  size_t len = strlen(num);
  int n = 0;
  int checksum = 0;

  for (size_t i = 0; i < len; i += 1) {
    int letter = num[len - 1 - i];
    if (letter >= '0' && letter <= '9') {
      n += 1;

      int digit = letter - '0';
      if (n % 2 == 0) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }
      checksum += digit;
    } else if (letter == ' ') {
      continue;
    } else {
      return false;
    }
  }

  return n > 1 && checksum % 10 == 0;
}
