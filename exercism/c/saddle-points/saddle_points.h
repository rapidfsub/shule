#pragma once

#include <stdint.h>
#include <stdlib.h>

typedef struct {
  size_t row;
  size_t column;
} saddle_point_t;

typedef struct {
  size_t count;
  saddle_point_t points[];
} saddle_points_t;

saddle_points_t *saddle_points(size_t n_row, size_t n_col,
                               uint8_t matrix[n_row][n_col]);

void free_saddle_points(saddle_points_t *actual);
