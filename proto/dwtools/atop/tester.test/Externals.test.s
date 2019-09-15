( function _Externals_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../Tools.s' );

  require( '../tester/MainTop.s' );
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
  self.tempDir = _.path.pathDirTempOpen( _.path.join( __dirname, '../..'  ), 'Tester' );
  self.assetDirPath = _.path.join( __dirname, '_asset' );
  self.find = _.fileProvider.filesFinder
  ({
    filter : { recursive : 2 },
    withTerminals : 1,
    withDirs : 1,
    withTransient/*maybe withStem*/ : 1,
    allowingMissed : 1,
    outputFormat : 'relative',
  });

}

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.tempDir, 'Tester' ) )
  _.path.pathDirTempClose( self.tempDir );
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
  let execPath = _.path.nativize( _.path.join( __dirname, '../tester/Exec' ) );
  let suitePath = _.path.join( routinePath, 'Hello.test.js' );

  let shellTester = _.process.starter
  ({
    execPath : 'node ' + execPath,
    currentPath : routinePath,
    outputCollecting : 1,
    throwingExitCode : 0,
    mode : 'shell',
    ready : ready,
  })

  let shell = _.process.starter
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
  // shell( 'npm -g uninstall wTesting' );
  // shell( 'npm -g install wTesting' );

  /* - */

  ready
  .then( () =>
  {
    test.case = 'node Hello.test.js beeping:0'
    return null;
  })

  shell({ args : [ 'node', 'Hello.test.js',  'beeping:0' ] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /Passed.*test.*routine.*Hello.*routine1.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Failed.*test.*routine.*Hello.*routine2.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  ready
  .then( () =>
  {
    test.case = 'wtest Hello.test.js'
    return null;
  })

  shellTester({ args : [ 'Hello.test.js',  'beeping:0' ] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /Passed.*test.*routine.*Hello.*routine1.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Failed.*test.*routine.*Hello.*routine2.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  ready
  .then( () =>
  {
    test.case = 'tst absolute path as subject'
    return null;
  })

  shellTester({ args : [ suitePath,  'beeping:0' ] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /Passed.*test.*routine.*Hello.*routine1.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Failed.*test.*routine.*Hello.*routine2.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  ready
  .then( () =>
  {
    test.case = 'tst absolute path as subject + options'
    return null;
  })

  shellTester({ args : [ suitePath,  'v:7 beeping:0' ] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /Passed.*test.*routine.*Hello.*routine1.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Failed.*test.*routine.*Hello.*routine2.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  ready
  .then( () =>
  {
    test.case = 'tst .run absolute path as subject'
    return null;
  })

  shellTester({ args : [ '.run', suitePath,  'beeping:0' ] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /Passed.*test.*routine.*Hello.*routine1.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Failed.*test.*routine.*Hello.*routine2.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  ready
  .then( () =>
  {
    test.case = 'tst .run absolute path as subject'
    return null;
  })

  shellTester({ args : [ '.run', suitePath,  'v:7 beeping:0' ] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /Passed.*test.*routine.*Hello.*routine1.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Failed.*test.*routine.*Hello.*routine2.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

/* - */

  ready
  .then( () =>
  {
    test.case = 'tst absolute nativized path as subject'
    return null;
  })

  shellTester({ args : [ _.path.nativize( suitePath ),  'beeping:0' ] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /Passed.*test.*routine.*Hello.*routine1.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Failed.*test.*routine.*Hello.*routine2.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  ready
  .then( () =>
  {
    test.case = 'tst absolute nativized path as subject + options'
    return null;
  })

  shellTester({ args : [ _.path.nativize( suitePath ),  'v:7 beeping:0' ] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /Passed.*test.*routine.*Hello.*routine1.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Failed.*test.*routine.*Hello.*routine2.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  ready
  .then( () =>
  {
    test.case = 'tst .run absolute nativized path as subject'
    return null;
  })

  shellTester({ args : [ '.run', _.path.nativize( suitePath ),  'beeping:0' ] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /Passed.*test.*routine.*Hello.*routine1.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Failed.*test.*routine.*Hello.*routine2.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  ready
  .then( () =>
  {
    test.case = 'tst .run absolute nativized path as subject'
    return null;
  })

  shellTester({ args : [ '.run', _.path.nativize( suitePath ),  'v:7 beeping:0' ] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /Passed.*test.*routine.*Hello.*routine1.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Failed.*test.*routine.*Hello.*routine2.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
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
  let execPath = _.path.nativize( _.path.join( __dirname, '../tester/Exec' ) );

  let shellTester = _.process.starter
  ({
    execPath : 'node ' + execPath,
    currentPath : routinePath,
    outputCollecting : 1,
    throwingExitCode : 0,
    mode : 'shell',
    ready : ready,
  })

  let shell = _.process.starter
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
  // shell( 'npm -g uninstall wTesting' );
  // shell( 'npm -g install wTesting' );

  /* - */

  ready
  .then( () =>
  {
    test.case = 'tst Hello.test.js'
    return null;
  })

  shellTester({ args : [ 'Hello.test.js',  'beeping:0' ] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, /Passed.*test.*routine.*Hello.*routine1.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Failed.*test.*routine.*Hello.*routine2.*in/ ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 4/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

/* - */

  ready
  .then( () =>
  {
    test.case = 'tst Hello.test.js fails:1'
    return null;
  })

  shellTester({ args : [ 'Hello.test.js',  'beeping:0', 'fails:1'] })
  .then( ( got ) =>
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

  let shell = _.process.starter
  ({
    currentPath : routinePath,
    outputCollecting : 1,
    throwingExitCode : 0,
    mode : 'shell',
    ready : ready,
  })

  debugger;
  let reflected = _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : routinePath } });
  test.is( _.fileProvider.fileExists( _.path.join( routinePath, 'Hello.test.js' ) ) );
  debugger;

  shell( 'npm i' );

  /* - */

  ready
  .then( () =>
  {
    test.case = 'node Hello.test.js'
    return null;
  })

  shell({ args : [ 'node', 'Hello.test.js' ] })
  .then( ( got ) =>
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

//

function noTestSuite( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetDirPath, 'hello' );
  let routinePath = _.path.join( self.tempDir, test.name );
  let execPath = _.path.nativize( _.path.join( __dirname, '../tester/Exec' ) );
  let ready = new _.Consequence().take( null );

  let shell = _.process.starter
  ({
    execPath : 'node ' + execPath,
    currentPath : routinePath,
    outputCollecting : 1,
    throwingExitCode : 0,
    mode : 'shell',
    ready : ready,
  })

  _.fileProvider.dirMake( routinePath );

  ready
  .then( () =>
  {
    test.case = 'relative path'
    return null;
  })

  shell({ args : 'proto' })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  //

  ready
  .then( () =>
  {
    test.case = 'relative path'
    return null;
  })

  shell({ args : 'proto/dwtools' })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  //

  .then( () =>
  {
    test.case = 'relative glob'
    return null;
  })

  shell({ args : 'proto/**' })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  //

  .then( () =>
  {
    test.case = 'absolute'
    return null;
  })

  shell({ args : _.path.nativize( routinePath ) })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  //

  .then( () =>
  {
    test.case = 'absolute glob'
    return null;
  })

  shell({ args : _.path.nativize( _.path.join( routinePath, '**' ) ) })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  .then( () =>
  {
    test.case = 'native'
    return null;
  })

  shell({ args : routinePath })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  .then( () =>
  {
    test.case = 'native'
    return null;
  })

  shell({ args : '.run ' + routinePath })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  .then( () =>
  {
    test.case = 'only option'
    return null;
  })

  shell({ args : 'n:1' })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  .then( () =>
  {
    test.case = 'only option'
    return null;
  })

  shell({ args : '.run n:1' })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  return ready;
}

//

function help( test )
{
  let self = this;
  debugger;
  let routinePath = _.path.join( self.tempDir, test.name );
  let execPath = _.path.nativize( _.path.join( __dirname, '../tester/Exec' ) );
  let ready = new _.Consequence().take( null );
  debugger;

  let shell = _.process.starter
  ({
    execPath : 'node ' + execPath,
    currentPath : routinePath,
    outputCollecting : 1,
    throwingExitCode : 0,
    mode : 'shell',
    ready : ready,
  })

  _.fileProvider.dirMake( routinePath );

  /* */

  ready
  .then( ( got ) =>
  {

    test.case = 'simple run without args'

    return null;
  })

  shell( '' )

  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );
    test.is( got.output.length );
    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    return null;
  })

  /* */

  ready
  .then( ( got ) =>
  {

    test.case = 'simple run without args'

    return null;
  })

  shell( '.' )

  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );
    test.is( got.output.length );
    test.ge( _.strLinesCount( got.output ), 8 );
    return null;
  })

  /* */

  shell({ execPath : '.help' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.ge( _.strLinesCount( op.output ), 23 );
    return op;
  })

  /* */

  shell({ execPath : '.' })
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.ge( _.strLinesCount( op.output ), 8 );
    return op;
  })

  /* */

  shell({ args : [] })
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '0 test suite' ), 1 );
    return op;
  })

  return ready;
}

// --
// suite
// --

var Self =
{

  name : 'Tools.atop.Tester',
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
    noTestSuite,
    help,

  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
