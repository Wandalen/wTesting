(function _Testing_debug_s_() {

'use strict';

// var Chalk = null;

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

  var _ = wTools;

  _.include( 'wConsequence' );
  _.include( 'wLogger' );

}

var _ = wTools;

// if( !_.toStr )
// _.toStr = function(){ return String( arguments ) };

_.assert( _.toStr );

// --
// equalizer
// --

function shouldBe( outcome )
{
  var testRoutineDescriptor = this;

  _.assert( _.boolLike( outcome ),'shouldBe expects single bool argument' )
  _.assert( arguments.length === 1,'shouldBe expects single bool argument' );

  if( !outcome )
  debugger;

  testRoutineDescriptor.outcomeReportSpecial( outcome,'expected true' )

  return outcome;
}

//

/**
 * Checks if test passes a specified condition by deep strict comparsing result of code execution( got )
 * with target( expected ). Uses recursive comparsion for objects,arrays and array-like objects.
 * If entity( got ) is equal to entity( expected ) test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {*} got - Source entity.
 * @param {*} expected - Target entity.
 *
 * @example
 * function someTest( test )
 * {
 *  test.description = 'single zero';
 *  var got = 0;
 *  var expected = 0;
 *  test.identical( got, expected );//returns true
 *
 *  test.description = 'single number';
 *  var got = 2;
 *  var expected = 1;
 *  test.identical( got, expected );//returns false
 * }
 *
 * _.Testing.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method identical
 * @memberof wTools
 */

function identical( got,expected )
{
  var testRoutineDescriptor = this;
  var options = {};

  _.assert( arguments.length === 2 );

  var outcome = _.entityIdentical( got,expected,options );

  _.assert( options.lastPath !== undefined );

  testRoutineDescriptor.outcomeReportCompare( outcome,got,expected,options.lastPath );

  return outcome;
}

//

/**
 * Checks if test passes a specified condition by deep soft comparsing result of code execution( got )
 * with target( expected ). Uses recursive comparsion for objects,arrays and array-like objects. Two entities are equivalent if
 * difference between their values are less or equal to( eps ). Example: ( got - expected ) <= ( eps ).
 * If entity( got ) is equivalent to entity( expected ) test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {*} got - Source entity.
 * @param {*} expected - Target entity.
 * @param {*} [ eps=1e-5 ] - Maximal distance between two values.
 *
 * @example
 * function sometest( test )
 * {
 *  test.description = 'single number';
 *  var got = 0.5;
 *  var expected = 1;
 *  var eps = 0.5;
 *  test.equivalent( got, expected, eps );//returns true
 *
 *  test.description = 'single number';
 *  var got = 0.5;
 *  var expected = 2;
 *  var eps = 0.5;
 *  test.equivalent( got, expected, eps );//returns false
 * }
 * _.Testing.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method equivalent
 * @memberof wTools
 */


function equivalent( got,expected,eps )
{
  var testRoutineDescriptor = this;
  var optionsForEntity = {};

  if( eps === undefined )
  eps = testRoutineDescriptor.eps;

  optionsForEntity.eps = eps;

  _.assert( arguments.length === 2 || arguments.length === 3 );

  var outcome = _.entityEquivalent( got,expected,optionsForEntity );

  testRoutineDescriptor.outcomeReportCompare( outcome,got,expected,optionsForEntity.lastPath );

  return outcome;
}

//

/**
 * Checks if test passes a specified condition by deep contain comparsing result of code execution( got )
 * with target( expected ). Uses recursive comparsion for objects,arrays and array-like objects.
 * If entity( got ) contains keys/values from entity( expected ) or they are indentical test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {*} got - Source entity.
 * @param {*} expected - Target entity.
 *
 * @example
 * function sometest( test )
 * {
 *  test.description = 'array';
 *  var got = [ 0, 1, 2 ];
 *  var expected = [ 0 ];
 *  test.contain( got, expected );//returns true
 *
 *  test.description = 'array';
 *  var got = [ 0, 1, 2 ];
 *  var expected = [ 4 ];
 *  test.contain( got, expected );//returns false
 * }
 * _.Testing.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method contain
 * @memberof wTools
 */

function contain( got,expected )
{
  var testRoutineDescriptor = this;
  var options = {};

  var outcome = _.entityContain( got,expected,options );

  testRoutineDescriptor.outcomeReportCompare( outcome,got,expected,options.lastPath );

  return outcome;
}

//

/**
 * Error throwing test. Expects one argument( routine ) - function to call or wConsequence instance.
 * If argument is a function runs it and checks if it throws an error. Otherwise if argument is a consequence  checks if it has a error message.
 * If its not a error or consequence contains more then one message test is failed. After check function reports result of test to the testing system.
 * If test is failed function also outputs additional information. Returns wConsequence instance to perform next call in chain.
 *
 * @param {Function|wConsequence} routine - Funtion to call or wConsequence instance.
 *
 * @example
 * function sometest( test )
 * {
 *  test.description = 'shouldThrowError';
 *  test.shouldThrowError( function()
 *  {
 *    throw _.err( 'Error' );
 *  });
 * }
 * _.Testing.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @example
 * function sometest( test )
 * {
 *  var consequence = new wConsequence().give();
 *  consequence
 *  .ifNoErrorThen( function()
 *  {
 *    test.description = 'shouldThrowError';
 *    var con = new wConsequence( )
 *    .error( _.err() ); //wConsequence instance with error message
 *    return test.shouldThrowError( con );//test passes
 *  })
 *  .ifNoErrorThen( function()
 *  {
 *    test.description = 'shouldThrowError2';
 *    var con = new wConsequence( )
 *    .error( _.err() )
 *    .error( _.err() ); //wConsequence instance with two error messages
 *    return test.shouldThrowError( con ); //test fails
 *  });
 *
 *  return consequence;
 * }
 * _.Testing.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @throws {Exception} If passed argument is not a Routine.
 * @method shouldThrowError
 * @memberof wTools
 */

function shouldThrowError( routine )
{
  var suit = this;
  var thrown = 0;
  var outcome;

  _.assert( _.routineIs( routine ) )
  _.assert( arguments.length === 1 );

  return suit._conSyn.got( function shouldThrowError()
  {

    var con = this;
    var result;
    if( routine instanceof wConsequence )
    {
      result = routine;
    }
    else try
    {
      var result = routine.call( this );
    }
    catch( err )
    {
      thrown = 1;
      outcome = suit.outcomeReportSpecial( 1,'error thrown by call as expected' );
    }

    /* */

    if( result instanceof wConsequence )
    {
      result
      .got( function( err,data )
      {
        if( !err )
        {
          outcome = suit.outcomeReportSpecial( 0,'error not thrown, but expected' );
        }
        else
        {
          thrown = 1;
          if( suit.verbose )
          _.errLogOnce( err );
          outcome = suit.outcomeReportSpecial( 1,'error thrown by consequence as expected' );
        }
        con.give( data );
      })
      .thenDo( function( err,data )
      {
        suit.outcomeReportSpecial( 0,'error thrown several times, something wrong' );
      });
    }
    else
    {
      if( !thrown )
      outcome = suit.outcomeReportSpecial( 0,'error not thrown, but expected' );
      con.give();
    }

  });

}

//

function mustNotThrowError( routine )
{
  var suit = this;
  var thrown = 0;
  var outcome;

  _.assert( _.routineIs( routine ) )
  _.assert( arguments.length === 1 );

  return suit._conSyn.got( function shouldThrowError()
  {

    var con = this;
    var result;
    if( routine instanceof wConsequence )
    {
      result = routine;
    }
    else try
    {
      var result = routine.call( this );
    }
    catch( err )
    {
      thrown = 1;
      _.errLogOnce( err );
      outcome = suit.outcomeReportSpecial( 0,'error thrown by call, something wrong' );
    }

    /* */

    if( result instanceof wConsequence )
    {
      result
      .got( function( err,data )
      {
        if( err )
        {
          thrown = 1;
          _.errLogOnce( err );
          outcome = suit.outcomeReportSpecial( 0,'error thrown by consequence, not expected' );
        }
        else
        {
          outcome = suit.outcomeReportSpecial( 1,'error not thrown' );
        }
        con.give( err,data );
      })
      .thenDo( function( err,data )
      {
        suit.outcomeReportSpecial( 0,'message sent several times, something wrong' );
      });
    }
    else
    {
      con.give();
    }

  });

}

//

function shouldMessageOnlyOnce( con )
{
  var suit = this;
  var result = new wConsequence();

  _.assert( arguments.length === 1 );
  _.assert( con instanceof wConsequence );

  var state = suit.stateStore();

  con
  .got( function( err,data )
  {
    _.timeOut( 1000, function()
    {
      suit.outcomeReportSpecial( 1,'message thrown at least once' );
      result.give( err,data );
    });
  })
  .thenDo( function( err,data )
  {
    suit.stateStore();
    suit.stateRestore( state );
    suit.outcomeReportSpecial( 0,'got several messages, expected only one' );
    suit.stateRestore();
  });

  return result;
}

// --
// store
// --

function stateStore()
{
  var suit = this;
  var result = {};

  _.assert( arguments.length === 0 );

  result.description = suit.description;
  result._caseIndex = suit._caseIndex;

  suit._storedStates = suit._storedStates || [];
  suit._storedStates.push( result );

  // console.log( 'stateStore',result._caseIndex );

  return result;
}

//

function stateRestore( state )
{
  var suit = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  // console.log( 'stateRestore',state );

  if( !state )
  {
    _.assert( _.arrayIs( suit._storedStates ) && suit._storedStates.length, 'stateRestore : no stored state' )
    state = suit._storedStates.pop();
  }

  suit.description = state.description;
  suit._caseIndex = state._caseIndex;

  return suit;
}

// --
// output
// --

function _outcomeReporting( outcome )
{
  var suit = this;

  if( !suit._caseIndex )
  suit._caseIndex = 1;
  else
  suit._caseIndex += 1;

  if( outcome )
  suit.report.passed += 1;
  else
  suit.report.failed += 1;

  _.assert( arguments.length === 1 );

}

//

function _outcomeReport( outcome,msg,details )
{
  var testRoutineDescriptor = this;

  testRoutineDescriptor._outcomeReporting( outcome );

  _.assert( arguments.length === 3 );

  if( outcome )
  {

    if( testRoutineDescriptor.verbose )
    {

      testRoutineDescriptor.logger.logUp();
      if( details )
      testRoutineDescriptor.logger.begin( 'details' ).log( details ).end( 'details' );

      msg = _.strColor.style( msg,'good' );

      testRoutineDescriptor.logger.begin( 'message' ).logDown( msg ).end( 'message' );
      testRoutineDescriptor.logger.log();

    }

  }
  else
  {

    var code;
    if( testRoutineDescriptor.usingCode )
    {
      code = _.diagnosticLocation({ level : 3 }).full;
      if( code )
      code += '\n' + _.diagnosticCode({ level : 3 });
    }

    testRoutineDescriptor.logger.logUp();
    if( details )
    testRoutineDescriptor.logger.begin( 'details' ).error( details ).end( 'details' );

    if( code )
    testRoutineDescriptor.logger.begin( 'source' ).error( code ).end( 'source' );

    msg = _.strColor.style( msg,'bad' )

    testRoutineDescriptor.logger.begin( 'message' ).errorDown( msg ).end( 'message' );
    testRoutineDescriptor.logger.log();

  }

}

//

function outcomeReportSpecial( outcome,msg )
{
  var testRoutineDescriptor = this;

  _.assert( arguments.length === 2 );

  msg = testRoutineDescriptor._currentTestCaseTextGet( outcome,msg );

  testRoutineDescriptor._outcomeReport( outcome,msg,'' );

}

//

function outcomeReportCompare( outcome,got,expected,path )
{
  var testRoutineDescriptor = this;

  _.assert( testRoutineDescriptor._testRoutineDescriptorIs );
  _.assert( arguments.length === 4 );

  /**/

  function msgExpectedGot()
  {
    return '' +
    'got :\n' + _.toStr( got,{ stringWrapper : '' } ) + '\n' +
    'expected :\n' + _.toStr( expected,{ stringWrapper : '' } ) +
    '';
  }

  /**/

  if( outcome )
  {

    var details = msgExpectedGot();
    var msg = testRoutineDescriptor._currentTestCaseTextGet( 1 );
    testRoutineDescriptor._outcomeReport( outcome,msg,details );

  }
  else
  {

    var details = msgExpectedGot();

    if( !_.atomicIs( got ) && !_.atomicIs( expected ) )
    details +=
    (
      '\nat : ' + path +
      '\ngot :\n' + _.toStr( _.entitySelect( got,path ) ) +
      '\nexpected :\n' + _.toStr( _.entitySelect( expected,path ) ) +
      ''
    );

    if( _.strIs( expected ) && _.strIs( got ) )
    details += '\ndifference :\n' + _.strDifference( expected,got );

    var msg = testRoutineDescriptor._currentTestCaseTextGet( 0 );

    testRoutineDescriptor._outcomeReport( outcome,msg,details );

    debugger;
  }

}

//

function exceptionReport( err,testRoutineDescriptor )
{
  var suit = this;

  // suit.report.failed += 1; xxxx

  if( testRoutineDescriptor.onError )
  testRoutineDescriptor.onError.call( suit,testRoutineDescriptor );

  var msg =
  [
    testRoutineDescriptor._currentTestCaseTextGet() +
    ' ... failed throwing error\n'
  ];

  var details = _.err( err ).toString();

  testRoutineDescriptor._outcomeReport( 0,msg,details );

}

//

function _currentTestCaseTextGet( value,hint )
{
  var testRoutineDescriptor = this;

  _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 );
  _.assert( value === undefined || _.boolLike( value ) );
  _.assert( hint === undefined || _.strIs( hint ) );
  _.assert( testRoutineDescriptor._testRoutineDescriptorIs );
  _.assert( testRoutineDescriptor._caseIndex >= 0 );
  _.assert( _.strIsNotEmpty( testRoutineDescriptor.name ),'test routine descriptor should have name' );

  var result = '' +
    'Test routine( ' + testRoutineDescriptor.name + ' ) : ' +
    'test case' + ( testRoutineDescriptor.description ? ( '( ' + testRoutineDescriptor.description + ' )' ) : '' ) +
    ' # ' + testRoutineDescriptor._caseIndex
  ;

  if( hint )
  result += ' : ' + hint;

  if( value !== undefined )
  {
    if( value )
    result += ' ... ok';
    else
    result += ' ... failed';
  }

  return result;
}

