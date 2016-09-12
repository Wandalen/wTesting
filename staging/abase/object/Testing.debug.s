(function _Testing_debug_s_() {

'use strict';

var Chalk = null;

if( typeof module !== 'undefined' )
{

  if( typeof wBase === 'undefined' )
  try
  {
    require( '../../abase/wTools.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  if( typeof wConsequence === 'undefined' )
  try
  {
    require( '../../abase/syn/Consequence.s' );
  }
  catch( err )
  {
    require( 'wConsequence' );
  }

  if( typeof logger === 'undefined' )
  require( '../../abase/object/printer/Logger.s' );

  var Chalk = require( 'chalk' );

}

_global_.wTests = _global_.wTests === undefined ? {} : _global_.wTests;

var _ = wTools;
if( !_.toStr )
_.toStr = function(){ return String( arguments ) };

// --
// equalizer
// --

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
  catch( err )
  {
    thrown = 1;
    outcome = test.reportOutcome( 1,true,true,'' );
  }

  if( !thrown )
  outcome = test.reportOutcome( 0,false,true,'' );

  return outcome;
}

// --
// output
// --

var reportOutcome = function( outcome,got,expected,path )
{
  var test = this;

  if( !test._sampleIndex )
  test._sampleIndex = 1;
  else test._sampleIndex += 1;

  _.assert( arguments.length === 4 );

  /**/

  var msgExpectedGot = function()
  {
    return '' +
    'expected :\n' + _.toStr( expected ) +
    '\ngot :\n' + _.toStr( got );
  }

  /**/

  if( outcome )
  {
    if( test.verbose )
    {

      logger.logUp();

      logger.log( msgExpectedGot() );

      var msg =
      [
        testCaseText( test ) +
        ' ... ok'
      ];

      logger.logDown.apply( logger,strColor.apply( 'good',msg ) );

    }
    test.report.passed += 1;
  }
  else
  {

    logger.logUp();

    logger.log( msgExpectedGot() );

    if( !_.atomicIs( got ) && !_.atomicIs( expected ) )
    logger.log
    (
      'at : ' + path +
      '\nexpected :\n' + _.toStr( _.entitySelect( expected,path ) ) +
      '\ngot :\n' + _.toStr( _.entitySelect( got,path ) )
    );

    if( _.strIs( expected ) && _.strIs( got ) )
    logger.error( '\ndifference :\n' + _.strDifference( expected,got ) );

    var msg =
    [
      testCaseText( test ) +
      ' ... failed'
    ];

    logger.errorDown.apply( logger,strColor.apply( 'bad',msg ) );

    test.report.failed += 1;
    debugger;
  }

}

//

var testCaseText = function( test )
{
  return '' +
    'Test routine : ' + test.name + ' : ' +
    'test case : ' + ( test.description ? test.description : '' ) + '' +
    ' # ' + test._sampleIndex
  ;
}

//

var _strColor = function _strColor( color,result )
{

  _.assert( arguments.length === 2 );
  _.assert( _.arrayIs( result ) );
  _.assert( _.strIs( color ),'expects color as string' );

  var src = result[ 0 ];

  if( Chalk )
  {

    _.assert( result.length === 1 );

    switch( color )
    {

      case 'good' :
        result[ 0 ] = Chalk.green( src ); break;

      case 'bad' :
        result[ 0 ] = Chalk.red( src ); break;

      case 'neutral' :
        result[ 0 ] = Chalk.bgWhite( Chalk.black( src ) ); break;
        return Chalk.bgWhite( Chalk.black( src ) ); break;

      case 'bold' :
        result[ 0 ] = Chalk.bgWhite( src ); break;
        return Chalk.bgWhite( src ); break;

      default :
        throw _.err( 'strColor : unknown color : ' + color );

    }

  }
  else
  {

    _.assert( result.length === 2 );
    _.assert( _.strIs( result[ 1 ] ) );

    var tag = null;
    switch( color )
    {

      case 'good' :
        tag = colorGood; break;

      case 'bad' :
        tag = colorBad; break;

      case 'neutral' :
        tag = colorNeutral; break;

      case 'bold' :
        tag = colorBold; break;

      default :
        throw _.err( 'strColor : unknown color : ' + color );

    }

    result[ 0 ] = _.strPrependOnce( src,'%c' );
    result[ 1 ] += ' ; ' + tag;

  }

  return result;
}

//

var strColor = function strColor()
{

  var src = _.str.apply( _,arguments );
  var result = null;

  if( Chalk )
  result = [ src ];
  else
  result = [ src,'' ];

  if( _.arrayIs( this ) )
  {

    for( var t = 0 ; t < this.length ; t++ )
    _strColor( this[ t ],result );

  }
  else
  {
    _strColor( this,result );
  }

  return result;
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
    self._testSuiteRunDelayed.apply( self,args );
  }

  _.timeOut( 1, function()
  {

    _.timeReady( run );

  });

}

//

var _testSuiteRunDelayed = function( context )
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

    var testing = self._testSuiteRun.call( self,context );
    testing.done( self.queue );

  });

}

//

