( function _Routine_s_()
{

'use strict';

//

/**
 * @classdesc Provides interface for creating of test routines. Interface is a collection of routines to create cases, groups of cases, perform different type of checks.
 * @class wTestRoutineObject
 * @param { Object } o - Test suite option map. {@link module:Tools/atop/Tester.wTestRoutineObject.TestRoutineFields More about options}
 * @module Tools/atop/Tester
 */

let _global = _global_;
let _ = _global_.wTools;
let debugged = _.process.isDebugged();

let Parent = null;
let Self = wTestRoutineObject;
function wTestRoutineObject( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'TestRoutine';

// --
// inter
// --

function init( o )
{
  let tro = this;

  tro[ accuracyEffectiveSymbol ] = null;
  _.workpiece.initFields( tro );
  Object.preventExtensions( tro );

  if( o )
  tro.copy( o );

  _.assert( _.routineIs( tro.routine ) );
  _.assert( Object.isPrototypeOf.call( wTestSuite.prototype, tro.suite ) );
  _.assert( Object.isPrototypeOf.call( Self.prototype, tro ) );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert
  (
    _.strDefined( tro.routine.name ),
    `Test routine should have name ${tro.name} test routine of test suite ${tro.suite.decoratedNickName} does not have name`
  );

  let proxy =
  {
    get : function( obj, k )
    {
      if( obj[ k ] !== undefined )
      return obj[ k ];
      return obj.suite[ k ];
    }
  }

  tro = new Proxy( tro, proxy );

  return tro;
}

//

/**
 * @summary Ensures that instance has all required properties defined.
 * @method form
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

function form()
{
  let tro = this;
  let routine = tro.routine;
  let name = tro.decoratedAbsoluteName;
  let suite = tro.suite;

  tro._returnedCon = null;
  tro._fieldsForm();
  tro._accuracyChange();
  tro._reportBegin();

  _.sure( routine.experimental === undefined || _.boolLike( routine.experimental ), name, 'Expects bool like in field {-experimental-} if defined' );
  _.sure( routine.timeOut === undefined || _.numberIs( routine.timeOut ), name, 'Expects number in field {-timeOut-} if defined' );
  _.sure( routine.routineTimeOut === undefined || _.numberIs( routine.routineTimeOut ), name, 'Expects number in field {-routineTimeOut-} if defined' );
  _.sure( routine.accuracy === undefined || _.numberIs( routine.accuracy ) || _.intervalIs( routine.accuracy ), name, 'Expects number or range in field {-accuracy-} if defined' );
  _.sure( routine.rapidity === undefined || _.numberIs( routine.rapidity ), name, 'Expects number in field {-rapidity-} if defined' );

  _.assert
  (
    _.strDefined( tro.name ),
    `Test routine should have name ${tro.name} test routine of test suite ${tro.suite.decoratedNickName} does not have name`
  );
  _.assert( suite instanceof wTestSuite );
  _.assert( suite.tests[ tro.name ] === routine || suite.tests[ tro.name ] === tro );

  suite.tests[ tro.name ] = tro;

  tro._formed = 1;
  return tro;
}

//

function _fieldsForm()
{
  let tro = this;
  let routine = tro.routine;
  let name = tro.decoratedAbsoluteName;

  for( let f in tro.RoutineFields )
  {
    if( routine[ f ] !== undefined )
    tro[ tro.RoutineFields[ f ] ] = routine[ f ];
  }

  _.sureMapHasOnly
  (
    routine,
    wTester.TestRoutine.RoutineFields,
    name + ' has unknown fields :'
  );

}

// --
// accessor
// --

function _accuracyGet()
{
  let tro = this;
  return tro[ accuracyEffectiveSymbol ];
}

//

function _accuracySet( accuracy )
{
  let tro = this;

  _.assert( accuracy === null || _.numberIs( accuracy ) || _.intervalIs( accuracy ), 'Expects number or range {-accuracy-}' );

  tro[ accuracySymbol ] = accuracy;

  return tro._accuracyChange();
}

//

function _accuracyEffectiveGet()
{
  let tro = this;
  return tro[ accuracyEffectiveSymbol ];
}

//

function _accuracyChange()
{
  let tro = this;
  let result;

  if( !tro.suite )
  return null;

  if( _.numberIs( tro[ accuracySymbol ] ) )
  {
    result = tro[ accuracySymbol ];
  }
  else
  {
    if( _.intervalIs( tro[ accuracySymbol ] ) )
    {
      _.assert( _.intervalIs( tro[ accuracySymbol ] ) );
      if( tro.suite.accuracyExplicitly !== null )
      result = tro.suite.accuracyExplicitly
      else
      result = tro[ accuracySymbol ][ 0 ];
      if( _.intervalIs( result ) )
      result = result[ 0 ];
      result = _.numberClamp( result, tro[ accuracySymbol ] );
    }
    else
    {
      result = tro.suite.accuracy;
      if( _.intervalIs( result ) )
      result = result[ 0 ];
    }
  }

  _.assert( _.numberDefined( result ) );

  tro[ accuracyEffectiveSymbol ] = result;
  return result;
}

//

function _timeOutGet()
{
  let tro = this;
  if( tro[ timeOutSymbol ] !== null )
  return tro[ timeOutSymbol ];
  if( tro.suite.routineTimeOut !== null )
  return tro.suite.routineTimeOut;
  _.assert( 0 );
}

//

function _timeOutSet( timeOut )
{
  let tro = this;
  _.assert( timeOut === null || _.numberIs( timeOut ) );
  tro[ timeOutSymbol ] = timeOut;
  return timeOut;
}

//

function _rapidityGet()
{
  let tro = this;
  if( tro[ rapiditySymbol ] !== null )
  return tro[ rapiditySymbol ];
  _.assert( 0 );
}

//

function _rapiditySet( rapidity )
{
  let tro = this;
  _.assert( _.numberIs( rapidity ) );
  if( rapidity > 9 )
  rapidity = 9;
  if( rapidity < -9 )
  rapidity = -9;
  tro[ rapiditySymbol ] = rapidity;
  return rapidity;
}

//

function _usingSourceCodeGet()
{
  let tro = this;

  if( tro[ usingSourceCodeSymbol ] !== null )
  return tro[ usingSourceCodeSymbol ];

  if( tro.rapidity < 0 && tro.suite.routine !== tro.name )
  return false;

  if( tro.suite.usingSourceCode !== null )
  return tro.suite.usingSourceCode;

  _.assert( 0 );
}

//

function _usingSourceCodeSet( usingSourceCode )
{
  let tro = this;
  _.assert( usingSourceCode === null || _.boolLike( usingSourceCode ) );
  tro[ usingSourceCodeSymbol ] = usingSourceCode;
  return usingSourceCode;
}

// --
// run
// --

function _run()
{
  let tro = this;
  let suite = tro.suite;
  let result;

  tro._runBegin();

  tro._timeLimitCon = new _.Consequence({ tag : '_timeLimitCon' });
  tro._timeLimitErrorCon = _.time.outError( debugged ? Infinity : tro.timeOut + wTester.settings.sanitareTime )
  .finally( ( err, arg ) =>
  {
    if( err === _.dont )
    {
      tro._timeLimitCon.take( err );
    }
    else
    {
      _.errAttend( err );
      err = tro._timeOutError( 'From run.' );
      if( err && !tro.report.reason )
      tro.report.reason = err.reason;
      _.errAttend( err );
      _.assert( !err.logged );
      if( !tro._returnedHow )
      tro._returnedHow = 'test routine time out';
    }
    if( err )
    throw err;
    return arg;
  });
  tro._timeLimitErrorCon.tag = '_timeLimitErrorCon';

  /* */

  try
  {
    result = tro.routine.call( suite.context, tro );
    if( result === undefined )
    result = null;
  }
  catch( err )
  {
    result = new _.Consequence().error( _.err( err ) );
  }

  /* */

  tro._returnedCon = new _.Consequence(); /* yyy */
  if( Config.debug && !tro._returnedCon.tag )
  tro._returnedCon.tag = tro.name + '-1';

  tro._returnedData = result;
  tro._originalReturnedCon = _.Consequence.From( result );
  tro._originalReturnedCon.give( ( err, arg ) =>
  {
    if( tro._returnedHow )
    {
      let err; debugger;
      if( tro.report && tro.report.reason )
      {
        if( tro.report.reason === 'test routine time limit' )
        return;
        err = _.err( `${tro.qualifiedNameGet()} is ended because of ${tro.report.reason}, but it got several async returning` );
      }
      else
      {
        err = _.err( `${tro.qualifiedNameGet()} is ended, but it got several async returning` );
      }
      suite.exceptionReport
      ({
        err,
      });
    }
    else
    {
      tro._returnedHow = 'normal';
      tro._returnedCon.take( err, arg );
      tro._originalReturnedCon.take( err, arg );
    }
  });

  tro._returnedCon.andKeep( suite._inroutineCon );
  tro._returnedCon.orKeeping([ tro._timeLimitErrorCon, wTester._cancelCon ]);
  tro._returnedCon.finally( ( err, msg ) => tro._runFinally( err, msg ) );

  return tro._returnedCon;
}

//

function _runBegin()
{
  let tro = this;
  let suite = tro.suite;

  _.assert( !!wTester );
  tro._testRoutineBeginTime = _.time.now();

  _.arrayAppendOnceStrictly( wTester.activeRoutines, tro );

  /*
  store exit code to restore it later
  */
  tro._exitCode = _.process.exitCode( 0 );
  suite._hasConsoleInOutputs = suite.logger.hasOutput( console, { deep : 0, withoutOutputToOriginal : 0 } );

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( tro._returned === null );

  let msg = [ `Running ${tro.decoratedAbsoluteName} ..` ];

  suite.logger.begin({ verbosity : -4 });

  suite.logger.begin({ 'routine' : tro.routine.name });
  suite.logger.logUp( msg.join( '\n' ) );
  suite.logger.end( 'routine' );

  suite.logger.end({ verbosity : -4 });

  _.assert( !suite.currentRoutine );
  suite.currentRoutine = tro;

  let debugWas = Config.debug;
  if( wTester.settings.debug !== null && wTester.settings.debug !== undefined )
  {
    _.assert( _.boolLike( wTester.settings.debug ) ); debugger;
    Config.debug = wTester.settings.debug;
  }

  try
  {
    suite.onRoutineBegin.call( tro.context, tro );
    if( Config.debug !== debugWas )
    Config.debug = debugWas;
    if( tro.eventGive )
    tro.eventGive({ kind : 'routineBegin', testRoutine : tro, context : tro.context });
  }
  catch( err )
  {
    if( Config.debug !== debugWas )
    Config.debug = debugWas;
    tro.exceptionReport({ err });
  }

  if( Config.debug !== debugWas )
  Config.debug = debugWas;
}

//

function _runEnd()
{
  let tro = this;
  let suite = tro.suite;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( _.strDefined( tro.routine.name ), 'test routine should have name' );
  _.assert( suite.currentRoutine === tro );

  if( !tro._timeLimitErrorCon.resourcesCount() && !tro._timeLimitCon.resourcesCount() )
  {
    tro._timeLimitErrorCon.error( _.dont );
  }

  let _hasConsoleInOutputs = suite.logger.hasOutput( console, { deep : 0, withoutOutputToOriginal : 0 } );
  if( suite._hasConsoleInOutputs !== _hasConsoleInOutputs && !wTester._canceled )
  {
    debugger;
    let err = _.err( 'Console is missing in logger`s outputs, probably it was removed' + '\n  in' + tro.absoluteName );
    suite.exceptionReport
    ({
      unbarring : 1,
      err,
    });
  }

  /* groups stack */

  tro._descriptionChange({ src : '', touching : 0 });
  tro._groupTestEnd();

  if( tro.report.errorsArray.length && !tro.report.reason )
  {
    if( tro.report.errorsArray[ 0 ].reason )
    tro.report.reason = tro.report.errorsArray[ 0 ].reason;
    else
    tro.report.reason = 'throwing error';
  }

  /* last test check */

  if( tro.report.testCheckPasses === 0 && tro.report.testCheckFails === 0 )
  {
    if( !tro.report.reason )
    tro.report.reason = 'passed none test check';
    tro._outcomeReportBoolean
    ({
      outcome : 0,
      msg : 'test routine has passed none test check',
      usingSourceCode : 0,
      usingDescription : 0,
    });
  }
  else if( !tro.report.errorsArray )
  {
    tro._outcomeReportBoolean
    ({
      outcome : 1,
      msg : 'test routine has not thrown an error',
      usingSourceCode : 0,
      usingDescription : 0,
    });
  }

  /* on end */

  tro._reportEnd();
  let ok = tro._reportIsPositive();
  try
  {
    suite.onRoutineEnd.call( tro.context, tro, ok ); /* xxx qqq for Dmytro : may return consequence! should pass error if thrown */
    /* qqq : should be
    it = { err, arg, test : tro }
    suite.onRoutineEnd.call( tro.context, it );
    */
    if( tro.eventGive )
    tro.eventGive({ kind : 'routineEnd', testRoutine : tro, context : tro.context });
  }
  catch( err )
  {
    tro.exceptionReport({ err });
    ok = false;
  }

  /* restoring exit code */

  if( tro._exitCode && !_.process.exitCode() )
  tro._exitCode = _.process.exitCode( tro._exitCode );

  /* */

  suite._testRoutineConsider( tro.report );

  suite.currentRoutine = null;

  /* */

  suite.logger.begin( 'routine', 'end' );
  suite.logger.begin({ 'connotation' : ok ? 'positive' : 'negative' });
  suite.logger.begin({ verbosity : -3 });

  let timingStr = '';
  if( wTester )
  {
    tro.report.timeSpent = _.time.now() - tro._testRoutineBeginTime;
    timingStr = 'in ' + _.time.spentFormat( tro.report.timeSpent );
  }

  let str = ( ok ? 'Passed' : 'Failed' ) + ( tro.report.reason ? ` ( ${tro.report.reason} )` : '' ) + ` ${tro.absoluteName} ${timingStr}`;

  str = wTester.textColor( str, ok );

  if( !ok )
  suite.logger.begin({ verbosity : -3+suite.negativity });

  suite.logger.logDown( str );

  if( !ok )
  suite.logger.end({ verbosity : -3+suite.negativity });

  suite.logger.end({ 'connotation' : ok ? 'positive' : 'negative' });
  suite.logger.end( 'routine', 'end' );

  suite.logger.end({ verbosity : -3 });

  _.arrayRemoveElementOnceStrictly( wTester.activeRoutines, tro );

  return ok
}

//

function _runFinally( err, arg )
{
  let tro = this;
  let suite = tro.suite;

  if( tro._returned === null )
  tro._returned = [ err, arg ];
  else
  tro.exceptionReport
  ({
    err : _.err( 'Returned several times!' ),
  });

  if( err )
  {
    tro.exceptionReport
    ({
      err,
      logging : tro._returnedHow !== 'test routine time out' || err.reason !== 'test routine time limit',
    });
    tro._runEnd();
    return err;
  }

  tro._runEnd();
  return arg;
}

//

function _runInterruptMaybe( throwing )
{
  let tro = this;
  let logger = tro.logger;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( !!wTester.report );

  tro._returnedVerification();

  if( !wTester._canContinue() )
  {
    debugger;
    let result = tro.cancel();
    if( throwing )
    throw result;
    return result;
  }

  let elapsed = _.time.now() - tro._testRoutineBeginTime;
  if( elapsed > tro.timeOut && !debugged )
  {
    logger.error( `Test routine ${tro.absoluteName} timed out, cant continue!` );
    let result = tro.cancel({ err : tro._timeOutError( 'Cancel.' ) });
    if( throwing )
    throw result;
    return result;
  }

  return false;
}

//

function _returnedVerification()
{
  let tro = this;
  let suite = tro.suite;
  let logger = tro.logger;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( !!wTester.report );

  if( tro._returned )
  {
    let err = _._err({ args : [ `Test routine ${tro.absoluteName} returned, cant continue!` ], reason : 'returned' });
    err = _.errBrief( err );
    suite.exceptionReport
    ({
      unbarring : 1,
      err,
    });
    debugger;
    throw err;
  }

}

//

function _runnableGet()
{
  let tro = this;
  let suite = tro.suite;

  _.assert( _.numberIs( wTester.settings.rapidity ) );

  if( suite.routine )
  {

    if( _.arrayIs( suite.routine ) )
    return _.any( suite.routine, ( e ) => _.path.globShortFit( tro.name, e ) )
    return _.path.globShortFit( tro.name, suite.routine );
  }

  if( tro.experimental )
  return false;

  if( tro.rapidity < wTester.settings.rapidity )
  return false;

  return true;
}

//

function _timeOutError( err )
{
  let tro = this;

  if( err && err._testRoutine )
  return err;

  err = _._err
  ({
    args : [ err || '', `\nTest routine ${tro.decoratedAbsoluteName} timed out. TimeOut set to ${tro.timeOut} + ms` ],
    usingSourceCode : 0,
    reason : 'test routine time limit',
  });

  let o =
  {
    enumerable : false,
    configurable : false,
    writable : false,
    value : tro,
  };

  Object.defineProperty( err, '_testRoutine', o );

  err = _.errBrief( err );

  return err;
}

//

function cancel( o )
{
  let tro = this;
  let logger = tro.logger;
  o = _.routineOptions( cancel, arguments );

  if( !o.err )
  o.err = _.errBrief( `Test routine ${tro.absoluteName} was canceled!` );
  logger.error( _.errOnce( o.err ) );

  if( tro._returnedCon )
  if( tro._returnedCon.resourcesCount() === 0 )
  {
    tro._originalReturnedCon.error( o.err );
  }

  if( wTester.settings.fails > 0 )
  if( wTester.settings.fails <= wTester.report.testCheckFails )
  {
    return wTester.cancel({ err : o.err });
  }

  // return wTester.cancel({ err : o.err, global : o.global });
  return o.err;
}

cancel.defaults =
{
  global : 0,
  err : null,
}

// --
// check description
// --

function _descriptionGet()
{
  let tro = this;
  return tro[ descriptionSymbol ];
}

//

function _descriptionSet( src )
{
  let tro = this;
  return tro._descriptionChange({ src });
}

//

function _descriptionChange( o )
{
  let tro = this;

  _.assert( _.mapIs( o ) );
  _.routineOptions( _descriptionChange, o );

  if( o.touching )
  if( wTester.report )
  tro._runInterruptMaybe( 1 );

  tro[ descriptionSymbol ] = o.src;

}

_descriptionChange.defaults =
{
  src : null,
  touching : 9,
}

//

function _descriptionFullGet()
{
  let tro = this;
  let result = '';
  let right = ' > ';
  let left = ' < ';

  result = tro._groupsStack.slice( 0, tro._groupsStack.length-1 ).join( right );
  if( result )
  result += right + tro.case
  else
  result += tro.case
  if( tro.description )
  result += left;

  if( tro.description )
  result += tro.description;

  return result;
}

//

function _descriptionWithNameGet()
{
  let tro = this;
  let description = tro.descriptionFull;
  let name = tro.absoluteName;
  let slash = ' / ';
  return name + slash + description
}

// --
// checks group
// --

function _groupGet()
{
  let tro = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return tro._groupsStack[ tro._groupsStack.length-1 ] || '';
}

//

/**
 * @summary Creates tests group with name `groupName`.
 * @method open
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

function groupOpen( groupName )
{
  let tro = this;

  try
  {
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.strIs( groupName ), 'Expects string' );
    tro._caseClose();
    tro._groupChange({ group : groupName, open : 1 });

    if( tro._groupsStack.length >= 2 )
    if( tro._groupsStack[ tro._groupsStack.length-1 ] === tro._groupsStack[ tro._groupsStack.length-2 ] )
    {
      let msg =
      `Attempt to open group "${groupName}". Group with the same name is already opened. Might be you meant to close it?`;

      let err = tro._groupingErorr( msg, 2 );
      err = tro.exceptionReport({ err });
      return;
    }

  }
  catch( err )
  {
    tro.exceptionReport
    ({
      err,
    });
    return false;
  }

}

//

/**
 * @summary Closes tests group with name `groupName`.
 * @method close
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

function groupClose( groupName )
{
  let tro = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  try
  {
    tro._caseClose();
    tro._groupChange({ group : groupName, open : 0 });
  }
  catch( err )
  {
    tro.exceptionReport
    ({
      err,
    });
    return false;
  }

  return tro.group;
}

//

function _groupChange( o )
{
  let tro = this;

  _.routineOptions( _groupChange, o );
  _.assert( arguments.length === 1, 'Expects no arguments' );
  _.assert( _.strIs( o.group ) || o.group === null );

  if( o.open )
  open();
  else
  close();

  reset();

  /* */

  function reset()
  {
    tro._groupOpenedWithCase = 0;
    tro._testCheckPassesOfTestCase = 0;
    tro._testCheckFailsOfTestCase = 0;
    tro._descriptionChange({ src : '', touching : 0 });
  }

  /* */

  function open()
  {
    let group = tro.group;

    _.assert( tro._groupOpenedWithCase === 0 );

    if( !o.group )
    return

    tro._groupsStack.push( o.group );

  }

  /* */

  function close()
  {
    let group = tro.group;

    if( group !== o.group )
    {
      let msg =
      `Discrepancy!. Attempt to close not the topmost tests group. \n`
      + `Attempt to close "${o.group}", but current tests group is "${group}". Might be you want to close it first.`;

      let err = tro._groupingErorr( msg, 4 );
      err = tro.exceptionReport({ err });
    }
    else
    {
      tro._groupsStack.pop();
    }

    if( group )
    {
      if( tro._testCheckFailsOfTestCase > 0 || tro._testCheckPassesOfTestCase > 0 )
      tro._testCaseConsider( !tro._testCheckFailsOfTestCase );
    }

  }

}

_groupChange.defaults =
{
  group : null,
  open : null,
  touching : 9,
}

//

function _groupTestEnd()
{
  let tro = this;

  tro._caseClose();

  if( tro._groupsStack.length && !tro._groupError )
  {
    let err = tro._groupingErorr( `Tests group ${tro.group} was not closed`, 4 );
    err = tro.exceptionReport({ err, usingSourceCode : 0 });
  }

}

//

function _groupingErorr( msg, level )
{
  let tro = this;

  if( level === undefined || level === null )
  level = 4;

  let err = _._err
  ({
    args : [ msg ],
    level,
    reason : 'grouping error',
    usingSourceCode : 0,
  });

  err = _.errBrief( err );

  if( !tro._groupError )
  tro._groupError = err;

  return err;
}

//

function _caseGet()
{
  let tro = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  if( tro._groupOpenedWithCase )
  return tro._groupsStack[ tro._groupsStack.length-1 ] || '';
  else
  return '';
}

//

function _caseSet( src )
{
  let tro = this;
  _.assert( arguments.length === 1 );
  return tro._caseChange({ src });
}

//

function _caseClose()
{
  let tro = this;
  let report = tro.report;

  if( tro._groupOpenedWithCase )
  {
    // tro._groupOpenedWithCase = 0;
    _.assert( _.strIs( tro.group ) );
    tro._groupChange({ group : tro.group, touching : 0, open : 0 });
    _.assert( tro._groupOpenedWithCase === 0 );
  }

}

//

function _caseChange( o )
{
  let tro = this;

  _.routineOptions( _caseChange, o );
  _.assert( _.mapIs( o ) );
  _.assert( arguments.length === 1 );
  _.assert( o.src === null || _.strIs( o.src ), () => `Expects string or null {-o.src-}, but got ${_.strType( o.src )}` );

  // yyy
  if( tro.case )
  {
    tro._groupChange({ group : tro.group, touching : o.touching, open : 0 });
  }

  if( o.src )
  {
    tro._groupChange({ group : o.src, touching : o.touching, open : 1 });
    tro._groupOpenedWithCase = 1;
  }
  else
  {
    // if( tro.case )
    // tro._groupChange({ group : o.src, touching : o.touching, open : 0 });
  }

  return o.src;
}

_caseChange.defaults =
{
  src : null,
  touching : 9,
}

// --
// name
// --

function qualifiedNameGet()
{
  let tro = this;
  return tro.constructor.shortName + '::' + tro.name;
}

//

function decoratedQualifiedNameGet()
{
  let tro = this;
  debugger;
  return wTester.textColor( tro.qualifiedNameGet, 'entity' );
}

//

function absoluteNameGet()
{
  let tro = this;
  let slash = ' / ';
  return tro.suite.qualifiedName + slash + tro.qualifiedName;
}

//

function decoratedAbsoluteNameGet()
{
  let tro = this;
  return wTester.textColor( tro.absoluteName, 'entity' );
}

// --
// ceck
// --

/**
 * @summary Returns information about current test check.
 * @method checkCurrent
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

function checkCurrent()
{
  let tro = this;
  let result = Object.create( null );

  _.assert( arguments.length === 0, 'Expects no arguments' );

  result.groupsStack = tro._groupsStack;
  result.description = tro.description;
  result.checkIndex = tro._checkIndex;

  return result;
}

//

/**
 * @summary Returns information about next test check.
 * @method checkCurrent
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

function checkNext( description )
{
  let tro = this;

  _.assert( tro instanceof Self );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !tro._checkIndex )
  tro._checkIndex = 1;
  else
  tro._checkIndex += 1;

  if( description !== undefined )
  tro.description = description;

  return tro.checkCurrent();
}

//

/**
 * @summary Saves information current test check into a inner container.
 * @method checkCurrent
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

function checkStore()
{
  let tro = this;
  let result = tro.checkCurrent();

  _.assert( arguments.length === 0, 'Expects no arguments' );

  tro._checksStack.push( result );

  return result;
}

//

/**
 * @descriptionNeeded
 * @param {Object} acheck
 * @method checkRestore
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

function checkRestore( acheck )
{
  let tro = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( acheck )
  {
    tro.checkStore();
    if( acheck === tro._checksStack[ tro._checksStack.length-1 ] )
    {
      debugger;
      _.assert( 0, 'not tested' );
      tro._checksStack.pop();
    }
  }
  else
  {
    _.assert( _.arrayIs( tro._checksStack ) && tro._checksStack.length, 'checkRestore : no stored check in stack' );
    acheck = tro._checksStack.pop();
  }

  tro._checkIndex = acheck.checkIndex;
  tro._groupsStack = acheck.groupsStack;
  tro._descriptionChange({ src : acheck.description, touching : 0 });

  return tro;
}

// --
// consider
// --

function _testCheckConsider( outcome )
{
  let tro = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( tro.constructor === Self );

  if( outcome )
  {
    tro.report.testCheckPasses += 1;
    tro._testCheckPassesOfTestCase += 1;
  }
  else
  {
    tro.report.testCheckFails += 1;
    tro._testCheckFailsOfTestCase += 1;
  }

  tro.suite._testCheckConsider( outcome );

  tro.checkNext();

}

//

function _testCaseConsider( outcome )
{
  let tro = this;
  let report = tro.report;

  if( outcome )
  report.testCasePasses += 1;
  else
  report.testCaseFails += 1;

  tro.suite._testCaseConsider( outcome );
}

//

function _exceptionConsider( err )
{
  let tro = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( tro.constructor === Self );

  tro.report.errorsArray.push( err );
  tro.suite._exceptionConsider( err );

}

// --
// report
// --

function _outcomeLog( o )
{
  let tro = this;
  let logger = tro.logger;
  let sourceCode = '';

  _.routineOptions( _outcomeLog, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  /* */

  let verbosity = o.outcome ? 0 : tro.negativity;
  sourceCode = sourceCodeGet();

  /* */

  logger.begin({ verbosity : o.verbosity });

  logger.begin({ 'check' : tro.description || tro._checkIndex });
  logger.begin({ 'checkIndex' : tro._checkIndex });

  logger.begin({ verbosity : o.verbosity+verbosity });

  logger.up();
  if( logger.verbosityReserve() > 1 )
  logger.log();
  logger.begin({ 'connotation' : o.outcome ? 'positive' : 'negative' });

  logger.begin({ verbosity : o.verbosity-1+verbosity });

  if( o.details )
  logger.begin( 'details' )
  .log( o.details )
  .end( 'details' );

  if( sourceCode )
  logger.begin( 'sourceCode' )
  .log( sourceCode )
  .end( 'sourceCode' );

  logger.end({ verbosity : o.verbosity-1+verbosity });

  logger.begin( 'message' )
  .logDown( o.msg )
  .end( 'message' );

  logger.end({ 'connotation' : o.outcome ? 'positive' : 'negative' });
  if( logger.verbosityReserve() > 1 )
  logger.log();

  logger.end({ verbosity : o.verbosity+verbosity });

  logger.end( 'check', 'checkIndex' );
  logger.end({ verbosity : o.verbosity });

  /* */

  function sourceCodeGet()
  {
    let code;
    if( tro.usingSourceCode && o.usingSourceCode )
    {
      let _location = o.stack ? _.introspector.location({ stack : o.stack }) : _.introspector.location({ level : 5 });
      let _code = _.introspector.code
      ({
        location : _location,
        selectMode : o.selectMode,
        nearestLines : 5,
      });
      if( _code )
      code = '\n' + _code + '\n';
      else
      code = '\n' + _location.full;
    }

    if( code )
    code = ' ❮inputRaw : 1❯ ' + code + ' ❮inputRaw : 0❯ ';

    return code;
  }

}

