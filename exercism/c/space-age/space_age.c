#include "space_age.h"

float get_period_ratio(planet_t planet);

const float SECONDS_PER_EARTH_YEAR = 60 * 60 * 24 * 365.25;

float age(planet_t planet, int64_t seconds) {
  float ratio = get_period_ratio(planet);
  if (isfinite(ratio)) {
    return seconds / (SECONDS_PER_EARTH_YEAR * ratio);
  } else {
    return -1;
  }
}

float get_period_ratio(planet_t planet) {
  switch (planet) {
  case MERCURY:
    return 0.2408467;
  case VENUS:
    return 0.61519726;
  case EARTH:
    return 1.0;
  case MARS:
    return 1.8808158;
  case JUPITER:
    return 11.862615;
  case SATURN:
    return 29.447498;
  case URANUS:
    return 84.016846;
  case NEPTUNE:
    return 164.79132;
  default:
    return NAN;
  }
}
