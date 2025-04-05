#pragma once

#include <stdlib.h>
#include <string.h>

typedef enum {
  MIN_SIMPLE_CATEGORY = 1,
  ONES = MIN_SIMPLE_CATEGORY,
  TWOS,
  THREES,
  FOURS,
  FIVES,
  SIXES,
  MAX_SIMPLE_CATEGORY = SIXES,

  FULL_HOUSE,
  FOUR_OF_A_KIND,
  LITTLE_STRAIGHT,
  BIG_STRAIGHT,
  CHOICE,
  YACHT
} category_t;

typedef struct {
  int faces[5];
} dice_t;

int score(dice_t dice, category_t category);
