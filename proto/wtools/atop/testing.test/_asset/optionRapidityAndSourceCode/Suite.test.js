
const _ = require( 'wTesting' );

//

function routine1( test )
{
  test.identical( 1, 1 );
}

//

function routine2( test )
{
  test.identical( 1, 1 );
}

routine2.rapidity = -1;

//

function routine3( test )
{
  test.identical( 1, 1 );
}

routine3.rapidity = -1;
routine3.usingSourceCode = true;

//

var Self1 =
{
  name : 'optionRapidityAndSourceCode',
  tests :
  {

    routine1,
    routine2,
    routine3,

  }
}

//

Self1 = wTestSuite( Self1 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self1.name );
