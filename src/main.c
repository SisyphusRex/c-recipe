// Copyright 2025 Theodore Podewil
// GPL-3.0-or-later

/*
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 
*/

#include "program.h"
#include <stdio.h>

//
//
//  Bootstrap File
//
//

int main(int argc, char *argv[])
{

    // Check if correct number of arguments provided
    /*
    int expectedArgs = 3;
    if (argc != 3) {
        printf("Incorrect number of arguments.  Expected %d", expectedArgs);
        return 1;
    }
    */

    // Remove program call from argv
    char *passedArgs[argc - 1];
    for (int i = 0; i < argc - 1; i++)
    {
        passedArgs[i] = argv[i + 1];
    }

    // run the program
    return run(argc - 1, passedArgs);
}
