let _ = require( 'wTesting' );
let Sum = require( './Sum.s' );

//

function routine1( test )
{
  test.equivalent( Sum.sum( 1, 1 ), 2.03 );
  test.equivalent( Sum.sum( 2, -1 ), 1.04 );
}
routine1.accuracy = 1e-2

//

function routine2( test )
{
  test.equivalent( Sum.sum( 1, 1 ), 2.1 );
  test.equivalent( Sum.sum( 2, -1 ), 0.9 );
}

//

let Self =
{
  name : 'Sum',
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

