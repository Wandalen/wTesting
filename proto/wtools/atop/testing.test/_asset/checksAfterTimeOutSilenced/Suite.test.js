
require( 'wTesting' );
// const _ = require( 'wTools' );
const _ = _globals_.testing.wTools;
_.include( 'wConsequence' );

//

function routine1( test )
{
  test.description = 'description1';
  console.log( 'v0' );
  test.identical( 1, 1 );
  test.description = 'description2';

  _.time.out( 1000, () =>
  {
    console.log( 'v1' );
    test.identical( 1, 1 );
    test.equivalent( 1, 1 );
    console.log( 'v2' );
  });
  _.time.out( 2000, () =>
  {
    console.log( 'v3' );
    test.identical( 1, 1 );
    test.equivalent( 1, 1 );
    console.log( 'v4' );
  });

}

routine1.timeOut = 100;

//

function routine2( test )
{
  test.description = 'description1';
  console.log( 'v10' );
  test.identical( 1, 1 );
  return _.time.out( 2000, () =>
  {
  })
}

routine2.timeOut = 10000;

//

var Self1 =
{
  name : 'ChecksAfterTimeOutSilencedAsset',
  silencing : 1,
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
