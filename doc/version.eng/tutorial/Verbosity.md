# Verbosity control

Changing the amount of output test information using the verbosity option.

Excessive detail of the report of test suites execution may make it difficult to find the necessary information. Conversely, when testing of a separate test routine is performed, there may not be enough information in the report. Therefore, the utility can control the amount of output information. To do this the `verbosity` option is used.

The `verbosity` option takes values from` 0` to `9`. By default, `verbosity` is set to `4`. The value `0` is the lowest level and does not display any test information. The value `9` is the highest level of verbosity and displays the maximum information about the test results. If `verbosity:1` is specified, exactly one line is displayed.

### Test object and test file

Use the test module from the tutorial about [creating a test file](HelloWorld.md). To complete the preparation, install dependencies. To do this, open a directory with files in the terminal and enter `npm install`. After installing dependencies, the module is ready for testing.

### Testing with different verbosity levels

The parameter `verbosity` is specified after the name of the test, directory or routine. Also, the option has a shortened entry form - `v`.

When the value `0` is used, the utility does not display a single line. This can be useful when only the test result is important. This result can be used by another utility or script. For example, if the test fails, the console holds a non-zero error code.

Enter the command

```
tst .imply verbosity:1 Join.test.js
```

Compare the console output with given one.

<details>
  <summary><u>Command output <code>tst .imply verbosity:1 Join.test.js</code></u></summary>

```
$ tst .imply verbosity:1 Join.test.js

  Testing ... in 0.278s ... failed

```

</details>

When command contains `verbosity:1` option, the console displays one line with an indication of how and for what time the test was passed or failed. If the utility would test the test suites group, the output would contain one line with the total result.

Increase the level of detail to `4`. To do this, run the command `tst .imply v:4 Join.test.js ` with the shortened form of the option. Compare the result with the output shown below.

<details>
  <summary><u>Command output <code>tst .imply v:4 Join.test.js</code></u></summary>

```
$ tst .imply v:4 Join.test.js

  Includes tests from : /.../testCreation/Join.test.js

  Launching several ( 1 ) test suites ..

    Running test suite ( Join ) ..
    at  /.../testCreation/Join.test.js:39

      Passed test routine ( Join / routine1 ) in 0.056s
        Test check ( Join / routine2 / fail # 2 ) ... failed
      Failed test routine ( Join / routine2 ) in 0.074s

    Passed test checks 2 / 3
    Passed test cases 1 / 2
    Passed test routines 1 / 2
    Test suite ( Join ) ... in 0.252s ... failed

  ExitCode : -1
  Passed test checks 2 / 3
  Passed test cases 1 / 2
  Passed test routines 1 / 2
  Passed test suites 0 / 1
  Testing ... in 0.344s ... failed
```

</details>

The console displays information that the test routine `routine1` successfully passed, and the test routine `routine2` failed. Also, it is indicated that the test check failed in the test case `fail` of the second test routine. The output contains the test suite report and the general report. Since only one test suite has been tested, the general report duplicates the test suite `Join` report.

Enter `tst .imply verbosity:6 Join.test.js ` command. Look at the output and compare with the below.

<details>
  <summary><u>Command output <code>tst .imply verbosity:6 Join.test.js</code></u></summary>

