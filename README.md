## What is it

C project template, built on top of `make` and GNU core utils and binutils. 
Works with GCC and LLVM/Clang. Template is oriented towards building 
static and dynamic (at the same time, man!) libraries across platforms. 

This is an effort to decouple the build system out from production and 
extend it towards more general use, where you would start any C project with 
this template and use it to build a static or dynamic library or an executable. 

### Features

__Warning: Don't use this for exes, yet. Usable, but alpha alert!__

You can build static or dynamic library or even an exe out of same make, across platforms!

Main feature are modules which get compiled into their own object. 
Within each module you get automatic platform overrides: 

```
src
├── README.md
├── module_one
│   ├── _osx
│   │   ├── module.mk
│   │   └── module_one_override.c
│   ├── module.mk
│   ├── module_one.c
│   ├── module_one.h
│   ├── module_one_override.c
│   └── module_one_override.h
└── module_two
    ├── _osx
    │   └── module.mk
    ├── module.mk
    └── module_two.c
```

In this example, within `module_one`, `_osx/module_one_override.c` will override 
`module_one_override.c` from the root of `module_one`. Thus, any file that exists 
in platform subdirectory will override it's parent if they share the same name. 

In order to accomplish this, each module has to have `module.mk` file, 
and submodule (platform directories) their own module.mk. Templates for both are in 
`make_tpls`. Eventually, I'll make a shell script to scaffold directory structures. 

Through those module/submodule.mk files you can override all the compile/link/include 
flags for each module/submodule as you wish.

![alt text](https://raw.githubusercontent.com/Keyframe/c_start/master/screenshot.png)
