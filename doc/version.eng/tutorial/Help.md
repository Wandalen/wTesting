# Help

How to get help.

All commands of the utility start with `tst .`, so enter the command in the console and compare.

<details>
  <summary><u>Command output <code>tst .</code></u></summary>

```
$ tst .
Command "."
Ambiguity. Did you mean?
  .help - Get help.
  .version - Get current version.
  .imply - Change state or imply value of a variable.
  .run - Run test suites found at a specified path.
  .suites.list - Find test suites at a specified path.
```

</details>

The utility displays a short list of available commands. Enter next command for complete help

```
tst .help
```

<details>
  <summary><u>Command output <code>tst .help</code></u></summary>

```
$ tst .help
Command ".help"
Known commands
  .help - Get help.
  .version - Get current version.
  .imply - Change state or imply value of a variable.
  .run - Run test suites found at a specified path.
  .suites.list - Find test suites at a specified path.
Tester options
  verbosity : Sets the verbosity of report. Accepts a value from 0 to 9. Default value is 4.
  suite : Testing of separate test suite. Accepts name of test suite or a glob.
  routine : Testing of separate test routine. Accepts name of test routine or a glob.
  testRoutineTimeOut : Limits the testing time for test routines. Accepts time in milliseconds. Default value is 5000ms.
  onSuiteEndTimeOut : Limits the execution time for onSuiteEnd handler. Accepts time in milliseconds. Default value is 15000ms.
  accuracy : Sets the numeric deviation for the comparison of numerical values. Accepts numeric values of deviation. Default value is 1e-7.
  sanitareTime : Sets the delay between completing the test suite and running the next one. Accepts time in milliseconds. Default value is 2000ms.
  negativity : Restricts the console output of passed routines and increases output of failed test checks. Accepts a value from 0 to 9. Default value is 1.
  silencing : Enables hiding the console output from the test unit. Accepts 0 or 1. Default value is 0.
  shoulding : Disables negative testing. Accepts 0 or 1. Default value is 0.
  fails : Sets the number of errors received to interrupt the test. Accepts number of fails. By default is unlimited.
  beeping : Disables the beep after test completion. Accepts 0 or 1. Default value is 1.
  coloring : Makes report colourful. Accepts 0 or 1. Default value is 1.
  timing : Disables measurement of time spent on testing. Accepts 0 or 1. Default value is 1.
  debug : Sets value of Config.debug. Accepts 0 or 1. Default value is null, utility does not change debug mode of test unit.
  rapidity : Controls the amount of time spent on testing. Accepts values from -9 to +9. Default value is 0.
  concurrent : Enables parallel execution of test suites. Accepts 0 or 1. Default value is 0.
```

</details>

As you can see, information about both the commands and the testing process options is displayed. For example, the `.suites.list` command prints a list of available test suites, but does not perform actual testing, and the` verbosity` option controls the verbosity level of the report.

It is possible to get help for an individual command. To do this, after typing `tst .help`, the name of the command specifies. For example, enter command `tst .help .suites.list`.

### Summary

- All commands of the utility start with `tst .`.
- To get help use the `tst .` or `tst .help` command.
- To get help for an individual command, use the `tst .help [command]` syntax.
- To get a list of test suites, the `.suites.list` command is used.

[Back to content](../README.md#Tutorials)
