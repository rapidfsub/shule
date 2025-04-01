#include "gigasecond.h"

const int GIGA = 1000 * 1000 * 1000;

void gigasecond(time_t input, char *output, size_t size) {
  input += GIGA;
  struct tm *t = gmtime(&input);
  strftime(output, size, "%Y-%m-%d %H:%M:%S", t);
}