_outcomeLog.defaults =
{
  outcome : null,
  msg : null,
  details : null,
  stack : null,
  usingSourceCode : 1,
  selectMode : 'end',
  verbosity : -4,
}

//

function _outcomeReport( o )
{
  let tro = this;
  let logger = tro.logger;
  let sourceCode = '';

  _.routineOptions( _outcomeReport, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( o.considering )
  tro._testCheckConsider( o.outcome );

  if( o.logging )
  tro._outcomeLog( _.mapOnly( o, tro._outcomeLog.defaults ) );

  if( o.interruptible )
  tro._runInterruptMaybe( 1 );
}

_outcomeReport.defaults =
{
  ... _outcomeLog.defaults,
  // outcome : null,
  // msg : null,
  // details : null,
  // stack : null,
  // usingSourceCode : 1,
  // selectMode : 'end',
  // verbosity : -4,
  considering : 1,
  logging : 1,
  interruptible : 0,
}

//

function _outcomeReportBoolean( o )
{
  let tro = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routineOptions( _outcomeReportBoolean, o );

  o.msg = tro._reportTextForTestCheck
  ({
    outcome : o.outcome,
    msg : o.msg,
    usingDescription : o.usingDescription,
  });

  tro._outcomeReport
  ({
    outcome : o.outcome,
    msg : o.msg,
    details : '',
    stack : o.stack,
    usingSourceCode : o.usingSourceCode,
    selectMode : o.selectMode,
    interruptible : o.interruptible,
  });

  // if( o.interruptible )
  // tro._runInterruptMaybe( 1 );

}

_outcomeReportBoolean.defaults =
{
  outcome : null,
  msg : null,
  stack : null,
  usingSourceCode : 1,
  usingDescription : 1,
  interruptible : 0,
  selectMode : 'end',
}

//

function _outcomeReportCompare( o )
{
  let tro = this;

  _.assert( tro instanceof Self );
  _.assert( arguments.length === 1, 'Expects single argument' );
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
      strictString : o.strictString,
    });
  }

  let msg = tro._reportTextForTestCheck({ outcome : o.outcome });

  tro._outcomeReport
  ({
    outcome : o.outcome,
    msg,
    details,
    interruptible : o.interruptible,
  });

  if( !o.outcome )
  if( tro.debug )
  debugger;

  /**/

  function msgExpectedGot()
  {
    return
    'got :\n' + _.toStr( o.got, { stringWrapper : '\'' } ) + '\n'
    + nameOfExpected + ' :\n' + _.toStr( o.expected, { stringWrapper : '\'' } );
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
  interruptible : 0,
  strictString : 1,
  accuracy : null,
}

