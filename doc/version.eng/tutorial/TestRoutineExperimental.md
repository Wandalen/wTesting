# Experimental test routine

Creation of experimental test routines ( experiments ) as a tool for research and communication between members of the development team.

The experiment is a special test routine that is not run by default. Using an experiment, the developer can incorporate non-test code into the test suite and execute it in the same testing environment.

The distance between individual team members, as well as the complexity, can impair understanding among team members. Experimental test routines are designed to improve dialogue between developers. A picture is worth a thousand words.

The experimental test routine is useful for debugging and clarifying the test unit behaviors. It is possible to place the required experimental code in the experimental routine and have it running in the same environment as an ordinary test routine. It will help another developer to find an experimental test routine and understand the first one. The fact that experiments do not affect the test report is very convenient.


### Example

For an introduction to this feature, create a test suite `Expriment.test.js` and follow the steps outlined below.

The module has one test file, `Expriment.test.js`, which contains two test routines. One of them is a typical test routine, and the other is experimental. For simplicity, we implement the testing of the standard routine `Math.sqrt`. Suppose that `Math.sqrt` is not standard, not described well, and the developer's goal is to investigate it.

<details>
<summary><u>Code of the file <code>Experiment.test.js</code></u></summary>

```js

let _ = require( `wTesting` );

//

function sqrtTest( test )
{
  test.case = `integer`;
  test.identical( Math.sqrt( 4 ), 2 );
}

//

function experiment( test )
{
  test.case = `strings`;
  test.identical( Math.sqrt( -1 ), `?` );
}
experiment.experimental = true;

//

let Self =
{
name : `Experiment`,
  tests :
  {
    sqrtTest,
    experiment,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== `undefined` && !module.parent )
wTester.test( Self.name );

```

</details>

Enter the code above into the file `Expriment.test.js`.

The routine `Math.sqrt` returns square root of a number. The test routine `sqrtTest` performs primitive testing of `Math.sqrt`.

Suppose that a developer does not have a clear understanding of exactly how `Math.sqrt` should respond to negative numbers. In this case, the developer can investigate it by writing an experiment. After the research, the developer can turn the experiment into a regular test routine or share it with team members.

The routine `experiment` is experimental. It checks an aspect of unit work that is unclear to the developer. To make the experimental test routine, set the field `experimental` of this routine to` true`.

```js
sqrtTestExperiment.experimental = true;
```

### Running

Run the test suite `Expriment.test.js`. To do this, enter the command `node Experiment.test.js` in the directory of the file.

<details>
<summary><u>Command output <code>tst .run ./Experiment.test.js</code></u></summary>

```
$ node Experiment.test.js

Running test suite ( Experiment ) ..
Located at Experiment.test.js:34
Passed TestSuite::Experiment / TestRoutine::sqrtTest in 0.031s
Passed test checks 1 / 1
Passed test cases 1 / 1
Passed test routines 1 / 1
Test suite ( Experiment ) ... in 0.601s ... ok

```

</details>

The above is a part of the test report. It shows that only one test routine `sqrtTest` was performed, even though there were two test routines. The second routine `experiment` is experimental, so it was not performed.

To execute an experimental test routine [run it explicitly](./Running.md) using the command `node Experiment.test.js r:experiment`.

<details>
<summary><u>Command output <code>tst .run ./Experiment.test.js r:sumTestExperiment</code></u></summary>

```
$ node Experiment.test.js r:experiment

Running test suite ( Experiment ) ..
Located at Experiment.test.js:34

Running TestSuite::Experiment / TestRoutine::experiment ..
- got :
NaN
- expected :
'?'

Test check ( TestSuite::Experiment / TestRoutine::experiment / strings # 1 ) ... failed
Failed TestSuite::Experiment / TestRoutine::experiment in 0.084s
Passed test checks 0 / 1
Passed test cases 0 / 1
Passed test routines 0 / 1
Test suite ( Experiment ) ... in 0.169s ... failed
```

</details>

Above is a part of the test report with experimental test routine `experiment` run. The name of the experiment was explicitly provided, so it was performed. An experiment can have any code, as well as test checks like a regular test routine. In this case, the experiment has a single test check, and it fails as `Math.sqrt( -1 )` does not return `'?'`.

### Why

The logical question arises. Why not just pass the experiment code into a separate, independent file? There are many reasons to keep an experiment in a test suite. Why putting experimental code in a separate JS file may not be the better solution?

- The experiment runs in the same environment as a regular test routine, which is not guaranteed by a standalone JS file.
- It is convenient to have all related code in one place. Experiments are often related to, and often transformed into tests.
- It's easier to turn experiment to test routine than a standalone JS file.

### Summary

- The experimental test routine is not performed unless it explicitly asked.
- To create an experiment, set the field `experimental` to `true` of the test routine.
- By default, experiments have no effect on the test report.
- The experiments are designed to facilitate interaction between the members of a development team when using common code to clarify implementation details and code behavior.
- The experimental test routine is convenient to use for experimenting.

[Back to content](../README.md#Tutorials)
