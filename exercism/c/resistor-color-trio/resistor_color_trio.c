#include "resistor_color_trio.h"

uint16_t single_color_code(resistor_band_t band);
uint64_t get_multiplier(resistor_band_t band);
resistor_value_t normalize(uint64_t value);

const uint64_t KILO = 1000;
const uint64_t MEGA = KILO * 1000;
const uint64_t GIGA = MEGA * 1000;

resistor_value_t color_code(resistor_band_t *bands) {
  uint64_t value = single_color_code(bands[0]) * 10;
  value += single_color_code(bands[1]);
  value *= get_multiplier(bands[2]);
  return normalize(value);
}

const resistor_band_t COLORS[] = {BLACK, BROWN, RED,    ORANGE, YELLOW,
                                  GREEN, BLUE,  VIOLET, GREY,   WHITE};

uint16_t single_color_code(resistor_band_t band) {
  uint16_t result = 0;
  while (result < 10) {
    if (COLORS[result] == band) {
      return result;
    }
    result += 1;
  }
  exit(1);
}

uint64_t get_multiplier(resistor_band_t band) {
  uint64_t zeros = single_color_code(band);
  uint64_t result = 1;
  while (zeros > 0) {
    result *= 10;
    zeros -= 1;
  }
  return result;
}

resistor_value_t normalize(uint64_t value) {
  resistor_value_t result;
  if (value == 0) {
    result.value = value;
    result.unit = OHMS;
  } else if (value % GIGA == 0) {
    result.value = value / GIGA;
    result.unit = GIGAOHMS;
  } else if (value % MEGA == 0) {
    result.value = value / MEGA;
    result.unit = MEGAOHMS;
  } else if (value % KILO == 0) {
    result.value = value / KILO;
    result.unit = KILOOHMS;
  } else {
    result.value = value;
    result.unit = OHMS;
  }
  return result;
}
