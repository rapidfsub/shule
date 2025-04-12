#pragma once

#include <stdlib.h>
#include <string.h>

char **annotate(const char **minefield, const size_t rows);
void free_annotation(char **annotation);
