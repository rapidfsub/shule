#include "roman_numerals.h"

const size_t ROMAN_BUFFER_SIZE = 100;

const roman_t ROMANS[] = {
    {.text = "M", .length = 1, .value = 1000},
    {.text = "CM", .length = 2, .value = 900},
    {.text = "D", .length = 1, .value = 500},
    {.text = "CD", .length = 2, .value = 400},
    {.text = "C", .length = 1, .value = 100},
    {.text = "XC", .length = 2, .value = 90},
    {.text = "L", .length = 1, .value = 50},
    {.text = "XL", .length = 2, .value = 40},
    {.text = "X", .length = 1, .value = 10},
    {.text = "IX", .length = 2, .value = 9},
    {.text = "V", .length = 1, .value = 5},
    {.text = "IV", .length = 2, .value = 4},
    {.text = "I", .length = 1, .value = 1},
};

const size_t ROMANS_LENGTH = 13;

char *to_roman_numeral(unsigned int number) {
  char *output = malloc(sizeof(char) * ROMAN_BUFFER_SIZE);
  size_t pos = 0;
  for (size_t i = 0; i < ROMANS_LENGTH;) {
    const roman_t *entry = &ROMANS[i];
    if (number < entry->value) {
      i += 1;
    } else {
      snprintf(&output[pos], entry->length + 1, "%s", entry->text);
      pos += entry->length;
      number -= entry->value;
    }
  }
  return output;
}
