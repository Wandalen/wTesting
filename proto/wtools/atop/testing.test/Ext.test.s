( function _Ext_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );
  require( '../testing/entry/Basic.s' );
  _.include( 'wProcess' );
  _.include( 'wFiles' );
  _.include( 'wConsequence' );
}

const _global = _global_;
const _ = _global_.wTools;
const __ = _globals_.testing.wTools;

/* qqq : parametrize delays */

// --
// context
// --

function onSuiteBegin()
{
  let context = this;

  context.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..'  ), 'Tester' );
  context.assetsOriginalPath = _.path.join( __dirname, '_asset' );
  context.appJsPath = _.path.nativize( _.path.join( _.path.normalize( __dirname ), '../testing/entry/Exec' ) );

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
  a.program = _.routine.uniteCloning_replaceByUnite( a.program.head, program_body );
  a.reflect = reflect;

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

  function reflect()
  {
    let reflected = a.fileProvider.filesReflect
    ({
      reflectMap : { [ a.originalAssetPath ] : a.routinePath },
      onUp,
      outputFormat : 'record'
    });

    reflected.forEach( ( r ) =>
    {
      if( !_.longHasAny( [ 'js', 's', 'ts' ], r.dst.ext ) )
      return;
      // if( r.dst.ext !== 'js' && r.dst.ext !== 's' )
      // return;
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
  test.true( a.fileProvider.fileExists( a.abs( 'Hello.test.js' ) ) );

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
    test.nil( op.exitCode, 0 );

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
    test.nil( op.exitCode, 0 );

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
    test.nil( op.exitCode, 0 );

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
    test.nil( op.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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

function run( test )
{
  let context = this;
  let a = context.assetFor( test, 'hello' );

  a.reflect();
  test.true( a.fileProvider.fileExists( a.abs( 'Hello.test.js' ) ) );

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
    test.nil( op.exitCode, 0 );

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
    test.nil( op.exitCode, 0 );

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
    test.nil( op.exitCode, 0 );

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
    test.nil( op.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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

function runDebugTst( test )
{
  let context = this;
  let a = context.assetFor( test, 'hello' );
  let con = _.take( null );
  a.reflect();

  /* */

  con.then( () =>
  {
    test.case = 'tst.debug .help';

    var debugWillPath = a.abs( __dirname, '../testing/entry/ExecDebug' );
    var o =
    {
      execPath : debugWillPath + ' .help',
      currentPath : a.routinePath,
      outputCollecting : 1,
      throwingExitCode : 0,
      outputGraying : 1,
      ready : a.ready,
      mode : 'fork',
    };
    _.process.start( o );

    return a.ready.then( ( op ) =>
    {
      if( op.exitCode === 0 )
      {
        test.description = 'utility debugnode exists';
        test.identical( _.strCount( op.output, 'Command ".help"' ), 1 );
        test.identical( _.strCount( op.output, '.help - Get help.' ), 1 );
        test.identical( _.strCount( op.output, '.imply - Change state or imply value of a variable.' ), 1 );
      }
      else
      {
        test.description = 'utility debugnode not exists';
        test.identical( _.strCount( op.output, 'spawn debugnode ENOENT' ), 1 );
        test.identical( _.strCount( op.output, 'code : \'ENOENT\'' ), 1 );
        test.identical( _.strCount( op.output, 'syscall : \'spawn debugnode\'' ), 1 );
        test.identical( _.strCount( op.output, 'path : \'debugnode\'' ), 1 );
        test.identical( _.strCount( op.output, 'spawnargs' ), 1 );
        test.identical( _.strCount( op.output, 'Error starting the process' ), 1 );
      }
      return null;
    });
  });

  return con;
}

runDebugTst.experimental = 1;

//

function runWithQuotedPath( test )
{
  let context = this;
  let a = context.assetFor( test, 'hello' );

  a.reflect();
  test.true( a.fileProvider.fileExists( a.abs( 'Hello.test.js' ) ) );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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

function runWithSeveralSimilarOptions( test )
{
  let context = this;
  let a = context.assetFor( test, 'grouping' );
  a.reflect();

  test.true( a.fileProvider.fileExists( a.abs( 'Grouping.test.js' ) ) );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'the first option is less than the second';
    return null;
  })

  a.appStart({ execPath : `.run ./ v:3 verbosity:5` })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Command ".run ./ v:3 verbosity:5"' ), 1 );
    test.identical( _.strCount( op.output, 'Tester Settings :' ), 1 );
    test.identical( _.strCount( op.output, 'verbosity : 5' ), 1 );
    test.identical( _.strCount( op.output, 'verbosity : 3' ), 0 );
    test.identical( _.strCount( op.output, 'Running test suite ( Hello ) ..' ), 1 );
    test.identical( _.strCount( op.output, 'Running TestSuite::Hello / TestRoutine::routine1 ..' ), 1 );
    test.identical( _.strCount( op.output, 'Test check ( TestSuite::Hello / TestRoutine::routine1 / string > trivial # 1 )' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::Hello / TestRoutine::routine1 in' ), 1 );
    test.identical( _.strCount( op.output, /Test suite \( Hello \) \.\.\. in \d+.\d+s \.\.\. ok/ ), 1 );

    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'the first option is less than the second';
    return null;
  })

  a.appStart({ execPath : `.run ./ v:5 verbosity:3` })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Command ".run ./ v:5 verbosity:3"' ), 1 );
    test.identical( _.strCount( op.output, 'Tester Settings :' ), 0 );
    test.identical( _.strCount( op.output, 'verbosity : 5' ), 0 );
    test.identical( _.strCount( op.output, 'verbosity : 3' ), 0 );
    test.identical( _.strCount( op.output, 'Running test suite ( Hello ) ..' ), 1 );
    test.identical( _.strCount( op.output, 'Running TestSuite::Hello / TestRoutine::routine1 ..' ), 0 );
    test.identical( _.strCount( op.output, 'Test check ( TestSuite::Hello / TestRoutine::routine1 / string > trivial # 1 )' ), 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::Hello / TestRoutine::routine1 in' ), 0 );
    test.identical( _.strCount( op.output, /Test suite \( Hello \) \.\.\. in \d+.\d+s \.\.\. ok/ ), 1 );

    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'the first option is less than the second';
    return null;
  })

  a.appStart({ execPath : `.run ./ verbosity:3 v:5` })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Command ".run ./ verbosity:3 v:5"' ), 1 );
    test.identical( _.strCount( op.output, 'Tester Settings :' ), 1 );
    test.identical( _.strCount( op.output, 'verbosity : 5' ), 1 );
    test.identical( _.strCount( op.output, 'verbosity : 3' ), 0 );
    test.identical( _.strCount( op.output, 'Running test suite ( Hello ) ..' ), 1 );
    test.identical( _.strCount( op.output, 'Running TestSuite::Hello / TestRoutine::routine1 ..' ), 1 );
    test.identical( _.strCount( op.output, 'Test check ( TestSuite::Hello / TestRoutine::routine1 / string > trivial # 1 )' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::Hello / TestRoutine::routine1 in' ), 1 );
    test.identical( _.strCount( op.output, /Test suite \( Hello \) \.\.\. in \d+.\d+s \.\.\. ok/ ), 1 );

    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'the first option is less than the second';
    return null;
  })

  a.appStart({ execPath : `.run ./ verbosity:5 v:3` })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Command ".run ./ verbosity:5 v:3"' ), 1 );
    test.identical( _.strCount( op.output, 'Tester Settings :' ), 0 );
    test.identical( _.strCount( op.output, 'verbosity : 5' ), 0 );
    test.identical( _.strCount( op.output, 'verbosity : 3' ), 0 );
    test.identical( _.strCount( op.output, 'Running test suite ( Hello ) ..' ), 1 );
    test.identical( _.strCount( op.output, 'Running TestSuite::Hello / TestRoutine::routine1 ..' ), 0 );
    test.identical( _.strCount( op.output, 'Test check ( TestSuite::Hello / TestRoutine::routine1 / string > trivial # 1 )' ), 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::Hello / TestRoutine::routine1 in' ), 0 );
    test.identical( _.strCount( op.output, /Test suite \( Hello \) \.\.\. in \d+.\d+s \.\.\. ok/ ), 1 );

    return null;
  });

  /* - */

  return a.ready;
}

//

function runWithSeveralMixedOptions( test )
{
  let context = this;
  let a = context.assetFor( test, 'optionRapidity' );
  a.reflect();
  test.true( a.fileProvider.fileExists( a.abs( 'OptionRapidity.test.js' ) ) );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'run with several option `r` and several `verbosity`';
    return null;
  });

  a.appStart({ execPath : `.run ./ r:routinePositiveRapidity1 r:routinePositiveRapidity2 v:1 v:5` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Running TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 ..' ), 1 );
    var exp = 'Test check ( TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 /  # 1 ) ... ok';
    test.identical( _.strCount( got.output, exp ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Running TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 ..' ), 1 );
    var exp = 'Test check ( TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 /  # 1 ) ... ok';
    test.identical( _.strCount( got.output, exp ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 in' ), 1 );

    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'run with vectorized option `r` and vectorized `verbosity`';
    return null;
  });

  a.appStart({ execPath : `.run ./ r:[routinePositiveRapidity1,routinePositiveRapidity2] v:[1,5]` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Running TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 ..' ), 1 );
    var exp = 'Test check ( TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 /  # 1 ) ... ok';
    test.identical( _.strCount( got.output, exp ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Running TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 ..' ), 1 );
    var exp = 'Test check ( TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 /  # 1 ) ... ok';
    test.identical( _.strCount( got.output, exp ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 in' ), 1 );

    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'run with several option `routine` and several `verbosity`';
    return null;
  });

  a.appStart({ execPath : `.run ./ routine:routinePositiveRapidity1 routine:routinePositiveRapidity2 v:1 v:5` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Running TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 ..' ), 1 );
    var exp = 'Test check ( TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 /  # 1 ) ... ok';
    test.identical( _.strCount( got.output, exp ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Running TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 ..' ), 1 );
    var exp = 'Test check ( TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 /  # 1 ) ... ok';
    test.identical( _.strCount( got.output, exp ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 in' ), 1 );

    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'run with vectorized option `routine` and vectorized `verbosity`';
    return null;
  });

  a.appStart({ execPath : `.run ./ routine:[routinePositiveRapidity1,routinePositiveRapidity2] v:[1,5]` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Running TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 ..' ), 1 );
    var exp = 'Test check ( TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 /  # 1 ) ... ok';
    test.identical( _.strCount( got.output, exp ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Running TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 ..' ), 1 );
    var exp = 'Test check ( TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 /  # 1 ) ... ok';
    test.identical( _.strCount( got.output, exp ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 in' ), 1 );

    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'run with options `routine` and `r`, vectorized `verbosity`';
    return null;
  });

  a.appStart({ execPath : `.run ./ r:routinePositiveRapidity1 routine:routinePositiveRapidity2 v:[1,5]` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Running TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 ..' ), 1 );
    var exp = 'Test check ( TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 /  # 1 ) ... ok';
    test.identical( _.strCount( got.output, exp ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Running TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 ..' ), 1 );
    var exp = 'Test check ( TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 /  # 1 ) ... ok';
    test.identical( _.strCount( got.output, exp ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 in' ), 1 );

    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'run with options `r` and `routine`, vectorized `verbosity`';
    return null;
  });

  a.appStart({ execPath : `.run ./ routine:routinePositiveRapidity1 r:routinePositiveRapidity2 v:[1,5]` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Running TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 ..' ), 1 );
    var exp = 'Test check ( TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 /  # 1 ) ... ok';
    test.identical( _.strCount( got.output, exp ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Running TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 ..' ), 1 );
    var exp = 'Test check ( TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 /  # 1 ) ... ok';
    test.identical( _.strCount( got.output, exp ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 in' ), 1 );

    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'run with vectorized option `r`, options `verbosity` and `v`';
    return null;
  });

  a.appStart({ execPath : `.run ./ r:[routinePositiveRapidity1,routinePositiveRapidity2] verbosity:1 v:5` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Running TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 ..' ), 1 );
    var exp = 'Test check ( TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 /  # 1 ) ... ok';
    test.identical( _.strCount( got.output, exp ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Running TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 ..' ), 1 );
    var exp = 'Test check ( TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 /  # 1 ) ... ok';
    test.identical( _.strCount( got.output, exp ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 in' ), 1 );

    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'run with vectorized option `r`, options `v` and `verbosity`';
    return null;
  });

  a.appStart({ execPath : `.run ./ r:[routinePositiveRapidity1,routinePositiveRapidity2] v:1 verbosity:5` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Running TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 ..' ), 1 );
    var exp = 'Test check ( TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 /  # 1 ) ... ok';
    test.identical( _.strCount( got.output, exp ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1 in' ), 1 );
    test.identical( _.strCount( got.output, 'Running TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 ..' ), 1 );
    var exp = 'Test check ( TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 /  # 1 ) ... ok';
    test.identical( _.strCount( got.output, exp ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2 in' ), 1 );

    return null;
  });

  /* - */

  return a.ready;
}

//

function runWithQuotedArrayWithSpaces( test )
{
  let context = this;
  let a = context.assetFor( test, 'runWithArrayOfRoutines' );
  a.reflect();
  test.true( a.fileProvider.fileExists( a.abs( 'RunWithArrayOfRoutines.test.js' ) ) );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'run with vectorized option `r`';
    return null;
  });

  a.appStart({ execPath : `.run ./RunWithArrayOfRoutines.test.js r:'[ export*, import*, open* ]'` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Running test suite ( RunWithArrayOfRoutines )' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::open in' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::importOne in' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::exportOne in' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::build in' ), 0 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::module in' ), 0 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::submodule in' ), 0 );

    return null;
  });

  /* - */

  return a.ready;
}

//

function runWithWrongSyntaxAndQuotedArrayWithSpaces( test )
{
  let context = this;
  let a = context.assetFor( test, 'runWithArrayOfRoutines' );
  a.reflect();
  test.true( a.fileProvider.fileExists( a.abs( 'RunWithArrayOfRoutines.test.js' ) ) );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'run with vectorized option `r`';
    return null;
  });

  a.shell({ execPath : `node ./RunWithArrayOfRoutines.test.js r:'[ export*, import*, open* ]'` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Running test suite ( RunWithArrayOfRoutines )' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::open in' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::importOne in' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::exportOne in' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::build in' ), 0 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::module in' ), 0 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::submodule in' ), 0 );

    return null;
  });

  /* - */

  return a.ready;
}

//

function runWithQuotedArrayWithSpacesAndRapidity( test )
{
  let context = this;
  let a = context.assetFor( test, 'runWithArrayOfRoutines' );
  a.reflect();
  test.true( a.fileProvider.fileExists( a.abs( 'RunWithArrayOfRoutines.test.js' ) ) );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'wrong syntax, run with vectorized option `r`';
    return null;
  });

  a.appStart( `.run ./RunWithArrayOfRoutines.test.js r:'[ export*, import*, open* ]' rapidity:-2` );
  a.ready.then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Running test suite ( RunWithArrayOfRoutines )' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::open in' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::importOne in' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::exportOne in' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::build in' ), 0 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::module in' ), 0 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::submodule in' ), 0 );

    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'wrong syntax, run with vectorized option `r`';
    return null;
  });

  a.shell( `node ./RunWithArrayOfRoutines.test.js r:'[ export*, import*, open* ]' rapidity:-2` );
  a.ready.then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Running test suite ( RunWithArrayOfRoutines )' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::open in' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::importOne in' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::exportOne in' ), 1 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::build in' ), 0 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::module in' ), 0 );
    test.identical( _.strCount( got.output, 'Passed TestSuite::RunWithArrayOfRoutines / TestRoutine::submodule in' ), 0 );

    return null;
  });

  /* - */

  return a.ready;
}

//

function runCheckNotRewritingDefaultOption( test )
{
  let context = this;
  let a = context.assetFor( test, 'optionsRewriting' );
  a.reflect();

  /* */

  a.appStartNonThrowing( '.run ./' )
  .then( ( op ) =>
  {
    test.case = 'default verbosity is 4, should not rewrite';
    test.identical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Running TestSuite::OptionsRewriting.test.s:102:14 / TestRoutine::routine ..' ), 0 );
    test.identical( _.strCount( op.output, 'Test check ( TestSuite::OptionsRewriting.test.s:102:14 / TestRoutine::routine /  # 1 ) ... ok' ), 0 );
    test.identical( _.strCount( op.output, 'Test check ( TestSuite::OptionsRewriting.test.s:102:14 / TestRoutine::routine /  # 2 ) ... ok' ), 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionsRewriting.test.s:102:14 / TestRoutine::routine in' ), 1 );
    return null;
  });

  /* */

  a.appStartNonThrowing( '.run ./ v:5' )
  .then( ( op ) =>
  {
    test.case = 'default verbosity is 4, verbosity in command line option is 5';
    test.identical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Running TestSuite::OptionsRewriting.test.s:102:14 / TestRoutine::routine ..' ), 1 );
    test.identical( _.strCount( op.output, 'Test check ( TestSuite::OptionsRewriting.test.s:102:14 / TestRoutine::routine /  # 1 ) ... ok' ), 1 );
    test.identical( _.strCount( op.output, 'Test check ( TestSuite::OptionsRewriting.test.s:102:14 / TestRoutine::routine /  # 2 ) ... ok' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionsRewriting.test.s:102:14 / TestRoutine::routine in' ), 1 );
    return null;
  });

  /* - */

  return a.ready;
}

//

function runCheckRewritingSuiteOptions( test )
{
  let context = this;
  let a = context.assetFor( test, 'optionsSuiteRewriting' );
  a.reflect();

  /* */

  a.appStartNonThrowing( '.run ./' )
  .then( ( op ) =>
  {
    test.case = 'suite silencing is 1, should not rewrite';
    test.identical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'good' ), 0 );
    test.identical( _.strCount( op.output, 'Running TestSuite::OptionsSuiteRewriting.test.s:102:14 / TestRoutine::routine ..' ), 0 );
    test.identical( _.strCount( op.output, 'Test check ( TestSuite::OptionsSuiteRewriting.test.s:102:14 / TestRoutine::routine /  # 1 ) ... ok' ), 0 );
    test.identical( _.strCount( op.output, 'Test check ( TestSuite::OptionsSuiteRewriting.test.s:102:14 / TestRoutine::routine /  # 2 ) ... ok' ), 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionsSuiteRewriting.test.s:102:14 / TestRoutine::routine in' ), 1 );
    return null;
  });

  /* */

  a.appStartNonThrowing( '.run ./ v:5 silencing:0' )
  .then( ( op ) =>
  {
    test.case = 'suite silencing is 1, silencing in command line option is 0';
    test.identical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'good' ), 2 );
    test.identical( _.strCount( op.output, 'Running TestSuite::OptionsSuiteRewriting.test.s:102:14 / TestRoutine::routine ..' ), 1 );
    test.identical( _.strCount( op.output, 'Test check ( TestSuite::OptionsSuiteRewriting.test.s:102:14 / TestRoutine::routine /  # 1 ) ... ok' ), 1 );
    test.identical( _.strCount( op.output, 'Test check ( TestSuite::OptionsSuiteRewriting.test.s:102:14 / TestRoutine::routine /  # 2 ) ... ok' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionsSuiteRewriting.test.s:102:14 / TestRoutine::routine in' ), 1 );
    return null;
  });

  /* - */

  return a.ready;
}

//

function runExperimentalRoutines( test )
{
  let context = this;
  let a = context.assetFor( test, 'runExperimentalRoutines' );
  a.reflect();

  /* */

  a.appStart( '.run ./' )
  .then( ( op ) =>
  {
    test.case = 'run without routines selector, should not run experimental test routines';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::open ' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::openExperimental ' ), 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::build ' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::buildExperimental ' ), 0 );
    return null;
  });

  a.appStart( '.run ./ r:open*' )
  .then( ( op ) =>
  {
    test.case = 'selector - string with glob, should not run experimental test routine';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::open ' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::openExperimental ' ), 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::build ' ), 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::buildExperimental ' ), 0 );
    return null;
  });

  a.appStart( '.run ./ r:openExperimental' )
  .then( ( op ) =>
  {
    test.case = 'selector - string with name of experimental routine, should run test routine';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::open ' ), 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::openExperimental ' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::build ' ), 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::buildExperimental ' ), 0 );
    return null;
  });

  a.appStart( '.run ./ r:open* r:build*' )
  .then( ( op ) =>
  {
    test.case = 'selector - array with globs, should not run experimental test routines';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::open ' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::openExperimental ' ), 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::build ' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::buildExperimental ' ), 0 );
    return null;
  });

  a.appStart( '.run ./ r:"[ openExperimental, buildExperimental ]"' )
  .then( ( op ) =>
  {
    test.case = 'selector - array with names of experimental test routines, should run test routines';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::open ' ), 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::openExperimental ' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::build ' ), 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::buildExperimental ' ), 1 );
    return null;
  });

  a.appStart( '.run ./ r:"[ open*, buildExperimental ]"' )
  .then( ( op ) =>
  {
    test.case = 'selector - array with mixed names, should run defined experimental test routine';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::open ' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::openExperimental ' ), 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::build ' ), 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::RunExperimentalRoutines / TestRoutine::buildExperimental ' ), 1 );
    return null;
  });

  /* - */

  return a.ready;
}

//

function runExcludeNodeModules( test )
{
  let context = this;
  let a = context.assetFor( test, 'runExcludeNodeModules' );
  a.reflect();

  /* */

  a.ready.then( () =>
  {
    a.fileProvider.fileCopy
    ({
      srcPath : a.abs( 'TestSuite1.test.js' ),
      dstPath : a.abs( 'node_modules/TestSuiteInNodeModules.test.js' ),
      makingDirectory : 1
    });
    return null;
  })

  a.appStart( '.run ./' )
  .then( ( op ) =>
  {
    test.case = 'should not include test suites from the node_modules directory';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Launching several ( 1 ) test suite(s)' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::TestSuite1.test.js' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::TestSuiteInNodeModules.test.js' ), 0 );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    a.fileProvider.fileCopy
    ({
      srcPath : a.abs( 'TestSuite1.test.js' ),
      dstPath : a.abs( 'dir1/node_modules/TestSuiteInNodeModules.test.js' ),
      makingDirectory : 1
    });
    return null;
  })

  a.appStart( '.run ./' )
  .then( ( op ) =>
  {
    test.case = 'should not include test suites from the nested node_modules directory';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Launching several ( 1 ) test suite(s)' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::TestSuite1.test.js' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::TestSuiteInNodeModules.test.js' ), 0 );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    a.fileProvider.fileCopy
    ({
      srcPath : a.abs( 'TestSuite1.test.js' ),
      dstPath : a.abs( 'dir1/dir2/node_modules/TestSuiteInNodeModules.test.js' ),
      makingDirectory : 1
    });
    return null;
  })

  a.appStart( '.run ./' )
  .then( ( op ) =>
  {
    test.case = 'should not include test suites from the deep nested node_modules directory';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Launching several ( 1 ) test suite(s)' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::TestSuite1.test.js' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::TestSuiteInNodeModules.test.js' ), 0 );
    return null;
  });

  /* - */

  return a.ready;
}

runExcludeNodeModules.description =
`
 - Checks that node_modules dir is exluded on any level. Tests in that directory should not be included.
`

//

function checkFails( test )
{
  let context = this;
  let a = context.assetFor( test );

  a.reflect();
  test.true( a.fileProvider.fileExists( a.abs( 'Hello.test.js' ) ) );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );
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
  test.true( a.fileProvider.fileExists( a.abs( 'Hello.test.js' ) ) );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

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
    test.nil( got.exitCode, 0 );

    test.identical( _.strCount( got.output, '0 test suite' ), 1 );
    test.identical( _.strCount( got.output, 'No enabled test suite to run' ), 1 );

    return null;
  })

  /* */

  return a.ready;
}

//

function exitCodeSeveralTestSuites( test )
{
  let context = this;
  let a = context.assetFor( test, false );
  let ready = _.take( null );

  /* */

  ready.then( function( arg )
  {
    test.case = 'programFail';
    let filePath/*programPath*/ = a.program({ entry : programFail }).filePath/*programPath*/;
    a.fork
    ({
      execPath : filePath/*programPath*/,
      throwingExitCode : 0,
    })
    .tap( ( err, op ) =>
    {
      test.notIdentical( op.exitCode, 0 );
      test.identical( _.strCount( op.output, 'ExitCode' ), 0 );
      test.identical( _.strCount( op.output, 'Exit' ), 0 );
      test.identical( _.strCount( op.output, 'exit' ), 2 );
      test.identical( _.strCount( op.output, 'Code' ), 2 );
      test.identical( _.strCount( op.output, 'code' ), 0 );
      test.identical( _.strCount( op.output, 'exitCodeSeveralTestSuites' ), 2 );
      test.identical( _.strCount( op.output, 'routine1.end' ), 1 );
      test.identical( _.strCount( op.output, 'routine2.end' ), 1 );
      test.identical( _.strCount( op.output, 'Unexpected termination' ), 0 );
      test.identical( _.dissector.dissect( `**<routine1.end>**<routine2.end>**`, op.output ).matched, true );
    });
    return a.ready;
  });

  /* */

  ready.then( function( arg )
  {
    test.case = 'programPass';
    let filePath/*programPath*/ = a.program({ entry : programPass }).filePath/*programPath*/;
    a.fork
    ({
      execPath : filePath/*programPath*/,
      throwingExitCode : 0,
    })
    .tap( ( err, op ) =>
    {
      test.identical( op.exitCode, 0 );
      test.identical( _.strCount( op.output, 'ExitCode' ), 0 );
      test.identical( _.strCount( op.output, 'Exit' ), 0 );
      test.identical( _.strCount( op.output, 'exit' ), 2 );
      test.identical( _.strCount( op.output, 'Code' ), 2 );
      test.identical( _.strCount( op.output, 'code' ), 0 );
      test.identical( _.strCount( op.output, 'exitCodeSeveralTestSuites' ), 2 );
      test.identical( _.strCount( op.output, 'routine1.end' ), 1 );
      test.identical( _.strCount( op.output, 'routine2.end' ), 1 );
      test.identical( _.strCount( op.output, 'Unexpected termination' ), 0 );
      test.identical( _.dissector.dissect( `**<routine1.end>**<routine2.end>**`, op.output ).matched, true );
    });
    return a.ready;
  });

  /* */

  ready.then( function( arg )
  {
    test.case = 'programExit1';
    let filePath/*programPath*/ = a.program({ entry : programExit1 }).filePath/*programPath*/;
    a.fork
    ({
      execPath : filePath/*programPath*/,
      throwingExitCode : 0,
    })
    .tap( ( err, op ) =>
    {
      test.notIdentical( op.exitCode, 0 );
      test.identical( _.strCount( op.output, 'ExitCode' ), 1 );
      test.identical( _.strCount( op.output, 'ExitCode : 1' ), 1 );
      test.identical( _.strCount( op.output, 'Exit' ), 2 );
      test.identical( _.strCount( op.output, 'exit' ), 1 );
      test.identical( _.strCount( op.output, 'Code' ), 2 );
      test.identical( _.strCount( op.output, 'code' ), 0 );
      test.identical( _.strCount( op.output, 'exitCodeSeveralTestSuites' ), 1 );
      test.identical( _.strCount( op.output, 'routine1.end' ), 0 );
      test.identical( _.strCount( op.output, 'routine2.end' ), 0 );
      test.identical( _.strCount( op.output, 'Unexpected termination' ), 1 );
    });
    return a.ready;
  });

  /* */

  ready.then( function( arg )
  {
    test.case = 'programExitCustomCode';
    let filePath/*programPath*/ = a.program({ entry : programExitCustomCode }).filePath/*programPath*/;
    a.fork
    ({
      execPath : filePath/*programPath*/,
      throwingExitCode : 0,
    })
    .tap( ( err, op ) =>
    {
      test.notIdentical( op.exitCode, 0 );
      test.identical( _.strCount( op.output, 'ExitCode' ), 1 );
      test.identical( _.strCount( op.output, 'ExitCode : 5' ), 1 );
      test.identical( _.strCount( op.output, 'Exit' ), 2 );
      test.identical( _.strCount( op.output, 'exit' ), 1 );
      test.identical( _.strCount( op.output, 'Code' ), 3 );
      test.identical( _.strCount( op.output, 'code' ), 0 );
      test.identical( _.strCount( op.output, 'exitCodeSeveralTestSuites' ), 1 );
      test.identical( _.strCount( op.output, 'routine1.end' ), 0 );
      test.identical( _.strCount( op.output, 'routine2.end' ), 0 );
      test.identical( _.strCount( op.output, 'Unexpected termination' ), 1 );
    });
    return a.ready;
  });

  /* */

  return ready;

  /* - */

  function programFail()
  {
    const _ = require( toolsPath );
    _.include( 'wTesting' );

    function routine1( test )
    {
      console.log( 'routine1.end' );
    }

    function routine2( test )
    {
      test.true( true );
      console.log( 'routine2.end' );
    }

    let Test1 =
    {
      name : 'Suite1',
      tests :
      {
        routine1,
      }
    }

    let Test2 =
    {
      name : 'Suite2',
      tests :
      {
        routine2,
      }
    }

    Test1 = wTestSuite( Test1 );
    Test2 = wTestSuite( Test2 );
    wTester.test();

  }

  /* - */

  function programPass()
  {
    const _ = require( toolsPath );
    _.include( 'wTesting' );

    function routine1( test )
    {
      test.true( true );
      console.log( 'routine1.end' );
    }

    function routine2( test )
    {
      test.true( true );
      console.log( 'routine2.end' );
    }

    let Test1 =
    {
      name : 'Suite1',
      tests :
      {
        routine1,
      }
    }

    let Test2 =
    {
      name : 'Suite2',
      tests :
      {
        routine2,
      }
    }

    Test1 = wTestSuite( Test1 );
    Test2 = wTestSuite( Test2 );
    wTester.test();

  }

  /* - */

  function programExit1()
  {
    const _ = require( toolsPath );
    _.include( 'wTesting' );

    function routine1( test )
    {
      test.true( true );
      process.exit( 0 );
      console.log( 'routine1.end' );
    }

    function routine2( test )
    {
      test.true( true );
      console.log( 'routine2.end' );
    }

    let Test1 =
    {
      name : 'Suite1',
      tests :
      {
        routine1,
      }
    }

    let Test2 =
    {
      name : 'Suite2',
      tests :
      {
        routine2,
      }
    }

    Test1 = wTestSuite( Test1 );
    Test2 = wTestSuite( Test2 );
    wTester.test();

  }

  /* - */

  function programExitCustomCode()
  {
    const _ = require( toolsPath );
    _.include( 'wTesting' );

    function routine1( test )
    {
      test.true( true );
      process.exit( 5 );
      console.log( 'routine1.end' );
    }

    function routine2( test )
    {
      test.true( true );
      console.log( 'routine2.end' );
    }

    let Test1 =
    {
      name : 'Suite1',
      tests :
      {
        routine1,
      }
    }

    let Test2 =
    {
      name : 'Suite2',
      tests :
      {
        routine2,
      }
    }

    Test1 = wTestSuite( Test1 );
    Test2 = wTestSuite( Test2 );
    wTester.test();

  }

  /* */

}

exitCodeSeveralTestSuites.description = /* qqq : extend the test */
`
  - previous test soute does not influence on exit code of the current
`;

//

function globalTestingTestToolsProblemFullModuleProblem( test )
{
  const a = test.assetFor( false );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'run all test suites by global tester, except Integration.test.s';
    return null;
  });

  a.shell( 'git clone https://github.com/Wandalen/wTools.git .' );
  a.shell( 'npm i' );
  a.appStartNonThrowing( '.run proto/wtools' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });

  /* - */

  return a.ready;
}

