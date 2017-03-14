(function _Testing_debug_s_() {

'use strict';

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

  _.include( 'wConsequence' );
  _.include( 'wFiles' );
  _.include( 'wLogger' );

}

var _ = wTools;
var sourceFilePath = _.diagnosticLocation().full; // typeof module !== 'undefined' ? __filename : document.scripts[ document.scripts.length-1 ].src;

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

  try
  {

    _.assert( arguments.length === 0 );

    var appArgs = testing.applyAppArgs();
    var path = appArgs.subject || _.pathCurrent();

    path = _.pathJoin( _.pathCurrent(),path );

    testing.includeTestsFrom( path );
    testing.testAll();

  }
  catch( err )
  {
    err = _.errLogOnce( err );
    process.exitCode = -1;
    throw err;
  }

}

//

function registerHook()
{
  var testing = this;

  if( testing._registerHookDone )
  return;

  testing._registerHookDone = 1;

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
    pathFile : path,
    ends : [ '.test.s','.test.ss' ], recursive : 1,
    maskAll : _.pathRegexpMakeSafe(),
  });

  // console.log( 'files',_.entitySelect( files,'*.absolute' ) );

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
      err = _.err( err );
      testing.includeFails.push( err );
      _.errLog( _.errBriefly( err ) );
    }

    // if( hadTestCases === _.mapKeys( wTests ).length )
    // throw _.err( 'Test file "' + absolutePath + '" has no test suites, but should!' );
  }

}

//

function applyAppArgs()
{
  var testing = this;
  var logger = testing.logger || _global_.logger;

  _.assert( arguments.length === 0 );

  var appArgs = _.appArgsInSubjectAndMapFormat();
  if( appArgs.map )
  {
    _.mapExtend( testing,_.mapScreen( Options,appArgs.map ) );
    if( testing.verbosity >= 8 )
    logger.log( 'applyAppArgs',_.mapScreen( Options,appArgs.map ) );
  }

  return appArgs;
}

// --
// run
// --

