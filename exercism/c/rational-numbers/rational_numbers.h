#pragma once

#include <math.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct {
  int numerator;
  int denominator;
} rational_t;

rational_t add(rational_t lhs, rational_t rhs);
rational_t subtract(rational_t lhs, rational_t rhs);
rational_t multiply(rational_t lhs, rational_t rhs);
rational_t divide(rational_t lhs, rational_t rhs);

rational_t absolute(rational_t rat);
rational_t reduce(rational_t rat);

rational_t exp_rational(rational_t rat, int exp);
double exp_real(int base, rational_t rat);