```
$ tst .imply verbosity:6 Join.test.js
Includes tests from : /.../testCreation/Join.test.js

Tester Settings :
{
  scenario : test,
  sanitareTime : 2000,
  fails : null,
  beeping : true,
  coloring : 1,
  timing : 1,
  rapidity : 3,
  routine : null,
  negativity : null,
  routineTimeOut : null,
  concurrent : null,
  verbosity : 6,
  silencing : null,
  shoulding : null,
  accuracy : null
}

  Launching several ( 1 ) test suites ..
  /.../testCreation/Join.test.js:39 - enabled
  1 test suite

    Running test suite ( Join ) ..
    at  /.../testCreation/Join.test.js:39

      Running test routine ( routine1 ) ..


        /.../testCreation/Join.test.js:9
            5 : //
            6 :
            7 : function routine1( test )
            8 : {
            9 :   test.identical( Join.join( 'Hello ', 'world!' ), 'Hello world!' );
        Test check ( Join / routine1 /  # 1 ) ... ok

      Passed test routine ( Join / routine1 ) in 0.091s
      Running test routine ( routine2 ) ..


        /.../testCreation/Join.test.js:18
            14 : function routine2( test )
            15 : {
            16 :
            17 :   test.case = 'pass';
            18 :   test.identical( Join.join( 1, 3 ), '13' );
        Test check ( Join / routine2 / pass # 1 ) ... ok


        - got :
          '13'
        - expected :
          13
        - difference :
          *

        /.../testCreation/Join.test.js:21
            17 :   test.case = 'pass';
            18 :   test.identical( Join.join( 1, 3 ), '13' );
            19 :
            20 :   test.case = 'fail';
            21 :   test.identical( Join.join( 1, 3 ), 13 );
        Test check ( Join / routine2 / fail # 2 ) ... failed

      Failed test routine ( Join / routine2 ) in 0.098s

    Passed test checks 2 / 3
    Passed test cases 1 / 2
    Passed test routines 1 / 2
    Test suite ( Join ) ... in 0.294s ... failed



  ExitCode : -1
  Passed test checks 2 / 3
  Passed test cases 1 / 2
  Passed test routines 1 / 2
  Passed test suites 0 / 1
  Testing ... in 0.389s ... failed
```

</details>

At the verbosity level `6`, the utility displays a section with the settings of the tester (test options) and report on a separate test check.

