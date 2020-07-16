let _ = require( 'wTesting' );

//

function sqrtTest( test )
{
  test.case = 'integer';
  test.identical( Math.sqrt( 4 ), 2 );
}

//

function experiment( test )
{
  test.case = 'strings';
  test.identical( Math.sqrt( -1 ), '?' );
}
experiment.experimental = true;

//

let Self =
{
  name : 'Experiment',
  tests :
  {
    sqrtTest,
    experiment,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
