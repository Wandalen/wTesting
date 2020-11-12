( function _Ext_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../wtools/Tools.s' );

  require( '../tester/entry/Main.s' );
  _.include( 'wProcess' );
  _.include( 'wFiles' );

}

let _global = _global_;
let _ = _global_.wTools;

/* qqq : parametrixe delays */

// --
// context
// --

function onSuiteBegin()
{
  let context = this;

  context.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..'  ), 'Tester' );
  context.assetsOriginalPath = _.path.join( __dirname, '_asset' );
  context.appJsPath = _.path.nativize( _.path.join( _.path.normalize( __dirname ), '../tester/entry/Exec' ) );

}

//

function onSuiteEnd()
{
  let context = this;
  _.assert( _.strHas( context.suiteTempPath, 'Tester' ) )
  _.path.tempClose( context.suiteTempPath );
}

//

function assetFor( test, asset )
{
  let context = this;
  let a = test.assetFor( asset );

  _.assert( _.routineIs( a.program.head ) );
  _.assert( _.routineIs( a.program.body ) );

  let oprogram = a.program;
  program_body.defaults = a.program.defaults;
  a.program = _.routineUnite( a.program.head, program_body );
  a.reflect = reflect

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

  function reflect()
  {

    let reflected = a.fileProvider.filesReflect({ reflectMap : { [ a.originalAssetPath ] : a.routinePath }, onUp });

    reflected.forEach( ( r ) =>
    {
      if( r.dst.ext !== 'js' && r.dst.ext !== 's' )
      return;
      var read = a.fileProvider.fileRead( r.dst.absolute );
      read = _.strReplace( read, `'wTesting'`, `'${_.strEscape( context.appJsPath )}'` );
      read = _.strReplace( read, `'wTools'`, `'${_.strEscape( _.module.resolve( 'wTools' ) )}'` );
      a.fileProvider.fileWrite( r.dst.absolute, read );
    });

  }

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
// conditions
// --

function run( test )
{
  let context = this;
  let a = context.assetFor( test, 'hello' );

  a.reflect();
  test.is( a.fileProvider.fileExists( a.abs( 'Hello.test.js' ) ) );

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

  a.appStartNonThrowing({ args : [ 'Hello.test.js',  'beeping:0' ] })
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

  a.appStartNonThrowing({ args : [ a.abs( 'Hello.test.js' ),  'beeping:0' ] })
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

  a.appStartNonThrowing({ execPath : `${a.abs( 'Hello.test.js' )} v:7 beeping:0` })
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

  a.appStartNonThrowing({ args : [ '.run', a.abs( 'Hello.test.js' ),  'beeping:0' ] })
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

  a.appStartNonThrowing({ execPath : `.run ${a.abs( 'Hello.test.js' )} v:7 beeping:0` })
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

  a.appStartNonThrowing({ args : [ a.path.nativize( a.abs( 'Hello.test.js' ) ),  'beeping:0' ] })
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

  a.appStartNonThrowing({ execPath : `.run ${a.path.nativize( a.abs( 'Hello.test.js' ) )} v:7 beeping:0` })
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

  a.appStartNonThrowing({ args : [ '.run', a.path.nativize( a.abs( 'Hello.test.js' ) ),  'beeping:0' ] })
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

  a.appStartNonThrowing({ execPath : `.run ${a.path.nativize( a.abs( 'Hello.test.js' ) )} v:7 beeping:0` })
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

  // shell( 'npm rm -g wTesting' );
  return a.ready;
}

//

function runWithQuotedPath( test )
{
  let context = this;
  let a = context.assetFor( test, 'hello' );

  a.reflect();
  test.is( a.fileProvider.fileExists( a.abs( 'Hello.test.js' ) ) );

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run glob quoted by single quote'
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run "'${a.path.nativize( a.abs( './**' ) )}'" beeping:0` })
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
    test.case = 'tst .run glob quoted by double quote'

    return null;
  })

  a.appStartNonThrowing({ execPath : `.run '"${a.path.nativize( a.abs( './**' ) )}"' beeping:0` })
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
    test.case = 'tst .run glob quoted by backtick'

    return null;
  })

  a.appStartNonThrowing({ execPath : `.run "\`${a.path.nativize( a.abs( './**' ) )}\`" beeping:0` })
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
    test.case = 'tst glob quoted by single quote'
    return null;
  })

  a.appStartNonThrowing({ execPath : `"'${a.path.nativize( a.abs( './**' ) )}'" beeping:0` })
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
    test.case = 'glob quoted by double quote'

    return null;
  })

  a.appStartNonThrowing({ execPath : `'"${a.path.nativize( a.abs( './**' ) )}"' beeping:0` })
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
    test.case = 'glob quoted by backtick'

    return null;
  })

  a.appStartNonThrowing({ execPath : `"\`${a.path.nativize( a.abs( './**' ) )}\`" beeping:0` })
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

  return a.ready;
}

//

function checkFails( test )
{
  let context = this;
  let a = context.assetFor( test );

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

  a.appStartNonThrowing({ args : [ 'Hello.test.js',  'beeping:0' ] })
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

  a.appStartNonThrowing({ args : [ 'Hello.test.js',  'beeping:0', 'fails:1' ] })
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
  let context = this;
  let a = context.assetFor( test );

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

function requireTesting( test )
{
  let context = this;
  let a = context.assetFor( test );

  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:5 s:0'
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run **` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* - */

  return a.ready;
}

requireTesting.description =
`
- require( 'wTesting' ) returns proper namespace
`

//

function noTestCheck( test )
{
  let context = this;
  let a = context.assetFor( test );
  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run **'
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run **` })
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

function noTestSuite( test )
{
  let context = this;
  let a = context.assetFor( test, false );

  a.fileProvider.dirMake( a.routinePath );

  a.ready
  .then( () =>
  {
    test.case = 'relative path'
    return null;
  })

  a.appStartNonThrowing({ args : 'proto' })
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

  a.appStartNonThrowing({ args : 'proto/wtools' })
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

  a.appStartNonThrowing({ args : 'proto/**' })
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

  a.appStartNonThrowing({ args : a.path.nativize( a.abs( '.' ) ) })
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

  a.appStartNonThrowing({ args : a.path.nativize( a.abs( '**' ) ) })
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

  a.appStartNonThrowing({ args : a.abs( '.' ) })
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

  a.appStartNonThrowing({ args : '.run ' + a.abs( '.' ) })
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

  a.appStartNonThrowing({ args : 'n:1' })
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

  a.appStartNonThrowing({ args : '.run n:1' })
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

// --
// options
// --

function optionSuite( test )
{
  let context = this;
  let a = context.assetFor( test );

  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run **'
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run **` })
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

  a.appStartNonThrowing({ execPath : `.run ** suite:OptionSuiteA1` })
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

  a.appStartNonThrowing({ execPath : `.run ** suite:*A*` })
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