//

function exceptionReport( o )
{
  let tro = this;
  let msg = '';
  let err;

  _.routineOptions( exceptionReport, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  try
  {

    let wasBarred;
    if( o.unbarring )
    wasBarred = suite.consoleBar( 0 );

    try
    {
      if( tro.onError )
      tro.onError.call( tro, o );
    }
    catch( err2 )
    {
      logger.log( err2 );
    }

    if( o.considering )
    {
      /* qqq : implement and cover different message if time out */
      /* qqq : implement and cover different message if user terminated the program */
      if( o.err && o.err.reason )
      msg = tro._reportTextForTestCheck({ outcome : null }) + ` ... failed, ${o.err.reason}`;
      else
      msg = tro._reportTextForTestCheck({ outcome : null }) + ' ... failed, throwing error';
    }
    else
    {
      msg = 'Error throwen'
    }

    if( o.sync !== null )
    msg += ( o.sync ? ' synchronously' : ' asynchronously' );

    err = _._err({ args : [ o.err ], level : _.numberIs( o.level ) ? o.level+1 : o.level });

    if( _.errIsAttended( err ) )
    err = _.errBrief( err );
    _.errAttend( err );

    let details = err.toString();

    o.stack = o.stack === null ? o.err.stack : o.stack;

    if( o.considering )
    tro._exceptionConsider( err );

    tro._outcomeReport
    ({
      outcome : o.outcome,
      msg,
      details,
      stack : o.stack,
      usingSourceCode : o.usingSourceCode,
      considering : o.considering,
      logging : o.logging
    });

    if( o.unbarring )
    suite.consoleBar( wasBarred );

  }
  catch( err2 )
  {
    debugger;
    console.error( err2 );
    console.error( msg );
  }

  return err;
}

exceptionReport.defaults =
{
  err : null,
  level : null,
  stack : null,
  usingSourceCode : 0,
  considering : 1,
  logging : 1,
  outcome : 0,
  unbarring : 0,
  sync : null,
}

//

function _reportBegin()
{
  let tro = this;

  _.assert( !tro.report, 'test routine already has report' );

  let report = tro.report = Object.create( null );

  report.reason = null;
  report.outcome = null;
  report.timeSpent = null;
  report.errorsArray = [];
  report.exitCode = null;

  report.testCheckPasses = 0;
  report.testCheckFails = 0;

  report.testCasePasses = 0;
  report.testCaseFails = 0;

  Object.preventExtensions( report );
}

//

function _reportEnd()
{
  let tro = this;
  let report = tro.report;

  if( !report.exitCode )
  report.exitCode = _.process.exitCode();

  if( report.exitCode !== undefined && report.exitCode !== null && report.exitCode !== 0 )
  report.outcome = false;

  if( tro.report.testCheckFails !== 0 )
  report.outcome = false;

  if( !( tro.report.testCheckPasses > 0 ) )
  report.outcome = false;

  if( tro.report.errorsArray.length )
  report.outcome = false;

  if( report.outcome === null )
  report.outcome = true;

  return report.outcome;
}

//

function _reportIsPositive()
{
  let tro = this;
  let report = tro.report;

  if( !report )
  return false;

  // tro._reportEnd(); // yyy

  return report.outcome;
}

//

function _reportTextForTestCheck( o )
{
  let tro = this;

  o = _.routineOptions( _reportTextForTestCheck, o );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( o.outcome === null || _.boolLike( o.outcome ) );
  _.assert( o.msg === null || _.strIs( o.msg ) );
  _.assert( tro instanceof Self );
  _.assert( tro._checkIndex >= 0 );
  _.assert( _.strDefined( tro.routine.name ), 'test routine should have name' );

  // if( tro._returned )
  // debugger;

  let result = 'Test check' + ' ( ' + tro.descriptionWithName + ' # ' + tro._checkIndex + ' )';

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
  result = wTester.textColor( result, o.outcome );

  return result;
}

_reportTextForTestCheck.defaults =
{
  outcome : null,
  msg : null,
  usingDescription : 1,
}

// --
// checker
// --

/**
 * @summary Checks if result `outcome` of provided condition is positive.
 * @description Check passes if result if positive, otherwise fails. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * @param {Boolean} outcome Result of some condition.
 * @method _true
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

function _true( outcome )
{
  let tro = this;

  tro._returnedVerification();

  if( !_.boolLike( outcome ) || arguments.length !== 1 )
  {

    tro.exceptionReport
    ({
      err : 'Test check "true()" expects single bool argument, but got ' + arguments.length + ' ' + _.strType( outcome ),
      level : 2,
    });

    outcome = false;

  }
  else
  {
    outcome = !!outcome;
    tro._outcomeReportBoolean
    ({
      outcome,
      msg : 'expected true',
      interruptible : 1,
    });
  }

  return outcome;
}

//

function _false( outcome )
{
  let tro = this;

  tro._returnedVerification();

  if( !_.boolLike( outcome ) || arguments.length !== 1 )
  {

    tro.exceptionReport
    ({
      err : 'Test check "false()" expects single bool argument, but got ' + arguments.length + ' ' + _.strType( outcome ),
      level : 2,
    });

    outcome = false;

  }
  else
  {
    outcome = !outcome;
    tro._outcomeReportBoolean
    ({
      outcome,
      msg : 'expected false',
      interruptible : 1,
    });
  }

  return outcome;
}

//

/**
 * Checks if test passes a specified condition by deep strict comparsing result of code execution( got )
 * with target( expected ). Uses recursive comparsion for objects, arrays and array-like objects.
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
 * wTester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method identical
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

function identical( got, expected )
{
  let tro = this;
  let o2, outcome;

  tro._returnedVerification();

  /* */

  try
  {
    o2 = Object.create( null );
    outcome = _.entityIdentical( got, expected, o2 );
  }
  catch( err )
  {
    tro.exceptionReport
    ({
      err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : '"identical" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  if( !o2.it || o2.it.lastPath === undefined )
  {
    debugger;
    outcome = false;
    tro.exceptionReport
    ({
      err : 'Something wrong with entityIdentical, iterator misses lastPath',
      level : 2,
    });
    return outcome;
  }

  /* */

  tro._outcomeReportCompare
  ({
    outcome,
    got,
    expected,
    path : o2.it.lastPath,
    usingExtraDetails : 1,
    interruptible : 1,
  });

  /* */

  return outcome;
}

//

/**
 * Checks if test doesn't pass a specified condition by deep strict comparsing result of code execution( got )
 * with target( expected ). Uses recursive comparsion for objects, arrays and array-like objects.
 * If entity( got ) is not equal to entity( expected ) test is passed successfully. After check function reports result of test
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
 *  test.notIdentical( got, expected );//returns false
 *
 *  test.case = 'single number';
 *  let got = 2;
 *  let expected = 1;
 *  test.notIdentical( got, expected );//returns true
 * }
 *
 * wTester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method notIdentical
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

function notIdentical( got, expected )
{
  let tro = this;
  let o2, outcome;

  tro._returnedVerification();

  /* */

  try
  {
    o2 = Object.create( null );
    outcome = !_.entityIdentical( got, expected, o2 );
  }
  catch( err )
  {
    tro.exceptionReport
    ({
      err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : '"notIdentical" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  if( !o2.it || o2.it.lastPath === undefined )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : 'Something wrong with entityIdentical, iterator misses lastPath',
      level : 2,
    });

    return outcome;
  }

  /* */

  tro._outcomeReportCompare
  ({
    outcome,
    got,
    expected,
    path : o2.it.lastPath,
    usingExtraDetails : 0,
    interruptible : 1,
  });

  return outcome;
}

//

/**
 * Checks if test passes a specified condition by deep soft comparsing result of code execution( got )
 * with target( expected ). Uses recursive comparsion for objects, arrays and array-like objects. Two entities are equivalent if
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
 * wTester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method equivalent
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

function equivalent( got, expected, options )
{
  let tro = this;
  let accuracy = tro.accuracyEffective;
  let o2, outcome;

  tro._returnedVerification();

  /* */

  try
  {
    o2 = Object.create( null );
    o2.accuracy = accuracy;
    if( _.mapIs( options ) )
    _.mapExtend( o2, options )
    else if( _.numberIs( options ) )
    o2.accuracy = options;
    else _.assert( options === undefined );
    accuracy = o2.accuracy;
    outcome = _.entityEquivalent( got, expected, o2 );
  }
  catch( err )
  {
    tro.exceptionReport
    ({
      err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 && arguments.length !== 3 )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : '"equivalent" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  if( !o2.it || o2.it.lastPath === undefined )
  {
    outcome = false;
    tro.exceptionReport
    ({
      err : 'Something wrong with entityIdentical, iterator misses lastPath',
      level : 2,
    });
    return outcome;
  }

  /* */

  tro._outcomeReportCompare
  ({
    outcome,
    got,
    expected,
    path : o2.it.lastPath,
    usingExtraDetails : 1,
    accuracy,
    interruptible : 1,
    strictString : 0,
  });

  return outcome;
}

//

/**
 * Checks if test doesn't pass a specified condition by deep soft comparsing result of code execution( got )
 * with target( expected ). Uses recursive comparsion for objects, arrays and array-like objects. Two entities are not equivalent if
 * difference between their values are bigger than ( accuracy ). Example: ( got - expected ) > ( accuracy ).
 * If entity( got ) is not equivalent to entity( expected ) test is passed successfully. After check function reports result of test
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
 * wTester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method notEquivalent
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

function notEquivalent( got, expected, options )
{
  let tro = this;
  let accuracy = tro.accuracyEffective;
  let o2, outcome;

  tro._returnedVerification();

  /* */

  try
  {
    o2 = Object.create( null );
    o2.accuracy = accuracy;
    if( _.mapIs( options ) )
    _.mapExtend( o2, options )
    else if( _.numberIs( options ) )
    o2.accuracy = options;
    else _.assert( options === undefined );
    accuracy = o2.accuracy;
    outcome = !_.entityEquivalent( got, expected, o2 );
  }
  catch( err )
  {
    tro.exceptionReport
    ({
      err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 && arguments.length !== 3 )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : '"notEquivalent" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  if( !o2.it || o2.it.lastPath === undefined )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : 'Something wrong with entityIdentical, iterator misses lastPath',
      level : 2,
    });

    return outcome;
  }

  /* */

  tro._outcomeReportCompare
  ({
    outcome,
    got,
    expected,
    path : o2.it.lastPath,
    usingExtraDetails : 1,
    accuracy,
    interruptible : 1,
    strictString : 0,
  });

  return outcome;
}


//

/**
 * Checks if test passes a specified condition by deep contains comparsing result of code execution( got )
 * with target( expected ). Uses recursive comparsion for objects, arrays and array-like objects.
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
 * wTester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method contains
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

function contains( got, expected )
{
  let tro = this;
  let o2, outcome;

  tro._returnedVerification();

  /* */

  try
  {
    o2 = Object.create( null );
    outcome = _.entityContains( got, expected, o2 );
  }
  catch( err )
  {
    tro.exceptionReport
    ({
      err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : '"contains" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  if( !o2.it || o2.it.lastPath === undefined )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : 'Something wrong with entityIdentical, iterator misses lastPath',
      level : 2,
    });

    return outcome;
  }

  /* */

  tro._outcomeReportCompare
  ({
    outcome,
    got,
    expected,
    path : o2.it.lastPath,
    usingExtraDetails : 1,
    interruptible : 1,
    strictString : 0,
  });

  /* */

  return outcome;
}

