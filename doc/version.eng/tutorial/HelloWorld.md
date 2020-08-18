# Test suite "Hello World!"

Creating a simple test suite.

<details>
  <summary><u>Module structure</u></summary>

```
testHello
    ├── Join.js
    ├── Join.test.js    
    └── package.json
```

</details>

Create the file structure above for testing.

### Test unit

<details>
    <summary><u>Code of file <code>Join.js</code></u></summary>

```js    
module.exports.join = function( a, b )
{
  return String( a ) + String( b );
}
```

</details>

Enter the code above into the `Join.js` file.

The `join` function performs the concatenation of two strings. It is exported for use.

### Test file

The test suite `Join.test.js` has the suffix `.test` so that the testing utility could find it.

<details>
    <summary><u>Code of file <code>Join.test.js</code></u></summary>

```JavaScript    

let _ = require( 'wTesting' );
let Join = require( './Join.js' );

//

function routine1( test )
{
  test.identical( Join.join( 'Hello ', 'world!' ), 'Hello world!' );
}

//

function routine2( test )
{

  test.case = 'pass';
  test.identical( Join.join( 1, 3 ), '13' );

  test.case = 'fail';
  test.identical( Join.join( 1, 3 ), 13 );

}

//

let Self =
{
  name : 'Join',
  tests :
  {
    routine1,
    routine2,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
```

</details>

Enter the code above into the `Join.test.js` file.

<details>
    <summary><u>File <code>Join.test.js</code> as an example of test file structure</u></summary>

![join.test.png](../../images/join.test.png)

</details>

The figure shows test file structure. It consists of four main elements:
- dependency injection;
- test routines definition;
- test suite definition;
- test suite launching.

### Dependencies section

The section is intended to inject dependencies required for testing.

In the given code two dependencies are injected. The first is the `Testing` utility to perform the test. The second is a `Join.js` file with a routine for testing.

<details>
    <summary><u>Code of file <code>package.json</code></u></summary>

```json    
{
  "dependencies": {
    "wTesting": ""
  }
}
```

</details>

Enter the code below with the dependencies for testing. They are loaded by the `npm install` command in the module directory.

### Section of test routines definition

The second section is intended for definition of the test routines. A test routine is a routine (function, method) designed to test some aspect of a test unit. Test routine can include:
- initial data, definition of variables (if necessary);
- [test cases](../concept/TestCase.md);
- [test checks](../concept/TestCheck.md).

The code in lines 7-23 lists two test routines. The first, called "routine1", performs one test check for matching the received and expected values. The second test routine is called `routine2` and includes two test cases -` pass` and `fail`. The test check of test case `pass` should pass as string values are compared. At the same time, the test check of test case `fail` should not, because of the `Join.join` routine returns the string `'13'`, while it is expected the number  `13`.

The developer can place in the section the required amount of test routines to test the selected object. Each test routine can contain any number of test cases and test checks.

### Section of test suite definition

The section is intended for definition of test suite - the highest structural unit of testing. The test file should contain only one test suite.

A test suite definition should contain the test suite name and set of the test routines. References to test routines are placed in the `tests` section. Additionally, the test suite declaration may include [advanced options](../concept/TestOption.md) that control the testing process.

According to the code, the `Join.test.js` file contains the` Join` test suite. The test suite has two test routines. The test suite does not include any additional options.

### Section of test suite launching

Lines 39-41 contain functions for running the test suite.
In the 39th line, the test suite is being created. And in lines 40-41 there is its launch. Without lines 40-41, the `node Join.test.js` command won't be able to run the test file directly.

### Summary

- The utility searches for test suite files with the suffix `.test`.
- For the convenience of testing, each test suite should be contained in a separate file.
- Test file consists of four main elements: dependency injection; test routines definition; test suite definition; test suite launching.
- The developer determines the required amount of test routines, test cases and test checks.
- A test suite definition should contain the test suite name and set of the test routines.  Additionally, the test suite declaration may include advanced options.

[Back to content](../README.md#Tutorials)
