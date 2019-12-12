let _ = require( 'wTesting' );
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
mulTest.experimental = 1;

//

var Self =
{
  name : 'Experiment',
  tests :
  {
    sumTest,
    mulTest,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );