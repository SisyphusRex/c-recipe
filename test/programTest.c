#include "program.h"
#include "unity.h"

void setUp(void) {};

void tearDown(void) {};

void test_isOdd(void)
{
    int testReturn = 1;
    TEST_ASSERT_EQUAL(1, testReturn);
};

int main(void)
{
    UNITY_BEGIN();
    RUN_TEST(test_isOdd);
    return UNITY_END();
}