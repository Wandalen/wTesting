(function _Testing_debug_s_() {

'use strict';

/*

- move test routine methods out of test suite
- implement routine only as option of test suite
- manual launch of test suite + global tests execution should not give extra test suite runs
- after the last test case of test routine description should be changed

- make possible switch off parents test routines

fileStat : null

- make "should/must not error" pass original messages through
  test.description = 'mustNotThrowError must return con with message';

  var con = new wConsequence().give( '123' );
  test.mustNotThrowError( con )
  .ifNoErrorThen( function( got )
  {
    test.identical( got, '123' );
  })

- improve inheritance
- global search cant find test suites with inheritance

- implement support of glob path
- print information about case with color directive avoiding change of color state of logger

- test.identical( undefined,undefined ) -> strange output, replacing undefined by null!

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

if( _.Testing._isFullImplementation )
{
  console.log( 'WARING : wTesting included several times!' );
  console.log( '' );
  console.log( 'First time' );
  console.log( _.Testing.sourceFileStack );
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

    logger.verbosityPush( testing.verbosity === null ? testing._defaultVerbosity : testing.verbosity );

    var path = appArgs.subject || _.pathCurrent();
    path = _.pathJoin( _.pathCurrent(),path );

    testing.includeTestsFrom( path );

    logger.verbosityPop();

    if( [ 'test','suites.list' ].indexOf( testing.scenario ) === -1 )
    throw _.errBriefly( 'Unknown scenario',testing.scenario );

    if( testing.scenario === 'test' )
    result = testing.testAll();
    else if( testing.scenario === 'suites.list' )
    testing.testsListPrint( testing.testsFilterOut() );

  }
  catch( err )
  {
    err = _.errLogOnce( err );
    process.exitCode = -1;
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

function includeTestsFrom( path )
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

  /*logger.log( 'files',_.entitySelect( files,'*.absolute' ) );*/

  for( var f = 0 ; f < files.length ; f++ )
  {
    if( !files[ f ].stat.isFile() )
    continue;
    var absolutePath = files[ f ].absolute;
    // console.log( 'absolutePath',absolutePath );
    // var hadTestCases = _.mapKeys( wTests ).length;

    try
    {
      require( _.fileProvider.pathNativize( absolutePath ) );
    }
    catch( err )
    {
      err = _.errAttend( 'Cant include',absolutePath + '\n',err );
      testing.includeFails.push( err );
      // console.log( 'logger.verbosity',logger.verbosity );

      if( logger.verbosity < 3 )
      logger.log( _.errBriefly( err ) );
      else
      logger.log( err );

    }

    // if( hadTestCases === _.mapKeys( wTests ).length )
    // throw _.err( 'Test file "' + absolutePath + '" has no test suites, but should!' );
  }

}

//

function appArgsApply()
{
  var testing = this;
  var logger = testing.logger || _global_.logger;

  if( testing._appArgsApplied )
  return testing._appArgsApplied;

  _.assert( arguments.length === 0 );

  var appArgs = _.appArgsInSubjectAndMapFormat();
  if( appArgs.map )
  {
    _.mapExtend( testing,_.mapScreen( Options,appArgs.map ) );
    if( testing.verbosity >= 8 )
    logger.log( 'Raw application arguments :\n',_.toStr( appArgs,{ levels : 2 } ) );
    if( testing.verbosity >= 5 )
    logger.log( 'Application arguments :\n',_.toStr( _.mapScreen( Options,appArgs.map ),{ levels : 2 } ) );
  }

  testing._appArgsApplied = appArgs;

  return appArgs;
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
  .timeOutThen( testing.sanitareTime )
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
  testing.barringConsole = suites[ 0 ].barringConsole;

  testing._testingBegin( suites );

  testing._testAct.apply( testing,suites );

  return wTestSuite._suiteCon
  .timeOutThen( testing.sanitareTime )
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

  // if( !testing.logger )
  // {
  //   logger = testing.logger = new wLogger({ name : 'LoggerForTesting' });
  // }

  testing.appArgsApply();
  testing._registerExitHandler();

  if( testing.barringConsole )
  {
    logger.begin({ verbosity : -8 });
    logger.log( 'Barring console' );
    logger.end({ verbosity : -8 });
    if( !wLogger.consoleIsBarred( console ) )
    testing._bar = wLogger.consoleBar({ outputLogger : logger, bar : 1 });
  }

  logger.begin({ verbosity : -4 });
  logger.log( 'Testing options' );
  logger.log( _.mapScreen( Options,testing ) );
  logger.log( '' );
  logger.end({ verbosity : -4 });

  logger.verbosityPush( testing.verbosity === null ? testing._defaultVerbosity : testing.verbosity );
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

  testing._reportNew();

}

//

function _testingEnd()
{
  var testing = this;
  var logger = testing.logger || _global_.logger;
  var ok = testing.report.testCaseFails === 0 && testing.report.testCasePasses > 0;

  if( !ok && !_.appExitCode() )
  _.appExitCode( -1 );

  var msg = '';
  msg += 'Passed test cases ' + ( testing.report.testCasePasses ) + ' / ' + ( testing.report.testCasePasses + testing.report.testCaseFails ) + '\n';
  msg += 'Passed test routines ' + ( testing.report.testRoutinePasses ) + ' / ' + ( testing.report.testRoutinePasses + testing.report.testRoutineFails ) + '\n';
  msg += 'Passed test suites ' + ( testing.report.testSuitePasses ) + ' / ' + ( testing.report.testSuitePasses + testing.report.testSuiteFailes ) + '';

  // logger._verbosityReport();
  // console.log( 'testing.logger',testing.logger );

  logger.begin({ verbosity : -2 });
  logger.log();

  logger.begin({ 'connotation' : ok ? 'positive' : 'negative' });
  logger.log( msg );
  logger.end({ verbosity : -2 });

  logger.begin({ verbosity : -1 });

  // logger._verbosityReport();

  var msg = 'Testing .. ' + ( ok ? 'ok' : 'failed' );
  logger.logDown( msg );
  logger.end({ 'connotation' : ok ? 'positive' : 'negative' });
  logger.end({ verbosity : -1 });

  logger.verbosityPop();

  // logger._verbosityReport();
  // console.log( 'testing.logger',testing.logger );

  if( testing.barringConsole && wLogger.consoleIsBarred( console ) )
  {
    testing._bar.bar = 0;
    wLogger.consoleBar( testing._bar );
  }

  _.timeOut( 500,function()
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

  var suites = _.entityFilter( suites,function( suite )
  {
    if( _.strIs( suite ) )
    {
      if( !wTests[ suite ] )
      throw _.err( 'Testing : test suite',suite,'not found' );
      suite = wTests[ suite ];
    }
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

function _reportNew()
{
  var testing = this;

  testing.report = Object.create( null );

  testing.report.testSuitePasses = 0;
  testing.report.testSuiteFailes = 0;

  testing.report.testRoutinePasses = 0;
  testing.report.testRoutineFails = 0;

  testing.report.testCasePasses = 0;
  testing.report.testCaseFails = 0;

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

  if( testing.fails > 0 )
  if( testing.fails <= testing.report.testCaseFails )
  return false;

  return true;
}

// --
// report generator
// --

function loggerToBook( o )
{

  if( !o )
  o = {};

  o.logger = o.logger || _.Testing.logger;

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

    /* cases */

    var cases = _.entitySearch({ src : routine, ins : 'case', searchingValue : 0, searchingSubstring : 0, returnParent : 1 });

    var routineMore = [];
    cases = _.entityFilter( cases, function( acase,k )
    {
      if( !acase.text )
      return;
      if( !acase.tail )
      {
        routineMore.push( acase );
        return;
      }

      acase.casePath = _.pathDir( k );
      var result = Object.create( null );
      result.data = acase;
      result.text = acase.case + ' # '+ acase.caseIndex;
      result.attributes = _.mapBut( acase,{ text : 0 } );

      result.kind = 'terminal';
      result.data.report = routineMore;
      routineMore = [];
      return result;
    });

    cases = _.entityVals( cases );

    /* routine */

    var result = Object.create( null );
    result.kind = 'branch';
    result.data = routine;
    result.text = routine.routine;
    result.elements = cases;
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

    if( node.data.case )
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

// --
// var
// --

var symbolForVerbosity = Symbol.for( 'verbosity' );

var Options =
{
  sanitareTime : 3000,
  testRoutineTimeOut : 5000,
  verbosity : null,
  verbosityOfDetails : null,
  importanceOfNegative : null,
  concurrent : 0,
  barringConsole : 1,
  scenario : 'test',
  routine : null,
  fails : null,
}

// --
// prototype
// --

var Self =
{

  // exec

  exec : exec,
  _registerExitHandler : _registerExitHandler,
  includeTestsFrom : includeTestsFrom,
  appArgsApply : appArgsApply,


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

  _reportNew : _reportNew,
  _verbositySet : _verbositySet,
  _canContinue : _canContinue,


  // report generator

  loggerToBook : loggerToBook,


  // var

  logger : new wLogger({ name : 'LoggerForTesting' }),

  activeSuites : [],
  report : null,
  includeFails : [],

  sourceFilePath : sourceFilePath,
  sourceFileStack : sourceFileStack,
  _isFullImplementation : 1,
  _registerExitHandlerDone : 0,
  _defaultVerbosity : 2,

  _bar : null,
  _appArgsApplied : null,

  constructor : function wTesting(){},

}

//

_.mapExtend( Self,Options );
_.accessor
({
  object : Self,
  prime : 0,
  names : { verbosity : 'verbosity' },
});

//

Object.preventExtensions( Self );
wTools.Testing = Self;

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
_.Testing.exec();

//

// if( 0 )
// _.timeReady( function()
// {
//
//   // debugger;
//   Self.verbosity = 0;
//   //Self.logger = wPrinterToJstructure({ coloring : 0 });
//
//   // _.Testing.test( 'Logger other test','Consequence','FileProvider.SimpleStructure' )
//   _.Testing.test( 'FileProvider.SimpleStructure' )
//   .doThen( function()
//   {
//     debugger;
//     if( Self.logger )
//     logger.log( _.toStr( Self.logger.outputData,{ levels : 5 } ) );
//     debugger;
//   });
//
// });

})();
