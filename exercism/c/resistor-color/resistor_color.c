#include "resistor_color.h"
#include <stdlib.h>

const resistor_band_t COLORS[] = {BLACK, BROWN, RED,    ORANGE, YELLOW,
                                  GREEN, BLUE,  VIOLET, GREY,   WHITE};

const resistor_band_t *colors(void) { return COLORS; }

int color_code(resistor_band_t band) {
  int result = 0;
  while (result < 10) {
    if (COLORS[result] == band) {
      return result;
    }
    result += 1;
  }
  exit(1);
}
