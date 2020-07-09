( function _Process_test_s_( ) {

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

var _global = _global_;
var _ = _global_.wTools;


// --
// 
// --

function main( test )
{
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
      throwingExitCode : 1,
      mode : 'spawn'
    }
    return _.process.start( o )
  }

  var suite = wTestSuite
  ({
    
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,

    onSuiteEnd,
    routineTimeOut : 3000,
    processWatching : 1,

    tests :
    {
      trivial
    },

  })
  
  var result = suite.run();
  
  result.finally( ( err, arg ) => 
  {
    test.identical( suite.report.errorsArray.length, 3 );
    
    test.is( _.strHas( suite.report.errorsArray[ 0 ].message, 'Time out!' ) );
    test.is( _.strHas( suite.report.errorsArray[ 1 ].message, 'Error from onSuiteEnd' ) );
    test.identical( _.strCount( suite.report.errorsArray[ 2 ].message, 'Test suite "Process.test.s:48:15" had zombie process with pid' ), 1 );
    
    return _.time.out( 2000, () =>
    {
      test.identical( _.mapKeys( suite._processWatcherMap ).length, 1 );
      _.each( suite._processWatcherMap, ( o ) =>
      {
        test.is( !_.process.isAlive( o.process.pid ) )
      })
      return null;
    })
  })
  
  return result;
}

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
    main
  }

}



Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
