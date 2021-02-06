# Running tests

How to run single file testing and group testing.

### Downloading

The [`Tools`](<https://github.com/Wandalen/wTools>) module has a ready test suites. Use them see how the framework works. Clone the repository of the module by executing the `git clone https://github.com/Wandalen/wTools.git` command.

The module code, along with its tests, is located in the `proto` directory.

After cloning, go to the module directory and enter the command

```
npm install
```

It installs module dependencies.

To get information about available test suites, enter the command

```
tst .suites.list
```

<details>
  <summary><u>Command output <code>tst .suites.list</code></u></summary>

```
$ tst .suites.list

/.../wTools/proto/wtools/abase/l1.test/Long.test.s:19500 - enabled
/.../wTools/proto/wtools/abase/l1.test/Diagnostics.test.s:309 - enabled
/.../wTools/proto/wtools/abase/l1.test/Entity.test.s:808 - enabled
/.../wTools/proto/wtools/abase/l1.test/Map.test.s:4034 - enabled
/.../wTools/proto/wtools/abase/l1.test/Regexp.test.s:1749 - enabled
/.../wTools/proto/wtools/abase/l1.test/Routine.test.s:1558 - enabled
/.../wTools/proto/wtools/abase/l1.test/String.test.s:3887 - enabled
/.../wTools/proto/wtools/abase/l1.test/Typing.test.s:97 - enabled
/.../wTools/proto/wtools/abase/l2.test/StringTools.test.s:10462 - enabled
/.../wTools/sample/Sample.test.s:92 - enabled
10 test suites
```

</details>

According to the output, the `Tools` module has 10 test suites. In other words, it is 10 files as every single test file is assigned to the test suite. Eight of them are in `proto/wtools/abase/l1.test`, one in `proto/wtools/abase/l2.test` and one in `sample` directory.

### Testing one test suite

The testing is performed by executing the file with the test suite by interpreter `NodeJS`.

Enter the command:

```
node proto/wtools/abase/l1.test/Long.test.s
```

As a result, the test will be performed, and a report will be displayed.

<details>
  <summary><u>Command output <code>node proto/wtools/abase/l1.test/Long.test.s</code></u></summary>

```
$ node proto/wtools/abase/l1.test/Long.test.s

Running test suite ( Tools/base/l1/Long ) ..
    at  /.../wTools/proto/wtools/abase/l1.test/Long.test.s:19500

      Passed test routine ( Tools/base/l1/Long / bufferFrom ) in 0.358s
      Passed test routine ( Tools/base/l1/Long / bufferRelen ) in 0.091s
      Passed test routine ( Tools/base/l1/Long / bufferRetype ) in 0.080s
      Passed test routine ( Tools/base/l1/Long / bufferRawFrom ) in 0.118s
      Passed test routine ( Tools/base/l1/Long / bufferBytesFrom ) in 0.104s
      Passed test routine ( Tools/base/l1/Long / bufferNodeFrom ) in 0.180s
      Passed test routine ( Tools/base/l1/Long / bufferRawFromTyped ) in 0.080s
      Passed test routine ( Tools/base/l1/Long / arrayIs ) in 0.109s
      Passed test routine ( Tools/base/l1/Long / longIs ) in 0.122s

      ...

      Passed test routine ( Tools/base/l1/Long / arraySetContainAny ) in 0.608s
      Passed test routine ( Tools/base/l1/Long / arraySetIdentical ) in 0.422s

    Passed test checks 4293 / 4293
    Passed test cases 1891 / 1891
    Passed test routines 173 / 173
    Test suite ( Tools/base/l1/Long ) ... in 41.251s ... ok

Testing ... in 41.851s ... ok
```

</details>

The test unit of the suite `Long.test.s` is the` _.array*` and `_.buffer*` routines for handling arrays and buffers.

The report shows that all tests were successful: `Test suite (Tools/base/l1/Long) ... in 41.251s ... ok`. The test was completed in 42 seconds, and 173 test routines were run. During the testing, 4293 test checks were made, which were grouped by the developer in the 1891 test cases. The detail of the report depends on [the verbose level](Verbosity.md).

Duration of the first test routine `bufferFrom` is 0.358 seconds, and according to the report, it, like the rest, was passed. The passed tests in the report indicate green. Failed tests indicate red. It's enough one failed test check to consider the entire test suite has failed.

The second way is to use the `tst` command. Enter the command

```
tst .run proto/wtools/abase/l1.test/Long.test.s
```

<details>
  <summary><u>Command output <code>tst .run proto/wtools/abase/l1.test/Long.test.s</code></u></summary>

```
$ tst .run proto/wtools/abase/l1.test/Long.test.s

Running test suite ( Tools/base/l1/Long ) ..
    at  /.../wTools/proto/wtools/abase/l1.test/Long.test.s:19500

     Passed test routine ( Tools/base/l1/Long / bufferFrom ) in 0.358s
      Passed test routine ( Tools/base/l1/Long / bufferRelen ) in 0.091s
      Passed test routine ( Tools/base/l1/Long / bufferRetype ) in 0.080s
      Passed test routine ( Tools/base/l1/Long / bufferRawFrom ) in 0.118s
      Passed test routine ( Tools/base/l1/Long / bufferBytesFrom ) in 0.104s
      Passed test routine ( Tools/base/l1/Long / bufferNodeFrom ) in 0.180s
      Passed test routine ( Tools/base/l1/Long / bufferRawFromTyped ) in 0.080s
      Passed test routine ( Tools/base/l1/Long / arrayIs ) in 0.109s
      Passed test routine ( Tools/base/l1/Long / longIs ) in 0.122s

      ...

      Passed test routine ( Tools/base/l1/Long / arraySetContainAny ) in 0.608s
      Passed test routine ( Tools/base/l1/Long / arraySetIdentical ) in 0.422s

    Passed test checks 4293 / 4293
    Passed test cases 1891 / 1891
    Passed test routines 173 / 173
    Test suite ( Tools/base/l1/Long ) ... in 40.622s ... ok



Testing ... in 41.124s ... ok
```

</details>

Read the command as: find and run all tests in the `proto/wtools/abase/l1.test/Long.test.s` directory. Compare the resulting output with the previous one. The last test report is similar to the previous. The difference in time, which can range from run to run

### Comparison of command input

So, you can run the test suite by launching the 'JavaScript' file by the interpreter. To do this, after the interpreter command, type a path to the file as an argument

```
node File.test.js
```
or enter this path as an utility argument

```
tst .run File.test.js
```

### Testing one test routine

The test suite is divided into test routines that run sequentially or concurrently and independently of each other. Testing a whole test suite is not always appropriate - it takes more time than testing one test routine.

To run a separate test routine, use the option `routine`.

```
node path/to/TestSuite.js routine:someRoutine
```
or

```
tst .imply routine:someRoutine .run path/to/TestSuite.js
```

This command will run the test routine `someRoutine`  of the test suite `TestSuite.js`.

Running the test with the name of the desired test routine in the `routine` option restricts the testing to the specified test routine. The rest of the test routines do not run. The `routine` option has a shortened entry form - `r`. Also, the option can accept glob instead of full name of routine.

Run the `bufferFrom` routine of ` Long.test.s` test suite. To run the test, enter the command

```
tst .imply routine:bufferFrom .run proto/wtools/abase/l1.test/Long.test.s
```

<details>
  <summary><u>Command output <code>tst .imply routine:bufferFrom .run proto/wtools/abase/l1.test/Long.test.s</code></u></summary>

```
$ tst .imply routine:bufferFrom .run proto/wtools/abase/l1.test/Long.test.s

Running test suite ( Tools/base/l1/Long ) ..
    at  /.../wTools/proto/wtools/abase/l1.test/Long.test.s:19500

      Passed test routine ( Tools/base/l1/Long / bufferFrom ) in 0.220s

    Passed test checks 18 / 18
    Passed test cases 18 / 18
    Passed test routines 1 / 1
    Test suite ( Tools/base/l1/Long ) ... in 3.645s ... ok


  Testing ... in 5.164s ... ok
```

</details>

The report shows that only one `bufferFrom` test routine was tested. As part of this routine test, 18th test checks were successfully passed in 18 test cases.

### Group testing

Testing a set of test suites requires [globally installed](Installation.md) utility `Testing`. To run the tests specify the directory with the test files after entering `tst .run`.

Run the test in the `proto` directory by entering the command

```
tst .run proto
```

<details>
  <summary><u>Command output <code>tst .run proto</code></u></summary>

```
$ tst .run proto

    Running test suite ( Tools/base/l1/Diagnostics ) ..
    at  /.../sources/wTools/proto/wtools/abase/l1.test/Diagnostics.test.s:309

      Passed test routine ( Tools/base/l1/Diagnostics / _err ) in 0.174s
      Passed test routine ( Tools/base/l1/Diagnostics / err ) in 0.061s
      Passed test routine ( Tools/base/l1/Diagnostics / errLog ) in 0.054s
      Passed test routine ( Tools/base/l1/Diagnostics / assert ) in 0.041s
      Passed test routine ( Tools/base/l1/Diagnostics / diagnosticStack ) in 0.048s

    Passed test checks 34 / 34
    Passed test cases 30 / 30
    Passed test routines 5 / 5
    Test suite ( Tools/base/l1/Diagnostics ) ... in 1.030s ... ok

    Running test suite ( Tools/base/l1/Entity ) ..
    at  /.../sources/wTools/proto/wtools/abase/l1.test/Entity.test.s:808

      Passed test routine ( Tools/base/l1/Entity / eachSample ) in 0.070s
      Passed test routine ( Tools/base/l1/Entity / entityMap ) in 0.094s
      Passed test routine ( Tools/base/l1/Entity / entityFilter ) in 0.073s
      ...

    Passed test checks 84 / 84
    Passed test cases 80 / 80
    Passed test routines 10 / 10
    Test suite ( Tools/base/l1/Entity ) ... in 1.089s ... ok

    Running test suite ( Tools/base/l1/Long ) ..
    at  /.../sources/wTools/proto/wtools/abase/l1.test/Long.test.s:19500

      Passed test routine ( Tools/base/l1/Long / bufferFrom ) in 0.145s
      Passed test routine ( Tools/base/l1/Long / bufferRelen ) in 0.073s
      Passed test routine ( Tools/base/l1/Long / bufferRetype ) in 0.071s
      ...

    Passed test checks 4293 / 4293
    Passed test cases 1891 / 1891
    Passed test routines 173 / 173
    Test suite ( Tools/base/l1/Long ) ... in 44.598s ... ok

    Running test suite ( Tools/base/l1/Map ) ..
    at  /.../sources/wTools/proto/wtools/abase/l1.test/Map.test.s:4034

      Passed test routine ( Tools/base/l1/Map / mapIs ) in 0.062s
      Passed test routine ( Tools/base/l1/Map / mapCloneAssigning ) in 0.081s
      Passed test routine ( Tools/base/l1/Map / mapExtendConditional ) in 0.072s
      ...

    Passed test checks 686 / 686
    Passed test cases 355 / 355
    Passed test routines 45 / 45
    Test suite ( Tools/base/l1/Map ) ... in 6.329s ... ok

    Running test suite ( Tools/base/l1/Regexp ) ..
    at  /.../sources/wTools/proto/wtools/abase/l1.test/Regexp.test.s:1749

      Passed test routine ( Tools/base/l1/Regexp / regexpIdentical ) in 0.069s
      Passed test routine ( Tools/base/l1/Regexp / regexpsSources ) in 0.143s
      Passed test routine ( Tools/base/l1/Regexp / regexpsJoin ) in 0.103s
      ...

    Passed test checks 237 / 237
    Passed test cases 211 / 211
    Passed test routines 15 / 15
    Test suite ( Tools/base/l1/Regexp ) ... in 2.755s ... ok

    Running test suite ( Tools/base/l1/Routine ) ..
    at  /.../sources/wTools/proto/wtools/abase/l1.test/Routine.test.s:1558

      Passed test routine ( Tools/base/l1/Routine / _routineJoin ) in 0.084s
      Passed test routine ( Tools/base/l1/Routine / constructorJoin ) in 0.165s
      Passed test routine ( Tools/base/l1/Routine / routineJoin ) in 0.075s
      ...

    Passed test checks 259 / 259
    Passed test cases 71 / 71
    Passed test routines 9 / 9
    Test suite ( Tools/base/l1/Routine ) ... in 2.290s ... ok

    Running test suite ( Tools/base/l1/String ) ..
    at  /.../sources/wTools/proto/wtools/abase/l1.test/String.test.s:3887

      Passed test routine ( Tools/base/l1/String / strLeft ) in 0.500s
      Passed test routine ( Tools/base/l1/String / strRight ) in 0.552s
      Passed test routine ( Tools/base/l1/String / strEquivalent ) in 0.075s
      ...

    Passed test checks 714 / 714
    Passed test cases 298 / 298
    Passed test routines 19 / 19
    Test suite ( Tools/base/l1/String ) ... in 4.814s ... ok

    Running test suite ( Tools/base/l1/Typing ) ..
    at  /.../sources/wTools/proto/wtools/abase/l1.test/Typing.test.s:97

      Passed test routine ( Tools/base/l1/Typing / objectLike ) in 0.074s
      Passed test routine ( Tools/base/l1/Typing / promiseIs ) in 0.042s
      Passed test routine ( Tools/base/l1/Typing / consequenceLike ) in 0.041s

    Passed test checks 20 / 20
    Passed test cases 2 / 2
    Passed test routines 3 / 3
    Test suite ( Tools/base/l1/Typing ) ... in 0.756s ... ok

    Running test suite ( Tools/base/l2/String ) ..
    at  /.../sources/wTools/proto/wtools/abase/l2.test/StringTools.test.s:10462

      Passed test routine ( Tools/base/l2/String / strRemoveBegin ) in 0.216s
      Passed test routine ( Tools/base/l2/String / strRemoveEnd ) in 0.226s
      Passed test routine ( Tools/base/l2/String / strRemove ) in 0.204s
      ...

    Passed test checks 1311 / 1311
    Passed test cases 930 / 930
    Passed test routines 40 / 40
    Test suite ( Tools/base/l2/String ) ... in 10.201s ... ok



  Testing ... in 75.676s ... ok
```

</details>

Each test suite in the `./proto` directory, the utility has tested in turn. The report is displayed as it is ready.

A general summary of the tests is given in the last line: `Testing ... in 75.676s ... ok`. It indicates that all test suites were successful and the test was completed in 76 seconds.

To [get a list](Help.md) of test suites in the directory, use the command

```
tst .suites.list
```

### Summary

- To run the tests, use the `tst .run ./Suite.test.js` command or the `node ./Suite.test.js` command.
- It is possible to run a separate test suite, a separate test routine, or a set of test suites in the directory.
- To test a set of files, you need to install the `Testing` utility globally.
- Information about failed tests helps to find errors in the code of test unit.

[Back to content](../README.md#Tutorials)
