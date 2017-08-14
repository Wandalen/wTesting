(function _Tester_debug_s_() {

'use strict';

/*

+ implement test case tracking

+ move test routine methods out of test suite
+ implement routine only as option of test suite

+ adjust verbosity levels

+ make possible switch off parents test routines

fileStat : null

+ make "should/must not error" pass original messages through
  test.description = 'mustNotThrowError must return con with message';

  var con = new wConsequence().give( '123' );
  test.mustNotThrowError( con )
  .ifNoErrorThen( function( got )
  {
    test.identical( got, '123' );
  })

+ improve inheritance
+ global search cant find test suites with inheritance

- implement options.list
- print information about case with color directive avoiding change of color state of logger

- implement support of glob path
- manual launch of test suite + global tests execution should not give extra test suite runs

+ after the last test case of test routine description should be changed

+ test.identical( undefined,undefined ) -> strange output, replacing undefined by null!

+ test suite should not pass if 0 / 0 test checks

+ track number of thrown errors

+ global / suite / routine basis statistic tracking

*/

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

  _.include( 'wCopyable' );
  _.include( 'wInstancing' );

  _.includeAny( 'wEventHandler','' );

  _.include( 'wConsequence' );
  _.include( 'wFiles' );
  _.include( 'wLogger' );

}

var _ = wTools;
var sourceFilePath = _.diagnosticLocation().full;
var sourceFileStack = _.diagnosticStack();

if( _.Tester._isFullImplementation )
{
  console.log( 'WARING : wTesting included several times!' );
  console.log( '' );
  console.log( 'First time' );
  console.log( _.Tester.sourceFileStack );
  console.log( '' );
  console.log( 'Second time' );
  console.log( sourceFileStack );
  console.log( '' );
  return;
}

// if( !_.toStr )
// _.toStr = function(){ return String( arguments ) };

_.assert( _.toStr,'wTesting needs wTools/staging/abase/akernel/StringTools.s' );
_.assert( _.execStages,'wTesting needs wTools/staging/abase/akernel/ExecTools.s' );
_.assert( _.Consequence,'wTesting needs wConsequence/staging/abase/syn/Consequence.s' );

// --
// tester
// --

function exec()
{
  var testing = this;
  var result;

  try
  {

    _.assert( arguments.length === 0 );

    var appArgs = testing.appArgsApply();
    var path = testing.path;

    if( !testing.scenariosHelpMap[ testing.settings.scenario ] )
    throw _.errBriefly( 'Unknown scenario',testing.settings.scenario );

    if( testing.settings.scenario !== 'test' )
    if( !testing[ testing.scenariosActionMap[ testing.settings.scenario ] ] )
    throw _.errBriefly( 'Scenario',testing.settings.scenario,'is not implemented' );

    if( testing.settings.scenario === 'test' )
    {
      testing.includeTestsFrom( testing.path );
      result = testing.testAll();
    }
    else
    {
      testing[ testing.scenariosActionMap[ testing.settings.scenario ] ]();
    }

  }
  catch( err )
  {
    err = _.errLogOnce( err );
    process.exitCode = -1;
    _.beep();
    _.beep();
    return;
    throw err;
  }

}

//

function _registerExitHandler()
{
  var testing = this;

  if( testing._registerExitHandlerDone )
  return;

  testing._registerExitHandlerDone = 1;

  if( _global_.process )
  process.on( 'exit', function ()
  {
    if( testing.report && testing.report.testSuiteFailes && !process.exitCode )
    {
      var logger = testing.logger || _global_.logger;
      logger.log( _.strColor.style( 'Errors!','negative' ) );
      process.exitCode = -1;
    }
  });

}

//

function _includeTestsFrom( path )
{
  var testing = this;
  var logger = testing.logger || _global_.logger;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( path ) );

  logger.log( 'Include tests from :',path );

  var files = _.fileProvider.filesFind
  ({
    filePath : path,
    ends : [ '.test.s','.test.ss','.test.js' ],
    recursive : 1,
    maskAll : _.pathRegexpMakeSafe(),
  });

  for( var f = 0 ; f < files.length ; f++ )
  {
    if( !files[ f ].stat.isFile() )
    continue;
    var absolutePath = files[ f ].absolute;

    try
    {
      require( _.fileProvider.pathNativize( absolutePath ) );
    }
    catch( err )
    {
      err = _.errAttend( 'Cant include',absolutePath + '\n',err );
      testing.includeFails.push( err );

      logger.error( _.strColor.fg( 'Cant include ' + absolutePath, 'red' ) );
      if( logger.verbosity > 3 )
      logger.error( _.err( err ) );
    }

  }

}

