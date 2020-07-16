
let _ = require( 'wTesting' );
let _ = _realGlobal_._testerGlobal_.wTools

//

function routine1( test )
{
  test.identical( 1,1 );
}

//

function onSuiteEnd()
{
  var con = new _.Consequence().error( 'Test error' );
  return con;
}

//

let Self =
{
  name : 'ErrorMessageByConsequence',
  onSuiteEnd,
  onSuiteEndTimeOut : 1500,
  tests :
  {
    routine1,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
