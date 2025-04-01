#include "rotational_cipher.h"

char rotate_letter(char letter, int shift_key);
char do_rotate_letter(char letter, char offset, int shift_key);
bool is_punctuation(char letter);

char *rotate(const char *text, int shift_key) {
  size_t len = strlen(text);
  char *result = malloc(len + 1);
  result[len] = '\0';
  for (size_t i = 0; i < len; i += 1) {
    result[i] = rotate_letter(text[i], shift_key);
  }
  return result;
}

char rotate_letter(char letter, int shift_key) {
  if (letter >= 'a' && letter <= 'z') {
    return do_rotate_letter(letter, 'a', shift_key);
  } else if (letter >= 'A' && letter <= 'Z') {
    return do_rotate_letter(letter, 'A', shift_key);
  } else if ((letter >= '0' && letter <= '9') || is_punctuation(letter)) {
    return letter;
  } else {
    exit(1);
  }
}

const int LETTER_COUNT = 'z' - 'a' + 1;

char do_rotate_letter(char letter, char offset, int shift_key) {
  return (letter - offset + shift_key) % LETTER_COUNT + offset;
}

bool is_punctuation(char letter) {
  return letter == ' ' || letter == '\'' || letter == ',' || letter == '!' ||
         letter == '.';
}
