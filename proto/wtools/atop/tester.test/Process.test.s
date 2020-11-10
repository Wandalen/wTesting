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

function assetFor( test, name )
{
  let context = this;
  let a = test.assetFor( name );

  _.assert( _.routineIs( a.program.head ) );
  _.assert( _.routineIs( a.program.body ) );

  let oprogram = a.program;
  program_body.defaults = a.program.defaults;
  a.program = _.routineUnite( a.program.head, program_body );
  return a;

  /* */

  function program_body( o )
  {
    let locals =
    {
      context : { t0 : context.t0, t1 : context.t1, t2 : context.t2, t3 : context.t3 },
      toolsPath : _.module.resolve( 'wTools' ),
    };
    o.locals = o.locals || locals;
    _.mapSupplement( o.locals, locals );
    _.mapSupplement( o.locals.context, locals.context );
    let programPath = a.path.nativize( oprogram.body.call( a, o ) );
    return programPath;
  }

}

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
    name : 'Trivial',

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
    test.identical( _.strCount( suite.report.errorsArray[ 2 ].message, 'Test suite "Trivial" had zombie process with pid' ), 1 );

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

//

function detachedDisconnectedChildProcess( test )
{
  var suite = wTestSuite
  ({

    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,

    onSuiteBegin : suiteBegin,
    onSuiteEnd : suiteEnd,
    routineTimeOut : 3000,
    processWatching : 1,
    name : 'DetachedProcess',

    context :
    {
      suiteTempPath : null,
      toolsPath : null,
      toolsPathInclude : null,
      t0 : 100,
      t1 : 1000,
      t2 : 5000,
      t3 : 15000,
      assetFor,
    },

    tests :
    {
      detachedDisconnectedChildProcess,
    },

  })

  var result = suite.run();

  result.finally( ( _err, got ) =>
  {
    test.identical( suite.report.errorsArray.length, 1 );

    console.log( suite.report.errorsArray.length );
    console.log( suite.report.errorsArray );
    test.identical( _.strCount( suite.report.errorsArray[ 0 ].message, 'Test suite "DetachedProcess" had zombie process with pid' ), 1 );

    test.identical( _.mapKeys( suite._processWatcherMap ).length, 0 );

    return null;
  })

  return result;

  function suiteBegin()
  {
    var self = this;
    self.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..' ), 'DetachedProcess' );
    self.toolsPath = _.path.nativize( _.path.resolve( __dirname, '../../../wtools/Tools.s' ) );
    self.toolsPathInclude = `let _ = require( '${ _.strEscape( self.toolsPath ) }' )\n`;
  }

  //

  function suiteEnd()
  {
    var self = this;
    _.assert( _.strHas( self.suiteTempPath, '/DetachedProcess-' ) )
    _.path.tempClose( self.suiteTempPath );
  }

  function detachedDisconnectedChildProcess( test )
  {
    let context = this;
    let a = context.assetFor( test, null );

    let testAppPath = a.path.nativize( a.program( testApp ) );

    let o =
    {
      execPath : 'node ' + testAppPath,
      mode : 'spawn',
      detaching : 1,
      stdio : 'pipe',
      outputPiping : 1
    }

    _.process.start( o );

    o.conStart.thenGive( () => o.disconnect() )

    //

    function testApp()
    {
      console.log( 'Child process start', process.pid )
      setTimeout( () =>
      {
        console.log( 'Child process end' )
        return null;
      }, context.t2 * 3 )
    }
  }
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
    main,
    shouldThrowErrorSyncProcessHasErrorBefore,
    detachedDisconnectedChildProcess
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
