#include "matching_brackets.h"

bool is_opening(char letter);
bool is_closing(char letter);
char get_opening_pair(char letter);

bool is_paired(const char *input) {
  size_t len = strlen(input);
  char stack[len];
  size_t count = 0;
  for (size_t i = 0; i < len; i += 1) {
    if (is_opening(input[i])) {
      stack[count] = input[i];
      count += 1;
    } else if (is_closing(input[i])) {
      if (count > 0 && get_opening_pair(input[i]) == stack[count - 1]) {
        count -= 1;
      } else {
        return false;
      }
    }
  }
  return count == 0;
}

bool is_opening(char letter) {
  return letter == '(' || letter == '{' || letter == '[';
}

bool is_closing(char letter) {
  return letter == ')' || letter == '}' || letter == ']';
}

char get_opening_pair(char letter) {
  switch (letter) {
  case ')':
    return '(';
  case '}':
    return '{';
  case ']':
    return '[';
  default:
    exit(1);
  }
}
