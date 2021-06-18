
const _ = require( 'wTesting' );

//

function open( test )
{
  test.identical( 1, 1 );
}

//

function openExperimental( test )
{
  test.identical( 1, 1 );
}

openExperimental.experimental = 1;

//

function build( test )
{
  test.identical( 1, 1 );
}

//

function buildExperimental( test )
{
  test.identical( 1, 1 );
}

buildExperimental.experimental = 1;

//

var Self1 =
{
  name : 'RunExperimentalRoutines',
  tests :
  {

    open,
    openExperimental,
    build,
    buildExperimental,

  }
}

//

Self1 = wTestSuite( Self1 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self1.name );
