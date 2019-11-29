
require( 'wTesting' );
let _ = require( 'wTools' );
_.include( 'wConsequence' );

//

function routine1( test )
{
  test.description = 'description1';
  console.log( 'v0' );
  return _.time.out( 1000, () =>
  {
    console.log( 'v1' );
    test.identical( 0, 1 );
    test.identical( 1, 1 );
    console.log( 'v2' );
  })
}

routine1.timeOut = 100;

//

var Self1 =
{
  name : 'AsyncTimeOutAsset',
  tests :
  {
    routine1,
  }
}

//

Self1 = wTestSuite( Self1 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self1.name );
