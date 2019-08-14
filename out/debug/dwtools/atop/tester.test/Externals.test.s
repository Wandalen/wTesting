( function _Externals_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../Tools.s' );

  _.include( 'wTesting' );;
  _.include( 'wAppBasic' );
  _.include( 'wFiles' );

}

var _global = _global_;
var _ = _global_.wTools;

//

function onSuiteBegin()
{
  let self = this;

  self.execPath = _.path.nativize( _.path.join( _.path.normalize( __dirname ), '../tester/Exec' ) );
  self.tempDir = _.path.dirTempOpen( _.path.join( __dirname, '../..'  ), 'Will' );
  self.assetDirPath = _.path.join( __dirname, '_asset' );
  self.find = _.fileProvider.filesFinder
  ({
    recursive : 2,
    includingTerminals : 1,
    includingDirs : 1,
    includingTransient : 1,
    allowingMissed : 1,
    outputFormat : 'relative',
  });

}

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.tempDir, '/dwtools/tmp.tmp' ) )
  _.fileProvider.filesDelete( self.tempDir );
}

// --
// tests
// --

function run( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetDirPath, 'hello' );
  let routinePath = _.path.join( self.tempDir, test.name );
  let ready = new _.Consequence().take( null );

  let shell = _.sheller
  ({
    currentPath : routinePath,
    outputCollecting : 1,
    throwingExitCode : 0,
    ready : ready,
  })

  function onUp( r )
  {
    if( !_.strHas( r.dst.relative, '.atest.' ) )
    return;

    let relative = _.strReplace( r.dst.relative, '.atest.', '.test.' );
    debugger;
    r.dst.relative = relative;
    _.assert( _.strHas( r.dst.absolute, '.test.' ) );

  }

  debugger;
  let reflected = _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : routinePath }, onUp : onUp });
  test.is( _.fileProvider.fileExists( _.path.join( routinePath, 'Hello.test.js' ) ) );
  debugger;

  // debugger; return; xxx

  shell( 'npm i' );
  // shell( 'npm rm -g wTesting' );
  // shell( 'npm i -g ../../../..' );
  // shell( 'npm ln ../../../..' );
  shell( 'npm rm wTesting -g && npm i wTesting -g' );

  /* - */

  ready
  .thenKeep( () =>
  {
    test.case = 'node Hello.test.js beeping:0'
    return null;
  })

  shell({ args : [ 'node', 'Hello.test.js',  'beeping:0' ] })
  .thenKeep( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /Passed.*test.*routine.*Hello.*routine1.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Failed.*test.*routine.*Hello.*routine2.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 1 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  ready
  .thenKeep( () =>
  {
    test.case = 'wtest Hello.test.js'
    return null;
  })

  shell({ args : [ 'wtest', 'Hello.test.js',  'beeping:0' ] })
  .thenKeep( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /Passed.*test.*routine.*Hello.*routine1.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Failed.*test.*routine.*Hello.*routine2.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 1 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  ready
  .thenKeep( () =>
  {
    test.case = 'tst Hello.test.js'
    return null;
  })

  shell({ args : [ 'tst', 'Hello.test.js',  'beeping:0' ] })
  .thenKeep( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /Passed.*test.*routine.*Hello.*routine1.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Failed.*test.*routine.*Hello.*routine2.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 1 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  // shell( 'npm rm -g wTesting' );
  return ready;
}

//

function checkFails( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetDirPath, 'check-fails' );
  let routinePath = _.path.join( self.tempDir, test.name );
  let ready = new _.Consequence().take( null );

  let shell = _.sheller
  ({
    currentPath : routinePath,
    outputCollecting : 1,
    throwingExitCode : 0,
    ready : ready,
  })

  function onUp( r )
  {
    if( !_.strHas( r.dst.relative, '.atest.' ) )
    return;

    let relative = _.strReplace( r.dst.relative, '.atest.', '.test.' );
    debugger;
    r.dst.relative = relative;
    _.assert( _.strHas( r.dst.absolute, '.test.' ) );

  }

  debugger;
  let reflected = _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : routinePath }, onUp : onUp });
  test.is( _.fileProvider.fileExists( _.path.join( routinePath, 'Hello.test.js' ) ) );
  debugger;

  // debugger; return; xxx

  shell( 'npm i' );
  shell( 'npm rm wTesting -g && npm i wTesting -g' );

  /* - */

  ready
  .thenKeep( () =>
  {
    test.case = 'tst Hello.test.js'
    return null;
  })

  shell({ args : [ 'tst', 'Hello.test.js',  'beeping:0' ] })
  .thenKeep( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /Passed.*test.*routine.*Hello.*routine1.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Failed.*test.*routine.*Hello.*routine2.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 4/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 1 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

/* - */

  ready
  .thenKeep( () =>
  {
    test.case = 'tst Hello.test.js fails:1'
    return null;
  })

  shell({ args : [ 'tst', 'Hello.test.js',  'beeping:0', 'fails:1'] })
  .thenKeep( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /Passed.*test.*routine.*Hello.*routine1.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Failed.*test.*routine.*Hello.*routine2.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  return ready;
}

//

function double( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetDirPath, 'double' );
  let routinePath = _.path.join( self.tempDir, test.name );
  let mainDirPath = _.path.nativize( _.path.join( __dirname, '../tester' ) );
  // let mainDirPath = _.path.nativize( _.path.join( __dirname ) );
  let ready = new _.Consequence().take( null );

  console.log( 'mainDirPath', mainDirPath );

  let shell = _.sheller
  ({
    currentPath : routinePath,
    outputCollecting : 1,
    throwingExitCode : 0,
    ready : ready,
    env :
    {
      NODE_PATH : _.path.nativize( mainDirPath ),
      // NODE_PATH : _.path.nativize( originalDirPath ),
    }
  })

  debugger;
  let reflected = _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : routinePath } });
  test.is( _.fileProvider.fileExists( _.path.join( routinePath, 'Hello.test.js' ) ) );
  debugger;

  /* - */

  ready
  .thenKeep( () =>
  {
    test.case = 'node Hello.test.js'
    return null;
  })

  shell({ args : [ 'node', 'Hello.test.js' ] })
  .thenKeep( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /Passed.*test.*routine.*\(.*Hello1.*\/.*routine1.*\)/ ), 1 );
    test.identical( _.strCount( got.output, /Failed.*test.*routine.*\(.*Hello1.*\/.*routine2.*\)/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test.*routine.*\(.*Hello2.*\/.*routine1.*\)/ ), 1 );
    test.identical( _.strCount( got.output, /Failed.*test.*routine.*\(.*Hello2.*\/.*routine2.*\)/ ), 1 );

    // test.identical( _.strCount( got.output, 'Failed test routine ( Hello1 / routine2 )' ), 1 );
    // test.identical( _.strCount( got.output, 'Passed test routine ( Hello2 / routine1 )' ), 1 );
    // test.identical( _.strCount( got.output, 'Failed test routine ( Hello2 / routine2 )' ), 1 );

    return null;
  })

  /* - */

  return ready;
}

// --
// suite
// --

var Self =
{

  name : 'Tools/atop/Tester',
  silencing : 1,
  enabled : 1,

  onSuiteBegin : onSuiteBegin,
  onSuiteEnd : onSuiteEnd,
  routineTimeOut : 300000,

  context :
  {
    execPath : null,
    tempDir : null,
    assetDirPath : null,
    find : null,
  },

  tests :
  {

    run,
    checkFails,
    double,

  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
