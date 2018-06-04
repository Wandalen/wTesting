(function _aTestSuit_debug_s_() {

'use strict';

var _ = _global_.wTools;

//

var logger = null;
var Parent = null;
var Self = function wTestSuit( o )
{

  _.assert( arguments.length === 1 );
  _.assert( o );

  if( !( this instanceof Self ) )
  if( _.strIs( o ) )
  return Self.instanceByName( o );

  _.assert( !( o instanceof Self ) );

  if( !o.suitFilePath )
  o.suitFilePath = _.diagnosticLocation( 1 ).path

  if( !o.suitFileLocation )
  o.suitFileLocation = _.diagnosticLocation( 1 ).full

  if( !( this instanceof Self ) )
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'TestSuit';

//

function init( o )
{
  var suit = this;

  _.instanceInit( suit );

  Object.preventExtensions( suit );

  if( _.routineIs( o.inherit ) )
  delete o.inherit;
  var inherit = o.inherit;
  delete o.inherit;

  // debugger;
  if( o )
  suit.copy( o );
  // debugger;

  suit._initialOptions = o;

  _.assert( o === undefined || _.objectIs( o ),'expects object ( options ), but got',_.strTypeOf( o ) );

  /* source path */

  if( !_.strIs( suit.suitFileLocation ) )
  {
    debugger;
    throw _.err( 'Test suit',suit.name,'expects a mandatory option ( suitFileLocation )' );
  }

  // console.log( 'suit.suitFileLocation',suit.suitFileLocation );

  /* name */

  if( !( o instanceof Self ) )
  if( !_.strIsNotEmpty( suit.name ) )
  suit.name = _.diagnosticLocation( suit.suitFileLocation ).nameLong;

  if( !( o instanceof Self ) )
  if( !_.strIsNotEmpty( suit.name ) )
  {
    debugger;
    throw _.err( 'Test suit expects name, but got',suit.name );
  }

  /* */

  if( inherit )
  debugger;
  if( inherit )
  suit.inherit.apply( suit,inherit );

  return suit;
}

//

function copy( o )
{
  var suit = this;

  // if( !( o instanceof Self ) )
  // suit.name = o.name;

  if( ( o instanceof Self ) )
  debugger;

  return _.Copyable.prototype.copy.call( suit,o );
}

//

function extendBy()
{
  var suit = this;

  throw _.err( 'extendBy is deprecated, please, use inherit' );

  // for( var a = 0 ; a < arguments.length ; a++ )
  // {
  //   var src = arguments[ 0 ];
  //
  //   _.assert( _.mapIs( src ) );
  //
  //   if( src.tests )
  //   _.mapSupplement( src.tests,suit.tests );
  //
  //   if( src.context )
  //   _.mapSupplement( src.context,suit.context );
  //
  //   _.mapExtend( suit,src );
  //
  // }

  return suit;
}

//

function inherit()
{
  var suit = this;

  for( var a = 0 ; a < arguments.length ; a++ )
  {
    var src = arguments[ a ];

    _.assert( src instanceof Self );

    if( src.tests )
    _.mapSupplement( suit.tests,src.tests );

    if( src.context )
    _.mapSupplement( suit.context,src.context );

    var extend = _.mapBut( src._initialOptions,suit._initialOptions );
    _.mapExtend( suit,extend );
    _.mapExtend( suit._initialOptions,extend );

  }

  return suit;
}

// --
// etc
// --

function _registerSuits( suits )
{
  var suit = this;

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( suits ) );

  for( var s in suits ) try
  {
    Self( suits[ s ] );
  }
  catch( err )
  {
    throw _.errLog( 'Cant make test suit',s,'\n',err );
  }

  return suit;
}

// --
// test suit run
// --

function _testSuitSettingsAdjust()
{
  var suit = this;

  _.assert( suit instanceof Self );
  _.assert( arguments.length === 0 );

  /* */

  if( suit.override )
  _.mapExtend( suit,suit.override );

  if( !suit.logger )
  suit.logger = _.Tester.logger || _global_.logger;

  if( !suit.ignoringTesterOptions )
  {

    for( var f in _.Tester.SettingsOfSuit )
    if( _.Tester.settings[ f ] !== null )
    suit[ f ] = _.Tester.settings[ f ];

    if( _.Tester.settings.verbosity !== null )
    suit.verbosity = _.Tester.settings.verbosity-1;

  }

  /* */

  if( suit.override )
  _.mapExtend( suit,suit.override );

  /* */

  _.assert( suit.concurrent !== null && suit.concurrent !== undefined );
  _.assert( _.Tester.settings.sanitareTime >= 0 );
  _.assert( _.numberIs( suit.verbosity ) );

}

//

function _testSuitRunLater()
{
  var suit = this;

  _.assert( suit instanceof Self );
  _.assert( arguments.length === 0 );

  /* */

  suit._testSuitSettingsAdjust();

  var con = suit.concurrent ? new _.Consequence().give() : wTestSuit._suitCon;

  return con
  .doThen( _.routineSeal( _,_.timeReady,[] ) )
  .doThen( function()
  {

    return suit._testSuitRunAct();

  })
  .split();

}

//

function _testSuitRunNow()
{
  var suit = this;
  var tests = suit.tests;

  _.assert( suit instanceof Self );
  _.assert( arguments.length === 0 );

  /* */

  suit._testSuitSettingsAdjust();

  var con = suit.concurrent ? new _.Consequence().give() : wTestSuit._suitCon;

  return con
  .doThen( function()
  {

    return suit._testSuitRunAct();

  })
  .split();
}

//

function _testSuitRunAct()
{
  var suit = this;
  var tests = suit.tests;
  var logger = suit.logger || _.Tester.settings.logger || _global_.logger;

  _.assert( suit instanceof Self );
  _.assert( arguments.length === 0 );

  /* */

  function handleStage( testRoutine,iteration,iterator )
  {
    return suit._testRoutineRun_entry( iteration.key,testRoutine );
  }

  /* */

  function handleEnd( err,data )
  {

    if( err )
    {
      debugger;
      logger.log( _.err( 'Something is wrong, cant even launch the test suit\n',err ) );
      suit._outcomeConsider( 0 );
    }

    _.assert( _.Tester.settings.sanitareTime >= 0 );
    if( suit._reportIsPositive() )
    return _.timeOut( _.Tester.settings.sanitareTime, () => suit._testSuitEnd() );
    else
    return suit._testSuitEnd();
  }

  /* */

  return _.execStages( tests,
  {
    manual : 1,
    onEachRoutine : handleStage,
    onBegin : _.routineJoin( suit,suit._testSuitBegin ),
    onEnd : handleEnd,
  });

}

//

function _testSuitBegin()
{
  var suit = this;

  if( suit.debug )
  debugger;

  if( !_.Tester._canContinue() )
  return;

  /* logger */

  var logger = suit.logger;

  /* report */

  suit.report = null;
  suit._reportForm();

  /* silencing */

  if( suit.silencing )
  {
    logger.begin({ verbosity : -8 });
    logger.log( 'Silencing console' );
    logger.end({ verbosity : -8 });
    if( !_.Logger.consoleIsBarred( console ) )
    _.Tester._bar = _.Logger.consoleBar({ outputLogger : logger, bar : 1 });
  }

  /* */

  logger.verbosityPush( suit.verbosity );
  logger.begin({ verbosity : -2 });

  var msg =
  [
    'Testing of test suit ( ' + suit.name + ' ) ..',
  ];

  logger.begin({ 'suit' : suit.name });

  logger.logUp( msg.join( '\n' ) );

  logger.log( _.color.strFormat( 'at  ' + suit.suitFileLocation,'selected' ) );

  logger.end( 'suit' );

  logger.mine( 'suit.content' ).log( '' );

  logger.end({ verbosity : -2 });

  logger.begin({ verbosity : -6 });
  logger.log( _.toStr( suit ) );
  logger.end({ verbosity : -6 });

  logger.begin({ verbosity : -6 + suit.importanceOfDetails });

  /* */

  _.assert( _.Tester.activeSuits.indexOf( suit ) === -1 );
  _.Tester.activeSuits.push( suit );

  if( suit.onSuitBegin )
  {
    try
    {
      suit.onSuitBegin.call( suit.context,suit );
    }
    catch( err )
    {
      debugger; /* !!! err not handled properly, if silencing : 1 */
      suit._exceptionConsider( err );
      _.errLog( err );
      return false;
    }
  }

  suit._testSuitEnd_joined = _.routineJoin( suit,_testSuitEnd );
  if( _global_.process )
  _global_.process.on( 'exit', suit._testSuitEnd_joined );

  return true;
}

//

function _testSuitEnd()
{
  var suit = this;
  var logger = suit.logger;

  if( _global_.process )
  _global_.process.removeListener( 'exit', suit._testSuitEnd_joined );

  if( suit.onSuitEnd )
  {
    try
    {
      suit.onSuitEnd.call( suit.context,suit );
    }
    catch( err )
    {
      _.errLog( err );
    }
  }

  /* */

  logger.begin({ verbosity : -2 });

  if( logger._mines[ 'suit.content' ] )
  logger.mineFinit( 'suit.content' );
  else
  logger.log();

  /* */

  var ok = suit._reportIsPositive();

  if( logger )
  logger.begin({ 'connotation' : ok ? 'positive' : 'negative' });
  if( logger )
  logger.begin( 'suit','end' );

  var msg = suit._reportToStr();

  logger.log( msg );

  var msg =
  [
    'Test suit ( ' + suit.name + ' ) .. ' + ( ok ? 'ok' : 'failed' ) + '.'
  ];

  logger.begin({ verbosity : -1 });
  logger.logDown( msg[ 0 ] );
  logger.end({ verbosity : -1 });

  logger.begin({ verbosity : -2 });
  logger.log();
  logger.end({ verbosity : -2 });

  logger.end( 'suit','end' );
  logger.end({ 'connotation' : ok ? 'positive' : 'negative' });

  logger.end({ verbosity : -2 });
  logger.end({ verbosity : -6 + suit.importanceOfDetails });
  logger.verbosityPop();

  // console.log( 'x' );

  /* */

  if( suit.takingIntoAccount )
  {

    _.Tester.report.testSuitPasses += ok ? 1 : 0;
    _.Tester.report.testSuitFailes += ok ? 0 : 1;

    _.Tester.report.testRoutinePasses += suit.report.testRoutinePasses;
    _.Tester.report.testRoutineFails += suit.report.testRoutineFails;

  }

  _.assert( _.Tester.activeSuits.indexOf( suit ) !== -1 );
  _.arrayRemoveOnce( _.Tester.activeSuits,suit );

  /* silencing */

  if( suit.silencing && _.Logger.consoleIsBarred( console ) )
  {
    _.Tester._bar.bar = 0;
    _.Logger.consoleBar( _.Tester._bar );
  }

  /* */

  if( suit.debug )
  debugger;

  return suit;
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

function onSuitBegin( t )
{
}

//

function onSuitEnd( t )
{
}

//

function _testRoutineRun_entry( name,testRoutine )
{
  var suit = this;
  var result = null;
  var report = suit.report;

  /* */

  if( ( !suit.routine || !suit.takingIntoAccount ) && testRoutine.experimental )
  return;

  if( suit.takingIntoAccount )
  if( suit.routine && suit.routine !== testRoutine.name )
  return;

  if( !_.Tester._canContinue() )
  return;

  /* */

  var trd = _.TestRoutineDescriptor
  ({
    name : name,
    routine : testRoutine,
    suit : suit,
  });

  _.assert( _.routineIs( trd._testRoutineHandleReturn ) );
  _.assert( arguments.length === 2 );

  return suit._routineCon
  .doThen( function _testRoutineRun()
  {

    trd._testRoutineBegin();

    /* */

    try
    {
      result = trd.routine.call( suit.context,trd );
    }
    catch( err )
    {
      result = new _.Consequence().error( _.err( err ) );
    }

    /* */

    var timeOut = testRoutine.timeOut || trd.testRoutineTimeOut || _.Tester.settings.testRoutineTimeOut;

    result = trd._returnCon = _.Consequence.from( result );

    result.andThen( suit._inroutineCon );
    result = result.eitherThenSplit([ _.timeOutError( timeOut ),trd._cancelCon ]);

    result.doThen( ( err,msg ) => trd._testRoutineHandleReturn( err,msg ) );
    result.doThen( () => trd._testRoutineEnd() );

    return result;
  })
  .split();

}

//

function _reportForm()
{
  var suit = this;

  _.assert( !suit.report );
  var report = suit.report = Object.create( null );

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
  var suit = this;

  var msg = '';

  if( suit.report.errorsArray.length )
  msg += 'Thrown ' + ( suit.report.errorsArray.length ) + ' error(s)\n';

  msg += 'Passed test checks ' + ( suit.report.testCheckPasses ) + ' / ' + ( suit.report.testCheckPasses + suit.report.testCheckFails ) + '\n';
  msg += 'Passed test cases ' + ( suit.report.testCasePasses ) + ' / ' + ( suit.report.testCasePasses + suit.report.testCaseFails ) + '\n';
  msg += 'Passed test routines ' + ( suit.report.testRoutinePasses ) + ' / ' + ( suit.report.testRoutinePasses + suit.report.testRoutineFails ) + '';

  // suit.logger.log( 'suit.report.testCaseFails',suit.report.testCaseFails );

  return msg;
}

//

function _reportIsPositive()
{
  var testing = this;

  if( testing.report.testCheckFails !== 0 )
  return false;

  if( !( testing.report.testCheckPasses > 0 ) )
  return false;

  if( testing.report.errorsArray.length )
  return false;

  return true;
}

// --
// output
// --

function _outcomeConsider( outcome )
{
  var suit = this;

  _.assert( arguments.length === 1 );
  _.assert( this.constructor === Self );
  _.assert( suit.takingIntoAccount !== undefined );

  if( outcome )
  {
    if( suit.report )
    suit.report.testCheckPasses += 1;
  }
  else
  {
    if( suit.report )
    suit.report.testCheckFails += 1;
  }

  if( suit.takingIntoAccount )
  _.Tester._outcomeConsider( outcome );

}

//

function _exceptionConsider( err )
{
  var suit = this;

  _.assert( arguments.length === 1 );
  _.assert( suit.constructor === Self );

  suit.report.errorsArray.push( err );

  if( suit.takingIntoAccount )
  _.Tester._exceptionConsider( err );

}

//

function _testCaseConsider( outcome )
{
  var suit = this;
  var report = suit.report;

  if( outcome )
  report.testCasePasses += 1;
  else
  report.testCaseFails += 1;

  if( suit.takingIntoAccount )
  _.Tester._testCaseConsider( outcome );
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
  importanceOfNegative : 0,

  testRoutineTimeOut : 5000,
  concurrent : 0,

  routine : null,
  silencing : null,

  platforms : null,

  /* */

  suitFilePath : null,
  suitFileLocation : null,
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

  onSuitBegin : onSuitBegin,
  onSuitEnd : onSuitEnd,

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
  _testSuitEnd_joined : null,
}

var Statics =
{
  usingUniqueNames : 1,
  _suitCon : new _.Consequence().give(),
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
  SettingsOfSuit : 'SettingsOfSuit',
}

// --
// prototype
// --

var Proto =
{

  // inter

  init : init,
  copy : copy,
  extendBy : extendBy,
  inherit : inherit,


  // etc

  _registerSuits : _registerSuits,


  // test suit run

  _testSuitSettingsAdjust : _testSuitSettingsAdjust,
  _testSuitRunLater : _testSuitRunLater,
  run : _testSuitRunNow,
  _testSuitRunNow : _testSuitRunNow,
  _testSuitRunAct : _testSuitRunAct,
  _testSuitBegin : _testSuitBegin,
  _testSuitEnd : _testSuitEnd,

  onSuitBegin : onSuitBegin,
  onSuitEnd : onSuitEnd,

  _testRoutineRun_entry : _testRoutineRun_entry,


  // report

  _reportForm : _reportForm,
  _reportToStr : _reportToStr,
  _reportIsPositive : _reportIsPositive,


  // output

  _outcomeConsider : _outcomeConsider,
  _exceptionConsider : _exceptionConsider,
  _testCaseConsider : _testCaseConsider,


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
_globalReal_[ Self.name ] = _global_[ Self.name ] = _[ Self.nameShort ] = Self;

})();
