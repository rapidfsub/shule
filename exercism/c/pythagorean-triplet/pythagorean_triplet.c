#include "pythagorean_triplet.h"

triplets_t *triplets_with_sum(size_t sum) {
  size_t size = sizeof(triplets_t) + sum * sizeof(triplet_t);
  triplets_t *result = malloc(size);
  result->count = 0;

  triplet_t curr = {.a = 0, .b = 0, .c = 0};
  size_t a_lim = sum / 3;
  for (curr.a = 1; curr.a <= a_lim; curr.a += 1) {
    size_t b_lim = (sum - curr.a) / 2;
    for (curr.b = curr.a; curr.b <= b_lim; curr.b += 1) {
      curr.c = sum - curr.a - curr.b;
      if (curr.a * curr.a + curr.b * curr.b == curr.c * curr.c) {
        result->triplets[result->count] = curr;
        result->count += 1;
      }
    }
  }
  return result;
}

void free_triplets(triplets_t *triplets) { free(triplets); }