// --
// tester
// --

function register( test )
{
  var self = this;

  _.assert( arguments.length > 0 );

  for( var a = 0 ; a < arguments.length ; a++ )
  {

    var test = arguments[ a ];
    _.assert( _.strIsNotEmpty( test.name ),'test suite should have name' );
    _global_.wTests[ test.name ] = test;

  }

  return self;
}

//

function testAll()
{
  var self = this;

  _.assert( arguments.length === 0 );

  self.logger.log( 'Launching all test suites' );

  for( var t in wTests )
  {
    self.test( t );
  }

}

//

function test()
{
  var proto = this;
  var args = arguments;

  _.assert( this === Self );

  return _.timeOut( 1, function()
  {
    return _.timeReady( _.routineSeal( Self,Self._testSuiteRunDelayed,args ) );
  });

}

//

function _testSuiteRunDelayed( suit )
{

  _.assert( this === Self );

  if( arguments.length === 0 )
  {
    Self.testAll();
    return;
  }

  if( !Self.queue )
  Self.queue = new wConsequence().give();

  _.assert( arguments.length === 1 );

  Self.queue.thenDo( function()
  {

    return Self._testSuiteRun.call( Self,suit );

  });

  return Self.queue;
}

//

function _testSuiteRun( suit )
{
  var proto = this;
  var con = new wConsequence();

  if( _.strIs( suit ) )
  suit = wTests[ suit ];
  var tests = suit.tests;

  /* */

  _.assert( _.strIsNotEmpty( suit.name ),'testing suit should has name' );
  _.assert( _.objectIs( suit.tests ),'testing suit should has map with test routines' );
  _.accessorForbid( suit,
  {
    options : 'options',
    suit : 'suit',
    context : 'context',
  });

  /* */

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

    var onEachStage = function onEachStage( testRoutine,iteration,iterator )
    {
      return suit._testRoutineRun( iteration.key,testRoutine );
    }

    return _.execStages( tests,
    {
      // syn : 1,
      manual : 1,
      onEachRoutine : onEachStage,
      onBegin : _.routineJoin( suit,suit._testSuiteBegin ),
      onEnd : _.routineJoin( suit,suit._testSuiteEnd ),
    });

  });

  return con;
}

