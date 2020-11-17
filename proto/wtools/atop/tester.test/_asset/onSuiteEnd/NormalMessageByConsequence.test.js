
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
  var con = new _.Consequence().take( 'Msg' );
  return con;
}

//

let Self =
{
  name : 'NormalMessageByConsequence',
  onSuiteEnd,
  suiteEndTimeOut : 1500,
  tests :
  {
    routine1,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
