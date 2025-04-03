#include "kindergarten_garden.h"

const char *STUDENTS[] = {
    "Alice", "Bob",     "Charlie", "David",  "Eve",     "Fred",
    "Ginny", "Harriet", "Ileana",  "Joseph", "Kincaid", "Larry",
};

const size_t STUDENT_COUNT = sizeof(STUDENTS) / sizeof(STUDENTS[0]);

size_t get_student_index(const char *student);
size_t get_pivot_index(const char *diagram);
plant_t get_plant(char letter);

plants_t plants(const char *diagram, const char *student) {
  size_t col_index = get_student_index(student) * 2;
  size_t next_row_index = get_pivot_index(diagram) + 1;
  size_t indices[] = {
      col_index,
      col_index + 1,
      next_row_index + col_index,
      next_row_index + col_index + 1,
  };

  plants_t result = {0};
  for (size_t i = 0; i < 4; i += 1) {
    result.plants[i] = get_plant(diagram[indices[i]]);
  }
  return result;
}

size_t get_student_index(const char *student) {
  for (size_t i = 0; i < STUDENT_COUNT; i += 1) {
    if (strcmp(STUDENTS[i], student) == 0) {
      return i;
    }
  }
  exit(1);
}

size_t get_pivot_index(const char *diagram) {
  size_t len = strlen(diagram);
  for (size_t i = 0; i < len; i += 1) {
    if (diagram[i] == '\n') {
      return i;
    }
  }
  exit(1);
}

plant_t get_plant(char letter) {
  switch (letter) {
  case 'C':
    return CLOVER;
  case 'G':
    return GRASS;
  case 'R':
    return RADISHES;
  case 'V':
    return VIOLETS;
  default:
    exit(1);
  }
}