globalTestingTestToolsProblemFullModuleProblem.experimental = 1;
globalTestingTestToolsProblemFullModuleProblem.timeOut = 8e5;

//

function globalTestingTestToolsSingleSuiteProblem( test )
{
  const a = test.assetFor( false );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'run single test suite Module.test.s by global tester';
    return null;
  });

  a.shell( 'git clone https://github.com/Wandalen/wTools.git .' );
  a.shell( 'npm i' );
  a.appStartNonThrowing( '.run proto/wtools/abase/l0/l9.test/Module.test.s' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });

  /* - */

  return a.ready;
}

globalTestingTestToolsSingleSuiteProblem.experimental = 1;
globalTestingTestToolsSingleSuiteProblem.timeOut = 6e5;

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

  a.ready.then( () =>
  {
    test.case = 'tst .run ** v:8 rapidity:3 rapidity:-3';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.run ** v:8 rapidity:3 rapidity:-3` })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity1` ), 1 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity2` ), 1 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity3` ), 1 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity4` ), 0 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity5` ), 0 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity6` ), 0 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity7` ), 0 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity8` ), 0 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineNegativeRapidity9` ), 0 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity ` ), 1 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routineRapidity0` ), 1 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity1` ), 1 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity2` ), 1 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity3` ), 1 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity4` ), 1 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity5` ), 1 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity6` ), 1 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity7` ), 1 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity8` ), 1 );
    test.identical( _.strCount( op.output, `Passed TestSuite::OptionRapidity / TestRoutine::routinePositiveRapidity9` ), 1 );

    return null;
  });

  /* - */

  return a.ready;
}

