
require( 'wTesting' );
let _ = _realGlobal_._testerGlobal_.wTools

//

process.on( 'message', ( signal ) =>
{
  process.emit( signal );
})

//

function routine1( test )
{
  test.identical( 1,1 );
  return _.time.out( 2000 );
}

//

let onSuiteEndIsExecuted = false;

function onSuiteEnd()
{
  console.log( 'Executing onSuiteEnd' );

  if( onSuiteEndIsExecuted )
  throw _.err( 'onSuiteEnd is executed for second time!' );

  onSuiteEndIsExecuted = true;

  let con = _.time.out( 1000 )
  con.deasync();
  return con;
}

//

let Self =
{
  name : 'IsExecutedOnceOnSigint',
  onSuiteEnd,
  tests :
  {
    routine1,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
