SUBMODULE_NAME := $(lastword $(subst /, , $(dir $(lastword $(MAKEFILE_LIST)))))

LOCAL_FILES := $(subst src/$(MODULE_NAME)/$(SUBMODULE_NAME)/,,$(wildcard src/$(MODULE_NAME)/$(SUBMODULE_NAME)/*.c))

SRC_$(MODULE_NAME) := $(filter-out $(LOCAL_FILES), $(SRC_$(MODULE_NAME)))

SRC_$(MODULE_NAME) += $(subst src/$(MODULE_NAME)/,,$(wildcard src/$(MODULE_NAME)/$(SUBMODULE_NAME)/*.c))

# submodule flags
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
