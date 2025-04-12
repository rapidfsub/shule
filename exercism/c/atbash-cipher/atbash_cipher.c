#include "atbash_cipher.h"

char *crypt(const char *input, bool will_split);

char *atbash_encode(const char *input) { return crypt(input, true); }

char *atbash_decode(const char *input) { return crypt(input, false); }

char *crypt(const char *input, bool will_split) {
  size_t len = strlen(input);
  char *result = calloc(len * 2, sizeof(char));
  size_t pos = 0;
  for (size_t i = 0; i < len; i += 1) {
    char curr = input[i];
    if (!isalnum(curr)) {
      continue;
    }

    if (will_split && pos % 6 == 5) {
      result[pos] = ' ';
      pos += 1;
    }

    if (isalpha(curr)) {
      if (isupper(curr)) {
        curr = tolower(curr);
      }
      result[pos] = 'z' - curr + 'a';
      pos += 1;
    } else if (isdigit(curr)) {
      result[pos] = curr;
      pos += 1;
    }
  }
  return result;
}
