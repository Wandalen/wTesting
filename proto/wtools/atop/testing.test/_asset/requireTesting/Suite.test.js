
debugger;
const _ = require( 'wTesting' );
debugger;

//

function routine1( test )
{
  test.identical( _.routineIs( _.arrayAppend ), true );
}

//

var Self1 =
{
  name : 'RequireTesting',
  tests :
  {

    routine1,

  }
}

//

Self1 = wTestSuite( Self1 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self1.name );
