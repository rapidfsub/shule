#include "isogram.h"

int to_bit(char letter);

bool is_isogram(const char phrase[]) {
  if (phrase == NULL) {
    return false;
  }

  size_t len = strlen(phrase);
  int set = 0;
  for (size_t i = 0; i < len; i += 1) {
    int bit = to_bit(phrase[i]);
    if ((set & bit) > 0) {
      return false;
    } else {
      set |= bit;
    }
  }
  return true;
}

int to_bit(char letter) {
  if (letter >= 'a' && letter <= 'z') {
    return 1 << (letter - 'a');
  } else if (letter >= 'A' && letter <= 'Z') {
    return 1 << (letter - 'A');
  } else if (letter >= ' ' && letter <= '-') {
    return 0;
  } else {
    exit(1);
  }
}
