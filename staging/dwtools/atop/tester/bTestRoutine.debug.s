(function _bTestRoutine_debug_s_() {

'use strict';

//

let _global = _global_;
let _ = _global_.wTools;
let debugged = _.processIsDebugged();
let Parent = null;
let Self = function wTestRoutineDescriptor( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'TestRoutineDescriptor';

//

function init( o )
{
  let trd = this;

  trd[ accuracyEffectiveSymbol ] = null;

  _.instanceInit( trd );

  Object.preventExtensions( trd );

  if( o )
  trd.copy( o );

  trd._adoptRoutineFields();
  trd._accuracyChange();
  trd._returnCon = null;

  trd._reportForm();

  _.assert( _.routineIs( trd.routine ) );
  _.assert( _.strDefined( trd.routine.name ),'Test routine should have name, ' + trd.name + ' test routine of test suite',trd.suite.name,'does not have name' );
  _.assert( Object.isPrototypeOf.call( _.TestSuite.prototype,trd.suite ) );
  _.assert( Object.isPrototypeOf.call( Self.prototype,trd ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  let proxy =
  {
    get : function( obj, k )
    {
      if( obj[ k ] !== undefined )
      return obj[ k ];
      return obj.suite[ k ];
    }
  }

  trd = new Proxy( trd, proxy );

  return trd;
}

//

function refine()
{
  let trd = this;
  let routine = trd.routine;

  let preStr = 'Test routine ' + _.strQuote( trd.nameFull );

  _.sureMapHasOnly
  (
    routine,
    _.Tester.TestRoutineDescriptor.KnownFields,
    [ preStr, 'has unknown fields :' ]
  );

  _.sure( routine.experimental === undefined || _.boolLike( routine.experimental ), preStr, 'expects bool like in field {-experimental-} if defined' );
  _.sure( routine.timeOut === undefined || _.numberIs( routine.timeOut ), preStr, 'expects number in field {-timeOut-} if defined' );
  _.sure( routine.routineTimeOut === undefined || _.numberIs( routine.routineTimeOut ), preStr, 'expects number in field {-routineTimeOut-} if defined' );
  _.sure( routine.accuracy === undefined || _.numberIs( routine.accuracy ) || _.rangeIs( routine.accuracy ), preStr, 'expects number or range in field {-accuracy-} if defined' );
  _.sure( routine.rapidity === undefined || _.numberIs( routine.rapidity ), preStr, 'expects number in field {-rapidity-} if defined' );

}

// --
// run
// --

function _testRoutineBegin()
{
  let trd = this;
  let suite = trd.suite;

  if( _.Tester )
  trd._testRoutineBeginTime = _.timeNow();

  _.arrayAppendOnceStrictly( _.Tester.activeRoutines, trd );

  suite._hasConsoleInOutputs = suite.logger.hasOutput( console,{ deep : 0, withoutOutputToOriginal : 0 } );

  _.assert( arguments.length === 0 );
  _.assert( trd._returned === null );

  let msg =
  [
    'Running test routine ( ' + trd.routine.name + ' ) ..'
  ];

  suite.logger.begin({ verbosity : -4 });

  suite.logger.begin({ 'routine' : trd.routine.name });
  suite.logger.logUp( msg.join( '\n' ) );
  suite.logger.end( 'routine' );

  suite.logger.end({ verbosity : -4 });

  _.assert( !suite.currentRoutine );
  suite.currentRoutine = trd;

  try
  {
    suite.onRoutineBegin.call( trd.context,trd );
    if( trd.eventGive )
    trd.eventGive({ kind : 'routineBegin', testRoutine : trd, context : trd.context });
  }
  catch( err )
  {
    trd.exceptionReport({ err : err });
  }

}

//

function _testRoutineEnd()
{
  let trd = this;
  let suite = trd.suite;
  let ok = trd._reportIsPositive();

  _.assert( arguments.length === 0 );
  _.assert( _.strDefined( trd.routine.name ),'test routine should have name' );
  _.assert( suite.currentRoutine === trd );

  let _hasConsoleInOutputs = suite.logger.hasOutput( console,{ deep : 0, withoutOutputToOriginal : 0 } );
  if( suite._hasConsoleInOutputs !== _hasConsoleInOutputs )
  {
    debugger; /* xxx */
    let wasBarred = suite.consoleBar( 0 );

    // let barOptions = _.Tester._barOptions;
    // let exclusiveOutputPrinter = barOptions.exclusiveOutputPrinter;
    //
    // barOptions.exclusiveOutputPrinter = 0;
    // suite.logger.consoleBar( barOptions );
    //
    // if( exclusiveOutputPrinter )
    // {
    //   barOptions.exclusiveOutputPrinter = exclusiveOutputPrinter;
    //   suite.logger.consoleBar( barOptions );
    // }

    let err = _.err( 'Console is missing in logger`s outputs, probably logger was modified' + '\n at' + trd.nameFull );
    suite.exceptionReport
    ({
      err : err,
    });

    suite.consoleBar( wasBarred );

  }

  /* groups stack */

  trd.testCaseCloseIfExplicitly();

  if( trd._testsGroupsStack.length && !trd._testsGroupError )
  {
    debugger;
    let err = trd.exceptionReport
    ({
      err : _.err( 'Tests group', _.strQuote( trd.testsGroup ), 'was not closed' ),
      usingSourceCode : 0,
    });
  }

  /* on end */

  try
  {
    suite.onRoutineEnd.call( trd.context, trd, ok );
    if( trd.eventGive )
    trd.eventGive({ kind : 'routineEnd', testRoutine : trd, context : trd.context });
  }
  catch( err )
  {
    trd.exceptionReport({ err : err });
  }

  /* */

  suite._testRoutineConsider( ok );

  suite.currentRoutine = null;

  /* */

  suite.logger.begin( 'routine','end' );
  suite.logger.begin({ 'connotation' : ok ? 'positive' : 'negative' });

  suite.logger.begin({ verbosity : -3 });

  let timingStr = '';
  if( _.Tester )
  {
    trd.report.timeSpent = _.timeNow() - trd._testRoutineBeginTime;
    timingStr = ' in ' + _.timeSpentFormat( trd.report.timeSpent );
  }

  let str = ( ok ? 'Passed' : 'Failed' ) + ' test routine ( ' + trd.nameFull + ' )' + timingStr;

  str = _.Tester.textColor( str, ok );

  if( !ok )
  suite.logger.begin({ verbosity : -3+suite.importanceOfNegative });

  suite.logger.logDown( str );

  if( !ok )
  suite.logger.end({ verbosity : -3+suite.importanceOfNegative });

  suite.logger.end({ 'connotation' : ok ? 'positive' : 'negative' });
  suite.logger.end( 'routine','end' );

  suite.logger.end({ verbosity : -3 });

  _.arrayRemoveOnceStrictly( _.Tester.activeRoutines, trd ); /* xxx */

}

//

function _testRoutineHandleReturn( err,msg )
{
  let trd = this;
  let suite = trd.suite;

  if( err )
  if( err.timeOut )
  err = trd._timeOutError();

  trd._returned = [ err, msg ];

  trd.will = '';

  if( err )
  {
    trd.exceptionReport
    ({
      err : err,
    });
  }
  else
  {
    if( trd.report.testCheckPasses === 0 && trd.report.testCheckFails === 0 )
    trd._outcomeReportBoolean
    ({
      outcome : 0,
      msg : 'test routine has passed none test check',
      usingSourceCode : 0,
      usingDescription : 0,
    });
    else
    trd._outcomeReportBoolean
    ({
      outcome : 1,
      msg : 'test routine has not thrown an error',
      usingSourceCode : 0,
      usingDescription : 0,
    });
  }

}

//

function _interruptMaybe( throwing )
{
  let trd = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( trd._returned )
  return false;

  if( _.Tester._canceled )
  return true;

  if( !_.Tester._canContinue() )
  {
    debugger; /* xxx */
    // if( trd._returnCon )
    // trd._returnCon.cancel();
    let result = _.Tester.cancel({ global : 0 });
    if( throwing )
    throw result;
    return result;
  }

  let elapsed = _.timeNow() - trd._testRoutineBeginTime;
  if( elapsed > trd.timeOut && !debugged )
  {
    let result = _.Tester.cancel({ err : trd._timeOutError(), global : 0 });
    if( throwing )
    throw result;
    return result;
  }

  return false;
}

//

function _ableGet()
{
  let trd = this;
  let suite = trd.suite;

  _.assert( _.numberIs( _.Tester.settings.rapidity ) );

  if( suite.routine )
  return suite.routine === trd.name;

  // if( ( !suite.routine || !suite.takingIntoAccount ) && trd.experimental )
  if( trd.experimental )
  return false;

  // if( suite.takingIntoAccount )
  // if( suite.routine && suite.routine !== trd.name )
  // return false;

  if( trd.rapidity < _.Tester.settings.rapidity )
  return false;

  return true;
}

//

function _timeOutError()
{
  let trd = this;

  debugger;

  let err = _._err
  ({
    args : [ 'Test routine ' + _.strQuote( trd.nameFull ) + ' timed out. TimeOut : ' + trd.timeOut + 'ms' ],
    usingSourceCode : 0,
  });

  Object.defineProperty( err, 'timeOut',
  {
    enumerable : false,
    configurable : false,
    writable : false,
    value : 1,
  });

  return err;
}

// --
// tests groups
// --

function _willGet()
{
  let trd = this;
  return trd[ willSymbol ];
}

//

function _willSet( src )
{
  let trd = this;
  trd._interruptMaybe( 1 );
  trd[ willSymbol ] = src
}

//

function _descriptionFullGet()
{
  let trd = this;
  let result = '';
  let right = ' > ';
  let left = ' < ';

  // if( trd._testsGroupOpenedExplicitly )
  // {
    result = trd._testsGroupsStack.slice( 0, trd._testsGroupsStack.length-1 ).join( right );
    if( result )
    result += right + trd.case
    else
    result += trd.case
    if( trd.will )
    result += left;
  // }
  // else
  // {
  //   result = trd._testsGroupsStack.join( right );
  //   if( trd.will )
  //   result += left;
  // }

  if( trd.will )
  result += trd.will;

  return result;
}

//

function _descriptionWithNameGet()
{
  let trd = this;
  let description = trd.descriptionFull;
  let name = trd.nameFull;
  let slash = ' / ';
  return name + slash + description
}

//

function _caseGet()
{
  let trd = this;
  return trd.testsGroup;
  // if( trd._testsGroupOpenedExplicitly )
  // return trd.testsGroup;
  // else
  // return '';
}

//

function _caseSet( src )
{
  let trd = this;

  _.assert( arguments.length === 1 );
  // _.assert( !trd._testsGroupOpenedExplicitly || trd.testsGroup );
  _.assert( src === null || _.strIs( src ), 'expects string or null {-src-}, but got', _.strTypeOf( src ) );

  // trd.testCaseCloseIfExplicitly();
  trd._testsGroupChange();

  if( src !== null )
  {
    trd.testsGroupOpen( src );
    trd._testsGroupOpenedExplicitly = 1;
  }

}

//

function _testsGroupGet()
{
  let trd = this;
  _.assert( arguments.length === 0, 'expects no arguments' );
  return trd._testsGroupsStack[ trd._testsGroupsStack.length-1 ] || '';
}

//

function testsGroupOpen( groupName )
{
  let trd = this;
  _.assert( arguments.length === 1, 'expects single argument' );

  trd._testsGroupChange();

  trd._testsGroupsStack.push( groupName );

  trd._testsGroupIsCase = 1;
  trd.report.testCheckPassesOfTestCase = 0;
  trd.report.testCheckFailsOfTestCase = 0;

}

//

function testsGroupClose( groupName )
{
  let trd = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  if( trd.testsGroup !== groupName )
  trd.testCaseCloseIfExplicitly();

  if( trd.testsGroup !== groupName )
  {
    let err = _._err
    ({
      args : [ 'Attempt to close not the topmost tests group', _.strQuote( groupName ), 'current tests group is', _.strQuote( trd.testsGroup ) ],
      level : 2,
    });
    err = trd.exceptionReport
    ({
      err : err,
    });
    trd._testsGroupError = err;
  }
  else
  {
    trd._testsGroupsStack.splice( trd._testsGroupsStack.length-1, 1 );
  }

  if( trd._testsGroupIsCase )
  {
    if( trd.report.testCheckFailsOfTestCase > 0 || trd.report.testCheckPassesOfTestCase > 0 )
    trd._testCaseConsider( !trd.report.testCheckFailsOfTestCase );
  }

  trd._testsGroupIsCase = 0;
  trd._testsGroupChange();

  return trd.testsGroup;
}

//

function _testsGroupChange()
{
  let trd = this;
  _.assert( arguments.length === 0, 'expects no arguments' );

  trd.will = '';
  trd.testCaseCloseIfExplicitly();
  trd._interruptMaybe( 1 );

}

//

function testCaseCloseIfExplicitly()
{
  let trd = this;
  let report = trd.report;

  // trd.will = '';

  if( trd._testsGroupOpenedExplicitly )
  {
    trd._testsGroupOpenedExplicitly = 0;
    _.assert( _.strIs( trd.testsGroup ) );
    trd.testsGroupClose( trd.testsGroup );
    // trd._testCaseConsider( !report.testCheckFailsOfTestCase ); // xxx
  }

}

//

function hasTestGroupExceptOfCase()
{
  let trd = this;
  if( trd._testsGroupsStack.length === 0 )
  return false;
  if( trd._testsGroupOpenedExplicitly && trd._testsGroupsStack.length === 1 )
  return false;
  return true;
}

//

function _nameFullGet()
{
  let trd = this;
  let slash = ' / ';
  return trd.suite.name + slash + trd.name;
}

//
// function testCaseCloseIfExplicitly()
// {
//   let trd = this;
//   let report = trd.report;
//
//   trd._testCaseConsider( !report.testCheckFailsOfTestCase );
//
// }
//
//

// --
// store
// --

function checkCurrent()
{
  let trd = this;
  let result = Object.create( null );

  _.assert( arguments.length === 0 );

  result.testsGroupsStack = trd._testsGroupsStack;
  result.will = trd.will;
  result.checkIndex = trd._checkIndex;

  return result;
}

//

function checkNext( will )
{
  let trd = this;

  _.assert( trd instanceof Self );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !trd._checkIndex )
  trd._checkIndex = 1;
  else
  trd._checkIndex += 1;

  if( will !== undefined )
  trd.will = will;

  return trd.checkCurrent();
}

//

function checkStore()
{
  let trd = this;
  let result = trd.checkCurrent();

  _.assert( arguments.length === 0 );
  // _.assert( !trd.hasTestGroupExceptOfCase(), trd._testsGroupsStack.length, trd._testsGroupOpenedExplicitly );

  trd._checksStack.push( result );

  return result;
}

//

function checkRestore( acheck )
{
  let trd = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( acheck )
  {
    trd.checkStore();
    if( acheck === trd._checksStack[ trd._checksStack.length-1 ] )
    {
      debugger;
      xxx
      trd._checksStack.pop();
    }
  }
  else
  {
    _.assert( _.arrayIs( trd._checksStack ) && trd._checksStack.length, 'checkRestore : no stored check in stack' );
    acheck = trd._checksStack.pop();
  }

  trd._checkIndex = acheck.checkIndex;
  trd._testsGroupsStack = acheck.testsGroupsStack;
  trd.will = acheck.will;

  return trd;
}

// --
// equalizer
// --

function is( outcome )
{
  let trd = this;

  if( !_.boolLike( outcome ) || arguments.length !== 1 )
  {

    outcome = false;

    trd.exceptionReport
    ({
      err : '"is" expects single bool argument',
      level : 2,
    });

  }
  else
  {
    outcome = !!outcome;
    trd._outcomeReportBoolean
    ({
      outcome : outcome,
      msg : 'expected true',
    });
  }

  return outcome;
}

//

function isNot( outcome )
{
  let trd = this;

  if( !_.boolLike( outcome ) || arguments.length !== 1 )
  {

    outcome = false;

    trd.exceptionReport
    ({
      err : '"isNot" expects single bool argument',
      level : 2,
    });

  }
  else
  {
    outcome = !outcome;
    trd._outcomeReportBoolean
    ({
      outcome : outcome,
      msg : 'expected false',
    });
  }

  return outcome;
}

//

function isNotError( maybeError )
{
  let trd = this;
  let outcome = !_.errIs( maybeError );

  if( arguments.length !== 1 )
  {

    outcome = false;

    trd.exceptionReport
    ({
      err : '"isNotError" expects single argument',
      level : 2,
    });

  }
  else
  {
    trd._outcomeReportBoolean
    ({
      outcome : outcome,
      msg : 'expected variable is not error',
    });
  }

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
 *  test.case = 'single zero';
 *  let got = 0;
 *  let expected = 0;
 *  test.identical( got, expected );//returns true
 *
 *  test.case = 'single number';
 *  let got = 2;
 *  let expected = 1;
 *  test.identical( got, expected );//returns false
 * }
 *
 * _.Tester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method identical
 * @memberof wTestRoutineDescriptor
 */

function identical( got,expected )
{
  let trd = this;
  let iterator, outcome;

  /* */

  try
  {
    iterator = Object.create( null );
    outcome = _.entityIdentical( got,expected,iterator );
  }
  catch( err )
  {
    trd.exceptionReport
    ({
      err : err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : '"identical" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  if( !iterator.iterator || iterator.iterator.lastPath === undefined )
  {
    outcome = false;
    trd.exceptionReport
    ({
      err : 'something wrong with entityIdentical, iterator misses lastPath',
      level : 2,
    });
    return outcome;
  }

  /* */

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : expected,
    path : iterator.iterator.lastPath,
    usingExtraDetails : 1,
  });

  /* */

  return outcome;
}

//

function notIdentical( got,expected )
{
  let trd = this;
  let iterator, outcome;

  /* */

  try
  {
    iterator = Object.create( null );
    outcome = !_.entityIdentical( got,expected,iterator );
  }
  catch( err )
  {
    trd.exceptionReport
    ({
      err : err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : '"notIdentical" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  if( !iterator.iterator || iterator.iterator.lastPath === undefined )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : 'something wrong with entityIdentical, iterator misses lastPath',
      level : 2,
    });

    return outcome;
  }

  /* */

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : expected,
    path : iterator.iterator.lastPath,
    usingExtraDetails : 0,
  });

  return outcome;
}

//

/**
 * Checks if test passes a specified condition by deep soft comparsing result of code execution( got )
 * with target( expected ). Uses recursive comparsion for objects,arrays and array-like objects. Two entities are equivalent if
 * difference between their values are less or equal to( accuracy ). Example: ( got - expected ) <= ( accuracy ).
 * If entity( got ) is equivalent to entity( expected ) test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {*} got - Source entity.
 * @param {*} expected - Target entity.
 * @param {*} [ accuracy=1e-7 ] - Maximal distance between two values.
 *
 * @example
 * function sometest( test )
 * {
 *  test.case = 'single number';
 *  let got = 0.5;
 *  let expected = 1;
 *  let accuracy = 0.5;
 *  test.equivalent( got, expected, accuracy );//returns true
 *
 *  test.case = 'single number';
 *  let got = 0.5;
 *  let expected = 2;
 *  let accuracy = 0.5;
 *  test.equivalent( got, expected, accuracy );//returns false
 * }
 * _.Tester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method equivalent
 * @memberof wTestRoutineDescriptor
 */

function equivalent( got, expected, options )
{
  let trd = this;
  let accuracy = trd.accuracyEffective;
  let iterator, outcome;

  /* */

  try
  {
    iterator = Object.create( null );
    iterator.accuracy = accuracy;
    if( _.mapIs( options ) )
    _.mapExtend( iterator, options )
    else if( _.numberIs( options ) )
    iterator.accuracy = options;
    else _.assert( options === undefined );
    accuracy = iterator.accuracy;
    outcome = _.entityEquivalent( got, expected, iterator );
  }
  catch( err )
  {
    trd.exceptionReport
    ({
      err : err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 && arguments.length !== 3 )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : '"equivalent" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  if( !iterator.iterator || iterator.iterator.lastPath === undefined )
  {
    outcome = false;
    trd.exceptionReport
    ({
      err : 'something wrong with entityIdentical, iterator misses lastPath',
      level : 2,
    });
    return outcome;
  }

  /* */

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : expected,
    path : iterator.iterator.lastPath,
    usingExtraDetails : 1,
    accuracy : accuracy,
  });

  return outcome;
}

//

function notEquivalent( got, expected, options )
{
  let trd = this;
  let accuracy = trd.accuracyEffective;
  let iterator, outcome;

  /* */

  try
  {
    iterator = Object.create( null );
    iterator.accuracy = accuracy;
    if( _.mapIs( options ) )
    _.mapExtend( iterator, options )
    else if( _.numberIs( options ) )
    iterator.accuracy = options;
    else _.assert( options === undefined );
    accuracy = iterator.accuracy;
    outcome = !_.entityEquivalent( got, expected, iterator );
  }
  catch( err )
  {
    trd.exceptionReport
    ({
      err : err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 && arguments.length !== 3 )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : '"notEquivalent" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  if( !iterator.iterator || iterator.iterator.lastPath === undefined )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : 'something wrong with entityIdentical, iterator misses lastPath',
      level : 2,
    });

    return outcome;
  }

  /* */

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : expected,
    path : iterator.iterator.lastPath,
    usingExtraDetails : 1,
    accuracy : accuracy,
  });

  return outcome;
}


