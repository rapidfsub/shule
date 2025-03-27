#include "resistor_color_duo.h"

uint16_t single_color_code(resistor_band_t band);

uint16_t color_code(resistor_band_t *bands) {
  return 10 * single_color_code(bands[0]) + single_color_code(bands[1]);
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
