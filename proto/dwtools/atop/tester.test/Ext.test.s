( function _Ext_test_s_( ) {

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

// --
// context
// --

function onSuiteBegin()
{
  let self = this;

  self.suiteTempPath = _.path.pathDirTempOpen( _.path.join( __dirname, '../..'  ), 'Tester' );
  self.assetsOriginalSuitePath = _.path.join( __dirname, '_asset' );
  self.defaultJsPath = _.path.nativize( _.path.join( _.path.normalize( __dirname ), '../tester/Exec' ) );
  self.toolsPath = _.path.nativize( _.path.join( _.path.normalize( __dirname ), '../../Tools.s' ) );

}

//

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.suiteTempPath, 'Tester' ) )
  _.path.pathDirTempClose( self.suiteTempPath );
}

//

function assetFor( test, asset )
{
  let self = this;
  let a = test.assetFor( asset );

  a.reflect = function reflect()
  {

    function onUp( r )
    {
      if( !_.strHas( r.dst.relative, '.atest.' ) )
      return;
      let relative = _.strReplace( r.dst.relative, '.atest.', '.test.' );
      r.dst.relative = relative;
      _.assert( _.strHas( r.dst.absolute, '.test.' ) );
    }

    let reflected = a.fileProvider.filesReflect({ reflectMap : { [ a.originalAssetPath ] : a.routinePath }, onUp : onUp });

    reflected.forEach( ( r ) =>
    {
      if( r.dst.ext !== 'js' && r.dst.ext !== 's' )
      return;
      var read = a.fileProvider.fileRead( r.dst.absolute );
      read = _.strReplace( read, `'wTesting'`, `'${_.strEscape( self.defaultJsPath )}'` );
      read = _.strReplace( read, `'wTools'`, `'${_.strEscape( self.toolsPath )}'` );
      a.fileProvider.fileWrite( r.dst.absolute, read );
    });

  }

  return a;
}

// --
// tests
// --

function run( test )
{
  let self = this;
  let a = self.assetFor( test, 'hello' );

  a.reflect();
  test.is( a.fileProvider.fileExists( a.abs( 'Hello.test.js' ) ) );

  // shell( 'npm i' );

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'node Hello.test.js beeping:0'
    return null;
  })

  a.shellNonThrowing({ args : [ 'node', 'Hello.test.js',  'beeping:0' ] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Passed TestSuite::Hello / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( got.output, 'Failed TestSuite::Hello / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'wtest Hello.test.js'
    return null;
  })

  a.jsNonThrowing({ args : [ 'Hello.test.js',  'beeping:0' ] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Passed TestSuite::Hello / TestRoutine::routine1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Failed TestSuite::Hello / TestRoutine::routine2 in' ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst absolute path as subject'
    return null;
  })

  a.jsNonThrowing({ args : [ a.abs( 'Hello.test.js' ),  'beeping:0' ] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Passed TestSuite::Hello / TestRoutine::routine1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Failed TestSuite::Hello / TestRoutine::routine2 in' ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst absolute path as subject + options'
    return null;
  })

  a.jsNonThrowing({ execPath : `${a.abs( 'Hello.test.js' )} v:7 beeping:0` })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Passed TestSuite::Hello / TestRoutine::routine1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Failed TestSuite::Hello / TestRoutine::routine2 in' ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run absolute path as subject'
    return null;
  })

  a.jsNonThrowing({ args : [ '.run', a.abs( 'Hello.test.js' ),  'beeping:0' ] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Passed TestSuite::Hello / TestRoutine::routine1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Failed TestSuite::Hello / TestRoutine::routine2 in' ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run absolute path as subject'
    return null;
  })

  a.jsNonThrowing({ execPath : `.run ${a.abs( 'Hello.test.js' )} v:7 beeping:0` })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Passed TestSuite::Hello / TestRoutine::routine1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Failed TestSuite::Hello / TestRoutine::routine2 in' ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

/* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst absolute nativized path as subject'
    return null;
  })

  a.jsNonThrowing({ args : [ a.path.nativize( a.abs( 'Hello.test.js' ) ),  'beeping:0' ] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Passed TestSuite::Hello / TestRoutine::routine1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Failed TestSuite::Hello / TestRoutine::routine2 in' ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst absolute nativized path as subject + options'
    return null;
  })

  a.jsNonThrowing({ execPath : `.run ${a.path.nativize( a.abs( 'Hello.test.js' ) )} v:7 beeping:0` })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Passed TestSuite::Hello / TestRoutine::routine1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Failed TestSuite::Hello / TestRoutine::routine2 in' ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run absolute nativized path as subject'
    return null;
  })

  a.jsNonThrowing({ args : [ '.run', a.path.nativize( a.abs( 'Hello.test.js' ) ),  'beeping:0' ] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Passed TestSuite::Hello / TestRoutine::routine1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Failed TestSuite::Hello / TestRoutine::routine2 in' ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run absolute nativized path as subject'
    return null;
  })

  a.jsNonThrowing({ execPath : `.run ${a.path.nativize( a.abs( 'Hello.test.js' ) )} v:7 beeping:0` })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Passed TestSuite::Hello / TestRoutine::routine1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Failed TestSuite::Hello / TestRoutine::routine2 in' ), 1 );
    test.identical( _.strCount( got.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( got.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

    return null;
  })

  /* - */

  // shell( 'npm rm -g wTesting' );
  return a.ready;
}

