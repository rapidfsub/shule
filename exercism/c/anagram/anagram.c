#include "anagram.h"

char letter_downcase(char letter);
bool letter_is_eqi(char lhs, char rhs);
size_t letter_get_index(char letter);
bool word_is_eqi(const char *lhs, const char *rhs);
void word_count_letters(const char *word, int freq[26]);
bool word_is_anagram(const char *lhs, const char *rhs);

void find_anagrams(const char *subject, struct candidates *candidates) {
  for (size_t i = 0; i < candidates->count; i += 1) {
    struct candidate *candid = &candidates->candidate[i];
    if (word_is_anagram(subject, candid->word)) {
      candid->is_anagram = IS_ANAGRAM;
    } else {
      candid->is_anagram = NOT_ANAGRAM;
    }
  }
}

char letter_downcase(char letter) {
  if (letter >= 'A' && letter <= 'Z') {
    return letter - 'A' + 'a';
  } else {
    return letter;
  }
}

bool letter_is_eqi(char lhs, char rhs) {
  return letter_downcase(lhs) == letter_downcase(rhs);
}

size_t letter_get_index(char letter) {
  if (letter >= 'A' && letter <= 'Z') {
    return letter - 'A';
  } else if (letter >= 'a' && letter <= 'z') {
    return letter - 'a';
  } else {
    exit(1);
  }
}

bool word_is_eqi(const char *lhs, const char *rhs) {
  size_t len = strlen(lhs);
  if (len == strlen(rhs)) {
    for (size_t i = 0; i < len; i += 1) {
      if (!letter_is_eqi(lhs[i], rhs[i])) {
        return false;
      }
    }
    return true;
  } else {
    return false;
  }
}

void word_count_letters(const char *word, int freq[26]) {
  size_t len = strlen(word);
  for (size_t i = 0; i < len; i += 1) {
    freq[letter_get_index(word[i])] += 1;
  }
}

bool word_is_anagram(const char *lhs, const char *rhs) {
  if (word_is_eqi(lhs, rhs)) {
    return false;
  }

  int lhs_freq[26] = {0};
  int rhs_freq[26] = {0};
  word_count_letters(lhs, lhs_freq);
  word_count_letters(rhs, rhs_freq);
  for (size_t i = 0; i < 26; i += 1) {
    if (lhs_freq[i] != rhs_freq[i]) {
      return false;
    }
  }
  return true;
}
