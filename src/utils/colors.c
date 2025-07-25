// Copyright 2025 Theodore Podewil
// GPL-3.0-or-later

/*
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 
*/

#include <stdio.h>

// The style struct will contain the ANSI color codes
typedef struct Style_struct
{
    const char black[15],
        red[15],
        green[15],
        yellow[15],
        blue[15],
        magenta[15],
        cyan[15],
        white[15],
        underline[15],
        reset[15],
        clear[15];
} Style;

// Static Initialization outside of main()
Style colorStyle = {"\033[30m",       // black
                    "\033[31m",       // red
                    "\033[32m",       // green
                    "\033[33m",       // yellow
                    "\033[34m",       // blue
                    "\033[35m",       // magenta
                    "\033[36m",       // cyan
                    "\033[37m",       // white
                    "\033[4m",        // underline
                    "\033[0m",        // reset
                    "\033[H\033[2J"}; // clear

void Reset(void)
{
    printf("%s", colorStyle.reset);
}

void PrintBlack(char *message)
{
    printf("%s", colorStyle.black);
    printf("%s", message);
    Reset();
}

void PrintRed(char *message)
{
    printf("%s", colorStyle.red);
    printf("%s", message);
    Reset();
}

void PrintGreen(char *message)
{
    printf("%s", colorStyle.green);
    printf("%s", message);
    Reset();
}

void PrintYellow(char *message)
{
    printf("%s", colorStyle.yellow);
    printf("%s", message);
    Reset();
}

void PrintBlue(char *message)
{
    printf("%s", colorStyle.blue);
    printf("%s", message);
    Reset();
}

void PrintMagenta(char *message)
{
    printf("%s", colorStyle.magenta);
    printf("%s", message);
    Reset();
}

void PrintCyan(char *message)
{
    printf("%s", colorStyle.cyan);
    printf("%s", message);
    Reset();
}

void PrintWhite(char *message)
{
    printf("%s", colorStyle.white);
    printf("%s", message);
    Reset();
}

void PrintUnderline(char *message)
{
    printf("%s", colorStyle.underline);
    printf("%s", message);
    Reset();
}

void PrintClear(char *message)
{
    printf("%s", colorStyle.clear);
    printf("%s", message);
    Reset();
}
