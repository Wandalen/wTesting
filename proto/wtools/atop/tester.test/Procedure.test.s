( function _Procedure_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  require( '../tester/entry/Main.s' );

  _.include( 'wProcess' );
  _.include( 'wProcedure' );

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
  var testRoutine;
  let a = test.assetFor( 'double' );
  let locals = { toolsPath : a.path.nativize( _.module.toolsPathGet() ) };
  let programPath1 = a.program({ routine : program1, locals });
  let programPath2 = a.program({ routine : program2, locals });
  let currentPath = a.abs( '.' );

  /* */

  function testResult1( t )
  {
    let context = this;
    testRoutine = t;

    let start = _.process.starter
    ({
      execPath : 'node ',
      currentPath,
      outputCollecting : 1,
      outputGraying : 1,
      throwingExitCode : 0,
      mode : 'shell',
    });

    let start2 = _.process.starter
    ({
      execPath : 'node ',
      currentPath,
      outputCollecting : 1,
      outputGraying : 1,
      throwingExitCode : 0,
      mode : 'shell',
    });

    let con1 = start( programPath1 )
    .then( ( op ) =>
    {
      t.case = 'termination of procedures from first global namespace';
      t.identical( op.exitCode, 0 );
      t.identical( _.strCount( op.output, 'Global procedures : 1' ), 2 );
      t.identical( _.strCount( op.output, 'GLOBAL WHICH : real' ), 1 );
      t.identical( _.strCount( op.output, 'Global procedures : 2' ), 1 );
      t.identical( _.strCount( op.output, 'GLOBAL WHICH : wTesting' ), 1 );
      t.identical( _.strCount( op.output, 'Instances are identical : false' ), 1 );
      t.identical( _.strCount( op.output, 'Wrong namespace for _.' ), 0 );
      t.identical( _.strCount( op.output, 'timer1' ), 1 );
      t.identical( _.strCount( op.output, 'timer2' ), 1 );
      t.identical( _.strCount( op.output, 'terminationBegin1' ), 1 );
      t.identical( _.strCount( op.output, /v1(.|\n|\r)*terminationBegin1(.|\n|\r)*time(.|\n|\r)*terminationEnd1(.|\n|\r)*/mg ), 1 );
      t.identical( _.strCount( op.output, 'Waiting for' ), 1 );
      t.identical( _.strCount( op.output, 'procedure::' ), 1 );
      t.identical( _.strCount( op.output, 'v1' ), 1 );
      t.identical( _.strCount( op.output, 'terminationEnd1' ), 1 );
      return null;
    });

    let con2 = start2( programPath2 )
    .then( ( op ) =>
    {
      t.case = 'termination of procedures from second global namespace';
      t.identical( op.exitCode, 0 );
      t.identical( _.strCount( op.output, 'Global procedures : 1' ), 2 );
      t.identical( _.strCount( op.output, 'GLOBAL WHICH : real' ), 1 );
      t.identical( _.strCount( op.output, 'Global procedures : 2' ), 1 );
      t.identical( _.strCount( op.output, 'GLOBAL WHICH : wTesting' ), 1 );
      t.identical( _.strCount( op.output, 'Instances are identical : false' ), 1 );
      t.identical( _.strCount( op.output, 'Wrong namespace for _.' ), 0 );
      t.identical( _.strCount( op.output, 'timer1' ), 1 );
      t.identical( _.strCount( op.output, 'timer2' ), 1 );
      t.identical( _.strCount( op.output, 'terminationBegin1' ), 1 );
      t.identical( _.strCount( op.output, /v1(.|\n|\r)*terminationBegin1(.|\n|\r)*time(.|\n|\r)*terminationEnd1(.|\n|\r)*/mg ), 1 );
      t.identical( _.strCount( op.output, 'Waiting for' ), 1 );
      t.identical( _.strCount( op.output, 'procedure::' ), 1 );
      t.identical( _.strCount( op.output, 'v1' ), 1 );
      t.identical( _.strCount( op.output, 'terminationEnd1' ), 1 );
      return null;
    });

    return _.Consequence.AndTake( con1, con2 );
  }

  /* */

  var suite = wTestSuite
  ({
    tests : { testResult1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run()
  .finally( ( err, data ) =>
  {

    var acheck = testRoutine.checkCurrent();
    test.identical( acheck.checkIndex, 31 );
    test.identical( suite.report.testCheckPasses, 30 );
    test.identical( suite.report.testCheckFails, 0 );

    if( err )
    throw err;

    return null;
  });

  /* */

  return result;

  /* */

  function program1()
  {
    let _ = require( toolsPath );

    let keys = _.mapKeys( _realGlobal_._globals_ );
    console.log( `Global procedures : ${ keys.length }` );

    _.include( 'wConsequence' );
    _.include( 'wProcedure' );

    keys = _.mapKeys( _realGlobal_._globals_ );
    console.log( `Global procedures : ${ keys.length }` );
    console.log( `GLOBAL WHICH : ${ _realGlobal_._globals_[ keys[ 0 ] ].__GLOBAL_WHICH__ }` );

    _.include( 'wTesting' );

    keys = _.mapKeys( _realGlobal_._globals_ );
    console.log( `Global procedures : ${ keys.length }` );
    console.log( `GLOBAL WHICH : ${ _realGlobal_._globals_[ keys[ 1 ] ].__GLOBAL_WHICH__ }` );

    console.log( `Instances are identical : ${ keys[ 0 ] === _realGlobal_._globals_[ keys[ 1 ] ] }` );

    if( _ !== _realGlobal_._globals_[ 'real' ].wTools )
    throw _.err( 'Wrong namespace for _.' )

    let t = _realGlobal_._globals_[ 'testing' ].wTools;

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

    /* */

    _.procedure.terminationPeriod = 1000;
    _.procedure.terminationBegin();
  }

  /* */

  function program2()
  {
    let _ = require( toolsPath );

    let keys = _.mapKeys( _realGlobal_._globals_ );
    console.log( `Global procedures : ${ keys.length }` );

    _.include( 'wConsequence' );
    _.include( 'wProcedure' );

    keys = _.mapKeys( _realGlobal_._globals_ );
    console.log( `Global procedures : ${ keys.length }` );
    console.log( `GLOBAL WHICH : ${ _realGlobal_._globals_[ keys[ 0 ] ].__GLOBAL_WHICH__ }` );

    _.include( 'wTesting' );

    keys = _.mapKeys( _realGlobal_._globals_ );
    console.log( `Global procedures : ${ keys.length }` );
    console.log( `GLOBAL WHICH : ${ _realGlobal_._globals_[ keys[ 1 ] ].__GLOBAL_WHICH__ }` );

    console.log( `Instances are identical : ${ keys[ 0 ] === _realGlobal_._globals_[ keys[ 1 ] ] }` );

    if( _ !== _realGlobal_._globals_[ 'real' ].wTools )
    throw _.err( 'Wrong namespace for _.' )

    let t = _realGlobal_._globals_[ 'testing' ].wTools;

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

//

var notTakingIntoAccount = { logger : _.Logger({ output : null }), concurrent : 1, takingIntoAccount : 0 };

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
    notTakingIntoAccount,
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
