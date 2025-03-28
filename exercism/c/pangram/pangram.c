#include "pangram.h"

int to_bit(char letter);

const int ALL_LETTERS = 0x003FFFFFF;

bool is_pangram(const char *sentence) {
  if (sentence == NULL) {
    return false;
  }

  int bits = 0;
  size_t len = strlen(sentence);
  for (size_t i = 0; i < len; i += 1) {
    bits |= to_bit(sentence[i]);
  }
  return (bits & ALL_LETTERS) == ALL_LETTERS;
}

int to_bit(char letter) {
  if (letter >= 'a' && letter <= 'z') {
    return 1 << (letter - 'a');
  } else if (letter >= 'A' && letter <= 'Z') {
    return 1 << (letter - 'A');
  } else {
    return 0;
  }
}