var _testSuiteRun = function( context )
{
  var self = this;
  var tests = context.tests;
  var con = new wConsequence();

  _.accessorForbid( context, { options : 'options' } );
  _.accessorForbid( context, { context : 'context' } );

  var report = {};
  report.passed = 0;
  report.failed = 0;

  var onEach = function( o,testRoutine )
  {
    return _testRoutineRun( o,testRoutine,context,report );
  }

  var handleTestSuiteBegin = function handleTestSuiteBegin()
  {

    var msg =
    [
      'Starting testing of test suite ' + context.name + '..'
    ];
    logger.logUp.apply( logger,strColor.apply( 'neutral',msg ) );
    logger.log();

  }

  var handleTestSuiteEnd = function handleTestSuiteEnd()
  {

    var msg =
    [
      'Testing of test suite ' + context.name + ' finished ' + ( report.failed === 0 ? 'good' : 'with fails' ) + '.'
    ];
    logger.logDown.apply( logger,strColor.apply( [ report.failed === 0 ? 'good' : 'bad','bold' ],msg ) );

    var msg =
    [
      _.toStr( report,{ wrap : 0, multiline : 1 } )+'\n\n'
    ];
    logger.logDown.apply( logger,strColor.apply( [ report.failed === 0 ? 'good' : 'bad' ],msg ) );

    //logger.log( '' + _.toStr( report,{ wrap : 0, multiline : 1 } )+'\n\n' );

/*
    logger.logDown
    (
      '%cTesting of ' + context.name + ' finished.',
      ( report.failed === 0 ) ? colorGood : colorBad,
      '\n  ' + _.toStr( report,{ wrap : 0, multiline : 1 } )+'\n\n'
    );
*/

    con.give();
  }

  _.execStages( tests,
  {
    syn : 1,
    manual : 1,
    onEach : onEach,
    onBegin : handleTestSuiteBegin,
    onEnd : handleTestSuiteEnd,
  });

  return con;
}

//

var _testRoutineRun = function( o,testRoutine,context,report )
{
  var self = this;

  // var tests = context.tests;
  // var con = new wConsequence();
  //
  // _.accessorForbid( context, { options : 'options' } );
  // _.accessorForbid( context, { context : 'context' } );
  //
  // var report = {};
  // report.passed = 0;
  // report.failed = 0;

  //var onEach = function( o,testRoutine )

  var result = null;
  var test = {};
  test.name = options.key;
  test.report = report;
  test.description = '';
  test.context = context;

  _.mapSupplement( test,context );

  Object.setPrototypeOf( test, Self );

  self._beganTestRoutine( test );

  if( self.safe )
  {

    try
    {
      result = testRoutine.call( context,test );
    }
    catch( err )
    {
      report.failed += 1;

      debugger;

      var msg =
      [
        testCaseText( test ) +
        ' ... failed throwing error\n' +
        _.err( err ).toString()
      ];

      logger.error.apply( logger,strColor.apply( 'bad',msg ) );
    }
  }
  else
  {
    result = testRoutine.call( context,test );
  }

  result = wConsequence.make( result );

  result.then_( function()
  {
    self._endedTestRoutine( test,failed === report.failed );
  });

  return result;
}

//

var _beganTestRoutine = function( test )
{

  var msg =
  [
    'Running test routine ' + test.name + '..'
  ];
  logger.logUp.apply( logger,strColor.apply( 'neutral',msg ) );

/*
  logger.logUp( '\n%cRunning test',colorNeutral,test.name+'..' );
*/

}

//

var _endedTestRoutine = function( test,success )
{

  if( success )
  {

    var msg =
    [
      'Passed test routine : ' + test.name + '.'
    ];
    logger.logDown.apply( logger,strColor.apply( [ 'good','bold' ],msg ) );

    //logger.logDown( '%cPassed test :',colorGood,test.name+'.\n' );

  }
  else
  {

    var msg =
    [
      'Failed test routine : ' + test.name + '.'
    ];
    logger.logDown.apply( logger,strColor.apply( [ 'bad','bold' ],msg ) );

  }

  logger.log();

}

//

var colorBad = 'color : #ff0000; font-weight :lighter;';
var colorGood = 'background-color : #00aa00; color : #008800; font-weight :lighter;';
var colorNeutral = 'background-color : #aaaaaa; color : #ffffff; font-weight :lighter;';

var colorBold = 'background-color : #aaaaaa';

var EPS = 1e-5;
var safe = true;
var verbose = false;

// --
// prototype
// --

var Self =
{

  // equalizer

  identical : identical,
  equivalent : equivalent,
  contain : contain,
  shouldThrowError : shouldThrowError,


  // output

  reportOutcome : reportOutcome,
  testCaseText : testCaseText,

  _strColor : _strColor,
  strColor : strColor,


  // tester

  testAll : testAll,
  test : test,

  _testSuiteRunDelayed : _testSuiteRunDelayed,
  _testSuiteRun : _testSuiteRun,

  _testRoutineRun : _testRoutineRun,
  _beganTestRoutine : _beganTestRoutine,
  _endedTestRoutine : _endedTestRoutine,


  // var

  colorBad : colorBad,
  colorGood : colorGood,
  colorNeutral : colorNeutral,
  EPS : EPS,

  safe : safe,
  verbose : verbose,

};

wTools.testing = Self;

if( typeof module !== 'undefined' && module !== null )
{
  module[ 'exports' ] = Self;
}

//_.timeOut( 5000, _.routineJoin( self,Self.test ) );

})();
