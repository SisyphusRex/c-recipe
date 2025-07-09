```
.
├── bin
│   └── myprogram.out
├── build
│   ├── modules
│   │   ├── module1.o
│   │   └── module2.o
│   ├── main.o
│   └── program.o
├── include
│   ├── modules
│   │   ├── module1.h
│   │   └── module2.h 
│   └── program.h
├── src
│   ├── modules
│   │   ├── module1.c
│   │   └── module2.c
│   ├── main.c
│   └── program.c
├── test
│   ├── modules
│   │   ├── module1Test.c
│   │   └── module2Test.c
│   └── programTest.c
├── testbuild
│   ├── bin
│   │   ├── modules
│   │   │   ├── module1Test.out
│   │   │   └── module2Test.out
│   │   └── programTest.out
│   ├── objs
│   │   ├── src
│   │   │   ├── modules
│   │   │   │   ├── module1.o
│   │   │   │   └── module2.o
│   │   │   └── program.o
│   │   ├── test
│   │   │   ├── modules
│   │   │   │   ├── module1Test.o
│   │   │   │   └── module2Test.o
│   │   │   └── programTest.o
│   │   └── unity
│   │       └── unity.o
│   └── results
│       ├── modules
│       │   ├── module1Test.txt
│       │   └── module2Test.txt
│       └── programTest.txt
├── unity
│   └── src
│       ├── unity_internals.h
│       ├── unity.c
│       └── unity.h
└── makefile
```

# c-recipe
This is a recipe for making a Command Line program in C.

## what-is
It includes:
* makefile - finds src files at any depth and recreates the structure in build
* src/
   * main.c - main entry point
   * program.c - navigate menu options or parse CL args
   * ui.c - handle user input and validation
        * colors.c - print in color
        * modules directory
            * application specific functions go here
* include/
  * all header files for included .c files


## how-to
Put all of your .c in src, all of your .h in include.



Run "make myprograme.exe" to build production.
Run "make clean" to clean production build.
