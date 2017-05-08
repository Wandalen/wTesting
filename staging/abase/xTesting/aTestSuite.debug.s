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

var logger = null;
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
  {
    o = arguments[ 0 ] = o || {};
    if( !o.sourceFilePath )
    o.sourceFilePath = _.diagnosticLocation( 1 ).full + '';
    return new( _.routineJoin( Self, Self, arguments ) );
  }

  o = arguments[ 0 ] = o || {};
  if( !o.sourceFilePath )
  o.sourceFilePath = _.diagnosticLocation( 1 ).full + '';

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

  // if( !suite.sourceFilePath )
  // suite.sourceFilePath = _.diagnosticLocation( 4 ).full;

  if( !( o instanceof Self ) )
  if( !_.strIsNotEmpty( suite.name ) )
  suite.name = _.diagnosticLocation( suite.sourceFilePath ).nameLong;

  if( !_.strIs( suite.sourceFilePath ) )
  {
    debugger;
    throw _.err( 'Test suite',suite.name,'expects a mandatory option ( sourceFilePath )' );
  }

  if( !( o instanceof Self ) )
  if( !_.strIsNotEmpty( suite.name ) )
  {
    debugger;
    throw _.err( 'Test suite expects name, but got',suite.name );
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

    if( src.context )
    _.mapSupplement( src.context,suite.context );

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

//

// function _verbositySet( src )
// {
//   var suite = this;
//
//   _.assert( arguments.length === 1 );
//
//   if( !_.numberIsNotNan( src ) )
//   src = 0;
//
//   suite[ symbolForVerbosity ] = src;
//
//   if( src !== null )
//   if( suite.logger )
//   suite.logger.verbosity = src;
//
// }

// --
// test suite run
// --

function _testSuiteRunLater()
{
  var suite = this;

  _.assert( suite instanceof Self );
  _.assert( arguments.length === 0 );

  /* */

  if( suite.override )
  _.mapExtend( suite,suite.override );

  // console.log( 'suite.override',suite.override );
  var concurrent = suite.concurrent !== null ? suite.concurrent : _.Testing.concurrent;
  var con = concurrent ? new wConsequence().give() : wTestSuite._suiteCon;
  // console.log( 'concurrent',concurrent );

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

  if( suite.override )
  _.mapExtend( suite,suite.override );

  // console.log( 'suite.override',suite.override );
  var concurrent = suite.concurrent !== null ? suite.concurrent : _.Testing.concurrent;
  var con = concurrent ? new wConsequence().give() : wTestSuite._suiteCon;
  // console.log( 'concurrent',concurrent );

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
  var logger = suite.logger || _.Testing.logger || _global_.logger;

  _.assert( suite instanceof Self );
  _.assert( arguments.length === 0 );

  /* */

  function handleStage( testRoutine,iteration,iterator )
  {
    return suite._testRoutineRun( iteration.key,testRoutine );
  }

  /* */

  function handleEnd( err,data )
  {
    if( err )
    {
      debugger;
      logger.log( _.err( 'Something very wrong, cant even launch the test suite\n',err ) );
      suite._outcome( 0 );
    }

    _.assert( _.Testing.sanitareTime >= 0 );
    return _.timeOut( _.Testing.sanitareTime/2, _.routineSeal( suite,suite._testSuiteEnd,[] ) );
  }

  /* */

  return _.execStages( tests,
  {
    manual : 1,
    onEachRoutine : handleStage,
    onBegin : _.routineJoin( suite,suite._testSuiteBegin ),
    onEnd : handleEnd,
  });

}

//

function _testSuiteBegin()
{
  var suite = this;
  if( suite.debug )
  debugger;

  if( !_.Testing._canContinue() )
  return;

  /* logger */

  if( !suite.logger )
  suite.logger = _.Testing.logger || _global_.logger;
  if( suite.override && suite.override.logger )
  suite.logger = suite.override.logger;

  if( _.Testing.verbosity !== null )
  suite.verbosity = _.Testing.verbosity-1;
  else
  suite.verbosity = suite.verbosity;

  if( _.Testing.importanceOfNegative !== null )
  suite.importanceOfNegative = _.Testing.importanceOfNegative;

  if( _.Testing.verbosityOfDetails !== null )
  suite.verbosityOfDetails = _.Testing.verbosityOfDetails;

  if( suite.override )
  _.mapExtend( suite,suite.override );

  var logger = suite.logger;

  /* report */

  suite.report = null;
  suite.reportNew();

  /* */

  logger.verbosityPush( suite.verbosity );
  logger.begin({ verbosity : -2 });

  var msg =
  [
    'Testing of test suite ( ' + suite.name + ' ) ..',
  ];

  logger.begin({ 'suite' : suite.name });

  logger.logUp( msg.join( '\n' ) );

  logger.log( _.strColor.style( 'at  ' + suite.sourceFilePath,'selected' ) );

  logger.end( 'suite' );

  logger.mine( 'suite.content' ).log( '' );

  logger.end({ verbosity : -2 });

  logger.begin({ verbosity : -6 });
  logger.log( _.toStr( suite ) );
  logger.end({ verbosity : -6 });

  logger.begin({ verbosity : suite.verbosityOfDetails });

  /* */

  _.assert( _.Testing.activeSuites.indexOf( suite ) === -1 );
  _.Testing.activeSuites.push( suite );

  if( suite.onSuiteBegin )
  suite.onSuiteBegin.call( suite.context,suite );

}

//

function _testSuiteEnd()
{
  var suite = this;
  var logger = suite.logger;

  if( suite.onSuiteEnd )
  suite.onSuiteEnd.call( suite.context,suite );

  /* */

  logger.begin({ verbosity : -2 });

  if( logger._mines[ 'suite.content' ] )
  logger.mineFinit( 'suite.content' );
  else
  logger.log();

  /* */

  var ok = suite.report.testCaseFails === 0;

  if( logger )
  logger.begin({ 'connotation' : ok ? 'positive' : 'negative' });
  if( logger )
  logger.begin( 'suite','end' );

  var msg = '';
  msg += 'Passed test cases ' + ( suite.report.testCasePasses ) + ' / ' + ( suite.report.testCasePasses + suite.report.testCaseFails ) + '\n';
  msg += 'Passed test routines ' + ( suite.report.testRoutinePasses ) + ' / ' + ( suite.report.testRoutinePasses + suite.report.testRoutineFails ) + '';

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
  logger.end({ verbosity : suite.verbosityOfDetails });
  logger.verbosityPop();

  /* */

  if( suite.takingIntoAccount )
  {

    _.Testing.report.testSuitePasses += ok ? 1 : 0;
    _.Testing.report.testSuiteFailes += ok ? 0 : 1;

    _.Testing.report.testRoutinePasses += suite.report.testRoutinePasses;
    _.Testing.report.testRoutineFails += suite.report.testRoutineFails;

    // _.Testing.report.testCasePasses += suite.report.testCasePasses;
    // _.Testing.report.testCaseFails += suite.report.testCaseFails;

  }

  _.assert( _.Testing.activeSuites.indexOf( suite ) !== -1 );
  _.arrayRemoveOnce( _.Testing.activeSuites,suite );

  if( suite.debug )
  debugger;

  return suite;
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
// test routine run
// --

function _testRoutineRun( name,testRoutine )
{
  var suite = this;
  var result = null;
  var report = suite.report;

  /* */

  if( ( !_.Testing.routine || !suite.takingIntoAccount ) && testRoutine.experimental )
  return;

  if( suite.takingIntoAccount )
  if( _.Testing.routine && _.Testing.routine !== testRoutine.name )
  return;

  if( !_.Testing._canContinue() )
  return;

  /* */

  var testRoutineDescriptor = wTestRoutine({ name : name, routine : testRoutine, suite : suite });

  _.assert( arguments.length === 2 );

  return suite._routineCon
  .doThen( function()
  {

    suite._testRoutineBegin( testRoutineDescriptor );

    /* */

    try
    {
      result = testRoutineDescriptor.routine.call( suite.context,testRoutineDescriptor );
    }
    catch( err )
    {
      result = new wConsequence().error( _.err( err ) );
    }

    /* */

    var timeOut = testRoutine.timeOut || testRoutineDescriptor.testRoutineTimeOut || _.Testing.testRoutineTimeOut;

    result = testRoutineDescriptor._returnCon = wConsequence.from( result );

    // result.got( function( err,data ){ console.log( _.strTypeOf( err ) ); this.give( err,data ); } );

    result.andThen( suite._inroutineCon );

    // result.got( function( err,data ){ console.log( _.strTypeOf( err ) ); this.give( err,data ); } );

    // debugger;
    result = result.eitherThenSplit([ _.timeOutError( timeOut ),testRoutineDescriptor._cancelCon ]);
    // debugger;
    result.doThen( _.routineJoin( testRoutineDescriptor,_testRoutineHandleReturn ) );

    return result;
  })
  .split();

}

//

function _testRoutineHandleReturn( err,msg )
{
  var testRoutineDescriptor = this;
  var suite = testRoutineDescriptor.suite;

  if( err )
  if( err.timeOut )
  err = _._err
  ({
    args : [ 'Test routine ( ' + testRoutineDescriptor.routine.name + ' ) time out!' ],
    usingSourceCode : 0,
  });

  if( err )
  {
    testRoutineDescriptor.exceptionReport
    ({
      err : err,
      testRoutineDescriptor : testRoutineDescriptor,
      usingSourceCode : 0,
      // usingSourceCode : data !== _.timeOut,
    });
  }
  else
  {
    if( testRoutineDescriptor._currentRoutinePasses === 0 && testRoutineDescriptor._currentRoutineFails === 0 )
    testRoutineDescriptor._outcomeReportBoolean
    ({
      outcome : 0,
      msg : 'test routine has passed none test case',
      usingSourceCode : 0,
      usingDescription : 0,
    });
    else
    testRoutineDescriptor._outcomeReportBoolean
    ({
      outcome : 1,
      msg : 'test routine has not thrown an error',
      usingSourceCode : 0,
      usingDescription : 0,
    });
  }

  suite._testRoutineEnd( testRoutineDescriptor,!testRoutineDescriptor._currentRoutineFails );

}

//

function _testRoutineBegin( testRoutineDescriptor )
{
  var suite = this;

  var msg =
  [
    'Running test routine ( ' + testRoutineDescriptor.routine.name + ' ) ..'
  ];

  suite.logger.begin({ verbosity : -4 });

  suite.logger.begin({ 'routine' : testRoutineDescriptor.routine.name });
  suite.logger.logUp( msg.join( '\n' ) );
  suite.logger.end( 'routine' );

  suite.logger.end({ verbosity : -4 });

  _.assert( !suite.currentRoutine );
  suite.currentRoutine = testRoutineDescriptor;

  // testRoutineDescriptor._currentRoutineFails = 0;
  // testRoutineDescriptor._currentRoutinePasses = 0;

  if( testRoutineDescriptor.eventGive )
  testRoutineDescriptor.eventGive({ kind : 'routineBegin', testRoutine : testRoutineDescriptor });

}

//

function _testRoutineEnd( testRoutineDescriptor,ok )
{
  var suite = this;

  _.assert( _.strIsNotEmpty( testRoutineDescriptor.routine.name ),'test routine should have name' );
  _.assert( suite.currentRoutine === testRoutineDescriptor );

  if( testRoutineDescriptor.eventGive )
  testRoutineDescriptor.eventGive({ kind : 'routineEnd', testRoutine : testRoutineDescriptor });

  if( testRoutineDescriptor._currentRoutineFails )
  suite.report.testRoutineFails += 1;
  else
  suite.report.testRoutinePasses += 1;

  suite.logger.begin( 'routine','end' );
  suite.logger.begin({ 'connotation' : ok ? 'positive' : 'negative' });

  suite.logger.begin({ verbosity : -3 });

  if( ok )
  {

    suite.logger.logDown( 'Passed test routine ( ' + testRoutineDescriptor.routine.name + ' ).' );

  }
  else
  {

    suite.logger.begin({ verbosity : -3+suite.importanceOfNegative });
    suite.logger.logDown( 'Failed test routine ( ' + testRoutineDescriptor.routine.name + ' ).' );
    suite.logger.end({ verbosity : -3+suite.importanceOfNegative });

  }

  suite.logger.end({ 'connotation' : ok ? 'positive' : 'negative' });
  suite.logger.end( 'routine','end' );

  suite.logger.end({ verbosity : -3 });

  suite.currentRoutine = null;

}

// --
// store
// --

function caseCurrent()
{
  var suite = this;
  var result = Object.create( null );

  _.assert( arguments.length === 0 );

  result.description = suite.description;
  result._caseIndex = suite._caseIndex;

  return result;
}

//

function caseNext( description )
{
  var suite = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !suite._caseIndex )
  suite._caseIndex = 1;
  else
  suite._caseIndex += 1;

  if( description !== undefined )
  suite.description = description;

  return suite.caseCurrent();
}

//

function caseStore()
{
  var suite = this;
  var result = suite.caseCurrent();

  _.assert( arguments.length === 0 );

  suite._casesStack.push( result );

  return result;
}

//

function caseRestore( acase )
{
  var suite = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( acase )
  {
    suite.caseStore();
  }
  else
  {
    _.assert( _.arrayIs( suite._casesStack ) && suite._casesStack.length, 'caseRestore : no stored case in stack' );
    acase = suite._casesStack.pop();
  }

  suite.description = acase.description;
  suite._caseIndex = acase._caseIndex;

  return suite;
}

// --
// equalizer
// --

function shouldBe( outcome )
{
  var testRoutineDescriptor = this;

  _.assert( _.boolLike( outcome ),'shouldBe expects single bool argument' );
  _.assert( arguments.length === 1,'shouldBe expects single bool argument' );

  if( !outcome )
  debugger;

  testRoutineDescriptor._outcomeReportBoolean
  ({
    outcome : outcome,
    msg : 'expected true',
  });

  return outcome;
}

//

function shouldBeNotError( maybeErrror )
{
  var testRoutineDescriptor = this;

  _.assert( arguments.length === 1,'shouldBeNotError expects single argument' );

  testRoutineDescriptor._outcomeReportBoolean({ outcome : !_.errIs( maybeErrror ), msg : 'expected variable is not error' });

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

  testRoutineDescriptor._outcomeReportCompare( outcome,got,expected,options.lastPath );

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

  testRoutineDescriptor._outcomeReportCompare( outcome,got,expected,optionsForEntity.lastPath );

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

  testRoutineDescriptor._outcomeReportCompare( outcome,got,expected,options.lastPath );

  return outcome;
}

//

function _shouldDo( o )
{
  var suite = this;
  var thrown = 0;
  var second = 0;
  var reported = 0;
  var good = 1;
  var stack = _.diagnosticStack( 2,-1 );
  var logger = suite.logger;
  var err,arg;

  // if( o.expectingSyncError || o.expectingAsyncError )
  // o.ignoringError = 1;

  _.routineOptions( _shouldDo,o );
  // _.assert( _.routineIs( o.routine ) );
  _.assert( arguments.length === 1 );

  var acase = suite.caseCurrent();
  var con = suite._inroutineCon.got().split();
  // con.got();

  // console.log( 'acase',acase );

  /* */

  function begin( positive )
  {
    debugger;
    if( positive )
    _.assert( !reported );
    reported = 1;
    good = positive;
    suite.caseRestore( acase );
    logger.begin({ verbosity : positive ? -5 : -5+suite.importanceOfNegative });
    logger.begin({ connotation : positive ? 'positive' : 'negative' });
  }

  function end( positive )
  {
    logger.end({ verbosity : positive ? -5 : -5+suite.importanceOfNegative  });
    logger.end({ connotation : positive ? 'positive' : 'negative' });
    suite.caseRestore();
  }

  /* */

  if( !_.routineIs( o.routine ) )
  {
    begin( 0 );
    suite._outcomeReportBoolean
    ({
      outcome : 0,
      msg : 'expects Routine or Consequence, but got ' + _.strTypeOf( o.routine ),
      stack : stack,
    });
    end( 0 );

    debugger;
    _.assert( !( o.routine instanceof wConsequence ) )
    suite._inroutineCon.give();
    con.give();
    // return con.split();
    return con;
  }

  /* */

  var result;
  if( o.routine instanceof wConsequence )
  {
    result = o.routine;
  }
  else try
  {
    var result = o.routine.call( this );
  }
  catch( err )
  {

    if( o.ignoringError )
    {
      begin( 1 );
      suite._outcomeReportBoolean
      ({
        outcome : 1,
        msg : 'error throwen synchronously, ignored',
        stack : stack,
      });
      end( 1 );
      debugger;
      con.give( null,err );
      suite._inroutineCon.give();
      throw err;
    }

    begin( o.expectingSyncError );

    logger.begin({ verbosity : -6+( o.expectingSyncError ? 0 : suite.importanceOfNegative ) });

    if( !_.errIsAttended( err ) )
    logger.log( _.errAttend( err ) );
    thrown = 1;

    logger.end({ verbosity : -6+( o.expectingSyncError ? 0 : suite.importanceOfNegative ) });

    if( o.expectingSyncError )
    suite._outcomeReportBoolean
    ({
      outcome : o.expectingSyncError,
      msg : 'error thrown synchronously as expected',
      stack : stack,
    });
    else
    suite._outcomeReportBoolean
    ({
      outcome : o.expectingSyncError,
      msg : 'error thrown synchronously, something wrong',
      stack : stack,
    });

    end( o.expectingSyncError );
  }

  if( !o.expectingAsyncError && o.expectingSyncError && !thrown )
  {
    begin( 0 );

    suite._outcomeReportBoolean
    ({
      outcome : 0,
      msg : 'error not thrown synchronously, but expected',
      stack : stack,
    });

    end( 0 );
  }

  /* */

  if( result instanceof wConsequence )
  {

    result.got( function( _err,_arg )
    {
      err = _err;
      arg = _arg;

      if( !o.ignoringError && !reported )
      if( err )
      {
        begin( o.expectingAsyncError );

        logger.begin({ verbosity : -6+( o.expectingAsyncError ? 0 : suite.importanceOfNegative ) });

        if( !_.errIsAttended( err ) )
        logger.log( _.errAttend( err ) );
        thrown = 1;

        logger.end({ verbosity : -6+( o.expectingAsyncError ? 0 : suite.importanceOfNegative ) });

        if( o.expectingAsyncError )
        suite._outcomeReportBoolean
        ({
          outcome : o.expectingAsyncError,
          msg : 'error thrown asynchronously as expected',
          stack : stack,
        });
        else
        suite._outcomeReportBoolean
        ({
          outcome : o.expectingAsyncError,
          msg : 'error thrown asynchronously, not expected',
          stack : stack,
        });

        end( o.expectingAsyncError );
      }
      else if( o.expectingAsyncError )
      {
        begin( !o.expectingAsyncError );

        if( !o.expectingAsyncError )
        suite._outcomeReportBoolean
        ({
          outcome : !o.expectingAsyncError,
          msg : 'error was not thrown asynchronously as expected',
          stack : stack,
        });
        else
        suite._outcomeReportBoolean
        ({
          outcome : !o.expectingAsyncError,
          msg : 'error was not thrown asynchronously, but expected',
          stack : stack,
        });

        end( !o.expectingAsyncError );
      }

      /* */

      if( !o.allowingMultipleMessages )
      _.timeOut( 10,function()
      {
        if( second || reported )
        {
          debugger;
          con.give( err,arg );
          suite._inroutineCon.give();
          return;
        }

        begin( 1 );

        suite._outcomeReportBoolean
        ({
          outcome : 1,
          msg : 'looks like got only one message as expected',
          stack : stack,
        });

        end( 1 );

        con.give( err,arg );
        suite._inroutineCon.give();
      });

    });

    /* */

    if( !o.allowingMultipleMessages )
    result.doThen( function( err,data )
    {
      if( reported && !good )
      return;

      begin( 0 );

      second = 1;

      suite._outcomeReportBoolean
      ({
        outcome : 0,
        msg : 'message got several times, something wrong',
        stack : stack,
      });

      end( 0 );
    });

  }
  else
  {

    if( o.expectingAsyncError && !thrown )
    {
      begin( 0 );

      var msg = 'error not thrown' + ( o.expectingSyncError ? '' : ' asynchronously' ) + ', but expected';

      suite._outcomeReportBoolean
      ({
        outcome : 0,
        msg : msg,
        stack : stack,
      });

      end( 0 );
    }
    else if( !o.expectingSyncError && !thrown )
    {
      begin( 1 );

      suite._outcomeReportBoolean
      ({
        outcome : 1,
        msg : 'no error thrown, as expected',
        stack : stack,
      });

      end( 1 );
    }
    else if( o.expectingAsyncError && o.expectingSyncError && !thrown )
    {
      begin( 0 );

      suite._outcomeReportBoolean
      ({
        outcome : 0,
        msg : 'error not thrown, but expected either synchronosuly or asynchronously',
        stack : stack,
      });

      end( 0 );
    }

    con.give( err,arg );
    suite._inroutineCon.give();
  }

  /* */

  suite.caseNext();

  return con;
  // return con.split();
}

_shouldDo.defaults =
{
  routine : null,
  expectingSyncError : 1,
  expectingAsyncError : 1,
  ignoringError : 0,
  allowingMultipleMessages : 0,
}

//

function shouldThrowErrorAsync( routine )
{
  var suite = this;

  return suite._shouldDo
  ({
    routine : routine,
    expectingSyncError : 0,
    expectingAsyncError : 1,
  });

}

//

function shouldThrowErrorSync( routine )
{
  var suite = this;

  return suite._shouldDo
  ({
    routine : routine,
    expectingSyncError : 1,
    expectingAsyncError : 0,
  });

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
 *  test.description = 'shouldThrowErrorSync';
 *  test.shouldThrowErrorSync( function()
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
 *    test.description = 'shouldThrowErrorSync';
 *    var con = new wConsequence( )
 *    .error( _.err() ); //wConsequence instance with error message
 *    return test.shouldThrowErrorSync( con );//test passes
 *  })
 *  .ifNoErrorThen( function()
 *  {
 *    test.description = 'shouldThrowError2';
 *    var con = new wConsequence( )
 *    .error( _.err() )
 *    .error( _.err() ); //wConsequence instance with two error messages
 *    return test.shouldThrowErrorSync( con ); //test fails
 *  });
 *
 *  return consequence;
 * }
 * _.Testing.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @throws {Exception} If passed argument is not a Routine.
 * @method shouldThrowErrorSync
 * @memberof wTools
 */

