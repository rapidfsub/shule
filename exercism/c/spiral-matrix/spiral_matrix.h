#pragma once

#include <stdbool.h>
#include <stdlib.h>

typedef struct {
  int size;
  int **matrix;
} spiral_matrix_t;

spiral_matrix_t *spiral_matrix_create(size_t n);

void spiral_matrix_destroy(spiral_matrix_t *m);
