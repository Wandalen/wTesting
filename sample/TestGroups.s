
if( typeof module !== 'undefined' )
require( 'wTesting' );
let _ = _globals_.testing.wTools;

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

//

function mapExtend( test )
{

  /* */

  test.open( 'first argument is null' );

  test.case = 'trivial'; /* */
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
  test.true( got !== src1 );
  test.will = 'return not src2';
  test.true( got !== src2 );

  test.case = 'rewriting'; /* */
  var src1 = { a : 1, b : 2 };
  var src1Copy = { a : 1, b : 2 };
  var src2 = { b : 22, c : 3, d : 4 };
  var src2Copy = { b : 22, c : 3, d : 4 };
  var got = _.mapExtend( null, src1, src2 );
  var expected = { a : 1, b : 22, c : 3, d : 4 };
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

  /* */

  test.open( 'first argument is dst' );

  test.case = 'trivial'; /* */
  var dst = { a : 1, b : 2 };
  var src2 = { c : 3, d : 4 };
  var src2Copy = { c : 3, d : 4 };
  var got = _.mapExtend( dst, src2 );
  var expected = { a : 1, b : 2, c : 3, d : 4 };
  test.will = 'return';
  test.identical( got, expected );
  test.will = 'preserve src2';
  test.identical( src2, src2Copy );
  test.will = 'return dst';
  test.true( got === dst );
  test.will = 'return not src2';
  test.true( got !== src2 );

  test.case = 'rewriting'; /* */
  var dst = { a : 1, b : 2 };
  var src2 = { b : 22, c : 3, d : 4 };
  var src2Copy = { b : 22, c : 3, d : 4 };
  var got = _.mapExtend( dst, src2 );
  var expected = { a : 1, b : 22, c : 3, d : 4 };
  test.will = 'return';
  test.identical( got, expected );
  test.will = 'preserve src2';
  test.identical( src2, src2Copy );
  test.will = 'return not dst';
  test.true( got === dst );
  test.will = 'return not src2';
  test.true( got !== src2 );

  test.close( 'first argument is dst' );

  /* */

/* Expecte output :

Running test routine ( mapExtend ) ..
  Test check ( Sample/TestGroups / mapExtend / first argument is null > trivial < return # 1 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / first argument is null > trivial < preserve src1 # 2 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / first argument is null > trivial < preserve src2 # 3 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / first argument is null > trivial < return not src1 # 4 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / first argument is null > trivial < return not src2 # 5 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / first argument is null > rewriting < return # 6 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / first argument is null > rewriting < preserve src1 # 7 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / first argument is null > rewriting < preserve src2 # 8 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / first argument is null > rewriting < return not src1 # 9 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / first argument is null > rewriting < return not src2 # 10 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / first argument is dst > trivial < return # 11 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / first argument is dst > trivial < preserve src2 # 12 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / first argument is dst > trivial < return dst # 13 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / first argument is dst > trivial < return not src2 # 14 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / first argument is dst > rewriting < return # 15 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / first argument is dst > rewriting < preserve src2 # 16 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / first argument is dst > rewriting < return not dst # 17 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / first argument is dst > rewriting < return not src2 # 18 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / trivial, first argument < return not src2 # 19 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / trivial, first argument < return not src2 # 20 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / trivial, first argument < return not src2 # 21 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / trivial, first argument < return not src2 # 22 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / complex, first argument is null < return not src2 # 23 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / complex, first argument is null < return not src2 # 24 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / complex, first argument is null < return not src2 # 25 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / complex, first argument is null < return not src2 # 26 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / complex, first argument is null < return not src2 # 27 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / complex, first argument is null < return not src2 # 28 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / complex, first argument is null < return not src2 # 29 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / complex, first argument is not null < return not src2 # 30 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / complex, first argument is not null < return not src2 # 31 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / complex, first argument is not null < return not src2 # 32 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / complex, first argument is not null < return not src2 # 33 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / complex, first argument is not null < return not src2 # 34 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / complex, first argument is not null < return not src2 # 35 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / extend pure map by empty strings, first argument is null < return not src2 # 36 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / extend pure map by empty strings, first argument is null < return not src2 # 37 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / extend pure map by empty strings, first argument is null < return not src2 # 38 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / extend pure map by empty strings, first argument is null < return not src2 # 39 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / extend pure map by empty strings, first argument is null < return not src2 # 40 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / extend pure map by empty strings, first argument is not null < return not src2 # 41 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / extend pure map by empty strings, first argument is not null < return not src2 # 42 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / extend pure map by empty strings, first argument is not null < return not src2 # 43 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / extend pure map by empty strings, first argument is not null < return not src2 # 44 ) : expected true ... ok
  Test check ( Sample/TestGroups / mapExtend / object like array < return not src2 # 45 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / extend complex map by complex map < return not src2 # 46 ) ... ok
  Test check ( Sample/TestGroups / mapExtend / extend complex map by complex map < return not src2 # 47 ) : expected true ... ok
  Error throwen synchronously
  Test check ( Sample/TestGroups / mapExtend / no argument < return not src2 # 48 ) : error thrown synchronously as expected ... ok
  Error throwen synchronously
  Test check ( Sample/TestGroups / mapExtend / few arguments < return not src2 # 49 ) : error thrown synchronously as expected ... ok
  Error throwen synchronously
  Test check ( Sample/TestGroups / mapExtend / wrong type of array < return not src2 # 50 ) : error thrown synchronously as expected ... ok
  Error throwen synchronously
  Test check ( Sample/TestGroups / mapExtend / wrong type of number < return not src2 # 51 ) : error thrown synchronously as expected ... ok
  Error throwen synchronously
  Test check ( Sample/TestGroups / mapExtend / wrong type of boolean < return not src2 # 52 ) : error thrown synchronously as expected ... ok
  Error throwen synchronously
  Test check ( Sample/TestGroups / mapExtend / first argument is wrong < return not src2 # 53 ) : error thrown synchronously as expected ... ok
  Test check ( Sample/TestGroups / mapExtend / first argument is wrong # 54 ) : test routine has not thrown an error ... ok
Passed test routine ( Sample/TestGroups / mapExtend ) in 0.131s

*/

}

//

let Self =
{

  name : 'Sample/TestGroups',
  silencing : 1,
  verbosity : 4,

  tests :
  {

    mapExtend : mapExtend,

  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
