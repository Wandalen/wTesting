# Testing cheat sheet

Framework for convenient unit testing. Utility Testing provides the intuitive interface, simple tests structure, asynchronous code handling mechanism, colorful report, verbosity control and more. This cheat sheet summarizes commonly used Testing command line instructions for quick reference.

### Installation of `Testing`

To install Testing you need an installed Node.js® and Node package manager ( NPM ). If you do not have it then download the version for your operating system from [official site](<https://nodejs.org/en/>) and follow the [installation instructions](https://nodejs.org/en/download/package-manager/).

```
npm install -g wTesting
```

Globally installing of utility Testing by NPM.

Official repository of utility:

```
https://github.com/Wandalen/wTesting.git
```

### Main commands

All commands of the utility start with `tst .`.

```
tst .help
```

Get help.

```
tst .suites.list [ path ]
```

Find test suites at a specified path.

```
tst .run [ path ]
```

Run test suites found at a specified path.


```
tst .imply [ options... ] .run [ directory ]
```

Change state or imply variable value.

### Running of test suites, test routines

```
tst .run [ path to single test file ]
```

Running of single test suite.

```
node [ path to single test file ]
```

If module Testing installed locally, you can run test suite by NodeJS interpreter.

```
tst .run [ path to directory with group of test files ]
```

Running group of test suites. NodeJS can't run group of test suites.

### Mostly used running options

To control testing process the running options is used.

```
tst .imply routine:[ name ] .run path/to/dir
```

Option `routine` allows test separate test routine in test suite. Accepts name of test routine. Option has shortened entry form - `r`.

```
tst .imply verbosity:[ number ] .run path/to/dir
```

Option `verbosity` sets the verbosity of report, that is, the amount of output information. Option has shortened entry form - `r`. Accepts a value from 0 to 9. Default value is 4.

```
tst .imply testRoutineTimeOut:[ time ] .run path/to/dir
```

Option `testRoutineTimeOut` limits the testing time for a test routine. Testing time sets in milliseconds. Default value is 5000ms.

```
tst .imply accuracy:[ number ] .run path/to/dir
```

The option `accuracy` sets the numeric deviation for the comparison of numerical values. Accepts numeric values of deviation. Default value is 1e-7.

```
tst .imply sanitareTime:[ time ] .run path/to/dir
```

Option `sanitareTime` sets the delay between completing the test suite and running the next one. Delay sets in milliseconds. Default value is 500ms.

```
tst .imply importanceOfNegative:[ number ] .run path/to/dir
```

It is intended to restrict the output of information of routines with the status `ok` / `pass` and to increase the amount of information about the checks with the status `failed`. Accepts a value from 0 to 9. Default value is 1.

```
tst .imply silencing:[ number ] .run path/to/dir
```

Option `silencing` enables hiding the console output from the test object. Accepts 0 or 1. Default value is 0.

```
tst .imply shoulding:[ number ] .run path/to/dir
```

Option `shoulding` designed to disable negative testing. Accepts 0 or 1. Default value is 0.

### Other running options

```
tst .imply fails:[ number ] .run path/to/dir
```

Option `fails` sets the number of errors that the utility must receive to pre-complete the test. Accepts number of fails. Default number of fails is unlimited.

```
tst .imply beeping:[ number ] .run path/to/dir
```

Option `beeping` is intended to turn on the beep after the test is completed. Accepts 0 or 1. Default value is 1.

```
tst .imply coloring:[ number ] .run path/to/dir
```

Option `coloring` desined to enable the color marking of the test report. Accepts 0 or 1. Default value is 1.

```
tst .imply timing:[ number ] .run path/to/dir
```

Option `timing` intended to enable measurement of time spent on testing. Accepts 0 or 1. Default value is 1.

```
tst .imply rapidity:[ number ] .run path/to/dir
```

The option `rapidity` controls the amount of time spent on testing. Test time changes if option `rapidity` of test routines has different values. Accepts values from 1 to 5. Default value is 3.

```
tst .imply  concurrent:[ number ] .run path/to/dir
```

Option `concurrent` desined to enable parallel execution of test suites.
Accepts 0 or 1. Default value is 0.
