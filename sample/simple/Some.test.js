
let _ = require( 'wTesting' );
let a = require( './hello.js' );

//

function singleCase( test )
{
  test.identical( a.hello( 'Hello ', 'world!' ), 'Hello world!' );
}

//

function twoCases( test )
{

  test.case = 'pass';
  test.identical( a.hello( 1, 3 ), '13' );

  test.case = 'fail';
  test.identical( a.hello( 1, 3 ), 13 );

}

//

var Self =
{
  name : 'Some',
  tests :
  {
    singleCase,
    twoCases,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
