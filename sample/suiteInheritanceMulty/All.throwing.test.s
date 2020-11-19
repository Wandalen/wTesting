let _ = require( 'wTesting' );
require( './Positive.test.s' );
require( './Negative.test.s' );

//

let Parent = wTests[ 'Negative' ];
let Parent1 = wTests[ 'Positive' ];

//

function shouldBeFailed( test )
{
  test.case = 'throwing'
  test.identical( 1, true );
}

//

var Proto =
{
  name : 'All',
  abstract : 0,
  tests :
  {
    shouldBeFailed,
  }
}

//

let Self = wTestSuite( Proto )
.inherit( Parent )
.inherit( Parent1 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

