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
  require( '../../abase/object/printer/printer/Logger.s' );

  var Chalk = require( 'chalk' );

}

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

var equivalent = function( got,expected,eps )
{
  var test = this;
  var optionsForEntity = {};

  if( eps === undefined )
  eps = test.eps;

  optionsForEntity.eps = eps;

  _.assert( arguments.length === 2 || arguments.length === 3 );

  var outcome = _.entityEquivalent( got,expected,optionsForEntity );

  test.reportOutcome( outcome,got,expected,optionsForEntity.lastPath );

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

  return test._conSyn/*.thenClone()*/.got( function()
  {

    var con = this;
    var result;
    if( routine instanceof wConsequence )
    {
      result = routine;
    }
    else try
    {
      debugger;
      var result = routine.call( this );
    }
    catch( err )
    {
      thrown = 1;
      outcome = test.reportOutcome( 1,'error thrown','error thrown','' );
    }

    /* */

    if( result instanceof wConsequence )
    {
      result
      .got( function( err )
      {
        if( !err )
        outcome = test.reportOutcome( 0,'error not thrown','error thrown','' );
        else
        outcome = test.reportOutcome( 1,'error thrown','error thrown','' );
        con.give();
      })
      .thenDo( function( err,data )
      {
        test.reportOutcome( 0,'shouldThrowError : should never reach it, consequence got redundant messages','single message for consequence','' );
      });
    }
    else
    {
      if( !thrown )
      outcome = test.reportOutcome( 0,'error not thrown','error thrown','' );
      con.give();
    }

    //return result;
  });

}

//

var shouldMessageOnlyOnce = function( con )
{
  var test = this;
  var result = new wConsequence();

  _.assert( arguments.length === 1 );
  _.assert( con instanceof wConsequence );

  var state = test.stateStore();

  con
  .got( function( err,data )
  {
    _.timeOut( 10, function()
    {
      result.give( err,data );
    });
  })
  .thenDo( function( err,data )
  {
    test.stateStore();
    test.stateRestore( state );
    test.reportOutcome( 0,'shouldMessageOnlyOnce : should never reach it, consequence got redundant messages','single message for consequence','' );
    test.stateRestore();
  });

  return result;
}

// --
// store
// --

var stateStore = function()
{
  var test = this;
  var result = {};

  _.assert( arguments.length === 0 );

  result.description = test.description;
  result._caseIndex = test._caseIndex;

  test._storedStates = test._storedStates || [];
  test._storedStates.push( result );

  return test;
}

//

var stateRestore = function( state )
{
  var test = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !state )
  {
    _.assert( _.arrayIs( test._storedStates ) && test._storedStates.length, 'stateRestore : no stored state' )
    state = test._storedStates.pop();
  }

  test.description = state.description;
  test._caseIndex = state._caseIndex;

  return test;
}

// --
// output
// --

