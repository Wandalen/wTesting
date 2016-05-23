(function(){

'use strict';

if( typeof module !== 'undefined' )
{
  if( require( 'fs' ).existsSync( '../wTools.s' ) )
  require( '../wTools.s' );
  else
  require( 'wTools' );
  require( '../syn/Consequence.s' );
  require( '../object/printer/Logger.s' );
  require( '../component/StringFormat.s' );
}

_global_.wTests = _global_.wTests === undefined ? {} : _global_.wTests;

var _ = wTools;
if( !_.toStr )
_.toStr = function(){ return String( arguments ) };

// --
// equalizer
// --

var reportOutcome = function( outcome,got,expected,path )
{
  var test = this;

  if( !test._sampleIndex )
  test._sampleIndex = 1;
  else test._sampleIndex += 1;

  _.assert( arguments.length === 4 );

  if( outcome )
  {
    if( test.verbose )
    {
      logger.up();
      logger.log
      (
        '\nexpected:\n',_.toStr( expected ),
        '\ngot:\n',_.toStr( got )
      );
      logger.log
      (
        '%c' +
        test.name + ' ' +
        ( test.description ? test.description : '' ) +
        '#' + test._sampleIndex +
        ' ... ok:',colorGood
      );
      logger.down();
    }
    test.report.passed += 1;
  }
  else
  {
    logger.up();
    logger.error
    (
      '\n' + test.name + ' ' +
      ( test.description ? test.description : '' ) +
      '#' + test._sampleIndex +
      ' ... failed\n' +
      '\nexpected :\n' + _.toStr( expected ) +
      '\ngot :\n' + _.toStr( got ) +
      '\nat : ' + path +
      '\nexpected :\n' + _.toStr( _.entitySelect( expected,path ) ) +
      '\ngot :\n' + _.toStr( _.entitySelect( got,path ) )
    );
    if( _.strIs( expected ) && _.strIs( got ) )
    logger.error( '\ndifference:\n' + _.strDifference( expected,got ) );
    logger.down();
    test.report.failed += 1;
    debugger;
  }

}

//

var identical = function( got,expected )
{
  var test = this;
  var options = {};

  _.assert( arguments.length === 2 );

  var outcome = _.entityIdentical( got,expected,options );
  test.reportOutcome( outcome,got,expected,options.lastPath );

  return outcome;
}

//

var equivalent = function( got,expected,EPS )
{
  var test = this;
  var options = {};

  if( EPS === undefined )
  EPS = test.EPS;
  options.EPS = EPS;

  _.assert( arguments.length === 2 || arguments.length === 3 );

  var outcome = _.entityEquivalent( got,expected,options );

  test.reportOutcome( outcome,got,expected,options.lastPath );

  return outcome;
}

//

var contain = function( got,expected )
{
  var test = this;
  var options = {};

  var outcome = _.entityContain( got,expected,options );

  test.reportOutcome( outcome,got,expected,options.lastPath );

  return outcome;
}

//

var shouldThrowError = function( routine )
{
  var test = this;
  var options = {};
  var thrown = 0;
  var outcome;

  _.assert( _.routineIs( routine ) )
  _.assert( arguments.length === 1 );

  try
  {
    routine.call( this );
  }
  catch()
  {
    thrown = 1;
    outcome = test.reportOutcome( 1,true,true );
  }

  if( !thrown )
  outcome = test.reportOutcome( 0,false,true );

  return outcome;
}

// --
// tester
// --

var testAll = function()
{
  var self = this;

  _.assert( arguments.length === 0 );

  for( var t in wTests )
  {
    self.test( t );
  }

}

//

var test = function( args )
{
  var self = this;
  var args = arguments;

  var run = function()
  {
    self._testCollectionDelayed.apply( self,args );
  }

  _.timeOut( 1, function()
  {

    _.timeReady( run );

  });

}

//

var _testCollectionDelayed = function( context )
{
  var self = this;

  if( arguments.length === 0 )
  {
    self.testAll();
    return;
  }

  if( _.strIs( context ) )
  context = wTests[ context ];

  if( !self.queue )
  self.queue = new wConsequence().give();

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( context.name ),'testing context should has name' );
  _.assert( _.objectIs( context.tests ),'testing context should has map with tests' );

  self.queue.got( function()
  {

    var testing = self._testCollection.call( self,context );
    testing.done( self.queue );

  });

}

//

var _testCollection = function( context )
{
  var self = this;
  var tests = context.tests;
  var con = new wConsequence();
  /*context.__proto__ = Self;*/

  _.accessorForbid( context, { options : 'options' } );
  _.accessorForbid( context, { context : 'context' } );

  var report = {};
  report.passed = 0;
  report.failed = 0;

  var onEach = function( options,testRoutine )
  {
    var failed = report.failed;

    var test = {};
    test.name = options.key;
    test.report = report;
    test.description = '';

    _.mapSupplement( test,context );

    test.__proto__ = Self;

    self._beginTest( test );

    if( self.safe )
    {
      try
      {
        testRoutine.call( context,test );
      }
      catch( err )
      {
        report.failed += 1;
        logger.error( 'Failed:',test.name, test.description ? test.description : '' ,'\error:\n',err );
      }
    }
    else
    {
      testRoutine.call( context,test );
    }

    self._endTest( test,failed === report.failed );

  }

  var onBegin = function()
  {
    logger.logUp( '%cTesting of ' + context.name + ' starting..', colorNeutral );
  }

  var onEnd = function()
  {
    logger.logDown
    (
      '%cTesting of ' + context.name + ' finished.',
      ( report.failed === 0 ) ? colorGood : colorBad,
      '\n  ' + _.toStr( report,{ wrap : 0, multiline : 1 } )+'\n\n'
    );
    con.give();
  }

  _.execStages( tests,
  {
    syn : 1,
    manual : 1,
    onEach : onEach,
    onBegin : onBegin,
    onEnd : onEnd,
  });

  return con;
}

//

var _beginTest = function( test )
{

  logger.logUp( '\n%cRunning test',colorNeutral,test.name+'..' );

}

//

var _endTest = function( test,success )
{

  if( success )
  logger.logDown( '%cPassed test:',colorGood,test.name+'.\n' );

}

//

var colorBad = 'background-color: #aa0000; color: #000000; font-weight:lighter;';
var colorGood = 'background-color: #00aa00; color: #ffffff; font-weight:lighter;';
var colorNeutral = 'background-color: #aaaaaa; color: #ffffff; font-weight:lighter;';
var EPS = 1e-5;
var safe = false;
var verbose = true;

// --
// prototype
// --

var Self =
{

  // equalizer

  reportOutcome: reportOutcome,
  identical: identical,
  equivalent: equivalent,
  contain: contain,
  shouldThrowError: shouldThrowError,

  // tester

  testAll: testAll,
  test: test,
  _testCollectionDelayed: _testCollectionDelayed,
  _testCollection: _testCollection,

  _beginTest: _beginTest,
  _endTest: _endTest,

  // var

  colorBad: colorBad,
  colorGood: colorGood,
  colorNeutral: colorNeutral,
  EPS: EPS,

  safe: safe,
  verbose: verbose,

};

wTools.testing = Self;

if( typeof module !== 'undefined' && module !== null )
{
  module[ 'exports' ] = Self;
}

//_.timeOut( 5000, _.routineBind( Self.test,Self ) );

})();
