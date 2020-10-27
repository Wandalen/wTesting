( function _Process_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  if( typeof _realGlobal_ === 'undefined' || !_realGlobal_.wTester || !_realGlobal_.wTester._isReal_ )
  require( '../tester/entry/Main.s' );

  _.include( 'wLogger' );
  _.include( 'wConsequence' );
  _.include( 'wProcedure' );
  _.include( 'wProcess' );
  _.include( 'wFiles' );

}

let _global = _global_;
let _ = _global_.wTools;

// --
//
// --

function main( test )
{

  var suite = wTestSuite
  ({

    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,

    onSuiteEnd,
    routineTimeOut : 3000,
    processWatching : 1,
    name : 'ForTesting',

    tests :
    {
      trivial,
    },

  })

  var result = suite.run();

  result.finally( ( _err, got ) =>
  {
    test.identical( suite.report.errorsArray.length, 3 );

    console.log( suite.report.errorsArray.length );
    console.log( suite.report.errorsArray );
    test.is( _.strHas( suite.report.errorsArray[ 0 ].message, 'timed out' ) );
    test.is( _.strHas( suite.report.errorsArray[ 1 ].message, 'Error from onSuiteEnd' ) );
    test.identical( _.strCount( suite.report.errorsArray[ 2 ].message, 'Test suite "ForTesting" had zombie process with pid' ), 1 );

    test.identical( _.mapKeys( suite._processWatcherMap ).length, 0 );

    return null;
  })

  return result;

  function onSuiteEnd()
  {
    throw _.err( 'Error from onSuiteEnd' );
  }

  function trivial( test )
  {
    var o =
    {
      execPath : 'node -e "setTimeout(()=>{},10000)"',
      inputMirroring : 1,
      throwingExitCode : 0,
      mode : 'spawn'
    }
    return _.process.start( o )
  }

}

//

function shouldThrowErrorSyncProcessHasErrorBefore( test )
{
  test.case = 'consequence of process starter has error';
  var err = _.err( 'error' );
  var ready = new _.Consequence().error( err );

  var o =
  {
    execPath : 'unknown command',
    ready,
    sync : 1,
    throwingExitCode : 0,
  };

  test.shouldThrowErrorSync( () => _.process.start( o ) );
}

shouldThrowErrorSyncProcessHasErrorBefore.experimental = 1;

// --
//
// --

var notTakingIntoAccount = { logger : _.Logger({ output : null }), concurrent : 1, takingIntoAccount : 0 };

let Self =
{
  name : 'Tools.Tester.Process',
  silencing : 1,
  processWatching : 1,
  routineTimeOut : 30000,

  tests :
  {
    main,
    shouldThrowErrorSyncProcessHasErrorBefore,
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
