#include "sum_of_multiples.h"

unsigned int sum(const unsigned int *factors, const size_t number_of_factors,
                 const unsigned int limit) {
  bool did_visit[limit];
  for (size_t i = 0; i < limit; i += 1) {
    did_visit[i] = false;
    for (size_t j = 0; j < number_of_factors; j += 1) {
      if (factors[j] != 0 && i % factors[j] == 0) {
        did_visit[i] = true;
        break;
      }
    }
  }

  int result = 0;
  for (size_t i = 0; i < limit; i += 1) {
    if (did_visit[i]) {
      result += i;
    }
  }
  return result;
}
