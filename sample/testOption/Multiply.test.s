
let _ = require( 'wTesting' );
let Mul = require( './Multiply.s' );

//

function routine1( test )
{
  test.equivalent( Mul.mul( 1, 2 ), 2 );
  test.equivalent( Mul.mul( 1, -2 ), -2 );
  test.shouldThrowErrorSync( () => Mul.mul( a, 1 ) );
}
routine1.timeOut = 200

//

let Self =
{
  name : 'Multiply',
  tests :
  {
    routine1,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

