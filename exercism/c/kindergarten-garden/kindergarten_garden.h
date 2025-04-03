#pragma once

#include <stdlib.h>
#include <string.h>

typedef enum { CLOVER = 0, GRASS = 1, RADISHES = 2, VIOLETS = 3 } plant_t;

typedef struct {
  plant_t plants[4];
} plants_t;

plants_t plants(const char *diagram, const char *student);
