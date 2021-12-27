( function _Procedure_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{

  const _ = require( 'Tools' );

  require( '../testing/entry/Basic.s' );

  _.include( 'wProcess' );
  _.include( 'wProcedure' );

}

const _global = _global_;
const _ = _global_.wTools;

// --
// context
// --

function onSuiteBegin()
{
  let context = this;

  context.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..' ), 'Tester' );
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


// --
// test
// --

function terminationBeginWithTwoNamespaces( test )
{
  let context = this;
  var testRoutine;
  let a = test.assetFor( 'double' );
  let programPath1 = a.path.nativize( a.path.normalize( a.program( program1 ).filePath/*programPath*/ ) );
  let programPath2 = a.path.nativize( a.path.normalize( a.program( program2 ).filePath/*programPath*/ ) );
  let currentPath = a.abs( '.' );

  /* */

  function testResult1( t )
  {
    let context = this;
    testRoutine = t;

    let start = _.process.starter
    ({
      currentPath,
      outputCollecting : 1,
      outputGraying : 1,
      throwingExitCode : 1,
      mode : 'fork',
    });

    let start2 = _.process.starter
    ({
      currentPath,
      outputCollecting : 1,
      outputGraying : 1,
      throwingExitCode : 1,
      mode : 'fork',
    });

    let con1 = start( programPath1 )
    .then( ( op ) =>
    {
      t.case = 'termination of procedures from first global namespace';
      t.identical( op.exitCode, 0 );
      t.identical( _.strCount( op.output, 'Global procedures : 1' ), 2 );
      t.identical( _.strCount( op.output, 'GLOBAL WHICH : real' ), 1 );
      t.identical( _.strCount( op.output, 'Global procedures : 2' ), 1 );
      t.identical( _.strCount( op.output, 'GLOBAL WHICH : testing' ), 1 );
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

    con1.then( () =>
    {
      return start2( programPath2 )
      .then( ( op ) =>
      {
        t.case = 'termination of procedures from second global namespace';
        t.identical( op.exitCode, 0 );
        t.identical( _.strCount( op.output, 'Global procedures : 1' ), 2 );
        t.identical( _.strCount( op.output, 'GLOBAL WHICH : real' ), 1 );
        t.identical( _.strCount( op.output, 'Global procedures : 2' ), 1 );
        t.identical( _.strCount( op.output, 'GLOBAL WHICH : testing' ), 1 );
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
    })

    return con1;
  }
  testResult1.timeOut = 30000;

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
    const _ = require( toolsPath );

    let keys = _.props.keys( _realGlobal_._globals_ );
    console.log( `Global procedures : ${ keys.length }` );

    _.include( 'wConsequence' );
    _.include( 'wProcedure' );

    keys = _.props.keys( _realGlobal_._globals_ );
    console.log( `Global procedures : ${ keys.length }` );
    console.log( `GLOBAL WHICH : ${ keys[ 0 ] }` );

    _.include( 'wTesting' );

    keys = _.props.keys( _realGlobal_._globals_ );
    console.log( `Global procedures : ${ keys.length }` );
    console.log( `GLOBAL WHICH : ${ keys[ 1 ] }` );

    console.log( `Instances are identical : ${ _realGlobal_._globals_[ keys[ 0 ] ] === _realGlobal_._globals_[ keys[ 1 ] ] }` );

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
    const _ = require( toolsPath );

    let keys = _.props.keys( _realGlobal_._globals_ );
    console.log( `Global procedures : ${ keys.length }` );

    _.include( 'wConsequence' );
    _.include( 'wProcedure' );

    keys = _.props.keys( _realGlobal_._globals_ );
    console.log( `Global procedures : ${ keys.length }` );
    console.log( `GLOBAL WHICH : ${ keys[ 0 ] }` );

    _.include( 'wTesting' );

    keys = _.props.keys( _realGlobal_._globals_ );
    console.log( `Global procedures : ${ keys.length }` );
    console.log( `GLOBAL WHICH : ${ keys[ 1 ] }` );

    console.log( `Instances are identical : ${ _realGlobal_._globals_[ keys[ 0 ] ] === _realGlobal_._globals_[ keys[ 1 ] ] }` );

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

const Proto =
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

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
