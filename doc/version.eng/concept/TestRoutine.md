# Test routine

A test routine is a routine (function, method) designed to test some aspect of a test object. The test routine is performed sequentially and contains test checks and a test case.

The division of a test suite on the test routines should be made taking into account that the routine stops its performance at the first thrown mistake.

### Result of test routine running

The test routine is indicated as failed (red) if:

- there was an error in it;
- there was no any performed test check in it;
- at least one test check has given a negative result;
- time out of routine testing was over.

In another way, a test routine is indicated as passed (green).

### Example of test routine

![test.routine](../../images/test.routine.png)

The firure shows a section of code that contains two test routines. The first routine named `routine1` performs one test of the identity of two values. The second test routine named `routine2` has two test cases, each of which has one test check. To perform test routines they should be specified in the test suite definition.

[Return to content](../README.md#Concepts)
