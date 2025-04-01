#include "reverse_string.h"

char *reverse(const char *value) {
  size_t len = strlen(value);
  char *result = malloc(len + 1);
  result[len] = '\0';
  for (size_t i = 0; i < len; i += 1) {
    result[i] = value[len - i - 1];
  }
  return result;
}
