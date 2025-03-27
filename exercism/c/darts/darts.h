#ifndef DARTS_H
#define DARTS_H

#include <math.h>
#include <stdint.h>

typedef struct {
  double x;
  double y;
} coordinate_t;

uint8_t score(coordinate_t pos);

#endif
