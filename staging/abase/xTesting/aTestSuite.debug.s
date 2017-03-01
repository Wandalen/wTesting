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

  require( './bTestRoutine.debug.s' );

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
  if( !_.strIsNotEmpty( suite.name ) )
  {
    debugger;
    throw _.err( 'Test suite expects name, but got',suite.name );
  }

  if( !_.strIs( suite.sourceFilePath ) )
  {
    debugger;
    throw _.err( 'Test suite',suite.name,'expects a mandatory option ( sourceFilePath )' );
  }

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

  _.assert( !suite.report );
  var report = suite.report = Object.create( null );

  report.testCasePasses = 0;
  report.testCaseFails = 0;

  report.testRoutinePasses = 0;
  report.testRoutineFails = 0;

  Object.preventExtensions( report );

}

// --
// test suite run
// --

function _testSuiteRunLater()
{
  var suite = this;

  _.assert( suite instanceof Self );
  _.assert( arguments.length === 0 );

  return wTestSuite._suiteCon
  .doThen( _.routineSeal( _,_.timeReady,[] ) )
  // .doThen( _.routineSeal( _,_.timeOut,[ 10000 ] ) )
  .doThen( function()
  {

    return suite._testSuiteRunAct();

  })
  .splitThen();

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
  .doThen( function()
  {

    return suite._testSuiteRunAct();

  })
  .splitThen();
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
  // debugger;

  var msg =
  [
    'Starting testing of test suite ( ' + suite.name + ' ) ..',
  ];

  suite.logger.begin({ 'suite' : suite.name });

  // debugger;
  suite.logger.logUp( msg.join( '\n' ) );
  // suite.logger.up();
  suite.logger.log( _.strColor.fg( '' + suite.sourceFilePath,'yellow' ) );
  // suite.logger.down();
  suite.logger.log();

  suite.logger.end( 'suite' );

  _.assert( !_.Testing.currentSuite );
  _.Testing.currentSuite = suite;

  if( suite.onSuitBegin )
  suite.onSuitBegin();

}

//

function _testSuiteEnd()
{
  var suite = this;

  if( suite.onSuitEnd )
  suite.onSuitEnd();

  var ok = suite.report.testCaseFails === 0;

  // var msg =
  // [
  //   '' + _.toStr( suite.report,{ wrap : 0, multiline : 1 } )
  // ];

  suite.logger.begin( 'suite','end' );

  var msg = '';
  msg += 'Passed test cases ' + ( suite.report.testCasePasses ) + ' / ' + ( suite.report.testCasePasses + suite.report.testCaseFails ) + '\n';
  msg += 'Passed test routines ' + ( suite.report.testRoutinePasses ) + ' / ' + ( suite.report.testRoutinePasses + suite.report.testRoutineFails ) + '';

  suite.logger.log( _.strColor.style( msg,[ ok ? 'good' : 'bad' ] ) );

  var msg =
  [
    'Test suite ( ' + suite.name + ' ) .. ' + ( ok ? 'ok' : 'failed' ) + '.'
  ];

  suite.logger.logDown( _.strColor.style( msg,[ ok ? 'good' : 'bad' ] ) );

  suite.logger.end( 'suite','end' );

  _.Testing.report.testSuitePasses += ok ? 1 : 0;
  _.Testing.report.testSuiteFailes += ok ? 0 : 1;

  _.Testing.report.testRoutinePasses += suite.report.testRoutinePasses;
  _.Testing.report.testRoutineFails += suite.report.testRoutineFails;

  _.Testing.report.testCasePasses += suite.report.testCasePasses;
  _.Testing.report.testCaseFails += suite.report.testCaseFails;

  _.assert( _.Testing.currentSuite === suite );
  _.Testing.currentSuite = null;

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
  var caseFails = report.testCaseFails;
  var testRoutineDescriptor = wTestRoutine({ name : name, routine : testRoutine, suite : suite });

  _.assert( arguments.length === 2 );

  /* */

  return wTestSuite._routineCon
  .doThen( function()
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
        suite.exceptionReport({ err : err , testRoutineDescriptor : testRoutineDescriptor });
      }

    }
    else
    {
      result = testRoutineDescriptor.routine.call( suite,testRoutineDescriptor );
    }

    /* */

    result = wConsequence.from( result,_.Testing.testRoutineTimeOut );

    result.doThen( function( err,data )
    {
      // debugger;
      // console.log( 'doThen',err,data );
      if( data === _.timeOut )
      err = _._err
      ({
        args : [ 'Test routine ( ' + testRoutineDescriptor.routine.name + ' ) time out!' ],
        usingSourceCode : 0,
      });

      if( err )
      suite.exceptionReport
      ({
        err : err,
        testRoutineDescriptor : testRoutineDescriptor,
        usingSourceCode : data !== _.timeOut,
      });
      suite._testRoutineEnd( testRoutineDescriptor,caseFails === report.testCaseFails );
    });

    return result;
  })
  .splitThen();

}

