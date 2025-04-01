#include "triangle.h"
#include <stdlib.h>

bool is_triangle(triangle_t t);
int cmp(const void *lhs, const void *rhs);

bool is_equilateral(triangle_t t) {
  return is_triangle(t) && t.a == t.b && t.b == t.c;
}

bool is_isosceles(triangle_t t) {
  return is_triangle(t) && (t.a == t.b || t.b == t.c || t.c == t.a);
}

bool is_scalene(triangle_t t) {
  return is_triangle(t) && t.a != t.b && t.b != t.c && t.c != t.a;
}

bool is_triangle(triangle_t t) {
  double sides[3] = {t.a, t.b, t.c};
  qsort(sides, 3, sizeof(t.a), cmp);
  return sides[0] + sides[1] > sides[2];
}

int cmp(const void *lhs, const void *rhs) {
  if (*(double *)lhs < *(double *)rhs) {
    return -1;
  } else if (*(double *)lhs == *(double *)rhs) {
    return 0;
  } else {
    return 1;
  }
}
