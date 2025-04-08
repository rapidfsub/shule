#include "pascals_triangle.h"

uint8_t **create_triangle(size_t rows) {
  if (rows < 1) {
    uint8_t **result = malloc(sizeof(uint8_t *));
    result[0] = malloc(sizeof(uint8_t));
    result[0][0] = 0;
    return result;
  }

  uint8_t **result = malloc(sizeof(uint8_t *) * rows);
  for (size_t i = 0; i < rows; i += 1) {
    size_t size = sizeof(uint8_t) * rows;
    result[i] = malloc(size);
    memset(result[i], 0, size);
    result[i][0] = 1;
    for (size_t j = 1; j <= i; j += 1) {
      result[i][j] = result[i - 1][j - 1] + result[i - 1][j];
    }
  }
  return result;
}

void free_triangle(uint8_t **triangle, size_t rows) {
  for (size_t i = 0; i < rows; i += 1) {
    free(triangle[i]);
  }
  free(triangle);
}
