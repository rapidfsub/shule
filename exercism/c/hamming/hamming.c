#include "hamming.h"

int compute(const char *lhs, const char *rhs) {
  size_t len = strlen(lhs);
  if (len > INT_MAX || len != strlen(rhs)) {
    return -1;
  }

  int result = 0;
  for (size_t i = 0; i < len; i += 1) {
    if (lhs[i] != rhs[i]) {
      result += 1;
    }
  }
  return result;
}
