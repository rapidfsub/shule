#ifndef PROTEIN_TRANSLATION_H
#define PROTEIN_TRANSLATION_H

#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>

#define MAX_PROTEINS 10

typedef enum {
  Stop = -100,

  Methionine = 0,
  Phenylalanine,
  Leucine,
  Serine,
  Tyrosine,
  Cysteine,
  Tryptophan,
} protein_t;

typedef struct {
  bool valid;
  size_t count;
  protein_t proteins[MAX_PROTEINS];
} proteins_t;

proteins_t proteins(const char *const rna);

#endif
