#include "protein_translation.h"

const size_t PROTEIN_SIZE = 4;
const size_t OFFSET = PROTEIN_SIZE - 1;

typedef struct {
  protein_t protein;
  char text[PROTEIN_SIZE];
} pair_t;

const pair_t PAIRS[] = {
    {.protein = Methionine, .text = "AUG"},
    {.protein = Phenylalanine, .text = "UUU"},
    {.protein = Phenylalanine, .text = "UUC"},
    {.protein = Leucine, .text = "UUA"},
    {.protein = Leucine, .text = "UUG"},
    {.protein = Serine, .text = "UCU"},
    {.protein = Serine, .text = "UCC"},
    {.protein = Serine, .text = "UCA"},
    {.protein = Serine, .text = "UCG"},
    {.protein = Tyrosine, .text = "UAU"},
    {.protein = Tyrosine, .text = "UAC"},
    {.protein = Cysteine, .text = "UGU"},
    {.protein = Cysteine, .text = "UGC"},
    {.protein = Tryptophan, .text = "UGG"},
    {.protein = Stop, .text = "UAA"},
    {.protein = Stop, .text = "UAG"},
    {.protein = Stop, .text = "UGA"},
};

const size_t PAIR_COUNT = sizeof(PAIRS) / sizeof(pair_t);

proteins_t proteins(const char *const rna) {
  proteins_t result = {.valid = true, .count = 0};
  size_t len = strlen(rna);

  for (size_t i = 0; i < len; i += OFFSET) {
    char chunk[PROTEIN_SIZE];
    snprintf(chunk, PROTEIN_SIZE, "%s", &rna[i]);

    const pair_t *pair = NULL;
    for (size_t j = 0; j < PAIR_COUNT; j += 1) {
      if (strcmp(chunk, PAIRS[j].text) == 0) {
        pair = &PAIRS[j];
        break;
      }
    }

    if (pair == NULL) {
      result.valid = false;
      return result;
    } else if (pair->protein == Stop) {
      return result;
    } else {
      result.proteins[result.count] = pair->protein;
      result.count += 1;
    }
  }

  return result;
}
