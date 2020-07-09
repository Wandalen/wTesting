
let _ = require( 'wTesting' );
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

var Self =
{
  name : 'Hello',
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