function shouldThrowError( routine )
{
  var suite = this;

  return suite._shouldDo
  ({
    routine : routine,
    expectingSyncError : 1,
    expectingAsyncError : 1,
  });

}

//

function mustNotThrowError( routine )
{
  var suite = this;

  return suite._shouldDo
  ({
    routine : routine,
    ignoringError : 0,
    expectingSyncError : 0,
    expectingAsyncError : 0,
  });

}

//

function shouldMessageOnlyOnce( routine )
{
  var suite = this;

  return suite._shouldDo
  ({
    routine : routine,
    ignoringError : 1,
    expectingSyncError : 0,
    expectingAsyncError : 0,
  });

}

// --
// output
// --

function _outcome( outcome )
{

  _.assert( arguments.length === 1 );

  if( this.constructor === wTestRoutine )
  {
    var testRoutineDescriptor = this;

    _.assert( testRoutineDescriptor.takingIntoAccount !== undefined );

    if( outcome )
    {
      testRoutineDescriptor._currentRoutinePasses += 1;
      testRoutineDescriptor.suite.report.testCasePasses += 1;
      if( testRoutineDescriptor.takingIntoAccount )
      _.Testing.report.testCasePasses += 1;
    }
    else
    {
      testRoutineDescriptor._currentRoutineFails += 1;
      testRoutineDescriptor.suite.report.testCaseFails += 1;
      if( testRoutineDescriptor.takingIntoAccount )
      _.Testing.report.testCaseFails += 1;
    }

    testRoutineDescriptor.caseNext();

  }
  else
  {
    var suite = this;

    _.assert( suite.takingIntoAccount !== undefined );

    if( outcome )
    {
      if( suite.takingIntoAccount )
      _.Testing.report.testCasePasses += 1;
      if( suite.report )
      suite.report.testCasePasses += 1;
    }
    else
    {
      if( suite.takingIntoAccount )
      _.Testing.report.testCaseFails += 1;
      if( suite.report )
      suite.report.testCaseFails += 1;
    }

  }

}

