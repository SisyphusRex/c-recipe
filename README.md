# c-recipe
This is a recipe for making a Command Line program in C.

## what-is
It includes:
    makefile - finds src files at any depth and recreates the structure in build  
    src directory  
        main.c - main entry point  
        program.c - navigate menu options or parse CL args  
        ui.c - handle user input and validation  
        colors.c - print in color  
        modules directory  
            application specific functions go here  
    include directory  
        all header files for included .c files  
