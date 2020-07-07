let Math = require( './Math.js' );

//

function sumThrowError( test )
{
  test.shouldThrowError( () => Math.sum( a, 1 ) );
}

//

function mulThrowError( test )
{
  test.shouldThrowError( () => Math.mul( a, 1 ) );
}

//

function shouldBeFailed( test )
{
  test.notEquivalent( Math.mul( -1, -2 ), 3 );
}

//

var Self =
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
