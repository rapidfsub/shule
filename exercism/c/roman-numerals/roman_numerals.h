#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
  char text[3];
  size_t length;
  unsigned int value;
} roman_t;

char *to_roman_numeral(unsigned int number);