function _testAllAct()
{
  var testing = this;
  debugger;

  _.assert( arguments.length === 0 );

  var suites = _.entityFilter( wTests,function( suite )
  {
    if( suite.abstract )
    return;
    if( suite.enabled !== undefined && !suite.enabled )
    return;
    return suite;
  });

  testing._testingBegin();

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

  return wTestSuite._suiteCon.splitThen();
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
    _.assert( _.strIsNotEmpty( suite.name ),'test suite should has ( name )' );
    _.assert( _.objectIs( suite.tests ),'test suite should has map with test routines ( tests )' );

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

  var suites = _.entityFilter( arguments,function( suite )
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

  // console.log( 'suites',_.entityLength( suites ) );

  testing._testingBegin( suites );

  testing._testAct.apply( testing,suites );

  return wTestSuite._suiteCon
  .timeOutThen( testing.sanitareTime )
  .splitThen( function()
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

  if( !testing.logger )
  {
    logger = testing.logger = new wLogger({ name : 'LoggerForTesting' });
  }

  testing.applyAppArgs();
  testing.registerHook();

  if( testing.barringConsole )
  {
    logger.begin({ verbosity : -8 });
    logger.log( 'Barring console' );
    logger.end({ verbosity : -8 });
    testing._bar = wLogger.consoleBar({ outputLogger : logger, bar : 1 });
  }

  logger.begin({ verbosity : -4 });
  logger.log( 'Testing options' );
  logger.log( _.mapScreen( Options,testing ) );
  logger.log( '' );
  logger.end({ verbosity : -4 });

  logger.verbosityPush( testing.verbosity === null ? 2 : testing.verbosity );
  logger.begin({ verbosity : -2 });

  if( tests !== undefined )
  {
    logger.logUp( 'Launching several ( ' + tests.length + ' ) test suites ..' );
    logger.log( _.entitySelect( tests,'*.name' ) );
  }
  else
  {
    debugger;
    logger.logUp( 'Launching all known ( ' + _.mapKeys( wTests ).length + ' ) test suites ..' );
    logger.log( _.entitySelect( _.mapValues( wTests ),'*.sourceFilePath' ).join( '\n' ) );
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

  if( !ok && !_.appReturnCode() )
  _.appReturnCode( -1 );

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

  if( testing.barringConsole )
  {
    testing._bar.bar = 0;
    wLogger.consoleBar( testing._bar );
  }

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
  var suite = this;

  _.assert( arguments.length === 1 );

  if( !_.numberIsNotNan( src ) )
  src = 0;

  suite[ symbolForVerbosity ] = src;

  if( src !== null )
  if( suite.logger )
  suite.logger.verbosity = src;

}

//

// function _consoleBar( src )
// {
//   var testing = this;
//   var logger = testing.logger;
//
//   _.assert( arguments.length === 1 || arguments.length === 2 );
//
//   if( src === undefined )
//   src = 1;
//
//   _.assert( !!testing.barred !== !!src );
//
//   testing.barred = src;
//
//   if( src )
//   {
//
//     logger.begin({ verbosity : -4 });
//     logger.log( 'Shutting console' );
//     logger.end({ verbosity : -4 });
//
//     _.assert( !testing._barLogger.inputs.length );
//     _.assert( !testing._barLogger.outputs.length );
//
//     testing._loggerWasChainedToConsole = logger.outputUnchain( testing._originalConsole );
//     logger.outputTo( testing._originalConsole,{ unbarring : 1, combining : 'rewrite' } );
//
//     testing._barLogger.permanentStyle = { bg : 'yellow' };
//     testing._barLogger.inputFrom( testing._originalConsole,{ barring : 1 } );
//     testing._barLogger.outputTo( logger );
//
//     // testing._barLogger.log( '_barLogger' );
//     // logger.log( 'logger' );
//
//   }
//   else
//   {
//
//     debugger;
//
//     testing._barLogger.unchain();
//
//     logger.outputUnchain( testing._originalConsole );
//     if( testing._loggerWasChainedToConsole )
//     logger.outputTo( testing._originalConsole );
//
//     debugger;
//
//     testing._barLogger.log( '_barLogger' );
//     logger.log( 'logger' );
//
//     debugger;
//   }
//
// /*
//
//      barring         unbarring
// console -> bar -> logger -> console
//   ^
//   |
// others
//
// unbarring link is not transitive, but terminating
// so no cycle
//
// */
//
// }

//

// function consoleBar( ownerName,src )
// {
//   var testing = this;
//
//   _.assert( arguments.length === 2 );
//
//   if( src )
//   {
//     _.assert( !testing._barringSuites[ ownwerName ] );
//     testing._barringSuites[ ownwerName ] = src;
//   }
//   else
//   {
//     _.assert( testing._barringSuites[ ownwerName ] );
//     delete testing._barringSuites[ ownwerName ];
//   }
//
//   if( src && !testing.barred )
//   {
//     testing._consoleBar( ownerName,src );
//   }
//   else if( !src && testing.barred && _.mapKeys( testing._barringSuites ) === 0 )
//   {
//     testing._consoleBar( ownerName,src );
//   }
//
//   return testing;
// }

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
  _.assert( o.logger instanceof wLoggerToJstructure );

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

    cases = _.mapValues( cases );

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
  routines = _.mapValues( routines );

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

  var book = new wHiBook({ targetDom : _.domOccupyWindow(), onPageGet : handlePageGet });
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
  logger : null,
  concurrent : 0,
  barringConsole : 1,
}

// --
// prototype
// --

var Self =
{

  // exec

  exec : exec,
  registerHook : registerHook,
  includeTestsFrom : includeTestsFrom,
  applyAppArgs : applyAppArgs,


  // run

  _testAllAct : _testAllAct,
  testAll : testAll,

  _testAct : _testAct,
  _test : _test,
  test : test,

  _testingBegin : _testingBegin,
  _testingEnd : _testingEnd,


  // etc

  _reportNew : _reportNew,
  _verbositySet : _verbositySet,


  // report generator

  loggerToBook : loggerToBook,


  // var

  activeSuites : [],
  report : null,
  includeFails : [],

  sourceFilePath : sourceFilePath,
  _full : 0,
  _registerHookDone : 0,

  _bar : null,

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
//   //Self.logger = wLoggerToJstructure({ coloring : 0 });
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
