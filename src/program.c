#include <stdio.h>
#include "program.h"
#include "utils/ui.h"
#include "modules/mod1.h"
#include "modules/mod2.h"

int run(int argCount, char *passedArgs[])
{
    /*
    if (argCount > 0)
    {
        printf("You entered:\n");
        for (int i = 0; i < argCount; i++)
        {

            printf("%s\n", passedArgs[i]);
        }
    }
    else
    {
        printf("You entered no arguments.\n");
    }
    */

    const char *menu[] = {"Menu Choice 1", "Menu Choice 2", "Exit.", NULL};
    int running = 1;

    while (running == 1)
    {
        int userInput = PrintMenuAndGetMenuInput(menu);

        switch (userInput)
        {
        case 1:
            // Handle menu choice 1
            break;
        case 2:
            // Handle menu choice 2
            break;
        case 3:
            // Exit program
            Goodbye();
            running = 0;
            break;
        default:
            // No match.
            ErrorSwitchCase();
            return 1;
        }
    }

    return 0;
}