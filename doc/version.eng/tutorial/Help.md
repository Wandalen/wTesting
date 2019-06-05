# Help

How to get help.

To get help, run the utility without arguments by the command

```
tst
```

<details>
  <summary><u>Command output <code>tst</code></u></summary>

```
[user@user ~]$ tst
Scenarios :
  test : run tests, default scenario
  help : get help
  options.list : list available options
  scenarios.list : list available scenarios
  suites.list : list available suites

Tester options
  scenario : Name of scenario to launch. To get scenarios list use scenario : "scenarios.list". Try: "node Some.test.js scenario:scenarios.list"
  sanitareTime : Delay between runs of test suites and after the last to get sure nothing throwen asynchronously later.
  fails : Maximum number of fails allowed before shutting down testing.
  beeping : Make diagnosticBeep sound after testing to let developer know it's done.
  coloring : Switch on/off coloring.
  timing : Switch on/off measuing of time.
  rapidity : How rapid teststing should be done. Increasing of the option decrase number of test routine to be executed. For rigorous testing 0 or 1 should be used. 5 for the fastest. Default is 3.
  routineTimeOut : Limits the time that each test routine can use. If execution of routine takes too long time then fail will be reaported and error throwen. Default is 5000 ms.
  concurrent : Runs test suite in parallel with other test suites.
  verbosity : Level of details of report. Zero for nothing, one for single line report, nine for maximum verbosity. Default is 5. Short-cut: "v". Try: "node Some.test.js v:2"
  importanceOfNegative : Increase verbosity of test checks which fails. It helps to see only fails and hide passes. Default is 9. Short-cut: "n".
  silencing : Hooking and silencing of object's of testing console output to make clean report of testing.
  shoulding : Switch on/off all should* tests checks.
  accuracy : Change default accuracy. Each test routine could have own accuracy, which cant be overwritten by this option.

```

</details>

The help for test scenarios and test options is displayed. For example, the `suites.list` scenario prints a list of available test suites, but does not perform actual testing, and the` verbosity` option controls the verbosity level of the report.

### Scenarios of utility `Testing`

A scenario is an option that defines the behavior of the utility when executing a command on files. The section `Scenarios` contains five scenarios.

##### Scenario `test`

It is executed by default if the path to the tests is entered into a command. Runs test suites in the specified directory.

The `tst path/to/dir scenario: test` command will find and run all the test suites in the` path/to/dir` directory, which is the same as `tst path/to/dir` command.

##### Scenario `help`

It is executed by default if the path to tests is not entered into a command. Displays a list of test scenarios and test options. Does not read or write files.

The `tst scenario:help` command gives full help, which is the same as entering `tst` command without any arguments.

##### Scenario `options.list`

Displays help for utility options. Does not read or write files.

The `tst scenario:options.list` command lists all the options known to the `Testing` utility.

##### Scenario `scenarios.list`

Displays help for utility scenarios. Does not read or write files.

The `tst scenario:scenarios.list` command lists all the scenarios known to the `Testing` utility.

##### Scenario `suites.list`

Finds and prints all suites in the specified directory. Testing no runs.

The `tst path/to/dir scenario:suites.list` command lists all the test suites in the `path/to/dir` directory.

### Test run options and suite options

The utility has options to control the testing process.

Test run options are specified when the command runs in command line interface:

```
tst . verbosity:7
```

The verbosity or report is set to the level `7`.

At the same time, the test suite options are specified in the test file:

```js
var Self =
{

  name : 'TestSuiteName',
  verbosity : 9,

  tests :
  {
    routine1,
    routine2,
  }

}

wTestSuite( Self );
```

The verbosity of report is set to the level `9`. Most test run options have priority over test suite options. For this reason, in the example, the verbal level will be `7`, not` 9`.

##### Run option `scenario`

Runs the selected scenario of utility. The list and description of scenarios are given above.

Example of command: `tst path/to/dir scenario:suites.list`.

##### Run option `sanitareTime`

Sets the delay between completing the test suite and running the next.

The option is intended to complete the execution of tests with asynchronous functions. It is determined in milliseconds. The default value is 500ms.

The `tst path/to/dir sanitareTime:1000` command runs the test in the specified directory; the delay before running the next test suite is set to one second.

##### Run option `fails`

Sets the number of errors that the utility must receive to pre-complete the test.