//

/**
 * Checks if test passes a specified condition by deep contains comparsing result of code execution( got )
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
 *  test.case = 'array';
 *  let got = [ 0, 1, 2 ];
 *  let expected = [ 0 ];
 *  test.contains( got, expected );//returns true
 *
 *  test.case = 'array';
 *  let got = [ 0, 1, 2 ];
 *  let expected = [ 4 ];
 *  test.contains( got, expected );//returns false
 * }
 * _.Tester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method contains
 * @memberof wTestRoutineDescriptor
 */

function contains( got,expected )
{
  let trd = this;
  let iterator, outcome;

  /* */

  try
  {
    iterator = Object.create( null );
    outcome = _.entityContains( got, expected, iterator );
  }
  catch( err )
  {
    trd.exceptionReport
    ({
      err : err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : '"contains" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  if( !iterator.iterator || iterator.iterator.lastPath === undefined )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : 'something wrong with entityIdentical, iterator misses lastPath',
      level : 2,
    });

    return outcome;
  }

  /* */

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : expected,
    path : iterator.iterator.lastPath,
    usingExtraDetails : 1,
  });

  /* */

  return outcome;
}

//

function gt( got, than )
{
  let trd = this;
  let outcome = got > than;
  let diff = got - than;

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : '"gt" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : than,
    nameOfPositiveExpected : 'greater than',
    nameOfNegativeExpected : 'not greater than',
    diff : diff,
    usingExtraDetails : 1,
  });

  return outcome;
}

