# Run option

The control parameter of the testing that is passed to the run command. Run options are performed for each test suite.

The run option is specified after the utility command. For example, in the command

```
tst path/to/dir accuracy:1e-4
```

the `accuracy` option is specified, it sets the allowable numeric deviation. The specified option applies to each test suite in the `path/to/dir` directory.


Run options override test suite options. If the same option in the command and in the test code is used, then the command has a higher priority.

The command can use several run options at the same time. For example, a command with `verbosity` and` silencing` options can look like this:

```
tst path/to/dir verbosity:6 silencing:1
```

You can learn more about the list of run options by going to [tutorial](../tutorial/Help.md#Options-launch-and-options-suites).

# Test suite option

The control parameter of the testing that is specified in the test suite definition. These options override the default values, which can be overridden by the run options.

The input format of run options and test suite options is the same. The test suite options have a lower priority than the startup options. Therefore, if the test suite and the entered command have the same option, the utility uses the run option and ignores the test suite options.

![test.suite.options.png](../../images/test.suite.options.png)

The figure shows the part of the code with the test suite definition. After the name of the test suite, test options are indicated.

The test suite has three options: `silencing`,` verbosity` and `enabled`. If the same options are not specified in the test command, the test report will have a verbosity value `5`, and the report will not contain the output of the test object. When the `silencing` i` verbosity` option is specified in the command, the utility uses the value specified in the command. For example, when using the command

```
tst path/to/dir verbosity:3
```

the utility displays a report with a verbosity level `3`.

Some options are only used in the test suites. For example, the option `enabled` (underlined by red) is intended to disable the test suite from the testing. The option has two values: `0` and` 1`. `0` - the test suite is not executed, `1` - the test suite is executed. Default value is `1`.
