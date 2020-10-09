let _ = require( 'wTesting' );

//

function sum( a, b )
{
  return a + b;
};

//

function sumTest( test )
{
  test.case = 'integer';
  test.equivalent( sum( 1, 1 ), 2 );
  test.case = 'float';
  test.equivalent( sum( 1.01, 2.21 ), 3.22 );
  test.case = 'negative';
  test.equivalent( sum( -1, -2 ), -3 );
}

//

function sumTestExperiment( test )
{
  test.case = 'strings';
  test.equivalent( sum( 'a', 'b' ), NaN );
}
sumTestExperiment.experimental = 1;

//

let Self =
{
  name : 'Experiment',
  tests :
  {
    sumTest,
    sumTestExperiment,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