//

function optionFails( test )
{
  let context = this;
  let a = context.assetFor( test );
  a.reflect();

  /* - */

  a.ready.then( () =>
  {
    test.case = 'tst .run ** - default value of fails';
    return null;
  });

  a.appStartNonThrowing({ execPath : `.run ** v:5` })
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Command ".run ** v:5"' ), 1 );
    test.identical( _.strCount( op.output, 'fails : null' ), 1 );
    test.identical( _.strCount( op.output, 'Launching several ( 3 ) test suite(s)' ), 1 );

    test.identical( _.strCount( op.output, 'Running test suite ( OptionFailsA1 )' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA1 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA1 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( op.output, /Test suite \( OptionFailsA1 \) \.+ in \d+\.\d+s \.+ ok/ ), 1 );

    test.identical( _.strCount( op.output, 'Running test suite ( OptionFailsA2 )' ), 1 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::OptionFailsA2 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA2 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( op.output, /Test suite \( OptionFailsA2 \) \.+ in \d+\.\d+s \.+ failed/ ), 1 );

    test.identical( _.strCount( op.output, '- got :' ), 3 );
    test.identical( _.strCount( op.output, '- expected :' ), 3 );
    test.identical( _.strCount( op.output, '- difference :' ), 3 );
    test.identical( _.strCount( op.output, ': function routine1( test )' ), 2 );
    test.identical( _.strCount( op.output, ': function routine2( test )' ), 1 );
    test.identical( _.strCount( op.output, ':   test.identical( 1, 0 );' ), 3 );

    test.identical( _.strCount( op.output, 'Running test suite ( OptionFailsA3 )' ), 1 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::OptionFailsA3 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::OptionFailsA3 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA3 / TestRoutine::routine3' ), 1 );
    test.identical( _.strCount( op.output, /Test suite \( OptionFailsA3 \) \.+ in \d+\.\d+s \.+ failed/ ), 1 );

    test.identical( _.strCount( op.output, 'Passed test checks 5 / 8' ), 1 );
    test.identical( _.strCount( op.output, 'Passed test cases 0 / 0' ), 4 );
    test.identical( _.strCount( op.output, 'Passed test routines 4 / 7' ), 1 );
    test.identical( _.strCount( op.output, 'Passed test suites 1 / 3' ), 1 );
    test.identical( _.strCount( op.output, /Testing \.+ in \d+\.\d+s \.+ failed/ ), 1 );

    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'tst .run ** v:5 fails:0 - disable fails - unlimited number of fails';
    return null;
  });

  a.appStartNonThrowing({ execPath : `.run ** v:5 fails:0` })
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Command ".run ** v:5 fails:0"' ), 1 );
    test.identical( _.strCount( op.output, 'fails : 0' ), 1 );
    test.identical( _.strCount( op.output, 'Launching several ( 3 ) test suite(s)' ), 1 );

    test.identical( _.strCount( op.output, 'Running test suite ( OptionFailsA1 )' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA1 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA1 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( op.output, /Test suite \( OptionFailsA1 \) \.+ in \d+\.\d+s \.+ ok/ ), 1 );

    test.identical( _.strCount( op.output, 'Running test suite ( OptionFailsA2 )' ), 1 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::OptionFailsA2 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA2 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( op.output, /Test suite \( OptionFailsA2 \) \.+ in \d+\.\d+s \.+ failed/ ), 1 );

    test.identical( _.strCount( op.output, '- got :' ), 3 );
    test.identical( _.strCount( op.output, '- expected :' ), 3 );
    test.identical( _.strCount( op.output, '- difference :' ), 3 );
    test.identical( _.strCount( op.output, ': function routine1( test )' ), 2 );
    test.identical( _.strCount( op.output, ': function routine2( test )' ), 1 );
    test.identical( _.strCount( op.output, ':   test.identical( 1, 0 );' ), 3 );

    test.identical( _.strCount( op.output, 'Running test suite ( OptionFailsA3 )' ), 1 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::OptionFailsA3 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::OptionFailsA3 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA3 / TestRoutine::routine3' ), 1 );
    test.identical( _.strCount( op.output, /Test suite \( OptionFailsA3 \) \.+ in \d+\.\d+s \.+ failed/ ), 1 );

    test.identical( _.strCount( op.output, /Thrown \d error/ ), 0 );
    test.identical( _.strCount( op.output, 'Passed test checks 5 / 8' ), 1 );
    test.identical( _.strCount( op.output, 'Passed test cases 0 / 0' ), 4 );
    test.identical( _.strCount( op.output, 'Passed test routines 4 / 7' ), 1 );
    test.identical( _.strCount( op.output, 'Passed test suites 1 / 3' ), 1 );
    test.identical( _.strCount( op.output, /Testing \.+ in \d+\.\d+s \.+ failed/ ), 1 );

    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'tst .run ** v:5 fails:10 - number of allowed fails is greater than total number of fails';
    return null;
  });

  a.appStartNonThrowing({ execPath : `.run ** v:5 fails:10` })
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Command ".run ** v:5 fails:10"' ), 1 );
    test.identical( _.strCount( op.output, 'fails : 10' ), 1 );
    test.identical( _.strCount( op.output, 'Launching several ( 3 ) test suite(s)' ), 1 );

    test.identical( _.strCount( op.output, 'Running test suite ( OptionFailsA1 )' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA1 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA1 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( op.output, /Test suite \( OptionFailsA1 \) \.+ in \d+\.\d+s \.+ ok/ ), 1 );

    test.identical( _.strCount( op.output, 'Running test suite ( OptionFailsA2 )' ), 1 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::OptionFailsA2 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA2 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( op.output, /Test suite \( OptionFailsA2 \) \.+ in \d+\.\d+s \.+ failed/ ), 1 );

    test.identical( _.strCount( op.output, '- got :' ), 3 );
    test.identical( _.strCount( op.output, '- expected :' ), 3 );
    test.identical( _.strCount( op.output, '- difference :' ), 3 );
    test.identical( _.strCount( op.output, ': function routine1( test )' ), 2 );
    test.identical( _.strCount( op.output, ': function routine2( test )' ), 1 );
    test.identical( _.strCount( op.output, ':   test.identical( 1, 0 );' ), 3 );

    test.identical( _.strCount( op.output, 'Running test suite ( OptionFailsA3 )' ), 1 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::OptionFailsA3 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::OptionFailsA3 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA3 / TestRoutine::routine3' ), 1 );
    test.identical( _.strCount( op.output, /Test suite \( OptionFailsA3 \) \.+ in \d+\.\d+s \.+ failed/ ), 1 );

    test.identical( _.strCount( op.output, /Thrown \d error/ ), 0 );
    test.identical( _.strCount( op.output, 'Passed test checks 5 / 8' ), 1 );
    test.identical( _.strCount( op.output, 'Passed test cases 0 / 0' ), 4 );
    test.identical( _.strCount( op.output, 'Passed test routines 4 / 7' ), 1 );
    test.identical( _.strCount( op.output, 'Passed test suites 1 / 3' ), 1 );
    test.identical( _.strCount( op.output, /Testing \.+ in \d+\.\d+s \.+ failed/ ), 1 );

    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'tst .run ** v:5 fails:3 - number of allowed fails is equivalent to total number of fails';
    return null;
  });

  a.appStartNonThrowing({ execPath : `.run ** v:5 fails:3` })
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Command ".run ** v:5 fails:3"' ), 1 );
    test.identical( _.strCount( op.output, 'fails : 3' ), 1 );
    test.identical( _.strCount( op.output, 'Launching several ( 3 ) test suite(s)' ), 1 );

    test.identical( _.strCount( op.output, 'Running test suite ( OptionFailsA1 )' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA1 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA1 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( op.output, /Test suite \( OptionFailsA1 \) \.+ in \d+\.\d+s \.+ ok/ ), 1 );

    test.identical( _.strCount( op.output, 'Running test suite ( OptionFailsA2 )' ), 1 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::OptionFailsA2 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA2 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( op.output, /Test suite \( OptionFailsA2 \) \.+ in \d+\.\d+s \.+ failed/ ), 1 );

    test.identical( _.strCount( op.output, '- got :' ), 3 );
    test.identical( _.strCount( op.output, '- expected :' ), 3 );
    test.identical( _.strCount( op.output, '- difference :' ), 3 );
    test.identical( _.strCount( op.output, ': function routine1( test )' ), 2 );
    test.identical( _.strCount( op.output, ': function routine2( test )' ), 1 );
    test.identical( _.strCount( op.output, ':   test.identical( 1, 0 );' ), 3 );

    test.identical( _.strCount( op.output, 'Running test suite ( OptionFailsA3 )' ), 1 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::OptionFailsA3 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( op.output, 'Failed ( throwing error ) TestSuite::OptionFailsA3 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::OptionFailsA3 / TestRoutine::routine2' ), 0 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::OptionFailsA3 / TestRoutine::routine3' ), 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA3 / TestRoutine::routine3' ), 0 );
    test.identical( _.strCount( op.output, /Test suite \( OptionFailsA3 \) \.+ in \d+\.\d+s \.+ failed/ ), 1 );

    test.identical( _.strCount( op.output, /Thrown \d error/ ), 2 );
    test.identical( _.strCount( op.output, 'Passed test checks 3 / 7' ), 1 );
    test.identical( _.strCount( op.output, 'Passed test cases 0 / 0' ), 4 );
    test.identical( _.strCount( op.output, 'Passed test routines 3 / 6' ), 1 );
    test.identical( _.strCount( op.output, 'Passed test suites 1 / 3' ), 1 );
    test.identical( _.strCount( op.output, /Testing \.+ in \d+\.\d+s \.+ failed/ ), 1 );

    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'tst .run ** v:5 fails:1 - number of allowed fails is less than total number of fails';
    return null;
  });

  a.appStartNonThrowing({ execPath : `.run ** v:5 fails:1` })
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Command ".run ** v:5 fails:1"' ), 1 );
    test.identical( _.strCount( op.output, 'fails : 1' ), 1 );
    test.identical( _.strCount( op.output, 'Launching several ( 3 ) test suite(s)' ), 1 );

    test.identical( _.strCount( op.output, 'Running test suite ( OptionFailsA1 )' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA1 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA1 / TestRoutine::routine2' ), 1 );
    test.identical( _.strCount( op.output, /Test suite \( OptionFailsA1 \) \.+ in \d+\.\d+s \.+ ok/ ), 1 );

    test.identical( _.strCount( op.output, 'Running test suite ( OptionFailsA2 )' ), 1 );
    test.identical( _.strCount( op.output, 'Failed ( throwing error ) TestSuite::OptionFailsA2 / TestRoutine::routine1' ), 1 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::OptionFailsA2 / TestRoutine::routine1' ), 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA2 / TestRoutine::routine2' ), 0 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::OptionFailsA2 / TestRoutine::routine2' ), 0 );
    test.identical( _.strCount( op.output, /Test suite \( OptionFailsA2 \) \.+ in \d+\.\d+s \.+ failed/ ), 1 );

    test.identical( _.strCount( op.output, '- got :' ), 1 );
    test.identical( _.strCount( op.output, '- expected :' ), 1 );
    test.identical( _.strCount( op.output, '- difference :' ), 1 );
    test.identical( _.strCount( op.output, ': function routine1( test )' ), 1 );
    test.identical( _.strCount( op.output, ': function routine2( test )' ), 0 );
    test.identical( _.strCount( op.output, ':   test.identical( 1, 0 );' ), 1 );

    test.identical( _.strCount( op.output, 'Running test suite ( OptionFailsA3 )' ), 1 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::OptionFailsA3 / TestRoutine::routine1' ), 0 );
    test.identical( _.strCount( op.output, 'Failed ( throwing error ) TestSuite::OptionFailsA3 / TestRoutine::routine2' ), 0 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::OptionFailsA3 / TestRoutine::routine2' ), 0 );
    test.identical( _.strCount( op.output, 'Failed TestSuite::OptionFailsA3 / TestRoutine::routine3' ), 0 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::OptionFailsA3 / TestRoutine::routine3' ), 0 );
    test.identical( _.strCount( op.output, /Test suite \( OptionFailsA3 \) \.+ in \d+\.\d+s \.+ failed/ ), 1 );

    test.identical( _.strCount( op.output, /Thrown \d error/ ), 2 );
    test.identical( _.strCount( op.output, 'Passed test checks 2 / 4' ), 1 );
    test.identical( _.strCount( op.output, 'Passed test cases 0 / 0' ), 4 );
    test.identical( _.strCount( op.output, 'Passed test routines 2 / 3' ), 1 );
    test.identical( _.strCount( op.output, 'Passed test suites 1 / 3' ), 1 );
    test.identical( _.strCount( op.output, /Testing \.+ in \d+\.\d+s \.+ failed/ ), 1 );

    return null;
  });

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
    test.true( got.output.length > 0 );
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
    test.true( got.output.length > 0 );
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
    test.true( _.strHas( op.output, /Current version : .*\..*\..*/ ) );
    test.true( _.strHas( op.output, /Latest version of wTesting : .*\..*\..*/ ) );
    test.true( _.strHas( op.output, /Stable version of wTesting : .*\..*\..*/ ) );
    return op;
  })

  return a.ready;
}