//

function _outcomeReporting( outcome )
{
  var testRoutineDescriptor = this;

  testRoutineDescriptor._outcome( outcome );

  if( !_.Testing._canContinue() )
  {
    testRoutineDescriptor._returnCon.cancel();
    testRoutineDescriptor._cancelCon.error( _.err( 'Too many fails',_.Testing.fails, '<=', testRoutineDescriptor._currentRoutineFails ) );
  }

  _.assert( arguments.length === 1 );

}

//

function _outcomeReport( o )
{
  var testRoutineDescriptor = this;
  var logger = testRoutineDescriptor.logger;
  var sourceCode = '';

  _.routineOptions( _outcomeReport,o );
  _.assert( arguments.length === 1 );

  /* */

  function sourceCodeGet()
  {
    var code;
    if( testRoutineDescriptor.usingSourceCode && o.usingSourceCode )
    {
      var _location = o.stack ? _.diagnosticLocation({ stack : o.stack }) : _.diagnosticLocation({ level : 4 });
      var _code = _.diagnosticCode
      ({
        location : _location,
        selectMode : 'end',
        numberOfLines : 5,
      });
      if( _code )
      code = '\n' + _location.full + '\n' + _code;
      else
      code = '\n' + _location.full;
    }

    if( code )
    code = '#trackingColor : 0#' + code + '#trackingColor : 1#';

    return code;
  }

  /* */

  logger.begin({ verbosity : -4 });
  logger.begin({ 'case' : testRoutineDescriptor.description || testRoutineDescriptor._caseIndex });
  logger.begin({ 'caseIndex' : testRoutineDescriptor._caseIndex });

  testRoutineDescriptor._outcomeReporting( o.outcome );

  // debugger;
  if( o.outcome )
  {
    logger.begin({ verbosity : -4 });
    logger.up();
    logger.begin({ 'connotation' : 'positive' });

    logger.begin({ verbosity : -6 });

    if( o.details )
    logger.begin( 'details' ).log( o.details ).end( 'details' );

    sourceCode = sourceCodeGet();
    if( sourceCode )
    logger.begin( 'sourceCode' ).log( sourceCode ).end( 'sourceCode' );

    logger.end({ verbosity : -6 });

    logger.begin( 'message' ).logDown( o.msg ).end( 'message' );

    logger.end({ 'connotation' : 'positive' });
    if( logger.verbosityReserve() > 1 )
    logger.log();

    logger.end({ verbosity : -4 });
  }
  else
  {

    sourceCode = sourceCodeGet();

    logger.begin({ verbosity : -4+testRoutineDescriptor.importanceOfNegative });

    logger.up();
    if( logger.verbosityReserve() > 1 )
    logger.log();
    logger.begin({ 'connotation' : 'negative' });

    logger.begin({ verbosity : -6+testRoutineDescriptor.importanceOfNegative });

    if( o.details )
    logger.begin( 'details' ).log( o.details ).end( 'details' );

    if( sourceCode )
    logger.begin( 'sourceCode' ).log( sourceCode ).end( 'sourceCode' );

    logger.end({ verbosity : -6+testRoutineDescriptor.importanceOfNegative });

    logger.begin( 'message' ).logDown( o.msg ).end( 'message' );

    logger.end({ 'connotation' : 'negative' });
    if( logger.verbosityReserve() > 1 )
    logger.log();

    logger.end({ verbosity : -4+testRoutineDescriptor.importanceOfNegative });

    debugger;
  }

  logger.end( 'case','caseIndex' );
  logger.end({ verbosity : -4 });

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

function _outcomeReportBoolean( o )
{
  var testRoutineDescriptor = this;

  _.assert( arguments.length === 1 );
  _.routineOptions( _outcomeReportBoolean,o );

  o.msg = testRoutineDescriptor._currentTestCaseTextMake( o.outcome,o.msg,o.usingDescription );

  testRoutineDescriptor._outcomeReport
  ({
    outcome : o.outcome,
    msg : o.msg,
    details : '',
    stack : o.stack,
    usingSourceCode : o.usingSourceCode,
  });

}

_outcomeReportBoolean.defaults =
{
  outcome : null,
  msg : null,
  stack : null,
  usingSourceCode : 1,
  usingDescription : 1,
}

//

function _outcomeReportCompare( outcome,got,expected,path )
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
    var msg = testRoutineDescriptor._currentTestCaseTextMake( 1 );

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

    if( !_.atomicIs( got ) && !_.atomicIs( expected ) && path )
    details +=
    (
      '\nat : ' + path +
      '\ngot :\n' + _.toStr( _.entitySelect( got,path ) ) +
      '\nexpected :\n' + _.toStr( _.entitySelect( expected,path ) ) +
      ''
    );

    if( _.strIs( expected ) && _.strIs( got ) )
    details += '\ndifference :\n' + _.strDifference( expected,got );

    var msg = testRoutineDescriptor._currentTestCaseTextMake( 0 );

    testRoutineDescriptor._outcomeReport
    ({
      outcome : outcome,
      msg : msg,
      details : details,
    });

    // debugger;
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

  var msg = o.testRoutineDescriptor._currentTestCaseTextMake() + ' ... failed throwing error';
  if( o.sync !== null )
  msg += ( o.sync ? 'synchronously' : 'asynchronously' );
  var err = _.errAttend( o.err );
  var details = err.toString();

  o.testRoutineDescriptor._outcomeReport
  ({
    outcome : 0,
    msg : msg,
    details : details,
    stack : o.stack,
    usingSourceCode : o.usingSourceCode
  });

}

