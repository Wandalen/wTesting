# Testing cheat sheet

Framework for convenient unit testing. This cheat sheet summarizes commonly used Testing command line instructions and test suite structure for quick reference.

### Installation of `Testing`

To install Testing you need an installed NodeJS and NPM.

```
npm install -g wTesting
```

Global installation of utility Testing by NPM.

### Main commands

All commands of the utility start with `tst .`.

```
tst .help
```

Get help.

```
tst .help [ command ]
```

Get help on a specific command.

```
tst .suites.list [ path ]
```

 Find test suites at a specific path.

```
tst .run [ path ]
```

Run test suites found at a specified path.

```
tst .imply [ options... ] .run [ path ]
```

Change state or imply variable value.

### Running of test suites

```
tst .run [ path to single test file || path with glob || path to directory ]

node [ path to single test file ]
```

Running of single test suite.

```
tst .run [ path to directory with group of test files ]
```

Running a set of test suites. NodeJS can't test a set of test suites.

### Often used running options

To control testing the running options is used.

```
tst .imply routine:[ name ] .run [ path ]
```

Option `routine` allows test separate test routine in test suite. Accepts name of test routine. Option has shortened entry form - `r`.

```
tst .imply verbosity:[ number ] .run [ path ]
```

Option `verbosity` sets the verbosity of report, that is, the amount of output information. Option has shortened entry form - `v`. Accepts a value from 0 to 9. Default value is 4.

```
tst .imply testRoutineTimeOut:[ time ] .run [ path ]
```

Option `testRoutineTimeOut` limits the testing time for a test routine. Testing time sets in milliseconds. Default value is 5000ms.

```
tst .imply accuracy:[ number ] .run [ path ]
```

The option `accuracy` sets the numeric deviation for the comparison of numerical values. Accepts numeric values of deviation. Default value is 1e-7.

```
tst .imply sanitareTime:[ time ] .run [ path ]
```

Option `sanitareTime` sets the delay between completing the test suite and running the next one. Delay sets in milliseconds. Default value is 2000ms.

```
tst .imply importanceOfNegative:[ number ] .run [ path ]
```

It is intended to restrict the output of information of routines with the status `ok` / `pass` and to increase the amount of information about the checks with the status `failed`. Accepts a value from 0 to 9. Default value is 1.

```
tst .imply silencing:[ number ] .run [ path ]
```

Option `silencing` enables hiding the console output from the test object. Accepts 0 or 1. Default value is 0.

```
tst .imply shoulding:[ number ] .run [ path ]
```

Option `shoulding` designed to disable negative testing. Accepts 0 or 1. Default value is 0.

### Additional running options

Running options that extend control of testing.

```
tst .imply fails:[ number ] .run [ path ]
```

Option `fails` sets the number of errors that the utility must receive to pre-complete the test. Accepts number of fails. Default number of fails is unlimited.

```
tst .imply beeping:[ number ] .run [ path ]
```

Option `beeping` is intended to turn on the beep after the test is completed. Accepts 0 or 1. Default value is 1.

```
tst .imply coloring:[ number ] .run [ path ]
```

Option `coloring` designed to enable the color marking of the test report. Accepts 0 or 1. Default value is 1.

```
tst .imply timing:[ number ] .run [ path ]
```

Option `timing` intended to disable measurement of time spent on testing. Accepts 0 or 1. Default value is 1.

```
tst .imply rapidity:[ number ] .run [ path ]
```

The option `rapidity` controls the amount of time spent on testing. Test time changes if option `rapidity` of test routines has different values. Accepts values from 1 to 5. Default value is 3.

```
tst .imply  concurrent:[ number ] .run [ path ]
```

Option `concurrent` designed to enable parallel execution of test suites.
Accepts 0 or 1. Default value is 0.

### Test suite structure

The test file should contain only one test suite.
The minimum test file is given below. It uses the basic structural elements and can be considered as a test suite template.

![join.test.png](../../images/join.test.png)

### Test checks

Module Testing contains next test checks:

`is( boolLike arg )` - passes if argument is true-like.

`isNot( boolLike arg )` - passes  if argument is false-like.

`isNotError( errorLike arg )` - passes if argument is not error.

`identical( any arg1, any arg2 )` ( shortened form `il` ) - passes if both arguments are identical. The numerical deviation is not allowed.

`notIdentical( any arg1, any arg2 )` ( `ni` ) - passes if both arguments are not identical. The numerical deviation is not allowed.

`equivalent( any arg1, any arg2 )` ( `et` ) - passes if both arguments are similar. The numerical deviation is allowed.

`notEquivalent( any arg1, any arg2 )` ( `ne` ) - passes if both arguments are not similar. The numerical deviation is allowed.

`contains( any arg1, any arg2 )` - passes if the arguments are identical or the first argument contains the second argument.

`gt( numberLike arg1, numberLike arg2 )` - passes if the value of the first argument is greater than the value of the second.

`ge( numberLike arg1, numberLike arg2 )` - passes if the value of the first argument is greater or equal to the value of the second.

`lt( numberLike arg1, numberLike arg2 )` - passes if the value of the first argument is less than the value of the second.

`le( numberLike arg1, numberLike arg2 )` - passes if the value of the first argument is less or equal to the value of the second.

`mustNotThrowError( routine arg )` - passes if the routine does not throw an error either in synchronous or in asynchronous mode.

`shouldMessageOnlyOnce( routine arg )` - passes if the routine ends synchronously or the result returns only one message.

`shouldThrowErrorSync( routine arg )` - passes if the routine throws an error synchronously.

`shouldThrowErrorAsync( routine arg )` - passes if the routine throws an error in asynchronous mode.

`shouldThrowError( routine arg )` - passes if the routine throws an error in synchronous or asynchronous mode.