//

function _testSuiteBegin()
{
  var suit = this;

  var msg =
  [
    'Starting testing of test suite ( ' + suit.name + ' ) ..'
  ];

  suit.logger.logUp( _.strColor.style( msg,[ 'topic','neutral' ] ) );
  suit.logger.log();

  if( suit.onSuitBegin )
  suit.onSuitBegin();

}

//

function _testSuiteEnd()
{
  var suit = this;

  // debugger;
  // console.log( '_testSuiteEnd',arguments.length );

  if( suit.onSuitEnd )
  suit.onSuitEnd();

  var msg =
  [
    'Testing of test suite ( ' + suit.name + ' ) finished ' + ( suit.report.failed === 0 ? 'good' : 'with fails' ) + '.'
  ];

  suit.logger.logDown( _.strColor.style( msg,[ suit.report.failed === 0 ? 'good' : 'bad','topic' ] ) );

  var msg =
  [
    _.toStr( suit.report,{ wrap : 0, multiline : 1 } )+'\n\n'
  ];

  suit.logger.log( _.strColor.style( msg,[ suit.report.failed === 0 ? 'good' : 'bad' ] ) );

  return suit;
}

//

function _testRoutineRun( name,testRoutine )
{
  var suit = this;
  var result = null;
  var report = suit.report;
  var failed = report.failed;

  var testRoutineDescriptor = { routine : testRoutine };
  testRoutineDescriptor.name = name;
  // testRoutineDescriptor.report = report;
  testRoutineDescriptor.description = '';
  testRoutineDescriptor.suit = suit;
  testRoutineDescriptor._caseIndex = 0;
  testRoutineDescriptor._testRoutineDescriptorIs = 1;
  testRoutineDescriptor._storedStates = null;

  Object.setPrototypeOf( testRoutineDescriptor, suit );
  Object.preventExtensions( testRoutineDescriptor );

  _.assert( _.routineIs( testRoutine ) );
  _.assert( _.strIsNotEmpty( testRoutineDescriptor.name ),'test routine descriptor should have name' );
  _.assert( Object.isPrototypeOf.call( Self,suit ) );
  _.assert( Object.isPrototypeOf.call( Self,testRoutineDescriptor ) );
  _.assert( arguments.length === 2 );

  /* */

  var con = suit._conSyn.thenClone();
  con.thenDo( function()
  {

    suit._beganTestRoutine( testRoutineDescriptor );

    /* */

    if( suit.safe )
    {

      try
      {
        result = testRoutineDescriptor.routine.call( suit,testRoutineDescriptor );
      }
      catch( err )
      {
        suit.exceptionReport( err,testRoutineDescriptor );
      }

    }
    else
    {
      result = testRoutineDescriptor.routine.call( suit,testRoutineDescriptor );
    }

    /* */

    result = wConsequence.from( result );

    result.thenDo( function( err )
    {
      if( err )
      suit.exceptionReport( err,testRoutineDescriptor );
      suit._endedTestRoutine( testRoutineDescriptor,failed === report.failed );
    });

    return result;
  });

  return con;
}