//

function imply( test )
{
  let context = this;
  let a = context.assetFor( test, 'optionRapidity' );
  a.reflect();

  /* - */

  a.ready.then( () =>
  {
    test.case = '.imply v:8 rapidity:-9 .run **';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.imply v:8 rapidity:-9 .run **` })
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
  });

  /* - */

  a.ready.then( () =>
  {
    test.case = '.imply v:5 rapidity:9 .run **';
    return null;
  })

  a.appStartNonThrowing({ execPath : `.imply v:5 rapidity:9 .run **` })
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
  });

  /* - */

  return a.ready;
}

//

function context( test )
{
  const ctx = this;
  const a = ctx.assetFor( test, 'context' );
  a.reflect();

  /* - */

  const routinesContextMap =
  {
    runWithoutChangedContext : '',
    runWithChangingSuiteVariable : 'suiteContextVariable:5',
    runWithChangingVariableWithDefaultValue : 'variableWithDefaultValue:3',
    runWithChangingVariableWithoutDefaultValue : 'variableWithoutDefaultValue:3',
    runWithChangingSeveralVariables : 'variableWithDefaultValue:3 variableWithoutDefaultValue:1',
    runWithExtendingContext : 'a:0 b:foo',
    runWithVectorisingContextVariables :
    'variableWithDefaultValue:1 variableWithDefaultValue:2 variableWithoutDefaultValue:"[a,b]"',
    severalRunsWithRewritingByLast : 'variableWithDefaultValue:100 .context variableWithDefaultValue:2',
    severalRunsWithExtendingByLast : 'variableWithDefaultValue:3 .context variableWithoutDefaultValue:1',
  };

  /* */

  for( let routine in routinesContextMap )
  run({ routine, context : routinesContextMap[ routine ] });

  /* - */

  return a.ready;

  function run( env )
  {
    return a.appStart({ execPath : `.context ${ env.context } .run ./ r:${ env.routine }` })
    .then( ( op ) =>
    {
      test.case = `${ _.entity.exportStringSolo( env ) }`;
      test.identical( op.exitCode, 0 );
      test.identical( _.strCount( op.output, `Passed TestSuite::Context / TestRoutine::${ env.routine }` ), 1 );
      test.identical( _.strCount( op.output, 'Passed test routines 1 / 1' ), 2 );
      test.identical( _.strCount( op.output, 'Passed test suites 1 / 1' ), 1 );
      return null;
    });
  }
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

  a.ready.then( () =>
  {
    test.case = 'Suite.test.js';
    return null;
  });

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
    test.identical( _.strCount( got.output, 'Unexpected termination' ), 0 );
    test.identical( _.strCount( got.output, 'routine1.' ), 1 );
    test.identical( _.strCount( got.output, 'routine1.1' ), 1 );

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
    test.identical( _.strCount( got.output, 'Unexpected termination' ), 0 );
    test.identical( _.strCount( got.output, 'TestRoutine::routine1 is ended' ), 0 );
    test.identical( _.strCount( got.output, 'time limit' ), 1 );
    test.identical( _.strCount( got.output, 'Failed ( test routine time limit )' ), 1 );
    test.identical( _.strCount( got.output, 'is ended because of time limit' ), 0 );
    test.identical( _.strCount( got.output, 'several' ), 1 );
    test.identical( _.strCount( got.output, 'several async returning' ), 0 );
    test.identical( _.strCount( got.output, 'Launching several' ), 1 );
    test.identical( _.strCount( got.output, '= Message of Error' ), 0 );
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
    test.identical( _.strCount( got.output, 'Unexpected termination' ), 0 );

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
//     console.log( 'v1' );
//     test.identical( 1, 1 );
//     test.equivalent( 1, 1 );
//     test.true( true );
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

function timeOutSeveralRoutines( test )
{
  let context = this;
  let a = context.assetFor( test, false );
  let filePath/*programPath*/ = a.program({ entry : program1 }).filePath/*programPath*/;
  let ready = _.take( null );

  /* */

  ready.then( function( arg )
  {
    test.case = 'basic';
    a.forkNonThrowing
    ({
      execPath : filePath/*programPath*/,
    })
    .tap( ( _err, op ) =>
    {
      test.identical( _.strCount( op.output, 'uncaught error' ), 0 );
      test.identical( _.strCount( op.output, 'Terminated by user' ), 0 );
      test.identical( _.strCount( op.output, 'Unexpected termination' ), 0 );

      test.identical( _.strCount( op.output, 'Failed ( test routine time limit ) TestSuite::ForTesting / TestRoutine::routine1' ), 1 );
      test.identical( _.strCount( op.output, 'Passed TestSuite::ForTesting / TestRoutine::routine2' ), 1 );
      test.identical( _.strCount( op.output, 'Test routine TestSuite::ForTesting / TestRoutine::routine1 returned, cant continue!' ), 1 );
      test.identical( _.strCount( op.output, 'Passed TestSuite::ForTesting / TestRoutine::routine3' ), 1 );
      test.identical( _.strCount( op.output, 'Passed TestSuite::ForTesting / TestRoutine::routine4' ), 1 );
      test.identical( _.strCount( op.output, 'Passed test routines 3 / 4' ), 2 );

      test.identical( _.dissector.dissect( '**<::routine1>**<::routine2>**<::routine3>**<::routine4>**', op.output ).matched, true );

      test.notIdentical( op.exitCode, 0 );
    });
    return a.ready;
  });

  /* */

  return ready;

  /* - */

  function program1()
  {
    const _ = require( toolsPath );
    _.include( 'wTesting' );
    const __ = _globals_.testing.wTools;

    function routine1( test )
    {
      test.true( true );
      _.time.begin( context.t2*4, () =>
      {
        console.log( 'routine1:time1' );
        test.true( true );
        console.log( 'routine1:time2' );
      });
      return __.time.out( context.t2*3 );
    }

    function routine2( test )
    {
      test.true( true );
      return __.time.out( context.t2 );
    }

    function routine3( test )
    {
      test.true( true );
      return __.time.out( context.t2 );
    }

    function routine4( test )
    {
      test.true( true );
      return __.time.out( context.t2 );
    }

    const Proto =
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

    const Self = wTestSuite( Proto );
    wTester.test( Self.name );
  }

}

timeOutSeveralRoutines.description =
`
  - time out of one test routine does not halt testing
  - time out of one test routine does not prevent other test routines to run
`

//

function timeOutSeveralRoutinesDesync( test )
{
  let context = this;
  let a = context.assetFor( test, false );
  let filePath/*programPath*/ = a.program({ entry : program1 }).filePath/*programPath*/;
  let ready = _.take( null );

  /* */

  ready.then( function( arg )
  {
    test.case = 'basic';
    a.forkNonThrowing
    ({
      execPath : filePath/*programPath*/,
    })
    .tap( ( _err, op ) =>
    {
      test.identical( _.strCount( op.output, 'uncaught error' ), 0 );
      test.identical( _.strCount( op.output, 'Terminated by user' ), 0 );
      test.identical( _.strCount( op.output, 'Unexpected termination' ), 0 );

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
    const _ = require( toolsPath );
    _.include( 'wTesting' );
    const __ = _globals_.testing.wTools;

    function routine1( test )
    {
      test.true( true );
      _.time.begin( context.t2*4, () =>
      {
        console.log( 'routine1:time1' );
        test.true( true );
        console.log( 'routine1:time2' );
      });
      __.time.out( context.t2*3 ).deasync();
      test.true( true );
    }

    function routine2( test )
    {
      test.true( true );
      return __.time.out( context.t2 );
    }

    function routine3( test )
    {
      test.true( true );
      return __.time.out( context.t2 );
    }

    function routine4( test )
    {
      test.true( true );
      return __.time.out( context.t2 );
    }

    const Proto =
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

    const Self = wTestSuite( Proto );
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

  a.ready.then( () =>
  {
    test.case = 'sync onSuiteEnd';

    let o =
    {
      execPath : `OnceOnSigintSync.test.js`,
      outputPiping : 1,
      ready : _.take( null ),
    }

    a.appStartNonThrowing( o )

    o.conStart.then( () =>
    {
      o.pnd.send( 'SIGINT' );
      return null;
    })

    o.conTerminate.then( ( got ) =>
    {
      test.notIdentical( got.exitCode, 0 );

      test.identical( _.strCount( got.output, 'Terminated by user' ), 0 );
      test.identical( _.strCount( got.output, 'Unexpected termination' ), 0 );
      test.identical( _.strCount( got.output, 'Executing onSuiteEnd' ), 1 );
      test.identical( _.strCount( got.output, 'Error in suite.onSuiteEnd' ), 0 );
      test.identical( _.strCount( got.output, 'Error' ), 1 );
      test.identical( _.strCount( got.output, 'error' ), 1 );
      test.identical( _.strCount( got.output, 'Message of Error' ), 1 );
      test.identical( _.strCount( got.output, 'Thrown 1 error' ), 1 );
      test.identical( _.strCount( got.output, 'ExitCode : 130' ), 1 );
      test.identical( _.strCount( got.output, 'Exit signal : SIGINT ( 128+2 )' ), 1 );

      return null;
    })

    return o.conTerminate;
  })

  /* - */

  a.ready.then( () =>
  {
    test.case = 'async onSuiteEnd';

    let o =
    {
      execPath : `OnceOnSigintAsync.test.js`,
      outputPiping : 1,
      ready : _.take( null ),
    }

    a.appStartNonThrowing( o )

    o.conStart.then( () =>
    {
      o.pnd.send( 'SIGINT' );
      return null;
    })

    o.conTerminate.then( ( got ) =>
    {
      test.notIdentical( got.exitCode, 0 );

      test.identical( _.strCount( got.output, 'Terminated by user' ), 0 );
      test.identical( _.strCount( got.output, 'Unexpected termination' ), 0 );
      test.identical( _.strCount( got.output, 'Executing onSuiteEnd' ), 1 );
      test.identical( _.strCount( got.output, 'Error in suite.onSuiteEnd' ), 0 );
      test.identical( _.strCount( got.output, 'Error' ), 1 );
      test.identical( _.strCount( got.output, 'error' ), 1 );
      test.identical( _.strCount( got.output, 'Message of Error' ), 1 );
      test.identical( _.strCount( got.output, 'Thrown 1 error' ), 1 );
      test.identical( _.strCount( got.output, 'ExitCode : 130' ), 1 );
      test.identical( _.strCount( got.output, 'Exit signal : SIGINT ( 128+2 )' ), 1 );

      return null;
    })

    return o.conTerminate;
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
    execPath : `OnceOnSigintAsync.test.js`,
    outputPiping : 1,
    ipc : 1
  }

  a.appStartNonThrowing( o )

  o.conStart.then( () =>
  {
    /* time delay should be exactly 5s to match delay in test asset */
    _.time.out( 5000, () => o.pnd.send( 'SIGINT' ) ); /* qqq : parametrize time delays */
    return null;
  })

  o.conTerminate.then( ( got ) => /* qqq : then( ( got ) -> then( ( op ) or then( ( arg ) */
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Terminated by user' ), 0 );
    test.identical( _.strCount( got.output, 'Unexpected termination' ), 0 );
    test.identical( _.strCount( got.output, 'Executing onSuiteEnd' ), 1 );
    test.identical( _.strCount( got.output, 'Error in suite.onSuiteEnd' ), 0 );
    test.identical( _.strCount( got.output, 'Error' ), 1 );
    test.identical( _.strCount( got.output, 'error' ), 1 );
    test.identical( _.strCount( got.output, 'Message of Error' ), 1 );
    test.identical( _.strCount( got.output, 'Thrown 1 error' ), 1 );
    test.identical( _.strCount( got.output, 'Thrown' ), 1 );
    test.identical( _.strCount( got.output, 'ExitCode : 130' ), 1 );
    test.identical( _.strCount( got.output, 'Exit signal : SIGINT ( 128+2 )' ), 1 );

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
  let filePath/*programPath*/ = a.program({ entry : program1, locals }).filePath/*programPath*/;
  let ready = _.take( null );

  /* */

  ready.then( function( arg )
  {
    test.case = 'throwing:1 errAttend:1 terminationBegin:1';
    let opts = { throwing : 1, errAttend : 1, terminationBegin : 1 };
    a.fileProvider.fileWrite({ filePath : file1Path, data : opts, encoding : 'json' });
    a.forkNonThrowing
    ({
      execPath : filePath/*programPath*/,
      mode : 'fork',
    })
    .tap( ( _err, op ) =>
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
      execPath : filePath/*programPath*/,
      mode : 'fork',
    })
    .tap( ( _err, op ) =>
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
      execPath : filePath/*programPath*/,
      mode : 'fork',
    })
    .tap( ( _err, op ) =>
    {
      test.identical( _.strCount( op.output, 'Waiting' ), 0 );
      test.identical( _.strCount( op.output, 'procedure::' ), 0 );
      test.identical( _.strCount( op.output, 'ncaught' ), 0 );
      test.identical( _.strCount( op.output, 'synchronous' ), 0 );
      test.identical( _.strCount( op.output, 'Error' ), 4 );
      test.identical( _.strCount( op.output, 'error' ), 6 );
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
      execPath : filePath/*programPath*/,
      mode : 'fork',
    })
    .tap( ( _err, op ) =>
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
    const _ = require( toolsPath );
    _.include( 'wTesting' );
    const __ = _globals_.testing.wTools;
    let input = { map : __.fileProvider.fileRead({ filePath : __.path.join( __dirname, 'File1' ), encoding : 'json' }) };

    function routine1( test )
    {
      test.true( true );
      let con = new __.Consequence();
      __.time.out( context.t1, () =>
      {
        if( input.map.throwing )
        {
          if( input.map.errAttend )
          con.error( __.errAttend( 'Error1' ) );
          else
          con.error( 'Error1' );
        }
        else
        {
          con.take( null );
        }
      });
      con.tap( ( _err, arg ) =>
      {
        if( input.map.terminationBegin )
        __.procedure.terminationBegin();
      });
      return con;
    }

    const Proto =
    {
      routineTimeOut : context.t1*100,
      tests :
      {
        routine1,
      }
    }

    const Self = wTestSuite( Proto );
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
  let a = context.assetFor( test );
  a.reflect();

  /* - */

  a.appStartNonThrowing( `${a.abs( 'Test.test.js' )} v:7` );
  a.ready.then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'onSuiteEnd : 2' ), 1 );
    test.identical( _.strCount( op.output, 'onExit : 1' ), 1 );
    test.identical( _.strCount( op.output, 'Terminated by user' ), 0 );
    test.identical( _.strCount( op.output, 'by user' ), 0 );
    test.identical( _.strCount( op.output, 'Unexpected termination' ), 1 );
    test.identical( _.strCount( op.output, 'Error' ), 0 );
    test.identical( _.strCount( op.output, 'error' ), 1 );
    return op;
  });

  /* - */

  return a.ready;
}

manualTermination.description =
`
  User terminates execution when second test routine is runnning.
  onSuiteEnd handler should be executed after exit event
  exit code should be not zero
`

//

function manualTerminationAsync( test )
{
  let context = this;
  let a = context.assetFor( test );
  a.reflect();

  /* - */

  a.appStartNonThrowing( `${a.abs( 'Test.test.js' )} v:7` );
  a.ready .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'onSuiteEnd : 2' ), 1 );
    test.identical( _.strCount( op.output, 'onExit : 1' ), 1 );
    test.identical( _.strCount( op.output, 'Terminated by user' ), 0 );
    test.identical( _.strCount( op.output, 'by user' ), 0 );
    test.identical( _.strCount( op.output, 'Unexpected termination' ), 1 );
    test.identical( _.strCount( op.output, 'Error in callback::onSuiteEnd of TestSuite::manualTermination' ), 1 );
    test.identical( _.strCount( op.output, 'Error' ), 1 );
    test.identical( _.strCount( op.output, 'error' ), 1 );
    return op;
  })

  /* - */

  return a.ready;
}

manualTerminationAsync.description =
`
  User terminates execution when second test routine is runnning.
  onSuiteEnd handler should be executed after exit event
  exit code should be not zero
  on suite end returns consequence
`

//

function uncaughtErrorNotSilenced( test )
{
  let context = this;
  let a = context.assetFor( test, false );
  let filePath/*programPath*/ = a.program({ entry : program1 }).filePath/*programPath*/;

  /* */

  a.forkNonThrowing
  ({
    execPath : filePath/*programPath*/,
    args : [ 'silencing:1' ],
    mode : 'fork',
  })
  .tap( ( _err, op ) =>
  {
    test.case = 'basic';
    test.identical( _.strCount( op.output, 'uncaught error' ), 2 );
    test.identical( _.strCount( op.output, 'Terminated by user' ), 0 );
    test.identical( _.strCount( op.output, 'Unexpected termination' ), 0 );
    test.notIdentical( op.exitCode, 0 );
  });

  return a.ready;

  /* */

  return ready;

  /* - */

  function program1()
  {
    const _ = require( toolsPath );
    _.include( 'wTesting' );

    const errCallback = ( o ) =>
    {
      throw _.err( o.err );
    }

    /* throw uncaughtError because event handler should be _.process._edispatcher */
    _.event.on( _.process, { callbackMap : { 'uncaughtError' : errCallback } } );

    function routine1( test )
    {
      _.time.begin( 1, () => _.error._handleUncaught2({ err : 'Error1' }) );
    }

    const Proto =
    {
      tests :
      {
        routine1,
      }
    }

    const Self = wTestSuite( Proto );
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
  var got = a.program( testApp1 ).filePath/*programPath*/;
  var exp = a.path.nativize( a.path.join( a.routinePath, testApp1.name ) );
  test.il( got, exp )

  test.case = 'options : routine, dirPath'
  var got = a.program({ entry : testApp1, dirPath : 'temp' }).filePath/*programPath*/;
  var exp = a.path.nativize( a.path.join( a.routinePath, 'temp', testApp1.name ) );
  test.il( got, exp )

  test.case = 'options : routine, dirPath with spaces'
  var got = a.program({ entry : testApp1, dirPath : 'temp with spaces' }).filePath/*programPath*/;
  var exp = a.path.nativize( a.path.join( a.routinePath, 'temp with spaces', testApp1.name ) );
  test.il( got, exp )

  /* */

  function testApp1(){}
}

//

function toolsPathGetBasic( test )
{
  let context = this;

  /* */

  test.case = 'basic';
  var got = _.module.toolsPathGet();
  // var exp = __.path.join( _.module.resolve( 'wTools' ), 'Tools' );
  var exp = _.module.resolve( 'wTools' );
  test.identical( got, exp );
  console.log( `toolsPath : ${got}` );

  /* */

}

//

function toolsPathGetTester( test )
{
  let context = this;
  let a = test.assetFor( false );
  let programPath = a.program( program ).filePath;

  var exp = _.module.resolve( 'wTools' );
  var toolsPath1 = _.module.toolsPathGet();
  return a.forkNonThrowing({ execPath : programPath })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var toolsPath2 = op.output.trim();
    console.log( toolsPath2 );
    test.identical( toolsPath1, exp );
    test.identical( toolsPath2, a.path.nativize( exp ) );
    return op;
  });

  /* */

  function program()
  {
    console.log( toolsPath );
  }

}

// --
// related
// --

function timeLimitConsequence( test )
{
  let t = 25;
  let ready = new _.take( null )

  /* */

  .thenKeep( function timeLimit1( arg )
  {
    test.case = 'timeOut timeLimit a timeLimitOut';

    var con = _.time.out( Number( t ) );
    var con0 = _.time.out( t*3, 'a' );
    con.timeLimit( t*6, con0 );

    return _.time.out( t*15, function()
    {
      test.true( con.argumentsGet()[ 0 ] === 'a' );
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

function checkDiffWithRoutines( test )
{
  let context = this;
  let a = context.assetFor( test, 'failout' );

  a.reflect();
  test.true( a.fileProvider.fileExists( a.abs( 'Fail.test.js' ) ) );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'not identical maps with 1 identical function';
    return null;
  });

  a.appStartNonThrowing({ execPath : `${a.abs( 'Fail.test.js' )} r:identical1` })
  .then( ( op ) =>
  {
    test.nil( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `{ 'a' : 'reducing1' }`;
    let exp3 = `- expected :`;
    let exp4 = `{ 'a' : 'reducing2' }`;
    let exp5 = `- difference :`;
    let exp6 = `{ 'a' : 'reducing*`;

    test.identical( _.strCount( op.output, exp1 ), 1 );
    test.identical( _.strCount( op.output, exp2 ), 1 );
    test.identical( _.strCount( op.output, exp3 ), 1 );
    test.identical( _.strCount( op.output, exp4 ), 1 );
    test.identical( _.strCount( op.output, exp5 ), 1 );
    test.identical( _.strCount( op.output, exp6 ), 1 );

    return null;
  });

  /* - */

  a.ready.then( () =>
  {
    test.case = 'not identical maps with 1 identical and 1 different functions';
    return null;
  });

  a.appStartNonThrowing({ execPath : `${a.abs( 'Fail.test.js' )} r:identical2` })
  .then( ( op ) =>
  {
    test.nil( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `{ 'f2' : [ routine b ], 'a' : 'reducing1' }`;
    let exp3 = `- expected :`;
    let exp4 = `{ 'f2' : [ routine b ], 'a' : 'reducing2' }`;
    let exp5 = `- difference :`;
    let exp6 = `{ 'f2' : [ routine b ], 'a' : 'reducing*`;

    test.identical( _.strCount( op.output, exp1 ), 1 );
    test.identical( _.strCount( op.output, exp2 ), 1 );
    test.identical( _.strCount( op.output, exp3 ), 1 );
    test.identical( _.strCount( op.output, exp4 ), 1 );
    test.identical( _.strCount( op.output, exp5 ), 1 );
    test.identical( _.strCount( op.output, exp6 ), 1 );

    return null;
  });

  /* - */

  a.ready.then( () =>
  {
    test.case = 'not identical maps with 3 identical and 1 different functions, with async';
    return null;
  });

  a.appStartNonThrowing({ execPath : `${a.abs( 'Fail.test.js' )} r:identical3` })
  .then( ( op ) =>
  {
    test.nil( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `{ 'f4' : [ routine a ], 'a' : 'reducing1' }`;
    let exp3 = `- expected :`;
    let exp4 = `{ 'f4' : [ routine a ], 'a' : 'reducing2' }`;
    let exp5 = `- difference :`;
    let exp6 = `{ 'f4' : [ routine a ], 'a' : 'reducing*`;

    test.identical( _.strCount( op.output, exp1 ), 1 );
    test.identical( _.strCount( op.output, exp2 ), 1 );
    test.identical( _.strCount( op.output, exp3 ), 1 );
    test.identical( _.strCount( op.output, exp4 ), 1 );
    test.identical( _.strCount( op.output, exp5 ), 1 );
    test.identical( _.strCount( op.output, exp6 ), 1 );

    return null;
  });

  return a.ready;
}

checkDiffWithRoutines.description =
`
Check diff from test.identical, when comparing maps that contain routines.
`

//

function checkDiffWithProto( test )
{
  let context = this;
  let a = context.assetFor( test, 'failout' );
  let filePath/*programPath*/ = a.program( program ).filePath/*programPath*/;

  a.reflect();

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 1 with __proto__ : {}';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:identical1` })
  .then( ( op ) =>
  {
    test.nil( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 2 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 2 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 4 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'identical maps, 2 with __proto__ : {}';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:identical2` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 1 with __proto__ : {}';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:identical3` })
  .then( ( op ) =>
  {
    test.nil( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello'`;
    let exp3 = `'a' : 'hello1'`;
    let exp4 = `- expected :`;
    let exp5 = `'b' : 'hello2'`;
    let exp6 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 2 );
    test.identical( _.strCount( op.output, exp2 ), 2 );
    test.identical( _.strCount( op.output, exp3 ), 2 );
    test.identical( _.strCount( op.output, exp4 ), 2 );
    test.identical( _.strCount( op.output, exp5 ), 0 );
    test.identical( _.strCount( op.output, exp6 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 2 with non empty equivalent __proto__';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:identical4` })
  .then( ( op ) =>
  {
    test.nil( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello'`;
    let exp3 = `'a' : 'hello1'`;
    let exp4 = `- expected :`;
    let exp5 = `'b' : 'hello2'`;
    let exp6 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 2 );
    test.identical( _.strCount( op.output, exp2 ), 2 );
    test.identical( _.strCount( op.output, exp3 ), 2 );
    test.identical( _.strCount( op.output, exp4 ), 2 );
    test.identical( _.strCount( op.output, exp5 ), 0 );
    test.identical( _.strCount( op.output, exp6 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'identical maps, 2 with identical __proto__';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:identical5` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `__proto__`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'identical maps, same fields on diff level in __proto__';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:identical6` })
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 2 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 2 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 4 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 1 with __proto__ : {}';
    return null;
  })

  return a.ready;

  /* - */

  function program()
  {
    const _ = require( toolsPath );
    _.include( 'wTesting' );

    /* */

    function identical1( test )
    {
      test.case = 'identical maps, 1 with __proto__ : {}';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, {} );

      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }

      test.identical( obj1, obj2 );
      test.identical( obj2, obj1 );
    }

    /* */

    function identical2( test )
    {
      test.case = 'identical maps, 2 with __proto__ : {}';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, {} );

      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, {} );

      test.identical( obj1, obj2 );
      test.identical( obj2, obj1 );
    }

    /* */

    function identical3( test )
    {
      test.case = 'not identical maps, 1 with __proto__ : {}';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, {} );

      let obj2 =
      {
        a : 'hello',
        b : 'hello2',
      }

      test.identical( obj1, obj2 );
      test.identical( obj2, obj1 );
    }

    /* */

    function identical4( test )
    {
      test.case = 'not identical maps, 2 with non empty equivalent __proto__';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, { c : 'hello3' } );

      let obj2 =
      {
        a : 'hello',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, { c : 'hello3' } );

      test.identical( obj1, obj2 );
      test.identical( obj2, obj1 );
    }

    /* */

    function identical5( test )
    {
      test.case = `identical maps, 2 with identical __proto__`;

      let proto = { 'c' : 'hello3' }
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, proto );

      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, proto );

      test.identical( obj1, obj2 );
      test.identical( obj2, obj1 );
    }

    /* */

    function identical6( test )
    {
      test.case = `identical maps, diff __proto__, same fields on diff level in __proto__`;
      let proto1 = {}
      Object.setPrototypeOf( proto1, { 'c' : 'hello3' } );

      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, proto1 );

      let proto2 = { 'c' : 'hello3' };
      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, proto2 );
      test.identical( obj1, obj2 );
      test.identical( obj2, obj1 );
    }

    /* */

    const Proto =
    {
      name : 'Fail',
      tests :
      {
        identical1,
        identical2,
        identical3,
        identical4,
        identical5,
        identical6,
      }
    }

    /* */

    const Self = wTestSuite( Proto );
    wTester.test();
  }
}

