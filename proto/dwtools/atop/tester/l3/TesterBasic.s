( function _TesterBasic_s_( ) {

'use strict';

/**
 * Framework for convenient unit testing. Testing provides the intuitive interface, simple tests structure, asynchronous code handling mechanism, colorful report, verbosity control and more. Use the module to get free of routines which can be automated..
  @module Tools/Tester
*/

/**
 * @file Main.bse.s
 */

//

let _global = _global_;
let _ = _global.wTools;
let sourceFileLocation = _.diagnosticLocation().full;
let sourceFileStack = _.diagnosticStack();

if( wTester._isReal_ )
{
  console.log( 'WARING : wTesting included several times!' );
  console.log( '' );
  console.log( 'First time' );
  console.log( wTester.sourceFileStack );
  console.log( '' );
  console.log( 'Second time' );
  console.log( sourceFileStack );
  console.log( '' );
  debugger;
  _.assert( 0 );
  return;
}

_.assert( _.routineIs( _.toStr ), 'wTesting needs Stringer' );
_.assert( _.routineIs( _.process.start ), 'wTesting needs ProcessBasic' );
_.assert( _.routineIs( _.execStages ), 'wTesting needs RoutineBasic' );
_.assert( _.routineIs( _.Consequence ), 'wTesting needs Consequence' );
_.assert( _.numberIs( _.accuracy ), 'wTesting needs _.accuracy' );
_.assert( _.printerIs( _global.logger ), 'wTesting needs Logger' );

//

let Parent = null;
let Self = function wTesterBasic( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Tester';

// --
// inter
// --

function finit()
{
  if( this.formed )
  this.unform();
  return _.Copyable.prototype.finit.apply( this, arguments );
}

//

function init( o )
{
  let tester = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  let logger = tester.logger = new _.Logger({ output : _global.logger, name : 'Tester', verbosity : 4 });

  _.workpiece.initFields( tester );
  Object.preventExtensions( tester );

  _.assert( logger === tester.logger );

  if( o )
  tester.copy( o );

}

//

function unform()
{
  let tester = this;

  _.assert( arguments.length === 0 );
  _.assert( !!tester.formed );

  /* begin */

  /* end */

  tester.formed = 0;
  return tester;
}

//

function form()
{
  let tester = this;

  if( tester.formed >= 1 )
  return tester;

  _.process.exitHandlerRepair();

  tester.FormSuites();
  tester.formAssociates();

  // tester._registerExitHandler();

  _.assert( arguments.length === 0 );
  _.assert( !tester.formed );

  tester.formed = 1;
  return tester;
}

//

function FormSuites()
{

  var testsWas = _realGlobal_.wTests;
  _realGlobal_.wTests = _global_.wTests = _realGlobal_.wTestSuite.InstancesMap;

  if( testsWas )
  _realGlobal_.wTestSuite.prototype.Froms( testsWas );

}

//

function formAssociates()
{
  let tester = this;
  let logger = tester.logger;

  _.assert( arguments.length === 0 );
  _.assert( !tester.formed );
  _.assert( !!logger );
  _.assert( logger.verbosity === tester.verbosity );

  if( !tester.fileProvider )
  tester.fileProvider = _.FileProvider.Default();
  let logger2 = new _.Logger({ output : logger, name : 'tester.providers' });
  tester.fileProvider.logger = logger2;

  _.assert( tester.fileProvider.logger === logger2 );
  _.assert( logger.verbosity === tester.verbosity );
  _.assert( tester.fileProvider.logger !== tester.logger );

  tester._verbosityChange();

  _.assert( logger2.verbosity <= logger.verbosity );
}

// --
// exec
// --

/**
 * @summary Parses arguments provided to tester. Resolves path provided to the tester.
 * @description List of possible arguments( options ) can be found {@link module:Tools/Tester.wTester.SettingsNameMap here}.
 * @function appArgsRead
 * @memberof module:Tools/Tester.wTester
 */

function appArgsRead()
{
  let tester = this;
  let logger = tester.logger;
  let settings = tester.settings;

  if( tester._appArgs )
  return tester._appArgs;

  let o = _.routineOptions( appArgsRead, arguments );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.mapExtend( settings, tester.Settings );

  let appArgs = _.process.args();
  if( o.propertiesMap !== null )
  appArgs.propertiesMap = o.propertiesMap;
  if( o.subject !== null )
  appArgs.subject = o.subject;

  let readOptions =
  {
    propertiesMap : appArgs.propertiesMap,
    dst : settings,
    namesMap : tester.SettingsNameMap,
    removing : 0,
    only : 1,
  }

  _.process.argsReadTo( readOptions );
  if( appArgs.err )
  throw _.errBrief( appArgs.err );

  _.assert( _.mapIs( appArgs.map ) );

  if( !appArgs.map )
  appArgs.map = Object.create( null );

  _.mapExtend( settings, _.mapOnly( appArgs.map, tester.Settings ) );

  let v = settings.verbosity;
  _.assert( v === null || v === undefined || _.boolLike( v ) || _.numberIs( v ) );
  if( v === null || v === undefined )
  settings.verbosity = tester.verbosity;

  if( settings.beeping === null )
  settings.beeping = !!settings.verbosity;

  tester._appArgs = appArgs;

  tester.filePath = appArgs.subject || _.path.current();
  tester.filePath = _.path.join( _.path.current(), tester.filePath );

  // if( appArgs.subject && !appArgs.map.scenario )
  // settings.scenario = 'test';

  if( settings.negativity !== undefined && settings.negativity !== null )
  tester.negativity = Number( settings.negativity ) || 0;

  tester.verbosity = settings.verbosity;

  return appArgs;
}

appArgsRead.defaults =
{
  subject : null,
  propertiesMap : null,
}

//

/**
 * @summary Runs the tester.
 * @description Tester will find test suites at provided path and execute them one by one.
 * If path is not provided explicitly tester will use path to current working directory.
 * During execution tester prints useful information about current state of execution. Level of output can be controled by options.
 * Path and options are be provided through command line arguments:
 * `wtest [ path ] [ options...]`
 * Path can be relative or absolute. Path can lead to single test suite or to directory with test suites.
 * Option is a combination of `key` and `value` splitted by delimeter `:`. Options should have at least one space between each other.
 * Spaces between `key` and `value` are supported: `v:5` and `v  :  5` are treated in same way.
 * @function scenarioTest
 * @example
 *  wtest .run proto/** v : 5
 * @memberof module:Tools/Tester.wTester
 */

function scenarioTest()
{
  let tester = this;
  let result;

  try
  {
    _.assert( arguments.length === 0 );
    _.assert( tester.settings.scenario === undefined );

    tester.suitesIncludeAt( tester.filePath );
    result = tester.testAll();

  }
  catch( err )
  {
    err = _.errLogOnce( err );
    _.process.exitCode( -1 );
    _.diagnosticBeep();
    _.diagnosticBeep();
    return;
    throw err;
  }

}

//

/**
 * @summary Prints list of available options.
 * @function scenarioOptionsList
 * @memberof module:Tools/Tester.wTester
 */

function scenarioOptionsList()
{
  let tester = this;
  let logger = tester.logger;

  let strOptions =
  {
    levels : 3,
    wrap : 0,
    stringWrapper : '',
    multiline : 1
  };

  logger.log( 'Tester options' );
  logger.log( _.toStr( tester.ApplicationArgumentsMap, strOptions ), '\n' );
}

//

/**
 * @summary Prints list of found tests suites.
 * @function scenarioSuitesList
 * @memberof module:Tools/Tester.wTester
 */

function scenarioSuitesList()
{
  let tester = this;
  let logger = tester.logger;

  // _.assert( tester.settings.scenario === 'suites.list' );
  _.assert( tester.settings.scenario === undefined );

  tester.suitesIncludeAt( tester.filePath );
  tester.suitesListPrint( tester.suitesFilterOut() );

}

// --
// run
// --

function _testAllAct()
{
  let tester = this;

  _.assert( arguments.length === 0 );

  tester.appArgsRead();
  let suites = tester.suitesFilterOut();
  return tester._suitesRun( suites );
}

//

/**
 * @summary Executes all found test suites.
 * @description Tests suites are executed one by one. After execution tester prints summary info.
 * @function testAll
 * @memberof module:Tools/Tester.wTester
 */

let testAll = _.timeReadyJoin( undefined, _testAllAct );

//

function _test()
{
  let tester = this;

  if( arguments.length === 0 )
  return tester._testAllAct();

  tester.appArgsRead();
  let args = _.arrayFlatten( null, arguments );
  let suites = tester.suitesFilterOut( args );
  return tester._suitesRun( suites );
}

//

/**
 * @summary Executes single or several tests suites.
 * @description Names of desirable test suites can be provided through argument `suites`.
 * Runs all found test suite if no arguent provided.
 * @param {Array} suites Names of test suites to run.
 * @function test
 * @memberof module:Tools/Tester.wTester
 */

let test = _.timeReadyJoin( undefined, _test );

//

function _testingBegin( allSuites, runSuites )
{
  let tester = this;
  let logger = tester.logger;

  if( tester.state === 'begin' )
  return;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.numberIs( tester.verbosity ) );
  _.assert( _.mapIs( allSuites ) );
  _.assert( _.mapIs( runSuites ) );
  _.assert( logger.hasOutput( _global.logger, { deep : 0, withoutOutputToOriginal : 0 } ), 'Logger of the tester does not have global logger in outputs.' );
  _.assert( tester.state === null );

  if( !tester.report )
  tester._reportBegin();

  tester._canceled = 0;
  tester.state = 'begin';

  if( tester.settings.timing )
  tester._testingBeginTime = _.timeNow();

  logger.begin({ verbosity : -5 });
  logger.log( 'Tester Settings :' );
  logger.log( tester.settings );
  logger.log( '' );
  logger.end({ verbosity : -5 });

  logger.begin({ verbosity : -3 });

  /* */

  let total = _.entityLength( runSuites );
  logger.log( 'Launching several ( ' + total + ' ) test suite(s) ..' );
  logger.up();
  logger.begin({ verbosity : -5 });
  tester.suitesListPrint( allSuites );
  logger.end({ verbosity : -5 });

  logger.log();
  logger.end({ verbosity : -3 });

  /* */

  tester._cancelCon.cancel();

}

//

function _testingEndSoon()
{
  let tester = this;

  _.assert( arguments.length === 0 );

  if( tester._reportIsPositive() )
  return _.timeOut( tester.settings.sanitareTime, () => tester._testingEndNow() );
  else
  tester._testingEndNow();

  return null;
}

//

function _testingEndNow()
{
  let tester = this;
  let logger = tester.logger;
  let ok = tester._reportIsPositive();

  _.assert( arguments.length === 0 );
  _.assert( tester.state === 'begin' );

  tester.state = 'end';

  if( tester.settings.beeping )
  _.diagnosticBeep();

  // if( !ok && !_.process.exitCode() )
  if( !ok )
  {
    if( tester.settings.beeping )
    _.diagnosticBeep();
    _.process.exitCode( -1 );
  }

  /* */

  let msg = tester._reportToStr();
  logger.begin({ verbosity : -2 });
  logger.begin({ 'connotation' : ok ? 'positive' : 'negative' });
  logger.log( '\n' + msg );
  logger.end({ verbosity : -2 });

  /* */

  logger.begin({ verbosity : -1 });

  let timingStr = '';
  if( tester.settings.timing )
  {
    tester.report.timeSpent = _.timeNow() - tester._testingBeginTime;
    timingStr = ' ... in ' + _.timeSpentFormat( tester.report.timeSpent );
  }

  msg = 'Testing' + timingStr + ' ... '  + ( ok ? 'ok' : 'failed' );
  msg = tester.textColor( msg, ok );

  logger.logDown( msg );

  logger.end({ 'connotation' : ok ? 'positive' : 'negative' });

  /* */

  logger.end({ verbosity : -1 });

  /* */

  // logger.verbosityPop();

  _.assert( logger.hasOutput( _global.logger, { deep : 0, withoutOutputToOriginal : 0 } ), 'Logger of the tester does not have global logger in outputs.' );

  _.procedure.terminationBegin();

  if( !ok )
  _.timeOut( 100, function()
  {
    _.process.exit();
  });

  return ok;
}

//

function _canContinue()
{
  let tester = this;

  if( tester._canceled )
  {
    debugger;
    return false;
  }

  if( tester.settings.fails > 0 )
  if( tester.settings.fails <= tester.report.testCheckFails )
  {
    debugger;
    let err = _.err( 'Too many fails', tester.settings.fails, '<=', trd.report.testCheckFails );
    tester.report.errorsArray.push( err );
    return false;
  }

  return true;
}

//

/**
 * @summary Stops execution of the tester.
 * @description There are several reasons to stop the execution:
 * 1. Exectuion can be terminated by a used, for example, by CTRL+C combination.
 * 2. Execution of test suite throws unhandled error.
 * @function cancel
 * @memberof module:Tools/Tester.wTester
 */

function cancel()
{
  let tester = this;

  if( tester.settings.fails > 0 )
  if( tester.settings.fails <= tester.report.testCheckFails )
  o.global = 1;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  let o = _.routineOptions( cancel, arguments );

  if( o.terminatedByUser )
  o.global = 1;
  if( tester._canceled )
  return tester.report.errorsArray[ tester.report.errorsArray.length-1 ];

  if( o.err === undefined )
  o.err = tester.report.errorsArray[ tester.report.errorsArray.length-1 ];
  o.err = _.err( o.err );

  if( o.global )
  {
    tester._cancelCon.error( o.err );
    tester._canceled = 1;
  }

  /* */

  if( o.global )
  try
  {
    debugger;
    for( let t = 0 ; t < tester.activeRoutines.length ; t++ )
    if( tester.activeRoutines[ t ]._returnCon )
    {
      if( tester.activeRoutines[ t ]._returnCon.resourcesCount() === 0 )
      tester.activeRoutines[ t ]._returnCon.error( o.err );
      // tester.activeRoutines[ t ]._returnCon.cancel();
    }
  }
  catch( err2 )
  {
    debugger;
    logger.log( err2 );
  }

  /* */

  if( o.terminatedByUser ) try
  {
    for( let t = 0 ; t < tester.activeSuites.length ; t++ )
    tester.activeSuites[ t ]._end( o.err );
  }
  catch( err2 )
  {
    debugger;
    logger.log( err2 );
  }

  return o.err;
}

let defaults = cancel.defaults = Object.create( null );
defaults.err = null;
defaults.terminatedByUser = 0;
defaults.global = 0;

// --
// suites
// --

function _suitesRun( suites )
{
  let tester = this;
  let logger = tester.logger;

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( suites ) );

  /* */

  let allSuites = _.mapExtend( null, suites );
  for( let s in suites )
  {
    let suite = wTesterBasic.TestSuite.instanceByName( suites[ s ] );
    suites[ s ] = suite;
    allSuites[ s ] = suite;

    if( !suite.enabled )
    {
      delete suites[ s ];
      continue;
    }

    try
    {
      _.assert( suite instanceof wTesterBasic.TestSuite, 'Test suite', s, 'was not found' );
      suite._form();
    }
    catch( err )
    {
      err = _.errLogOnce( err );
      return new _.Consequence().error( err );
    }

  }

  if( !_.mapKeys( suites ).length )
  {
    tester.suitesListPrint( allSuites );
    logger.log( 'No enabled test suite to run at', wTester.textColor( tester.filePath, 'path' ) );
    _.process.exitCode( -1 );
  }

  tester._testingBegin( suites, allSuites );

  /* */

  let con = new _.Consequence().take( [] );

  for( let s in suites )
  {
    let suite = suites[ s ];
    con.andKeepAccumulative( suite._runSoon() );
  }

  return con;
}

//

/**
 * @summary Selects desirable test suites using list from argument `suites`. Returns map with instances of {@link module:Tools/Tester.wTestSuite}
 * @param {Array} suites Names of test suites to run.
 * @throws {Error} If test suite doesn't exist.
 * @function suitesFilterOut
 * @memberof module:Tools/Tester.wTester
 */

function suitesFilterOut( suites )
{
  let tester = this;
  let logger = tester.logger;
  suites = suites || wTests;

  if( _.longIs( suites ) )
  {
    let _suites = Object.create( null );

    for( let s = 0 ; s < suites.length ; s++ )
    {
      let suite = suites[ s ];
      if( _.strIs( suite ) )
      _suites[ suite ] = suite;
      else if( suite instanceof wTesterBasic.TestSuite )
      _suites[ suite.name ] = suite;
      else _.assert( 0, 'not tested' );
    }

    suites = _suites;
  }

  _.assert( arguments.length === 0 || arguments.length === 1, 'Expects none or single argument, but got', arguments.length );
  _.assert( _.objectIs( suites ) );

  suites = _.entityFilter( suites, function( suite )
  {
    if( _.strIs( suite ) )
    {
      if( !wTests[ suite ] )
      throw _.err( 'Tester : test suite', suite, 'not found' );
      suite = wTests[ suite ];
    }
    if( suite.abstract )
    return;
    return suite;
  });

  return suites;
}

//

/**
 * @summary Prints information about provided test `suites`.
 * @description Prints info about all test suites if they are not provided explicitly.
 * @param {Array|Object} suites Entity with instances of {@link module:Tools/Tester.wTestSuite}
 * @function suitesListPrint
 * @memberof module:Tools/Tester.wTester
 */

function suitesListPrint( suites )
{
  let tester = this;
  let logger = tester.logger;
  suites = suites || wTests;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  _.each( suites, function( suite, k )
  {
    if( suite.enabled )
    logger.log( suite.suiteFileLocation, '-', ( suite.enabled ? 'enabled' : 'disabled' ) );
  });

  _.each( suites, function( suite, k )
  {
    if( !suite.enabled )
    logger.log( suite.suiteFileLocation, '-', ( suite.enabled ? 'enabled' : 'disabled' ) );
  });

  let l = _.entityLength( suites );

  logger.log( l, l > 1 ? 'test suites' : 'test suite' );

}

//

function _suitesIncludeAt( path )
{
  let tester = this;
  let logger = tester.logger;
  path = _.path.join( _.path.current(), path );

  _.assert( _.numberIs( tester.negativity ) );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( path ), 'Expects string' );

  if( !tester.report )
  tester._reportBegin();

  if( tester.verbosity > 1 )
  logger.log( 'Includes tests from :', path, '\n' );

  let ends = [ '.test.s' ];
  ends.push( '.test.js' );
  ends.push( '.test.ss' );

  let maskAll = _.files.regexpMakeSafe
  ({
    excludeAny : [ /(?:^|\/)_/ ],
  });
  let files = tester.fileProvider.filesFind
  ({
    filePath : path,
    filter :
    {
      ends : ends,
      maskAll : maskAll,
      recursive : 2,
    }
  });

  if( !files.length )
  {
    let record = tester.fileProvider.recordFactory({ allowingMissed : 1 }).record( path );
    if( record.stat && !record.stat.isDir() && record.isActual )
    files = [ record ];
  }

  for( let f = 0 ; f < files.length ; f++ )
  {
    if( !files[ f ].stat.isTerminal() )
    continue;
    let absolutePath = files[ f ].absolute;

    try
    {
      require( tester.fileProvider.path.nativize( absolutePath ) );
    }
    catch( err )
    {
      debugger;
      err = _.err( err, '\nCant include', absolutePath );
      _.errAttend( err );
      tester._includeFailConsider( err );

      if( tester.settings.coloring )
      logger.error( _.color.strFormatForeground( 'Cant include ' + absolutePath, 'red' ) );
      else
      logger.error( 'Cant include ' + absolutePath );

      if( logger.verbosity + tester.negativity >= 4 )
      logger.error( _.err( err ) );
    }

  }

}

