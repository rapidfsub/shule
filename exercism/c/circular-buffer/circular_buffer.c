#include "circular_buffer.h"

void increase_index(circular_buffer_t *buf);
void push(circular_buffer_t *buf, buffer_value_t val);

circular_buffer_t *new_circular_buffer(size_t capacity) {
  circular_buffer_t *result = malloc(sizeof(circular_buffer_t));
  result->values = malloc(sizeof(buffer_value_t) * capacity);
  result->capacity = capacity;
  result->i = 0;
  result->count = 0;
  return result;
}

int16_t read(circular_buffer_t *buf, buffer_value_t *val) {
  if (buf->count > 0) {
    *val = buf->values[buf->i];
    increase_index(buf);
    buf->count -= 1;
    return EXIT_SUCCESS;
  } else {
    errno = ENODATA;
    return EXIT_FAILURE;
  }
}

int16_t write(circular_buffer_t *buf, buffer_value_t val) {
  if (buf->count < buf->capacity) {
    push(buf, val);
    buf->count += 1;
    return EXIT_SUCCESS;
  } else {
    errno = ENOBUFS;
    return EXIT_FAILURE;
  }
}

int16_t overwrite(circular_buffer_t *buf, buffer_value_t val) {
  if (buf->count < buf->capacity) {
    return write(buf, val);
  } else {
    push(buf, val);
    increase_index(buf);
    return EXIT_SUCCESS;
  }
}

void delete_buffer(circular_buffer_t *buf) {
  free(buf->values);
  free(buf);
}

void clear_buffer(circular_buffer_t *buf) {
  memset(buf->values, 0, sizeof(buffer_value_t) * buf->capacity);
  buf->count = 0;
}

void increase_index(circular_buffer_t *buf) {
  buf->i += 1;
  buf->i %= buf->capacity;
}

void push(circular_buffer_t *buf, buffer_value_t val) {
  size_t j = (buf->i + buf->count) % buf->capacity;
  buf->values[j] = val;
}