checkDiffWithProto.description =
`
Check diff from test.identical, when comparing maps that set new __proto__.
`

//

function checkDiffWithProtoEq( test )
{
  let context = this;
  let a = context.assetFor( test, 'failout' );
  let filePath/*programPath*/ = a.program( program ).filePath/*programPath*/;

  a.reflect();

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 1 with __proto__ : {}';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:equivalent1` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'identical maps, 2 with __proto__ : {}';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:equivalent2` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 1 with __proto__ : {}';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:equivalent3` })
  .then( ( op ) =>
  {
    test.nil( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello'`;
    let exp3 = `'a' : 'hello1'`;
    let exp4 = `- expected :`;
    let exp5 = `'b' : 'hello2'`;
    let exp6 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 2 );
    test.identical( _.strCount( op.output, exp2 ), 2 );
    test.identical( _.strCount( op.output, exp3 ), 2 );
    test.identical( _.strCount( op.output, exp4 ), 2 );
    test.identical( _.strCount( op.output, exp5 ), 0 );
    test.identical( _.strCount( op.output, exp6 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 2 with non empty equivalent __proto__';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:equivalent4` })
  .then( ( op ) =>
  {
    test.nil( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello'`;
    let exp3 = `'a' : 'hello1'`;
    let exp4 = `- expected :`;
    let exp5 = `'b' : 'hello2'`;
    let exp6 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 2 );
    test.identical( _.strCount( op.output, exp2 ), 2 );
    test.identical( _.strCount( op.output, exp3 ), 2 );
    test.identical( _.strCount( op.output, exp4 ), 2 );
    test.identical( _.strCount( op.output, exp5 ), 0 );
    test.identical( _.strCount( op.output, exp6 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'identical maps, 2 with identical __proto__';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:equivalent5` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `__proto__`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'identical maps, same fields on diff level in __proto__';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:equivalent6` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  return a.ready;

  /* - */

  function program()
  {
    const _ = require( toolsPath );
    _.include( 'wTesting' );

    /* */

    function equivalent1( test )
    {
      test.case = 'identical maps, 1 with __proto__ : {}';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, {} );

      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }

      test.eq( obj1, obj2 );
      test.eq( obj2, obj1 );
    }

    /* */

    function equivalent2( test )
    {
      test.case = 'identical maps, 2 with __proto__ : {}';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, {} );

      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, {} );

      test.eq( obj1, obj2 );
      test.eq( obj2, obj1 );
    }

    /* */

    function equivalent3( test )
    {
      test.case = 'not identical maps, 1 with __proto__ : {}';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, {} );

      let obj2 =
      {
        a : 'hello',
        b : 'hello2',
      }

      test.eq( obj1, obj2 );
      test.eq( obj2, obj1 );
    }

    /* */

    function equivalent4( test )
    {
      test.case = 'not identical maps, 2 with non empty equivalent __proto__';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, { c : 'hello3' } );

      let obj2 =
      {
        a : 'hello',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, { c : 'hello3' } );

      test.eq( obj1, obj2 );
      test.eq( obj2, obj1 );
    }

    /* */

    function equivalent5( test )
    {
      test.case = `identical maps, 2 with identical __proto__`;

      let proto = { 'c' : 'hello3' }
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, proto );

      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, proto );

      test.eq( obj1, obj2 );
      test.eq( obj2, obj1 );
    }

    /* */

    function equivalent6( test )
    {
      test.case = `identical maps, diff __proto__, same fields on diff level in __proto__`;
      let proto1 = {}
      Object.setPrototypeOf( proto1, { 'c' : 'hello3' } );

      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, proto1 );

      let proto2 = { 'c' : 'hello3' };
      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, proto2 );
      test.eq( obj1, obj2 );
      test.eq( obj2, obj1 );
    }

    const Proto =
    {
      name : 'Eq',
      tests :
      {
        equivalent1,
        equivalent2,
        equivalent3,
        equivalent4,
        equivalent5,
        equivalent6
      }
    }

    /* */

    const Self = wTestSuite( Proto );
    wTester.test();
  }
}

