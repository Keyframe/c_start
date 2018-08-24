# Shuriken lib
# PLATFORM sets the platform, release and debug for each are available
# Usage: make release/debug PLATFORM=osx

# full example for OSX dynamic lib
# @libtool -dynamic $(addsuffix .o,$(addprefix $(PREFIX)/$(PLATFORM)/_objects_/,$(subst .c,.o, $(MODULES)))) -Lextlib/build/osx/release/glfw3/lib -lglfw3 -o $(PREFIX)/$(PLATFORM)/lib$(LIBNAME).dylib -framework CoreFoundation -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo -framework Carbon -lSystem -macosx_version_min 10.11 -install_name @executable_path/lib$(LIBNAME).dylib -compatibility_version 0.0.1 -current_version 0.0.1 -undefined dynamic_lookup -flat_namespace -multiply_defined suppress;

PLATFORM ?= none
PLATFORMS := osx windows linux ios android

# Get src/ directories
MODULES := $(sort $(dir $(wildcard src/*/)))
# Clean src and / from module list
MODULES := $(subst /,,$(subst src,,$(MODULES)))

# Filter out unwanted modules
IGNORE_MODULES = 
MODULES := $(filter-out $(IGNORE_MODULES), $(MODULES))

.DEFAULT_GOAL := all

include $(patsubst %, src/%/module.mk, $(MODULES))

CC := $(CC)
LD := $(LD)
PREFIX := build
LIBNAME := mylibrary

# common CFLAGS for everything
CFLAGS := -c -std=c99 -Wall -Werror -pedantic -fdiagnostics-color=always
CFLAGS_DYNAMIC := -fPIC
# include paths for everything -Iinclude/
INCLUDES := -Iinclude
# library paths for everything
LIBRARIES := 
# linker flags for everything
LINKERFLAGS := 
# framwork flags and similar for everything
RESTOFLAGS :=
# debug equivavlents, override manually or set to same as release flags
DCFLAGS := $(CFLAGS)
DCFLAGS_DYNAMIC := $(CFLAGS) -fPIC
DINCLUDES := $(INCLUDES)
DLIBRARIES := $(LIBRARIES)
DLINKERFLAGS := $(LINKERFLAGS)
DRESTOFLAGS := $(RESTOFLAGS)

# internal use
OUT_LIBRARIES :=
OUT_RESTO :=
OUT_LINKERFLAGS :=

.PHONY : all debug release clean

all: release

# debug
debug: DCFLAGS += -DTYPE=DEBUG -g
debug: DEBUG := TRUE
debug: OUT_CCFILE := ccfiled.mk
debug: LIBNAME := $(LIBNAME)d
debug: proglib

# release
release: CFLAGS += -DTYPE=RELEASE -O3 -fomit-frame-pointer
# optimizations: -msse4.2 -mavx(2) -ftree-vectorize -ffast-math OR -fassociative-math
release: DEBUG := FALSE
release: OUT_CCFILE := ccfile.mk
release: proglib

# clean
clean:
	@$(foreach platform, $(PLATFORMS), \
		rm -rf $(PREFIX)/$(platform); \
	)
	@rm -rf $(PREFIX)/$(PLATFORM)/_objects_
	@rm -rf $(PREFIX)/$(PLATFORM)/_objects_dynamic_
	@rm -rf $(PREFIX)
	
proglib:
	@echo 

	$(if $(filter none,$(PLATFORM)), $(error No platform set. Available platforms: $(PLATFORMS)) )

	@mkdir -p $(PREFIX)/$(PLATFORM)
	@rm -rf $(PREFIX)/$(PLATFORM)/$(OUT_CCFILE)

	@echo "\033[33mDetected Modules:\n\033[32m$(MODULES)" "\033[0m" "\033[0m"
	@echo "\033[33m==================================================\033[0m"

	@echo "Platform:\033[34m" $(PLATFORM)"\033[0m"
	@echo "CC:" $(CC)

	$(if $(filter FALSE,$(DEBUG)), \
		@echo "Common CFLAGS:" $(CFLAGS);, \
		@echo "Common debug CFLAGS:" $(DCFLAGS); \
	)
	$(if $(filter FALSE,$(DEBUG)), \
		@echo "Common LFLAGS:" $(LINKERFLAGS);, \
		@echo "Common debug LFLAGS:" $(DLINKERFLAGS); \
	)
	@# ccfile.mk and ccfiled.mk in platform lib directory
	@# OUT_GENERAL_LIBRARIES is general library include paths
	@# OUT_GENERAL_RESTO is general resto flags (framworks
	@# OUT_GENERAL_LINKERFLAGS is general linker flags
	@# same, per module without _GENERAL_ gets added to the var. Revise if needed
	$(if $(filter FALSE,$(DEBUG)), \
		@echo R_OUT_GENERAL_LIBRARIES += $(subst -L,-L$$(ROOTPATH),$(LIBRARIES)) >> $(PREFIX)/$(PLATFORM)/$(OUT_CCFILE); \
		echo R_OUT_GENERAL_RESTO += $(subst -L,-L$$(ROOTPATH),$(RESTO)) >> $(PREFIX)/$(PLATFORM)/$(OUT_CCFILE); \
		echo R_OUT_GENERAL_LINKERFLAGS += $(subst -L,-L$$(ROOTPATH),$(LINKERFLAGS)) >> $(PREFIX)/$(PLATFORM)/$(OUT_CCFILE); \
		, \
		@echo D_OUT_GENERAL_LIBRARIES += $(subst -L,-L$$(ROOTPATH),$(DLIBRARIES)) >> $(PREFIX)/$(PLATFORM)/$(OUT_CCFILE); \
		echo D_OUT_GENERAL_RESTO += $(subst -L,-L$$(ROOTPATH),$(DRESTO)) >> $(PREFIX)/$(PLATFORM)/$(OUT_CCFILE); \
		echo D_OUT_GENERAL_LINKERFLAGS += $(subst -L,-L$$(ROOTPATH),$(DLINKERFLAGS)) >> $(PREFIX)/$(PLATFORM)/$(OUT_CCFILE); \
	)

	@echo "Libname:" $(LIBNAME)
	@echo "PREFIX:" $(PREFIX)
	@echo "DEBUG:\033[33m" $(DEBUG)"\033[0m"
	@echo "\033[33m==================================================\033[0m"

	@# compiling static
	@$(foreach module,$(MODULES), \
		if [[ "$(DEBUG)" == "FALSE" ]]; then \
		if ! [[ -z "$(CFLAGS_$(module))" ]]; then echo "\033[33mCFLAGS:\033[0m" $(CFLAGS_$(module)); fi; \
		if ! [[ -z "$(INC_$(module))" ]]; then echo "\033[33mincludes:\033[0m" $(INC_$(module)); fi; \
		if ! [[ -z "$(LIB_$(module))" ]]; then echo "\033[33mlibraries:\033[0m" $(LIB_$(module)); fi; \
		if ! [[ -z "$(LINKER_$(module))" ]]; then echo "\033[33mlinker flags:\033[0m" $(LINKER_$(module)); fi; \
		if ! [[ -z "$(RESTO_$(module))" ]]; then echo "\033[33mresto:\033[0m" $(RESTO_$(module)); fi; \
		else \
		\
		if ! [[ -z "$(DCFLAGS_$(module))" ]]; then echo "\033[33mdebug CFLAGS:\033[0m" $(DCFLAGS_$(module)); fi; \
		if ! [[ -z "$(DINC_$(module))" ]]; then echo "\033[33mdebug includes:\033[0m" $(DINC_$(module)); fi; \
		if ! [[ -z "$(DLIB_$(module))" ]]; then echo "\033[33mdebug libraries:\033[0m" $(DLIB_$(module)); fi; \
		if ! [[ -z "$(DLINKER_$(module))" ]]; then echo "\033[33mdebug linker flags:\033[0m" $(DLINKER_$(module)); fi; \
		if ! [[ -z "$(DRESTO_$(module))" ]]; then echo "\033[33mdebug resto:\033[0m" $(DRESTO_$(module)); fi; \
		fi; \
		\
		echo "Building module:\033[32m" $(module) "\033[0m"; \
		mkdir -p $(PREFIX)/$(PLATFORM)/_objects_/$(module); \
		mkdir -p $(PREFIX)/$(PLATFORM)/_objects_dynamic_/$(module); \
		$(foreach platform, $(PLATFORMS), \
			mkdir -p $(PREFIX)/$(PLATFORM)/_objects_/$(module)/_$(platform); \
			mkdir -p $(PREFIX)/$(PLATFORM)/_objects_dynamic_/$(module)/_$(platform); \
		) \
		$(foreach cfile,$(SRC_$(module)), \
			echo 'compiling \033[33m$(cfile)\033[0m'; \
			if [[ "$(DEBUG)" == "FALSE" ]]; then \
			$(CC) $(CFLAGS) $(CFLAGS_$(module)) $(INCLUDES) $(INC_$(module)) $(LIBRARIES) $(LIB_$(module)) src/$(module)/$(cfile) -o $(PREFIX)/$(PLATFORM)/_objects_/$(module)/$(subst .c,.o,$(cfile)) $(RESTOFLAGS) $(RESTO_$(module)) $(LINKERFLAGS) $(LINKER_$(module)); \
			$(CC) $(CFLAGS) $(CFLAGS_DYNAMIC) $(CFLAGS_$(module)) $(INCLUDES) $(INC_$(module)) $(LIBRARIES) $(LIB_$(module)) src/$(module)/$(cfile) -o $(PREFIX)/$(PLATFORM)/_objects_dynamic_/$(module)/$(subst .c,.o,$(cfile)) $(RESTOFLAGS) $(RESTO_$(module)) $(LINKERFLAGS) $(LINKER_$(module)); \
			echo R_OUT_LIBRARIES += $(subst -L,-L'$$(ROOTPATH)',$(LIB_$(module))) >> $(PREFIX)/$(PLATFORM)/$(OUT_CCFILE); \
			echo R_OUT_RESTO += $(subst -L,-L'$$(ROOTPATH)',$(RESTO_$(module))) >> $(PREFIX)/$(PLATFORM)/$(OUT_CCFILE); \
			echo R_OUT_LINKERFLAGS += $(subst -L,-L'$$(ROOTPATH)',$(LINKER_$(module))) >> $(PREFIX)/$(PLATFORM)/$(OUT_CCFILE); \
			else \
			$(CC) $(DCFLAGS) $(DCFLAGS_$(module)) $(DINCLUDES) $(DINC_$(module)) $(DLIBRARIES) $(DLIB_$(module)) src/$(module)/$(cfile) -o $(PREFIX)/$(PLATFORM)/_objects_/$(module)/$(subst .c,.o,$(cfile)) $(DRESTOFLAGS) $(DRESTO_$(module)) $(DLINKERFLAGS) $(DLINKER_$(module)); \
			$(CC) $(DCFLAGS) $(DCFLAGS_DYNAMIC) $(DCFLAGS_$(module)) $(DINCLUDES) $(DINC_$(module)) $(DLIBRARIES) $(DLIB_$(module)) src/$(module)/$(cfile) -o $(PREFIX)/$(PLATFORM)/_objects_dynamic_/$(module)/$(subst .c,.o,$(cfile)) $(DRESTOFLAGS) $(DRESTO_$(module)) $(DLINKERFLAGS) $(DLINKER_$(module)); \
			echo D_OUT_LIBRARIES += $(subst -L,-L'$$(ROOTPATH)',$(DLIB_$(module))) >> $(PREFIX)/$(PLATFORM)/$(OUT_CCFILE); \
			echo D_OUT_RESTO += $(subst -L,-L'$$(ROOTPATH)',$(DRESTO_$(module))) >> $(PREFIX)/$(PLATFORM)/$(OUT_CCFILE); \
			echo D_OUT_LINKERFLAGS += $(subst -L,-L'$$(ROOTPATH)',$(DLINKER_$(module))) >> $(PREFIX)/$(PLATFORM)/$(OUT_CCFILE); \
			fi; \
		) \
		echo "Linking:\033[34m" $(module).o "\033[0m"; \
		$(LD) -r $(addprefix $(PREFIX)/$(PLATFORM)/_objects_/$(module)/,$(subst .c,.o, $(SRC_$(module)))) -o $(PREFIX)/$(PLATFORM)/_objects_/$(module).o; \
		$(LD) -r $(addprefix $(PREFIX)/$(PLATFORM)/_objects_dynamic_/$(module)/,$(subst .c,.o, $(SRC_$(module)))) -o $(PREFIX)/$(PLATFORM)/_objects_dynamic_/$(module).o; \
		echo "--------------------------------------------------"; \
	)

	@# linking/archive final static lib
	@echo "Linking:" $(addsuffix .o,$(addprefix $(PREFIX)/$(PLATFORM)/_objects_/,$(subst .c,.o, $(MODULES))));
	@ar rcs $(PREFIX)/$(PLATFORM)/lib$(LIBNAME).a $(addsuffix .o,$(addprefix $(PREFIX)/$(PLATFORM)/_objects_/,$(subst .c,.o, $(MODULES))));

	@echo "\033[33m==================================================\033[0m"

	@# linking executable
	@echo "Building executable:" $(PREFIX)/$(PLATFORM)/"\033[34m"$(LIBNAME)"\033[0m";
	@$(CC) -o $(PREFIX)/$(PLATFORM)/$(LIBNAME) $(addsuffix .o,$(addprefix $(PREFIX)/$(PLATFORM)/_objects_/,$(subst .c,.o, $(MODULES))));

	@echo "\033[33m==================================================\033[0m"

	@# linking dynamic lib
	@if [[ "$(PLATFORM)" == "osx" ]]; then \
		libtool -dynamic $(addsuffix .o,$(addprefix $(PREFIX)/$(PLATFORM)/_objects_dynamic_/,$(subst .c,.o, $(MODULES)))) -o $(PREFIX)/$(PLATFORM)/lib$(LIBNAME)-dyn.dylib -macosx_version_min 10.11 -install_name @executable_path/lib$(LIBNAME)-dyn.dylib -compatibility_version 0.0.1 -current_version 0.0.1 -undefined dynamic_lookup -flat_namespace -multiply_defined suppress; \
		echo "\033[32mDone - $(PREFIX)/$(PLATFORM)/lib$(LIBNAME)-dyn.dylib\033[0m"; \
	fi;

	@if [[ "$(DEBUG)" == "FALSE" ]]; then \
		rm -rf $(PREFIX)/$(PLATFORM)/_objects_; \
		rm -rf $(PREFIX)/$(PLATFORM)/_objects_dynamic_; \
	fi;

	@#==================================================
	@echo "\033[32mDone - $(PREFIX)/$(PLATFORM)/lib$(LIBNAME).a\033[0m"
	@echo "\033[32mDone - $(PREFIX)/$(PLATFORM)/$(LIBNAME)\033[0m"

