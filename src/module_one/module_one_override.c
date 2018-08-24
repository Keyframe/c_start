#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <inttypes.h>
#include <stdbool.h>

#include "module_one_override.h"

void module_one_override() {
    printf("Hello from module one! You will not see this if there's a platform override!\n");
}
