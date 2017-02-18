(function _aTestSuite_debug_s_() {

'use strict';

var isBrowser = true;
if( typeof module !== 'undefined' )
{

  isBrowser = false;

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

}

//

var _ = wTools;
var Parent = null;
var Self = function wTestSuite( o )
{
  _.assert( arguments.length <= 1 );

  if( !( this instanceof Self ) )
  if( _.strIs( o ) )
  return Self.instanceByName( o );

  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
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

  if( o )
  suite.copy( o );

  _.assert( o === undefined || _.objectIs( o ),'expects object ( options ), but got',_.strTypeOf( o ) );

  if( !( o instanceof Self ) )
  _.assert( _.strIsNotEmpty( suite.name ),'Test suite expects name, but got',suite.name );

  return suite;
}

//

function copy( o )
{
  var suite = this;

  if( !( o instanceof Self ) )
  suite.name = o.name;

  return wCopyable.copy.call( suite,o );
}

//

function extendBy()
{
  var suite = this;

  for( var a = 0 ; a < arguments.length ; a++ )
  {
    var src = arguments[ 0 ];

    _.assert( _.mapIs( src ) );

    if( src.tests )
    _.mapSupplement( src.tests,suite.tests );

    if( src.special )
    _.mapSupplement( src.special,suite.special );

    _.mapExtend( suite,src );

  }

  return suite;
}

// --
// etc
// --

// function _register()
// {
//   var suite = this;
//
//   _.assert( arguments.length > 0 );
//
//   for( var a = 0 ; a < arguments.length ; a++ )
//   {
//
//     var testSuite = arguments[ a ];
//
//     _.assert( _.strIsNotEmpty( testSuite.name ),'Test suite should have name' );
//     _.assert( !_global_.wTests[ testSuite.name ],'Test suite with name',testSuite.name,'already registered!' );
//
//     _global_.wTests[ testSuite.name ] = wTestSuite( testSuite );
//
//     debugger;
//
//     _.assert( _global_.wTests[ testSuite.name ] instanceof Self );
//
//     // console.log( 'Test suite ',testSuite.name,_global_.wTests[ testSuite.name ].logger );
//
//   }
//
//   return suite;
// }

//

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

//

function reportNew()
{
  var suite = this;

  debugger;
  _.assert( !suite.report );
  var report = suite.report = {};
  report.passed = 0;
  report.failed = 0;

}

// --
// test suite run
// --

function _testSuiteRunLater()
{
  var suite = this;

  // console.log( '_testSuiteRunLater' );
  // console.log( _.diagnosticStack() );

  _.assert( suite instanceof Self );
  _.assert( arguments.length === 0 );

  return wTestSuite._suiteCon
  .thenDo( _.routineSeal( _,_.timeReady,[] ) )
  // .thenDo( _.routineSeal( _,_.timeOut,[ 10000 ] ) )
  .thenDo( function()
  {

    return suite._testSuiteRunAct();

  })
  .thenSplit();
}

//

function _testSuiteRunNow()
{
  var suite = this;
  var tests = suite.tests;

  _.assert( suite instanceof Self );
  _.assert( arguments.length === 0 );

  /* */

  return wTestSuite._suiteCon
  .thenDo( function()
  {

    return suite._testSuiteRunAct();

  })
  .thenSplit();
}

//

function _testSuiteRunAct()
{
  var suite = this;
  var tests = suite.tests;

  _.assert( suite instanceof Self );
  _.assert( arguments.length === 0 );

  if( _.Testing.verbosity !== null )
  suite.verbosity = _.Testing.verbosity;

  if( _.Testing.logger !== null )
  suite.logger = _.Testing.logger;

  suite.report = null;
  suite.reportNew();

  var onEachStage = function onEachStage( testRoutine,iteration,iterator )
  {
    return suite._testRoutineRun( iteration.key,testRoutine );
  }

  return _.execStages( tests,
  {
    manual : 1,
    onEachRoutine : onEachStage,
    onBegin : _.routineJoin( suite,suite._testSuiteBegin ),
    onEnd : _.routineJoin( suite,suite._testSuiteEnd ),
  });

}

//

function _testSuiteBegin()
{
  var suite = this;
  debugger;

  var msg =
  [
    'Starting testing of test suite ( ' + suite.name + ' ) ..'
  ];

  suite.logger.logUp( _.strColor.style( msg,[ 'topic','neutral' ] ) );
  suite.logger.log();

  _.assert( !_.Testing.currentSuite );
  _.Testing.currentSuite = suite;

  if( suite.onSuitBegin )
  suite.onSuitBegin();

}

//

function _testSuiteEnd()
{
  var suite = this;

  _.assert( _.Testing.currentSuite === suite );
  _.Testing.currentSuite = null;

  if( suite.onSuitEnd )
  suite.onSuitEnd();

  var msg =
  [
    _.toStr( suite.report,{ wrap : 0, multiline : 1 } )+'\n\n'
  ];

  debugger;
  suite.logger.log( _.strColor.style( msg,[ suite.report.failed === 0 ? 'good' : 'bad' ] ) );

  var msg =
  [
    'Testing of test suite ( ' + suite.name + ' ) finished ' + ( suite.report.failed === 0 ? 'good' : 'with fails' ) + '.'
  ];

  suite.logger.logDown( _.strColor.style( msg,[ suite.report.failed === 0 ? 'good' : 'bad','topic' ] ) );

  // debugger;
  return suite;
}

// --
// test routine run
// --

function _testRoutineRun( name,testRoutine )
{
  var suite = this;
  var result = null;
  var report = suite.report;
  var failed = report.failed;

  var testRoutineDescriptor = Object.create( suite );
  testRoutineDescriptor.routine = testRoutine;
  // testRoutineDescriptor.routine.name = name;
  testRoutineDescriptor.description = '';
  testRoutineDescriptor.suite = suite;
  testRoutineDescriptor._caseIndex = 0;
  testRoutineDescriptor._testRoutineDescriptorIs = 1;
  testRoutineDescriptor._storedStates = null;
  Object.preventExtensions( testRoutineDescriptor );

  _.assert( _.routineIs( testRoutine ) );
  _.assert( _.strIsNotEmpty( testRoutine.name ),'Test routine should have name, few test routine of test suite',suite.name,'does not' );
  _.assert( testRoutine.name === name );
  // _.assert( _.strIsNotEmpty( testRoutineDescriptor.routine.name ),'Test routine descriptor should have name' );
  _.assert( Object.isPrototypeOf.call( wTestSuite.prototype,suite ) );
  _.assert( Object.isPrototypeOf.call( wTestSuite.prototype,testRoutineDescriptor ) );
  _.assert( arguments.length === 2 );

  /* */

  return wTestSuite._routineCon
  .thenDo( function()
  {

    suite._testRoutineBegin( testRoutineDescriptor );

    /* */

    if( suite.safe )
    {

      try
      {
        result = testRoutineDescriptor.routine.call( suite,testRoutineDescriptor );
      }
      catch( err )
      {
        suite.exceptionReport( err,testRoutineDescriptor );
      }

    }
    else
    {
      result = testRoutineDescriptor.routine.call( suite,testRoutineDescriptor );
    }

    /* */

    result = wConsequence.from( result );

    result.thenDo( function( err )
    {
      if( err )
      suite.exceptionReport( err,testRoutineDescriptor );
      suite._testRoutineEnd( testRoutineDescriptor,failed === report.failed );
    });

    return result;
  })
  .thenSplit();

}

//

function _testRoutineBegin( testRoutineDescriptor )
{
  var suite = this;

  var msg =
  [
    'Running test routine ( ' + testRoutineDescriptor.routine.name + ' ) ..'
  ];

  debugger;
  suite.logger.logUp( _.strColor.style( msg,[ 'topic','neutral' ] ) );

  _.assert( !suite.currentRoutine );
  suite.currentRoutine = testRoutineDescriptor;

}

//

function _testRoutineEnd( testRoutineDescriptor,success )
{
  var suite = this;

  _.assert( _.strIsNotEmpty( testRoutineDescriptor.routine.name ),'test routine should have name' );
  _.assert( suite.currentRoutine === testRoutineDescriptor );
  suite.currentRoutine = null;

  debugger;

  if( success )
  {

    var msg =
    [
      'Passed test routine ( ' + testRoutineDescriptor.routine.name + ' ).'
    ];
    suite.logger.logDown( _.strColor.style( msg,[ 'good','neutral' ] ) );

  }
  else
  {

    var msg =
    [
      'Failed test routine ( ' + testRoutineDescriptor.routine.name + ' ).'
    ];
    suite.logger.logDown( _.strColor.style( msg,[ 'bad','neutral' ] ) );

  }

  suite.logger.log();

}

// --
// store
// --

function stateStore()
{
  var suite = this;
  var result = {};

  _.assert( arguments.length === 0 );

  result.description = suite.description;
  result._caseIndex = suite._caseIndex;

  suite._storedStates = suite._storedStates || [];
  suite._storedStates.push( result );

  // console.log( 'stateStore',result._caseIndex );

  return result;
}

//

function stateRestore( state )
{
  var suite = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  // console.log( 'stateRestore',state );

  if( !state )
  {
    _.assert( _.arrayIs( suite._storedStates ) && suite._storedStates.length, 'stateRestore : no stored state' )
    state = suite._storedStates.pop();
  }

  suite.description = state.description;
  suite._caseIndex = state._caseIndex;

  return suite;
}

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
  var suite = this;
  var thrown = 0;
  var outcome;

  _.assert( _.routineIs( routine ) )
  _.assert( arguments.length === 1 );

  return wTestSuite._conSyn.got( function shouldThrowError()
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
      outcome = suite.outcomeReportSpecial( 1,'error thrown by call as expected' );
    }

    /* */

    if( result instanceof wConsequence )
    {
      result
      .got( function( err,data )
      {
        if( !err )
        {
          outcome = suite.outcomeReportSpecial( 0,'error not thrown, but expected' );
        }
        else
        {
          thrown = 1;
          if( suite.verbosity )
          _.errLogOnce( err );
          outcome = suite.outcomeReportSpecial( 1,'error thrown by consequence as expected' );
        }
        con.give( data );
      })
      .thenDo( function( err,data )
      {
        suite.outcomeReportSpecial( 0,'error thrown several times, something wrong' );
      });
    }
    else
    {
      if( !thrown )
      outcome = suite.outcomeReportSpecial( 0,'error not thrown, but expected' );
      con.give();
    }

  });

}

