
const _ = require( 'wTesting' );

//

function trivial( test )
{
  test.identical( 1, 1 );
}

//

var Self1 =
{
  tests :
  {

    trivial,

  }
}

//

Self1 = wTestSuite( Self1 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self1.name );
