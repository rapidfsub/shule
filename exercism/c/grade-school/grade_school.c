#include "grade_school.h"
#include <stdio.h>
#include <string.h>

bool roster_contains_name(roster_t *roster, const char *name);
bool student_has_name(student_t *student, const char *name);
bool student_lt(const student_t *lhs, const student_t *rhs);

void init_roster(roster_t *roster) {
  roster->count = 0;
  memset(roster->students, 0, sizeof(roster->students));
}

bool add_student(roster_t *roster, const char *name, uint8_t grade) {
  if (roster->count >= MAX_STUDENTS || roster_contains_name(roster, name)) {
    return false;
  }

  student_t student;
  student.grade = grade;
  snprintf(student.name, MAX_NAME_LENGTH, "%s", name);

  size_t i = 0;
  for (; i < roster->count; i += 1) {
    if (!student_lt(&roster->students[i], &student)) {
      break;
    }
  }

  student_t *studs = roster->students;
  if (i < roster->count) {
    memmove(&studs[i + 1], &studs[i], sizeof(student_t) * (roster->count - i));
    studs[i] = student;
  } else {
    studs[roster->count] = student;
  }
  roster->count += 1;
  return true;
}

roster_t get_grade(roster_t *roster, uint8_t grade) {
  roster_t result;
  init_roster(&result);
  for (size_t i = 0; i < roster->count; i += 1) {
    if (roster->students[i].grade == grade) {
      add_student(&result, roster->students[i].name, grade);
    }
  }
  return result;
}

bool roster_contains_name(roster_t *roster, const char *name) {
  for (size_t i = 0; i < roster->count; i += 1) {
    if (student_has_name(&roster->students[i], name)) {
      return true;
    }
  }
  return false;
}

bool student_has_name(student_t *student, const char *name) {
  return strncmp(student->name, name, MAX_NAME_LENGTH) == 0;
}

bool student_lt(const student_t *lhs, const student_t *rhs) {
  if (lhs->grade == rhs->grade) {
    return strncmp(lhs->name, rhs->name, MAX_NAME_LENGTH) < 0;
  } else {
    return lhs->grade < rhs->grade;
  }
}