//

function containsAll( got, expected )
{
  let tro = this;
  let o2, outcome;

  tro._returnedVerification();

  /* */

  try
  {
    o2 = Object.create( null );
    outcome = _.entityContainsAll( got, expected, o2 );
  }
  catch( err )
  {
    tro.exceptionReport
    ({
      err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : '"contains" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  if( !o2.it || o2.it.lastPath === undefined )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : 'Something wrong with entityIdentical, iterator misses lastPath',
      level : 2,
    });

    return outcome;
  }

  /* */

  tro._outcomeReportCompare
  ({
    outcome,
    got,
    expected,
    path : o2.it.lastPath,
    usingExtraDetails : 1,
    interruptible : 1,
    strictString : 0,
  });

  /* */

  return outcome;
}

//

function containsAny( got, expected )
{
  let tro = this;
  let o2, outcome;

  tro._returnedVerification();

  /* */

  try
  {
    o2 = Object.create( null );
    outcome = _.entityContainsAny( got, expected, o2 );
  }
  catch( err )
  {
    tro.exceptionReport
    ({
      err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : '"contains" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  if( !o2.it || o2.it.lastPath === undefined )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : 'Something wrong with entityIdentical, iterator misses lastPath',
      level : 2,
    });

    return outcome;
  }

  /* */

  tro._outcomeReportCompare
  ({
    outcome,
    got,
    expected,
    path : o2.it.lastPath,
    usingExtraDetails : 1,
    interruptible : 1,
    strictString : 0,
  });

  /* */

  return outcome;
}

//

function containsOnly( got, expected )
{
  let tro = this;
  let o2, outcome;

  tro._returnedVerification();

  /* */

  try
  {
    o2 = Object.create( null );
    outcome = _.containsOnly( got, expected, o2 );
  }
  catch( err )
  {
    tro.exceptionReport
    ({
      err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : '"contains" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  if( !o2.it || o2.it.lastPath === undefined )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : 'Something wrong with entityIdentical, iterator misses lastPath',
      level : 2,
    });

    return outcome;
  }

  /* */

  tro._outcomeReportCompare
  ({
    outcome,
    got,
    expected,
    path : o2.it.lastPath,
    usingExtraDetails : 1,
    interruptible : 1,
    strictString : 0,
  });

  /* */

  return outcome;
}

//

function containsNone( got, expected )
{
  let tro = this;
  let o2, outcome;

  tro._returnedVerification();

  /* */

  try
  {
    o2 = Object.create( null );
    outcome = _.entityContainsNone( got, expected, o2 );
  }
  catch( err )
  {
    tro.exceptionReport
    ({
      err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : '"contains" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  if( !o2.it || o2.it.lastPath === undefined )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : 'Something wrong with entityIdentical, iterator misses lastPath',
      level : 2,
    });

    return outcome;
  }

  /* */

  tro._outcomeReportCompare
  ({
    outcome,
    got,
    expected,
    path : o2.it.lastPath,
    usingExtraDetails : 1,
    interruptible : 1,
    strictString : 0,
  });

  /* */

  return outcome;
}

//

