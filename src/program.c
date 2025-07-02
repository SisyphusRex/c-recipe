#include <stdio.h>
#include "program.h"
#include "ui.h"
#include "modules/module1.h"
#include "modules/module2.h"

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

    const char *menu[] = {"Menu Option 1", "Menu Option 2", "Exit.", NULL};
    int running = 1;

    while (running == 1)
    {
        int userInput = PrintMenuAndGetMenuInput(menu);

        switch (userInput)
        {
        case 1:

            break;
        case 2:

            break;
        case 3:
            // Exit program
            Goodbye();
            return 0;
        default:
            // No match.
            ErrorSwitchCase();
            return 1;
        }
    }

    return 0;
}