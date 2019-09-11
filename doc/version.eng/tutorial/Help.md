# Help

How to get help.

All commands of the utility start with `tst .`, so enter the command in the console and compare.

<details>
  <summary><u>Вивід команди <code>tst .</code></u></summary>

```
[user@user ~]$ tst .
Command "."
Ambiguity. Did you mean?
  .help - Get help.
  .imply - Change state or imply variable value.
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
[user@user ~]$ tst .help
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
  negativity : Increase verbosity of test checks which fails. It helps to see only fails and hide passes. Default is 9. Short-cut: "n".
  silencing : Hooking and silencing of object's of testing console output to make clean report of testing.
  shoulding : Switch on/off all should* tests checks.
  accuracy : Change default accuracy. Each test routine could have own accuracy, which cant be overwritten by this option.

```

</details>

As you can see, information about both the commands and the testing process options is displayed. For example, the `.suites.list` command prints a list of available test suites, but does not perform actual testing, and the` verbosity` option controls the verbosity level of the report.

It is possible to get help for an individual command. To do this, after typing `tst .help`, the name of the command specifies. For example, enter command `tst .help .suites.list`.

<!--
### Scenarios of utility `Testing`

A scenario is an option that defines the behavior of the utility when a command executes on files. The section `Scenarios` contains five scenarios.

##### Scenario `test`

It is executed by default if the path to the tests is entered into a command. Runs test suites in the specified directory.

The `tst path/to/dir scenario:test` command will find and run all the test suites in the` path/to/dir` directory, which is the same as `tst path/to/dir` command.

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
-->

### Test run options and suite options

The utility has options to control the testing process.

Test run options are specified when the command runs in command line interface:

```
tst .imply verbosity:7 .run
```

The verbosity of report is set to the level `7`.

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

The verbosity of report is set to the level `9`. Most run options have priority over test suite options. For this reason, in the example, the verbal level will be `7`, not` 9`.

<!--
##### Run option `scenario`

Runs the selected scenario of utility. The list and description of scenarios are given above.

Example of command: `tst .imply scenario:suites.list path/to/dir `.
-->

##### Run option `sanitareTime`

Sets the delay between completing the test suite and running the next.

The option is intended to complete the execution of tests with asynchronous functions. It is determined in milliseconds. The default value is 2000ms.

The `tst .imply sanitareTime:1000 .run path/to/dir` command runs the test in the specified directory; the delay before running the next test suite is set to one second.

##### Run option `fails`

Sets the number of errors that the utility must receive to interrupt the test.

When the specified number of errors is reached, the utility finishes testing. By default, the number of errors is not limited.

The `tst .imply fails:5 .run path/to/dir` command runs the test in the specified directory. If the test checks fail five times, then the testing will end.

##### Run option `beeping`

It is intended to turn on the beep after the test is completed.

The option has two values: 1 is enabled, 0 is off. Default value is 1.

The `tst .imply beeping:0 .run path/to/dir` command will complete the testing quietly without a beep.

##### Run option `coloring`

Desined to enable the color marking of the test report.

The option has two values: 1 is enabled, 0 is off. Default value is 1.

Example: `tst .imply coloring:0 .run path/to/dir`. The test report output will be simple, without color marking of the results.

##### Run option `timing`

It is intended to enable measurement of time spent on testing.

The option has two values: 1 is enabled, 0 is off. By default - 1.

Example: `tst .imply timing:0 .run path/to/dir`. Time data will not be available in the report after the test is completed.

##### Run option `debug`

It is intended to to disable assertion by changing default value of `Config.debug`.

The option has two values: 1 is enabled, 0 is off. By default - 1.

Example: `tst .imply debug:0 .run path/to/dir`. During testing, the assertions will be ignored.

##### Run option `rapidity`

The option controls the amount of time spent on testing. Each test routine can specify its own option `rapidity` with a value from `-9` to `+9`. By default, routine option `rapidity`  is `0`. A routine doesn't run when the value of run option `rapidity` is greater than the value of routine option `rapidity`.

The option accepts values from `-9` to `+9`: `-9` is the slowest testing, `+9` is the fastest. The default value is `0`.

The `tst .imply rapidity:-9 .run path/to/dir` command tests each test routine.

The `tst .imply rapidity:4 .run path/to/dir` command skips all test routines, which routine options `rapidity` are less than `4`.

##### Run option `testRoutineTimeOut`

The option limits the testing time for a test routine. Each test routine can have its own `timeOut`. If the test routine has its own `timeOut` then the value of the run option `testRoutineTimeOut` does not change it.

The routine is denoted as failed (red) if it has not been tested at the specified time.

Option is determined in milliseconds. The default value is 5000ms.

The `tst .imply testRoutineTimeOut:60000 .run path/to/dir` command gives each test routine without explicitly setting `timeOut` one minute to complete it.

##### Run option `concurrent`

Desined to enable parallel execution of test suites.

The utility can run more than one test suite at the same time if there are several test suites in the specified directory.

The option has two values: 1 - parallel testing is on, 0 - is disabled and testing is in turn. By default - 0.

The command `tst .imply  concurrent:1 .run path/to/dir` runs parallel execution of test suites in the` path/to/dir` directory.

##### Run option `verbosity`

Sets the verbosity of report, that is, the amount of output information.

Accepts a value from 0 to 9. When the value is set to 0, it does not display a single line. If it is set to 9, the report has a maximum of information. The default value is 4.

The test suite can have a `verbosity` option. In this case, the value set in the test suite has a priority over the run option.

The `tst .imply verbosity:5 .run path/to/dir` command prints a more detailed test report by displaying information about test checks. By default, information about the test checks is not displayed.

##### Run option `negativity`

It is intended to restrict the output of information of routines with the status `ok` / `pass` and to increase the amount of information about the checks with the status `failed`.

Accepts values from 0 to 9. By default - 1.

The `tst .imply negativity:0 .run path/to/dir` command displays the report without detailed information about the failed checks.

##### Run option `silencing`

Enables hiding the console output from the test object. The test object and the code of the test routines can have its own output. This issue may worsen the readability of the test report.

The `silencing` run option has priority over the test suite option.

The option has two values: 1 is enabled, 0 is off. By default - 0.

The `tst .imply silencing:1 .run path/to/dir` command displays a clean report without additional output of the test object.

##### Run option `shoulding`

Designed to disable negative testing. Test checks beginning with `should*` can be disabled by this option.

The option has two values: 1 is enabled, 0 is off. By default - 1.

The `tst .imply shoulding:0 .run path/to/dir` command executes the test by skipping all `should*` checks.

##### Run option `accuracy`

The option sets the numeric deviation for the comparison of numerical values.

The default value is set to `1e-7`.

The `tst .imply accuracy:1e-4 .run path/to/dir` command changes the result of the next test check:

```js
test.equivalent( 1, 1.00001 );
```

By default, this test check fails. However, the `accuracy:1e-4` run option changes the permissible deviation, and this check is passed.

### Summary

- All commands of the utility start with `tst .`.
- To get help use the `tst .` or `tst .help` command. To get help for an individual command, use the `tst .help [command]` syntax.
- To get a list of test suites, the `.suites.list` command is used.
- Run options and suites options control the testing process.
- The run options have priority over the test suites options.

[Back to content](../README.md#Tutorials)