/**
 * Checks if test passes a specified condition by deep contains comparsing result of code execution( got )
 * with target( expected ).
 * If value of( got ) is greater than value of( than ) test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {*} got - First entity.
 * @param {*} than - Second entity.
 *
 * @example
 * function sometest( test )
 * {
 *  test.gt( 1, 2 );//returns false
 *  test.gt( 2, 1 );//returns true
 * }
 * wTester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method gt
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

function gt( got, than )
{
  let tro = this;

  tro._returnedVerification();

  if( _.bigIntIs( got ) || _.bigIntIs( than ) )
  {
    got = BigInt( got );
    than = BigInt( than );
  }

  let outcome = got > than;
  let diff = got - than;

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : '"gt" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  tro._outcomeReportCompare
  ({
    outcome,
    got,
    expected : than,
    nameOfPositiveExpected : 'greater than',
    nameOfNegativeExpected : 'not greater than',
    diff,
    usingExtraDetails : 1,
    interruptible : 1,
  });

  return outcome;
}

//

/**
 * Checks if test passes a specified condition by deep contains comparsing result of code execution( got )
 * with target( expected ).
 * If value of( got ) is greater than or equal to value of( than ) test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {*} got - First entity.
 * @param {*} than - Second entity.
 *
 * @example
 * function sometest( test )
 * {
 *  test.ge( 1, 2 );//returns false
 *  test.ge( 2, 2 );//returns true
 * }
 * wTester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method ge
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

function ge( got, than )
{
  let tro = this;

  tro._returnedVerification();

  if( _.bigIntIs( got ) || _.bigIntIs( than ) )
  {
    got = BigInt( got );
    than = BigInt( than );
  }

  let greater = got > than;
  let outcome = got >= than;
  let diff = got - than;

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : '"ge" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  tro._outcomeReportCompare
  ({
    outcome,
    got,
    expected : than,
    nameOfPositiveExpected : greater ? 'greater than' : 'identical with',
    nameOfNegativeExpected : 'not greater neither identical with',
    diff,
    usingExtraDetails : 1,
    interruptible : 1,
  });

  /* */

  return outcome;
}

//

/**
 * Checks if test passes a specified condition by deep contains comparsing result of code execution( got )
 * with target( expected ).
 * If value of( got ) is less than value of( than ) test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {*} got - First entity.
 * @param {*} than - Second entity.
 *
 * @example
 * function sometest( test )
 * {
 *  test.lt( 1, 2 );//returns true
 *  test.lt( 2, 2 );//returns false
 * }
 * wTester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method lt
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

function lt( got, than )
{
  let tro = this;

  tro._returnedVerification();

  if( _.bigIntIs( got ) || _.bigIntIs( than ) )
  {
    got = BigInt( got );
    than = BigInt( than );
  }

  let outcome = got < than;
  let diff = got - than;

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : '"lt" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  tro._outcomeReportCompare
  ({
    outcome,
    got,
    expected : than,
    nameOfPositiveExpected : 'less than',
    nameOfNegativeExpected : 'not less than',
    diff,
    usingExtraDetails : 1,
    interruptible : 1,
  });

  /* */

  return outcome;
}

//

/**
 * Checks if test passes a specified condition by deep contains comparsing result of code execution( got )
 * with target( expected ).
 * If value of( got ) is less or equal to value of( than ) test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {*} got - First entity.
 * @param {*} than - Second entity.
 *
 * @example
 * function sometest( test )
 * {
 *  test.le( 1, 2 );//returns true
 *  test.le( 2, 2 );//returns true
 *  test.le( 3, 2 );//returns false
 * }
 * wTester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method le
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

function le( got, than )
{
  let tro = this;

  tro._returnedVerification();

  if( _.bigIntIs( got ) || _.bigIntIs( than ) )
  {
    got = BigInt( got );
    than = BigInt( than );
  }

  let less = got < than;
  let outcome = got <= than;
  let diff = got - than;

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    tro.exceptionReport
    ({
      err : '"le" expects two arguments',
      level : 2,
    });

    return outcome;
  }

  /* */

  tro._outcomeReportCompare
  ({
    outcome,
    got,
    expected : than,
    nameOfPositiveExpected : less ? 'less than' : 'identical with',
    nameOfNegativeExpected : 'not less neither identical with',
    diff,
    usingExtraDetails : 1,
    interruptible : 1,
  });

  /* */

  return outcome;
}

// --
// shoulding
// --

// function _shouldDo( o )
// {
//   let tro = this;
//   let second = 0;
//   let reported = 0;
//   let good = 1;
//   let async = 0;
//   let stack = _.introspector.stack([ 2, -1 ]);
//   let logger = tro.logger;
//   let err, arg;
//   let con = new _.Consequence();
//
//   tro._returnedVerification();
//
//   if( !tro.shoulding )
//   return con.take( null );
//
//   try
//   {
//     _.routineOptions( _shouldDo, o );
//     _.assert( arguments.length === 1, 'Expects single argument' );
//     _.sure( o.args.length === 1 || o.args.length === 2, 'Expects one or two arguments' );
//     _.sure( _.routineIs( o.args[ 0 ] ), 'Expects callback to call' );
//     _.sure( o.args[ 1 ] === undefined || _.routineIs( o.args[ 1 ] ), 'Callback to handle error should be routine' );
//     if( o.args[ 1 ] )
//     {
//       _.sure( 1 <= o.args[ 1 ].length, 'Callback should have at least one argument.' );
//       _.sure( o.args[ 1 ].length <= 3, 'Callback should have less then three arguments.' );
//     }
//   }
//   catch( err )
//   {
//     let error = _.errRestack( err, 3 );
//     error = _._err({ args : [ error, '\nIllegal usage of should in', tro.absoluteName ] });
//     error = tro.exceptionReport({ err : error });
//
//     con.error( error );
//     if( !o.ignoringError && !o.expectingAsyncError && o.expectingSyncError )
//     return false;
//     else
//     return con;
//   }
//
//   o.routine = o.args[ 0 ];
//   let acheck = tro.checkCurrent();
//   tro._inroutineCon.give( 1 );
//
//   /* */
//
//   let result;
//   if( _.consequenceIs( o.routine ) )
//   {
//     result = o.routine;
//   }
//   else
//   {
//     try
//     {
//       result = o.routine.call( this );
//     }
//     catch( _err )
//     {
//       return handleError( _err );
//     }
//   }
//
//   /* no sync error, but expected */
//
//   if( !o.ignoringError && !o.expectingAsyncError && o.expectingSyncError && !err )
//   return handleLackOfSyncError();
//
//   /* */
//
//   if( _.consequenceIs( result ) )
//   handleAsyncResult()
//   else
//   handleSyncResult();
//
//   /* */
//
//   return con;
//
//   /* */
//
//   function handleError( _err )
//   {
//
//     err = _.err( _err );
//
//     if( o.args[ 1 ] )
//     callbackRunOnResult( err, result, !!o.expectingSyncError || !!( o.expectingSyncError && o.expectingAsyncError ) );
//
//     _.errAttend( err );
//
//     /* */
//
//     if( o.ignoringError )
//     {
//       begin( 1 );
//       tro._outcomeReportBoolean
//       ({
//         outcome : 1,
//         msg : 'error throwen synchronously, ignored',
//         stack,
//         selectMode : 'center'
//       });
//       end( 1, err );
//       return con;
//     }
//
//     /* */
//
//     tro.exceptionReport
//     ({
//       err,
//       sync : 1,
//       considering : 0,
//       outcome : o.expectingSyncError,
//     });
//
//     begin( o.expectingSyncError );
//
//     if( o.expectingSyncError )
//     {
//
//       tro._outcomeReportBoolean
//       ({
//         outcome : o.expectingSyncError,
//         msg : 'error thrown synchronously as expected',
//         stack,
//         selectMode : 'center',
//       });
//
//     }
//     else
//     {
//
//       tro._outcomeReportBoolean
//       ({
//         outcome : o.expectingSyncError,
//         msg : 'error thrown synchronously, what was not expected',
//         stack,
//         selectMode : 'center',
//       });
//
//     }
//
//     end( o.expectingSyncError, err );
//
//     if( !o.ignoringError && !o.expectingAsyncError && o.expectingSyncError )
//     return err;
//     else
//     return con;
//
//   }
//
//   /* */
//
//   function handleLackOfSyncError()
//   {
//     begin( 0 );
//
//     if( o.args[ 1 ] )
//     callbackRunOnResult( undefined, result, false );
//
//     let msg = 'Error not thrown synchronously, but expected';
//
//     tro._outcomeReportBoolean
//     ({
//       outcome : 0,
//       msg,
//       stack,
//       selectMode : 'center',
//     });
//
//     end( 0, _.err( msg ) );
//
//     return false;
//   }
//
//   /* */
//
//   function handleAsyncResult()
//   {
//
//     tro.checkNext();
//     async = 1;
//
//     result.give( function( _err, _arg )
//     {
//
//       err = _err;
//       arg = _arg;
//
//       if( !o.ignoringError && !reported )
//       {
//         if( o.args[ 1 ] && !err )
//         callbackRunOnResult( err, result, !o.expectingAsyncError );
//         if( err && !o.expectingAsyncError )
//         reportAsync();
//       }
//       else if( !err && o.expectingAsyncError )
//       {
//         if( o.args[ 1 ] )
//         callbackRunOnResult( err, result, !o.expectingAsyncError );
//         reportAsync();
//       }
//
//       if( _.errIs( err ) )
//       {
//         if( o.args[ 1 ] )
//         callbackRunOnResult( err, result, !!o.expectingAsyncError );
//         _.errAttend( err );
//       }
//
//       /* */
//
//       if( !reported )
//       if( !o.allowingMultipleResources )
//       _.time.out( 25, function() /* zzz : refactor that, use time out or test routine */
//       {
//
//         if( result.resourcesGet().length )
//         if( reported )
//         {
//           _.assert( !good );
//         }
//         else
//         {
//
//           begin( 0 );
//           debugger;
//
//           _.assert( !reported );
//
//           tro._outcomeReportBoolean
//           ({
//             outcome : 0,
//             msg : 'Got more than one message',
//             stack,
//           });
//
//           end( 0, _.err( msg ) );
//         }
//
//         if( !reported )
//         reportAsync();
//
//         return null;
//       });
//
//     });
//
//     /* */
//
//     if( !o.allowingMultipleResources )
//     handleSecondResource();
//
//   }
//
//   /* */
//
//   function handleSecondResource()
//   {
//     if( reported && !good )
//     return;
//
//     result.finally( gotSecondResource );
//
//     // let r = result.orKeepingSplit([ tro._timeLimitCon, wTester._cancelCon ]);
//     let r = _.Consequence.Or( result, tro._timeLimitCon, wTester._cancelCon );
//     r.finally( ( err, arg ) =>
//     {
//       if( result.competitorHas( gotSecondResource ) )
//       result.competitorsCancel( gotSecondResource );
//       if( err )
//       throw err;
//       return arg;
//     });
//
//   }
//
//   /* */
//
//   function gotSecondResource( err, arg )
//   {
//     if( reported && !good )
//     return null;
//
//     begin( 0 );
//
//     second = 1;
//     let msg = 'Got more than one message';
//
//     tro._outcomeReportBoolean
//     ({
//       outcome : 0,
//       msg,
//       stack,
//     });
//
//     end( 0, _.err( msg ) );
//
//     if( err )
//     throw err;
//     return arg;
//   }
//
//   /* */
//
//   function handleSyncResult()
//   {
//     if( o.args[ 1 ] )
//     callbackRunOnResult( err, result, !!( !o.expectingSyncError && !o.expectingAsyncError ) );
//
//     if( ( o.expectingAsyncError || o.expectingSyncError ) && !err )
//     {
//       begin( 0 );
//
//       let msg = 'Error not thrown asynchronously, but expected';
//       if( o.expectingAsyncError )
//       msg = 'Error not thrown, but expected either synchronosuly or asynchronously';
//
//       tro._outcomeReportBoolean
//       ({
//         outcome : 0,
//         msg,
//         stack,
//         selectMode : 'center',
//       });
//
//       end( 0, _.err( msg ) );
//     }
//     else if( !o.expectingSyncError && !err )
//     {
//       begin( 1 );
//
//       tro._outcomeReportBoolean
//       ({
//         outcome : 1,
//         msg : 'no error thrown, as expected',
//         stack,
//         selectMode : 'center',
//       });
//
//       end( 1, result );
//     }
//     else
//     {
//       debugger;
//       _.assert( 0, 'unexpected' );
//       tro.checkNext();
//     }
//
//   }
//
//   /* */
//
//   function begin( positive )
//   {
//     if( positive )
//     _.assert( !reported );
//     good = positive;
//
//     if( reported || async )
//     tro.checkRestore( acheck );
//
//     logger.begin({ verbosity : positive ? -5 : -5+tro.negativity });
//     logger.begin({ connotation : positive ? 'positive' : 'negative' });
//   }
//
//   /* */
//
//   function end( positive, arg )
//   {
//     _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//
//     logger.end({ verbosity : positive ? -5 : -5+tro.negativity });
//     logger.end({ connotation : positive ? 'positive' : 'negative' });
//
//     if( reported )
//     debugger;
//     if( reported || async )
//     tro.checkRestore();
//
//     if( arg === undefined && !async )
//     arg = null;
//
//     if( positive )
//     con.take( undefined, arg );
//     else
//     con.take( _.errAttend( arg ), undefined );
//
//     if( !reported )
//     tro._inroutineCon.take( null );
//
//     reported = 1;
//   }
//
//   /* */
//
//   function reportAsync()
//   {
//
//     /* yyy */
//     if( tro._returned )
//     return;
//     if( reported )
//     return;
//
//     if( o.ignoringError )
//     {
//       begin( 1 );
//
//       tro._outcomeReportBoolean
//       ({
//         outcome : 1,
//         msg : 'got single message',
//         stack,
//         selectMode : 'center'
//       });
//
//       end( 1, err ? err : arg );
//     }
//     else if( err !== undefined )
//     {
//       begin( o.expectingAsyncError );
//
//       tro.exceptionReport
//       ({
//         err,
//         sync : 0,
//         considering : 0,
//         outcome : o.expectingAsyncError,
//       });
//
//       if( o.expectingAsyncError )
//       tro._outcomeReportBoolean
//       ({
//         outcome : o.expectingAsyncError,
//         msg : 'error thrown asynchronously as expected',
//         stack,
//         selectMode : 'center'
//       });
//       else
//       tro._outcomeReportBoolean
//       ({
//         outcome : o.expectingAsyncError,
//         msg : 'error thrown asynchronously, not expected',
//         stack,
//         selectMode : 'center'
//       });
//
//       end( o.expectingAsyncError, err );
//     }
//     else
//     {
//       begin( !o.expectingAsyncError );
//
//       let msg = 'error was not thrown asynchronously, but expected';
//       if( !o.expectingAsyncError && !o.expectingSyncError && good )
//       msg = 'error was not thrown as expected';
//
//       tro._outcomeReportBoolean
//       ({
//         outcome : !o.expectingAsyncError,
//         msg,
//         stack,
//         selectMode : 'center'
//       });
//
//       if( o.expectingAsyncError )
//       end( !o.expectingAsyncError, _._err({ args : [ msg ], catchCallsStack : stack }) );
//       else
//       end( !o.expectingAsyncError, arg );
//
//     }
//
//   }
//
//   /* */
//
//   function callbackRunOnResult( err, arg, ok )
//   {
//     let onResult = o.args[ 1 ];
//     try
//     {
//       onResult( err, arg, ok );
//     }
//     catch( err2 )
//     {
//       console.error( err2 );
//     }
//   }
//
// }
//
// _shouldDo.defaults =
// {
//   args : null, /* aaa : cover 2-arguments calls for each should* check */ /* Dmytro : covered */
//   expectingSyncError : 1,
//   expectingAsyncError : 1,
//   ignoringError : 0,
//   allowingMultipleResources : 0,
// }

