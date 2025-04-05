#include "beer_song.h"

#include <string.h>

const char *FST_LINES[] = {
    "No more bottles of beer on the wall, no more bottles of beer.",
    "1 bottle of beer on the wall, 1 bottle of beer.",
};

const char *SND_LINES[] = {
    "Go to the store and buy some more, 99 bottles of beer on the wall.",
    "Take it down and pass it around, no more bottles of beer on the wall.",
    "Take one down and pass it around, 1 bottle of beer on the wall.",
};

const size_t LINE_SIZE = 100;

void recite(uint8_t start_bottles, uint8_t take_down, char **song) {
  if (start_bottles + 1 < take_down) {
    exit(1);
  }

  for (size_t i = 0; i < take_down; i += 1) {
    size_t j = 3 * i;
    size_t count = start_bottles - i;

    if (count > 1) {
      snprintf(song[j], LINE_SIZE,
               "%lu bottles of beer on the wall, %lu bottles of beer.", count,
               count);
    } else {
      strncpy(song[j], FST_LINES[count], LINE_SIZE);
    }

    if (count > 2) {
      snprintf(
          song[j + 1], LINE_SIZE,
          "Take one down and pass it around, %lu bottles of beer on the wall.",
          count - 1);
    } else {
      strncpy(song[j + 1], SND_LINES[count], LINE_SIZE);
    }
  }
}