//

function _testRoutineBegin( testRoutineDescriptor )
{
  var suite = this;

  var msg =
  [
    'Running test routine ( ' + testRoutineDescriptor.routine.name + ' ) ..'
  ];

  suite.logger.begin({ 'routine' : testRoutineDescriptor.routine.name });

  suite.logger.logUp( msg.join( '\n' ) );

  suite.logger.end( 'routine' );

  _.assert( !suite.currentRoutine );
  suite.currentRoutine = testRoutineDescriptor;

  suite.currentRoutineFails = 0;
  suite.currentRoutinePasses = 0;

}

//

function _testRoutineEnd( testRoutineDescriptor,success )
{
  var suite = this;

  _.assert( _.strIsNotEmpty( testRoutineDescriptor.routine.name ),'test routine should have name' );
  _.assert( suite.currentRoutine === testRoutineDescriptor );

  if( suite.currentRoutineFails )
  suite.report.testRoutineFails += 1;
  else
  suite.report.testRoutinePasses += 1;

  suite.logger.begin( 'routine','end' );

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

  suite.logger.end( 'routine','end' );

  suite.logger.log();

  suite.currentRoutine = null;

}

// --
// store
// --

function stateStore()
{
  var suite = this;
  var result = Object.create( null );

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
  var options = Object.create( null );

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
  var optionsForEntity = Object.create( null );

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
  var options = Object.create( null );

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
  var stack = _.diagnosticStack( 1,-1 );

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
      outcome = suite.outcomeReportSpecial( 1,'error thrown( synchronously ) by call as expected',stack );
    }

    /* */

    if( result instanceof wConsequence )
    {
      result
      .got( function( err,data )
      {
        if( !err )
        {
          outcome = suite.outcomeReportSpecial( 0,'error not thrown, but expected',stack );
        }
        else
        {
          thrown = 1;
          if( suite.verbosity )
          _.errLogOnce( err );
          outcome = suite.outcomeReportSpecial( 1,'error thrown( asynchronously ) as expected',stack );
        }
        con.give( data );
      })
      .doThen( function( err,data )
      {
        suite.outcomeReportSpecial( 0,'message sent several times, something wrong',stack );
      });
    }
    else
    {
      if( !thrown )
      outcome = suite.outcomeReportSpecial( 0,'error not thrown, but expected',stack );
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
  var stack = _.diagnosticStack( 1,-1 );

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
      outcome = suite.outcomeReportSpecial( 0,'error thrown by call, something wrong',stack );
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
          outcome = suite.outcomeReportSpecial( 0,'error thrown by consequence, not expected',stack );
        }
        else
        {
          outcome = suite.outcomeReportSpecial( 1,'error not thrown',stack );
        }
        con.give( err,data );
      })
      .doThen( function( err,data )
      {
        suite.outcomeReportSpecial( 0,'message sent several times, something wrong',stack );
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
  var stack = _.diagnosticStack( 1,-1 );

  con
  .got( function( err,data )
  {
    _.timeOut( 10, function()
    {
      suite.outcomeReportSpecial( 1,'message thrown at least once',stack );
      result.give( err,data );
    });
  })
  .doThen( function( err,data )
  {
    // suite.stateStore();
    // suite.stateRestore( state );
    suite.outcomeReportSpecial( 0,'consequence got several messages, expected only one',stack );
    // suite.stateRestore();
  });

  return result;
}

// --
// output
// --

function _outcomeReporting( outcome )
{
  var testRoutineDescriptor = this;

  if( !testRoutineDescriptor._caseIndex )
  testRoutineDescriptor._caseIndex = 1;
  else
  testRoutineDescriptor._caseIndex += 1;

  if( outcome )
  {
    testRoutineDescriptor.suite.currentRoutinePasses += 1;
    testRoutineDescriptor.suite.report.testCasePasses += 1;
  }
  else
  {
    testRoutineDescriptor.suite.currentRoutineFails += 1;
    testRoutineDescriptor.suite.report.testCaseFails += 1;
  }

  _.assert( arguments.length === 1 );

}

//

function _outcomeReport( o )
{
  var testRoutineDescriptor = this;

  _.routineOptions( _outcomeReport,o );
  _.assert( arguments.length === 1 );

  testRoutineDescriptor.logger.begin({ 'case' : testRoutineDescriptor.description || testRoutineDescriptor._caseIndex });
  testRoutineDescriptor.logger.begin({ 'caseIndex' : testRoutineDescriptor._caseIndex });

  testRoutineDescriptor._outcomeReporting( o.outcome );

  if( o.outcome )
  {

    if( testRoutineDescriptor.verbosity )
    {

      testRoutineDescriptor.logger.up();
      if( o.details )
      testRoutineDescriptor.logger.begin( 'details' ).log( o.details ).end( 'details' );

      o.msg = _.strColor.style( o.msg,'good' );

      testRoutineDescriptor.logger.begin( 'message' ).logDown( o.msg ).end( 'message' );
      testRoutineDescriptor.logger.log();

    }

  }
  else
  {

    var code;
    if( testRoutineDescriptor.usingSourceCode && o.usingSourceCode )
    {
      var _location = o.stack ? _.diagnosticLocation({ stack : o.stack }) : _.diagnosticLocation({ level : 3 });
      var _code = _.diagnosticCode({ location : _location });
      if( _code )
      code = '\n' + _location.full + '\n' + _code;
      else
      code = '\n' + _location.full;
    }

    testRoutineDescriptor.logger.logUp();
    if( o.details )
    testRoutineDescriptor.logger.begin( 'details' ).error( o.details ).end( 'details' );

    if( code )
    testRoutineDescriptor.logger.begin( 'source' ).error( code ).end( 'source' );

    o.msg = _.strColor.style( o.msg,'bad' )

    testRoutineDescriptor.logger.begin( 'message' ).errorDown( o.msg ).end( 'message' );
    testRoutineDescriptor.logger.log();

  }

  testRoutineDescriptor.logger.end( 'case','caseIndex' );

}

_outcomeReport.defaults =
{
  outcome : null,
  msg : null,
  details : null,
  stack : null,
  usingSourceCode : 1,
}

//

function outcomeReportSpecial( outcome,msg,stack )
{
  var testRoutineDescriptor = this;

  _.assert( arguments.length === 2 || arguments.length === 3 );

  msg = testRoutineDescriptor._currentTestCaseTextGet( outcome,msg );

  testRoutineDescriptor._outcomeReport
  ({
    outcome : outcome,
    msg : msg,
    details : '',
    stack : stack,
  });

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

    testRoutineDescriptor._outcomeReport
    ({
      outcome : outcome,
      msg : msg,
      details : details,
    });

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

    testRoutineDescriptor._outcomeReport
    ({
      outcome : outcome,
      msg : msg,
      details : details,
    });

    debugger;
  }

}

//

function exceptionReport( o )
{
  var suite = this;

  _.routineOptions( exceptionReport,o );
  _.assert( arguments.length === 1 );

  if( o.testRoutineDescriptor.onError )
  o.testRoutineDescriptor.onError.call( suite,o.testRoutineDescriptor );

  var msg =
  [
    o.testRoutineDescriptor._currentTestCaseTextGet() +
    ' ... failed throwing error'
  ];

  var err = _.err( o.err );
  var details = err.toString();

  o.testRoutineDescriptor._outcomeReport
  ({
    outcome : 0,
    msg : msg,
    details : details,
    stack : o.stack,
    usingSourceCode : o.usingSourceCode
  });

  // testRoutineDescriptor._outcomeReport( 0,msg,details );

}

exceptionReport.defaults =
{
  err : null,
  testRoutineDescriptor : null,
  stack : null,
  usingSourceCode : 1,
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
    'Test routine ( ' + testRoutineDescriptor.routine.name + ' ) : ' +
    'test case' + ( testRoutineDescriptor.description ? ( ' ( ' + testRoutineDescriptor.description + ' )' ) : '' ) +
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

  sourceFilePath : null,
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
  currentRoutineFails : null,
  currentRoutinePasses : null,
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
