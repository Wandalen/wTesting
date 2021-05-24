
const _ = require( 'wTesting' );

//

function routine1( test )
{
}

//

var Self1 =
{
  name : 'NoTestCheckAsset',
  tests :
  {
    routine1,
  }
}

//

Self1 = wTestSuite( Self1 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self1.name );
