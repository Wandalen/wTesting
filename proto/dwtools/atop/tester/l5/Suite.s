(function _Suite_s_() {

'use strict';

let _global = _global_;
let _ = _global_.wTools;

// debugger;
// let d = _.propertyDescriptorGet( _global.logger, 'write' );
// var fs1 = _.mapFields( _global.logger );
// var fs2 = _.mapFields( d.object );
// debugger;

//

let logger = null;
let Parent = null;
let Self = function wTestSuite( o )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( !!o );

  let location;

  if( !o.suiteFilePath )
  {
    location = location || _.diagnosticLocation( 1 );
    o.suiteFilePath = location.path;
  }

  if( !o.suiteFileLocation )
  {
    location = location || _.diagnosticLocation( 1 );
    o.suiteFileLocation = location.full;
  }

  if( !( this instanceof Self ) )
  if( _.strIs( o ) )
  return Self.instanceByName( o );

  if( !( this instanceof Self ) )
  return new( _.constructorJoin( Self, arguments ) );

  _.assert( !( o instanceof Self ) );

  return Self.prototype.init.apply( this,arguments );
}

Self.shortName = 'TestSuite';

// --
// inter
// --

function init( o )
{
  let suite = this;

  _.instanceInit( suite );

  Object.preventExtensions( suite );

  // if( _.routineIs( o.inherit ) )
  // debugger;
  if( _.routineIs( o.inherit ) )
  delete o.inherit;
  let inherits = o.inherit;
  delete o.inherit;

  if( o && o.tests !== undefined )
  suite.tests = o.tests;

  if( o )
  suite.copy( o );

  suite._initialOptions = o;

  _.assert( o === undefined || _.objectIs( o ), 'Expects object {-options-}, but got', _.strTypeOf( o ) );

  /* source path */

  if( !_.strIs( suite.suiteFileLocation ) )
  {
    debugger;
    throw _.err( 'Test suite',suite.name,'Expects a mandatory option ( suiteFileLocation )' );
  }

  // console.log( 'suite.suiteFileLocation',suite.suiteFileLocation );

  /* name */

  if( !( o instanceof Self ) )
  if( !_.strDefined( suite.name ) )
  suite.name = _.diagnosticLocation( suite.suiteFileLocation ).nameLong;

  if( !( o instanceof Self ) )
  if( !_.strDefined( suite.name ) )
  {
    debugger;
    throw _.err( 'Test suite should have name, but', suite.name );
  }

  /* */

  if( inherits )
  {
    _.assert( _.arrayLike( inherits ) );
    if( inherits.length !== 1 )
    debugger;
    for( let i = 0 ; i < inherits.length ; i++ )
    {
      let inherit = inherits[ i ];
      if( !( inherits[ i ] instanceof Self ) )
      {
        if( Self.instancesMap[ inherit.name ] )
        {
          let inheritInited = Self.instancesMap[ inherit.name ];
          _.assert( _.entityContains( inheritInited, _.mapBut( inherit, { inherit : inherit } ) ) );
          inherits[ i ] = inheritInited;
        }
        else
        {
          debugger;
          inherits[ i ] = Self( inherit );
        }
      }
    }
    suite.inherit.apply( suite, inherits );
  }

  return suite;
}

//

function copy( o )
{
  let suite = this;

  // if( !( o instanceof Self ) )
  // suite.name = o.name;

  if( ( o instanceof Self ) )
  debugger;

  return _.Copyable.prototype.copy.call( suite,o );
}

//
//
// function extendBy()
// {
//   let suite = this;
//
//   throw _.err( 'extendBy is deprecated, please, use inherit' );
//
//   // for( let a = 0 ; a < arguments.length ; a++ )
//   // {
//   //   let src = arguments[ 0 ];
//   //
//   //   _.assert( _.mapIs( src ) );
//   //
//   //   if( src.tests )
//   //   _.mapSupplement( src.tests,suite.tests );
//   //
//   //   if( src.context )
//   //   _.mapSupplement( src.context,suite.context );
//   //
//   //   _.mapExtend( suite,src );
//   //
//   // }
//
//   return suite;
// }

//

function inherit()
{
  let suite = this;

  for( let a = 0 ; a < arguments.length ; a++ )
  {
    let src = arguments[ a ];

    _.assert( src instanceof Self );

    if( src.tests )
    _.mapSupplement( suite.tests, src.tests );

    if( src.context )
    _.mapSupplement( suite.context, src.context );

    let extend = _.mapBut( src._initialOptions, suite._initialOptions );
    _.mapExtend( suite,extend );
    _.mapExtend( suite._initialOptions, extend );

  }

  return suite;
}

// --
// etc
// --

function _testSuitesRegister( suites )
{
  let suite = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.mapIs( suites ) );

  for( let s in suites ) try
  {
    let suite = suites[ s ];
    Self( suite );
  }
  catch( err )
  {
    throw _.errLog( 'Cant make test suite',s,'\n',err );
  }

  return suite;
}

