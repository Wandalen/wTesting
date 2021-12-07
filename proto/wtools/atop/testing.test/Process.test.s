( function _Process_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{

  const _ = require( 'Tools' );

  if( typeof _realGlobal_ === 'undefined' || !_realGlobal_.wTester || !_realGlobal_.wTester._isReal_ )
  require( '../testing/entry/Basic.s' );

  _.include( 'wLogger' );
  _.include( 'wConsequence' );
  _.include( 'wProcedure' );
  _.include( 'wProcess' );
  _.include( 'wFiles' );

}

const _global = _global_;
const _ = _global_.wTools;

function assetFor( test, name )
{
  let context = this;
  let a = test.assetFor( name );

  _.assert( _.routineIs( a.program.head ) );
  _.assert( _.routineIs( a.program.body ) );

  let oprogram = a.program;
  program_body.defaults = a.program.defaults;
  a.program = _.routine.uniteCloning_replaceByUnite( a.program.head, program_body );
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
    _.props.supplement( o.locals, locals );
    _.props.supplement( o.locals.context, locals.context );
    let r = oprogram.body.call( a, o );
    r.filePath/*programPath*/ = a.path.nativize( r.filePath/*programPath*/ );
    return r;
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
    test.true( _.strHas( suite.report.errorsArray[ 0 ].message, 'timed out' ) );
    test.true( _.strHas( suite.report.errorsArray[ 1 ].message, 'Error from onSuiteEnd' ) );
    test.identical( _.strCount( suite.report.errorsArray[ 2 ].message, 'Test suite "Trivial" had zombie process with pid' ), 1 );

    test.identical( _.props.keys( suite._processWatcherMap ).length, 0 );

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


function disconnectedChildProcess( test )
{
  var suite = wTestSuite
  ({

    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,

    onSuiteBegin : suiteBegin,
    onSuiteEnd : suiteEnd,
    routineTimeOut : 3000,
    processWatching : 1,
    name : 'DisconnectedProcess',

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
      disconnectedChildProcess,
    },

  });

  var result = suite.run();

  result.finally( ( _err, got ) =>
  {
    test.identical( suite.report.errorsArray.length, 1 );

    console.log( suite.report.errorsArray.length );
    console.log( suite.report.errorsArray[ 0 ] );
    test.identical( _.strCount( suite.report.errorsArray[ 0 ].message, 'Test suite "DisconnectedProcess" had zombie process with pid' ), 1 );

    test.identical( _.props.keys( suite._processWatcherMap ).length, 0 );

    return null;
  })

  return result;

  function suiteBegin()
  {
    var self = this;
    self.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..' ), 'DetachedProcess' );
    self.toolsPath = _.path.nativize( _.path.resolve( __dirname, '../../../node_modules/Tools' ) );
    self.toolsPathInclude = `const _ = require( '${ _.strEscape( self.toolsPath ) }' )\n`;
  }

  //

  function suiteEnd()
  {
    var self = this;
    _.assert( _.strHas( self.suiteTempPath, '/DetachedProcess-' ) )
    _.path.tempClose( self.suiteTempPath );
  }

  function disconnectedChildProcess( test )
  {
    let context = this;
    let a = context.assetFor( test, null );

    let testAppPath = a.path.nativize( a.program( testApp ).filePath/*programPath*/ );

    let o =
    {
      execPath : 'node ' + testAppPath,
      mode : 'spawn',
      detaching : 0,
      stdio : 'pipe',
      outputPiping : 1
    }

    _.process.start( o );

    o.conStart.thenGive( () => o.disconnect() );

    test.true( true );
    return o;

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

//

function disconnectedChildProcessWithIPC( test )
{
  var suite = wTestSuite
  ({

    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,

    onSuiteBegin : suiteBegin,
    onSuiteEnd : suiteEnd,
    routineTimeOut : 3000,
    processWatching : 1,
    name : 'DisconnectedProcessIPC',

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
      disconnectedChildProcessIPC,
    },

  })

  var result = suite.run();

  result.finally( ( _err, got ) =>
  {
    test.identical( suite.report.errorsArray.length, 1 );

    console.log( suite.report.errorsArray.length );
    console.log( suite.report.errorsArray[ 0 ] );
    test.identical( _.strCount( suite.report.errorsArray[ 0 ].message, 'Test suite "DisconnectedProcessIPC" had zombie process with pid' ), 1 );

    test.identical( _.props.keys( suite._processWatcherMap ).length, 0 );

    return null;
  })

  return result;

  function suiteBegin()
  {
    var self = this;
    self.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..' ), 'DetachedProcess' );
    self.toolsPath = _.path.nativize( _.path.resolve( __dirname, '../../../node_modules/Tools' ) );
    self.toolsPathInclude = `const _ = require( '${ _.strEscape( self.toolsPath ) }' )\n`;
  }

  //

  function suiteEnd()
  {
    var self = this;
    _.assert( _.strHas( self.suiteTempPath, '/DetachedProcess-' ) )
    _.path.tempClose( self.suiteTempPath );
  }

  function disconnectedChildProcessIPC( test )
  {
    let context = this;
    let a = context.assetFor( test, null );

    let testAppPath = a.path.nativize( a.program( testApp ).filePath/*programPath*/ );

    let o =
    {
      execPath : 'node ' + testAppPath,
      mode : 'spawn',
      detaching : 0,
      ipc : 1,
      stdio : 'pipe',
      outputPiping : 1
    }

    _.process.start( o );

    o.conStart.thenGive( () => o.disconnect() )

    test.true( true );
    return o;

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
    console.log( suite.report.errorsArray[ 0 ] );
    test.identical( _.strCount( suite.report.errorsArray[ 0 ].message, 'Test suite "DetachedProcess" had zombie process with pid' ), 1 );

    test.identical( _.props.keys( suite._processWatcherMap ).length, 0 );

    return null;
  })

  return result;

  function suiteBegin()
  {
    var self = this;
    self.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..' ), 'DetachedProcess' );
    self.toolsPath = _.path.nativize( _.path.resolve( __dirname, '../../../node_modules/Tools' ) );
    self.toolsPathInclude = `const _ = require( '${ _.strEscape( self.toolsPath ) }' )\n`;
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

    let testAppPath = a.path.nativize( a.program( testApp ).filePath/*programPath*/ );

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

    test.true( true );
    return o;

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

const Proto =
{
  name : 'Tools.Tester.Process',
  silencing : 1,
  processWatching : 1,
  routineTimeOut : 60000,

  tests :
  {
    main,
    shouldThrowErrorSyncProcessHasErrorBefore,
    disconnectedChildProcess,
    disconnectedChildProcessWithIPC,
    detachedDisconnectedChildProcess
  }

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
