(function _aTestSuite_debug_s_() {

'use strict';

var _global = _global_;
var _ = _global_.wTools;

//

var logger = null;
var Parent = null;
var Self = function wTestSuite( o )
{

  _.assert( arguments.length === 1 );
  _.assert( o );

  if( !( this instanceof Self ) )
  if( _.strIs( o ) )
  return Self.instanceByName( o );

  _.assert( !( o instanceof Self ) );

  if( !o.suiteFilePath )
  o.suiteFilePath = _.diagnosticLocation( 1 ).path

  if( !o.suiteFileLocation )
  o.suiteFileLocation = _.diagnosticLocation( 1 ).full

  if( !( this instanceof Self ) )
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'TestSuite';

//

function init( o )
{
  var suite = this;

  _.instanceInit( suite );

  Object.preventExtensions( suite );

  if( _.routineIs( o.inherit ) )
  delete o.inherit;
  var inherit = o.inherit;
  delete o.inherit;

  // debugger;
  if( o )
  suite.copy( o );
  // debugger;

  suite._initialOptions = o;

  _.assert( o === undefined || _.objectIs( o ),'expects object ( options ), but got',_.strTypeOf( o ) );

  /* source path */

  if( !_.strIs( suite.suiteFileLocation ) )
  {
    debugger;
    throw _.err( 'Test suite',suite.name,'expects a mandatory option ( suiteFileLocation )' );
  }

  // console.log( 'suite.suiteFileLocation',suite.suiteFileLocation );

  /* name */

  if( !( o instanceof Self ) )
  if( !_.strIsNotEmpty( suite.name ) )
  suite.name = _.diagnosticLocation( suite.suiteFileLocation ).nameLong;

  if( !( o instanceof Self ) )
  if( !_.strIsNotEmpty( suite.name ) )
  {
    debugger;
    throw _.err( 'Test suite expects name, but got',suite.name );
  }

  /* */

  if( inherit )
  debugger;
  if( inherit )
  suite.inherit.apply( suite,inherit );

  return suite;
}

//

function copy( o )
{
  var suite = this;

  // if( !( o instanceof Self ) )
  // suite.name = o.name;

  if( ( o instanceof Self ) )
  debugger;

  return _.Copyable.prototype.copy.call( suite,o );
}

//

function extendBy()
{
  var suite = this;

  throw _.err( 'extendBy is deprecated, please, use inherit' );

  // for( var a = 0 ; a < arguments.length ; a++ )
  // {
  //   var src = arguments[ 0 ];
  //
  //   _.assert( _.mapIs( src ) );
  //
  //   if( src.tests )
  //   _.mapSupplement( src.tests,suite.tests );
  //
  //   if( src.context )
  //   _.mapSupplement( src.context,suite.context );
  //
  //   _.mapExtend( suite,src );
  //
  // }

  return suite;
}

//

function inherit()
{
  var suite = this;

  for( var a = 0 ; a < arguments.length ; a++ )
  {
    var src = arguments[ a ];

    _.assert( src instanceof Self );

    if( src.tests )
    _.mapSupplement( suite.tests,src.tests );

    if( src.context )
    _.mapSupplement( suite.context,src.context );

    var extend = _.mapBut( src._initialOptions,suite._initialOptions );
    _.mapExtend( suite,extend );
    _.mapExtend( suite._initialOptions,extend );

  }

  return suite;
}

// --
// etc
// --

function _registerSuites( suites )
{
  var suite = this;

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( suites ) );

  for( var s in suites ) try
  {
    Self( suites[ s ] );
  }
  catch( err )
  {
    throw _.errLog( 'Cant make test suite',s,'\n',err );
  }

  return suite;
}

// --
// test suite run
// --

function _testSuiteSettingsAdjust()
{
  var suite = this;

  _.assert( suite instanceof Self );
  _.assert( arguments.length === 0 );

  /* */

  if( suite.override )
  _.mapExtend( suite,suite.override );

  if( !suite.logger )
  suite.logger = _.Tester.logger || _global_.logger;

  if( !suite.ignoringTesterOptions )
  {

    for( var f in _.Tester.SettingsOfSuite )
    if( _.Tester.settings[ f ] !== null )
    suite[ f ] = _.Tester.settings[ f ];

    if( _.Tester.settings.verbosity !== null )
    suite.verbosity = _.Tester.settings.verbosity-1;

  }

  /* */

  if( suite.override )
  _.mapExtend( suite,suite.override );

  /* */

  _.assert( suite.concurrent !== null && suite.concurrent !== undefined );
  _.assert( _.Tester.settings.sanitareTime >= 0 );
  _.assert( _.numberIs( suite.verbosity ) );

}

//

function _testSuiteRunLater()
{
  var suite = this;

  _.assert( suite instanceof Self );
  _.assert( arguments.length === 0 );

  /* */

  suite._testSuiteSettingsAdjust();

  var con = suite.concurrent ? new _.Consequence().give() : wTestSuite._suiteCon;

  return con
  .doThen( _.routineSeal( _,_.timeReady,[] ) )
  .doThen( function()
  {

    return suite._testSuiteRunAct();

  })
  .split();

}

//

function _testSuiteRunNow()
{
  var suite = this;
  var tests = suite.tests;

  _.assert( suite instanceof Self );
  _.assert( arguments.length === 0 );

  /* */

  suite._testSuiteSettingsAdjust();

  var con = suite.concurrent ? new _.Consequence().give() : wTestSuite._suiteCon;

  return con
  .doThen( function()
  {

    return suite._testSuiteRunAct();

  })
  .split();
}

//

function _testSuiteRunAct()
{
  var suite = this;
  var tests = suite.tests;
  var logger = suite.logger || _.Tester.settings.logger || _global_.logger;

  _.assert( suite instanceof Self );
  _.assert( arguments.length === 0 );

  /* */

  function handleStage( testRoutine,iteration,iterator )
  {
    return suite._testRoutineRun_entry( iteration.key,testRoutine );
  }

  /* */

  function handleEnd( err,data )
  {

    if( err )
    {
      debugger;
      logger.log( _.err( 'Something is wrong, cant even launch the test suite\n',err ) );
      suite._outcomeConsider( 0 );
    }

    _.assert( _.Tester.settings.sanitareTime >= 0 );
    if( suite._reportIsPositive() )
    return _.timeOut( _.Tester.settings.sanitareTime, () => suite._testSuiteEnd() );
    else
    return suite._testSuiteEnd();
  }

  /* */

  return _.execStages( tests,
  {
    manual : 1,
    onEachRoutine : handleStage,
    onBegin : _.routineJoin( suite,suite._testSuiteBegin ),
    onEnd : handleEnd,
    delay : 10,
  });

}

//

function _testSuiteBegin()
{
  var suite = this;

  if( suite.debug )
  debugger;

  if( !_.Tester._canContinue() )
  return;

  /* logger */

  var logger = suite.logger;

  /* report */

  suite.report = null;
  suite._reportForm();

  /* silencing */

  if( suite.silencing )
  {
    logger.begin({ verbosity : -8 });
    logger.log( 'Silencing console' );
    logger.end({ verbosity : -8 });
    if( !_.Logger.consoleIsBarred( console ) )
    _.Tester._bar = _.Logger.consoleBar({ outputLogger : logger, bar : 1 });
  }

  /* */

  logger.verbosityPush( suite.verbosity );
  logger.begin({ verbosity : -2 });

  var msg =
  [
    'Testing of test suite ( ' + suite.name + ' ) ..',
  ];

  logger.begin({ 'suite' : suite.name });

  logger.logUp( msg.join( '\n' ) );

  logger.log( _.color.strFormat( 'at  ' + suite.suiteFileLocation,'selected' ) );

  logger.end( 'suite' );

  logger.mine( 'suite.content' ).log( '' );

  logger.end({ verbosity : -2 });

  logger.begin({ verbosity : -6 });
  logger.log( _.toStr( suite ) );
  logger.end({ verbosity : -6 });

  logger.begin({ verbosity : -6 + suite.importanceOfDetails });

  /* */

  _.assert( _.Tester.activeSuites.indexOf( suite ) === -1 );
  _.Tester.activeSuites.push( suite );

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

  suite._testSuiteTerminated_joined = _.routineJoin( suite,_testSuiteTerminated );
  if( _global_.process )
  _global_.process.on( 'exit', suite._testSuiteTerminated_joined );

  return true;
}

//

function _testSuiteEnd()
{
  var suite = this;
  var logger = suite.logger;

  if( _global_.process && suite._testSuiteTerminated_joined )
  _global_.process.removeListener( 'exit', suite._testSuiteTerminated_joined );

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

  /* */

  logger.begin({ verbosity : -2 });

  if( logger._mines[ 'suite.content' ] )
  logger.mineFinit( 'suite.content' );
  else
  logger.log();

  /* */

  var ok = suite._reportIsPositive();

  if( logger )
  logger.begin({ 'connotation' : ok ? 'positive' : 'negative' });
  if( logger )
  logger.begin( 'suite','end' );

  var msg = suite._reportToStr();

  logger.log( msg );

  var msg =
  [
    'Test suite ( ' + suite.name + ' ) .. ' + ( ok ? 'ok' : 'failed' ) + '.'
  ];

  logger.begin({ verbosity : -1 });
  logger.logDown( msg[ 0 ] );
  logger.end({ verbosity : -1 });

  logger.begin({ verbosity : -2 });
  logger.log();
  logger.end({ verbosity : -2 });

  logger.end( 'suite','end' );
  logger.end({ 'connotation' : ok ? 'positive' : 'negative' });

  logger.end({ verbosity : -2 });
  logger.end({ verbosity : -6 + suite.importanceOfDetails });
  logger.verbosityPop();

  // console.log( 'x' );

  /* */

  if( suite.takingIntoAccount )
  {

    _.Tester.report.testSuitePasses += ok ? 1 : 0;
    _.Tester.report.testSuiteFailes += ok ? 0 : 1;

    _.Tester.report.testRoutinePasses += suite.report.testRoutinePasses;
    _.Tester.report.testRoutineFails += suite.report.testRoutineFails;

  }

  _.assert( _.Tester.activeSuites.indexOf( suite ) !== -1 );
  _.arrayRemoveOnce( _.Tester.activeSuites,suite );

  /* silencing */

  if( suite.silencing && _.Logger.consoleIsBarred( console ) )
  {
    _.Tester._bar.bar = 0;
    _.Logger.consoleBar( _.Tester._bar );
  }

  /* */

  if( suite.debug )
  debugger;

  return suite;
}

//

function _testSuiteTerminated()
{
  var suite = this;
  suite.exceptionReport({ err : _.err( 'Terminated by user' ) });
  _.Tester.cancel( 'Terminated by user' );
  suite._testSuiteEnd();
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

//

function _testRoutineRun_entry( name,testRoutine )
{
  var suite = this;
  var result = null;
  var report = suite.report;

  /* */

  if( ( !suite.routine || !suite.takingIntoAccount ) && testRoutine.experimental )
  return;

  if( suite.takingIntoAccount )
  if( suite.routine && suite.routine !== testRoutine.name )
  return;

  if( !_.Tester._canContinue() )
  return;

  /* */

  var trd = _.TestRoutineDescriptor
  ({
    name : name,
    routine : testRoutine,
    suite : suite,
  });

  _.assert( _.routineIs( trd._testRoutineHandleReturn ) );
  _.assert( arguments.length === 2 );

  return suite._routineCon
  .doThen( function _testRoutineRun()
  {

    trd._testRoutineBegin();

    /* */

    try
    {
      result = trd.routine.call( suite.context,trd );
    }
    catch( err )
    {
      result = new _.Consequence().error( _.err( err ) );
    }

    /* */

    var timeOut = testRoutine.timeOut || trd.testRoutineTimeOut || _.Tester.settings.testRoutineTimeOut;

    result = trd._returnCon = _.Consequence.from( result );

    result.andThen( suite._inroutineCon );
    result = result.eitherThenSplit([ _.timeOutError( timeOut ),_.Tester._cancelCon ]);

    result.doThen( ( err,msg ) => trd._testRoutineHandleReturn( err,msg ) );
    result.doThen( () => trd._testRoutineEnd() );

    return result;
  })
  .split();

}

//

function _reportForm()
{
  var suite = this;

  _.assert( !suite.report );
  var report = suite.report = Object.create( null );

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
  var suite = this;

  var msg = '';

  if( suite.report.errorsArray.length )
  msg += 'Thrown ' + ( suite.report.errorsArray.length ) + ' error(s)\n';

  msg += 'Passed test checks ' + ( suite.report.testCheckPasses ) + ' / ' + ( suite.report.testCheckPasses + suite.report.testCheckFails ) + '\n';
  msg += 'Passed test cases ' + ( suite.report.testCasePasses ) + ' / ' + ( suite.report.testCasePasses + suite.report.testCaseFails ) + '\n';
  msg += 'Passed test routines ' + ( suite.report.testRoutinePasses ) + ' / ' + ( suite.report.testRoutinePasses + suite.report.testRoutineFails ) + '';

  // suite.logger.log( 'suite.report.testCaseFails',suite.report.testCaseFails );

  return msg;
}

//

function _reportIsPositive()
{
  var testing = this;

  if( _.appExitCode() !== undefined && _.appExitCode() !== 0 )
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

function _outcomeConsider( outcome )
{
  var suite = this;

  _.assert( arguments.length === 1 );
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
  _.Tester._outcomeConsider( outcome );

}

//

function _exceptionConsider( err )
{
  var suite = this;

  _.assert( arguments.length === 1 );
  _.assert( suite.constructor === Self );

  suite.report.errorsArray.push( err );

  if( suite.takingIntoAccount )
  _.Tester._exceptionConsider( err );

}

//

function _testCaseConsider( outcome )
{
  var suite = this;
  var report = suite.report;

  if( outcome )
  report.testCasePasses += 1;
  else
  report.testCaseFails += 1;

  if( suite.takingIntoAccount )
  _.Tester._testCaseConsider( outcome );
}

//

function exceptionReport( o )
{
  var suite = this;
  var logger = suite.logger || _.Tester.settings.logger || _global_.logger;

  _.routineOptions( exceptionReport,o );
  _.assert( arguments.length === 1 );

  var err = _.err( o.err );

  if( o.considering )
  suite._exceptionConsider( err );

  logger.begin({ verbosity : 9 });
  _.errLog( err );
  logger.end({ verbosity : 9 });

}

exceptionReport.defaults =
{
  err : null,
  considering : 1,
}

// --
// var
// --

var symbolForVerbosity = Symbol.for( 'verbosity' );

// --
// relationships
// --

var Composes =
{

  name : null,
  verbosity : 2,
  importanceOfDetails : 0,
  importanceOfNegative : 9,

  testRoutineTimeOut : 5000,
  concurrent : 0,

  routine : null,
  silencing : null,

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

  eps : 1e-5,
  report : null,

  debug : 0,

  override : Object.create( null ),

  _routineCon : new _.Consequence().give(),
  _inroutineCon : new _.Consequence().give(),

  onRoutineBegin : onRoutineBegin,
  onRoutineEnd : onRoutineEnd,

  onSuiteBegin : onSuiteBegin,
  onSuiteEnd : onSuiteEnd,

}

var Aggregates =
{
}

var Associates =
{
  logger : null,
  context : null,
}

var Restricts =
{
  currentRoutine : null,
  _initialOptions : null,
  _testSuiteTerminated_joined : null,
}

var Statics =
{
  usingUniqueNames : 1,
  _suiteCon : new _.Consequence().give(),
}

var Events =
{
  routineBegin : 'routineBegin',
  routineEnd : 'routineEnd',
}

var Forbids =
{
  safe : 'safe',
  options : 'options',
  special : 'special',
  currentRoutineFails : 'currentRoutineFails',
  currentRoutinePasses : 'currentRoutinePasses',
  SettingsOfSuite : 'SettingsOfSuite',
}

// --
// define class
// --

var Proto =
{

  // inter

  init : init,
  copy : copy,
  extendBy : extendBy,
  inherit : inherit,


  // etc

  _registerSuites : _registerSuites,


  // test suite run

  _testSuiteSettingsAdjust : _testSuiteSettingsAdjust,
  _testSuiteRunLater : _testSuiteRunLater,
  run : _testSuiteRunNow,
  _testSuiteRunNow : _testSuiteRunNow,
  _testSuiteRunAct : _testSuiteRunAct,
  _testSuiteBegin : _testSuiteBegin,
  _testSuiteEnd : _testSuiteEnd,
  _testSuiteTerminated : _testSuiteTerminated,

  onSuiteBegin : onSuiteBegin,
  onSuiteEnd : onSuiteEnd,

  _testRoutineRun_entry : _testRoutineRun_entry,


  // report

  _reportForm : _reportForm,
  _reportToStr : _reportToStr,
  _reportIsPositive : _reportIsPositive,


  // consider

  _outcomeConsider : _outcomeConsider,
  _exceptionConsider : _exceptionConsider,
  _testCaseConsider : _testCaseConsider,
  exceptionReport : exceptionReport,


  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,
  Events : Events,

}

//

_.classMake
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );
_.Instancing.mixin( Self );
if( _.EventHandler )
_.EventHandler.mixin( Self );

_.accessorForbid( Self.prototype,Forbids );

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_realGlobal_[ Self.name ] = _global_[ Self.name ] = _[ Self.nameShort ] = Self;

})();
