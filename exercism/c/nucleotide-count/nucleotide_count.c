#include "nucleotide_count.h"

const char FMT[] = "A:%u C:%u G:%u T:%u";
const int SIZE = sizeof(FMT);

char *count(const char *dna_strand) {
  char *result = malloc(SIZE);
  int count[4] = {0, 0, 0, 0};
  size_t len = strlen(dna_strand);

  for (size_t i = 0; i < len; i += 1) {
    switch (dna_strand[i]) {
    case 'A':
      count[0] += 1;
      break;
    case 'C':
      count[1] += 1;
      break;
    case 'G':
      count[2] += 1;
      break;
    case 'T':
      count[3] += 1;
      break;
    default:
      result[0] = '\0';
      return result;
    }
  }

  snprintf(result, SIZE, FMT, count[0], count[1], count[2], count[3]);
  return result;
}
