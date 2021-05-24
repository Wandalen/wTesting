
require( 'wTesting' );
let _ = _realGlobal_._globals_.testing.wTools;

//

function routine1( test )
{
  test.identical( 1, 1 );
}

//

function onSuiteEnd()
{
  var con = new _.Consequence().error( 'Test error' );
  return con;
}

//

const Proto =
{
  name : 'ErrorMessageByConsequence',
  onSuiteEnd,
  suiteEndTimeOut : 1500,
  tests :
  {
    routine1,
  }
}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
