#include "clock.h"

typedef struct {
  int fst;
  int snd;
} int_pair_t;

int to_int(char fst, char snd);
int_pair_t to_pair(clock_t clock);

const int MINUTES_PER_HOUR = 60;
const int HOURS_PER_DAY = 24;

clock_t clock_create(int hour, int minute) {
  hour += minute / MINUTES_PER_HOUR;
  minute %= MINUTES_PER_HOUR;
  if (minute < 0) {
    hour -= 1;
    minute += MINUTES_PER_HOUR;
  }

  hour %= HOURS_PER_DAY;
  if (hour < 0) {
    hour += HOURS_PER_DAY;
  }

  clock_t result;
  snprintf(result.text, MAX_STR_LEN, "%02u:%02u", hour, minute);
  return result;
}

clock_t clock_add(clock_t clock, int minute_add) {
  int_pair_t pair = to_pair(clock);
  return clock_create(pair.fst, pair.snd + minute_add);
}

clock_t clock_subtract(clock_t clock, int minute_subtract) {
  return clock_add(clock, -minute_subtract);
}

bool clock_is_equal(clock_t a, clock_t b) {
  int_pair_t lhs = to_pair(a);
  int_pair_t rhs = to_pair(b);
  return lhs.fst == rhs.fst && lhs.snd == rhs.snd;
}

int to_int(char fst, char snd) {
  if (fst >= '0' && fst <= '9' && snd >= '0' && snd <= '9') {
    return (fst - '0') * 10 + (snd - '0');
  } else {
    exit(1);
  }
}

int_pair_t to_pair(clock_t clock) {
  return (int_pair_t){.fst = to_int(clock.text[0], clock.text[1]),
                      .snd = to_int(clock.text[3], clock.text[4])};
}
