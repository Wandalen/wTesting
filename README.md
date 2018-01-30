
# wTesting [![Build Status](https://travis-ci.org/Wandalen/wTesting.svg?branch=master)](https://travis-ci.org/Wandalen/wTesting)

Tool for unit testing in Java Script. Package provides intuitive interface, simple tests structure, async code handling using [wConsequnce](https://github.com/Wandalen/wConsequence), colorful report output with multiple levels of details, running all suites from directory, supports running in browser and much more.

### Installation

For local use:

```npm install wTesting```

For global use through name `wtest` :

```npm install -g wTesting```

### Usage

#### Description

Test suite is a set of test routines in one file, each test routine is a set of test features( cases ).
Test feature is a combination of code execution and validation of obtained results, that is aimed to check some aspect of the program.

For convenience, each test feature may have own description, it can be provided through `description` field.

To get access to functionality of test package from test routine user must use first provided argument.

#### Assertions

Assertions are routines that are used in test routine to validate results of code execution.

List of mostly used assertions:

* identical - checks if two arguments are equal;
* shouldBe - checks if result of provided expression is true;
* shouldThrowError - checks if code execution throws an error;
* mustNotThrowError - checks if code execution ends without error.

#### Launch options

* verbosity - level of detail of information in the output;
* routine - name of test routine to run, other routines are ignored.

#### How to run

Locally expects path to file that contains test suite:

```node path/to/suite```

Globally expects path to folder that contains many test suites( files ), but also can work with single suite:

```wtest path/to/folder/with/suites```

With options:

```node path/to/suite verbosity : 5 routine : myTest```

### Example

```javascript
function myTest( test )
{  
  /* describe what is going to happen */
  test.description = 'info about test feature';

  /* do it and save results */
  var got = 'abc'.indexOf( 'a' );
  var expected = 0;

  /* compare result with expected */
  test.identical( got, expected );
}

/*
Map that describes test suite, contains
- name of the suite,
- map of test routines
- and other options
*/

var testSuite =
{
  name : 'name of my test suite',
  tests :
  {
      myTest : myTest
  }
}

/* Initilize test suite */
testSuite = wTestSuite( testSuite );

/* Run all tests of the suite */
wTools.Testing.test( testSuite );

```



























