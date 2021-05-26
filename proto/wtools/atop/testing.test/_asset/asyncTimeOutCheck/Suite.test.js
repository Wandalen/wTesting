
require( 'wTesting' );
// const _ = require( 'wTools' );
const _ = _globals_.testing.wTools;
_.include( 'wConsequence' );

//

function routine1( test )
{
  test.description = 'description1';
  console.log( 'routine1.1' );
  return _.time.out( 200, () =>
  {
    console.log( 'routine1.2' );
    test.identical( 1, 1 );
    console.log( 'routine1.3' );
  })
}

routine1.timeOut = 100;

//

function routine2( test )
{
  test.description = 'description1';
  console.log( 'routine2.1' );
  return _.time.out( 1000, () =>
  {
    console.log( 'routine2.2' );
    test.identical( 1, 1 );
    console.log( 'routine2.3' );
  })
}

routine2.timeOut = 2000;

//

var Self1 =
{
  name : 'AsyncTimeOutAsset',
  silencing : 0,
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
