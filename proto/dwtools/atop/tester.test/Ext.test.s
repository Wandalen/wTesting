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
  self.execJsPath = _.path.nativize( _.path.join( _.path.normalize( __dirname ), '../tester/Exec' ) );
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

    let reflected = a.fileProvider.filesReflect({ reflectMap : { [ a.originalAssetPath ] : a.routinePath }, onUp : onUp });

    reflected.forEach( ( r ) =>
    {
      if( r.dst.ext !== 'js' && r.dst.ext !== 's' )
      return;
      var read = a.fileProvider.fileRead( r.dst.absolute );
      read = _.strReplace( read, `'wTesting'`, `'${_.strEscape( self.execJsPath )}'` );
      read = _.strReplace( read, `'wTools'`, `'${_.strEscape( self.toolsPath )}'` );
      a.fileProvider.fileWrite( r.dst.absolute, read );
    });

  }

  return a;

  function onUp( r )
  {
    if( !_.strHas( r.dst.relative, '.atest.' ) )
    return;
    let relative = _.strReplace( r.dst.relative, '.atest.', '.test.' );
    r.dst.relative = relative;
    _.assert( _.strHas( r.dst.absolute, '.test.' ) );
  }

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
  .then( ( op ) =>
  {
    test.ni( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Passed TestSuite::Hello / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::Hello / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( op.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( op.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( op.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( op.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

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
  .then( ( op ) =>
  {
    test.ni( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Passed TestSuite::Hello / TestRoutine::routine1 in' ), 1 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::Hello / TestRoutine::routine2 in' ), 1 );
    test.identical( _.strCount( op.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( op.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( op.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( op.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

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
  .then( ( op ) =>
  {
    test.ni( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Passed TestSuite::Hello / TestRoutine::routine1 in' ), 1 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::Hello / TestRoutine::routine2 in' ), 1 );
    test.identical( _.strCount( op.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( op.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( op.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( op.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

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
  .then( ( op ) =>
  {
    test.ni( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Passed TestSuite::Hello / TestRoutine::routine1 in' ), 1 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::Hello / TestRoutine::routine2 in' ), 1 );
    test.identical( _.strCount( op.output, /Passed.*test checks 2 \/ 3/ ), 2 );
    test.identical( _.strCount( op.output, /Passed.*test cases 1 \/ 2/ ), 2 );
    test.identical( _.strCount( op.output, /Passed.*test routines 1 \/ 2/ ), 2 );
    test.identical( _.strCount( op.output, /Test suite.*\(.*Hello.*\).*failed/ ), 1 );

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
  let a = self.assetFor( test );

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
    test.identical( _.strCount( got.output, 'Failed ( throwing error ) TestSuite::Hello / TestRoutine::routine2' ), 1 );
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
    test.identical( _.strCount( got.output, 'failed, time out' ), 1 );
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
    test.case = 'tst .run ** v:5'
    return null;
  })

  a.jsNonThrowing({ execPath : `.run ** v:5` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 2 error' ), 2 );
    test.identical( _.strCount( got.output, 'failed, time out' ), 1 );
    test.identical( _.strCount( got.output, 'Passed test checks 2 / 3' ), 2 );
    test.identical( _.strCount( got.output, 'Passed test routines 1 / 2' ), 2 );
    test.identical( _.strCount( got.output, 'test routine has passed none test check' ), 0 );
    test.identical( _.strCount( got.output, 'failed' ), 3 );
    test.identical( _.strCount( got.output, 'Failed' ), 1 );

    test.identical( _.strCount( got.output, 'Test check ( TestSuite::ChecksAfterTimeOutAsset / TestRoutine::routine1 /  < description1 # 1 ) ... ok' ), 1 );
    test.identical( _.strCount( got.output, 'Test check ( TestSuite::ChecksAfterTimeOutAsset / TestRoutine::routine1 /  < description2 # 2 ) ... failed, time out' ), 1 );
    test.identical( _.strCount( got.output, 'Failed ( timed limit ) TestSuite::ChecksAfterTimeOutAsset / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( got.output, 'Test check ( TestSuite::ChecksAfterTimeOutAsset / TestRoutine::routine2 /  < description1 # 1 ) ... ok' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::ChecksAfterTimeOutAsset / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( got.output, 'Test check' ), 3 );

    test.identical( _.strCount( got.output, 'v0' ), 1 );
    test.identical( _.strCount( got.output, 'v1' ), 1 );
    test.identical( _.strCount( got.output, 'v2' ), 0 );
    test.identical( _.strCount( got.output, 'v3' ), 1 );

    return null;
  })

  /* - */

  return a.ready;
}

//

function checksAfterTimeOutSilenced( test )
{
  let self = this;
  let a = self.assetFor( test );
  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:5'
    return null;
  })

  a.jsNonThrowing({ execPath : `.run ** v:5` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 2 error(s)' ), 2 );
    test.identical( _.strCount( got.output, 'Passed test checks 2 / 2' ), 2 );
    test.identical( _.strCount( got.output, 'Passed test routines 2 / 2' ), 2 );
    test.identical( _.strCount( got.output, 'test routine has passed none test check' ), 0 );
    test.identical( _.strCount( got.output, 'failed, throwing error' ), 0 );

    test.identical( _.strCount( got.output, 'Passed TestSuite::ChecksAfterTimeOutSilencedAsset / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::ChecksAfterTimeOutSilencedAsset / TestRoutine::routine2' ), 1 );

    test.identical( _.strCount( got.output, 'Test check' ), 2 );
    test.identical( _.strCount( got.output, 'returned, cant continue!' ), 2 );

    test.identical( _.strCount( got.output, 'v0' ), 0 );
    test.identical( _.strCount( got.output, 'v1' ), 0 );
    test.identical( _.strCount( got.output, 'v2' ), 0 );
    test.identical( _.strCount( got.output, 'v3' ), 0 );
    test.identical( _.strCount( got.output, 'v4' ), 0 );
    test.identical( _.strCount( got.output, 'v10' ), 0 );

    return null;
  })

  /* - */

  return a.ready;
}

//

function timeOutExternalMessage( test )
{
  let self = this;
  let a = self.assetFor( test );
  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:5'
    return null;
  })

  a.js({ execPath : `.run ** v:5` })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Waiting for' ), 0 );
    test.identical( _.strCount( op.output, 'procedure::' ), 0 );
    test.identical( _.strCount( op.output, 'v1' ), 1 );
    test.identical( _.strCount( op.output, 'v2' ), 1 );
    test.identical( _.strCount( op.output, 'v3' ), 1 );
    test.identical( _.strCount( op.output, 'v4' ), 1 );
    test.identical( _.strCount( op.output, 'v5' ), 0 );
    test.identical( _.strCount( op.output, /v1(.|\n|\r)*v2(.|\n|\r)*v3(.|\n|\r)*v4(.|\n|\r)*/mg ), 1 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'node .run ** v:5'
    return null;
  })

  a.shell({ execPath : `node Suite.test.js v:5` })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Waiting for' ), 0 );
    test.identical( _.strCount( op.output, 'procedure::' ), 0 );
    test.identical( _.strCount( op.output, 'v1' ), 1 );
    test.identical( _.strCount( op.output, 'v2' ), 1 );
    test.identical( _.strCount( op.output, 'v3' ), 1 );
    test.identical( _.strCount( op.output, 'v4' ), 1 );
    test.identical( _.strCount( op.output, 'v5' ), 0 );
    test.identical( _.strCount( op.output, /v1(.|\n|\r)*v2(.|\n|\r)*v3(.|\n|\r)*v4(.|\n|\r)*/mg ), 1 );

    return null;
  })

  /* - */

  return a.ready;
}

//

function timeLimitConsequence( test )
{
  let t = 25;
  let ready = new _.Consequence().take( null )

  /* */

  .thenKeep( function timeLimit1( arg )
  {
    test.case = 'timeOut timeLimit a timeLimitOut';

    var con = _.time.out( t*1 );
    var con0 = _.time.out( t*3, 'a' );
    con.timeLimit( t*6, con0 );

    return _.time.out( t*15, function()
    {
      debugger;
      test.is( con.argumentsGet()[ 0 ] === 'a' );
      test.identical( con.argumentsCount(), 1 );
      test.identical( con.errorsCount(), 0 );
      test.identical( con.competitorsCount(), 0 );
      return null;
    })
  })

  /* */

  return ready;
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

//

function manualTermination( test )
{
  // let self = this;
  // let a = self.assetFor( test, 'manualTermination' );
  //
  // /* - */
  //
  // let o =
  // {
  //   execPath : 'node manualTermination.test.js v:7',
  //   currentPath : a.originalAssetPath,
  //   mode : 'spawn',
  //   outputCollecting : 1,
  //   throwingExitCode : 0
  // };
  // a.shellNonThrowing( o )

  let self = this;
  let a = self.assetFor( test, 'manualTermination' );
  a.reflect();

  /* - */

  let o =
  {
    execPath : `${a.abs( 'manualTermination.test.js' )} v:7`,
  };
  a.jsNonThrowing( o )

  /* */

  a.ready
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.is( _.strHas( op.output, 'onSuiteEnd : 1' ) );
    test.is( _.strHas( op.output, 'onExit : 2' ) );
    return op;
  })

  return a.ready;
}

manualTermination.description =
`
  User terminates execution when second test routine is runnning.
  onSuiteEnd handler should be executed before _exitHandlerOnce
`

//

function asyncErrorHandling( test )
{
  let self = this;
  let a = self.assetFor( test, 'asyncErrorHandling' );
  a.reflect();

  /* - */

  let o =
  {
    execPath : `${a.abs( 'asyncErrorHandling.test.js' )} v:7`,
  };
  a.jsNonThrowing( o )

  a.ready
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Cannot find' ), 0 );
    test.identical( _.strCount( op.output, 'error(s)' ), 0 );
    test.identical( _.strCount( op.output, 'nhandled' ), 0 );
    test.identical( _.strCount( op.output, 'ncaught' ), 0 );
    test.identical( _.strCount( op.output, '---' ), 0 );
    test.identical( _.strCount( op.output, 'Thrown' ), 0 );
    test.identical( _.strCount( op.output, 'Passed test suites 1 / 1' ), 1 );
    test.identical( _.strCount( op.output, 'Error throwen asynchronously' ), 1 );
    return op;
  })

  /* */

  return a.ready;
}

//

function onSuiteEndReturnConsequence( test )
{
  let self = this;
  let a = self.assetFor( test, 'onSuiteEnd' );
  a.reflect();

  /* - */

  a.jsNonThrowing({ execPath : `TimeOutInOnSuiteEnd.test.js` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 1 error' ), 2 );
    test.identical( _.strCount( got.output, 'Time out!' ), 1 );
    return null;
  })

  a.jsNonThrowing({ execPath : `ErrorMessageByConsequence.test.js` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 1 error' ), 2 );
    test.identical( _.strCount( got.output, 'Test error' ), 2 );
    return null;
  })

  a.jsNonThrowing({ execPath : `NormalMessageByConsequence.test.js` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    test.identical( _.strCount( got.output, 'error' ), 0 );
    test.identical( _.strCount( got.output, /Testing \.\.\. in .* \.\.\. ok/g ), 1 );
    return null;
  })

  a.jsNonThrowing({ execPath : `DelayedMessageByConsequence.test.js` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    test.identical( _.strCount( got.output, 'error' ), 0 );
    test.identical( _.strCount( got.output, /Testing \.\.\. in .* \.\.\. ok/g ), 1 );
    return null;
  })

  /* - */

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
    execJsPath : null,
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
    checksAfterTimeOutSilenced,
    timeOutExternalMessage,
    timeLimitConsequence,
    noTestSuite,
    help,
    version,
    manualTermination,
    asyncErrorHandling,

    onSuiteEndReturnConsequence,

  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
