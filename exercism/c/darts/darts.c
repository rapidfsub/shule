#include "darts.h"

uint8_t score(coordinate_t pos) {
  float dist = pow(pos.x, 2) + pow(pos.y, 2);
  if (dist > 100) {
    return 0;
  } else if (dist > 25) {
    return 1;
  } else if (dist > 1) {
    return 5;
  } else {
    return 10;
  }
}