//

/**
 * @summary Includes test suite from provided `path`.
 * @param {String} path Path can be relative or absolute. Path can lead to single suite or to directory with several test suites.
 * @function suitesIncludeAt
 * @memberof module:Tools/Tester.wTester
 */

function suitesIncludeAt( path )
{
  let tester = this;
  let logger = tester.logger;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( path ), 'Expects string' );

  logger.verbosityPush( tester.verbosity );

  try
  {
    tester._suitesIncludeAt( path );
  }
  catch( err )
  {
    throw _.errLogOnce( _.errBrief( err ) );
  }

  logger.verbosityPop();
}

// --
// etc
// --

function _verbositySet( src )
{
  let tester = this;
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !_.numberIsNotNan( src ) )
  src = 0;

  if( src !== null )
  if( tester.logger )
  tester.logger.verbosity = src;

  tester._verbosityChange();

}

//

function _verbosityGet()
{
  let tester = this;
  if( !tester.logger )
  return 9;
  return tester.logger.verbosity;
}

//

function _verbosityChange()
{
  let tester = this;

  _.assert( arguments.length === 0 );
  _.assert( !tester.fileProvider || tester.fileProvider.logger !== tester.logger );

  if( tester.fileProvider )
  tester.fileProvider.verbosity = tester.verbosity-2;

}

