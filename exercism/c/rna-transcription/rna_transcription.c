#include "rna_transcription.h"

char *to_rna(const char *dna) {
  size_t len = strlen(dna);
  char *result = malloc(len + 1);
  result[len] = '\0';

  for (size_t i = 0; i < len; i += 1) {
    switch (dna[i]) {
    case 'G':
      result[i] = 'C';
      break;
    case 'C':
      result[i] = 'G';
      break;
    case 'T':
      result[i] = 'A';
      break;
    case 'A':
      result[i] = 'U';
      break;
    default:
      exit(1);
    }
  }

  return result;
}
