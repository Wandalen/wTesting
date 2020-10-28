( function _Procedure_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  if( typeof _realGlobal_ === 'undefined' || !_realGlobal_.wTester || !_realGlobal_.wTester._isReal_ )
  require( '../tester/entry/Main.s' );

  _.include( 'wProcess' );

}

let _global = _global_;
let _ = _global_.wTools;

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


// --
// test
// --

function terminationBeginWithTwoNamespaces( test )
{
  let context = this;
  let a = test.assetFor( 'double' );
  let locals = { toolsPath : a.path.nativize( _.module.toolsPathGet() ) };
  let programPath1 = a.program({ routine : program1, locals });
  let programPath2 = a.program({ routine : program2, locals });

  /* */

  a.appStartNonThrowing({ execPath : programPath1 })
  .then( ( op ) =>
  {
    test.case = 'termination of procedures from first global namespace';
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Global procedures : undefined' ), 0 );
    test.identical( _.strCount( op.output, 'GLOBAL WHICH : real' ), 1 );
    test.identical( _.strCount( op.output, 'Global procedures : 2' ), 2 );
    test.identical( _.strCount( op.output, 'GLOBAL WHICH : wTesting' ), 1 );
    test.identical( _.strCount( op.output, 'Instances are identical : false' ), 1 );
    test.identical( _.strCount( op.output, 'timer1' ), 1 );
    test.identical( _.strCount( op.output, 'timer2' ), 1 );
    test.identical( _.strCount( op.output, 'terminationBegin1' ), 1 );
    test.identical( _.strCount( op.output, /v1(.|\n|\r)*terminationBegin1(.|\n|\r)*timer(.|\n|\r)*terminationEnd1(.|\n|\r)*/mg ), 1 );
    test.identical( _.strCount( op.output, 'Waiting for' ), 1 );
    test.identical( _.strCount( op.output, 'procedure::' ), 1 );
    test.identical( _.strCount( op.output, 'v1' ), 1 );
    test.identical( _.strCount( op.output, 'terminationEnd1' ), 1 );
    test.identical( _.strCount( op.output, 'terminationEnd2' ), 1 );
    return null;
  });

  a.appStartNonThrowing({ execPath : programPath2 })
  .then( ( op ) =>
  {
    test.case = 'termination of procedures from second global namespace';
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Global procedures : undefined' ), 0 );
    test.identical( _.strCount( op.output, 'GLOBAL WHICH : real' ), 1 );
    test.identical( _.strCount( op.output, 'Global procedures : 2' ), 2 );
    test.identical( _.strCount( op.output, 'GLOBAL WHICH : wTesting' ), 1 );
    test.identical( _.strCount( op.output, 'Instances are identical : false' ), 1 );
    test.identical( _.strCount( op.output, 'timer1' ), 1 );
    test.identical( _.strCount( op.output, 'timer2' ), 1 );
    test.identical( _.strCount( op.output, 'terminationBegin1' ), 1 );
    test.identical( _.strCount( op.output, /v1(.|\n|\r)*terminationBegin1(.|\n|\r)*timer(.|\n|\r)*terminationEnd1(.|\n|\r)*/mg ), 1 );
    test.identical( _.strCount( op.output, 'Waiting for' ), 1 );
    test.identical( _.strCount( op.output, 'procedure::' ), 1 );
    test.identical( _.strCount( op.output, 'v1' ), 1 );
    test.identical( _.strCount( op.output, 'terminationEnd1' ), 1 );
    test.identical( _.strCount( op.output, 'terminationEnd2' ), 1 );
    return null;
  });

  /* */

  return a.ready;

  /* */

  function program1()
  {
    let _ = require( toolsPath );

    console.log( `Global procedures : ${ _realGlobal_._ProcedureGlobals_ }` );

    _.include( 'wConsequence' );
    _.include( 'wProcedure' );

    console.log( `Global procedures : ${ _realGlobal_._ProcedureGlobals_.length }` );
    console.log( `GLOBAL WHICH : ${ _realGlobal_._ProcedureGlobals_[ 0 ].__GLOBAL_WHICH__ }` );

    _.include( 'wTesting' );

    console.log( `Global procedures : ${ _realGlobal_._ProcedureGlobals_.length }` );
    console.log( `GLOBAL WHICH : ${ _realGlobal_._ProcedureGlobals_[ 1 ].__GLOBAL_WHICH__ }` );

    console.log( `Instances are identical : ${ _realGlobal_._ProcedureGlobals_[ 0 ] === _realGlobal_._ProcedureGlobals_[ 1 ] }` );

    let t = _testerGlobal_.wTools;

    /* */

    let timeOut = 1500;

    let timer = _.time.begin( timeOut, () =>
    {
      console.log( 'timer1' );
    });

    let timerT = t.time.begin( timeOut, () =>
    {
      console.log( 'timer2' );
    });

    console.log( 'v1' );

    /* */

    _.procedure.on( 'terminationBegin', () =>
    {
      console.log( 'terminationBegin1' );
    });

    _.procedure.on( 'terminationEnd', () =>
    {
      console.log( 'terminationEnd1' );
    });

    t.procedure.on( 'terminationEnd', () =>
    {
      console.log( 'terminationEnd2' );
    });

    /* */

    _.procedure.terminationPeriod = 1000;
    _.procedure.terminationBegin();
  }

  /* */

  function program2()
  {
    let _ = require( toolsPath );

    console.log( `Global procedures : ${ _realGlobal_._ProcedureGlobals_ }` );

    _.include( 'wConsequence' );
    _.include( 'wProcedure' );

    console.log( `Global procedures : ${ _realGlobal_._ProcedureGlobals_.length }` );
    console.log( `GLOBAL WHICH : ${ _realGlobal_._ProcedureGlobals_[ 0 ].__GLOBAL_WHICH__ }` );

    _.include( 'wTesting' );

    console.log( `Global procedures : ${ _realGlobal_._ProcedureGlobals_.length }` );
    console.log( `GLOBAL WHICH : ${ _realGlobal_._ProcedureGlobals_[ 1 ].__GLOBAL_WHICH__ }` );

    console.log( `Instances are identical : ${ _realGlobal_._ProcedureGlobals_[ 0 ] === _realGlobal_._ProcedureGlobals_[ 1 ] }` );

    let t = _testerGlobal_.wTools;

    /* */

    let timeOut = 1500;

    let timer = _.time.begin( timeOut, () =>
    {
      console.log( 'timer1' );
    });

    let timerT = t.time.begin( timeOut, () =>
    {
      console.log( 'timer2' );
    });

    /* */

    console.log( 'v1' );

    t.procedure.on( 'terminationBegin', () =>
    {
      console.log( 'terminationBegin1' );
    });

    t.procedure.on( 'terminationEnd', () =>
    {
      console.log( 'terminationEnd1' );
    });

    _.procedure.on( 'terminationEnd', () =>
    {
      console.log( 'terminationEnd2' );
    });

    /* */

    t.procedure.terminationPeriod = 1000;
    t.procedure.terminationBegin();
  }

}

terminationBeginWithTwoNamespaces.timeOut = 60000;
terminationBeginWithTwoNamespaces.description =
`
- terminationBegin terminate global namespaces in _ProcedureGlobals_
- each global namespace terminate own procedures
`

// --
// declare
// --

let Self =
{
  name : 'Tools.Tester.Procedure',
  silencing : 1,
  processWatching : 1,
  routineTimeOut : 30000,

  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null,
  },

  tests :
  {
    terminationBeginWithTwoNamespaces,
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