// --
// report
// --

function _reportBegin()
{
  let tester = this;

  _.assert( !tester.report, 'tester already has report' );

  let report = tester.report = Object.create( null );

  report.outcome = null;
  report.timeSpent = null;
  report.errorsArray = [];
  report.includeErrorsArray = [];
  report.appExitCode = null;

  report.testCheckPasses = 0;
  report.testCheckFails = 0;

  report.testCasePasses = 0;
  report.testCaseFails = 0;
  report.testCaseNumber = 0;

  report.testRoutinePasses = 0;
  report.testRoutineFails = 0;

  report.testSuitePasses = 0;
  report.testSuiteFails = 0;

  Object.preventExtensions( report );
}

//

function _reportEnd()
{
  let tester = this;
  let report = tester.report;

  if( !report.appExitCode )
  report.appExitCode = _.process.exitCode();

  if( report.appExitCode !== undefined && report.appExitCode !== null && report.appExitCode !== 0 )
  report.outcome = false;

  if( report.testCheckFails !== 0 )
  report.outcome = false;

  if( report.testRoutineFails !== 0 )
  report.outcome = false;

  if( report.testSuiteFails !== 0 )
  report.outcome = false;

  if( !( report.testCheckPasses > 0 ) )
  report.outcome = false;

  if( report.testCaseFails !== 0 )
  report.outcome = false;

  if( report.errorsArray.length )
  report.outcome = false;

  if( report.includeErrorsArray.length )
  report.outcome = false;

  if( report.outcome === null )
  report.outcome = true;

  return report.outcome;
}

