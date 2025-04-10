#pragma once

#include <ctype.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
  int value;
  const char *keys;
} legacy_map;

typedef struct {
  char key;
  int value;
} new_map;

int convert(const legacy_map *input, const size_t input_len, new_map **output);
