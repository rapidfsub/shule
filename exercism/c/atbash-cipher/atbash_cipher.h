#pragma once

#include <ctype.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

char *atbash_encode(const char *input);
char *atbash_decode(const char *input);
