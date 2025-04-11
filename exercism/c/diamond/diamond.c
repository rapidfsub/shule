#include "diamond.h"

char **make_diamond(const char letter) {
  size_t pivot = letter - 'A';
  size_t side = pivot * 2 + 1;
  char **result = malloc(sizeof(char *) * side);

  for (size_t i = 0; i <= pivot; i += 1) {
    result[i] = malloc(sizeof(char) * side);
    for (size_t j = 0; j < side; j += 1) {
      if (abs((int)pivot - (int)j) == (int)i) {
        result[i][j] = i + 'A';
      } else {
        result[i][j] = ' ';
      }
    }
  }

  for (size_t i = pivot + 1; i < side; i += 1) {
    result[i] = result[side - i - 1];
  }
  return result;
}

void free_diamond(char **diamond) {
  if (diamond != NULL) {
    free(diamond);
  }
}
