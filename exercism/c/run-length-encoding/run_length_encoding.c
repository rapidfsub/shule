#include "run_length_encoding.h"

size_t get_repeat_len(const char *text, size_t i, size_t len);
size_t get_num_len(const char *text, size_t i, size_t len);

char *encode(const char *text) {
  size_t len = strlen(text);
  char *result = calloc(len + 1, sizeof(char));
  if (len < 1) {
    return result;
  }

  size_t pos = 0;
  for (size_t i = 0; i < len;) {
    size_t count = get_repeat_len(text, i, len);
    if (count > 1) {
      pos += sprintf(&result[pos], "%lu%c", count, text[i]);
    } else {
      result[pos] = text[i];
      pos += 1;
    }
    i += count;
  }
  return result;
}

char *decode(const char *data) {
  size_t len = strlen(data);
  if (len < 1) {
    char *result = calloc(1, sizeof(char));
    return result;
  }

  char *result = calloc(1000, sizeof(char));
  size_t pos = 0;
  for (size_t i = 0; i < len; i += 1) {
    size_t num_len = get_num_len(data, i, len);
    size_t count;
    if (num_len < 1) {
      count = 1;
    } else {
      count = atoi(&data[i]);
      i += num_len;
    }

    while (count > 0) {
      result[pos] = data[i];
      pos += 1;
      count -= 1;
    }
  }
  return result;
}

size_t get_repeat_len(const char *text, size_t i, size_t len) {
  if (len <= i) {
    return 0;
  }

  char curr = text[i];
  size_t result = 1;
  for (size_t j = i + 1; j < len; j += 1) {
    if (text[j] == curr) {
      result += 1;
    } else {
      break;
    }
  }
  return result;
}

size_t get_num_len(const char *text, size_t i, size_t len) {
  if (len <= i) {
    return 0;
  }

  size_t result = 0;
  for (; i < len; i += 1) {
    if (text[i] >= '0' && text[i] <= '9') {
      result += 1;
    } else {
      break;
    }
  }
  return result;
}