exceptionReport.defaults =
{
  err : null,
  testRoutineDescriptor : null,
  stack : null,
  usingSourceCode : 1,
  sync : null,
}

//

function _currentTestCaseTextMake( value,hint,usingDescription )
{
  var testRoutineDescriptor = this;

  if( usingDescription === undefined )
  usingDescription = 1;

  _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );
  _.assert( value === undefined || _.boolLike( value ) );
  _.assert( hint === undefined || _.strIs( hint ) );
  _.assert( testRoutineDescriptor._testRoutineDescriptorIs );
  _.assert( testRoutineDescriptor._caseIndex >= 0 );
  _.assert( _.strIsNotEmpty( testRoutineDescriptor.routine.name ),'test routine descriptor should have name' );

  var name = testRoutineDescriptor.routine.name;

  if( testRoutineDescriptor.description && usingDescription )
  name += ' : ' + testRoutineDescriptor.description;

  var result = '' +
    'Test case' + ' ( ' + name + ' )' +
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
// var
// --

var symbolForVerbosity = Symbol.for( 'verbosity' );

// --
// relationships
// --

var Composes =
{

  sourceFilePath : null,
  tests : null,

  verbosity : 2,
  importanceOfNegative : 0,
  verbosityOfDetails : -6,
  barringConsole : null,

  abstract : 0,
  enabled : 1,
  takingIntoAccount : 1,
  usingSourceCode : 1,

  eps : 1e-5,
  report : null,

  concurrent : null,
  testRoutineTimeOut : null,
  debug : 0,

  override : Object.create( null ),
  _casesStack : [],

  _routineCon : new wConsequence().give(),
  _inroutineCon : new wConsequence().give(),

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
  name : null,
  currentRoutine : null,
  // currentRoutineFails : null,
  // currentRoutinePasses : null,
}