//

function includeTestsFrom( path )
{
  var testing = this;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( path ) );

  logger.verbosityPush( testing.verbosity === null ? testing._defaultVerbosity : testing.verbosity );
  testing._includeTestsFrom( path );
  logger.verbosityPop();

}

//

function appArgsApply()
{
  var testing = this;
  var logger = testing.logger || _global_.logger;

  if( testing._appArgsApplied )
  return testing._appArgsApplied;

  _.assert( arguments.length === 0 );
  _.mapExtend( testing.settings,testing.Settings );

  var appArgs = _.appArgsInSubjectAndMapFormat();
  if( appArgs.map )
  {
    _.mapExtend( testing.settings,_.mapScreen( testing.Settings,appArgs.map ) );
    if( testing.verbosity >= 8 )
    logger.log( 'Raw application arguments :\n',_.toStr( appArgs,{ levels : 2 } ) );
    if( testing.verbosity >= 5 )
    logger.log( 'Application arguments :\n',_.toStr( _.mapScreen( testing.Settings,appArgs.map ),{ levels : 2 } ) );

    if( appArgs.map.verbosity === 0 && appArgs.map.usingBeep === undefined )
    testing.settings.usingBeep = 0;

  }

  testing._appArgsApplied = appArgs;

  testing.path = appArgs.subject || _.pathCurrent();
  testing.path = _.pathJoin( _.pathCurrent(),testing.path );

  debugger;
  if( _.numberIs( testing.settings.verbosity ) )
  testing.verbosity = testing.settings.verbosity;

  return appArgs;
}

//

function scenarioScenariosList()
{
  var testing = this;

  debugger;

  _.assert( testing.settings.scenario === 'scenarios.list' );

  logger.log( 'Scenarios :\n',_.toStr( testing.scenariosHelpMap,{ levels : 2 } ) );

}

//

function scenarioSuitesList()
{
  var testing = this;

  debugger;

  _.assert( testing.settings.scenario === 'suites.list' );

  testing.includeTestsFrom( testing.path );

  testing.testsListPrint( testing.testsFilterOut() );

}

//

function scenarioOptionsList()
{
  var testing = this;

  _.assert( testing.settings.scenario === 'options.list' );

  var optionsList =
  {
    'wTesting options' : ' ',
    scenario : 'Name of scenario to launch. To get scenarios list use scenario : "scenarios.list".',
    sanitareTime : 'Delay before run of next test suite.',
    usingBeep : 'Make beep sound when work of tester is finished.',
    routine : 'Name of test routine to run. If each test suite has that routine, it will be executed.',
    fails : 'Maximal number of fails before shutdown.',
    barringConsole : 'Enables catching of console output that occures during test run.',
    testRoutineTimeOut : 'Limits the time that each test routine can work. If routine works too long timeOut error will be thrown.',
    concurrent : 'Runs all test suites in parallel.',
    verbosity : 'Level of details in tester output.',
    importanceOfDetails : 'Importance of test details in output.',
    importanceOfNegative : 'Importance of fails in output.'
  }

  var strOptions =
  {
    levels : 3,
    wrap : 0,
    stringWrapper : '',
    multiline : 1
  };

  logger.log( _.toStr( optionsList, strOptions ) );
}

// --
// run
// --

