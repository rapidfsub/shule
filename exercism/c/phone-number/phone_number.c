#include "phone_number.h"

char *phone_number_clean(const char *input) {
  size_t len = strlen(input);
  char *result = malloc(12 * sizeof(char));
  size_t count = 0;
  for (size_t i = 0; i < len && count < 11; i += 1) {
    if (input[i] >= '0' && input[i] <= '9') {
      result[count] = input[i];
      count += 1;
    }
  }

  if (count > 10 && result[0] == '1') {
    memmove(result, &result[1], 11);
    count = 10;
  }

  if (count != 10 || result[0] < '2' || result[3] < '2') {
    memcpy(result, "0000000000", 11);
  }

  result[10] = '\0';
  return result;
}
