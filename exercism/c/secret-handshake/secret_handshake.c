#include "secret_handshake.h"

typedef struct {
  size_t bit;
  const char *command;
} action_t;

const action_t ACTIONS[] = {
    {.bit = 1, .command = "wink"},
    {.bit = 2, .command = "double blink"},
    {.bit = 4, .command = "close your eyes"},
    {.bit = 8, .command = "jump"},
};

typedef struct {
  int initial;
  int limit;
  int offset;
} stride_t;

const stride_t STRIDES[] = {
    {.initial = 0, .limit = 4, .offset = 1},
    {.initial = 3, .limit = -1, .offset = -1},
};

const size_t ACTION_COUNT = 4;
const size_t BUFFER_SIZE = sizeof(const char *) * (ACTION_COUNT + 1);
const size_t REVERSE_BIT = 16;

const char **commands(size_t number) {
  const char **result = malloc(BUFFER_SIZE);
  memset(result, 0, BUFFER_SIZE);
  stride_t stride = STRIDES[(number & REVERSE_BIT) > 0];
  size_t count = 0;
  for (int i = stride.initial; i != stride.limit; i += stride.offset) {
    const action_t *curr = &ACTIONS[i];
    if ((number & curr->bit) > 0) {
      result[count] = curr->command;
      count += 1;
    }
  }
  return result;
}
