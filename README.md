# ** CURRENTLY UNDER REPAIR **

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