//

function _beganTestRoutine( testRoutineDescriptor )
{
  var suit = this;

  var msg =
  [
    'Running test routine ( ' + testRoutineDescriptor.name + ' ) ..'
  ];

  suit.logger.logUp( _.strColor.style( msg,[ 'topic','neutral' ] ) );

}

//

function _endedTestRoutine( testRoutineDescriptor,success )
{
  var suit = this;

  _.assert( _.strIsNotEmpty( testRoutineDescriptor.name ),'test routine should have name' );

  if( success )
  {

    var msg =
    [
      'Passed test routine ( ' + testRoutineDescriptor.name + ' ).'
    ];
    suit.logger.logDown( _.strColor.style( msg,[ 'good','neutral' ] ) );

  }
  else
  {

    var msg =
    [
      'Failed test routine ( ' + testRoutineDescriptor.name + ' ).'
    ];
    suit.logger.logDown( _.strColor.style( msg,[ 'bad','neutral' ] ) );

  }

  suit.logger.log();

}

// --
//
// --

var Statics =
{
  EPS : 1e-5,

  safe : 1,
  usingCode : 1,
  verbose : 0,

  _conSyn : null,
  logger : logger,
}

// --
// prototype
// --

var Self =
{

  // equalizer

  shouldBe : shouldBe,
  identical : identical,
  equivalent : equivalent,
  contain : contain,

  shouldThrowError : shouldThrowError,
  mustNotThrowError : mustNotThrowError,
  shouldMessageOnlyOnce : shouldMessageOnlyOnce,


  // state

  stateStore : stateStore,
  stateRestore : stateRestore,


  // output

  _outcomeReporting : _outcomeReporting,
  _outcomeReport : _outcomeReport,

  outcomeReportSpecial : outcomeReportSpecial,
  outcomeReportCompare : outcomeReportCompare,

  exceptionReport : exceptionReport,

  _currentTestCaseTextGet : _currentTestCaseTextGet,


  // tester

  register : register,

  testAll : testAll,
  test : test,

  _testSuiteRunDelayed : _testSuiteRunDelayed,
  _testSuiteRun : _testSuiteRun,
  _testSuiteBegin : _testSuiteBegin,
  _testSuiteEnd : _testSuiteEnd,

  _testRoutineRun : _testRoutineRun,
  _beganTestRoutine : _beganTestRoutine,
  _endedTestRoutine : _endedTestRoutine,

}

_.mapExtend( Self,Statics );

wTools.Testing = Self;

_global_.wTests = _global_.wTests === undefined ? {} : _global_.wTests;

if( typeof module !== 'undefined' && module !== null )
{
  module[ 'exports' ] = Self;
}

//_.timeOut( 5000, _.routineJoin( self,Self.test ) );

})();
