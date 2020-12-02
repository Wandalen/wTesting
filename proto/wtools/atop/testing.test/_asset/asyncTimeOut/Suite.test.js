
require( 'wTesting' );
let _ = require( 'wTools' );
_.include( 'wConsequence' );

//

function routine1( test )
{
  test.description = 'description1';
  console.log( 'routine1.1' );
  _.time.out( 2000, () => console.log( '_.time.out( 2000 )' ) );
  return _.time.out( 1000, () =>
  {
    console.log( 'routine1.2' );
    test.identical( 1, 1 );
    console.log( 'routine1.3' );
  })
}

routine1.timeOut = 500;

//

var Self1 =
{
  name : 'AsyncTimeOutAsset',
  silencing : 0,
  tests :
  {
    routine1,
  }
}

//

Self1 = wTestSuite( Self1 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self1.name );