//

function _shouldDo_( o )
{
  let tro = this;
  let reported = 0;
  let good = 1;
  let async = 0;
  let stack = _.introspector.stack([ 2, -1 ]);
  let logger = tro.logger;
  let err, arg;
  let con = new _.Consequence();

  tro._returnedVerification();

  if( !tro.shoulding )
  return con.take( null );

  /* check arguments */

  try
  {
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.sure( o.args.length === 1 || o.args.length === 2, 'Expects one or two arguments' );
    _.sure( _.routineIs( o.args[ 0 ] ), 'Expects callback to call' );
    _.sure( o.args[ 1 ] === undefined || _.routineIs( o.args[ 1 ] ), 'Callback to handle error should be routine' );

    _.routineOptions( _shouldDo_, o );

    if( o.args[ 1 ] )
    {
      _.sure( 1 <= o.args[ 1 ].length, 'Callback should have at least one argument.' );
      _.sure( o.args[ 1 ].length <= 3, 'Callback should have less then three arguments.' );
    }
  }
  catch( err )
  {
    let error = _.errRestack( err, 3 );
    error = _._err({ args : [ error, '\nIllegal usage of should in', tro.absoluteName ] });
    error = tro.exceptionReport({ err : error });

    if( !o.ignoringError && !o.expectingAsyncError && o.expectingSyncError )
    {
      return false;
    }
    else
    {
      con.error( error );
      return con;
    }
  }

  /* make result */

  let result;
  let routine = o.args[ 0 ];
  let callback = o.args[ 1 ];
  let acheck = tro.checkCurrent();
  tro._inroutineCon.give( 1 );

  if( _.consequenceIs( routine ) )
  {
    result = routine;
  }
  else
  {
    try
    {
      result = routine.call( this );
    }
    catch( _err )
    {
      err = _err;
      return handleSyncError();
    }
  }

  /* handle result */

  if( !o.ignoringError && !o.expectingAsyncError && o.expectingSyncError && !err )
  return handleLackOfSyncError();

  if( _.consequenceIs( result ) )
  handleAsyncResult()
  else
  handleSyncResult();

  return con;

  /* */

  function handleLackOfSyncError()
  {
    if( callback )
    callbackRunOnResult( err, result, false );
    let msg = 'Error not thrown synchronously, but expected';
    outcomeReportBoolean( 0, msg, _.err( msg ) );
    return false;
  }

  /* */

  function handleSyncError()
  {
    if( callback )
    callbackRunOnResult( err, result, !!o.expectingSyncError || !!( o.expectingSyncError && o.expectingAsyncError ) );

    _.errAttend( err );

    if( o.ignoringError )
    return errorIgnore();

    tro.exceptionReport
    ({
      err,
      sync : 1,
      considering : 0,
      outcome : o.expectingSyncError,
    });

    let msg = 'error thrown synchronously as expected';
    if( !o.expectingSyncError )
    msg = 'error thrown synchronously, what was not expected';
    outcomeReportBoolean( o.expectingSyncError, msg, err );

    if( !o.expectingAsyncError && o.expectingSyncError )
    return err;
    else
    return con;
  }

  /* */

  function errorIgnore()
  {
    let msg = 'error throwen synchronously, ignored';
    outcomeReportBoolean( 1, msg, err );
    return con;
  }

  /* */

  function outcomeReportBoolean( sync, msg, reportedResult )
  {
    begin( sync );

    tro._outcomeReportBoolean
    ({
      outcome : sync,
      msg,
      stack,
      selectMode : 'center',
    });

    end( sync, reportedResult );
  }

  /* */

  function begin( positive )
  {
    if( positive )
    _.assert( !reported );
    good = positive;

    if( reported || async )
    tro.checkRestore( acheck );

    logger.begin({ verbosity : positive ? -5 : -5 + tro.negativity });
    logger.begin({ connotation : positive ? 'positive' : 'negative' });
  }

  /* */

  function end( positive, arg )
  {
    _.assert( arguments.length === 2, 'Expects exactly two arguments' );

    logger.end({ verbosity : positive ? -5 : -5 + tro.negativity });
    logger.end({ connotation : positive ? 'positive' : 'negative' });

    if( reported || async )
    tro.checkRestore();

    if( arg === undefined && !async )
    arg = null;

    if( positive )
    con.take( undefined, arg );
    else
    con.take( _.errAttend( arg ), undefined );

    if( !reported )
    tro._inroutineCon.take( null );

    reported = 1;
  }

  /* */

  function handleAsyncResult()
  {
    tro.checkNext();
    async = 1;

    result.give( function( _err, _arg )
    {

      err = _err;
      arg = _arg;

      let expected = !!o.expectingAsyncError;
      if( !err )
      expected = !expected;

      if( callback )
      callbackRunOnResult( err, result, expected );

      if( !o.ignoringError && !reported )
      {

        if( err && !o.expectingAsyncError )
        reportAsync();
      }
      else if( !err && o.expectingAsyncError )
      {
        reportAsync();
      }

      if( _.errIs( err ) )
      _.errAttend( err );

      /* */

      if( !reported )
      if( !o.allowingMultipleResources )
      _.time.out( 25, function() /* zzz : refactor that, use time out or test routine */
      {

        if( result.resourcesGet().length )
        {
          if( reported )
          {
            _.assert( !good );
          }
          else
          {
            let msg = 'Got more than one message';
            outcomeReportBoolean( 0, msg, _.err( msg ) );
          }
        }

        if( !reported )
        reportAsync();

        return null;
      });

    });

    /* */

    if( !o.allowingMultipleResources )
    handleSecondResource();

  }

  /* */

  function reportAsync()
  {
    if( tro._returned || reported )
    return;

    if( o.ignoringError )
    {
      let msg = 'got single message';
      outcomeReportBoolean( 1, msg, err ? err : arg );
      return;
    }

    else if( err !== undefined )
    reportThrowenAsyncError();
    else
    reportNotThrowenAsyncError();
  }

  /* */

  function reportThrowenAsyncError()
  {
    tro.exceptionReport
    ({
      err,
      sync : 0,
      considering : 0,
      outcome : o.expectingAsyncError,
    });

    let msg = 'error thrown asynchronously as expected';
    if( !o.expectingAsyncError )
    msg = 'error thrown asynchronously, not expected';

    outcomeReportBoolean( o.expectingAsyncError, msg, err );
  }

  /* */

  function reportNotThrowenAsyncError()
  {
    let msg = 'error was not thrown asynchronously, but expected';
    if( !o.expectingAsyncError && !o.expectingSyncError && good )
    msg = 'error was not thrown as expected';

    if( o.expectingAsyncError )
    outcomeReportBoolean( !o.expectingAsyncError, msg, _._err({ args : [ msg ], catchCallsStack : stack }) );
    else
    outcomeReportBoolean( !o.expectingAsyncError, msg, arg );
  }

  /* */

  function handleSecondResource()
  {
    if( reported && !good )
    return;

    result.finally( gotSecondResource );

    let r = _.Consequence.Or( result, tro._timeLimitCon, wTester._cancelCon );
    r.finally( ( err, arg ) =>
    {
      if( result.competitorHas( gotSecondResource ) )
      result.competitorsCancel( gotSecondResource );
      if( err )
      throw err;
      return arg;
    });

  }

  /* */

  function gotSecondResource( err, arg )
  {
    if( reported && !good )
    return null;

    let msg = 'Got more than one message';
    outcomeReportBoolean( 0, msg, _.err( msg ) );

    if( err )
    throw err;
    return arg;
  }

  /* */

  function handleSyncResult()
  {
    if( callback )
    callbackRunOnResult( err, result, ( !o.expectingSyncError && !o.expectingAsyncError ) );

    _.assert( !err, 'Expect no error' );

    if( o.expectingSyncError && !o.expectingAsyncError )
    {
      let msg = 'Error not thrown synchronously, but expected';
      outcomeReportBoolean( 1, msg, _.err( msg ) );
    }
    if( !o.expectingSyncError && o.expectingAsyncError )
    {
      let msg = 'Error not thrown asynchronously, but expected';
      outcomeReportBoolean( 0, msg, _.err( msg ) );
    }
    if( o.expectingSyncError && o.expectingAsyncError )
    {
      let msg = 'Error not thrown, but expected either synchronosuly or asynchronously';
      outcomeReportBoolean( 0, msg, _.err( msg ) );
    }
    if( !o.expectingSyncError && !o.expectingAsyncError )
    {
      let msg = 'no error thrown, as expected';
      outcomeReportBoolean( 1, msg, result );
    }
  }

  /* */

  function callbackRunOnResult( err, arg, ok )
  {
    let onResult = o.args[ 1 ];
    try
    {
      onResult( err, arg, ok );
    }
    catch( err2 )
    {
      logger.error( err2 );
    }
  }

}