function optionAccuracyExplicitly( test )
{
  let context = this;
  let a = context.assetFor( test );

  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run **';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run **` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `routine1.accuracy : ${_.accuracy*_.accuracy}` ), 1 );
    test.identical( _.strCount( got.output, `routine2.accuracy : ${_.accuracy*1e-1}` ), 1 );
    test.identical( _.strCount( got.output, `routine3.accuracy : ${Math.sqrt( _.accuracy )}` ), 1 );
    test.identical( _.strCount( got.output, `routine4.accuracy : 10` ), 1 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** accuracy:1e-10';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** accuracy:1e-10` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `routine1.accuracy : ${_.accuracy*_.accuracy}` ), 1 );
    test.identical( _.strCount( got.output, `routine2.accuracy : 1e-10` ), 1 );
    test.identical( _.strCount( got.output, `routine3.accuracy : ${_.accuracy*10}` ), 1 );
    test.identical( _.strCount( got.output, `routine4.accuracy : 1e-10` ), 1 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** accuracy:0.01';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** accuracy:0.01` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `routine1.accuracy : ${_.accuracy*_.accuracy}` ), 1 );
    test.identical( _.strCount( got.output, `routine2.accuracy : ${_.accuracy*1e-1}` ), 1 );
    test.identical( _.strCount( got.output, `routine3.accuracy : ${Math.sqrt( _.accuracy )}` ), 1 );
    test.identical( _.strCount( got.output, `routine4.accuracy : 0.01` ), 1 );

    return null;
  })

  /* - */

  return a.ready;
}

optionAccuracyExplicitly.description =
`
- option accuracy of test routine change accuracy of test routine
- option accuracy of test routine could be range
`

//

function optionAccuracy( test )
{
  let context = this;
  let a = context.assetFor( test );

  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run **';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run **` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `routine1.accuracy : ${_.accuracy*_.accuracy}` ), 1 );
    test.identical( _.strCount( got.output, `routine2.accuracy : ${_.accuracy*_.accuracy}` ), 1 );
    test.identical( _.strCount( got.output, `routine3.accuracy : ${_.accuracy*10}` ), 1 );
    test.identical( _.strCount( got.output, `routine4.accuracy : ${_.accuracy}` ), 1 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** accuracy:1e-10';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** accuracy:1e-10` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `routine1.accuracy : ${_.accuracy*_.accuracy}` ), 1 );
    test.identical( _.strCount( got.output, `routine2.accuracy : 1e-10` ), 1 );
    test.identical( _.strCount( got.output, `routine3.accuracy : ${_.accuracy*10}` ), 1 );
    test.identical( _.strCount( got.output, `routine4.accuracy : 1e-10` ), 1 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** accuracy:0.01';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** accuracy:0.01` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `routine1.accuracy : ${_.accuracy*_.accuracy}` ), 1 );
    test.identical( _.strCount( got.output, `routine2.accuracy : ${_.accuracy*1e-1}` ), 1 );
    test.identical( _.strCount( got.output, `routine3.accuracy : ${Math.sqrt( _.accuracy )}` ), 1 );
    test.identical( _.strCount( got.output, `routine4.accuracy : 0.01` ), 1 );

    return null;
  })

  /* - */

  return a.ready;
}

optionAccuracy.description =
`
- option accuracy of test routine change accuracy of test routine
- option accuracy of test routine could be range
`

//

function optionRapidityAndSourceCode( test )
{
  let context = this;
  let a = context.assetFor( test );

  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:8 rapidity:-9';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:8 rapidity:-9` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `Passed TestSuite::optionRapidityAndSourceCode / TestRoutine::routine1` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::optionRapidityAndSourceCode / TestRoutine::routine2` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::optionRapidityAndSourceCode / TestRoutine::routine3` ), 1 );

    test.identical( _.strCount( got.output, `function routine1( test )` ), 1 );
    test.identical( _.strCount( got.output, `function routine2( test )` ), 0 );
    test.identical( _.strCount( got.output, `function routine3( test )` ), 1 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:8 rapidity:-9 r:routine2';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:8 rapidity:-9 r:routine2` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `Passed TestSuite::optionRapidityAndSourceCode / TestRoutine::routine1` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::optionRapidityAndSourceCode / TestRoutine::routine2` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::optionRapidityAndSourceCode / TestRoutine::routine3` ), 0 );

    test.identical( _.strCount( got.output, `function routine1( test )` ), 0 );
    test.identical( _.strCount( got.output, `function routine2( test )` ), 1 );
    test.identical( _.strCount( got.output, `function routine3( test )` ), 0 );

    return null;
  })

  /* - */

  return a.ready;
}

optionRapidityAndSourceCode.description =
`
- rapidity below zero switch off usingSourceCode
- but if option routine used then rapidity does not swtich off usingSourceCode
`

//

