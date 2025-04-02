#include "yacht.h"

const int SCORE_STRAIGHT = 30;
const int SCORE_YACHT = 50;

int score(dice_t dice, category_t category) {
  if (category == CHOICE) {
    int result = 0;
    for (size_t i = 0; i < 5; i += 1) {
      result += dice.faces[i];
    }
    return result;
  }

  int freq[7];
  memset(freq, 0, sizeof(freq));
  for (size_t i = 0; i < 5; i += 1) {
    freq[dice.faces[i]] += 1;
  }

  if (category < MIN_SIMPLE_CATEGORY) {
    exit(1);
  } else if (category <= MAX_SIMPLE_CATEGORY) {
    return freq[category] * category;
  } else if (category == FULL_HOUSE) {
    int twos = 0;
    int threes = 0;
    for (size_t i = 1; i <= 6; i += 1) {
      if (freq[i] == 2) {
        twos = i;
      } else if (freq[i] == 3) {
        threes = i;
      }
    }

    if (twos > 0 && threes > 0) {
      return twos * 2 + threes * 3;
    } else {
      return 0;
    }
  }

  switch (category) {
  case FOUR_OF_A_KIND:
    for (size_t i = 1; i <= 6; i += 1) {
      if (freq[i] >= 4) {
        return i * 4;
      }
    }
    return 0;
  case LITTLE_STRAIGHT:
    for (size_t i = 1; i < 6; i += 1) {
      if (freq[i] != 1) {
        return 0;
      }
    }
    return SCORE_STRAIGHT;
  case BIG_STRAIGHT:
    for (size_t i = 2; i <= 6; i += 1) {
      if (freq[i] != 1) {
        return 0;
      }
    }
    return SCORE_STRAIGHT;
  case YACHT:
    for (size_t i = 1; i <= 6; i += 1) {
      if (freq[i] == 5) {
        return SCORE_YACHT;
      }
    }
    return 0;
  default:
    exit(1);
  }
}
