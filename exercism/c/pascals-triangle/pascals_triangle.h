#ifndef PASCALS_TRIANGLE_H
#define PASCALS_TRIANGLE_H

#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

void free_triangle(uint8_t **triangle, size_t rows);
uint8_t **create_triangle(size_t rows);

#endif
