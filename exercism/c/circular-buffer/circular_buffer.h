#pragma once

#include <errno.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

typedef int16_t buffer_value_t;

typedef struct {
  buffer_value_t *values;
  size_t capacity;
  size_t i;
  size_t count;
} circular_buffer_t;

circular_buffer_t *new_circular_buffer(size_t capacity);
int16_t read(circular_buffer_t *buf, buffer_value_t *val);
int16_t write(circular_buffer_t *buf, buffer_value_t val);
int16_t overwrite(circular_buffer_t *buf, buffer_value_t val);
void delete_buffer(circular_buffer_t *buf);
void clear_buffer(circular_buffer_t *buf);
