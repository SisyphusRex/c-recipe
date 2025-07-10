# UNDER CONSTRUCTION: 
The test build makefile requires the compiler to handle .d (depends) files.  Without this support, src files cannot include header files from other parts of the project.  
I could include ALL header files from the include directory as dependencies for ALL src files, but that defeats the purpose of make and reducing build time.  I am currently in the process of rebuilding gcc on my machine to enable gdc support.
# c-recipe
This is a recipe for making a Command Line program in C.  Builds are handled by Make and unit testing is handled by Unity.

## What's Included  
1. Basic File Structure
2. main.c
   * entry point into program
3. program.c
   * menu/command line logic here
4. colors.c
   * allows printing to terminal in color
5. ui.c
   * handles all printing to terminal and input validation
4. unity
   * src files for unity unit test framework
5. makefile
   * makes production and test builds separately
   * recursively locates src files and recreates file structure

## File Structure
The makefile is dynamic and allows you to create subdirectories in your project folders.  The file structure of your src directory must be repeated in your include and test directory.  
Make will recreate your structure automatically in the build directories.  
Please see the following example of the file structure:  
```
.
├── bin
│   └── myprogram.out
├── build
│   ├── modules
│   │   ├── module1.o
│   │   └── module2.o
│   ├── utils
│   │   ├── colors.o
│   │   └── ui.o
│   ├── main.o
│   └── program.o
├── include
│   ├── modules
│   │   ├── module1.h
│   │   └── module2.h 
│   ├── utils
│   │   ├── colors.h
│   │   └── ui.h
│   └── program.h
├── src
│   ├── modules
│   │   ├── module1.c
│   │   └── module2.c
│   ├── utils
│   │   ├── colors.c
│   │   └── ui.c
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
│   │   │   ├── utils
│   │   │   │   ├── colors.o
│   │   │   │   └── ui.o
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

## main.c
Entry point into the program.  Essentially the bootstrap file.  
If your program takes command line arguments, this file strips the program call from the arguments and passes the remainder to program.c

## program.c
This is where the driving logic, the menu structure, the meat, of your program lies.  You handle the command line arguments here or you use switch case and invoke ui.c to handle menu choices.
