#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <inttypes.h>
#include <stdbool.h>

#include "../src/module_one/module_one.h"
#include "../src/module_one/module_one_override.h"

int main(int argc, char *argv[]) {

    module_one();
    module_one_override();

    exit(EXIT_SUCCESS);
}

