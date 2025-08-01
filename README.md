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
├── build
│   ├── bin
│   │   └── myprogram.out
│   └── objs
│   │   ├── modules
│   │   │   ├── module1.o
│   │   │   └── module2.o
│   │   ├── utils
│   │   │   ├── colors.o
│   │   │   └── ui.o
│   │   ├── main.o
│   │   └── program.o
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

## colors.c
Contains functions for printing to the terminal in different colors.

## ui.c
The primary function is PrintMenuAndGetMenuInput().  It does exactly what it says.  You pass an array of strings (the last element must be NULL) and the function prints them out as menu options, waits for user input, validates input, and returns an integer representing the user's choice (choices start at 1, not 0).

## unity
This is the unit testing framework.  The best resource is:  
https://github.com/ThrowTheSwitch/Unity

## makefile
The makefile controls both the production and the test build.  It accounts for directories and subdirectories in your src and test folders.  Be mindful! You must maintain your directory structure from src/ to include/ and test/ for make to find the files it needs.  
The makefile accounts for your src files referencing functions from other files.  It also autogenerates dependencies based on the #include section of your files.  
The ONLY thing that you must change in the makefile is to update your program name on line 1.  
### makefile Usage
1. make production
   * builds production executable
2. make test
   * builds all tests and reports findings
3. make clean
   * removes build/ and testbuild/ directories
   * for granular removal, run make cleanproduction or make cleantest
  

_______________________________________________________________________________________________________________________________________________________________________________________________
Copyright 2025 Theodore Podewil  
GPL-3.0-or-later

/*
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 
*/