_shouldDo_.defaults =
{
  args : null,
  expectingSyncError : 1,
  expectingAsyncError : 1,
  ignoringError : 0,
  allowingMultipleResources : 0,
}

//

/**
 * @summary Error throwing test. Executes provided `routine` and checks if it throws an Error asynchrounously.
 * @description
 * Provided routines should return instance of `wConsequence`. Also routine can accepts `wConsequence` instance as argument.
 * If check is positive then test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {Function|wConsequence} routine `wConsequence` instance or routine that returns it.
 *
 * @example
 * function sometest( test )
 * {
 *  test.shouldThrowErrorAsync( () => _.time.outError( 1000 ) );//returns true
 *  test.shouldThrowErrorAsync( () => _.time.out( 1000 ) );//returns false
 * }
 * wTester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method shouldThrowErrorAsync
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

function shouldThrowErrorAsync( routine )
{
  let tro = this;

  return tro._shouldDo
  ({
    args : arguments,
    expectingSyncError : 0,
    expectingAsyncError : 1,
  });

}

function shouldThrowErrorAsync_( routine )
{
  let tro = this;

  return tro._shouldDo_
  ({
    args : arguments,
    expectingSyncError : 0,
    expectingAsyncError : 1,
  });

}

//

/**
 * @summary Error throwing test. Executes provided `routine` and checks if it throws an Error synchrounously.
 * @description
 * If check is positive then test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {Function} routine Routine to execute.
 *
 * @example
 * function sometest( test )
 * {
 *  test.shouldThrowErrorSync( () => { throw 1 } );//returns true
 *  test.shouldThrowErrorSync( () => { console.log( 1 ) } );//returns false
 * }
 * wTester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method shouldThrowErrorSync
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

// function shouldThrowErrorSync( routine )
// {
//   let tro = this;
//
//   return tro._shouldDo
//   ({
//     args : arguments,
//     expectingSyncError : 1,
//     expectingAsyncError : 0,
//   });
//
// }

function shouldThrowErrorSync_( routine )
{
  let tro = this;

  return tro._shouldDo_
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
 * wTester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @example
 * function sometest( test )
 * {
 *  let consequence = new _.Consequence().take( null );
 *  consequence
 *  .ifNoErrorThen( function( arg )
 *  {
 *    test.case = 'shouldThrowErrorSync';
 *    let con = new _.Consequence( )
 *    .error( _.err() ); //wConsequence instance with error message
 *    return test.shouldThrowErrorSync( con );//test passes
 *  })
 *  .ifNoErrorThen( function( arg )
 *  {
 *    test.case = 'shouldThrowError2';
 *    let con = new _.Consequence( )
 *    .error( _.err() )
 *    .error( _.err() ); //wConsequence instance with two error messages
 *    return test.shouldThrowErrorSync( con ); //test fails
 *  });
 *
 *  return consequence;
 * }
 * wTester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @throws {Exception} If passed argument is not a Routine.
 * @method shouldThrowErrorSync
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

// function shouldThrowErrorOfAnyKind( routine )
// {
//   let tro = this;
//
//   return tro._shouldDo
//   ({
//     args : arguments,
//     expectingSyncError : 1,
//     expectingAsyncError : 1,
//   });
//
// }

function shouldThrowErrorOfAnyKind_( routine )
{
  let tro = this;

  return tro._shouldDo_
  ({
    args : arguments,
    expectingSyncError : 1,
    expectingAsyncError : 1,
  });

}

//

/**
 * @summary Error throwing test. Executes provided `routine` and checks if doesn't throw an Error synchrounously or asynchrounously.
 * @description
 * If check is positive then test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {Function} routine Routine to execute.
 *
 * @example
 * function sometest( test )
 * {
 *  test.mustNotThrowError( () => { throw 1 } );//returns false
 *  test.mustNotThrowError( () => _.time.out( 1000 ) );//returns true
 *  test.mustNotThrowError( () => _.time.outError( 1000 ) );//returns false
 *  test.mustNotThrowError( () => { console.log( 1 ) } );//returns true
 * }
 * wTester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method mustNotThrowError
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

// function mustNotThrowError( routine )
// {
//   let tro = this;
//
//   return tro._shouldDo
//   ({
//     args : arguments,
//     ignoringError : 0,
//     expectingSyncError : 0,
//     expectingAsyncError : 0,
//   });
//
// }

function mustNotThrowError_( routine )
{
  let tro = this;

  return tro._shouldDo_
  ({
    args : arguments,
    ignoringError : 0,
    expectingSyncError : 0,
    expectingAsyncError : 0,
  });

}

//

/**
 * @summary `wConsequence` messaging test. Executes provided `routine` and checks if returned `wConsequence` gives only one message.
 * @description
 * If check is positive then test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {Function} routine Routine to execute.
 *
 * @example
 * function sometest( test )
 * {
 *  test.returnsSingleResource( () => _.Consequence().take( null ) );//returns true
 *  test.returnsSingleResource( () => _.Consequence().take( null ).take( null ) );//returns false
 * }
 * wTester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method returnsSingleResource
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

// function returnsSingleResource( routine )
// {
//   let tro = this;
//
//   return tro._shouldDo
//   ({
//     args : arguments,
//     ignoringError : 1,
//     expectingSyncError : 0,
//     expectingAsyncError : 0,
//   });
//
// }

function returnsSingleResource_( routine )
{
  let tro = this;

  return tro._shouldDo_
  ({
    args : arguments,
    ignoringError : 1,
    expectingSyncError : 0,
    expectingAsyncError : 0,
  });

}

//

function assetFor( a )
{
  let tro = this;
  let context = tro.context;
  let suite = tro.suite;

  if( !_.mapIs( a ) )
  {
    if( _.boolIs( arguments[ 0 ] ) )
    a = { originalAssetPath : arguments[ 0 ] }
    else
    a = { assetName : arguments[ 0 ] }
  }

  _.assert( a.tro === undefined );
  _.assert( a.suite === undefined );
  _.assert( a.routine === undefined );
  _.routineOptions( assetFor, a );

  if( a.suiteTempPath === null && context.suiteTempPath !== undefined )
  a.suiteTempPath = context.suiteTempPath;
  if( a.assetsOriginalPath === null && context.assetsOriginalPath !== undefined )
  a.assetsOriginalPath = context.assetsOriginalPath;
  if( a.appJsPath === null && context.appJsPath !== undefined )
  a.appJsPath = context.appJsPath;

  a.tro = tro;
  a.suite = suite;
  a.routine = tro.routine;
  if( !a.assetName )
  a.assetName = a.routine.name;

  _.sure( arguments.length === 0 || arguments.length === 1 );
  _.sure( _.mapIs( a ) );
  _.sure( _.routineIs( a.routine ) );
  _.sure( _.strDefined( a.assetName ) );
  _.sure
  (
    _.strDefined( a.suiteTempPath ) || _.strDefined( a.routinePath ),
    `Test suite's context should have defined path to suite temp directory {- suiteTempPath -}. `
    + `But test suite ${suite.name} does not have.`
  );
  _.sure
  (
    a.assetsOriginalPath === null || _.strDefined( a.assetsOriginalPath ),
    `Test suite's context should have defined path to original asset directory {- assetsOriginalPath -}. `
    + `But test suite ${suite.name} does not have.`
  );
  _.sure
  (
    a.appJsPath === null || _.strDefined( a.appJsPath ),
    `Test suite's context should have defined path to default JS file {- appJsPath -}. `
    + `But test suite ${suite.name} does not have.`
  );

  Object.setPrototypeOf( a, context );

  if( a.process === null )
  a.process = _globals_.testing.wTools.process;
  if( a.fileProvider === null )
  {
    a.fileProvider = _.FileProvider.System({ providers : [] });
    _.FileProvider.Git().providerRegisterTo( a.fileProvider );
    _.FileProvider.Npm().providerRegisterTo( a.fileProvider );
    _.FileProvider.Http().providerRegisterTo( a.fileProvider );
    let defaultProvider = _.FileProvider.Default();
    defaultProvider.providerRegisterTo( a.fileProvider );
    a.fileProvider.defaultProvider = defaultProvider;
  }
  if( a.path === null )
  a.path = a.fileProvider.path || _globals_.testing.wTools.uri;
  if( a.uri === null )
  a.uri = _globals_.testing.wTools.uri || a.fileProvider.path;
  if( a.ready === null )
  a.ready = _.Consequence().take( null );

  if( _.boolLike( a.originalAssetPath ) && a.originalAssetPath )
  a.originalAssetPath = null
  if( a.originalAssetPath === null && a.assetsOriginalPath )
  a.originalAssetPath = a.path.join( a.assetsOriginalPath, a.assetName );
  if( a.routinePath === null )
  a.routinePath = a.path.join( a.suiteTempPath, a.routine.name );

  if( a.abs === null )
  a.abs = abs_functor( a.routinePath );
  if( a.rel === null )
  a.rel = rel_functor( a.routinePath );
  if( a.originalAbs === null && a.originalAssetPath )
  a.originalAbs = abs_functor( a.originalAssetPath );
  if( a.originalRel === null && a.originalAssetPath )
  a.originalRel = rel_functor( a.originalAssetPath );

  if( a.reflect === null )
  a.reflect = reflect;

  program_body.defaults =
  {
    routine : null,
    locals : null,
    dirPath : '.'
  }
  let program = _.routineUnite( program_head, program_body );

  if( a.program === null )
  a.program = program;

  if( a.shell === null )
  a.shell = a.process.starter
  ({
    currentPath : a.routinePath,
    outputCollecting : 1,
    outputGraying : 1,
    throwingExitCode : 1,
    ready : a.ready,
    mode : 'shell',
  })

  if( a.shellNonThrowing === null )
  a.shellNonThrowing = a.process.starter
  ({
    currentPath : a.routinePath,
    outputCollecting : 1,
    outputGraying : 1,
    throwingExitCode : 0,
    ready : a.ready,
    mode : 'shell',
  })

  if( a.appStart === null )
  a.appStart = a.process.starter
  ({
    execPath : a.appJsPath || null,
    currentPath : a.routinePath,
    outputCollecting : 1,
    throwingExitCode : 1,
    outputGraying : 1,
    ready : a.ready,
    mode : 'fork',
  })

  if( a.appStartNonThrowing === null )
  a.appStartNonThrowing = a.process.starter
  ({
    execPath : a.appJsPath || null,
    currentPath : a.routinePath,
    outputCollecting : 1,
    outputGraying : 1,
    throwingExitCode : 0,
    ready : a.ready,
    mode : 'fork',
  })

  if( a.fork === null )
  a.fork = a.process.starter
  ({
    currentPath : a.routinePath,
    outputCollecting : 1,
    throwingExitCode : 1,
    outputGraying : 1,
    ready : a.ready,
    mode : 'fork',
  })

  if( a.forkNonThrowing === null )
  a.forkNonThrowing = a.process.starter
  ({
    currentPath : a.routinePath,
    outputCollecting : 1,
    outputGraying : 1,
    throwingExitCode : 0,
    ready : a.ready,
    mode : 'fork',
  })

  if( a.find === null )
  a.find = a.fileProvider.filesFinder
  ({
    withTerminals : 1,
    withDirs : 1,
    withStem : 1,
    allowingMissed : 1,
    maskPreset : 0,
    outputFormat : 'relative',
    resolvingSoftLink : 1,
    resolvingTextLink : 1,
    filter :
    {
      recursive : 2,
      maskAll :
      {
        excludeAny : [ /(^|\/)\.git($|\/)/, /(^|\/)\+/ ],
      },
      maskTransientAll :
      {
        excludeAny : [ /(^|\/)\.git($|\/)/, /(^|\/)\+/ ],
      },
    },
  });

  if( a.findDirs === null )
  a.findDirs = a.fileProvider.filesFinder
  ({
    withTerminals : 0,
    withDirs : 1,
    withStem : 1,
    allowingMissed : 1,
    maskPreset : 0,
    resolvingSoftLink : 1,
    resolvingTextLink : 1,
    outputFormat : 'relative',
    filter :
    {
      recursive : 2,
      maskAll :
      {
        excludeAny : [ /(^|\/)\.git($|\/)/, /(^|\/)\+/ ],
      },
      maskTransientAll :
      {
        excludeAny : [ /(^|\/)\.git($|\/)/, /(^|\/)\+/ ],
      },
    },
  });

  if( a.findAll === null )
  a.findAll = a.fileProvider.filesFinder
  ({
    withTerminals : 1,
    withDirs : 1,
    withStem : 1,
    withTransient : 1,
    withDefunct : 1,
    allowingMissed : 1,
    allowingCycled : 1,
    resolvingSoftLink : 1,
    resolvingTextLink : 1,
    maskPreset : 0,
    outputFormat : 'relative',
    filter :
    {
      recursive : 2,
    }
  });

  if( a.originalAssetPath )
  {
    _.sure
    (
      a.fileProvider.isDir( a.originalAssetPath ),
      `Expects directory ${a.originalAssetPath} exists. Make one or change {- assetsOriginalPath -}`
    );
  }

  return a;

  /* */

  function abs_functor( routinePath )
  {
    _.assert( _.strIs( routinePath ) );
    _.assert( arguments.length === 1 );
    return function abs( filePath )
    {
      if( arguments.length === 1 && filePath === null )
      return filePath;
      let args = _.longSlice( arguments );
      args.unshift( routinePath );
      if( _.arrayIs( filePath ) || _.mapIs( filePath ) )
      return _.filter_( null, filePath, ( filePath ) => abs( filePath, ... args.slice( 2, args.length ) ) );
      return a.uri.s.join.apply( a.uri.s, args );
    }
  }

  /* */

  function rel_functor( routinePath )
  {
    _.assert( _.strIs( routinePath ) );
    _.assert( arguments.length === 1 );
    return function rel( filePath )
    {
      _.assert( arguments.length === 1 );
      if( filePath === null )
      return filePath;
      if( _.arrayIs( filePath ) || _.mapIs( filePath ) )
      return _.filter_( null, filePath, ( filePath ) => rel( filePath ) );
      if( a.uri.isRelative( filePath ) && !a.uri.isRelative( routinePath ) )
      return filePath;
      return a.uri.s.relative.apply( a.uri.s, [ routinePath, filePath ] );
    }
  }

  /* */

  function reflect()
  {
    _.assert( arguments.length === 0 );
    a.fileProvider.filesDelete( a.routinePath );
    if( a.originalAssetPath === false )
    a.fileProvider.dirMake( a.routinePath );
    else
    a.fileProvider.filesReflect({ reflectMap : { [ a.originalAssetPath ] : a.routinePath } });
    return null; /* qqq : cover a.reflect. make sure returned value is covered */
  }

  /**/

  function program_head( routine, args )
  {
    let o = args[ 0 ]

    if( !_.mapIs( o ) )
    o = { routine : o }
    _.routineOptions( program, o );
    _.assert( _.strIs( o.dirPath ) );
    _.assert( arguments.length === 2 );
    _.assert( args.length === 1 );

    return o;
  }

  /**/

  function program_body( o )
  {
    let a = this;

    _.assert( _.strIs( o.dirPath ) );
    _.assert( arguments.length === 1 );

    if( !o.tempPath )
    o.tempPath = a.abs( '.' );

    _.program.write( o );

    logger.log( _.strLinesNumber( o.sourceCode ) );

    return o.programPath;
  }

  /**/

}

