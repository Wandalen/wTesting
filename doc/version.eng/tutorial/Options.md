# Test run options and suite options

Options to control the testing process.

### The difference between options

Test run options are specified when the command runs in command line interface:

```
tst .imply verbosity:7 .run
```

The verbosity of report is set to the level `7`.

At the same time, the test suite options are specified in the test file, they are written as the run options:

```js
let Self =
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

#### Run option `sanitareTime`

Sets the delay between completing the test suite and running the next.

The option is intended to complete the execution of tests with asynchronous functions. It is determined in milliseconds. The default value is 2000ms.

The `tst .imply sanitareTime:1000 .run path/to/dir` command runs the test in the specified directory; the delay before running the next test suite is set to one second.

#### Run option `fails`

Sets the number of errors that the utility must receive to interrupt the test.

When the specified number of errors is reached, the utility finishes testing. By default, the number of errors is not limited.

The `tst .imply fails:5 .run path/to/dir` command runs the test in the specified directory. If the test checks fail five times, then the testing will end.

#### Run option `beeping`

It is intended to turn on the beep after the test is completed.

The option has two values: 1 is enabled, 0 is off. Default value is 1.

The `tst .imply beeping:0 .run path/to/dir` command will complete the testing quietly without a beep.

#### Run option `coloring`

Desined to enable the color marking of the test report.

The option has two values: 1 is enabled, 0 is off. Default value is 1.

Example: `tst .imply coloring:0 .run path/to/dir`. The test report output will be simple, without color marking of the results.

#### Run option `timing`

It is intended to enable measurement of time spent on testing.

The option has two values: 1 is enabled, 0 is off. By default - 1.

Example: `tst .imply timing:0 .run path/to/dir`. Time data will not be available in the report after the test is completed.

#### Run option `debug`

It is intended to to disable assertion by changing default value of `Config.debug`.

The option has two values: 1 is enabled, 0 is off. By default - null, so utility does not change `debug` mode of object of testing.

Example: `tst .imply debug:0 .run path/to/dir`. During testing, the assertions will be ignored.

#### Run option `rapidity`

The option controls the amount of time spent on testing. Each test routine can specify its own option `rapidity` with a value from `-9` to `+9`. By default, routine option `rapidity`  is `0`. A routine doesn't run when the value of run option `rapidity` is greater than the value of routine option `rapidity`.

The option accepts values from `-9` to `+9`: `-9` is the slowest testing, `+9` is the fastest. The default value is `0`.

The `tst .imply rapidity:-9 .run path/to/dir` command tests each test routine.

The `tst .imply rapidity:4 .run path/to/dir` command skips all test routines, which routine options `rapidity` are less than `4`.

#### Run option `testRoutineTimeOut`

The option limits the testing time for a test routine. Each test routine can have its own `timeOut`. If the test routine has its own `timeOut` then the value of the run option `testRoutineTimeOut` does not change it.

The routine is denoted as failed (red) if it has not been tested at the specified time.

Option is determined in milliseconds. The default value is 5000ms.

The `tst .imply testRoutineTimeOut:60000 .run path/to/dir` command gives each test routine without explicitly setting `timeOut` one minute to complete it.

#### Run option `concurrent`

Designed to enable parallel execution of test suites.

The utility can run more than one test suite at the same time if there are several test suites in the specified directory.

The option has two values: 1 - parallel testing is on, 0 - is disabled and testing is in turn. By default - 0.

The command `tst .imply  concurrent:1 .run path/to/dir` runs parallel execution of test suites in the` path/to/dir` directory.

#### Run option `verbosity`

Sets the verbosity of report, that is, the amount of output information.

Accepts a value from 0 to 9. When the value is set to 0, it does not display a single line. If it is set to 9, the report has a maximum of information. The default value is 4.

The test suite can have a `verbosity` option. In this case, the value set in the test suite has a priority over the run option.

The `tst .imply verbosity:5 .run path/to/dir` command prints a more detailed test report by displaying information about test checks. By default, information about the test checks is not displayed.

#### Run option `negativity`

It is intended to restrict the output of information of routines with the status `ok` / `pass` and to increase the amount of information about the checks with the status `failed`.

Accepts values from 0 to 9. By default - 1.

The `tst .imply negativity:0 .run path/to/dir` command displays the report without detailed information about the failed checks.

#### Run option `silencing`

Enables hiding the console output from the test unit. The test object and the code of the test routines can have its own output. This issue may worsen the readability of the test report.

The `silencing` run option has priority over the test suite option.

The option has two values: 1 is enabled, 0 is off. By default - 0.

The `tst .imply silencing:1 .run path/to/dir` command displays a clean report without additional output of the test unit.

#### Run option `shoulding`

Designed to disable negative testing. Test checks beginning with `should*` can be disabled by this option.

<!-- qqq : show example of such test check -->

The option has two values: 1 is enabled, 0 is off. By default - 1.

The `tst .imply shoulding:0 .run path/to/dir` command executes the test by skipping all `should*` checks.

#### Run option `accuracy`

The option sets the numeric deviation for the comparison of numerical values.

The default value is set to `1e-7`.

The `tst .imply accuracy:1e-4 .run path/to/dir` command changes the result of the next test check:

```js
test.equivalent( 1, 1.00001 );
```

By default, this test check fails. However, the `accuracy:1e-4` run option changes the permissible deviation, and this check is passed.

### Summary

- Run options and suites options control the testing process.
- The run options have priority over the test suites options.
- The run and suites options have the same wording.

[Back to content](../README.md#Tutorials)
