//let _ = require( 'wTesting' );
let Math = require( './Math.js' );

//

function sumTest( test )
{
  test.case = 'integer';
  test.equivalent( Math.sum( 1, 1 ), 2 );
  test.case = 'float';
  test.equivalent( Math.sum( 1.01, 2.21 ), 3.22 );
  test.case = 'negative';
  test.equivalent( Math.sum( -1, -2 ), -3 );
}

//

function mulTest( test )
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

var Self =
{
  name : 'Positive',
  abstract : 1,
  tests :
  {
    sumTest,
    mulTest,
    shouldBeFailed,
  }
}

//

Self = wTestSuite( Self );