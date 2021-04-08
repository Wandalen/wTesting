
const _ = require( 'wTesting' );
let Hello = require( './Hello.js' );

//

function routine1( test )
{
  test.identical( Hello.join( 'Hello ', 'world!' ), 'Hello world!' );
}

//

function routine2( test )
{

  test.case = 'pass';
  test.identical( Hello.join( 1, 3 ), '13' );

  test.case = 'fail';
  test.identical( Hello.join( 1, 3 ), 13 );

}

//

var Self1 =
{
  name : 'Hello1',
  // beeping : 0,
  tests :
  {
    routine1,
    routine2,
  }
}

//

var Self2 =
{
  name : 'Hello2',
  // beeping : 0,
  tests :
  {
    routine1,
    routine2,
  }
}

//

Self1 = wTestSuite( Self1 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self1.name );

Self2 = wTestSuite( Self2 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self2.name );
wTester.test( Self2.name );