checkDiffWithProtoEq.description =
`
Check diff from test.eq, when comparing maps that set new __proto__.
`

//

function checkDiffWithProtoContains( test )
{
  let context = this;
  let a = context.assetFor( test, 'failout' );
  let filePath/*programPath*/ = a.program( program ).filePath/*programPath*/;

  a.reflect();

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 1 with __proto__ : {}';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:contains1` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'identical maps, 2 with __proto__ : {}';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:contains2` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 1 with __proto__ : {}';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:contains3` })
  .then( ( op ) =>
  {
    test.nil( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello'`;
    let exp3 = `'a' : 'hello1'`;
    let exp4 = `- expected :`;
    let exp5 = `'b' : 'hello2'`;
    let exp6 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 2 );
    test.identical( _.strCount( op.output, exp2 ), 2 );
    test.identical( _.strCount( op.output, exp3 ), 2 );
    test.identical( _.strCount( op.output, exp4 ), 2 );
    test.identical( _.strCount( op.output, exp5 ), 0 );
    test.identical( _.strCount( op.output, exp6 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 2 with non empty contains __proto__';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:contains4` })
  .then( ( op ) =>
  {
    test.nil( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello'`;
    let exp3 = `'a' : 'hello1'`;
    let exp4 = `- expected :`;
    let exp5 = `'b' : 'hello2'`;
    let exp6 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 2 );
    test.identical( _.strCount( op.output, exp2 ), 2 );
    test.identical( _.strCount( op.output, exp3 ), 2 );
    test.identical( _.strCount( op.output, exp4 ), 2 );
    test.identical( _.strCount( op.output, exp5 ), 0 );
    test.identical( _.strCount( op.output, exp6 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'identical maps, 2 with identical __proto__';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:contains5` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `__proto__`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'identical maps, same fields on diff level in __proto__';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:contains6` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  return a.ready;

  /* - */

  function program()
  {
    const _ = require( toolsPath );
    _.include( 'wTesting' );

    /* */

    function contains1( test )
    {
      test.case = 'identical maps, 1 with __proto__ : {}';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, {} );

      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }

      test.contains( obj1, obj2 );
      test.contains( obj2, obj1 );
    }

    /* */

    function contains2( test )
    {
      test.case = 'identical maps, 2 with __proto__ : {}';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, {} );

      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, {} );

      test.contains( obj1, obj2 );
      test.contains( obj2, obj1 );
    }

    /* */

    function contains3( test )
    {
      test.case = 'not identical maps, 1 with __proto__ : {}';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, {} );

      let obj2 =
      {
        a : 'hello',
        b : 'hello2',
      }

      test.contains( obj1, obj2 );
      test.contains( obj2, obj1 );
    }

    /* */

    function contains4( test )
    {
      test.case = 'not identical maps, 2 with non empty contains __proto__';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, { c : 'hello3' } );

      let obj2 =
      {
        a : 'hello',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, { c : 'hello3' } );

      test.contains( obj1, obj2 );
      test.contains( obj2, obj1 );
    }

    /* */

    function contains5( test )
    {
      test.case = `identical maps, 2 with identical __proto__`;

      let proto = { 'c' : 'hello3' }
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, proto );

      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, proto );

      test.contains( obj1, obj2 );
      test.contains( obj2, obj1 );
    }

    /* */

    function contains6( test )
    {
      test.case = `identical maps, diff __proto__, same fields on diff level in __proto__`;
      let proto1 = {}
      Object.setPrototypeOf( proto1, { 'c' : 'hello3' } );

      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, proto1 );

      let proto2 = { 'c' : 'hello3' };
      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, proto2 );
      test.contains( obj1, obj2 );
      test.contains( obj2, obj1 );
    }

    const Proto =
    {
      name : 'Contains',
      tests :
      {
        contains1,
        contains2,
        contains3,
        contains4,
        contains5,
        contains6
      }
    }

    /* */

    const Self = wTestSuite( Proto );
    wTester.test();
  }
}

