
const _ = require( 'wTesting' );

//

let accuracy1 = _.accuracy*_.accuracy;
let accuracy2 = _.accuracy*1e-1;
let accuracy3 = _.accuracy*10;
let accuracy4 = Math.sqrt( _.accuracy );

function routine1( test )
{
  test.identical( 1, 1 );
  console.log( `${test.name}.accuracy : ${test.accuracy}` );
}

routine1.accuracy = accuracy1;

//

function routine2( test )
{
  test.identical( 1, 1 );
  console.log( `${test.name}.accuracy : ${test.accuracy}` );
}

routine2.accuracy = [ accuracy1, accuracy2 ];

//

function routine3( test )
{
  test.identical( 1, 1 );
  console.log( `${test.name}.accuracy : ${test.accuracy}` );
}

routine3.accuracy = [ accuracy3, accuracy4 ];

//

function routine4( test )
{
  test.identical( 1, 1 );
  console.log( `${test.name}.accuracy : ${test.accuracy}` );
}

//

var Self1 =
{
  name : 'OptionAccuracy1',
  tests :
  {

    routine1,
    routine2,
    routine3,
    routine4,

  }
}

//

Self1 = wTestSuite( Self1 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self1.name );
