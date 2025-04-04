#include "spiral_matrix.h"

typedef struct {
  int r;
  int c;
} point_t;

bool is_eq(point_t lhs, point_t rhs);
point_t add(point_t lhs, point_t rhs);
point_t rotate(point_t point);

spiral_matrix_t *spiral_matrix_create(size_t n) {
  spiral_matrix_t *result = malloc(sizeof(spiral_matrix_t));
  *result = (spiral_matrix_t){.size = n, .matrix = NULL};
  if (n < 1) {
    return result;
  }

  result->matrix = malloc(sizeof(int *) * n);
  for (size_t i = 0; i < n; i += 1) {
    result->matrix[i] = calloc(n, sizeof(int));
  }

  int x = 1;
  for (size_t c = 0; c < n; c += 1, x += 1) {
    result->matrix[0][c] = x;
  }

  point_t p = {.r = 0, .c = n - 1};
  point_t dp = {.r = 1, .c = 0};
  for (size_t limit = n - 1; limit > 0; limit -= 1) {
    for (size_t i = 0; i < 2; i += 1) {
      for (size_t j = 0; j < limit; j += 1, x += 1) {
        p = add(p, dp);
        result->matrix[p.r][p.c] = x;
      }
      dp = rotate(dp);
    }
  }
  return result;
}

void spiral_matrix_destroy(spiral_matrix_t *m) {
  for (int i = 0; i < m->size; i += 1) {
    free(m->matrix[i]);
  }
  free(m->matrix);
  free(m);
}

bool is_eq(point_t lhs, point_t rhs) {
  return lhs.r == rhs.r && lhs.c == rhs.c;
}

point_t add(point_t lhs, point_t rhs) {
  return (point_t){.r = lhs.r + rhs.r, .c = lhs.c + rhs.c};
}

point_t rotate(point_t point) {
  static const point_t directions[] = {{.r = 0, .c = 1},
                                       {.r = 1, .c = 0},
                                       {.r = 0, .c = -1},
                                       {.r = -1, .c = 0},
                                       {.r = 0, .c = 1}};

  for (size_t i = 0; i < 4; i += 1) {
    if (is_eq(point, directions[i])) {
      return directions[i + 1];
    }
  }
  exit(1);
}