//

function ge( got, than )
{
  let trd = this;
  let greater = got > than;
  let outcome = got >= than;
  let diff = got - than;

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : '"ge" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : than,
    nameOfPositiveExpected : greater ? 'greater than' : 'identical with',
    nameOfNegativeExpected : 'not greater neither identical with',
    diff : diff,
    usingExtraDetails : 1,
  });

  /* */

  return outcome;
}

//

function lt( got, than )
{
  let trd = this;
  let outcome = got < than;
  let diff = got - than;

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : '"lt" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : than,
    nameOfPositiveExpected : 'less than',
    nameOfNegativeExpected : 'not less than',
    diff : diff,
    usingExtraDetails : 1,
  });

  /* */

  return outcome;
}

//

function le( got, than )
{
  let trd = this;
  let less = got < than;
  let outcome = got <= than;
  let diff = got - than;

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : '"le" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : than,
    nameOfPositiveExpected : less ? 'less than' : 'identical with',
    nameOfNegativeExpected : 'not less neither identical with',
    diff : diff,
    usingExtraDetails : 1,
  });

  /* */

  return outcome;
}

//

function _shouldDo( o )
{
  let trd = this;
  let second = 0;
  let reported = 0;
  let good = 1;
  let async = 0;
  let stack = _.diagnosticStack( 2,-1 );
  let logger = trd.logger;
  let err, arg;
  let con = new _.Consequence();

  if( !trd.shoulding )
  return con.give();

  try
  {
    _.routineOptions( _shouldDo,o );
    _.assert( arguments.length === 1, 'expects single argument' );
    _.assert( o.args.length === 1 );
    _.assert( _.routineIs( o.args[ 0 ] ) );
  }
  catch( err )
  {
    err = _.errRestack( err, 3 );
    err = _._err
    ({
      args : [ 'Illegal usage of should in', trd.nameFull, '\n', err ],
    });
    err = trd.exceptionReport
    ({
      err : err,
    });
    debugger;
    con.error( err );
    if( !o.ignoringError && !o.expectingAsyncError && o.expectingSyncError )
    return false;
    else
    return con;
  }

  o.routine = o.args[ 0 ];
  let acheck = trd.checkCurrent();
  trd._inroutineCon.choke();

  /* */

  let result;
  if( _.consequenceIs( o.routine ) )
  {
    result = o.routine;
  }
  else try
  {
    result = o.routine.call( this );
  }
  catch( _err )
  {
    return handleError( _err );
  }

  /* no sync error, but expected */

  if( !o.ignoringError && !o.expectingAsyncError && o.expectingSyncError && !err )
  return handleLackOfSyncError();

  /* */

  if( _.consequenceIs( result ) )
  handleAsyncResult()
  else
  handleSyncResult();

  /* */

  return con;

  /* */

  function handleError( _err )
  {

    err = _err;

    if( o.ignoringError )
    {
      begin( 1 );
      trd._outcomeReportBoolean
      ({
        outcome : 1,
        msg : 'error throwen synchronously, ignored',
        stack : stack,
        selectMode : 'begin'
      });
      end( 1, err );
      return con;
    }

    trd.exceptionReport
    ({
      err : err,
      sync : 1,
      considering : 0,
      outcome : o.expectingSyncError,
    });

    if( !o.ignoringError )
    {

      begin( o.expectingSyncError );

      if( o.expectingSyncError )
      {

        trd._outcomeReportBoolean
        ({
          outcome : o.expectingSyncError,
          msg : 'error thrown synchronously as expected',
          stack : stack,
          selectMode : 'begin'
        });

      }
      else
      {

        trd._outcomeReportBoolean
        ({
          outcome : o.expectingSyncError,
          msg : 'error thrown synchronously, what was not expected',
          stack : stack,
          selectMode : 'begin'
        });

      }

      end( o.expectingSyncError,err );

      if( !o.ignoringError && !o.expectingAsyncError && o.expectingSyncError )
      return err;
      else
      return con;
    }

  }

  /* */

  function handleLackOfSyncError()
  {
    begin( 0 );

    let msg = 'error not thrown synchronously, but expected';

    trd._outcomeReportBoolean
    ({
      outcome : 0,
      msg : msg,
      stack : stack,
      selectMode : 'begin'
    });

    end( 0,_.err( msg ) );

    return false;
  }

  /* */

  function handleAsyncResult()
  {

    trd.checkNext();
    async = 1;

    result.got( function( _err,_arg )
    {

      err = _err;
      arg = _arg;

      if( !o.ignoringError && !reported )
      if( err && !o.expectingAsyncError )
      reportAsync();
      else if( !err && o.expectingAsyncError )
      reportAsync();

      /* */

      if( !reported )
      if( !o.allowingMultipleMessages )
      _.timeOut( 10,function()
      {

        if( result.resourcesGet().length )
        if( reported )
        {
          _.assert( !good );
        }
        else
        {

          begin( 0 );
          debugger;

          _.assert( !reported );

          trd._outcomeReportBoolean
          ({
            outcome : 0,
            msg : 'got more than one message',
            stack : stack,
          });

          end( 0,_.err( msg ) );
        }

        if( !reported )
        reportAsync();

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
      let msg = 'got more than one message';

      trd._outcomeReportBoolean
      ({
        outcome : 0,
        msg : msg,
        stack : stack,
      });

      end( 0,_.err( msg ) );
    });

  }

  /* */

  function handleSyncResult()
  {

    if( ( o.expectingAsyncError || o.expectingSyncError ) && !err )
    {
      begin( 0 );

      let msg = 'error not thrown asynchronously, but expected';
      if( o.expectingAsyncError )
      msg = 'error not thrown, but expected either synchronosuly or asynchronously';

      trd._outcomeReportBoolean
      ({
        outcome : 0,
        msg : msg,
        stack : stack,
        selectMode : 'begin'
      });

      end( 0,_.err( msg ) );
    }
    else if( !o.expectingSyncError && !err )
    {
      begin( 1 );

      trd._outcomeReportBoolean
      ({
        outcome : 1,
        msg : 'no error thrown, as expected',
        stack : stack,
        selectMode : 'begin'
      });

      end( 1,result );
    }
    else
    {
      debugger;
      _.assert( 0,'unexpected' );
      trd.checkNext();
    }

  }

  /* */

  function begin( positive )
  {
    if( positive )
    _.assert( !reported );
    good = positive;

    if( reported || async )
    trd.checkRestore( acheck );

    logger.begin({ verbosity : positive ? -5 : -5+trd.importanceOfNegative });
    logger.begin({ connotation : positive ? 'positive' : 'negative' });
  }

  /* */

  function end( positive, arg )
  {
    _.assert( arguments.length === 2, 'expects exactly two arguments' );

    logger.end({ verbosity : positive ? -5 : -5+trd.importanceOfNegative });
    logger.end({ connotation : positive ? 'positive' : 'negative' });

    if( reported )
    debugger;
    if( reported || async )
    trd.checkRestore();

    if( positive )
    con.give( undefined,arg );
    else
    con.give( arg,undefined );

    trd._inroutineCon.give();

    reported = 1;
  }

  /* */

  function reportAsync()
  {

    if( reported )
    return;

    if( o.ignoringError )
    {
      begin( 1 );

      trd._outcomeReportBoolean
      ({
        outcome : 1,
        msg : 'got single message',
        stack : stack,
        selectMode : 'begin'
      });

      end( 1, err ? err : arg );
    }
    else if( err )
    {
      begin( o.expectingAsyncError );

      trd.exceptionReport
      ({
        err : err,
        sync : 0,
        considering : 0,
        outcome : o.expectingAsyncError,
      });

      if( o.expectingAsyncError )
      trd._outcomeReportBoolean
      ({
        outcome : o.expectingAsyncError,
        msg : 'error thrown asynchronously as expected',
        stack : stack,
        selectMode : 'begin'
      });
      else
      trd._outcomeReportBoolean
      ({
        outcome : o.expectingAsyncError,
        msg : 'error thrown asynchronously, not expected',
        stack : stack,
        selectMode : 'begin'
      });

      end( o.expectingAsyncError, err );
    }
    else
    {
      begin( !o.expectingAsyncError );

      let msg = 'error was not thrown asynchronously, but expected';
      if( o.expectingAsyncError )
      debugger;
      if( o.expectingAsyncError )
      msg = 'error was thrown asynchronously as expected';
      else if( !o.expectingAsyncError && !o.expectingSyncError && good )
      msg = 'error was not thrown as expected';

      trd._outcomeReportBoolean
      ({
        outcome : !o.expectingAsyncError,
        msg : msg,
        stack : stack,
        selectMode : 'begin'
      });

      if( o.expectingAsyncError )
      end( !o.expectingAsyncError,_.err( msg ) );
      else
      end( !o.expectingAsyncError,arg );

    }

  }

}

_shouldDo.defaults =
{
  args : null,
  expectingSyncError : 1,
  expectingAsyncError : 1,
  ignoringError : 0,
  allowingMultipleMessages : 0,
}

//

function shouldThrowErrorAsync( routine )
{
  let trd = this;

  return trd._shouldDo
  ({
    args : arguments,
    expectingSyncError : 0,
    expectingAsyncError : 1,
  });

}

//

function shouldThrowErrorSync( routine )
{
  let trd = this;

  return trd._shouldDo
  ({
    args : arguments,
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
 *  test.case = 'shouldThrowErrorSync';
 *  test.shouldThrowErrorSync( function()
 *  {
 *    throw _.err( 'Error' );
 *  });
 * }
 * _.Tester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @example
 * function sometest( test )
 * {
 *  let consequence = new _.Consequence().give();
 *  consequence
 *  .ifNoErrorThen( function()
 *  {
 *    test.case = 'shouldThrowErrorSync';
 *    let con = new wConsequence( )
 *    .error( _.err() ); //wConsequence instance with error message
 *    return test.shouldThrowErrorSync( con );//test passes
 *  })
 *  .ifNoErrorThen( function()
 *  {
 *    test.case = 'shouldThrowError2';
 *    let con = new wConsequence( )
 *    .error( _.err() )
 *    .error( _.err() ); //wConsequence instance with two error messages
 *    return test.shouldThrowErrorSync( con ); //test fails
 *  });
 *
 *  return consequence;
 * }
 * _.Tester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @throws {Exception} If passed argument is not a Routine.
 * @method shouldThrowErrorSync
 * @memberof wTestRoutineDescriptor
 */

function shouldThrowError( routine )
{
  let trd = this;

  return trd._shouldDo
  ({
    args : arguments,
    expectingSyncError : 1,
    expectingAsyncError : 1,
  });

}

//

function mustNotThrowError( routine )
{
  let trd = this;

  return trd._shouldDo
  ({
    args : arguments,
    ignoringError : 0,
    expectingSyncError : 0,
    expectingAsyncError : 0,
  });

}

//

function shouldMessageOnlyOnce( routine )
{
  let trd = this;

  return trd._shouldDo
  ({
    args : arguments,
    ignoringError : 1,
    expectingSyncError : 0,
    expectingAsyncError : 0,
  });

}

// --
// consider
// --

function _testCheckConsider( outcome )
{
  let trd = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( trd.constructor === Self );

  if( outcome )
  {
    trd.report.testCheckPasses += 1;
    trd.report.testCheckPassesOfTestCase += 1;
  }
  else
  {
    trd.report.testCheckFails += 1;
    trd.report.testCheckFailsOfTestCase += 1;
  }

  trd.suite._testCheckConsider( outcome );

  trd.checkNext();

}

//

function _testCaseConsider( outcome )
{
  let trd = this;
  let report = trd.report;

  if( outcome )
  report.testCasePasses += 1;
  else
  report.testCaseFails += 1;

  trd.suite._testCaseConsider( outcome );
}

//

function _exceptionConsider( err )
{
  let trd = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( trd.constructor === Self );

  trd.report.errorsArray.push( err );
  trd.suite._exceptionConsider( err );

}

// --
// report
// --

function _outcomeReport( o )
{
  let trd = this;
  let logger = trd.logger;
  let sourceCode = '';

  _.routineOptions( _outcomeReport,o );
  _.assert( arguments.length === 1, 'expects single argument' );

  if( o.considering )
  trd._testCheckConsider( o.outcome );

  /* */

  let verbosity = o.outcome ? 0 : trd.importanceOfNegative;
  sourceCode = sourceCodeGet();

  /* */

  logger.begin({ verbosity : o.verbosity });

  if( o.considering )
  {
    logger.begin({ 'check' : trd.description || trd._checkIndex });
    logger.begin({ 'checkIndex' : trd._checkIndex });
  }

  logger.begin({ verbosity : o.verbosity+verbosity });

  logger.up();
  if( logger.verbosityReserve() > 1 )
  logger.log();
  logger.begin({ 'connotation' : o.outcome ? 'positive' : 'negative' });

  logger.begin({ verbosity : o.verbosity-1+verbosity });

  if( o.details )
  logger.begin( 'details' ).log( o.details ).end( 'details' );

  if( sourceCode )
  logger.begin( 'sourceCode' ).log( sourceCode ).end( 'sourceCode' );

  logger.end({ verbosity : o.verbosity-1+verbosity });

  logger.begin( 'message' ).logDown( o.msg ).end( 'message' );

  logger.end({ 'connotation' : o.outcome ? 'positive' : 'negative' });
  if( logger.verbosityReserve() > 1 )
  logger.log();

  logger.end({ verbosity : o.verbosity+verbosity });

  if( o.considering )
  logger.end( 'check','checkIndex' );
  logger.end({ verbosity : o.verbosity });

  trd._interruptMaybe( 1 );

  /* */

  function sourceCodeGet()
  {
    let code;
    if( trd.usingSourceCode && o.usingSourceCode )
    {
      let _location = o.stack ? _.diagnosticLocation({ stack : o.stack }) : _.diagnosticLocation({ level : 4 });
      let _code = _.diagnosticCode
      ({
        location : _location,
        selectMode : o.selectMode,
        numberOfLines : 5,
      });
      if( _code )
      code = '\n' + _code;
      else
      code = '\n' + _location.full;
    }

    if( code )
    code = ' #inputRaw : 1# ' + code + ' #inputRaw : 0# ';

    return code;
  }

}

_outcomeReport.defaults =
{
  outcome : null,
  msg : null,
  details : null,
  stack : null,
  usingSourceCode : 1,
  selectMode : 'end',
  considering : 1,
  verbosity : -4,
}

//

function _outcomeReportBoolean( o )
{
  let trd = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( _outcomeReportBoolean,o );

  o.msg = trd._reportTextForTestCheck
  ({
    outcome : o.outcome,
    msg : o.msg,
    usingDescription : o.usingDescription,
  });

  trd._outcomeReport
  ({
    outcome : o.outcome,
    msg : o.msg,
    details : '',
    stack : o.stack,
    usingSourceCode : o.usingSourceCode,
    selectMode : o.selectMode
  });

}

_outcomeReportBoolean.defaults =
{
  outcome : null,
  msg : null,
  stack : null,
  usingSourceCode : 1,
  usingDescription : 1,
  selectMode : 'end'
}

//

function _outcomeReportCompare( o )
{
  let trd = this;

  _.assert( trd instanceof Self );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptionsPreservingUndefines( _outcomeReportCompare, o );

  let nameOfExpected = ( o.outcome ? o.nameOfPositiveExpected : o.nameOfNegativeExpected );
  let details = '';

  /**/

  if( !o.outcome )
  if( o.usingExtraDetails )
  {
    details += _.entityDiffExplanation
    ({
      name1 : '- got',
      name2 : '- expected',
      srcs : [ o.got, o.expected ],
      path : o.path,
      accuracy : o.accuracy,
    });
  }

  let msg = trd._reportTextForTestCheck({ outcome : o.outcome });

  trd._outcomeReport
  ({
    outcome : o.outcome,
    msg : msg,
    details : details,
  });

  if( !o.outcome )
  if( trd.debug )
  debugger;

  /**/

  function msgExpectedGot()
  {
    return '' +
    'got :\n' + _.toStr( o.got,{ stringWrapper : '\'' } ) + '\n' +
    nameOfExpected + ' :\n' + _.toStr( o.expected,{ stringWrapper : '\'' } ) +
    '';
  }

}

_outcomeReportCompare.defaults =
{
  got : null,
  expected : null,
  diff : null,
  nameOfPositiveExpected : 'expected',
  nameOfNegativeExpected : 'expected',
  outcome : null,
  path : null,
  usingExtraDetails : 1,
  accuracy : null,
}

//

function exceptionReport( o )
{
  let trd = this;

  _.routineOptions( exceptionReport,o );
  _.assert( arguments.length === 1, 'expects single argument' );

  if( trd.onError )
  debugger;
  try
  {
    if( trd.onError )
    trd.onError.call( trd,o );
  }
  catch( err2 )
  {
    logger.log( err2 );
  }

  let msg = null;
  if( o.considering )
  {
    msg = trd._reportTextForTestCheck({ outcome : null }) + ' ... failed throwing error';
  }
  else
  {
    msg = 'Error throwen'
  }

  if( o.sync !== null )
  msg += ( o.sync ? ' synchronously' : ' asynchronously' );

  let err = _._err({ args : [ o.err ], level : _.numberIs( o.level ) ? o.level+1 : o.level });
  _.errAttend( err );
  let details = err.toString();

  o.stack = o.stack === null ? o.err.stack : o.stack;

  if( o.considering )
  trd._exceptionConsider( err );

  trd._outcomeReport
  ({
    outcome : o.outcome,
    msg : msg,
    details : details,
    stack : o.stack,
    usingSourceCode : o.usingSourceCode,
    considering : o.considering,
  });

  return err;
}

exceptionReport.defaults =
{
  err : null,
  level : null,
  stack : null,
  usingSourceCode : 0,
  considering : 1,
  outcome : 0,
  sync : null,
}

//

function _reportForm()
{
  let trd = this;

  _.assert( !trd.report, 'test routine already has report' );

  let report = trd.report = Object.create( null );

  report.timeSpent = null;
  report.errorsArray = [];

  report.testCheckPasses = 0;
  report.testCheckFails = 0;

  report.testCheckPassesOfTestCase = 0;
  report.testCheckFailsOfTestCase = 0;

  report.testCasePasses = 0;
  report.testCaseFails = 0;

  Object.preventExtensions( report );

}

//

function _reportIsPositive()
{
  let trd = this;

  if( trd.report.testCheckFails !== 0 )
  return false;

  if( !( trd.report.testCheckPasses > 0 ) )
  return false;

  if( trd.report.errorsArray.length )
  return false;

  return true;
}

//

function _reportTextForTestCheck( o )
{
  let trd = this;

  o = _.routineOptions( _reportTextForTestCheck,o );

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( o.outcome === null || _.boolLike( o.outcome ) );
  _.assert( o.msg === null || _.strIs( o.msg ) );
  _.assert( trd instanceof Self );
  _.assert( trd._checkIndex >= 0 );
  _.assert( _.strDefined( trd.routine.name ), 'test routine should have name' );

  let result = 'Test check' + ' ( ' + trd.descriptionWithName + ' # ' + trd._checkIndex + ' )';

  if( o.msg )
  result += ' : ' + o.msg;

  if( o.outcome !== null )
  {
    if( o.outcome )
    result += ' ... ok';
    else
    result += ' ... failed';
  }

  if( o.outcome !== null )
  result = _.Tester.textColor( result, o.outcome );

  return result;
}

_reportTextForTestCheck.defaults =
{
  outcome : null,
  msg : null,
  usingDescription : 1,
}

// --
// etc
// --

function _accuracyGet()
{
  let trd = this;
  return trd[ accuracyEffectiveSymbol ];
}

//

function _accuracySet( accuracy )
{
  let trd = this;

  _.assert( accuracy === null || _.numberIs( accuracy ) || _.rangeIs( accuracy ), 'expects number or range {-accuracy-}' );

  trd[ accuracySymbol ] = accuracy;

  return trd._accuracyChange();
}

//

function _accuracyEffectiveGet()
{
  let trd = this;
  return trd[ accuracyEffectiveSymbol ];
}

//

function _accuracyChange()
{
  let trd = this;
  let result;

  if( !trd.suite )
  return null;

  if( _.numberIs( trd[ accuracySymbol ] ) )
  result = trd[ accuracySymbol ];
  else
  result = trd.suite.accuracy;

  // if( trd.accuracyRange )
  // debugger;
  // if( trd.accuracyRange )

  if( _.arrayIs( trd[ accuracySymbol ] ) )
  result = _.numberClamp( result, trd[ accuracySymbol ] );

  trd[ accuracyEffectiveSymbol ] = result;

  return result;
}

//

function _timeOutGet()
{
  let trd = this;
  if( trd[ timeOutSymbol ] !== null )
  return trd[ timeOutSymbol ];
  if( trd.suite.routineTimeOut !== null )
  return trd.suite.routineTimeOut;
  _.assert( 0 );
}

//

function _timeOutSet( timeOut )
{
  let trd = this;
  // debugger;
  _.assert( timeOut === null || _.numberIs( timeOut ) );
  trd[ timeOutSymbol ] = timeOut;
  return timeOut;
}

//

function _rapidityGet()
{
  let trd = this;
  if( trd[ rapiditySymbol ] !== null )
  return trd[ rapiditySymbol ];
  _.assert( 0 );
}

//

function _rapiditySet( rapidity )
{
  let trd = this;
  _.assert( _.numberIs( rapidity ) );
  trd[ rapiditySymbol ] = rapidity;
  return rapidity;
}

//

function _usingSourceCodeGet()
{
  let trd = this;
  if( trd[ usingSourceCodeSymbol ] !== null )
  return trd[ usingSourceCodeSymbol ];
  if( trd.suite.usingSourceCode !== null )
  return trd.suite.usingSourceCode;
  _.assert( 0 );
}

//

function _usingSourceCodeSet( usingSourceCode )
{
  let trd = this;
  _.assert( usingSourceCode === null || _.boolLike( usingSourceCode ) );
  trd[ usingSourceCodeSymbol ] = usingSourceCode;
  return usingSourceCode;
}

//

function _adoptRoutineFields()
{
  let trd = this;

  // if( trd.routine.name === 'filesReflect' )
  // debugger;
  _.mapExtendByDefined( trd, _.mapOnly( trd.routine, trd.KnownFields ) );

}

// --
// let
// --

let willSymbol = Symbol.for( 'will' );
let accuracySymbol = Symbol.for( 'accuracy' );
let accuracyEffectiveSymbol = Symbol.for( 'accuracyEffective' );
let timeOutSymbol = Symbol.for( 'timeOut' );
let rapiditySymbol = Symbol.for( 'rapidity' );
let usingSourceCodeSymbol = Symbol.for( 'usingSourceCode' );

let KnownFields =
{
  experimental : null,
  routineTimeOut : null,
  timeOut : null,
  accuracy : null,
  rapidity : null,
  usingSourceCode : null,
}

// --
// relations
// --

let Composes =
{
  name : null,
  will : '',
  accuracy : null,
  rapidity : 3,
  timeOut : null,
  experimental : 0,
  usingSourceCode : null,
}

let Aggregates =
{
}

let Associates =
{
  suite : null,
  routine : null,
}

let Restricts =
{

  _checkIndex : 1,
  _checksStack : _.define.own( [] ),
  _testsGroupOpenedExplicitly : 0,
  _testsGroupIsCase : 0,
  _testsGroupError : 0,
  _testsGroupsStack : _.define.own( [] ),

  _testRoutineBeginTime : null,
  _returned : null,
  _returnCon : null,
  report : null,

}

let Statics =
{
  KnownFields : KnownFields,
  strictEventHandling : 0,
}

let Events =
{
}

let Forbids =
{
  _cancelCon : '_cancelCon',
  _storedStates : '_storedStates',
  _currentRoutineFails : '_currentRoutineFails',
  _currentRoutinePasses : '_currentRoutinePasses',
}

let AccessorsReadOnly =
{
  testsGroup : 'testsGroup',
  nameFull : 'nameFull',
  descriptionFull : 'descriptionFull',
  descriptionWithName : 'descriptionWithName',
  accuracyEffective : 'accuracyEffective',
  able : 'able',
}

let Accessors =
{
  description : 'description',
  will : 'will',
  case : 'case',
  accuracy : 'accuracy',
  timeOut : 'timeOut',
  rapidity : 'rapidity',
  usingSourceCode : 'usingSourceCode',
}

// --
// declare
// --

let Proto =
{

  // inter

  init : init,
  refine : refine,

  // run

  _testRoutineBegin : _testRoutineBegin,
  _testRoutineEnd : _testRoutineEnd,
  _testRoutineHandleReturn : _testRoutineHandleReturn,

  _interruptMaybe : _interruptMaybe,
  _ableGet : _ableGet,
  _timeOutError : _timeOutError,

  // tests groups

  _willGet : _willGet,
  _willSet : _willSet,
  _descriptionGet : _willGet,
  _descriptionSet : _willSet,
  _descriptionFullGet : _descriptionFullGet,
  _descriptionWithNameGet : _descriptionWithNameGet,

  _caseGet : _caseGet,
  _caseSet : _caseSet,

  _testsGroupGet : _testsGroupGet,
  testsGroupOpen : testsGroupOpen,
  testsGroupClose : testsGroupClose,
  open : testsGroupOpen,
  close : testsGroupClose,

  _testsGroupChange : _testsGroupChange,
  testCaseCloseIfExplicitly : testCaseCloseIfExplicitly,
  hasTestGroupExceptOfCase : hasTestGroupExceptOfCase,
  _nameFullGet : _nameFullGet,

  // check

  checkCurrent : checkCurrent,
  checkNext : checkNext,
  checkStore : checkStore,
  checkRestore : checkRestore,

  // equalizer

  is : is,
  isNot : isNot,
  isNotError : isNotError,

  identical : identical,
  notIdentical : notIdentical,
  equivalent : equivalent,
  notEquivalent : notEquivalent,
  contains : contains,

  il : identical,
  ni : notIdentical,
  et : equivalent,
  ne : notEquivalent,

  gt : gt,
  ge : ge,
  lt : lt,
  le : le,

  _shouldDo : _shouldDo,

  shouldThrowErrorSync : shouldThrowErrorSync,
  shouldThrowErrorAsync : shouldThrowErrorAsync,
  shouldThrowError : shouldThrowError,
  mustNotThrowError : mustNotThrowError,
  shouldMessageOnlyOnce : shouldMessageOnlyOnce,

  // consider

  _testCheckConsider : _testCheckConsider,
  _testCaseConsider : _testCaseConsider,
  _exceptionConsider : _exceptionConsider,

  // report

  _outcomeReport : _outcomeReport,
  _outcomeReportBoolean : _outcomeReportBoolean,
  _outcomeReportCompare : _outcomeReportCompare,
  exceptionReport : exceptionReport,

  _reportForm : _reportForm,
  _reportIsPositive : _reportIsPositive,
  _reportTextForTestCheck : _reportTextForTestCheck,

  // fields

  _accuracySet : _accuracySet,
  _accuracyGet : _accuracyGet,
  _accuracyEffectiveGet : _accuracyEffectiveGet,
  _accuracyChange : _accuracyChange,

  _timeOutGet : _timeOutGet,
  _timeOutSet : _timeOutSet,

  _rapidityGet : _rapidityGet,
  _rapiditySet : _rapiditySet,

  _usingSourceCodeGet : _usingSourceCodeGet,
  _usingSourceCodeSet : _usingSourceCodeSet,

  _adoptRoutineFields : _adoptRoutineFields,

  // relations


  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,
  Events : Events,
  Forbids : Forbids,
  AccessorsReadOnly : AccessorsReadOnly,
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

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_.Tester[ Self.shortName ] = Self;

})();
