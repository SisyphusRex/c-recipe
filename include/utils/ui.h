#ifndef UI_H
#define UI_H

int PrintMenuAndGetMenuInput(const char *menu[]);
int CountMenuItems(const char *menu[]);
void PrintInputRequestAndGetMenuInput(char *userInput);
void PrintMenu(int numberOfMenuItems, const char *menu[]);
void GetInput(char *userInput);
void PrintInputRequest(void);
int ValidateMenuInput(char *userInput, int numberOfMenuItems);
int ValidateIsInt(char *userInput);
int ValidateIsPositiveInt(int convertedInput);
int ValidateIsInMenu(int convertedInput, int numberOfMenuItems);
int PrintPromptGetNaturalNumber(char *prompt);
int ValidateNaturalNumberInput(char *userInput);
void PrintIntegerArray(int inputArray[], int numberOfElements);
void ErrorNotInt(void);
void ErrorNotPositiveInt(void);
void ErrorNotInMenu(void);
void ErrorSwitchCase(void);
void Goodbye(void);

#endif