//

function _accuracySet( accuracy )
{
  let suite = this;

  if( accuracy === null )
  accuracy = _.accuracy;

  _.assert( _.numberIs( accuracy ), 'Expects number {-accuracy-}' );
  suite[ accuracySymbol ] = accuracy;

  if( suite._refined )
  suite.routineEach( ( trd ) => trd._accuracyChange() );

  return accuracy;
}

//

function _routineSet( src )
{
  let suite = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( src === null || _.routineIs( src ) || _.strIs( src ) );

  if( _.routineIs( src ) )
  debugger;

  suite[ routineSymbol ] = src;

}

//

function consoleBar( value )
{
  let suite = this;
  let logger = suite.logger;
  let wasBarred = wTester._barOptions ? wTester._barOptions.on : false;

  try
  {

    _.assert( arguments.length === 1 );
    _.assert( _.boolLike( value ) );

    if( value )
    {
      logger.begin({ verbosity : -8 });
      logger.log( 'Silencing console' );
      logger.end({ verbosity : -8 });
      if( !_.Logger.consoleIsBarred( console ) )
      wTester._barOptions = _.Logger.consoleBar({ outputPrinter : logger, on : 1 });
    }
    else
    {
      if( _.Logger.consoleIsBarred( console ) )
      {
        wTester._barOptions.on = 0;
        _.Logger.consoleBar( wTester._barOptions );
      }
    }

  }
  catch( err )
  {
    debugger;
    if( err && err.toString )
    console.error( err.toString() + '\n' + err.stack );
    else
    console.error( err );
  }

  return wasBarred;
}

// --
// test suite run
// --

function run()
{
  let suite = this;

  _.assert( arguments.length === 0 );

  suite._testSuiteRefine();

  return suite._testSuiteRunSoon();
}

//

function _testSuiteRefine()
{
  let suite = this;

  /* verify */

  _.assert( _.objectIs( suite.tests ) );
  _.assert( suite instanceof Self );
  _.assert( arguments.length === 0 );
  _.assert( _.strDefined( suite.name ), 'Test suite should has {-name-}"' );
  _.assert( _.objectIs( suite.tests ), 'Test suite should has map with test routines {-tests-}, but "' + suite.name + '" does not have such map' );
  _.assert( !suite._refined );

  /* extend */

  let extend = Object.create( null );

  if( suite.override )
  _.mapExtend( extend, suite.override );

  if( !suite.logger )
  suite.logger = wTester.logger || _global_.logger;

  if( !suite.ignoringTesterOptions )
  {

    if( wTester.settings.verbosity !== null )
    if( extend.verbosity === undefined )
    extend.verbosity = wTester.settings.verbosity-1;

    for( let f in wTester.SettingsOfSuite )
    if( wTester.settings[ f ] !== null )
    if( extend[ f ] === undefined )
    extend[ f ] = wTester.settings[ f ];

  }

  _.mapExtend( suite, extend );

  /* refine test routines */

  for( let testRoutineName in suite.tests )
  {
    let testRoutine = suite.tests[ testRoutineName ];

    _.assert( _.routineIs( testRoutine ) );

    let trd = wTester.TestRoutineDescriptor
    ({
      name : testRoutineName,
      routine : testRoutine,
      suite : suite,
    });

    trd.refine();

    suite.tests[ testRoutineName ] = trd;

  }

  /* */

  suite._refined = 1;

  /* validate */

  _.assert( suite.concurrent !== null && suite.concurrent !== undefined );
  _.assert( wTester.settings.sanitareTime >= 0 );
  _.assert( _.numberIs( suite.verbosity ) );

}

