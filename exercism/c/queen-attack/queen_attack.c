#include "queen_attack.h"
#include <stdbool.h>
#include <stdlib.h>

bool is_on_board(position_t q);
bool is_on_row(position_t q1, position_t q2);
bool is_on_col(position_t q1, position_t q2);
bool is_on_diag(position_t q1, position_t q2);
bool is_eq(position_t q1, position_t q2);

attack_status_t can_attack(position_t q1, position_t q2) {
  if (!is_on_board(q1) || !is_on_board(q2) || is_eq(q1, q2)) {
    return INVALID_POSITION;
  } else if (is_on_row(q1, q2) || is_on_col(q1, q2) || is_on_diag(q1, q2)) {
    return CAN_ATTACK;
  } else {
    return CAN_NOT_ATTACK;
  }
}

bool is_on_board(position_t q) { return q.row < 8 && q.column < 8; }

bool is_on_row(position_t q1, position_t q2) { return q1.row == q2.row; }

bool is_on_col(position_t q1, position_t q2) { return q1.column == q2.column; }

bool is_on_diag(position_t q1, position_t q2) {
  return abs(q1.row - q2.row) == abs(q1.column - q2.column);
}

bool is_eq(position_t q1, position_t q2) {
  return is_on_row(q1, q2) && is_on_col(q1, q2);
}