//

function checkFails( test )
{
  let self = this;
  let a = self.assetFor( test, 'check-fails' );

  a.reflect();
  test.is( a.fileProvider.fileExists( a.abs( 'Hello.test.js' ) ) );

  // shell( 'npm i' );

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst Hello.test.js'
    return null;
  })

  a.jsNonThrowing({ args : [ 'Hello.test.js',  'beeping:0' ] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Passed TestSuite::Hello / TestRoutine::routine1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Failed TestSuite::Hello / TestRoutine::routine2 in' ), 1 );
    test.identical( _.strCount( got.output, 'Passed test checks 2 / 4' ), 2 );
    test.identical( _.strCount( got.output, 'Passed test cases 1 / 2' ), 2 );
    test.identical( _.strCount( got.output, 'Passed test routines 1 / 2' ), 2 );
    test.identical( _.strCount( got.output, /Test suite \( Hello \) ... in .* ... failed/ ), 1 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst Hello.test.js fails:1'
    return null;
  })

  a.jsNonThrowing({ args : [ 'Hello.test.js',  'beeping:0', 'fails:1'] })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::Hello / TestRoutine::routine1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Failed TestSuite::Hello / TestRoutine::routine2 in' ), 1 );
    test.identical( _.strCount( got.output, /Test suite \( Hello \) ... in .* ... failed/ ), 1 );

    return null;
  })

  /* - */

  return a.ready;
}

//

function double( test )
{
  let self = this;
  let a = self.assetFor( test );

  a.reflect();
  test.is( a.fileProvider.fileExists( a.abs( 'Hello.test.js' ) ) );

  // shell( 'npm i' );

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'node Hello.test.js'
    return null;
  })

  a.shellNonThrowing({ execPath : `node Hello.test.js v:5` })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Passed TestSuite::Hello1 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( got.output, 'Failed TestSuite::Hello1 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::Hello2 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( got.output, 'Failed TestSuite::Hello2 / TestRoutine::routine2' ), 1 );

    return null;
  })

  /* - */

  return a.ready;
}

//

function optionSuite( test )
{
  let self = this;
  let a = self.assetFor( test );

  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run **'
    return null;
  })

  a.jsNonThrowing({ execPath : `.run **` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'TestSuite::OptionSuiteA1 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( got.output, 'TestSuite::OptionSuiteA1 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( got.output, 'TestSuite::OptionSuiteA2 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( got.output, 'TestSuite::OptionSuiteA2 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( got.output, 'TestSuite::OptionSuiteB1 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( got.output, 'TestSuite::OptionSuiteB1 / TestRoutine::routine2' ), 1 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** suite:OptionSuiteA1'
    return null;
  })

  a.jsNonThrowing({ execPath : `.run ** suite:OptionSuiteA1` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'TestSuite::OptionSuiteA1 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( got.output, 'TestSuite::OptionSuiteA1 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( got.output, 'TestSuite::OptionSuiteA2 / TestRoutine::routine1' ), 0 );
    test.identical( _.strCount( got.output, 'TestSuite::OptionSuiteA2 / TestRoutine::routine2' ), 0 );
    test.identical( _.strCount( got.output, 'TestSuite::OptionSuiteB1 / TestRoutine::routine1' ), 0 );
    test.identical( _.strCount( got.output, 'TestSuite::OptionSuiteB1 / TestRoutine::routine2' ), 0 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** suite:*A*'
    return null;
  })

  a.jsNonThrowing({ execPath : `.run ** suite:*A*` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'TestSuite::OptionSuiteA1 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( got.output, 'TestSuite::OptionSuiteA1 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( got.output, 'TestSuite::OptionSuiteA2 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( got.output, 'TestSuite::OptionSuiteA2 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( got.output, 'TestSuite::OptionSuiteB1 / TestRoutine::routine1' ), 0 );
    test.identical( _.strCount( got.output, 'TestSuite::OptionSuiteB1 / TestRoutine::routine2' ), 0 );

    return null;
  })

  /* - */

  return a.ready;
}

//

function noTestCheck( test )
{
  let self = this;
  let a = self.assetFor( test );
  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run **'
    return null;
  })

  a.jsNonThrowing({ execPath : `.run **` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'cant continue' ), 0 );
    test.identical( _.strCount( got.output, 'Thrown' ), 0 );
    test.identical( _.strCount( got.output, 'Passed test checks 0 / 1' ), 2 );
    test.identical( _.strCount( got.output, 'test routine has passed none test check' ), 1 );
    test.identical( _.strCount( got.output, 'Failed ( passed none test check ) TestSuite::NoTestCheckAsset / TestRoutine::routine1' ), 1 );

    return null;
  })

  /* - */

  return a.ready;
}