//

function _testSuiteRunSoon()
{
  let suite = this;

  _.assert( suite instanceof Self );
  _.assert( arguments.length === 0 );
  _.assert( suite._refined );

  // debugger;
  // suite._testSuiteRefine();
  // debugger;

  let con = suite.concurrent ? new _.Consequence().give( null ) : wTester.TestSuite._suiteCon;

  return con
  .doThen( _.routineSeal( _,_.timeReady,[] ) )
  .doThen( function()
  {

    return suite._testSuiteRunAct();

  })
  .split();

}

//

function _testSuiteRunAct()
{
  let suite = this;
  let testRoutines = suite.tests;
  let logger = suite.logger || wTester.settings.logger || _global_.logger;

  _.assert( suite instanceof Self );
  _.assert( arguments.length === 0 );

  /* */

  return _.execStages( testRoutines,
  {
    manual : 1,
    onEachRoutine : handleStage,
    onBegin : _.routineJoin( suite,suite._testSuiteBegin ),
    onEnd : handleEnd,
    onRoutine : ( trd ) => trd.routine,
    delay : 10,
  });

  /* */

  function handleStage( trd, iteration, iterator )
  {
    let result = suite._testRoutineRun( trd ) || null;
    _.assert( result !== undefined );
    return result;
  }

  /* */

  function handleEnd( err,data )
  {

    if( !( wTester.settings.sanitareTime >= 0 ) )
    err = _.err( '{-sanitareTime-} should be greater than zero, but it is', wTester.settings.sanitareTime );

    if( suite._reportIsPositive() )
    return _.timeOut( wTester.settings.sanitareTime, () => suite._testSuiteEnd( err ) );
    else
    return suite._testSuiteEnd( err );
  }

}

//

function _testSuiteBegin()
{
  let suite = this;

  if( suite.debug )
  debugger;

  if( wTester.settings.timing )
  suite._testSuiteBeginTime = _.timeNow();

  /* test routine */

  if( _.routineIs( suite.routine ) )
  debugger;
  if( _.routineIs( suite.routine ) )
  suite.routine = _.mapKeyWithValue( suite, suite.routine );

  /* report */

  suite.report = null;
  suite._reportForm();

  /* tracking */

  _.arrayAppendOnceStrictly( wTester.activeSuites, suite );

  /* logger */

  let logger = suite.logger;

  /* silencing */

  if( suite.silencing )
  {
    suite.consoleBar( 1 );
  }

  /* */

  logger.verbosityPush( suite.verbosity );
  logger.begin({ verbosity : -2 });

  let msg =
  [
    'Running test suite ( ' + suite.name + ' ) ..',
  ];

  logger.begin({ 'suite' : suite.name });

  logger.logUp( msg.join( '\n' ) );

  logger.log( wTester.textColor( 'at  ' + suite.suiteFileLocation, 'selected' ) );

  logger.end( 'suite' );

  logger.later( 'suite.content' ).log( '' );

  logger.end({ verbosity : -2 });

  logger.begin({ verbosity : -6 });
  logger.log( _.toStr( suite ) );
  logger.end({ verbosity : -6 });

  logger.begin({ verbosity : -6 + suite.importanceOfDetails });

  /* */

  if( suite.onSuiteBegin )
  {
    try
    {
      suite.onSuiteBegin.call( suite.context,suite );
    }
    catch( err )
    {
      debugger;
      suite.exceptionReport({ err : err });
      return false;
    }
  }

  /* */

  suite._testSuiteTerminated_joined = _.routineJoin( suite, _testSuiteTerminated );
  if( _global_.process )
  _global_.process.on( 'exit', suite._testSuiteTerminated_joined );

  /* */

  if( !wTester._canContinue() )
  {
    debugger; /* xxx */
    return false;
  }

  /* */

  return true;
}

