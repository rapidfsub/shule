#include "high_scores.h"

int cmp(const void *a, const void *b);

int32_t latest(const int32_t *scores, size_t scores_len) {
  return scores[scores_len - 1];
}

int32_t personal_best(const int32_t *scores, size_t scores_len) {
  if (scores_len < 1) {
    exit(1);
  }

  int32_t result = scores[0];
  for (size_t i = 1; i < scores_len; i += 1) {
    if (result < scores[i]) {
      result = scores[i];
    }
  }
  return result;
}

size_t personal_top_three(const int32_t *scores, size_t scores_len,
                          int32_t *output) {
  qsort((void *)scores, scores_len, sizeof(int32_t), cmp);

  size_t result;
  if (scores_len < 3) {
    result = scores_len;
  } else {
    result = 3;
  }

  for (size_t i = 0; i < result; i += 1) {
    output[i] = scores[i];
  }
  return result;
}

int cmp(const void *a, const void *b) { return *(int *)b - *(int *)a; }