assetFor.defaults =
{

  assetName : null,

  process : null,
  fileProvider : null,
  path : null,
  uri : null,
  ready : null,

  suiteTempPath : null,
  assetsOriginalPath : null,
  appJsPath : null,

  originalAssetPath : null,
  originalAbs : null,
  originalRel : null,
  routinePath : null,
  abs : null,
  rel : null,
  reflect : null,
  program : null,
  shell : null,
  shellNonThrowing : null,
  appStart : null,
  appStartNonThrowing : null,
  fork : null,
  forkNonThrowing : null,
  find : null,
  findAll : null,
  findDirs : null,

}

// --
// let
// --

let descriptionSymbol = Symbol.for( 'description' );
let accuracySymbol = Symbol.for( 'accuracy' );
let accuracyEffectiveSymbol = Symbol.for( 'accuracyEffective' );
let timeOutSymbol = Symbol.for( 'timeOut' );
let rapiditySymbol = Symbol.for( 'rapidity' );
let usingSourceCodeSymbol = Symbol.for( 'usingSourceCode' );

/**
 * @typedef {Object} RoutineFields
 * @property {Boolean} experimental
 * @property {Number} routineTimeOut
 * @property {Number} timeOut
 * @property {Number} accuracy
 * @property {Number} rapidity
 * @property {Boolean} usingSourceCode
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

let RoutineFields =
{
  experimental : 'experimental',
  routineTimeOut : 'timeOut',
  timeOut : 'timeOut',
  accuracy : 'accuracy',
  rapidity : 'rapidity',
  usingSourceCode : 'usingSourceCode',
  description : 'routineDescription', /* qqq : implement separate test routine per each test routine option */
}

/**
 * @typedef {Object} TestRoutineFields
 * @property {String} name
 * @property {String} description
 * @property {Number} accuracy
 * @property {Number} rapidity=3
 * @property {Number} timeOut
 * @property {Boolean} experimental
 * @property {Boolean} usingSourceCode
 * @class wTestRoutineObject
 * @module Tools/atop/Tester
 */

// --
// relations
// --

let Composes =
{
  name : null,
  description : '',
  accuracy : null,
  rapidity : 0,
  timeOut : null,
  experimental : 0,
  usingSourceCode : null,
  routineDescription : null,
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

  _formed : 0,
  _checkIndex : 1,
  _checksStack : _.define.own( [] ),
  _groupOpenedWithCase : 0,
  _testCheckPassesOfTestCase : 0,
  _testCheckFailsOfTestCase : 0,
  _groupError : null,
  _groupsStack : _.define.own( [] ),

  _testRoutineBeginTime : null,
  _returned : null,
  _exitCode : null,
  _returnedCon : null,
  _originalReturnedCon : null,
  _returnedHow : 0,
  _returnedData : null,
  _timeLimitCon : null,
  _timeLimitErrorCon : null,
  report : null,

}

let Statics =
{
  RoutineFields,
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

let Accessors =
{

  description : 'description',
  will : 'will',
  case : 'case',
  accuracy : 'accuracy',
  timeOut : 'timeOut',
  rapidity : 'rapidity',
  usingSourceCode : 'usingSourceCode',

  group : { writable : 0 },
  descriptionFull : { writable : 0 },
  descriptionWithName : { writable : 0 },
  accuracyEffective : { writable : 0 },
  runnable : { writable : 0 },

  qualifiedName : { writable : 0 },
  decoratedQualifiedName : { writable : 0 },
  absoluteName : { writable : 0 },
  decoratedAbsoluteName : { writable : 0 },

}

// --
// declare
// --

let Extension =
{

  // inter

  init,
  form,
  _fieldsForm,

  // accessor

  _accuracySet,
  _accuracyGet,
  _accuracyEffectiveGet,
  _accuracyChange,

  _timeOutGet,
  _timeOutSet,

  _rapidityGet,
  _rapiditySet,

  _usingSourceCodeGet,
  _usingSourceCodeSet,

  // run

  _run,
  _runBegin,
  _runEnd,
  _runFinally,

  _runInterruptMaybe,
  _returnedVerification,
  _runnableGet,
  _timeOutError,
  cancel,

  // check description

  _willGet : _descriptionGet,
  _willSet : _descriptionSet,
  _descriptionGet,
  _descriptionSet,
  _descriptionChange,
  _descriptionFullGet,
  _descriptionWithNameGet,

  // checks group

  _groupGet,
  groupOpen,
  groupClose,
  open : groupOpen,
  close : groupClose,
  _groupChange,
  _groupTestEnd,
  _groupingErorr,

  _caseGet,
  _caseSet,
  _caseClose,
  _caseChange,

  // name

  qualifiedNameGet,
  decoratedQualifiedNameGet,
  absoluteNameGet,
  decoratedAbsoluteNameGet,

  // check

  checkCurrent,
  checkNext,
  checkStore,
  checkRestore,

  // consider

  _testCheckConsider,
  _testCaseConsider,
  _exceptionConsider,

  // report

  _outcomeLog,
  _outcomeReport,
  _outcomeReportBoolean,
  _outcomeReportCompare,
  exceptionReport,

  _reportBegin,
  _reportEnd,
  _reportIsPositive,
  _reportTextForTestCheck,

  // checker

  true : _true,
  false : _false,

  identical,
  notIdentical,
  equivalent,
  notEquivalent,

  contains,
  containsAll,
  containsAny,
  containsOnly,
  containsNone,

  il : identical,
  ni : notIdentical,
  et : equivalent,
  ne : notEquivalent,

  gt,
  ge,
  lt,
  le,

  // shoulding

  // _shouldDo,
  _shouldDo_,

  shouldThrowErrorSync : shouldThrowErrorSync_, /* aaa : cover second argument */ /* Dmytro : covered */ /* !!! use instead of shouldThrowErrorSync */ /* Dmytro : refactored routine _shouldDo_ is used */
  shouldThrowErrorSync_,
  shouldThrowErrorAsync : shouldThrowErrorAsync_, /* aaa : cover second argument */ /* Dmytro : covered */ /* !!! use instead of shouldThrowErrorAsync */ /* Dmytro : refactored routine _shouldDo_ is used */
  shouldThrowErrorAsync_,
  shouldThrowErrorOfAnyKind : shouldThrowErrorOfAnyKind_, /* aaa : cover second argument */ /* Dmytro : covered */ /* !!! use instead of shouldThrowErrorOfAnyKind */ /* Dmytro : refactored routine _shouldDo_ is used */
  shouldThrowErrorOfAnyKind_,
  mustNotThrowError : mustNotThrowError_, /* !!! use instead of mustNotThrowError */ /* Dmytro : refactored routine _shouldDo_ is used */
  mustNotThrowError_,
  returnsSingleResource : returnsSingleResource_, /* !!! use instead of returnsSingleResource */ /* Dmytro : refactored routine _shouldDo_ is used */
  returnsSingleResource_,

  // asset

  assetFor,

  // relations

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Events,
  Forbids,
  Accessors,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extension,
});

_.Copyable.mixin( Self );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
wTesterBasic[ Self.shortName ] = Self;

})();
