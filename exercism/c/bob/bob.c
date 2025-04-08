#include "bob.h"

bool is_silent(char *text);
bool has_lower(char *text);
bool has_upper(char *text);
bool is_yelling(char *text);
bool is_asking(char *text);

char *hey_bob(char *greeting) {
  if (greeting == NULL || is_silent(greeting)) {
    return "Fine. Be that way!";
  } else if (is_yelling(greeting)) {
    if (is_asking(greeting)) {
      return "Calm down, I know what I'm doing!";
    } else {
      return "Whoa, chill out!";
    }
  } else {
    if (is_asking(greeting)) {
      return "Sure.";
    } else {
      return "Whatever.";
    }
  }
}

bool is_silent(char *text) {
  size_t len = strlen(text);
  for (size_t i = 0; i < len; i += 1) {
    if (!isspace(text[i])) {
      return false;
    }
  }
  return true;
}

bool has_lower(char *text) {
  size_t len = strlen(text);
  for (size_t i = 0; i < len; i += 1) {
    if (islower(text[i])) {
      return true;
    }
  }
  return false;
}

bool has_upper(char *text) {
  size_t len = strlen(text);
  for (size_t i = 0; i < len; i += 1) {
    if (isupper(text[i])) {
      return true;
    }
  }
  return false;
}

bool is_yelling(char *text) { return !has_lower(text) && has_upper(text); }

bool is_asking(char *text) {
  size_t len = strlen(text);
  for (size_t i = 0; i < len; i += 1) {
    char curr = text[len - i - 1];
    if (!isspace(curr)) {
      return curr == '?';
    }
  }
  return false;
}