function optionRapidity( test )
{
  let context = this;
  let a = context.assetFor( test, 'optionRapidity' );

  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:8 rapidity:-9';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:8 rapidity:-9` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity1` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity2` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity3` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity4` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity5` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity6` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity7` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity8` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity9` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity ` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity0` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity3` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity4` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity5` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity6` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity7` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity8` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity9` ), 1 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:8 rapidity:-8';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:8 rapidity:-8` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity1` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity2` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity3` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity4` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity5` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity6` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity7` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity8` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity9` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity ` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity0` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity3` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity4` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity5` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity6` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity7` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity8` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity9` ), 1 );


    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:8 rapidity:-5';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:8 rapidity:-5` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity1` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity2` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity3` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity4` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity5` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity6` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity7` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity8` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity9` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity ` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity0` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity3` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity4` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity5` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity6` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity7` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity8` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity9` ), 1 );


    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:8 rapidity:-3';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:8 rapidity:-3` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity1` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity2` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity3` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity4` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity5` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity6` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity7` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity8` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity9` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity ` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity0` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity3` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity4` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity5` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity6` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity7` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity8` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity9` ), 1 );


    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:8 rapidity:-1';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:8 rapidity:-1` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity1` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity2` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity3` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity4` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity5` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity6` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity7` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity8` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity9` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity ` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity0` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity3` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity4` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity5` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity6` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity7` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity8` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity9` ), 1 );


    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:8 rapidity:0';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:8 rapidity:0` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity1` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity2` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity3` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity4` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity5` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity6` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity7` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity8` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity9` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity ` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity0` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity3` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity4` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity5` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity6` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity7` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity8` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity9` ), 1 );


    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:8';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:8` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity1` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity2` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity3` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity4` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity5` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity6` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity7` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity8` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity9` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity ` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity0` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity3` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity4` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity5` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity6` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity7` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity8` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity9` ), 1 );


    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:8 rapidity:1';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:8 rapidity:1` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity1` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity2` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity3` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity4` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity5` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity6` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity7` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity8` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity9` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity ` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity0` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity3` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity4` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity5` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity6` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity7` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity8` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity9` ), 1 );


    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:8 rapidity:3';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:8 rapidity:3` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity1` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity2` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity3` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity4` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity5` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity6` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity7` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity8` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity9` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity ` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity0` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity3` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity4` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity5` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity6` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity7` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity8` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity9` ), 1 );


    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:8 rapidity:5';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:8 rapidity:5` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity1` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity2` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity3` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity4` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity5` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity6` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity7` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity8` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity9` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity ` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity0` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity3` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity4` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity5` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity6` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity7` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity8` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity9` ), 1 );


    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:8 rapidity:8';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:8 rapidity:8` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity1` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity2` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity3` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity4` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity5` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity6` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity7` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity8` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity9` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity ` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity0` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity3` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity4` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity5` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity6` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity7` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity8` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity9` ), 1 );


    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:8 rapidity:9';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:8 rapidity:9` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity1` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity2` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity3` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity4` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity5` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity6` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity7` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity8` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity9` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity ` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity0` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity3` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity4` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity5` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity6` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity7` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity8` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity9` ), 1 );


    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:8 rapidity:-11';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:8 rapidity:-11` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity1` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity2` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity3` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity4` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity5` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity6` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity7` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity8` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity9` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity ` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity0` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity3` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity4` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity5` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity6` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity7` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity8` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity9` ), 1 );


    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:8 rapidity:11';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:8 rapidity:11` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity1` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity2` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity3` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity4` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity5` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity6` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity7` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity8` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity9` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity ` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity0` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity3` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity4` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity5` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity6` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity7` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity8` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity9` ), 0 );


    return null;
  })

  /* - */

  return a.ready;
}

optionRapidity.timeOut = 900000;

//