var Statics =
{
  usingUniqueNames : 1,
  _suiteCon : new wConsequence().give(),
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
  // _verbositySet : _verbositySet,


  // test suite run

  run : _testSuiteRunNow,
  _testSuiteRunLater : _testSuiteRunLater,
  _testSuiteRunNow : _testSuiteRunNow,
  _testSuiteRunAct : _testSuiteRunAct,
  _testSuiteBegin : _testSuiteBegin,
  _testSuiteEnd : _testSuiteEnd,

  onSuiteBegin : onSuiteBegin,
  onSuiteEnd : onSuiteEnd,


  // test routine run

  _testRoutineRun : _testRoutineRun,
  _testRoutineBegin : _testRoutineBegin,
  _testRoutineEnd : _testRoutineEnd,


  // case

  caseCurrent : caseCurrent,
  caseNext : caseNext,
  caseStore : caseStore,
  caseRestore : caseRestore,


  // equalizer

  shouldBe : shouldBe,
  shouldBeNotError : shouldBeNotError,
  identical : identical,
  equivalent : equivalent,
  contain : contain,

  _shouldDo : _shouldDo,

  shouldThrowErrorSync : shouldThrowErrorSync,
  shouldThrowErrorAsync : shouldThrowErrorAsync,
  shouldThrowError : shouldThrowError,
  mustNotThrowError : mustNotThrowError,
  shouldMessageOnlyOnce : shouldMessageOnlyOnce,


  // output

  _outcome : _outcome,
  _outcomeReporting : _outcomeReporting,
  _outcomeReport : _outcomeReport,

  _outcomeReportBoolean : _outcomeReportBoolean,
  _outcomeReportCompare : _outcomeReportCompare,

  exceptionReport : exceptionReport,

  _currentTestCaseTextMake : _currentTestCaseTextMake,


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
if( _.EventHandler )
_.EventHandler.mixin( Self );

//

// _.accessor
// ({
//   object : Self.prototype,
//   prime : 1,
//   names : { verbosity : verbosity },
// });

//

_.accessorForbid( Self.prototype,
{
  safe : 'safe',
  options : 'options',
  special : 'special',
  currentRoutineFails : 'currentRoutineFails',
  currentRoutinePasses : 'currentRoutinePasses',
});

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;

return Self;

})();
