#include "minesweeper.h"

typedef struct {
  int di;
  int dj;
} offset_t;

const offset_t OFFSETS[] = {
    // clang-format off
    {.di = 1, .dj = 1},
    {.di = 1, .dj = 0},
    {.di = 1, .dj = -1},
    {.di = 0, .dj = -1},
    {.di = -1, .dj = -1},
    {.di = -1, .dj = 0},
    {.di = -1, .dj = 1},
    {.di = 0, .dj = 1},
    // clang-format on
};

const size_t OFFSET_COUNT = 8;

char **annotate(const char **minefield, const size_t rows) {
  if (rows < 1) {
    return NULL;
  }

  char **result = malloc(sizeof(char *) * rows);
  int i_lim = rows;
  int j_lim = strlen(minefield[0]);
  for (int i = 0; i < i_lim; i += 1) {
    result[i] = malloc(sizeof(char) * j_lim);
    for (int j = 0; j < j_lim; j += 1) {
      if (minefield[i][j] == '*') {
        result[i][j] = minefield[i][j];
        continue;
      }

      size_t count = 0;
      for (size_t k = 0; k < OFFSET_COUNT; k += 1) {
        offset_t offset = OFFSETS[k];
        int x = i + offset.di;
        int y = j + offset.dj;
        if (x >= 0 && x < i_lim && y >= 0 && y < j_lim &&
            minefield[x][y] == '*') {
          count += 1;
        }
      }

      if (count > 0) {
        result[i][j] = '0' + count;
      } else {
        result[i][j] = ' ';
      }
    }
  }
  return result;
}

void free_annotation(char **annotation) { free(annotation); }
