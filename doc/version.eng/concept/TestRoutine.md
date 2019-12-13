# Test routine

Test routine is a routine ( function, method ) designed to test some aspect of a test unit. A test suite includes test routines, each of which is executed independently of each other. Instructions of test routines are performed sequentially and include test checks that can be combined into test cases and can have a description.

Partitioning of a test suite on the test routines should be designed, taking into account that the routine stops its performance at the first thrown mistake.

### Result of test routine running

A test routine is marked as failed ( red ) if:

- an error was thrown from it;
- there was none test check in it;
- at least one test check fails;
- time out of test routine is over.

Otherwise, a test routine is marked as passed (green).

### Example of a test routine

![test.routine](../../images/test.routine.png)

The figure shows a section of code that contains two test routines. The first routine named `routine1` performs one test of the identity of two values. The second test routine named `routine2` has two test cases, each of which has one test check. Test routines should be mentioned in the definition of the test suite to be executed.

[Back to content](../README.md#Concepts)
