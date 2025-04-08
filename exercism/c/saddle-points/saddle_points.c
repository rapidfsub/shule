#include "saddle_points.h"

saddle_points_t *saddle_points(size_t n_row, size_t n_col,
                               uint8_t matrix[n_row][n_col]) {
  saddle_points_t *result =
      malloc(sizeof(saddle_points_t) + n_row * n_col * sizeof(saddle_point_t));
  result->count = 0;

  uint8_t max_in_row[n_row];
  for (size_t i = 0; i < n_row; i += 1) {
    max_in_row[i] = matrix[i][0];
  }

  uint8_t min_in_col[n_col];
  for (size_t j = 0; j < n_col; j += 1) {
    min_in_col[j] = matrix[0][j];
  }

  for (size_t i = 0; i < n_row; i += 1) {
    for (size_t j = 0; j < n_col; j += 1) {
      if (matrix[i][j] > max_in_row[i]) {
        max_in_row[i] = matrix[i][j];
      }
      if (matrix[i][j] < min_in_col[j]) {
        min_in_col[j] = matrix[i][j];
      }
    }
  }

  for (size_t i = 0; i < n_row; i += 1) {
    for (size_t j = 0; j < n_col; j += 1) {
      if (matrix[i][j] == max_in_row[i] && matrix[i][j] == min_in_col[j]) {
        result->points[result->count].row = i + 1;
        result->points[result->count].column = j + 1;
        result->count += 1;
      }
    }
  }

  return result;
}

void free_saddle_points(saddle_points_t *actual) { free(actual); }
