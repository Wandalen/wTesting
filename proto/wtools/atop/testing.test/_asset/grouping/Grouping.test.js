
const _ = require( 'wTesting' );
let Hello = require( './Hello.js' );

//

function routine1( test )
{

  test.open( 'string' );

  test.case = 'trivial';
  test.identical( Hello.join( 'a', 'b' ), 'ab' );

  test.case = 'empty';
  test.identical( Hello.join( '', '' ), '' );

  test.close( 'string' );

  /* - */

  test.open( 'number' );

  test.case = 'trivial';
  test.identical( Hello.join( 1, 3 ), '13' );

  test.case = 'zeroes';
  test.identical( Hello.join( 0, 0 ), '00' );

  test.close( 'number' );

}

//

const Proto =
{
  name : 'Hello',
  tests :
  {
    routine1,
  }
}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
