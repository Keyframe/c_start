#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <inttypes.h>
#include <stdbool.h>

#include "../module_one_override.h"

void module_one_override() {
    printf("Hello from module one! Overriden by OSX platform override!\n");
}
