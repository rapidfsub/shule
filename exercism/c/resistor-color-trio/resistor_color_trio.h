#ifndef RESISTOR_COLOR_TRIO_H
#define RESISTOR_COLOR_TRIO_H

#include <stdint.h>
#include <stdlib.h>

typedef enum {
  BLACK,
  BROWN,
  RED,
  ORANGE,
  YELLOW,
  GREEN,
  BLUE,
  VIOLET,
  GREY,
  WHITE
} resistor_band_t;

typedef enum {
  OHMS,
  KILOOHMS,
  MEGAOHMS,
  GIGAOHMS,
} resistor_unit_t;

typedef struct {
  uint64_t value;
  resistor_unit_t unit;
} resistor_value_t;

resistor_value_t color_code(resistor_band_t *bands);

#endif