function _testAllAct()
{
  var testing = this;

  _.assert( arguments.length === 0 );

  // var suites = _.entityFilter( wTests,function( suite )
  // {
  //   if( suite.abstract )
  //   return;
  //   if( suite.enabled !== undefined && !suite.enabled )
  //   return;
  //   return suite;
  // });

  var suites = testing.testsFilterOut( wTests );

  testing._testingBegin( suites );

  for( var t in suites )
  {
    testing._testAct( t );
  }

  wTestSuite._suiteCon
  .timeOutThen( testing.settings.sanitareTime )
  .doThen( function()
  {
    return testing._testingEnd();
  });

  return wTestSuite._suiteCon.split();
}

//

var testAll = _.timeReadyJoin( undefined,_testAllAct );

//

function _testAct()
{
  var testing = this;

  _.assert( this === Self );

  for( var a = 0 ; a < arguments.length ; a++ )
  {
    var _suite = arguments[ a ];
    var suite = wTestSuite.instanceByName( _suite );

    _.assert( suite instanceof wTestSuite,'Test suite',_suite,'was not found' );
    _.assert( _.strIsNotEmpty( suite.name ),'Test suite should has ( name )"' );
    _.assert( _.objectIs( suite.tests ),'Test suite should has map with test routines ( tests ), but "' + suite.name + '" does not have it' );

    suite._testSuiteRunLater();
  }

}

//

function _test()
{
  var testing = this;

  _.assert( this === Self );

  if( arguments.length === 0 )
  return testing._testAllAct();

  var suites = testing.testsFilterOut( arguments );

  if( suites[ 0 ] && suites[ 0 ].barringConsole !== null && suites[ 0 ].barringConsole !== undefined )
  testing.settings.barringConsole = suites[ 0 ].barringConsole;

  testing._testingBegin( suites );

  testing._testAct.apply( testing,suites );

  return wTestSuite._suiteCon
  .timeOutThen( testing.settings.sanitareTime )
  .split( function()
  {
    return testing._testingEnd();
  });
}

//

var test = _.timeReadyJoin( undefined,_test );

//

function _testingBegin( tests )
{
  var testing = this;
  var logger = testing.logger;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.numberIs( testing.verbosity ) );

  testing.appArgsApply();
  testing._registerExitHandler();

  logger.verbosityPush( testing.verbosity );
  // logger._verbosityReport();

  if( testing.settings.barringConsole )
  {
    logger.begin({ verbosity : -8 });
    logger.log( 'Barring console' );
    logger.end({ verbosity : -8 });
    if( !wLogger.consoleIsBarred( console ) )
    testing._bar = wLogger.consoleBar({ outputLogger : logger, bar : 1 });
  }

  logger.begin({ verbosity : -4 });
  logger.log( 'Tester Settings :' );
  logger.log( testing.settings );
  logger.log( '' );
  logger.end({ verbosity : -4 });

  // logger.verbosityPush( testing.verbosity === null ? testing._defaultVerbosity : testing.verbosity );
  // logger.verbosityPush( testing.verbosity );
  logger.begin({ verbosity : -2 });

  if( tests !== undefined )
  {
    logger.logUp( 'Launching several ( ' + _.entityLength( tests ) + ' ) test suites ..' );
    testing.testsListPrint( tests );
  }
  else
  {
    debugger;
    logger.logUp( 'Launching all known ( ' + _.mapKeys( wTests ).length + ' ) test suites ..' );
    testing.testsListPrint( tests );
  }

  logger.log();
  logger.end({ verbosity : -2 });

  testing._reportForm();

}

//

function _testingEnd()
{
  var testing = this;
  var logger = testing.logger || _global_.logger;
  var ok = testing._reportIsPositive();

  if( testing.settings.usingBeep )
  _.beep();

  if( !ok && !_.appExitCode() )
  {
    if( testing.settings.usingBeep )
    _.beep();
    _.appExitCode( -1 );
  }

  var msg = testing._reportToStr();

  logger.begin({ verbosity : -2 });
  // logger.log();

  logger.begin({ 'connotation' : ok ? 'positive' : 'negative' });
  logger.log( msg );
  logger.end({ verbosity : -2 });

  // logger._verbosityReport();
  logger.begin({ verbosity : -1 });
  // logger._verbosityReport();
  var msg = 'Tester .. ' + ( ok ? 'ok' : 'failed' );
  logger.logDown( msg );
  logger.end({ 'connotation' : ok ? 'positive' : 'negative' });
  logger.end({ verbosity : -1 });

  /* */

  logger.verbosityPop();

  // logger._verbosityReport();
  // console.log( 'testing.logger',testing.logger );

  if( testing.settings.barringConsole && wLogger.consoleIsBarred( console ) )
  {
    testing._bar.bar = 0;
    wLogger.consoleBar( testing._bar );
  }

  _.timeOut( 100,function()
  {
    _.appExit();
  });

}