//

function mustNotThrowError( routine )
{
  var suite = this;
  var thrown = 0;
  var outcome;

  _.assert( _.routineIs( routine ) )
  _.assert( arguments.length === 1 );

  return wTestSuite._conSyn.got( function shouldThrowError()
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
      outcome = suite.outcomeReportSpecial( 0,'error thrown by call, something wrong' );
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
          outcome = suite.outcomeReportSpecial( 0,'error thrown by consequence, not expected' );
        }
        else
        {
          outcome = suite.outcomeReportSpecial( 1,'error not thrown' );
        }
        con.give( err,data );
      })
      .thenDo( function( err,data )
      {
        suite.outcomeReportSpecial( 0,'message sent several times, something wrong' );
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
  var suite = this;
  var result = new wConsequence();

  _.assert( arguments.length === 1 );
  _.assert( con instanceof wConsequence );

  var state = suite.stateStore();

  con
  .got( function( err,data )
  {
    _.timeOut( 1000, function()
    {
      suite.outcomeReportSpecial( 1,'message thrown at least once' );
      result.give( err,data );
    });
  })
  .thenDo( function( err,data )
  {
    suite.stateStore();
    suite.stateRestore( state );
    suite.outcomeReportSpecial( 0,'got several messages, expected only one' );
    suite.stateRestore();
  });

  return result;
}

// --
// output
// --

function _outcomeReporting( outcome )
{
  var suite = this;

  if( !suite._caseIndex )
  suite._caseIndex = 1;
  else
  suite._caseIndex += 1;

  if( outcome )
  suite.report.passed += 1;
  else
  suite.report.failed += 1;

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

    if( testRoutineDescriptor.verbosity )
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
    if( testRoutineDescriptor.usingSourceCode )
    {
      debugger;
      var _location = _.diagnosticLocation({ level : 3 }).full;
      var _code = _.diagnosticCode({ level : 3 });

      if( _code )
      code = '\n' + _location + '\n' + _code;
      else
      code = '\n' + _location;

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
  var suite = this;

  // suite.report.failed += 1; xxxx

  if( testRoutineDescriptor.onError )
  testRoutineDescriptor.onError.call( suite,testRoutineDescriptor );

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
  _.assert( _.strIsNotEmpty( testRoutineDescriptor.routine.name ),'test routine descriptor should have name' );

  var result = '' +
    'Test routine( ' + testRoutineDescriptor.routine.name + ' ) : ' +
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
// relationships
// --

var Composes =
{

  tests : null,

  verbosity : 0,
  abstract : 0,

  usingSourceCode : 1,

  safe : 1,
  eps : 1e-5,

  report : null,

}

var Aggregates =
{
}

var Associates =
{
  logger : logger,
  special : null,
}

var Restricts =
{
  name : null,
  currentRoutine : null,
}

var Statics =
{
  usingUniqueNames : 1,
  _suiteCon : new wConsequence().give(),
  _routineCon : new wConsequence().give(),
  _conSyn : new wConsequence().give(),
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


  // etc

  _registerSuites : _registerSuites,
  reportNew : reportNew,


  // test suite run

  _testSuiteRunLater : _testSuiteRunLater,
  _testSuiteRunNow : _testSuiteRunNow,
  _testSuiteRunAct : _testSuiteRunAct,
  _testSuiteBegin : _testSuiteBegin,
  _testSuiteEnd : _testSuiteEnd,


  // test routine run

  _testRoutineRun : _testRoutineRun,
  _testRoutineBegin : _testRoutineBegin,
  _testRoutineEnd : _testRoutineEnd,


  // state

  stateStore : stateStore,
  stateRestore : stateRestore,


  // equalizer

  shouldBe : shouldBe,
  identical : identical,
  equivalent : equivalent,
  contain : contain,

  shouldThrowError : shouldThrowError,
  mustNotThrowError : mustNotThrowError,
  shouldMessageOnlyOnce : shouldMessageOnlyOnce,


  // output

  _outcomeReporting : _outcomeReporting,
  _outcomeReport : _outcomeReport,

  outcomeReportSpecial : outcomeReportSpecial,
  outcomeReportCompare : outcomeReportCompare,

  exceptionReport : exceptionReport,

  _currentTestCaseTextGet : _currentTestCaseTextGet,


  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,

}

//

_.protoMake
({
  constructor : Self,
  parent : Parent,
  extend : Proto,
});

wCopyable.mixin( Self );
wInstancing.mixin( Self );

//

_.accessorForbid( Self.prototype,
{
  options : 'options',
  // suite : 'suite',
  context : 'context',
});

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;

return Self;

})();
