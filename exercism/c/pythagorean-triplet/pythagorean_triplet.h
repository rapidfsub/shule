#pragma once

#include <stdlib.h>

typedef struct {
  size_t a;
  size_t b;
  size_t c;
} triplet_t;

typedef struct {
  size_t count;
  triplet_t triplets[];
} triplets_t;

triplets_t *triplets_with_sum(size_t sum);

void free_triplets(triplets_t *triplets);