checkDiffWithProtoContains.description =
`
Check diff from test.contains, when comparing maps that set new __proto__.
`
//

function checkDiffWithProtoContainsAll( test )
{
  let context = this;
  let a = context.assetFor( test, 'failout' );
  let filePath/*programPath*/ = a.program( program ).filePath/*programPath*/;

  a.reflect();

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 1 with __proto__ : {}';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:containsAll1` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'identical maps, 2 with __proto__ : {}';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:containsAll2` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 1 with __proto__ : {}';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:containsAll3` })
  .then( ( op ) =>
  {
    test.nil( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello'`;
    let exp3 = `'a' : 'hello1'`;
    let exp4 = `- expected :`;
    let exp5 = `'b' : 'hello2'`;
    let exp6 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 2 );
    test.identical( _.strCount( op.output, exp2 ), 2 );
    test.identical( _.strCount( op.output, exp3 ), 2 );
    test.identical( _.strCount( op.output, exp4 ), 2 );
    test.identical( _.strCount( op.output, exp5 ), 0 );
    test.identical( _.strCount( op.output, exp6 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 2 with non empty containsAll __proto__';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:containsAll4` })
  .then( ( op ) =>
  {
    test.nil( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello'`;
    let exp3 = `'a' : 'hello1'`;
    let exp4 = `- expected :`;
    let exp5 = `'b' : 'hello2'`;
    let exp6 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 2 );
    test.identical( _.strCount( op.output, exp2 ), 2 );
    test.identical( _.strCount( op.output, exp3 ), 2 );
    test.identical( _.strCount( op.output, exp4 ), 2 );
    test.identical( _.strCount( op.output, exp5 ), 0 );
    test.identical( _.strCount( op.output, exp6 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'identical maps, 2 with identical __proto__';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:containsAll5` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `__proto__`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'identical maps, same fields on diff level in __proto__';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:containsAll6` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  return a.ready;

  /* - */

  function program()
  {
    const _ = require( toolsPath );
    _.include( 'wTesting' );

    /* */

    function containsAll1( test )
    {
      test.case = 'identical maps, 1 with __proto__ : {}';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, {} );

      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }

      test.containsAll( obj1, obj2 );
      test.containsAll( obj2, obj1 );
    }

    /* */

    function containsAll2( test )
    {
      test.case = 'identical maps, 2 with __proto__ : {}';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, {} );

      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, {} );

      test.containsAll( obj1, obj2 );
      test.containsAll( obj2, obj1 );
    }

    /* */

    function containsAll3( test )
    {
      test.case = 'not identical maps, 1 with __proto__ : {}';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, {} );

      let obj2 =
      {
        a : 'hello',
        b : 'hello2',
      }

      test.containsAll( obj1, obj2 );
      test.containsAll( obj2, obj1 );
    }

    /* */

    function containsAll4( test )
    {
      test.case = 'not identical maps, 2 with non empty containsAll __proto__';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, { c : 'hello3' } );

      let obj2 =
      {
        a : 'hello',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, { c : 'hello3' } );

      test.containsAll( obj1, obj2 );
      test.containsAll( obj2, obj1 );
    }

    /* */

    function containsAll5( test )
    {
      test.case = `identical maps, 2 with identical __proto__`;

      let proto = { 'c' : 'hello3' }
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, proto );

      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, proto );

      test.containsAll( obj1, obj2 );
      test.containsAll( obj2, obj1 );
    }

    /* */

    function containsAll6( test )
    {
      test.case = `identical maps, diff __proto__, same fields on diff level in __proto__`;
      let proto1 = {}
      Object.setPrototypeOf( proto1, { 'c' : 'hello3' } );

      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, proto1 );

      let proto2 = { 'c' : 'hello3' };
      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, proto2 );
      test.containsAll( obj1, obj2 );
      test.containsAll( obj2, obj1 );
    }

    const Proto =
    {
      name : 'ContainsAll',
      tests :
      {
        containsAll1,
        containsAll2,
        containsAll3,
        containsAll4,
        containsAll5,
        containsAll6
      }
    }

    /* */

    const Self = wTestSuite( Proto );
    wTester.test();
  }
}

