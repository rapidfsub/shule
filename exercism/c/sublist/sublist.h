#pragma once

#include <stdbool.h>
#include <stddef.h>

typedef enum { EQUAL, UNEQUAL, SUBLIST, SUPERLIST } comparison_result_t;

comparison_result_t check_lists(int *cmp, int *base, size_t n, size_t base_n);
