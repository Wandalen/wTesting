# Test suite

Test suite is a set of test routines and test data for testing a test unit.

A test suite located in its own file. The test suite consists of:

- test routines;
- test options;
- test data.

### Inheritance

Test suite can [inherit](<../tutorial/SuiteInheritance.md>) another test suite and can be inherited.

### Running order

By default, each test routine of a test suite is executed one-by-one from the first one to the last one. The execution is sequential.

### Test suite definition in a file

![test.suite.definition](../../images/test.suite.definition.png)

The figure shows a section of code with a test suite definition. The test suite is called `Join` and has `silencing` [option](./tutorial/TestOptions.md). In this test suite, the first tested routine is `routine1` and the second and the last one is `routine2`.

[Back to content](../README.md#Concepts)
