#include "program.h"
#include "unity.h"

void setUp(void) {};

void tearDown(void) {};

void test_(void) {

};

int main(void)
{
    UNITY_BEGIN();
    RUN_TEST(test_);
    return UNITY_END();
}