//

function asyncTimeOut( test )
{
  let self = this;
  let a = self.assetFor( test );
  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run **'
    return null;
  })

  a.jsNonThrowing({ execPath : `.run **` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 1 error' ), 2 );
    test.identical( _.strCount( got.output, 'failed throwing error' ), 1 );
    test.identical( _.strCount( got.output, 'Passed test checks 0 / 1' ), 2 );
    test.identical( _.strCount( got.output, 'Failed ( timed limit ) TestSuite::AsyncTimeOutAsset / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( got.output, 'test routine has passed none test check' ), 0 );

    return null;
  })

  /* - */

  return a.ready;
}

//

function checksAfterTimeOut( test )
{
  let self = this;
  let a = self.assetFor( test );
  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run **'
    return null;
  })

  a.jsNonThrowing({ execPath : `.run **` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 1 error' ), 2 );
    test.identical( _.strCount( got.output, 'failed throwing error' ), 1 );
    test.identical( _.strCount( got.output, 'Passed test checks 0 / 1' ), 2 );
    test.identical( _.strCount( got.output, 'Failed ( timed limit ) TestSuite::AsyncTimeOutAsset / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( got.output, 'test routine has passed none test check' ), 0 );

    return null;
  })

  /* - */

  return a.ready;
}

//

function noTestSuite( test )
{
  let self = this;
  let a = self.assetFor( test, false );

  a.fileProvider.dirMake( a.routinePath );

  a.ready
  .then( () =>
  {
    test.case = 'relative path'
    return null;
  })

  a.jsNonThrowing({ args : 'proto' })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = 'relative path'
    return null;
  })

  a.jsNonThrowing({ args : 'proto/dwtools' })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  /* */

  .then( () =>
  {
    test.case = 'relative glob'
    return null;
  })

  a.jsNonThrowing({ args : 'proto/**' })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  /* */

  .then( () =>
  {
    test.case = 'absolute'
    return null;
  })

  a.jsNonThrowing({ args : a.path.nativize( a.abs( '.' ) ) })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  /* */

  .then( () =>
  {
    test.case = 'absolute glob'
    return null;
  })

  a.jsNonThrowing({ args : a.path.nativize( a.abs( '**' ) ) })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  /* */

  .then( () =>
  {
    test.case = 'native'
    return null;
  })

  a.jsNonThrowing({ args : a.abs( '.' ) })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  /* */

  .then( () =>
  {
    test.case = 'native'
    return null;
  })

  a.jsNonThrowing({ args : '.run ' + a.abs( '.' ) })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  /* */

  .then( () =>
  {
    test.case = 'only option'
    return null;
  })

  a.jsNonThrowing({ args : 'n:1' })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  /* */

  .then( () =>
  {
    test.case = 'only option'
    return null;
  })

  a.jsNonThrowing({ args : '.run n:1' })
  .then( ( got ) =>
  {
    test.ni( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  /* */

  return a.ready;
}

//

function help( test )
{
  let self = this;
  let a = self.assetFor( test, false );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* */

  a.ready
  .then( ( got ) =>
  {

    test.case = 'simple run without args'

    return null;
  })

  a.jsNonThrowing( '' )

  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );
    test.is( got.output.length );
    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    return null;
  })

  /* */

  a.ready
  .then( ( got ) =>
  {

    test.case = 'simple run without args'

    return null;
  })

  a.jsNonThrowing( '.' )

  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );
    test.is( got.output.length );
    test.ge( _.strLinesCount( got.output ), 8 );
    return null;
  })

  /* */

  a.jsNonThrowing({ execPath : '.help' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.ge( _.strLinesCount( op.output ), 23 );
    return op;
  })

  /* */

  a.jsNonThrowing({ execPath : '.' })
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.ge( _.strLinesCount( op.output ), 8 );
    return op;
  })

  /* */

  a.jsNonThrowing({ args : [] })
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '0 test suite' ), 1 );
    return op;
  })

  return a.ready;
}

//

function version( test )
{
  let self = this;
  let a = self.assetFor( test, false );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* */

  a.jsNonThrowing( '.version' )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.is( _.strHas( op.output, /Current version:.*\..*\..*/ ) );
    test.is( _.strHas( op.output, /Available version:.*\..*\..*/ ) );
    return op;
  })

  return a.ready;
}

// --
// suite
// --

var Self =
{

  name : 'Tools.Tester.Ext',
  silencing : 1,
  enabled : 1,

  onSuiteBegin : onSuiteBegin,
  onSuiteEnd : onSuiteEnd,
  routineTimeOut : 300000,

  context :
  {

    assetFor,

    suiteTempPath : null,
    assetsOriginalSuitePath : null,
    defaultJsPath : null,
    toolsPath : null,

  },

  tests :
  {

    run,
    checkFails,
    double,
    optionSuite,
    noTestCheck,
    asyncTimeOut,
    checksAfterTimeOut,
    noTestSuite,
    help,
    version,

  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
