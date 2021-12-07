( function _Basic_s_()
{

'use strict';

/**
 *Framework for convenient unit testing. Aggregates module Testing. Utility Test provides the intuitive interface, simple tests structure, asynchronous code handling mechanism, colorful report, verbosity control and more. Use the module to get free of routines which can be automated.
 * @module Tools/top/test
 */

if( typeof module !== 'undefined' )
{

  if( typeof Config !== 'undefined' )
  if( Config.interpreter !== 'njs' ) /* xxx : remove after fixing starter */
  {
    // debugger;
    // return;
  }

  require( '../include/Top.s' );

}

if( typeof module !== 'undefined' )
module[ 'exports' ] = _globals_.testing.wTools;

if( !module.parent )
_realGlobal_.wTester.exec();

})();

/*

+ implement test case tracking
+ move test routine methods out of test suite
+ implement routine only as option of test suite
+ adjust verbosity levels
+ make possible switch off parents test routines : statResolvedRead : null
+ make "should/must not error" pass original messages through
  test.case = 'mustNotThrowError must return con with message';

  let con = new _.Consequence().take( '123' );
  test.mustNotThrowError( con )
  .ifNoErrorThen( function( got )
  {
    test.identical( got, '123' );
  })

+ improve inheritance
+ global search cant find test suites with inheritance
+ after the last test case of test routine description should be changed
+ test.identical( undefined,undefined ) -> strange output, replacing undefined by null!
+ test suite should not pass if 0 / 0 test checks
+ track number of thrown errors
+ global / suite / routine basis statistic tracking
+ fails issue
+ implement silencing from test suite
+ no suite/tester sanitare period if errror
+ issue if first test suite has silencing:0 and other silencing:1
+ less static information with verbosity:7, to introduce higher verbosity levels
+ when error not throwen under test.mustNotThrowError have "error was not thrown asynchronously, but expected"
+ implement scenario options.list
+ fire onSuiteEnd if user terminated process earlier
+ time measurements of testing
+ sort-cuts for command line otpions : h,r..
+ warning if command line option is strange
+ warning if test routine has unknown fields
+ warning if no test suite under path found
+ checkers ( identical, contains, equivalent ... ) should return boolean
+ routine : 'some', routine : some - should work both variants
+ switch off routine timeout if debugged

- cover error throwing in onSuiteBegin, onSuiteEnd.

- qqq : highlght call in call stack from *.test files. cover it.

- print information about case with color directive avoiding change of color state of logger

- implement support of glob path

- manual launch of test suite + global tests execution should not give extra test suite runs
- run test suite only once, even if asked several

- make onSuiteBegin, onSuiteEnd asynchronous

- tester should has its own copy of environment, even if included from test suite file

- implement caching source code reading

- use script launcher
- use multiple processes

- qqq : if timeout then print not "failed throwing error", but "failed because of time out". cover it

- implement onError field for test routine?
- implement custom handler of test routine fail?

- options to show path to test suite even if verbosity is low

- better test case text for "test routine has not thrown an error"
        Test check ( Tools/Math/Vector / comparator / trivial # 1 ) ... ok
        Test check ( Tools/Math/Vector / comparator / trivial # 2 ) ... ok
        Test check ( Tools/Math/Vector / comparator / trivial # 3 ) : test routine has not thrown an error ... ok

- Expose entityDiffExplanation's option levels via CLI.

- Tweak and cover entityDiffExplanation.

- time out in seconds maybe?

- implement running option additive:0

- reimplement options routine with multiple test suite. should pass test suites which does not have such test routine

- extend final report
  if verbosity is high user should be able to copy paste final report with no need to copy paste from aother sources
  should have name, path.. etc

- integrate with github ( special path format ) workflow to let github print annotation
-- make github marking each faile in source files similar it marks eslint errors

- node Some.test.js . -- should give help
- node Some.test.js .routines.list -- should list routines

- implement trap. opened trap make test to fail. help to cover async callbacks which potentially could be not called

- xxx : make optional name of test suite. deduce if not defined

- introduce criterions-like groups for test routines and test suites
- implement logical formulas for selecting test routines and test suites

- make most options available from both test suite and test routine

- implement logger-driven broadcasing of the report

- implement protocol for communication for multi-process run

- make possible listing test routine with options of each
-- in table formatting

*/

/*

= Simplified hierarchy of test suite with examples

- Test suite - has name, name could have slashes, for example 'Some/Test'
- Test routine - has name, obay JavaScript rules for functions naming, for example 'append'
- Test case - could be set with test.case = 'why is this test case'
- Test check - could be set with test.will = 'what is expected'

= Hierarchy of test suite

- Test suite
- Test routine
- Any number of test groups
- Test case
- Test check

= Test checks grouping

Test checks grouping is dvanced feature which let developer group several test checks and let Tester know that them are connected somehow.
Use `test.open( 'why' )` to open a new test group. Each `test.open` should have complementing `test.close` with the same argument otherwise error will be reported.
The simplest way to open a test group is using `test.case = 'why'`.
Test case is the lowest level of test group and `test.case` expects no closing, it is made implicitly, when new test case started or test routine end.

= Test checks grouping report example

```
  test.open( 'first argument is null' );

  test.case = 'trivial';
  var src1 = { a : 1, b : 2 };
  var src1Copy = { a : 1, b : 2 };
  var src2 = { c : 3, d : 4 };
  var src2Copy = { c : 3, d : 4 };
  var got = _.props.extend( null, src1, src2 );
  var expected = { a : 1, b : 2, c : 3, d : 4 };
  test.will = 'return';
  test.identical( got, expected );
  test.will = 'preserve src1';
  test.identical( src1, src1Copy );
  test.will = 'preserve src2';
  test.identical( src2, src2Copy );
  test.will = 'return not src1';
  test.true( got !== src1 );
  test.will = 'return not src2';
  test.true( got !== src2 );

  test.close( 'first argument is null' );
```

Output for `test.identical( src1, src1Copy );` will be

```
Test check ( Sample/TestGroups / mapExtend / first argument is null > trivial < preserve src1 # 2 ) ... ok
```

This report has lots of information

1. In test suite "Sample/TestGroups".
2. Exists test routine "mapExtend", in which.
3. Exists group "first argument is null", in which.
4. Exists test case "trivial", in which.
5. Test check "preserve src1" checks does src1 is preserved after call of function.
6. This test check is the second in the test routine.
7. And this check passed with no problem.

You may see that name for test case enclosed into `> trivial <`, that's how you may find it faster.
Also everyting on on the right side of " < " are not test groups.

Pefect text for `test.case` answer question "Why is this test case? What is difference between this test case and other test cases?".
Pefect text for `test.will` answer question "What is expected?".

*/