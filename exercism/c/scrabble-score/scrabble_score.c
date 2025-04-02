#include "scrabble_score.h"
#include <stdlib.h>
#include <string.h>

const unsigned int SCORES[26] = {
    // A B C D E
    1, 3, 3, 2, 1,
    // F G H I J
    4, 2, 4, 1, 8,
    // K L M N O
    5, 1, 3, 1, 1,
    // P Q R S T
    3, 10, 1, 1, 1,
    // U V W X Y
    1, 4, 4, 8, 4,
    // Z
    10};

unsigned int get_score(char letter);

unsigned int score(const char *word) {
  size_t len = strlen(word);
  unsigned int result = 0;
  for (size_t i = 0; i < len; i += 1) {
    result += get_score(word[i]);
  }
  return result;
}

unsigned int get_score(char letter) {
  if (letter >= 'a' && letter <= 'z') {
    return SCORES[letter - 'a'];
  } else if (letter >= 'A' && letter <= 'Z') {
    return SCORES[letter - 'A'];
  } else {
    exit(1);
  }
}