//

function _reportToStr()
{
  let tester = this;
  let report = tester.report;
  let msg = '';

  if( report.appExitCode !== undefined && report.appExitCode !== null && report.appExitCode !== 0 )
  msg = 'ExitCode : ' + report.appExitCode + '\n';

  if( report.errorsArray.length )
  msg += 'Thrown ' + ( report.errorsArray.length ) + ' error(s)\n';

  msg += 'Passed test checks ' + ( report.testCheckPasses ) + ' / ' + ( report.testCheckPasses + report.testCheckFails ) + '\n';
  msg += 'Passed test cases ' + ( report.testCasePasses ) + ' / ' + ( report.testCasePasses + report.testCaseFails ) + '\n';
  msg += 'Passed test routines ' + ( report.testRoutinePasses ) + ' / ' + ( report.testRoutinePasses + report.testRoutineFails ) + '\n';
  msg += 'Passed test suites ' + ( report.testSuitePasses ) + ' / ' + ( report.testSuitePasses + report.testSuiteFails ) + '';

  return msg;
}

//

function _reportIsPositive()
{
  let tester = this;
  let report = tester.report;

  if( !report )
  return false;

  tester._reportEnd();

  return report.outcome;
}

//

/**
 * @summary Styles string with colors of some specific format.
 * @description One of possible formats are: `green` and `red`. As the result string will have green or red foreground color.
 * List of possible formats can be found {@link @module:Tools/mid/Color.Style}
 * @param {String} srcStr Text string
 * @param {String} format Desirable format.
 * @function textColor
 * @memberof module:Tools/Tester.wTester
 */