var reportOutcome = function( outcome,got,expected,path )
{
  var test = this;

  if( !test._caseIndex )
  test._caseIndex = 1;
  else
  test._caseIndex += 1;

  _.assert( arguments.length === 4 );

  /**/

  var msgExpectedGot = function()
  {
    return '' +
    'expected :\n' + _.toStr( expected,{ wrapString : 0 } ) +
    '\ngot :\n' + _.toStr( got,{ wrapString : 0 } );
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
    'Test routine( ' + test.name + ' ) : ' +
    'test case' + ( test.description ? ( '( ' + test.description + ' )' ) : '' ) +
    ' # ' + test._caseIndex
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

  // var run = function()
  // {
  //   self._testSuiteRunDelayed.apply( self,args );
  // }

  _.timeOut( 1, function()
  {

    _.timeReady( _.routineSeal( self,self._testSuiteRunDelayed,args ) );

  });

}

//

var _testSuiteRunDelayed = function( suit )
{
  var self = this;

  if( arguments.length === 0 )
  {
    self.testAll();
    return;
  }

  if( !self.queue )
  self.queue = new wConsequence().give();

  _.assert( arguments.length === 1 );

  self.queue.thenDo( function()
  {

    return self._testSuiteRun.call( self,suit );

  });

}

//

var _testSuiteRun = function( suit )
{
  var self = this;
  var tests = suit.tests;
  var con = new wConsequence();

  if( _.strIs( suit ) )
  suit = wTests[ suit ];

  //console.log( 'Object.getPrototypeOf( suit ) :',Object.getPrototypeOf( suit ) );

  _.assert( _.strIs( suit.name ),'testing suit should has name' );
  _.assert( _.objectIs( suit.tests ),'testing suit should has map with test routines' );
  //_.assert( _.mapIs( suit ) || Object.getPrototypeOf( suit ) === Self,'expects suit instance of','wTools.Testing' );
  _.accessorForbid( suit,
  {
    options : 'options',
    suit : 'suit',
    context : 'context',
  });

  if( _.mapIs( suit ) )
  Object.setPrototypeOf( suit, Self );
  _.assert( Object.isPrototypeOf.call( Self,suit ) );

  if( !Self._conSyn )
  Self._conSyn = new wConsequence().give();

  var con = suit._conSyn.thenClone();
  con.thenDo( function()
  {

    _.assert( !suit.report );
    var report = suit.report = {};
    report.passed = 0;
    report.failed = 0;

    var onEach = function( e,testRoutine )
    {
      return suit._testRoutineRun( e,testRoutine,suit,report );
    }

    return _.execStages( tests,
    {
      syn : 1,
      manual : 1,
      onEach : onEach,
      onBegin : _.routineJoin( suit,suit.testSuiteBegin ),
      onEnd : _.routineJoin( suit,suit.testSuiteEnd ),
    });

  });

  return con;
}

//

var testSuiteBegin = function testSuiteBegin()
{
  var self = this;

  var msg =
  [
    'Starting testing of test suite ( ' + self.name + ' )..'
  ];

  logger.logUp.apply( logger,strColor.apply( 'neutral',msg ) );
  logger.log();

  if( self.onSuitBegin )
  self.onSuitBegin();

}

//

var testSuiteEnd = function testSuiteEnd()
{
  var self = this;

  if( self.onSuitEnd )
  self.onSuitEnd();

  var msg =
  [
    'Testing of test suite ( ' + self.name + ' ) finished ' + ( self.report.failed === 0 ? 'good' : 'with fails' ) + '.'
  ];

  logger.logDown.apply( logger,strColor.apply( [ self.report.failed === 0 ? 'good' : 'bad','bold' ],msg ) );

  var msg =
  [
    _.toStr( self.report,{ wrap : 0, multiline : 1 } )+'\n\n'
  ];

  logger.log.apply( logger,strColor.apply( [ self.report.failed === 0 ? 'good' : 'bad' ],msg ) );

}

//

var _testRoutineRun = function( e,testRoutine,suit,report )
{
  var self = this;
  var result = null;
  var failed = report.failed;

  var testRoutine = { routine : testRoutine };
  testRoutine.name = e.key;
  testRoutine.report = report;
  testRoutine.description = '';
  testRoutine.suit = suit;
  testRoutine._caseIndex = 0;

  Object.setPrototypeOf( testRoutine, suit );

  _.assert( Object.isPrototypeOf.call( Self,suit ) );
  _.assert( Object.isPrototypeOf.call( Self,testRoutine ) );

  /* error */

  var handleError = function( err )
  {

    report.failed += 1;

    if( testRoutine.onError )
    testRoutine.onError.call( suit,testRoutine );

    var msg =
    [
      testCaseText( testRoutine ) +
      ' ... failed throwing error\n' +
      _.err( err ).toString()
    ];

    logger.error.apply( logger,strColor.apply( 'bad',msg ) );
  }

  /* */

  var con = self._conSyn.thenClone();
  con.thenDo( function()
  {

    self._beganTestRoutine( testRoutine );

    /* */

    if( self.safe )
    {

      try
      {
        result = testRoutine.routine.call( suit,testRoutine );
      }
      catch( err )
      {
        handleError( err );
      }
    }
    else
    {
      result = testRoutine.routine.call( suit,testRoutine );
    }

    /* */

    result = wConsequence.from( result );

    result.thenDo( function( err )
    {
      if( err )
      handleError( err );
      self._endedTestRoutine( test,failed === report.failed );
    });

    return result;
  });

  return con;
}

//

var _beganTestRoutine = function( testRoutine )
{

  var msg =
  [
    'Running test routine ( ' + testRoutine.name + ' )..'
  ];
  logger.logUp.apply( logger,strColor.apply( 'neutral',msg ) );

/*
  logger.logUp( '\n%cRunning test',colorNeutral,test.name+'..' );
*/

}

//

var _endedTestRoutine = function( testRoutine,success )
{

  if( success )
  {

    var msg =
    [
      'Passed test routine ( ' + testRoutine.name + ' ).'
    ];
    logger.logDown.apply( logger,strColor.apply( [ 'good','bold' ],msg ) );

    //logger.logDown( '%cPassed test :',colorGood,test.name+'.\n' );

  }
  else
  {

    var msg =
    [
      'Failed test routine ( ' + testRoutine.name + ' ).'
    ];
    logger.logDown.apply( logger,strColor.apply( [ 'bad','bold' ],msg ) );

  }

  logger.log();

}

//

var colorBad = 'color:#ff0000;font-weight:lighter;';
var colorGood = 'background-color:#00aa00;color:#008800;font-weight:lighter;';
var colorNeutral = 'background-color:#aaaaaa;color:#ffffff;font-weight:lighter;';
var colorBold = 'background-color:#aaaaaa';

var EPS = 1e-5;
var safe = true;
var verbose = false;
var _conSyn = null

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
  shouldMessageOnlyOnce : shouldMessageOnlyOnce,

  //

  stateStore : stateStore,
  stateRestore : stateRestore,


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
  testSuiteBegin : testSuiteBegin,
  testSuiteEnd : testSuiteEnd,

  _testRoutineRun : _testRoutineRun,
  _beganTestRoutine : _beganTestRoutine,
  _endedTestRoutine : _endedTestRoutine,


  // var

  colorBad : colorBad,
  colorGood : colorGood,
  colorNeutral : colorNeutral,
  EPS : EPS,
  _conSyn : _conSyn,

  safe : safe,
  verbose : verbose,

}

wTools.Testing = Self;

_global_.wTests = _global_.wTests === undefined ? {} : _global_.wTests;

if( typeof module !== 'undefined' && module !== null )
{
  module[ 'exports' ] = Self;
}

//_.timeOut( 5000, _.routineJoin( self,Self.test ) );

})();
