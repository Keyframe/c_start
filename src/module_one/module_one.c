#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <inttypes.h>
#include <stdbool.h>

#include "module_one.h"

void module_one() {
    module_one_t test;
    test.x = 1;

    printf("Hello from module one: %" PRIu64 "\n", test.x);
}