function textColor( srcStr, format )
{
  let tester = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.boolLike( tester.settings.coloring ) );
  _.assert( _.mapIs( format ) || _.strIs( format ) || _.boolLike( format ) );

  if( !tester.settings.coloring )
  return srcStr;

  if( !_.color || !_.color.strFormat )
  return srcStr;

  if( _.mapIs( format ) || _.strIs( format ) )
  {
    return _.color.strFormat( srcStr, format );
  }

  let light = [ ' ok', ' failed' ];
  let gray = [ /test check/i, /test routine/i, /test ceck/i, '/', ' # ', ' < ', ' > ', '(', ')', ' ... in', ' in ', ' ... ', ' .. ', ':' ];
  let splits = _.strSplit
  ({
    src : srcStr,
    delimeter : _.arrayAppendArrays( [], [ light, gray ] ),
    stripping : 0,
    preservingDelimeters : 1,
  });

  splits = splits.map( function( e, i )
  {
    if( i % 2 === 0 )
    return e;
    return _.color.strFormat( e, { fg : ( format ? 'green' : 'red' ) } );
  });

  return splits.join( '' );
}

// --
// consider
// --

function _testCheckConsider( outcome )
{
  let tester = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  // _.assert( tester === Self );

  if( outcome )
  {
    tester.report.testCheckPasses += 1;
  }
  else
  {
    tester.report.testCheckFails += 1;
  }

}