//

function _testSuiteEnd( err )
{
  let suite = this;
  let logger = suite.logger;

  _.assert( arguments.length === 1 )

  /* error */

  if( !err )
  if( suite.routine !== null && !suite.tests[ suite.routine ] )
  err = _.errBriefly( 'Test suite', _.strQuote( suite.name ), 'does not have test routine', _.strQuote( suite.routine ),'\n' );

  if( err )
  {
    debugger;
    suite.consoleBar( 0 );
    console.error( '\nSomething wrong!' );
    try
    {
      suite.exceptionReport({ err : err });
      suite._testCheckConsider( 0 );
    }
    catch( err2 )
    {
      debugger;
      console.error( err2 );
      console.error( err.toString() + '\n' + err.stack );
    }
  }

  /* process exit handler */

  if( _global_.process && suite._testSuiteTerminated_joined )
  _global_.process.removeListener( 'exit', suite._testSuiteTerminated_joined );

  /* on suite end */

  if( suite.onSuiteEnd )
  {
    try
    {
      suite.onSuiteEnd.call( suite.context,suite );
    }
    catch( err )
    {
      _.errLog( err );
    }
  }

  /* report */

  logger.begin({ verbosity : -2 });

  if( logger._mines[ 'suite.content' ] )
  logger.laterFinit( 'suite.content' );
  else
  logger.log();

  /**/

  let ok = suite._reportIsPositive();

  if( logger )
  logger.begin({ 'connotation' : ok ? 'positive' : 'negative' });
  if( logger )
  logger.begin( 'suite','end' );

  let msg = suite._reportToStr();

  logger.log( msg );

  let timingStr = '';
  if( wTester.settings.timing )
  {
    suite.report.timeSpent = _.timeNow() - suite._testSuiteBeginTime;
    timingStr = ' ... in ' + _.timeSpentFormat( suite.report.timeSpent );
  }

  msg = 'Test suite ( ' + suite.name + ' )' + timingStr + ' ... ' + ( ok ? 'ok' : 'failed' );

  msg = wTester.textColor( msg, ok );

  logger.begin({ verbosity : -1 });
  logger.logDown( msg );
  logger.end({ verbosity : -1 });

  logger.begin({ verbosity : -2 });
  logger.log();
  logger.end({ verbosity : -2 });

  logger.end( 'suite','end' );
  logger.end({ 'connotation' : ok ? 'positive' : 'negative' });

  logger.end({ verbosity : -2 });
  logger.end({ verbosity : -6 + suite.importanceOfDetails });
  logger.verbosityPop();

  /* */

  if( suite.takingIntoAccount )
  wTester._testSuiteConsider( ok );

  /* tracking */

  _.arrayRemoveElementOnceStrictly( wTester.activeSuites, suite );

  /* silencing */

  if( suite.silencing )
  suite.consoleBar( 0 );

  /* */

  if( suite.debug )
  debugger;

  return suite;
}

//

function _testSuiteTerminated()
{
  let suite = this;
  debugger;
  let err = _.err( 'Terminated by user' );
  wTester.cancel({ err : err, terminatedByUser : 1, global : 1 });
}

//

function onRoutineBegin( t )
{
}

//

function onRoutineEnd( t )
{
}

//

function onSuiteBegin( t )
{
}

//

function onSuiteEnd( t )
{
}

// --
// test routine
// --

