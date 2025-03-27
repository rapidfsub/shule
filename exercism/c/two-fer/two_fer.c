#include "two_fer.h"

void two_fer(char *buffer, const char *name) {
  strcat(buffer, "One for ");
  if (name == NULL) {
    strcat(buffer, "you");
  } else {
    strcat(buffer, name);
  }
  strcat(buffer, ", one for me.");
}
