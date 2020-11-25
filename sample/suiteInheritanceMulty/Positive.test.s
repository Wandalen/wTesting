let _ = require( 'wTesting' );
let Math = require( './Math.s' );

//

function sum( test )
{
  test.case = 'integer';
  test.equivalent( Math.sum( 1, 1 ), 2 );

  test.case = 'float';
  test.equivalent( Math.sum( 1.01, 2.21 ), 3.22 );

  test.case = 'negative';
  test.equivalent( Math.sum( -1, -2 ), -3 );
}

//

function mul( test )
{
  test.case = 'integer';
  test.equivalent( Math.mul( 1, 1 ), 1 );

  test.case = 'float';
  test.equivalent( Math.mul( 2.5, 2.5 ), 6.25 );

  test.case = 'negative';
  test.equivalent( Math.mul( -1, -2 ), 2 );
}

//

function shouldBeFailed( test )
{
  test.equivalent( Math.mul( -1, -2 ), 3 );
}

//

let Self =
{
  name : 'Positive',
  abstract : 1,
  tests :
  {
    sum,
    mul,
    shouldBeFailed,
  }
}

//

Self = wTestSuite( Self );

