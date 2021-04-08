
const _ = require( 'wTesting' );

//

function routine1( test )
{
  test.identical( 1, 0 );
}

//

function routine2( test )
{
  test.identical( 1, 1 );
}

//

var Self1 =
{
  name : 'OptionFailsA2',
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