//

function testsFilterOut( suites )
{
  var testing = this;
  var logger = testing.logger;

  // console.log( suites );

  _.assert( arguments.length === 0 || arguments.length === 1,'expects none or single argument, but got',arguments.length );

  var suites = suites || wTests;

  // debugger;
  var suites = _.entityFilter( suites,function( suite )
  {
    if( _.strIs( suite ) )
    {
      if( !wTests[ suite ] )
      throw _.err( 'Tester : test suite',suite,'not found' );
      suite = wTests[ suite ];
    }
    // debugger;
    if( suite.abstract )
    return;
    if( suite.enabled !== undefined && !suite.enabled )
    return;
    return suite;
  });

  // debugger;

  return suites;
}

//

function testsListPrint( suites )
{
  var testing = this;
  var logger = testing.logger;
  var suites = suites || wTests;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  logger.log( _.entitySelect( _.entityVals( suites ),'*.sourceFilePath' ).join( '\n' ) );

  var l = _.entityLength( suites );

  logger.log( l, l > 1 ? 'test suites' : 'test suite' );

}

// --
// etc
// --

function _reportForm()
{
  var testing = this;
  var report = testing.report = Object.create( null );

  report.errorsArray = [];

  report.testCheckPasses = 0;
  report.testCheckFails = 0;

  report.testCasePasses = 0;
  report.testCaseFails = 0;
  report.testCaseNumber = 0;

  report.testRoutinePasses = 0;
  report.testRoutineFails = 0;

  report.testSuitePasses = 0;
  report.testSuiteFailes = 0;

  Object.preventExtensions( report );

}

//

function _reportToStr()
{
  var testing = this;
  var report = testing.report;
  var msg = '';

  if( report.errorsArray.length )
  msg += 'Thrown ' + ( report.errorsArray.length ) + ' error(s)\n';

  msg += 'Passed test checks ' + ( report.testCheckPasses ) + ' / ' + ( report.testCheckPasses + report.testCheckFails ) + '\n';
  msg += 'Passed test cases ' + ( report.testCasePasses ) + ' / ' + ( report.testCasePasses + report.testCaseFails ) + '\n';
  msg += 'Passed test routines ' + ( report.testRoutinePasses ) + ' / ' + ( report.testRoutinePasses + report.testRoutineFails ) + '\n';
  msg += 'Passed test suites ' + ( report.testSuitePasses ) + ' / ' + ( report.testSuitePasses + report.testSuiteFailes ) + '';

  return msg;
}

//

function _reportIsPositive()
{
  var testing = this;

  if( testing.report.testCheckFails !== 0 )
  return false;

  if( !( testing.report.testCheckPasses > 0 ) )
  return false;

  if( testing.report.errorsArray.length )
  return false;

  return true;
}

//

function _verbositySet( src )
{
  var testing = this;

  _.assert( arguments.length === 1 );

  if( !_.numberIsNotNan( src ) )
  src = 0;

  testing[ symbolForVerbosity ] = src;

  if( src !== null )
  if( testing.logger )
  testing.logger.verbosity = src;

}

//

function _canContinue()
{
  var testing = this;

  if( testing.settings.fails > 0 )
  if( testing.settings.fails <= testing.report.testCheckFails )
  return false;

  return true;
}

//

function _outcomeConsider( outcome )
{
  var testing = this;

  _.assert( arguments.length === 1 );
  _.assert( testing === Self );

  if( outcome )
  {
    testing.report.testCheckPasses += 1;
  }
  else
  {
    testing.report.testCheckFails += 1;
  }

}

