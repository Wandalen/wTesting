
require( 'wTesting' );
let _ = require( 'wTools' );
_.include( 'wConsequence' );

//

// function routine1( test )
// {
//   test.description = 'description1';
//   console.log( 'routine1.1' );
//   _.time.out( 2000, () => console.log( '_.time.out( 2000 )' ) );
//   return _.time.out( 1000, () =>
//   {
//     console.log( 'routine1.2' );
//     test.identical( 1, 1 );
//     console.log( 'routine1.3' );
//   })
// }

function routine1( test )
{
  let context = this;
  test.description = 'description1';
  console.log( 'routine1.1' );
  return _.time.out( context.t2 * 2, () =>
  {
    console.log( 'routine1.2' );
    test.identical( 1, 1 );
    console.log( 'routine1.3' );
  })
}

routine1.timeOut = 5000;

//

var Self1 =
{
  name : 'AsyncTimeOutAsset',
  silencing : 0,
  context : 
  {
    t2 : 5000,
  },
  tests :
  {
    routine1,
  }
}

//

Self1 = wTestSuite( Self1 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self1.name );
