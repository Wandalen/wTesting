let _ = require( 'wTesting' );
require( './Positive.test.js' );
require( './Negative.test.js' );

//

let Parent = wTests[ 'Negative' ];
let Parent1 = wTests[ 'Positive' ];

//

function shouldBeFailed( test )
{
  test.il( 1, true );
}

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

Self = wTestSuite( Proto ).inherit( Parent ).inherit( Parent1 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
