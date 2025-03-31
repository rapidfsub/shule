#include "allergies.h"
#include <stdlib.h>

int get_bit(allergen_t allergen);

bool is_allergic_to(allergen_t allergen, int bits) {
  return (get_bit(allergen) & bits) > 0;
}

allergen_list_t get_allergens(int bits) {
  allergen_list_t result = {.count = 0};
  for (size_t i = 0; i < ALLERGEN_COUNT; i += 1) {
    if (is_allergic_to(i, bits)) {
      result.allergens[i] = true;
      result.count += 1;
    } else {
      result.allergens[i] = false;
    }
  }
  return result;
}

int get_bit(allergen_t allergen) {
  switch (allergen) {
  case ALLERGEN_EGGS:
    return 1;
  case ALLERGEN_PEANUTS:
    return 2;
  case ALLERGEN_SHELLFISH:
    return 4;
  case ALLERGEN_STRAWBERRIES:
    return 8;
  case ALLERGEN_TOMATOES:
    return 16;
  case ALLERGEN_CHOCOLATE:
    return 32;
  case ALLERGEN_POLLEN:
    return 64;
  case ALLERGEN_CATS:
    return 128;
  default:
    exit(1);
  }
}