//

function _exceptionConsider( err )
{
  var testing = this;

  _.assert( arguments.length === 1 );
  _.assert( testing === Self );

  testing.report.errorsArray.push( err );

}

//

function _testCaseConsider( outcome )
{
  var testing = this;
  var report = testing.report;

  if( outcome )
  report.testCasePasses += 1;
  else
  report.testCaseFails += 1;

}

// --
// report formatter
// --

function loggerToBook( o )
{

  if( !o )
  o = {};

  o.logger = o.logger || _.Tester.logger;

  _.routineOptions( loggerToBook,o );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( o.logger instanceof wPrinterToJstructure );

  var data = o.logger.outputData;
  var routines = _.entitySearch({ src : data, ins : 'routine', searchingValue : 0, returnParent : 1, searchingSubstring : 0 });
  logger.log( _.toStr( routines,{ levels : 1 } ) );

  /* */

  var routineHead;
  routines = _.entityFilter( routines, function( routine,k )
  {
    routine.folderPath = _.pathDir( k );
    routine.itemsPath = _.pathDir( routine.folderPath );
    routine.itemsData = _.entitySelect( data,routine.itemsPath );

    if( routine.tail )
    {
      routineHead.data.report = [ routine ];
      _.mapSupplement( routineHead.attributes,_.mapBut( routine,{ text : 0 } ) );
      return;
    }

    /* checks */

    debugger;
    var checks = _.entitySearch
    ({
      src : routine,
      ins : 'check',
      searchingValue : 0,
      searchingSubstring : 0,
      returnParent : 1,
    });

    var routineMore = [];
    checks = _.entityFilter( checks, function( acheck,k )
    {
      if( !acheck.text )
      return;
      if( !acheck.tail )
      {
        routineMore.push( acheck );
        return;
      }

      acheck.checkPath = _.pathDir( k );
      var result = Object.create( null );
      result.data = acheck;
      debugger;
      result.text = acheck.check + ' # '+ acheck.checkIndex;
      result.attributes = _.mapBut( acheck,{ text : 0 } );

      result.kind = 'terminal';
      result.data.report = routineMore;
      routineMore = [];
      return result;
    });

    checks = _.entityVals( checks );

    /* routine */

    var result = Object.create( null );
    result.kind = 'branch';
    result.data = routine;
    result.text = routine.routine;
    result.elements = checks;
    result.attributes = _.mapBut( routine,{ text : 0 } );

    routineHead = result;
    return result;
  });

  /* */

  logger.log( _.toStr( routines,{ levels : 1 } ) );
  routines = _.entityVals( routines );

  /* */

  function handlePageGet( node )
  {
    if( !node.data )
    return '-';
    var result = _.entitySelect( node.data.report,'*.text' );

    if( node.data.check )
    result = result.join( '\n' ) + '\n' + node.data.text;
    else if( node.data.routine )
    result = node.data.text + '\n' + _.entitySelect( node.elements,'*.data.text' ).join( '\n' ) + '\n' + result.join( '\n' );

    return result;
  }

  /* */

  var book = new wHiBook({ targetDom : _.domTotalPanelMake().targetDom, onPageGet : handlePageGet });
  book.make();
  book.tree.treeSet({ elements : routines });

}

loggerToBook.defaults =
{
  logger : null,
}

//

function bookExperiment()
{

  if( 0 )
  _.timeReady( function()
  {

    // debugger;
    Self.verbosity = 0;
    //Self.logger = wPrinterToJstructure({ coloring : 0 });

    // _.Tester.test( 'Logger other test','Consequence','FileProvider.SimpleStructure' )
    _.Tester.test( 'FileProvider.SimpleStructure' )
    .doThen( function()
    {
      debugger;
      if( Self.logger )
      logger.log( _.toStr( Self.logger.outputData,{ levels : 5 } ) );
      debugger;
    });

  });

}

// --
// var
// --

var symbolForVerbosity = Symbol.for( 'verbosity' );