checkDiffWithProtoContainsAll.description =
`
Check diff from test.containsAll, when comparing maps that set new __proto__.
`

//

function checkDiffWithProtoContainsAny( test )
{
  let context = this;
  let a = context.assetFor( test, 'failout' );
  let filePath/*programPath*/ = a.program( program ).filePath/*programPath*/;

  a.reflect();

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 1 with __proto__ : {}';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:containsAny1` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'identical maps, 2 with __proto__ : {}';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:containsAny2` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 1 with __proto__ : {}';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:containsAny3` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello'`;
    let exp3 = `'a' : 'hello1'`;
    let exp4 = `- expected :`;
    let exp5 = `'b' : 'hello2'`;
    let exp6 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );
    test.identical( _.strCount( op.output, exp6 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 2 with non empty containsAny __proto__';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:containsAny4` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello'`;
    let exp3 = `'a' : 'hello1'`;
    let exp4 = `- expected :`;
    let exp5 = `'b' : 'hello2'`;
    let exp6 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );
    test.identical( _.strCount( op.output, exp6 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'identical maps, 2 with identical __proto__';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:containsAny5` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `__proto__`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'identical maps, same fields on diff level in __proto__';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:containsAny6` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  return a.ready;

  /* - */

  function program()
  {
    const _ = require( toolsPath );
    _.include( 'wTesting' );

    /* */

    function containsAny1( test )
    {
      test.case = 'identical maps, 1 with __proto__ : {}';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, {} );

      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }

      test.containsAny( obj1, obj2 );
      test.containsAny( obj2, obj1 );
    }

    /* */

    function containsAny2( test )
    {
      test.case = 'identical maps, 2 with __proto__ : {}';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, {} );

      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, {} );

      test.containsAny( obj1, obj2 );
      test.containsAny( obj2, obj1 );
    }

    /* */

    function containsAny3( test )
    {
      test.case = 'not identical maps, 1 with __proto__ : {}';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, {} );

      let obj2 =
      {
        a : 'hello',
        b : 'hello2',
      }

      test.containsAny( obj1, obj2 );
      test.containsAny( obj2, obj1 );
    }

    /* */

    function containsAny4( test )
    {
      test.case = 'not identical maps, 2 with non empty containsAny __proto__';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, { c : 'hello3' } );

      let obj2 =
      {
        a : 'hello',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, { c : 'hello3' } );

      test.containsAny( obj1, obj2 );
      test.containsAny( obj2, obj1 );
    }

    /* */

    function containsAny5( test )
    {
      test.case = `identical maps, 2 with identical __proto__`;

      let proto = { 'c' : 'hello3' }
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, proto );

      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, proto );

      test.containsAny( obj1, obj2 );
      test.containsAny( obj2, obj1 );
    }

    /* */

    function containsAny6( test )
    {
      test.case = `identical maps, diff __proto__, same fields on diff level in __proto__`;
      let proto1 = {}
      Object.setPrototypeOf( proto1, { 'c' : 'hello3' } );

      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, proto1 );

      let proto2 = { 'c' : 'hello3' };
      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, proto2 );
      test.containsAny( obj1, obj2 );
      test.containsAny( obj2, obj1 );
    }

    const Proto =
    {
      name : 'ContainsAny',
      tests :
      {
        containsAny1,
        containsAny2,
        containsAny3,
        containsAny4,
        containsAny5,
        containsAny6
      }
    }

    /* */

    const Self = wTestSuite( Proto );
    wTester.test();
  }
}

checkDiffWithProtoContainsAny.description =
`
Check diff from test.containsAny, when comparing maps that set new __proto__.
`

//

function checkDiffWithProtoContainsOnly( test )
{
  let context = this;
  let a = context.assetFor( test, 'failout' );
  let filePath/*programPath*/ = a.program( program ).filePath/*programPath*/;

  a.reflect();

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 1 with __proto__ : {}';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:containsOnly1` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'identical maps, 2 with __proto__ : {}';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:containsOnly2` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 1 with __proto__ : {}';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:containsOnly3` })
  .then( ( op ) =>
  {
    test.nil( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello'`;
    let exp3 = `'a' : 'hello1'`;
    let exp4 = `- expected :`;
    let exp5 = `'b' : 'hello2'`;
    let exp6 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 2 );
    test.identical( _.strCount( op.output, exp2 ), 2 );
    test.identical( _.strCount( op.output, exp3 ), 2 );
    test.identical( _.strCount( op.output, exp4 ), 2 );
    test.identical( _.strCount( op.output, exp5 ), 0 );
    test.identical( _.strCount( op.output, exp6 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'not identical maps, 2 with non empty containsOnly __proto__';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:containsOnly4` })
  .then( ( op ) =>
  {
    test.nil( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello'`;
    let exp3 = `'a' : 'hello1'`;
    let exp4 = `- expected :`;
    let exp5 = `'b' : 'hello2'`;
    let exp6 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 2 );
    test.identical( _.strCount( op.output, exp2 ), 2 );
    test.identical( _.strCount( op.output, exp3 ), 2 );
    test.identical( _.strCount( op.output, exp4 ), 2 );
    test.identical( _.strCount( op.output, exp5 ), 0 );
    test.identical( _.strCount( op.output, exp6 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'identical maps, 2 with identical __proto__';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:containsOnly5` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `__proto__`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'identical maps, same fields on diff level in __proto__';
    return null;
  })

  a.appStartNonThrowing({ execPath : `${filePath/*programPath*/} r:containsOnly6` })
  .then( ( op ) =>
  {
    test.il( op.exitCode, 0 );

    let exp1 = `- got :`;
    let exp2 = `'a' : 'hello1'`;
    let exp3 = `- expected :`;
    let exp4 = `'b' : 'hello2'`;
    let exp5 = `'__proto__'`;

    test.identical( _.strCount( op.output, exp1 ), 0 );
    test.identical( _.strCount( op.output, exp2 ), 0 );
    test.identical( _.strCount( op.output, exp3 ), 0 );
    test.identical( _.strCount( op.output, exp4 ), 0 );
    test.identical( _.strCount( op.output, exp5 ), 0 );

    return null;
  })

  return a.ready;

  /* - */

  function program()
  {
    const _ = require( toolsPath );
    _.include( 'wTesting' );

    /* */

    function containsOnly1( test )
    {
      test.case = 'identical maps, 1 with __proto__ : {}';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, {} );

      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }

      test.containsOnly( obj1, obj2 );
      test.containsOnly( obj2, obj1 );
    }

    /* */

    function containsOnly2( test )
    {
      test.case = 'identical maps, 2 with __proto__ : {}';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, {} );

      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, {} );

      test.containsOnly( obj1, obj2 );
      test.containsOnly( obj2, obj1 );
    }

    /* */

    function containsOnly3( test )
    {
      test.case = 'not identical maps, 1 with __proto__ : {}';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, {} );

      let obj2 =
      {
        a : 'hello',
        b : 'hello2',
      }

      test.containsOnly( obj1, obj2 );
      test.containsOnly( obj2, obj1 );
    }

    /* */

    function containsOnly4( test )
    {
      test.case = 'not identical maps, 2 with non empty containsOnly __proto__';
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, { c : 'hello3' } );

      let obj2 =
      {
        a : 'hello',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, { c : 'hello3' } );

      test.containsOnly( obj1, obj2 );
      test.containsOnly( obj2, obj1 );
    }

    /* */

    function containsOnly5( test )
    {
      test.case = `identical maps, 2 with identical __proto__`;

      let proto = { 'c' : 'hello3' }
      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, proto );

      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, proto );

      test.containsOnly( obj1, obj2 );
      test.containsOnly( obj2, obj1 );
    }

    /* */

    function containsOnly6( test )
    {
      test.case = `identical maps, diff __proto__, same fields on diff level in __proto__`;
      let proto1 = {}
      Object.setPrototypeOf( proto1, { 'c' : 'hello3' } );

      let obj1 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj1, proto1 );

      let proto2 = { 'c' : 'hello3' };
      let obj2 =
      {
        a : 'hello1',
        b : 'hello2',
      }
      Object.setPrototypeOf( obj2, proto2 );
      test.containsOnly( obj1, obj2 );
      test.containsOnly( obj2, obj1 );
    }

    const Proto =
    {
      name : 'ContainsOnly',
      tests :
      {
        containsOnly1,
        containsOnly2,
        containsOnly3,
        containsOnly4,
        containsOnly5,
        containsOnly6
      }
    }

    //

    const Self = wTestSuite( Proto );
    wTester.test();
  }
}

checkDiffWithProtoContainsOnly.description =
`
Check diff from test.containsOnly, when comparing maps that set new __proto__.
`

//

function typescriptSupport( test )
{
  let context = this;
  let a = context.assetFor( test, 'typescriptSupport' );

  a.reflect();

  /* */

  a.ready.then( () =>
  {
    test.case = 'detects and runs typescript tests';
    return null;
  })

  a.appStartNonThrowing({ args : [ '.run', a.abs( 'tests/**' ) ] })

  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Passed TestSuite::TestSuite1.test.ts' ), 1 );
    test.identical( _.strCount( op.output, 'Passed TestSuite::TestSuite2.test.ts' ), 1 );
    test.identical( _.strCount( op.output, 'Passed test routines 2 / 2' ), 1 );
    test.identical( _.strCount( op.output, 'Passed test suites 2 / 2' ), 1 );

    return null;
  })

  /* */

  a.ready.then( () =>
  {
    test.case = 'runs single ts test suite';
    return null;
  })

  a.appStartNonThrowing({ args : [ '.run', a.abs( 'tests/TestSuite1.test.ts' ) ] })

  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    test.identical( _.strCount( op.output, 'Passed TestSuite::TestSuite1.test.ts' ), 1 );
    test.identical( _.strCount( op.output, 'Passed test routines 1 / 1' ), 2 );
    test.identical( _.strCount( op.output, 'Passed test suites 1 / 1' ), 1 );

    return null;
  })

  /* */

  return a.ready;
}

typescriptSupport.description =
`
  - Tester should detect typescript test files and include them into the run.
`

// --
// suite
// --

const Proto =
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
    runDebugTst,
    runWithQuotedPath,
    runWithSeveralSimilarOptions,
    runWithSeveralMixedOptions,
    runWithQuotedArrayWithSpaces,
    runWithWrongSyntaxAndQuotedArrayWithSpaces,
    runWithQuotedArrayWithSpacesAndRapidity,
    runCheckNotRewritingDefaultOption,
    runCheckRewritingSuiteOptions,
    runExperimentalRoutines,
    runExcludeNodeModules,

    checkFails,
    double,
    requireTesting,
    noTestCheck,
    noTestSuite,
    exitCodeSeveralTestSuites,
    globalTestingTestToolsProblemFullModuleProblem,
    globalTestingTestToolsSingleSuiteProblem,

    // options

    optionSuite,
    optionAccuracyExplicitly,
    optionAccuracy,
    optionRapidityAndSourceCode,
    optionRapidity,
    optionRapidityTwice,
    optionFails,

    // commands

    help,
    version,
    imply,
    context,

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
    manualTerminationAsync,
    uncaughtErrorNotSilenced,
    asyncErrorHandling,

    // test asset

    programOptionsRoutineDirPath,
    toolsPathGetBasic,
    toolsPathGetTester,

    // related

    timeLimitConsequence,
    checkDiffWithRoutines,
    checkDiffWithProto,
    checkDiffWithProtoEq,
    checkDiffWithProtoContains,
    checkDiffWithProtoContainsAll,
    checkDiffWithProtoContainsAny,
    checkDiffWithProtoContainsOnly,

    // typescript

    typescriptSupport,

  }

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
