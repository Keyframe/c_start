MODULE_NAME := $(lastword $(subst /, , $(dir $(lastword $(MAKEFILE_LIST)))))

SRC_$(MODULE_NAME) := $(subst src/$(MODULE_NAME)/,,$(wildcard src/$(MODULE_NAME)/*.c))

# D prefix is for debug release
CFLAGS_$(MODULE_NAME) := 
DCFLAGS_$(MODULE_NAME) := 
INC_$(MODULE_NAME) := 
DINC_$(MODULE_NAME) := 
LIB_$(MODULE_NAME) := 
DLIB_$(MODULE_NAME) := 
LINKER_$(MODULE_NAME) :=
DLINKER_$(MODULE_NAME) := 
RESTO_$(MODULE_NAME) := 
DRESTO_$(MODULE_NAME) := 

-include $(patsubst %, src/$(MODULE_NAME)/_%/module.mk, $(PLATFORM))