var SettingsOfTester =
{

  scenario : 'test',
  sanitareTime : 3000,
  usingBeep : 1,

  routine : null,
  fails : null,
  barringConsole : 1,

}

var SettingsOfSuite =
{

  testRoutineTimeOut : null,
  concurrent : null,

  verbosity : null,
  importanceOfDetails : null,
  importanceOfNegative : null,

  routine : null,
  barringConsole : 1,

}

var Settings = _.mapExtend( null,SettingsOfTester,SettingsOfSuite );

var scenariosHelpMap =
{
  'test' : 'run tests, default scenario',
  'help' : 'get help',
  'options.list' : 'list available options',
  'scenarios.list' : 'list available scenarios',
  'suites.list' : 'list available suites',
}

var scenariosActionMap =
{
  'test' : '',
  'help' : 'scenarioHelp',
  'options.list' : 'scenarioOptionsList',
  'scenarios.list' : 'scenarioScenariosList',
  'suites.list' : 'scenarioSuitesList',
}

var Forbids =
{

  sanitareTime : 'sanitareTime',
  testRoutineTimeOut : 'testRoutineTimeOut',

  importanceOfDetails : 'importanceOfDetails',
  importanceOfNegative : 'importanceOfNegative',

  concurrent : 'concurrent',
  barringConsole : 'barringConsole',
  scenario : 'scenario',
  routine : 'routine',
  fails : 'fails',
  usingBeep : 'usingBeep',

}

var Accessors =
{
  verbosity : 'verbosity',
}

// --
// prototype
// --

var Self =
{

  // exec

  exec : exec,
  _registerExitHandler : _registerExitHandler,
  _includeTestsFrom : _includeTestsFrom,
  includeTestsFrom : includeTestsFrom,
  appArgsApply : appArgsApply,

  scenarioScenariosList : scenarioScenariosList,
  scenarioSuitesList : scenarioSuitesList,


  // run

  _testAllAct : _testAllAct,
  testAll : testAll,

  _testAct : _testAct,
  _test : _test,
  test : test,

  _testingBegin : _testingBegin,
  _testingEnd : _testingEnd,

  testsFilterOut : testsFilterOut,
  testsListPrint : testsListPrint,


  // etc

  _reportForm : _reportForm,
  _reportToStr : _reportToStr,
  _reportIsPositive : _reportIsPositive,

  _verbositySet : _verbositySet,
  _canContinue : _canContinue,

  _outcomeConsider : _outcomeConsider,
  _exceptionConsider : _exceptionConsider,
  _testCaseConsider : _testCaseConsider,


  // report formatter

  loggerToBook : loggerToBook,
  bookExperiment : bookExperiment,


  // var

  SettingsOfTester : SettingsOfTester,
  SettingsOfSuite : SettingsOfSuite,
  Settings : Settings,

  settings : Object.create( null ),

  logger : new wLogger({ name : 'LoggerForTesting' }),

  activeSuites : [],
  report : null,
  includeFails : [],

  scenariosHelpMap : scenariosHelpMap,
  scenariosActionMap : scenariosActionMap,

  sourceFilePath : sourceFilePath,
  sourceFileStack : sourceFileStack,
  _isFullImplementation : 1,
  _registerExitHandlerDone : 0,

  _defaultVerbosity : 2,
  verbosity : 2,

  _bar : null,
  _appArgsApplied : null,
  path : null,

  constructor : function wTester(){},

}

//

_.accessorForbid( Self,Forbids )

_.accessor
({
  object : Self,
  prime : 0,
  names : Accessors,
});

//

Object.preventExtensions( Self );
wTools.Tester = Self;

if( typeof module !== 'undefined' && module !== null )
{
  require( './aTestSuite.debug.s' );
  module[ 'exports' ] = Self;
}

var wTestsWas = _global_.wTests;
_global_.wTests = wTestSuite.instancesMap;

if( wTestsWas )
wTestSuite.prototype._registerSuites( wTestsWas );

if( typeof module !== 'undefined' && !module.parent )
_.Tester.exec();

})();