//

function _testCaseConsider( outcome )
{
  let tester = this;
  let report = tester.report;

  if( outcome )
  {
    report.testCasePasses += 1;
  }
  else
  {
    report.testCaseFails += 1;
  }

}

//

function _testRoutineConsider( outcome )
{
  let tester = this;
  let report = tester.report;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( outcome )
  {
    report.testRoutinePasses += 1;
  }
  else
  {
    report.testRoutineFails += 1;
  }

}

//

function _testSuiteConsider( outcome )
{
  let tester = this;
  let report = tester.report;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( outcome )
  {
    report.testSuitePasses += 1;
  }
  else
  {
    report.testSuiteFails += 1;
  }

}

//

function _exceptionConsider( err )
{
  let tester = this;
  _.assert( arguments.length === 1, 'Expects single argument' );
  // tester.report.errorsArray.push( err );
  _.arrayAppendOnce( tester.report.errorsArray, err );
}

//

function _includeFailConsider( err )
{
  let tester = this;
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.arrayAppendOnce( tester.report.includeErrorsArray, err );
}

// --
// relations
// --

/**
 * @enum {String} ApplicationArgumentsMap
 * @memberof module:Tools/Tester.wTester
*/

let ApplicationArgumentsMap =
{

  verbosity :  `Sets the verbosity of report. Accepts a value from 0 to 9. Default value is 4.`,
  routine : `Testing of separate test routine. Accepts name of test routine.`,
  testRoutineTimeOut : `Limits the testing time for test routines. Accepts time in milliseconds. Default value is 5000ms.`,
  accuracy : `Sets the numeric deviation for the comparison of numerical values. Accepts numeric values of deviation. Default value is 1e-7.`,
  sanitareTime : `Sets the delay between completing the test suite and running the next one. Accepts time in milliseconds. Default value is 2000ms.`,
  negativity : `Restricts the console output of passed routines and increases output of failed test checks. Accepts a value from 0 to 9. Default value is 1.`,
  silencing : `Enables hiding the console output from the test object. Accepts 0 or 1. Default value is 0.`,
  shoulding : `Disables negative testing. Accepts 0 or 1. Default value is 0.`,
  fails : `Sets the number of errors received to interrupt the test. Accepts number of fails. By default is unlimited.`,
  beeping : `Disables the beep after test completion. Accepts 0 or 1. Default value is 1.`,
  coloring : `Makes report colourful. Accepts 0 or 1. Default value is 1.`,
  timing : `Disables measurement of time spent on testing. Accepts 0 or 1. Default value is 1.`,
  debug : `Sets value of Config.debug. Accepts 0 or 1. Default value is null, utility does not change debug mode of test object.`,
  rapidity : `Controls the amount of time spent on testing. Accepts values from -9 to +9. Default value is 0.`,
  concurrent : `Enables parallel execution of test suites. Accepts 0 or 1. Default value is 0.`,

  // scenario : 'Name of scenario to launch. To get scenarios list use scenario : "scenarios.list". Try: "node Some.test.js scenario:scenarios.list"',
  // sanitareTime : 'Delay between runs of test suites and after the last to get sure nothing throwen asynchronously later.',
  // fails : 'Maximum number of fails allowed before shutting down testing.',
  // beeping : 'Make diagnosticBeep sound after testing to let developer know it\'s done.',
  // coloring : 'Switch on/off coloring.',
  // timing : 'Switch on/off measuing of time.',
  // rapidity : 'How rapid teststing should be done. Increasing of the option decrase number of test routine to be executed. For rigorous testing -9 .. -5 should be used. +9 for the fastest testing. Default is 0.',
  //
  // routineTimeOut : 'Limits the time that each test routine can use. If execution of routine takes too long time then fail will be reaported and error throwen. Default is 5000 ms.',
  // concurrent : 'Runs test suite in parallel with other test suites.',
  // concurrent : 'Runs test suite in parallel with other test suites.',
  // verbosity : 'Level of details of report. Zero for nothing, one for single line report, nine for maximum verbosity. Default is 5. Short-cut: "v". Try: "node Some.test.js v:2"',
  // negativity : 'Increase verbosity of test checks which fails. It helps to see only fails and hide passes. Default is 9. Short-cut: "n".',
  // silencing : 'Hooking and silencing of object\'s of testing console output to make clean report of testing.',
  // shoulding : 'Switch on/off all should* tests checks.',
  // accuracy : 'Change default accuracy. Each test routine could have own accuracy, which cant be overwritten by this option.',

}

