let _ = require( 'wTesting' );
let Math = require( './Math.s' );

//

function sumThrowError( test )
{
  test.shouldThrowErrorSync( () => Math.sum( a, 1 ) );
}

//

function mulThrowError( test )
{
  test.shouldThrowErrorSync( () => Math.mul( a, 1 ) );
}

//

function shouldBeFailed( test )
{
  test.notEquivalent( Math.mul( -1, -2 ), 3 );
}

//

let Self =
{
  name : 'Negative',
  abstract : 1,
  tests :
  {
    sumThrowError,
    mulThrowError,
    shouldBeFailed,
  }
}

//

Self = wTestSuite( Self );