When the specified number of errors is reached, the utility finishes testing. By default, the number of errors is not limited.

The `tst path/to/dir fails:5` command runs the test in the specified directory. If the test checks fail five times, then the testing will end.

##### Run option `beeping`

It is intended to turn on the beep after the test is completed.

The option has two values: 1 is enabled, 0 is off. Default value is 1.

The `tst path/to/dir beeping:0` command will complete the testing quietly without a beep.

##### Run option `coloring`

Desined to enable the color marking of the test report.

The option has two values: 1 is enabled, 0 is off. Default value is 1.

Example: `tst path/to/dir coloring:0`. The test report output will be simple, without color marking of the results.

##### Run option `timing`

It is intended to enable measurement of time spent on testing.

The option has two values: 1 is enabled, 0 is off. By default - 1.

Example: `tst path/to/dir timing:0`. Time data will not be available in the report after the test is completed

##### Run option `rapidity`

The option controls the amount of time spent on testing. Each test routine can specify its own option `rapidity` with a value from` 1` to `5`. By default, routine option `rapidity`  is` 3`. A routine doesn't run when the value of run option `rapidity` is greater than the value of routine option `rapidity`.

The option accepts values from 1 to 5: 1 is the slowest testing, 5 is the fastest. The default value is 3.

The `tst path/to/dir rapidity:1` command tests each test routine.

The `tst path/to/dir rapidity:4` command skips all test routines, which routine options `rapidity` are less than `4` or` 5`.

##### Run option `testRoutineTimeOut`

The option limits the testing time for a test routine. Each test routine can have its own `timeOut`. If the test routine has its own `timeOut` then the value of the run option `testRoutineTimeOut` does not change it.

The routine is denoted as failed (red) if it has not been tested at the specified time.

Option is determined in milliseconds. The default value is 5000ms.

The `tst path/to/dir testRoutineTimeOut:60000` command will give each test a routine without explicitly set` timeOut` minutes to execute it.

##### Run option `concurrent`

Desined to enable parallel execution of test suites.

The utility can run more than one test suite at the same time if there are several test suites in the specified directory.

The option has two values: 1 is on, 0 is disabled and testing is in turn. By default - 0.

The command `tst path/to/dir concurrent:1` runs parallel execution of test suites in the` path/to/dir` directory.

##### Run option `verbosity`

Sets the verbosity of report, that is, the amount of output information.

Accepts a value from 0 to 9. When the value is set to 0, it does not display a single line. If it is set to 9, the report has a maximum of information. The default value is 4.

The test suite can have a `verbosity` option. In this case, the value set in the test suite has a priority over the run option.

The `tst path/to/dir verbosity:5` command prints a more detailed test report by displaying information about test checks. By default, information about the test checks is not displayed.

##### Run option `importanceOfNegative`

It is intended to restrict the output of information of routines with the status `ok` / `pass` and to increase the amount of information about the checks with the status `failed`.

Accepts values from 0 to 9. By default - 1.

The `tst path/to/dir importanceOfNegative:0` command displays the report without detailed information about the failed checks.

##### Run option `silencing`

Enables hiding the console output from the test object. The test object and the code of the test routines can have its own output. This issue may worsen the readability of the test report. 

The `silencing` run option has priority over the test suite option.

The option has two values: 1 is enabled, 0 is off. By default - 0.

The `tst path/to/dir silencing:1` command displays a clean report without additional output of the test object.

##### Run option `shoulding`

Designed to disable negative testing. Test checks beginning with `should*` can be disabled by this option.

The option has two values: 1 is enabled, 0 is off. By default - 1.

The `tst path/to/dir shoulding:0` command executes the test by skipping all `should*` checks.

##### Run option `accuracy`

The option sets the numeric deviation for the comparison of numerical values.

The default value is set to `1e-7`.

The `tst path/to/dir accuracy:1e-4` command changes the result of the next test check:

```js
test.equivalent( 1, 1.00001 );
```

By default, this test check fails. However, the `accuracy:1e-4` run option changes the permissible deviation, and this check is passed.

### Summary

- To get help use the `help` scenario. If the utility runs without arguments or with the argument `scenario:help` the `help` scenario is executed.
- To get a list of test suites, the `suites.list` scenario is used.
- Run options and suites options control the testing process.
- The run options have priority over the test suites options.