/**
 * @enum {String} SettingsNameMap
 * @memberof module:Tools/Tester.wTester
*/

let SettingsNameMap =
{

  'scenario' : 'scenario',
  'sanitareTime' : 'sanitareTime',
  'fails' : 'fails',
  'beeping' : 'beeping',
  'coloring' : 'coloring',
  'timing' : 'timing',
  'rapidity' : 'rapidity',
  'routine' : 'routine',

  /**/

  'routine' : 'routine',
  'r' : 'routine',
  'routineTimeOut' : 'routineTimeOut',
  'concurrent' : 'concurrent',

  'v' : 'verbosity',
  'verbosity' : 'verbosity',
  'negativity' : 'negativity',
  'n' : 'negativity',
  'silencing' : 'silencing',
  's' : 'silencing',
  'shoulding' : 'shoulding',
  'accuracy' : 'accuracy',
  'debug' : 'debug',

  // 'parent' : 'parent',

}

/**
 * @typedef {Object} SettingsOfTester
 * @property {String} [scenario='test']
 * @property {Number} [sanitareTime=500]
 * @property {Number} [fails=null]
 * @property {Boolean} [beeping=null]
 * @property {Boolean} [coloring=1]
 * @property {Boolean} [timing=1]
 * @property {Number} [rapidity=0]
 * @property {String} [routine=null]
 * @property {Number} [negativity=null]
 * @memberof module:Tools/Tester.wTester
*/

