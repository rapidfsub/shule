#include "etl.h"

const size_t BUFFER_SIZE = sizeof(new_map) * 26;

int new_map_cmp(const void *lhs, const void *rhs);

int convert(const legacy_map *input, const size_t input_len, new_map **output) {
  new_map *result = malloc(BUFFER_SIZE);
  memset(result, 0, BUFFER_SIZE);

  size_t count = 0;
  for (size_t i = 0; i < input_len; i += 1) {
    const legacy_map *curr = &input[i];
    size_t len = strlen(curr->keys);
    for (size_t j = 0; j < len; j += 1) {
      result[count].key = tolower(curr->keys[j]);
      result[count].value = curr->value;
      count += 1;
    }
  }

  qsort(result, count, sizeof(new_map), new_map_cmp);
  *output = result;
  return count;
}

int new_map_cmp(const void *lhs, const void *rhs) {
  const new_map *lhs_map = lhs;
  const new_map *rhs_map = rhs;
  if (lhs_map->key < rhs_map->key) {
    return -1;
  } else if (lhs_map->key == rhs_map->key) {
    return 0;
  } else {
    return 1;
  }
}
