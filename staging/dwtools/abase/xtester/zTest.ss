#! /usr/bin/env node

if( typeof module !== 'undefined' )
{

  _SeparatingTester_ = 1;
  require( './aBase.debug.s' );
  _SeparatingTester_ = 0;
  wTester.exec();

}

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
  var got = _.mapExtend( null, src1, src2 );
  var expected = { a : 1, b : 2, c : 3, d : 4 };
  test.will = 'return';
  test.identical( got, expected );
  test.will = 'preserve src1';
  test.identical( src1, src1Copy );
  test.will = 'preserve src2';
  test.identical( src2, src2Copy );
  test.will = 'return not src1';
  test.is( got !== src1 );
  test.will = 'return not src2';
  test.is( got !== src2 );

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