let SettingsOfTester =
{

  sanitareTime : 500,
  fails : null,
  beeping : null,
  coloring : 1,
  debug : null,
  timing : 1,
  rapidity : 0,
  routine : null,
  negativity : null,
  // parent : null,

}

/**
 * @typedef {Object} SettingsOfSuite
 * @property {String} routine
 * @property {Number} routineTimeOut
 * @property {Boolean} concurrent
 * @property {Number} verbosity
 * @property {Number} negativity
 * @property {Boolean} silencing
 * @property {Boolean} shoulding
 * @property {Number} accuracy
 * @memberof module:Tools/Tester.wTester
*/

let SettingsOfSuite =
{

  routine : null,
  routineTimeOut : null,
  concurrent : null,
  // rapidity : null,
  // fails : null,
  verbosity : null,
  negativity : null,
  silencing : null,
  shoulding : null,
  accuracy : null,

}

let Settings = _.mapExtend( null, SettingsOfSuite, SettingsOfTester );

let Composes =
{
  verbosity : 3,

  settings : _.define.own( {} ),
  state : null,

  _cancelCon : _.define.own( new _.Consequence({ tag : 'TesterCancel', capacity : 0 }) ),
  _canceled : 0,

  report : null,

  sourceFileLocation : sourceFileLocation,
  sourceFileStack : sourceFileStack,

  _testingBeginTime : null,
  _isReal_ : 1,

  verbosity : 4,
  negativity : 2,

  _barOptions : null,
  _appArgs : null,
  filePath : null,

}

let Aggregates =
{
}

let Associates =
{

  quedSuites : _.define.own( [] ),
  activeSuites : _.define.own( [] ),
  activeRoutines : _.define.own( [] ),

  fileProvider : null,
  logger : null,

}

let Restricts =
{

  formed : 0,

}

let Statics =
{

  FormSuites,

  ApplicationArgumentsMap,

  SettingsNameMap,
  SettingsOfTester,
  SettingsOfSuite,
  Settings,

  TestSuite : null,
  TestRoutine : null,

}

let Forbids =
{

  importanceOfDetails : 'importanceOfDetails',
  timeOut : 'timeOut',
  appArgs : 'appArgs',
  scenario : 'scenario',
  sanitareTime : 'sanitareTime',
  fails : 'fails',
  beeping : 'beeping',
  coloring : 'coloring',
  timing : 'timing',
  rapidity : 'rapidity',
  routine : 'routine',
  routineTimeOut : 'routineTimeOut',
  concurrent : 'concurrent',
  silencing : 'silencing',
  shoulding : 'shoulding',
  accuracy : 'accuracy',
  _defaultVerbosity : '_defaultVerbosity',
  path : 'path',
  includeFails : 'includeFails',

}

let Accessors =
{
  verbosity : 'verbosity',
}

// --
// declare
// --

let Extend =
{

  // inter

  finit,
  init,
  unform,
  form,
  FormSuites,
  formAssociates,

  // scenarios

  appArgsRead,

  scenarioTest,
  scenarioOptionsList,
  scenarioSuitesList,

  // run

  _testAllAct,
  testAll,

  _test,
  test,

  _testingBegin,
  _testingEndSoon,
  _testingEndNow,

  _canContinue,
  cancel,

  // suites

  _suitesRun,
  suitesFilterOut,
  suitesListPrint,

  _suitesIncludeAt,
  suitesIncludeAt,

  // report

  _reportBegin,
  _reportEnd,
  _reportToStr,
  _reportIsPositive,
  textColor,

  // etc

  _verbositySet,
  _verbosityGet,
  _verbosityChange,

  // consider

  _testCheckConsider,
  _testCaseConsider,
  _testRoutineConsider,
  _testSuiteConsider,
  _exceptionConsider,
  _includeFailConsider,

  // relation

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,
  Accessors,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extend,
});

_.Copyable.mixin( Self );
_.Verbal.mixin( Self );

_realGlobal_[ Self.name ] = _global[ Self.name ] = Self;

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