function optionRapidityTwice( test )
{

  let context = this;
  let a = context.assetFor( test, 'optionRapidity' );

  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:8 rapidity:3 rapidity:-3';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:8 rapidity:3 rapidity:-3` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity1` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity2` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity3` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity4` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity5` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity6` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity7` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity8` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity9` ), 0 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity ` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity0` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity3` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity4` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity5` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity6` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity7` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity8` ), 1 );
    test.identical( _.strCount( got.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity9` ), 1 );

    return null;
  })
  /* - */

  return a.ready;
}

// --
// commands
// --

function help( test )
{
  let context = this;
  let a = context.assetFor( test, false );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* */

  a.ready
  .then( ( got ) =>
  {

    test.case = 'simple run without args'

    return null;
  })

  a.appStartNonThrowing( '' )

  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );
    test.is( got.output.length > 0 );
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

  a.appStartNonThrowing( '.' )

  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );
    test.is( got.output.length > 0 );
    test.ge( _.strLinesCount( got.output ), 8 );
    return null;
  })

  /* */

  a.appStartNonThrowing({ execPath : '.help' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.ge( _.strLinesCount( op.output ), 23 );
    return op;
  })

  /* */

  a.appStartNonThrowing({ execPath : '.' })
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.ge( _.strLinesCount( op.output ), 8 );
    return op;
  })

  /* */

  a.appStartNonThrowing({ args : [] })
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
  let context = this;
  let a = context.assetFor( test, false );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* */

  a.appStartNonThrowing( '.version' )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.is( _.strHas( op.output, /Current version : .*\..*\..*/ ) );
    test.is( _.strHas( op.output, /Latest version of wTesting!alpha : .*\..*\..*/ ) );
    return op;
  })

  return a.ready;
}

// --
// time out
// --

function asyncTimeOutSingle( test )
{
  let context = this;
  let a = context.assetFor( test );
  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'Suite.test.js'
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run Suite.test.js` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 1 error' ), 2 );
    test.identical( _.strCount( got.output, 'Thrown' ), 2 );
    test.identical( _.strCount( got.output, 'failed, time out' ), 0 );
    test.identical( _.strCount( got.output, 'failed, test routine time limit' ), 0 );
    test.identical( _.strCount( got.output, 'failed, time limit' ), 0 );
    test.identical( _.strCount( got.output, 'Passed test checks 0 / 1' ), 2 );
    test.identical( _.strCount( got.output, 'Failed ( test routine time limit )' ), 1 );
    test.identical( _.strCount( got.output, 'Failed ( test routine time limit ) TestSuite::AsyncTimeOutAsset / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( got.output, 'test routine has passed none test check' ), 0 );
    test.identical( _.strCount( got.output, 'cant continue' ), 0 );
    test.identical( _.strCount( got.output, 'unchaught' ), 0 );
    test.identical( _.strCount( got.output, 'Unchaught' ), 0 );
    test.identical( _.strCount( got.output, 'terminated by user' ), 0 );
    test.identical( _.strCount( got.output, 'routine1.' ), 1 );
    test.identical( _.strCount( got.output, 'routine1.1' ), 1 );
    test.identical( _.strCount( got.output, 'routine1.2' ), 0 );
    test.identical( _.strCount( got.output, 'routine1.3' ), 0 );

    return null;
  })

  /* - */

  return a.ready;
}

//

function asyncTimeOutTwo( test )
{
  let context = this;
  let a = context.assetFor( test );
  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'Suite.test.js'
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run Suite.test.js` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown' ), 2 );
    test.identical( _.strCount( got.output, 'Thrown 1 error' ), 2 );
    test.identical( _.strCount( got.output, 'failed, time out' ), 0 );
    test.identical( _.strCount( got.output, 'failed, test routine time limit' ), 0 );
    test.identical( _.strCount( got.output, 'failed, time limit' ), 0 );
    test.identical( _.strCount( got.output, 'Failed ( test routine time limit )' ), 1 );
    test.identical( _.strCount( got.output, 'Passed test checks 1 / 2' ), 2 );
    test.identical( _.strCount( got.output, 'Failed ( test routine time limit ) TestSuite::AsyncTimeOutAsset / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( got.output, 'test routine has passed none test check' ), 0 );
    test.identical( _.strCount( got.output, 'cant continue' ), 0 );
    test.identical( _.strCount( got.output, 'unchaught' ), 0 );
    test.identical( _.strCount( got.output, 'Unchaught' ), 0 );
    test.identical( _.strCount( got.output, 'terminated by user' ), 0 );
    test.identical( _.strCount( got.output, 'TestRoutine::routine1 is ended' ), 0 );
    test.identical( _.strCount( got.output, 'time limit' ), 1 );
    test.identical( _.strCount( got.output, 'Failed ( test routine time limit )' ), 1 );
    test.identical( _.strCount( got.output, 'is ended because of time limit' ), 0 );
    test.identical( _.strCount( got.output, 'several' ), 1 );
    test.identical( _.strCount( got.output, 'several async returning' ), 0 );
    test.identical( _.strCount( got.output, 'Launching several' ), 1 );
    test.identical( _.strCount( got.output, '= Message of error' ), 0 );
    test.identical( _.strCount( got.output, 'stack' ), 0 );
    test.identical( _.strCount( got.output, 'Stack' ), 0 );

    test.identical( _.strCount( got.output, 'routine1.' ), 3 );
    test.identical( _.strCount( got.output, 'routine1.1' ), 1 );
    test.identical( _.strCount( got.output, 'routine1.2' ), 1 );
    test.identical( _.strCount( got.output, 'routine1.3' ), 1 );

    test.identical( _.strCount( got.output, 'routine2.' ), 3 );
    test.identical( _.strCount( got.output, 'routine2.1' ), 1 );
    test.identical( _.strCount( got.output, 'routine2.2' ), 1 );
    test.identical( _.strCount( got.output, 'routine2.3' ), 1 );

    return null;
  })

  /* - */

  return a.ready;
}

//

function asyncTimeOutCheck( test )
{
  let context = this;
  let a = context.assetFor( test );
  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run Suite.test.js'
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run Suite.test.js` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 1 error' ), 2 );
    test.identical( _.strCount( got.output, 'Thrown' ), 2 );
    test.identical( _.strCount( got.output, 'failed, time out' ), 0 );
    test.identical( _.strCount( got.output, 'Passed test checks 2 / 3' ), 2 );
    test.identical( _.strCount( got.output, 'Failed ( test routine time limit )' ), 1 );

    test.identical( _.strCount( got.output, 'Test check ( TestSuite::AsyncTimeOutAsset / TestRoutine::routine1 /  < description1 # 2 ) ... failed, test routine time limit' ), 1 );
    test.identical( _.strCount( got.output, 'Test check ( TestSuite::AsyncTimeOutAsset / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( got.output, 'failed, test routine time limit' ), 1 );
    test.identical( _.strCount( got.output, 'failed, time limit' ), 0 );
    test.identical( _.strCount( got.output, 'Failed ( test routine time limit ) TestSuite::AsyncTimeOutAsset / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( got.output, 'test routine has passed none test check' ), 0 );
    test.identical( _.strCount( got.output, 'cant continue' ), 0 );
    test.identical( _.strCount( got.output, 'unchaught' ), 0 );
    test.identical( _.strCount( got.output, 'Unchaught' ), 0 );
    test.identical( _.strCount( got.output, 'terminated by user' ), 0 );

    test.identical( _.strCount( got.output, 'routine1.' ), 2 );
    test.identical( _.strCount( got.output, 'routine1.1' ), 1 );
    test.identical( _.strCount( got.output, 'routine1.2' ), 1 );
    test.identical( _.strCount( got.output, 'routine1.3' ), 0 );
    test.identical( _.strCount( got.output, 'routine2.' ), 3 );
    test.identical( _.strCount( got.output, 'routine2.1' ), 1 );
    test.identical( _.strCount( got.output, 'routine2.2' ), 1 );
    test.identical( _.strCount( got.output, 'routine2.3' ), 1 );

    return null;
  })

  /* - */

  return a.ready;
}

// //
//
// function routine1( test )
// {
//   test.description = 'description1';
//   console.log( 'v0' );
//   test.identical( 1, 1 );
//   test.description = 'description2';
//   _.time.out( 2000 );
//   _.time.out( 1000, () =>
//   {
//     console.log( 'v1' ); debugger;
//     test.identical( 1, 1 );
//     test.equivalent( 1, 1 );
//     test.is( true );
//     test.ge( 5, 0 );
//     console.log( 'v2' );
//   });
//   return _.time.out( 2000 );
// }
//
// routine1.timeOut = 100;

//

function checksAfterTimeOut( test )
{
  let context = this;
  let a = context.assetFor( test );
  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:5'
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:5` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 2 error' ), 2 );
    test.identical( _.strCount( got.output, 'Thrown' ), 2 );
    test.identical( _.strCount( got.output, 'failed, time out' ), 0 );
    test.identical( _.strCount( got.output, 'TestRoutine::routine1 returned, cant continue!' ), 1 );
    test.identical( _.strCount( got.output, 'returned, cant continue!' ), 1 );
    test.identical( _.strCount( got.output, 'Passed test checks 2 / 3' ), 2 );
    test.identical( _.strCount( got.output, 'Passed test routines 1 / 2' ), 2 );
    test.identical( _.strCount( got.output, 'test routine has passed none test check' ), 0 );
    test.identical( _.strCount( got.output, 'failed' ), 2 );
    test.identical( _.strCount( got.output, 'Failed' ), 1 );
    test.identical( _.strCount( got.output, 'Time out' ), 0 );
    test.identical( _.strCount( got.output, 'Time out!' ), 0 );

    test.identical( _.strCount( got.output, 'Test check ( TestSuite::ChecksAfterTimeOutAsset / TestRoutine::routine1 /  < description1 # 1 ) ... ok' ), 1 );
    test.identical( _.strCount( got.output, 'Failed ( test routine time limit ) TestSuite::ChecksAfterTimeOutAsset / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::ChecksAfterTimeOutAsset / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( got.output, 'Test check' ), 2 );

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
  let context = this;
  let a = context.assetFor( test );
  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:5'
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:5` })
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
  let context = this;
  let a = context.assetFor( test );
  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'tst .run ** v:5'
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:5` })
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Waiting for' ), 0 );
    test.identical( _.strCount( op.output, 'procedure::' ), 0 );
    test.identical( _.strCount( op.output, 'v1' ), 1 );
    test.identical( _.strCount( op.output, 'v2' ), 1 );
    test.identical( _.strCount( op.output, 'v3' ), 1 );
    test.identical( _.strCount( op.output, 'v4' ), 0 );
    test.identical( _.strCount( op.output, 'v5' ), 0 );
    var exp =
`v1
v2
v3`
    test.identical( _.strCount( op.output, exp ), 1 );

    return null;
  })

  /* - */

  a.ready
  .then( () =>
  {
    test.case = 'node .run ** v:5'
    return null;
  })

  a.shellNonThrowing({ execPath : `node Suite.test.js v:5` })
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Waiting for' ), 0 );
    test.identical( _.strCount( op.output, 'procedure::' ), 0 );
    test.identical( _.strCount( op.output, 'v1' ), 1 );
    test.identical( _.strCount( op.output, 'v2' ), 1 );
    test.identical( _.strCount( op.output, 'v3' ), 1 );
    test.identical( _.strCount( op.output, 'v4' ), 0 );
    test.identical( _.strCount( op.output, 'v5' ), 0 );
    var exp =
`v1
v2
v3`
    test.identical( _.strCount( op.output, exp ), 1 );

    return null;
  })

  /* - */

  return a.ready;
}

//

function timeOutSeveralRoutines( test ) /* xxx : implement similar test routine with deasync */
{
  let context = this;
  let a = context.assetFor( test, false );
  let programPath = a.program({ routine : program1 });
  let ready = _.Consequence().take( null );

  /* */

  ready.then( function( arg )
  {
    test.case = 'basic';
    a.forkNonThrowing
    ({
      execPath : programPath,
    })
    .tap( ( err, op ) =>
    {
      test.identical( _.strCount( op.output, 'uncaught error' ), 0 );
      test.identical( _.strCount( op.output, 'Terminated by user' ), 0 );

      test.identical( _.strCount( op.output, 'Failed ( test routine time limit ) TestSuite::ForTesting / TestRoutine::routine1' ), 1 );
      test.identical( _.strCount( op.output, 'Passed TestSuite::ForTesting / TestRoutine::routine2' ), 1 );
      test.identical( _.strCount( op.output, 'Test routine TestSuite::ForTesting / TestRoutine::routine1 returned, cant continue!' ), 1 );
      test.identical( _.strCount( op.output, 'Passed TestSuite::ForTesting / TestRoutine::routine3' ), 1 );
      test.identical( _.strCount( op.output, 'Passed TestSuite::ForTesting / TestRoutine::routine4' ), 1 );
      test.identical( _.strCount( op.output, 'Passed test routines 3 / 4' ), 2 );

      // test.identical( _.lexParse( op.output, '(-::routine1-)**(-::routine2-)**(-::routine3-)**(-::routine4-)' ).ok, true ); /* xxx : implement and uncomment */

      test.notIdentical( op.exitCode, 0 );
    });
    return a.ready;
  });

  /* */

  return ready;

  /* - */

  function program1()
  {
    let _ = require( toolsPath );
    _.include( 'wTesting' );

    function routine1( test )
    {
      test.is( true );
      _.time.begin( context.t2*4, () =>
      {
        console.log( 'routine1:time1' );
        test.is( true );
        console.log( 'routine1:time2' );
      });
      return _.time.out( context.t2*3 );
    }

    function routine2( test )
    {
      test.is( true );
      return _.time.out( context.t2 );
    }

    function routine3( test )
    {
      test.is( true );
      return _.time.out( context.t2 );
    }

    function routine4( test )
    {
      test.is( true );
      return _.time.out( context.t2 );
    }

    let Self =
    {
      routineTimeOut : context.t2*2,
      name : 'ForTesting',
      tests :
      {
        routine1,
        routine2,
        routine3,
        routine4,
      }
    }

    Self = wTestSuite( Self );
    wTester.test( Self.name );
  }

}

timeOutSeveralRoutines.description =
`
  - time out of one test routine does not halt testing
  - time out of one test routine does not prevent other test routines to run
`

//

function timeOutSeveralRoutinesDesync( test ) /* xxx : implement similar test routine with deasync */
{
  let context = this;
  let a = context.assetFor( test, false );
  let programPath = a.program({ routine : program1 });
  let ready = _.Consequence().take( null );

  /* */

  ready.then( function( arg )
  {
    test.case = 'basic';
    a.forkNonThrowing
    ({
      execPath : programPath,
    })
    .tap( ( err, op ) =>
    {
      test.identical( _.strCount( op.output, 'uncaught error' ), 0 );
      test.identical( _.strCount( op.output, 'Terminated by user' ), 0 );

      test.identical( _.strCount( op.output, 'Failed ( test routine time limit ) TestSuite::ForTesting / TestRoutine::routine1' ), 1 );
      test.identical( _.strCount( op.output, 'Passed TestSuite::ForTesting / TestRoutine::routine2' ), 1 );
      test.identical( _.strCount( op.output, 'Test routine TestSuite::ForTesting / TestRoutine::routine1 returned, cant continue!' ), 1 );
      test.identical( _.strCount( op.output, 'Passed TestSuite::ForTesting / TestRoutine::routine3' ), 1 );
      test.identical( _.strCount( op.output, 'Passed TestSuite::ForTesting / TestRoutine::routine4' ), 1 );
      test.identical( _.strCount( op.output, 'Passed test routines 3 / 4' ), 2 );

      test.notIdentical( op.exitCode, 0 );
    });
    return a.ready;
  });

  /* */

  return ready;

  /* - */

  function program1()
  {
    let _ = require( toolsPath );
    _.include( 'wTesting' );

    function routine1( test )
    {
      test.is( true );
      _.time.begin( context.t2*4, () =>
      {
        console.log( 'routine1:time1' );
        test.is( true );
        console.log( 'routine1:time2' );
      });
      _.time.out( context.t2*3 ).deasync();
      test.is( true );
    }

    function routine2( test )
    {
      test.is( true );
      return _.time.out( context.t2 );
    }

    function routine3( test )
    {
      test.is( true );
      return _.time.out( context.t2 );
    }

    function routine4( test )
    {
      test.is( true );
      return _.time.out( context.t2 );
    }

    let Self =
    {
      routineTimeOut : context.t2*2,
      name : 'ForTesting',
      tests :
      {
        routine1,
        routine2,
        routine3,
        routine4,
      }
    }

    Self = wTestSuite( Self );
    wTester.test( Self.name );
  }

}

timeOutSeveralRoutinesDesync.description =
`
  - time out of one test routine does not halt testing
  - time out of one test routine does not prevent other test routines to run
  - deasync is used in timed out test routine
`

// --
// events
// --

function onSuiteEndReturnConsequence( test )
{
  let context = this;
  let a = context.assetFor( test, 'onSuiteEnd' );
  a.reflect();

  /* - */

  a.appStartNonThrowing({ execPath : `TimeOutInOnSuiteEnd.test.js` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 1 error' ), 2 );
    test.identical( _.strCount( got.output, 'Time out!' ), 1 );
    return null;
  })

  a.appStartNonThrowing({ execPath : `ErrorMessageByConsequence.test.js` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 1 error' ), 2 );
    test.identical( _.strCount( got.output, 'Test error' ), 2 );
    return null;
  })

  a.appStartNonThrowing({ execPath : `NormalMessageByConsequence.test.js` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    test.identical( _.strCount( got.output, 'error' ), 0 );
    test.identical( _.strCount( got.output, /Testing \.\.\. in .* \.\.\. ok/g ), 1 );
    return null;
  })

  a.appStartNonThrowing({ execPath : `DelayedMessageByConsequence.test.js` })
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

//

function onSuiteEndIsExecutedOnceOnSigintEarly( test )
{
  let context = this;
  let a = context.assetFor( test, 'onSuiteEnd' );
  a.reflect();

  /* - */

  let o =
  {
    execPath : `IsExecutedOnceOnSigint.test.js`,
    outputPiping : 1,
    ipc : 1
  }

  a.appStartNonThrowing( o )

  o.conStart.then( () =>
  {
    o.process.send( 'SIGINT' );
    return null;
  })

  o.conTerminate.then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Terminated by user' ), 1 );
    test.identical( _.strCount( got.output, 'Executing onSuiteEnd' ), 1 );
    test.identical( _.strCount( got.output, 'Error in suite.onSuiteEnd' ), 0 );
    test.identical( _.strCount( got.output, 'Thrown 1 error' ), 2 );
    return null;
  })

  /* - */

  return a.ready;
}

onSuiteEndIsExecutedOnceOnSigintEarly.description =
`
  - Test suite uses deasync in onSuiteEnd handler.
  - User terminates test run after short delay, early!
  - Callback onSuiteEnd handler should be executed only once.
`

//

function onSuiteEndIsExecutedOnceOnSigintLate( test )
{
  let context = this;
  let a = context.assetFor( test, 'onSuiteEnd' );
  a.reflect();

  /* - */

  let o =
  {
    execPath : `IsExecutedOnceOnSigint.test.js`,
    outputPiping : 1,
    ipc : 1
  }

  a.appStartNonThrowing( o )

  o.conStart.then( () =>
  {
    /* time delay should be exactly 5s to match delay in test asset */
    _.time.out( 5000, () => o.process.send( 'SIGINT' ) ); /* qqq : parametrize time delays */
    return null;
  })

  o.conTerminate.then( ( got ) => /* qqq : then( ( got ) -> then( ( op ) or then( ( arg ) */
  {
    test.notIdentical( got.exitCode, 0 );
    test.identical( _.strCount( got.output, 'Terminated by user' ), 1 );
    test.identical( _.strCount( got.output, 'Executing onSuiteEnd' ), 1 );
    test.identical( _.strCount( got.output, 'Error in suite.onSuiteEnd' ), 0 );
    test.identical( _.strCount( got.output, 'Thrown 1 error' ), 2 );
    test.identical( _.strCount( got.output, 'Thrown' ), 2 );
    return null;
  })

  /* - */

  return a.ready;
}

onSuiteEndIsExecutedOnceOnSigintLate.description =
`
  - Test suite uses deasync in onSuiteEnd handler.
  - User terminates test run after short delay, early!
  - Callback onSuiteEnd handler should be executed only once.
  - May not work on some machines because of races conditions!
`

//

function termination( test )
{
  let context = this;
  let a = context.assetFor( test, false );
  let file1Path = a.abs( 'File1' );
  let locals = { file1Path }
  let programPath = a.program({ routine : program1, locals });
  let ready = _.Consequence().take( null );

  /* */

  ready.then( function( arg )
  {
    test.case = 'throwing:1 errAttend:1 terminationBegin:1';
    let opts = { throwing : 1, errAttend : 1, terminationBegin : 1 };
    a.fileProvider.fileWrite({ filePath : file1Path, data : opts, encoding : 'json' });
    a.forkNonThrowing
    ({
      execPath : programPath,
      mode : 'fork',
    })
    .tap( ( err, op ) =>
    {
      test.identical( _.strCount( op.output, 'Waiting' ), 0 );
      test.identical( _.strCount( op.output, 'procedure::' ), 0 );
      test.identical( _.strCount( op.output, 'ncaught' ), 0 );
      test.identical( _.strCount( op.output, 'synchronous' ), 0 );
      test.identical( _.strCount( op.output, 'Time' ), 0 );
      test.identical( _.strCount( op.output, 'time' ), 0 );
      test.identical( _.strCount( op.output, 'Error' ), 1 );
      test.identical( _.strCount( op.output, 'error' ), 4 );
      test.identical( _.strCount( op.output, 'Error1' ), 1 );
      test.identical( _.strCount( op.output, 'Testing ...' ), 1 );
      test.identical( _.strCount( op.output, '... failed' ), 3 );
      test.identical( _.strCount( op.output, '... ok' ), 0 );
      test.identical( _.strCount( op.output, 'throwing error' ), 2 );
      test.notIdentical( op.exitCode, 0 );
    });
    return a.ready;
  });

  /* */

  ready.then( function( arg )
  {
    test.case = 'throwing:1 errAttend:1 terminationBegin:0';
    let opts = { throwing : 1, errAttend : 1, terminationBegin : 0 };
    a.fileProvider.fileWrite({ filePath : file1Path, data : opts, encoding : 'json' });
    a.forkNonThrowing
    ({
      execPath : programPath,
      mode : 'fork',
    })
    .tap( ( err, op ) =>
    {
      test.identical( _.strCount( op.output, 'Waiting' ), 0 );
      test.identical( _.strCount( op.output, 'procedure::' ), 0 );
      test.identical( _.strCount( op.output, 'ncaught' ), 0 );
      test.identical( _.strCount( op.output, 'synchronous' ), 0 );
      test.identical( _.strCount( op.output, 'Time' ), 0 );
      test.identical( _.strCount( op.output, 'time' ), 0 );
      test.identical( _.strCount( op.output, 'Error' ), 1 );
      test.identical( _.strCount( op.output, 'error' ), 4 );
      test.identical( _.strCount( op.output, 'Error1' ), 1 );
      test.identical( _.strCount( op.output, 'Testing ...' ), 1 );
      test.identical( _.strCount( op.output, '... failed' ), 3 );
      test.identical( _.strCount( op.output, '... ok' ), 0 );
      test.identical( _.strCount( op.output, 'throwing error' ), 2 );
      test.notIdentical( op.exitCode, 0 );
    });
    return a.ready;
  });

  /* */

  ready.then( function( arg )
  {
    test.case = 'throwing:1 errAttend:0 terminationBegin:0';
    let opts = { throwing : 1, errAttend : 0, terminationBegin : 0 };
    a.fileProvider.fileWrite({ filePath : file1Path, data : opts, encoding : 'json' });
    a.forkNonThrowing
    ({
      execPath : programPath,
      mode : 'fork',
    })
    .tap( ( err, op ) =>
    {
      test.identical( _.strCount( op.output, 'Waiting' ), 0 );
      test.identical( _.strCount( op.output, 'procedure::' ), 0 );
      test.identical( _.strCount( op.output, 'ncaught' ), 0 );
      test.identical( _.strCount( op.output, 'synchronous' ), 0 );
      test.identical( _.strCount( op.output, 'Error' ), 3 );
      test.identical( _.strCount( op.output, 'error' ), 7 );
      test.identical( _.strCount( op.output, 'Error1' ), 3 );
      test.identical( _.strCount( op.output, 'Testing ...' ), 1 );
      test.identical( _.strCount( op.output, '... failed' ), 3 );
      test.identical( _.strCount( op.output, '... ok' ), 0 );
      test.identical( _.strCount( op.output, 'throwing error' ), 2 );
      test.notIdentical( op.exitCode, 0 );
    });
    return a.ready;
  });

  /* */

  ready.then( function( arg )
  {
    test.case = 'throwing:0 errAttend:0 terminationBegin:0';
    let opts = { throwing : 0, errAttend : 0, terminationBegin : 0 };
    a.fileProvider.fileWrite({ filePath : file1Path, data : opts, encoding : 'json' });
    a.forkNonThrowing
    ({
      execPath : programPath,
      mode : 'fork',
    })
    .tap( ( err, op ) =>
    {
      test.identical( _.strCount( op.output, 'Waiting' ), 0 );
      test.identical( _.strCount( op.output, 'procedure::' ), 0 );
      test.identical( _.strCount( op.output, 'ncaught' ), 0 );
      test.identical( _.strCount( op.output, 'synchronous' ), 0 );
      test.identical( _.strCount( op.output, 'Error' ), 0 );
      test.identical( _.strCount( op.output, 'error' ), 0 );
      test.identical( _.strCount( op.output, 'Error1' ), 0 );
      test.identical( _.strCount( op.output, 'Testing ...' ), 1 );
      test.identical( _.strCount( op.output, '... failed' ), 0 );
      test.identical( _.strCount( op.output, '... ok' ), 2 );
      test.identical( _.strCount( op.output, 'throwing error' ), 0 );
      test.identical( op.exitCode, 0 );
    });
    return a.ready;
  });

  /* */

  return ready;

  /* - */

  function program1()
  {
    let _ = require( toolsPath );
    _.include( 'wTesting' );
    _ = _realGlobal_._testerGlobal_.wTools;
    let input = { map : _.fileProvider.fileRead({ filePath : _.path.join( __dirname, 'File1' ), encoding : 'json' }) };

    function routine1( test )
    {
      test.is( true );
      let con = new _.Consequence();
      _.time.out( context.t1, () =>
      {
        if( input.map.throwing )
        {
          if( input.map.errAttend )
          con.error( _.errAttend( 'Error1' ) );
          else
          con.error( 'Error1' );
        }
        else
        {
          con.take( null );
        }
      });
      con.tap( ( err, arg ) =>
      {
        if( input.map.terminationBegin )
        _.procedure.terminationBegin();
      });
      return con;
    }

    let Self =
    {
      name : 'xxx : make working without name',
      routineTimeOut : context.t1*100,
      tests :
      {
        routine1,
      }
    }

    Self = wTestSuite( Self );
    wTester.test( Self.name );
    // wTestSuite( Self ).run(); // xxx : make it working
  }

}

termination.description =
`
  - process terminates even if consequence recieves attended error
  - process terminates even if consequence recieves unattended error
  - process terminates even if consequence recieves argument
`

//

function manualTermination( test )
{
  let context = this;
  let a = context.assetFor( test, 'manualTermination' );
  a.reflect();

  /* - */

  let o =
  {
    execPath : `${a.abs( 'manualTermination.test.js' )} v:7`,
  };
  a.appStartNonThrowing( o )

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
  onSuiteEnd handler should be executed before exit event
`

//

function uncaughtErrorNotSilenced( test )
{
  let context = this;
  let a = context.assetFor( test, false );
  let programPath = a.program({ routine : program1 });
  let ready = _.Consequence().take( null );

  /* */

  ready.then( function( arg )
  {
    test.case = 'basic';
    a.forkNonThrowing
    ({
      execPath : programPath,
      args : [ 'silencing:1' ],
      mode : 'fork',
    })
    .tap( ( err, op ) =>
    {
      test.identical( _.strCount( op.output, 'uncaught error' ), 2 );
      test.identical( _.strCount( op.output, 'Terminated by user' ), 0 );
      test.notIdentical( op.exitCode, 0 );
    });
    return a.ready;
  });

  /* */

  return ready;

  /* - */

  function program1()
  {
    let _ = require( toolsPath );
    _.include( 'wTesting' );

    function routine1( test )
    {
      _.time.begin( 1, () => _.error._handleUncaught2({ err : 'Error1' }) );
    }

    let Self =
    {
      tests :
      {
        routine1,
      }
    }

    Self = wTestSuite( Self );
    wTester.test( Self.name );
  }

}

uncaughtErrorNotSilenced.description = /* qqq : extend the test */
`
  - uncaught error should not be silenced event if silencing:1
`

//

function asyncErrorHandling( test )
{
  let context = this;
  let a = context.assetFor( test, 'asyncErrorHandling' );
  a.reflect();

  /* - */

  let o =
  {
    execPath : `${a.abs( 'asyncErrorHandling.test.js' )} v:7`,
  };
  a.appStartNonThrowing( o )

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

// --
// test asset
// --

function programOptionsRoutineDirPath( test )
{
  let context = this;
  let a = context.assetFor( test, false );

  test.case = 'default'
  var got = a.program( testApp1 );
  var exp = a.path.nativize( a.path.join( a.routinePath, testApp1.name + '.js' ) )
  test.il( got, exp )

  test.case = 'options : routine, dirPath'
  var got = a.program({ routine : testApp1, dirPath : 'temp' })
  var exp = a.path.nativize( a.path.join( a.routinePath, 'temp', testApp1.name + '.js' ) )
  test.il( got, exp )

  test.case = 'options : routine, dirPath with spaces'
  var got = a.program({ routine : testApp1, dirPath : 'temp with spaces' });
  var exp = a.path.nativize( a.path.join( a.routinePath, 'temp with spaces', testApp1.name + '.js' ) )
  test.il( got, exp )

  /* - */

  function testApp1(){}

}

// --
// related
// --

function timeLimitConsequence( test )
{
  let t = 25;
  let ready = new _.Consequence().take( null )

  /* */

  .thenKeep( function timeLimit1( arg )
  {
    test.case = 'timeOut timeLimit a timeLimitOut';

    var con = _.time.out( Number( t ) );
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

// --
// suite
// --

let Self =
{

  name : 'Tools.Tester.Ext',
  silencing : 1,
  enabled : 1,

  onSuiteBegin,
  onSuiteEnd,
  routineTimeOut : 300000,

  context :
  {

    assetFor,

    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null,

    t1 : 100,
    t2 : 1000,
    t3 : 10000,

  },

  tests :
  {

    // conditions

    run,
    runWithQuotedPath,
    checkFails,
    double,
    requireTesting,
    noTestCheck,
    noTestSuite,

    // options

    optionSuite,
    optionAccuracyExplicitly,
    optionAccuracy,
    optionRapidityAndSourceCode,
    optionRapidity,
    optionRapidityTwice,

    // commands

    help,
    version,

    // time out

    asyncTimeOutSingle,
    asyncTimeOutTwo,
    asyncTimeOutCheck,
    checksAfterTimeOut,
    checksAfterTimeOutSilenced,
    timeOutExternalMessage,
    timeOutSeveralRoutines,
    timeOutSeveralRoutinesDesync,

    // events

    onSuiteEndReturnConsequence,
    onSuiteEndIsExecutedOnceOnSigintEarly,
    onSuiteEndIsExecutedOnceOnSigintLate,

    // termination

    termination,
    manualTermination,
    uncaughtErrorNotSilenced,
    asyncErrorHandling,

    // test asset

    programOptionsRoutineDirPath,

    // related

    timeLimitConsequence,

  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
