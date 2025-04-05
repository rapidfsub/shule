#include "grade_school.h"
#include <stdio.h>
#include <string.h>

bool roster_contains_name(roster_t *actual, const char *name);
bool student_has_name(student_t *student, const char *name);
int student_cmp(const void *lhs, const void *rhs);

void init_roster(roster_t *actual) {
  actual->count = 0;
  memset(actual->students, 0, sizeof(actual->students));
}

bool add_student(roster_t *actual, const char *name, uint8_t grade) {
  if (actual->count >= MAX_STUDENTS || roster_contains_name(actual, name)) {
    return false;
  }

  student_t *pos = &actual->students[actual->count];
  pos->grade = grade;
  snprintf(pos->name, MAX_NAME_LENGTH, "%s", name);
  actual->count += 1;
  qsort(actual->students, actual->count, sizeof(student_t), student_cmp);
  return true;
}

roster_t get_grade(roster_t *actual, uint8_t grade) {
  roster_t result;
  init_roster(&result);
  for (size_t i = 0; i < actual->count; i += 1) {
    if (actual->students[i].grade == grade) {
      add_student(&result, actual->students[i].name, grade);
    }
  }
  return result;
}

bool roster_contains_name(roster_t *actual, const char *name) {
  for (size_t i = 0; i < actual->count; i += 1) {
    if (student_has_name(&actual->students[i], name)) {
      return true;
    }
  }
  return false;
}

bool student_has_name(student_t *student, const char *name) {
  return strncmp(student->name, name, MAX_NAME_LENGTH) == 0;
}

int student_cmp(const void *lhs, const void *rhs) {
  const student_t *s1 = lhs;
  const student_t *s2 = rhs;
  if (s1->grade == s2->grade) {
    return strncmp(s1->name, s2->name, MAX_NAME_LENGTH);
  } else {
    return s1->grade - s2->grade;
  }
}
