## Quick start

For quick start [install](<./tutorial/Installation.md>) utility `Testing`, get acquainted [how to run](<./tutorial/Running.md>) tests and create the first test suite ["Hello World"](<./tutorial/HelloWorld.md>). Read [abstract](<./tutorial/Abstract.md>) if you are wondering what is it for and what philosophy is behind utility `Testing`.

For gentle introduction use tutorials. For getting exhaustive information on one or another aspect use list of concepts to find a concept of interest and get familiar with it.

## Concepts

<details>
  <summary><a href="./concept/TestObject.md">
    Test unit
  </a></summary>
    Test unit is a system proper functioning of which is tested.
</details>

<details>
  <summary><a href="./concept/TestSuite.md">
    Test suite
  </a></summary>
    Test suite is a set of test routines and test data for testing a test unit.
</details>

<details>
  <summary><a href="./concept/TestRoutine.md">
    Test routine
  </a></summary>
    Test routine is a routine ( function, method ) designed to test some aspect of a test unit. A test suite includes test routines, each of which is executed independently of each other. Instructions of test routines are performed sequentially and include test checks that can be combined into test cases and can have a description.
</details>

<details>
  <summary><a href="./concept/TestCheck.md">
    Test check
  </a></summary>
    Test check is a developer's expectation regarding the behavior of the test unit. Test check is expressed by some condition. It is the smallest structural unit of testing.
</details>

<details>
  <summary><a href="./concept/TestCase.md">
    Test case
  </a></summary>
 Test case or group of test checks are one or more test checks with an accompanying code combined into a logical unit to test the functionality of an aspect of a test unit.
</details>

<details>
  <summary><a href="./concept/TestCase.md">
    Group of test checks
  </a></summary>
 Test case or group of test checks is one or more test checks with an accompanying code combined into a logical unit to test the functionality of an aspect of a test unit.
</details>

<details>
  <summary><a href="./concept/TestCoverage.md">
    Test coverage
  </a></summary>
    Test coverage is a measure of software testing which is determined by the percentage of source code being tested.
</details>

<details>
  <summary><a href="./concept/TestCheck.md#Positive-testing">
    Positive testing
  </a></summary>
    It is a test to show the correct operation of the test unit under normal conditions without errors in the input data and in the normal state.
</details>

<details>
  <summary><a href="./concept/TestCheck.md#Negative-testing">
    Negative testing
  </a></summary>
    It is a test to show the correct operation of a test unit in a false input or an erroneous state.
</details>

<details>
  <summary><a href="./concept/TestOption.md#Run-option">
    Run option
  </a></summary>
    The control parameter of the testing that is passed to the run command. Run options are performed for each test suite.
</details>

<details>
  <summary><a href="./concept/TestOption.md#Test-suite-option">
    Test suite option
  </a></summary>
    The control parameter of the testing that is specified in the test suite definition. These options override the default values, and it can be overridden by the run options.
</details>

<details>
  <summary><a href="./concept/TestOption.md#Test-routine-option">
    Test routine option
  </a></summary>
    The control parameter of the testing that is specified in a separate test routine.
</details>

## Tutorials

<details>
  <summary><a href="./tutorial/Abstract.md">
    Abstract
  </a></summary>
    General information about utility Testing.
</details>

<details>
  <summary><a href="./tutorial/Installation.md">
    Installation
  </a></summary>
    Installation of utility Testing.
</details>

<details>
  <summary><a href="./tutorial/Options.md">
    Test run options and suite options
  </a></summary>
    Options to control the testing process.
</details>

<details>
  <summary><a href="./tutorial/Help.md">
    Help
  </a></summary>
    How to get help.
</details>

<details>
  <summary><a href="./tutorial/HelpSuitesList.md">
    How to get a list of test suites
  </a></summary>
    How to get information about test suites.
</details>

<details>
  <summary><a href="./tutorial/Running.md">
    Running tests
  </a></summary>
    How to run single file testing and group testing.
</details>

<details>
  <summary><a href="./tutorial/HelloWorld.md">
    Test suite "Hello World!"
  </a></summary>
    Creating a simple test suite.
</details>

<details>
  <summary><a href="./tutorial/Report.md">
    How to read a report and group test checks
  </a></summary>
    How to read a test report and group the test checks in groups and test case. How the test suite content is displayed in the report.
</details>

<details>
  <summary><a href="./tutorial/Verbosity.md">
    Verbosity control
  </a></summary>
    Changing the amount of output test information using the verbosity option.
</details>

<details>
  <summary><a href="./tutorial/TestRoutineExperimental.md">
    Experimental test routine
  </a></summary>
    Creation of experimental test routines ( experiments ) as a tool for research and communication between members of the development team.
</details>

<!--
<details>
  <summary><a href="./tutorial/SuiteInheritance.md">
    Test suite inheritance
  </a></summary>
    An example of how one test suites inherits another.
</details>

<details>
  <summary><a href="./tutorial/TestOptions.md">
    Advanced test options
  </a></summary>
    How to use advanced options to set up tests.
</details>
-->
