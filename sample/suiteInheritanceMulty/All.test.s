let _ = require( 'wTesting' );
require( './Positive.test.s' );
require( './Negative.test.s' );

//

let Parent = wTests[ 'Negative' ];
let Parent1 = wTests[ 'Positive' ];

//

function shouldBeThrowing( test )
{
  test.case = 'throwing'
  test.il( 1, true );
}

var Proto =
{
  name : 'All',
  abstract : 0,
  tests :
  {
    shouldBeThrowing,
  }
}

//

var Self = wTestSuite( Proto )
.inherit( Parent )
.inherit( Parent1 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
