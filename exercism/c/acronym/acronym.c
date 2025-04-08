#include "acronym.h"

bool is_separator(char letter);

char *abbreviate(const char *phrase) {
  if (phrase == NULL) {
    return NULL;
  }

  size_t len = strlen(phrase);
  if (len < 1) {
    return NULL;
  }

  char *result = malloc(sizeof(char) * len);
  size_t count = 0;
  for (size_t i = 0; i < len; i += 1) {
    if (i > 0 && !is_separator(phrase[i - 1])) {
      continue;
    } else if (phrase[i] >= 'A' && phrase[i] <= 'Z') {
      result[count] = phrase[i];
      count += 1;
    } else if (phrase[i] >= 'a' && phrase[i] <= 'z') {
      result[count] = phrase[i] - 'a' + 'A';
      count += 1;
    }
  }
  result[count] = '\0';
  return result;
}

bool is_separator(char letter) {
  return letter == ' ' || letter == '-' || letter == '_';
}