At the beginning of the report, all settled [test options](Help.md#Test-run-options-and-suite-options) are specified. Since the test suite has no specified test options, and the command has only `verbosity` option, all other options have the default settings.

The test report for the `ok` test includes:

- path to the test file;
- number of line with test check;
- test suite code with test check;
- result of testing.

The test report with the status `failed` additionally contains a section with description of an error. For example, in this report this section is

```
        - got :
          '13'
        - expected :
          13
        - difference :
          *
```
It indicates the difference between the received and the expected values.

Run the test routine `routine2` with the highest level of verbosity Use the `tst .imply routine:routine2 v:9 Join.test.js` command.

<details>
  <summary><u>Command output <code>tst .imply routine:routine2 v:9 Join.test.js</code></u></summary>

```
$ tst .imply routine:routine2 v:9 Join.test.js
Includes tests from : /.../testCreation/Join.test.js

Tester Settings :
{
  scenario : test,
  sanitareTime : 500,
  fails : null,
  beeping : true,
  coloring : 1,
  timing : 1,
  rapidity : 3,
  routine : routine2,
  negativity : null,
  routineTimeOut : null,
  concurrent : null,
  verbosity : 9,
  silencing : null,
  shoulding : null,
  accuracy : null
}

  Launching several ( 1 ) test suites ..
  /.../testCreation/Join.test.js:39 - enabled
  1 test suite

    Running test suite ( Join ) ..
    at  /.../testCreation/Join.test.js:39

    wTestSuite( Join#in0 )
    {
      name : 'Join',
      verbosity : 8,
      importanceOfDetails : 0,
      negativity : 1,
      silencing : null,
      shoulding : 1,
      routineTimeOut : 5000,
      concurrent : 0,
      routine : 'routine2',
      platforms : null,
      suiteFilePath : [ '/path_to_' ... 'reation/Join.test.js' ],
      suiteFileLocation : [ '/path_to_' ... 'tion/Join.test.js:39' ],
      tests : [ Map:Pure with 2 elements ],
      abstract : 0,
      enabled : 1,
      takingIntoAccount : 1,
      usingSourceCode : 1,
      ignoringTesterOptions : 0,
      accuracy : 1e-7,
      report : [ Map:Pure with 9 elements ],
      debug : 0,
      override : [ Map:Pure with 0 elements ],
      _routineCon : [ routine bound anonymous ],
      _inroutineCon : [ routine bound anonymous ],
      onRoutineBegin : [ routine onRoutineBegin ],
      onRoutineEnd : [ routine onRoutineEnd ],
      onSuiteBegin : [ routine onSuiteBegin ],
      onSuiteEnd : [ routine onSuiteEnd ]
    }
      Running test routine ( routine1 ) ..


        /.../testCreation/Join.test.js:9
            5 : //
            6 :
            7 : function routine1( test )
            8 : {
            9 :   test.identical( Join.join( 'Hello ', 'world!' ), 'Hello world!' );
        Test check ( Join / routine1 /  # 1 ) ... ok

      Passed test routine ( Join / routine1 ) in 0.066s
      Running test routine ( routine2 ) ..


        /.../testCreation/Join.test.js:18
            14 : function routine2( test )
            15 : {
            16 :
            17 :   test.case = 'pass';
            18 :   test.identical( Join.join( 1, 3 ), '13' );
        Test check ( Join / routine2 / pass # 1 ) ... ok


        - got :
          '13'
        - expected :
          13
        - difference :
          *

        /.../testCreation/Join.test.js:21
            17 :   test.case = 'pass';
            18 :   test.identical( Join.join( 1, 3 ), '13' );
            19 :
            20 :   test.case = 'fail';
            21 :   test.identical( Join.join( 1, 3 ), 13 );
        Test check ( Join / routine2 / fail # 2 ) ... failed

      Failed test routine ( Join / routine2 ) in 0.147s

    Passed test checks 1 / 2
    Passed test cases 1 / 2
    Passed test routines 0 / 1
    Test suite ( Join ) ... in 0.226s ... failed



  ExitCode : -1
  Passed test checks 1 / 2
  Passed test cases 1 / 2
  Passed test routines 0 / 1
  Passed test suites 0 / 1
  Testing ... in 0.323s ... failed
```

</details>

Test output is as detailed as possible. It includes general information about test options and additional information about the settings of the test suite `Join`.

### Test report elements displayed at different levels of verbosity

The table provides information on the details of the test report,  depending on the value of the `verbosity` option.

| Verbosity level                           | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
|-------------------------------------------|---|---|---|---|---|---|---|---|---|---|
| Single line test result                   | - | + | + | + | + | + | + | + | + | + |
| Detailed test summary                     | - | - | + | + | + | + | + | + | + | + |
| Single line summary of passing the test suite | - | - | + | + | + | + | + | + | + | + |
| Detailed summary of passing the test suite    | - | - | - | + | + | + | + | + | + | + |
| Failed test routines                      | - | - | - | + | + | + | + | + | + | + |
| Passed test routines                      | - | - | - | - | + | + | + | + | + | + |
| Failed test checks                        | - | - | - | - | + | + | + | + | + | + |
| Passed test checks                        | - | - | - | - | - | + | + | + | + | + |
| Test options                              | - | - | - | - | - | + | + | + | + | + |
| Difference between the received and the expected value                                                                                                                                                                        | - | - | - | - | - | + | + | + | + | + |
| Code of failed test check                 | - | - | - | - | - | + | + | + | + | + |
| Code of passed test check                 | - | - | - | - | - | - | + | + | + | + |
| Address of failed test check              | - | - | - | - | - | + | + | + | + | + |
| Address of passed test check              | - | - | - | - | - | - | + | + | + | + |
| Options and settings of test suite        | - | - | - | - | - | - | - | + | + | + |
| Output of a test object that is colored in console                                                                                                                                                                      | - | - | - | - | - | - | - | + | + | + |
| Output of a test routines that is colored in console                                                                                                                                                                      | - | - | - | - | - | - | - | + | + | + |

Output of test object or test routines [is highlighted in yellow](OptionSilencing.md) at the verbosity level from `7` to `9`.

### Summary

- To set the verbosity level of the test report, the `verbosity` option is used.
- The `verbosity` option takes values from` 0` to `9`.
- When `verbosity: 0` is set, not a single line is displayed.
- When `verbosity: 1` is set, exactly one line is displayed.
- By default, the `verbosity` option is set to `4`.
- When values from `5` or more are used, the utility displays a more detailed report than the regular report.
- When values from `7` are used, the output of the test object is highlighted in yellow.

[Back to content](../README.md#Tutorials)

