
const _ = require( 'wTesting' );

//

function routineNegativeRapidity1( test )
{
  test.identical( 1, 1 );
}
routineNegativeRapidity1.rapidity = -1;

//

function routineNegativeRapidity2( test )
{
  test.identical( 1, 1 );
}
routineNegativeRapidity2.rapidity = -2;

//

function routineNegativeRapidity3( test )
{
  test.identical( 1, 1 );
}
routineNegativeRapidity3.rapidity = -3;

//

function routineNegativeRapidity4( test )
{
  test.identical( 1, 1 );
}
routineNegativeRapidity4.rapidity = -4;

//

function routineNegativeRapidity5( test )
{
  test.identical( 1, 1 );
}
routineNegativeRapidity5.rapidity = -5;

//

function routineNegativeRapidity6( test )
{
  test.identical( 1, 1 );
}
routineNegativeRapidity6.rapidity = -6;

//

function routineNegativeRapidity7( test )
{
  test.identical( 1, 1 );
}
routineNegativeRapidity7.rapidity = -7;

//

function routineNegativeRapidity8( test )
{
  test.identical( 1, 1 );
}
routineNegativeRapidity8.rapidity = -8;

//

function routineNegativeRapidity9( test )
{
  test.identical( 1, 1 );
}
routineNegativeRapidity9.rapidity = -9;

//

function routineRapidity( test )
{
  test.identical( 1, 1 );
}

//

function routineRapidity0( test )
{
  test.identical( 1, 1 );
}
routineRapidity0.rapidity = 0;

//

function routinePositiveRapidity1( test )
{
  test.identical( 1, 1 );
}
routinePositiveRapidity1.rapidity = 1;

//

function routinePositiveRapidity2( test )
{
  test.identical( 1, 1 );
}
routinePositiveRapidity2.rapidity = 2;

//

function routinePositiveRapidity3( test )
{
  test.identical( 1, 1 );
}
routinePositiveRapidity3.rapidity = 3;

//

function routinePositiveRapidity4( test )
{
  test.identical( 1, 1 );
}
routinePositiveRapidity4.rapidity = 4;

//

function routinePositiveRapidity5( test )
{
  test.identical( 1, 1 );
}
routinePositiveRapidity5.rapidity = 5;

//

function routinePositiveRapidity6( test )
{
  test.identical( 1, 1 );
}
routinePositiveRapidity6.rapidity = 6;

//

function routinePositiveRapidity7( test )
{
  test.identical( 1, 1 );
}
routinePositiveRapidity7.rapidity = 7;

//

function routinePositiveRapidity8( test )
{
  test.identical( 1, 1 );
}
routinePositiveRapidity8.rapidity = 8;

//

function routinePositiveRapidity9( test )
{
  test.identical( 1, 1 );
}
routinePositiveRapidity9.rapidity = 9;

//

var Self1 =
{
  name : 'OptionRapidity',
  tests :
  {

    routineNegativeRapidity1,
    routineNegativeRapidity2,
    routineNegativeRapidity3,
    routineNegativeRapidity4,
    routineNegativeRapidity5,
    routineNegativeRapidity6,
    routineNegativeRapidity7,
    routineNegativeRapidity8,
    routineNegativeRapidity9,

    routineRapidity,
    routineRapidity0,

    routinePositiveRapidity1,
    routinePositiveRapidity2,
    routinePositiveRapidity3,
    routinePositiveRapidity4,
    routinePositiveRapidity5,
    routinePositiveRapidity6,
    routinePositiveRapidity7,
    routinePositiveRapidity8,
    routinePositiveRapidity9,

  }
}

//

Self1 = wTestSuite( Self1 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self1.name );
