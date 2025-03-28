#include "robot_simulator.h"

void do_robot_move(robot_status_t *robot, char command);
void rotate_left(robot_status_t *robot);
void rotate_right(robot_status_t *robot);
void advance(robot_status_t *robot);

robot_status_t robot_create(robot_direction_t direction, int x, int y) {
  robot_position_t position = {.x = x, .y = y};
  robot_status_t result = {.direction = direction, .position = position};
  return result;
}

void robot_move(robot_status_t *robot, const char *commands) {
  size_t len = strlen(commands);
  for (size_t i = 0; i < len; i += 1) {
    do_robot_move(robot, commands[i]);
  }
}

void do_robot_move(robot_status_t *robot, char command) {
  switch (command) {
  case 'L':
    rotate_left(robot);
    break;
  case 'R':
    rotate_right(robot);
    break;
  case 'A':
    advance(robot);
    break;
  default:
    exit(1);
  }
}

void rotate_left(robot_status_t *robot) {
  if (robot->direction > DIRECTION_MIN) {
    robot->direction -= 1;
  } else {
    robot->direction = DIRECTION_MAX;
  }
}

void rotate_right(robot_status_t *robot) {
  if (robot->direction < DIRECTION_MAX) {
    robot->direction += 1;
  } else {
    robot->direction = DIRECTION_MIN;
  }
}

void advance(robot_status_t *robot) {
  switch (robot->direction) {
  case DIRECTION_NORTH:
    robot->position.y += 1;
    break;
  case DIRECTION_EAST:
    robot->position.x += 1;
    break;
  case DIRECTION_SOUTH:
    robot->position.y -= 1;
    break;
  case DIRECTION_WEST:
    robot->position.x -= 1;
    break;
  default:
    exit(1);
  }
}
