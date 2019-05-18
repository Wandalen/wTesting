# Test suite

A test suite is a set of test procedures and test data for testing a test object.

The test suite is contained in a separate file attached to it. The test suite consists of:

- test routins;
- test options;
- test data.

### Inheritance

Test suite can [inherit](<../tutorial/SuiteInheritance.md>) some test suite and be inherited.

### Running procedure

By default, each test routine of test suite runs in turn from first to last. The execution is consistent.

### Test suite definition in a file

![test.suite.definition](../../images/test.suite.definition.png)

The figure shows a section of code with a test suite definition. The test suite is called `Join` and has `silencing` [option](./tutorial/TestOptions.md). In this test suite, routine `routine1` is first tested and then` routine2`.

[Return to content](../README.md#Concepts)
