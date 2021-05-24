
require( 'wTesting' );
let _ = _realGlobal_._globals_.testing.wTools;

//

process.on( 'message', ( signal ) =>
{
  process.emit( signal );
})

//

function routine1( test )
{
  test.identical( 1, 1 );
  return _.time.out( 10000 );
}

//

let onSuiteEndIsExecuted = false;

function onSuiteEnd()
{
  console.log( 'Executing onSuiteEnd' );
  if( onSuiteEndIsExecuted )
  throw _.err( 'onSuiteEnd is executed for second time!' );
  onSuiteEndIsExecuted = true;
  return null;
}

//

const Proto =
{
  name : 'IsExecutedOnceOnSigint',
  onSuiteEnd,
  routineTimeOut : 60000,
  suiteEndTimeOut : 60000,
  tests :
  {
    routine1,
  }
}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
