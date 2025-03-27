#include "dnd_character.h"

int roll_dice(void);

int ability(void) {
  int dies[4];
  for (size_t i = 0; i < 4; i += 1) {
    dies[i] = roll_dice();
  }

  int sum = 0;
  int min = dies[0];
  for (size_t i = 0; i < 4; i += 1) {
    sum += dies[i];
    if (dies[i] < min) {
      min = dies[i];
    }
  }
  return sum - min;
}

int modifier(int score) {
  double tmp = score - 10;
  tmp /= 2;
  return (int)floor(tmp);
}

dnd_character_t make_dnd_character(void) {
  srand(time(NULL));
  int constitution = ability();
  dnd_character_t result = {
      .strength = ability(),
      .dexterity = ability(),
      .intelligence = ability(),
      .wisdom = ability(),
      .charisma = ability(),
      .constitution = constitution,
      .hitpoints = modifier(constitution) + 10,
  };
  return result;
}

int roll_dice(void) { return rand() % 6 + 1; }
