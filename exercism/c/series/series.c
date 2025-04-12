#include "series.h"

slices_t slices(char *input_text, unsigned int substring_length) {
  size_t len = strlen(input_text);
  slices_t result = {0};
  if (substring_length < 1 || len < substring_length) {
    return result;
  }

  result.substring_count = (len - substring_length + 1);
  result.substring = malloc(sizeof(char *) * result.substring_count);
  for (size_t i = 0; i < result.substring_count; i += 1) {
    size_t size = sizeof(char) * (substring_length + 1);
    result.substring[i] = malloc(size);
    memset(result.substring[i], 0, size);
    strncpy(result.substring[i], &input_text[i], substring_length);
  }
  return result;
}
