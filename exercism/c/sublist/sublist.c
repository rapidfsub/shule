#include "sublist.h"

bool is_equal(int *lhs, int *rhs, size_t n);
bool is_sublist(int *lhs, int *rhs, size_t lhs_n, size_t rhs_n);

comparison_result_t check_lists(int *cmp, int *base, size_t n, size_t base_n) {
  if (n < base_n && is_sublist(cmp, base, n, base_n)) {
    return SUBLIST;
  } else if (n == base_n && is_sublist(cmp, base, n, base_n)) {
    return EQUAL;
  } else if (n > base_n && is_sublist(base, cmp, base_n, n)) {
    return SUPERLIST;
  } else {
    return UNEQUAL;
  }
}

bool is_equal(int *lhs, int *rhs, size_t n) {
  for (size_t i = 0; i < n; i += 1) {
    if (lhs[i] != rhs[i]) {
      return false;
    }
  }
  return true;
}

bool is_sublist(int *lhs, int *rhs, size_t lhs_n, size_t rhs_n) {
  if (lhs_n > rhs_n) {
    return false;
  }

  size_t limit = rhs_n - lhs_n;
  for (size_t i = 0; i <= limit; i += 1) {
    if (is_equal(lhs, &rhs[i], lhs_n)) {
      return true;
    }
  }
  return false;
}