function _testRoutineRun( trd )
{
  let suite = this;
  let result = null;
  let report = suite.report;

  /* */

  if( !wTester._canContinue() )
  return;

  if( !trd.able )
  return;

  /* */

  _.assert( _.routineIs( trd._testRoutineHandleReturn ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  return suite._routineCon
  .doThen( function _testRoutineRun()
  {

    trd._testRoutineBegin();

    /* */

    try
    {
      result = trd.routine.call( suite.context, trd );
    }
    catch( err )
    {
      result = new _.Consequence().error( _.err( err ) );
    }

    /* */

    result = trd._returnCon = _.Consequence.From( result );

    result.andThen( suite._inroutineCon );

    result = result.eitherThenSplit([ _.timeOutError( trd.timeOut ), wTester._cancelCon ]);

    result.doThen( ( err,msg ) => trd._testRoutineHandleReturn( err, msg ) );
    result.doThen( () => trd._testRoutineEnd() );

    return result;
  })
  .split();

}

//

function routineEach( onEach )
{
  let suite = this;

  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( onEach ) );
  _.assert( suite._refined );

  for( let testRoutineName in suite.tests )
  {
    let testRoutine = suite.tests[ testRoutineName ];
    onEach( testRoutine );
  }

  return suite;
}

// --
// report
// --

function _reportForm()
{
  let suite = this;

  _.assert( !suite.report, 'test suite already has report' );

  let report = suite.report = Object.create( null );

  report.timeSpent = null;
  report.errorsArray = [];

  report.testCheckPasses = 0;
  report.testCheckFails = 0;

  report.testCasePasses = 0;
  report.testCaseFails = 0;
  report.testCaseNumber = 0;

  report.testRoutinePasses = 0;
  report.testRoutineFails = 0;

  Object.preventExtensions( report );

}

//

function _reportToStr()
{
  let suite = this;
  let msg = '';
  let appExitCode = _.appExitCode();

  if( appExitCode !== undefined && appExitCode !== 0 )
  msg = 'ExitCode : ' + appExitCode + '\n';

  if( suite.report.errorsArray.length )
  msg += 'Thrown ' + ( suite.report.errorsArray.length ) + ' error(s)\n';

  msg += 'Passed test checks ' + ( suite.report.testCheckPasses ) + ' / ' + ( suite.report.testCheckPasses + suite.report.testCheckFails ) + '\n';
  msg += 'Passed test cases ' + ( suite.report.testCasePasses ) + ' / ' + ( suite.report.testCasePasses + suite.report.testCaseFails ) + '\n';
  msg += 'Passed test routines ' + ( suite.report.testRoutinePasses ) + ' / ' + ( suite.report.testRoutinePasses + suite.report.testRoutineFails ) + '';

  return msg;
}

//

function _reportIsPositive()
{
  let testing = this;

  let appExitCode = _.appExitCode();
  if( appExitCode !== undefined && appExitCode !== 0 )
  return false;

  if( !testing.report )
  return false;

  if( testing.report.testCheckFails !== 0 )
  return false;

  if( !( testing.report.testCheckPasses > 0 ) )
  return false;

  if( testing.report.errorsArray.length )
  return false;

  return true;
}

// --
// consider
// --

function _testCheckConsider( outcome )
{
  let suite = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( this.constructor === Self );
  _.assert( suite.takingIntoAccount !== undefined );

  if( outcome )
  {
    if( suite.report )
    suite.report.testCheckPasses += 1;
  }
  else
  {
    if( suite.report )
    suite.report.testCheckFails += 1;
  }

  if( suite.takingIntoAccount )
  wTester._testCheckConsider( outcome );

}

//

function _testCaseConsider( outcome )
{
  let suite = this;
  let report = suite.report;

  if( outcome )
  report.testCasePasses += 1;
  else
  report.testCaseFails += 1;

  if( suite.takingIntoAccount )
  wTester._testCaseConsider( outcome );
}

//

function _testRoutineConsider( outcome )
{
  let suite = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( this.constructor === Self );
  _.assert( suite.takingIntoAccount !== undefined );

  if( outcome )
  {
    if( suite.report )
    suite.report.testRoutinePasses += 1;
  }
  else
  {
    if( suite.report )
    suite.report.testRoutineFails += 1;
  }

  if( suite.takingIntoAccount )
  wTester._testRoutineConsider( outcome );

}

//

function _exceptionConsider( err )
{
  let suite = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( suite.constructor === Self );

  suite.report.errorsArray.push( err );

  if( suite.takingIntoAccount )
  wTester._exceptionConsider( err );

}

//

function exceptionReport( o )
{
  let suite = this;
  let logger = suite.logger || wTester.settings.logger || _global_.logger;

  _.routineOptions( exceptionReport,o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let err = _.err( o.err );

  if( o.considering )
  suite._exceptionConsider( err );

  logger.begin({ verbosity : 9 });
  _.errLog( err );
  logger.end({ verbosity : 9 });

  return err;
}

exceptionReport.defaults =
{
  err : null,
  considering : 1,
}

// --
// let
// --

let accuracySymbol = Symbol.for( 'accuracy' );
let routineSymbol = Symbol.for( 'routine' );

// --
// relations
// --

let Composes =
{

  name : null,

  verbosity : 2,
  importanceOfDetails : 0,
  importanceOfNegative : 9,

  silencing : null,
  shoulding : 1,

  routineTimeOut : 5000,
  concurrent : 0,
  routine : null,
  platforms : null,

  /* */

  suiteFilePath : null,
  suiteFileLocation : null,
  tests : null,

  abstract : 0,
  enabled : 1,
  takingIntoAccount : 1,
  usingSourceCode : 1,
  ignoringTesterOptions : 0,

  accuracy : 1e-7,
  report : null,

  debug : 0,

  override : _.define.own( {} ),

  _routineCon : _.define.own( new _.Consequence().give( null ) ),
  _inroutineCon : _.define.own( new _.Consequence().give( null ) ),

  onRoutineBegin : onRoutineBegin,
  onRoutineEnd : onRoutineEnd,

  onSuiteBegin : onSuiteBegin,
  onSuiteEnd : onSuiteEnd,

}

let Aggregates =
{
}

let Associates =
{
  logger : null,
  context : null,
}

let Restricts =
{
  currentRoutine : null,
  _initialOptions : null,
  _testSuiteTerminated_joined : null,
  _hasConsoleInOutputs : 0,
  _testSuiteBeginTime : null,
  _refined : 0,
}

let Statics =
{
  // usingUniqueNames : 1,
  usingUniqueNames : _.define.contained({ value : 1, readOnly : 1 }),
  _suiteCon : new _.Consequence().give( null ),
}

let Events =
{
  routineBegin : 'routineBegin',
  routineEnd : 'routineEnd',
}

let Forbids =
{
  safe : 'safe',
  options : 'options',
  special : 'special',
  currentRoutineFails : 'currentRoutineFails',
  currentRoutinePasses : 'currentRoutinePasses',
  SettingsOfSuite : 'SettingsOfSuite',
  timing : 'timing',
}

let Accessors =
{
  accuracy : 'accuracy',
  routine : 'routine',
}

// --
// declare
// --

let Proto =
{

  // inter

  init : init,
  copy : copy,
  inherit : inherit,

  // etc

  _testSuitesRegister : _testSuitesRegister,
  _accuracySet : _accuracySet,
  _routineSet : _routineSet,
  consoleBar : consoleBar,

  // test suite run

  run : run,
  _testSuiteRefine : _testSuiteRefine,
  _testSuiteRunSoon : _testSuiteRunSoon,
  _testSuiteRunAct : _testSuiteRunAct,
  _testSuiteBegin : _testSuiteBegin,
  _testSuiteEnd : _testSuiteEnd,
  _testSuiteTerminated : _testSuiteTerminated,

  onSuiteBegin : onSuiteBegin,
  onSuiteEnd : onSuiteEnd,

  // test routines

  _testRoutineRun : _testRoutineRun,
  routineEach : routineEach,

  // report

  _reportForm : _reportForm,
  _reportToStr : _reportToStr,
  _reportIsPositive : _reportIsPositive,

  // consider

  _testCheckConsider : _testCheckConsider,
  _testCaseConsider : _testCaseConsider,
  _testRoutineConsider : _testRoutineConsider,
  _exceptionConsider : _exceptionConsider,
  exceptionReport : exceptionReport,

  // relations


  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,
  Events : Events,
  Forbids : Forbids,
  Accessors : Accessors,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );
_.Instancing.mixin( Self );
if( _.EventHandler )
_.EventHandler.mixin( Self );

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
wTester[ Self.shortName ] = Self;
_realGlobal_[ Self.name ] = _global_[ Self.name ] = _[ Self.shortName ] = Self;

})();
