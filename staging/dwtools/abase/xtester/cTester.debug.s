(function _Tester_debug_s_() {

'use strict';

var _global = _global_;
var _ = _global_.wTools;
var sourceFileLocation = _.diagnosticLocation().full;
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
  debugger;
  _.assert( 0 );
  return;
}

_.assert( _.toStr, 'wTesting needs wTools/staging/dwtools/abase/layer1/StringTools.s' );
_.assert( _.execStages, 'wTesting needs wTools/staging/dwtools/abase/layer1/ExecTools.s' );
_.assert( _.Consequence, 'wTesting needs wConsequence/staging/dwtools/abase/oclass/Consequence.s' );
_.assert( _.accuracy, 'wTesting needs wTools.accuracy' );

// --
// tester
// --

function exec()
{
  var tester = this;
  var result;

  try
  {

    _.assert( arguments.length === 0 );

    tester.appArgsRead();
    var path = tester.path;

    if( !tester.ScenariosHelpMap[ tester.settings.scenario ] )
    throw _.errBriefly( 'Unknown scenario',tester.settings.scenario );

    if( tester.settings.scenario !== 'test' )
    if( !tester[ tester.ScenariosActionMap[ tester.settings.scenario ] ] )
    throw _.errBriefly( 'Scenario',tester.settings.scenario,'is not implemented' );

    if( tester.settings.scenario === 'test' )
    {
      tester.includeTestsFrom( tester.path );
      result = tester.testAll();
    }
    else
    {
      tester[ tester.ScenariosActionMap[ tester.settings.scenario ] ]();
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
  var tester = this;

  _.appRepairExitHandler();

  if( tester._registerExitHandlerDone )
  return;

  tester._registerExitHandlerDone = 1;

  // if( 0 )
  // if( _global.process )
  // process.on( 'exit', function()
  // {
  //   if( tester.report && tester.report.testSuiteFailes && !process.exitCode )
  //   {
  //     var logger = tester.logger;
  //     debugger;
  //     if( tester.settings.coloring )
  //     logger.error( _.color.strFormat( 'Errors!','negative' ) );
  //     else
  //     logger.error( 'Errors!' );
  //     process.exitCode = -1;
  //   }
  // });

}

//

function _includeTestsFrom( path )
{
  var tester = this;
  var logger = tester.logger;
  var path = _.pathJoin( _.pathCurrent(),path );

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( path ) );

  if( tester.verbosity > 1 )
  logger.log( 'Includes tests from :',path,'\n' );

  var files = _.fileProvider.filesFind
  ({
    filePath : path,
    ends : [ '.test.s','.test.ss','.test.js' ],
    recursive : 1,
    maskAll : _.regexpMakeSafe(),
  });

  if( !files.length )
  {
    var record = _.fileProvider.fileRecord( path );
    if( record.stat && !record.stat.isDirectory() && record.inclusion )
    var files = [ record ];
  }

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
      debugger;
      err = _.errAttend( 'Cant include',absolutePath + '\n',err );
      tester.includeFails.push( err );

      if( tester.settings.coloring )
      logger.error( _.color.strFormatForeground( 'Cant include ' + absolutePath, 'red' ) );
      else
      logger.error( 'Cant include ' + absolutePath );

      if( logger.verbosity > 3 )
      logger.error( _.err( err ) );
    }

  }

}

//

function includeTestsFrom( path )
{
  var tester = this;
  var logger = tester.logger;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( path ) );

  logger.verbosityPush( tester.verbosity === null ? tester._defaultVerbosity : tester.verbosity );
  tester._includeTestsFrom( path );
  logger.verbosityPop();

}

//

function appArgsRead()
{
  var tester = this;
  var logger = tester.logger;
  var settings = tester.settings;

  debugger;

  if( tester._appArgs )
  return tester._appArgs;

  _.assert( arguments.length === 0 );
  _.mapExtend( settings, tester.Settings );

  var readOptions =
  {
    dst : settings,
    nameMap : tester.SettingsNameMap,
    removing : 0,
    only : 1,
  }

  try
  {
    var appArgs = _.appArgsReadTo( readOptions );
    // var appArgs = _.appArgsInSamFormat();
  }
  catch ( err )
  {
    err = _.errBriefly( err );
    throw err;
  }

  _.assert( appArgs.map );

  if( !appArgs.map )
  appArgs.map = Object.create( null );

  _.mapExtend( settings,_.mapOnly( appArgs.map, tester.Settings ) );

  var v = settings.verbosity;
  _.assert( v === null || v === undefined || _.boolLike( v ) )
  if( !_.boolLike( v ) )
  v = 1;

  if( settings.beeping === null )
  settings.beeping = !!v;

  tester._appArgs = appArgs;

  tester.path = appArgs.subject || _.pathCurrent();
  tester.path = _.pathJoin( _.pathCurrent(), tester.path );

  if( _.numberIs( v ) )
  tester.verbosity = v;

  return appArgs;
}

//

function scenarioHelp()
{
  var tester = this;

  tester.scenarioScenariosList();
  tester.scenarioOptionsList();

}

//

function scenarioScenariosList()
{
  var tester = this;
  var logger = tester.logger;

  var strOptions =
  {
    levels : 3,
    wrap : 0,
    stringWrapper : '',
    multiline : 1
  };

  logger.log( 'Scenarios :\n',_.toStr( tester.ScenariosHelpMap,strOptions ),'\n' );

}

//

function scenarioOptionsList()
{
  var tester = this;
  var logger = tester.logger;

  var strOptions =
  {
    levels : 3,
    wrap : 0,
    stringWrapper : '',
    multiline : 1
  };

  logger.log( 'Tester options' );
  logger.log( _.toStr( tester.ApplicationArgumentsMap, strOptions ),'\n' );
}

//

function scenarioSuitesList()
{
  var tester = this;
  var logger = tester.logger;

  _.assert( tester.settings.scenario === 'suites.list' );

  tester.includeTestsFrom( tester.path );
  tester.suitesListPrint( tester.suitesFilterOut() );

}

// --
// run
// --

function _testAllAct()
{
  var tester = this;

  _.assert( arguments.length === 0 );

  var suites = tester.suitesFilterOut( wTests );

  return tester._suitesRun( suites );
}

//

var testAll = _.timeReadyJoin( undefined, _testAllAct );

//

function _test()
{
  var tester = this;

  _.assert( this === Self );

  if( arguments.length === 0 )
  return tester._testAllAct();

  var suites = tester.suitesFilterOut( arguments );
  return tester._suitesRun( suites );
}

//

var test = _.timeReadyJoin( undefined,_test );

//

function _testingBegin( allSuites, runSuites )
{
  var tester = this;
  var logger = tester.logger;

  _.assert( arguments.length === 2 );
  _.assert( _.numberIs( tester.verbosity ) );
  _.assert( _.mapIs( allSuites ) );
  _.assert( _.mapIs( runSuites ) );

  tester._reportForm();

  tester._canceled = 0;

  if( tester.settings.timing )
  tester._testingBeginTime = _.timeNow();

  logger.begin({ verbosity : -5 });
  logger.log( 'Tester Settings :' );
  logger.log( tester.settings );
  logger.log( '' );
  logger.end({ verbosity : -5 });

  logger.begin({ verbosity : -3 });

  /* */

  var total = _.entityLength( runSuites );
  logger.logUp( 'Launching several ( ' + total + ' ) test suites ..' );
  logger.begin({ verbosity : -5 });
  tester.suitesListPrint( allSuites );
  logger.end({ verbosity : -5 });

  logger.log();
  logger.end({ verbosity : -3 });

  /* */

  tester._cancelCon.cancel();

}

//

function _testingEnd()
{
  var tester = this;
  var logger = tester.logger;
  var ok = tester._reportIsPositive();

  if( tester.settings.beeping )
  _.beep();

  if( !ok && !_.appExitCode() )
  {
    if( tester.settings.beeping )
    _.beep();
    _.appExitCode( -1 );
  }

  /* */

  var msg = tester._reportToStr();
  logger.begin({ verbosity : -2 });
  logger.begin({ 'connotation' : ok ? 'positive' : 'negative' });
  logger.log( msg );
  logger.end({ verbosity : -2 });

  /* */

  logger.begin({ verbosity : -1 });

  var timingStr = '';
  if( tester.settings.timing )
  {
    tester.report.timeSpent = _.timeNow() - tester._testingBeginTime;
    timingStr = ' ... in ' + _.timeSpentFormat( tester.report.timeSpent );
  }

  var msg = 'Testing' + timingStr + ' ... '  + ( ok ? 'ok' : 'failed' );
  msg = _.Tester.textColor( msg, ok );

  logger.logDown( msg );

  logger.end({ 'connotation' : ok ? 'positive' : 'negative' });

  /* */

  logger.end({ verbosity : -1 });

  /* */

  logger.verbosityPop();

  _.assert( logger._hasOutput( console,{ deep : 0, ignoringUnbar : 0 } ), 'Logger of the tester does not have console in outputs.' );

  debugger;
  if( !ok )
  _.timeOut( 100,function()
  {
    _.appExit();
  });

}

//

function _suitesRun( suites )
{
  var tester = this;
  var logger = tester.logger;

  _.assert( arguments.length === 1 );

  /* */

  tester.appArgsRead();
  tester._registerExitHandler();

  /* */

  var allSuites = _.mapExtend( null, suites );
  for( var s in suites )
  {
    var suite = _.Tester.TestSuite.instanceByName( suites[ s ] );
    suites[ s ] = suite;
    allSuites[ s ] = suite;

    if( !suite.enabled )
    {
      delete suites[ s ];
      continue;
    }

    try
    {
      _.assert( suite instanceof _.Tester.TestSuite, 'Test suite', s, 'was not found' );
      suite._testSuiteRefine();
    }
    catch( err )
    {
      err = _.errBriefly( err );
      err = _.errLogOnce( err );
      err = _.errAttend( err );
      return new _.Consequence().error( err );
    }

  }

  if( !_.mapKeys( suites ).length )
  {
    tester.suitesListPrint( allSuites );
    logger.log( 'No enabled test suite to run.' );
  }

  tester._testingBegin( suites, allSuites );

  /* */

  for( var s in suites )
  {
    var suite = suites[ s ];
    suite._testSuiteRunSoon();
  }

  /* */

  _.Tester.TestSuite._suiteCon
  .doThen( function()
  {
    if( tester._reportIsPositive() )
    return _.timeOut( tester.settings.sanitareTime );
  })
  .doThen( function()
  {
    return tester._testingEnd();
  });

  return _.Tester.TestSuite._suiteCon.split();
}

//

function suitesFilterOut( suites )
{
  var tester = this;
  var logger = tester.logger;
  var suites = suites || wTests;

  if( _.arrayLike( suites ) )
  {
    var _suites = Object.create( null );
    for( var s = 0 ; s < suites.length ; s++ )
    {
      var suite = suites[ s ];
      if( _.strIs( suite ) )
      _suites[ suite ] = suite;
      else if( suite instanceof _.Tester.TestSuite )
      _suites[ suite.name ] = suite;
      else _.assert( 0,'not tested' );
    }
    suites = _suites;
  }

  _.assert( arguments.length === 0 || arguments.length === 1,'expects none or single argument, but got',arguments.length );
  _.assert( _.objectIs( suites ) );

  var suites = _.entityFilter( suites,function( suite )
  {
    if( _.strIs( suite ) )
    {
      if( !wTests[ suite ] )
      throw _.err( 'Tester : test suite',suite,'not found' );
      suite = wTests[ suite ];
    }
    if( suite.abstract )
    return;
    // if( suite.enabled !== undefined && !suite.enabled )
    // return;
    return suite;
  });

  return suites;
}

//

function suitesListPrint( suites )
{
  var tester = this;
  var logger = tester.logger;
  var suites = suites || wTests;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  _.each( suites,function( suite,k )
  {
    if( suite.enabled )
    logger.log( suite.suiteFileLocation, '-', ( suite.enabled ? 'enabled' : 'disabled' ) );
  });

  _.each( suites,function( suite,k )
  {
    if( !suite.enabled )
    logger.log( suite.suiteFileLocation, '-', ( suite.enabled ? 'enabled' : 'disabled' ) );
  });

  // logger.log( _.entitySelect( _.entityVals( suites ),'*.suiteFileLocation' ).join( '\n' ) );

  var l = _.entityLength( suites );

  logger.log( l, l > 1 ? 'test suites' : 'test suite' );

}

// --
// etc
// --

function _verbositySet( src )
{
  var tester = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  if( !_.numberIsNotNan( src ) )
  src = 0;

  tester[ symbolForVerbosity ] = src;

  if( src !== null )
  if( tester.logger )
  tester.logger.verbosity = src;

}

//

function _canContinue()
{
  var tester = this;

  // console.log( 'process._eventsCount', process._eventsCount )
  // console.log( 'process.stdin._eventsCount', process.stdin._eventsCount )
//
  // debugger;
  // if( _global_.process )
  // {
  //   // setImmediate( function(){} );
  //   // _global_.process._tickCallback()
  //   // EventEmitter.prototype.emit();
  // }
  // debugger;

  if( tester._canceled )
  return false;

  if( tester.settings.fails > 0 )
  if( tester.settings.fails <= tester.report.testCheckFails )
  {
    var err = _.err( 'Too many fails', _.Tester.settings.fails, '<=', trd.report.testCheckFails );
    tester.report.errorsArray.push( err );
    return false;
  }

  return true;
}

//

function cancel( err, terminatedByUser )
{
  var tester = this;

  if( tester._canceled )
  return tester.report.errorsArray[ tester.report.errorsArray.length-1 ];

  if( err === undefined )
  tester.report.errorsArray[ tester.report.errorsArray.length-1 ];
  err = _.err( err );

  tester._cancelCon.error( err );

  tester._canceled = 1;

  /* */

  try
  {
    for( var t = 0 ; t < tester.activeRoutines.length ; t++ )
    if( tester.activeRoutines[ t ]._returnCon )
    {
      debugger; /* xxx */
      tester.activeRoutines[ t ]._returnCon.cancel();
    }
  }
  catch( err2 )
  {
    debugger;
    console.log( err2 );
  }

  /* */

  if( terminatedByUser )
  try
  {
    debugger; /* xxx */
    for( var t = 0 ; t < tester.activeSuites.length ; t++ )
    tester.activeSuites[ t ]._testSuiteEnd( err );
  }
  catch( err2 )
  {
    debugger;
    console.log( err2 );
  }

  return err;
}

// --
// report
// --

function _reportForm()
{
  var tester = this;

  _.assert( !tester.report, 'tester already has report' );

  var report = tester.report = Object.create( null );

  report.timeSpent = null;
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
  var tester = this;
  var appExitCode = _.appExitCode();
  var report = tester.report;
  var msg = '';

  if( appExitCode !== undefined && appExitCode !== 0 )
  msg = 'ExitCode : ' + appExitCode + '\n';

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
  var tester = this;
  var report = tester.report;

  var appExitCode = _.appExitCode();
  if( appExitCode !== undefined && appExitCode !== 0 )
  return false;

  if( report.testCheckFails !== 0 )
  return false;

  if( !( report.testCheckPasses > 0 ) )
  return false;

  if( report.testCaseFails !== 0 )
  return false;

  if( report.errorsArray.length )
  return false;

  if( tester.includeFails.length )
  return false;

  return true;
}

//

function textColor( srcStr, connotation )
{

  _.assert( arguments.length === 2 );
  _.assert( _.boolLike( _.Tester.settings.coloring ) );

  if( !_.Tester.settings.coloring )
  return srcStr;

  var light = [ ' ok', ' failed' ];
  var gray = [ /test check/i, /test routine/i, /test ceck/i, '/', ' # ', ' < ', ' > ', '(', ')', ' ... in', ' in ', ' ... ', ' .. ', ':' ];
  var splits = _.strSplit2
  ({
    src : srcStr,
    delimeter : _.arrayAppendArrays( [],[ light, gray ] ),
    stripping : 0,
    preservingDelimeters : 1,
  });

  splits = splits.map( function( e, i )
  {

    if( i % 2 === 0 )
    return e;

    return _.color.strFormat( e, { fg : ( connotation ? 'green' : 'red' ) } );

    // if( i % 2 === 0 )
    // return _.color.strFormat( e, { fg : ( connotation ? 'green' : 'red' ) } );

    // if( _.arrayHas( light, e ) )
    // return _.color.strFormat( e, { fg : ( connotation ? 'light green' : 'light red' ) } );
    // else
    // return _.color.strFormat( e, { fg : 'light black' } );

  });

  return splits.join( '' );
}

// --
// consider
// --

function _testCheckConsider( outcome )
{
  var tester = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( tester === Self );

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
  var tester = this;
  var report = tester.report;

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
  var tester = this;
  var report = tester.report;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( tester === Self );

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
  var tester = this;
  var report = tester.report;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( tester === Self );

  if( outcome )
  {
    report.testSuitePasses += 1;
  }
  else
  {
    report.testSuiteFailes += 1;
  }

}

//

function _exceptionConsider( err )
{
  var tester = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( tester === Self );

  // err = _.errLogOnce( err );

  tester.report.errorsArray.push( err );
}

// // --
// // report formatter
// // --
//
// function loggerToBook( o )
// {
//
//   if( !o )
//   o = {};
//
//   o.logger = o.logger || _.Tester.logger;
//
//   _.routineOptions( loggerToBook,o );
//
//   _.assert( arguments.length === 0 || arguments.length === 1 );
//   _.assert( o.logger instanceof wPrinterToJs );
//
//   var data = o.logger.outputData;
//   var routines = _.entitySearch({ src : data, ins : 'routine', searchingValue : 0, returnParent : 1, searchingSubstring : 0 });
//   logger.log( _.toStr( routines,{ levels : 1 } ) );
//
//   /* */
//
//   var routineHead;
//   routines = _.entityFilter( routines, function( routine,k )
//   {
//     routine.folderPath = _.pathDir( k );
//     routine.itemsPath = _.pathDir( routine.folderPath );
//     routine.itemsData = _.entitySelect( data,routine.itemsPath );
//
//     if( routine.tail )
//     {
//       routineHead.data.report = [ routine ];
//       _.mapSupplement( routineHead.attributes,_.mapBut( routine,{ text : 0 } ) );
//       return;
//     }
//
//     /* checks */
//
//     debugger;
//     var checks = _.entitySearch
//     ({
//       src : routine,
//       ins : 'check',
//       searchingValue : 0,
//       searchingSubstring : 0,
//       returnParent : 1,
//     });
//
//     var routineMore = [];
//     checks = _.entityFilter( checks, function( acheck,k )
//     {
//       if( !acheck.text )
//       return;
//       if( !acheck.tail )
//       {
//         routineMore.push( acheck );
//         return;
//       }
//
//       acheck.checkPath = _.pathDir( k );
//       var result = Object.create( null );
//       result.data = acheck;
//       debugger;
//       result.text = acheck.check + ' # '+ acheck.checkIndex;
//       result.attributes = _.mapBut( acheck,{ text : 0 } );
//
//       result.kind = 'terminal';
//       result.data.report = routineMore;
//       routineMore = [];
//       return result;
//     });
//
//     checks = _.entityVals( checks );
//
//     /* routine */
//
//     var result = Object.create( null );
//     result.kind = 'branch';
//     result.data = routine;
//     result.text = routine.routine;
//     result.elements = checks;
//     result.attributes = _.mapBut( routine,{ text : 0 } );
//
//     routineHead = result;
//     return result;
//   });
//
//   /* */
//
//   logger.log( _.toStr( routines,{ levels : 1 } ) );
//   routines = _.entityVals( routines );
//
//   /* */
//
//   function handlePageGet( node )
//   {
//     if( !node.data )
//     return '-';
//     var result = _.entitySelect( node.data.report,'*.text' );
//
//     if( node.data.check )
//     result = result.join( '\n' ) + '\n' + node.data.text;
//     else if( node.data.routine )
//     result = node.data.text + '\n' + _.entitySelect( node.elements,'*.data.text' ).join( '\n' ) + '\n' + result.join( '\n' );
//
//     return result;
//   }
//
//   /* */
//
//   var book = new wHiBook({ targetDom : _.domTotalPanelMake().targetDom, onPageGet : handlePageGet });
//   book.form();
//   book.tree.treeApply({ elements : routines });
//
// }
//
// loggerToBook.defaults =
// {
//   logger : null,
// }
//
// //
//
// function bookExperiment()
// {
//
//   if( 0 )
//   _.timeReady( function()
//   {
//
//     // debugger;
//     Self.verbosity = 0;
//     //Self.logger = wPrinterToJs({ coloring : 0 });
//
//     // _.Tester.test( 'Logger other test','Consequence','FileProvider.Extract' )
//
//     _.Tester.test( 'FileProvider.Extract' )
//     .doThen( function()
//     {
//       debugger;
//       if( Self.logger )
//       logger.log( _.toStr( Self.logger.outputData,{ levels : 5 } ) );
//       debugger;
//     });
//
//   });
//
// }

// --
// var
// --

var symbolForVerbosity = Symbol.for( 'verbosity' );

var ScenariosHelpMap =
{
  'test' : 'run tests, default scenario',
  'help' : 'get help',
  'options.list' : 'list available options',
  'scenarios.list' : 'list available scenarios',
  'suites.list' : 'list available suites',
}

var ScenariosActionMap =
{
  'test' : '',
  'help' : 'scenarioHelp',
  'scenarios.list' : 'scenarioScenariosList',
  'options.list' : 'scenarioOptionsList',
  'suites.list' : 'scenarioSuitesList',
}

var ApplicationArgumentsMap =
{

  scenario : 'Name of scenario to launch. To get scenarios list use scenario : "scenarios.list". Try: "node Some.test.js scenario:scenarios.list"',
  sanitareTime : 'Delay between runs of test suites and after the last to get sure nothing throwen asynchronously later.',
  fails : 'Maximum number of fails allowed before shutting down testing.',
  beeping : 'Make beep sound after testing to let developer know it\'s done.',
  coloring : 'Switch on/off coloring.',
  timing : 'Switch on/off measuing of time.',
  rapidity : 'How rapid teststing should be done. Increasing of the option decrase number of test routine to be executed. For rigorous testing 0 or 1 should be used. 5 for the fastest. Default is 3.',

  routineTimeOut : 'Limits the time that each test routine can use. If execution of routine takes too long time then timeOut error will be thrown. Default is 5000 ms.',
  concurrent : 'Runs test suite in parallel with other test suites.',
  concurrent : 'Runs test suite in parallel with other test suites.',
  verbosity : 'Level of details of report. Zero for nothing, one for single line report, nine for maximum verbosity. Default is 5. Short-cut: "v". Try: "node Some.test.js v:2"',
  importanceOfNegative : 'Increase verbosity of test checks which fails. It helps to see only fails and hide passes. Default is 9. Short-cut: "n".',
  silencing : 'Hooking and silencing of object\'s of testing console output to make clean report of testing.',
  shoulding : 'Switch on/off all should* tests checks.',
  accuracy : 'Change default accuracy. Each test routine could have own accuracy, which cant be overwritten by this option.',

}

var SettingsNameMap =
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
  'importanceOfNegative' : 'importanceOfNegative',
  'n' : 'importanceOfNegative',
  'silencing' : 'silencing',
  'shoulding' : 'shoulding',
  'accuracy' : 'accuracy',

}

var SettingsOfTester =
{

  scenario : 'test',
  sanitareTime : 1000,
  fails : null,
  beeping : null,
  coloring : 1,
  timing : 1,
  rapidity : 3,
  routine : null,

}

var SettingsOfSuite =
{

  routine : null,
  routineTimeOut : null,
  concurrent : null,

  verbosity : null,
  importanceOfNegative : null,
  silencing : null,
  shoulding : null,
  accuracy : null,

}

var Settings = _.mapExtend( null,SettingsOfTester,SettingsOfSuite );

var Rapidities =
[
  'slowest',
  'slow',
  'normal',
  'fast',
  'fastest',
]

var Forbids =
{

  importanceOfDetails : 'importanceOfDetails',
  timeOut : 'timeOut',
  appArgs : 'appArgs',

  /**/

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
  importanceOfNegative : 'importanceOfNegative',
  silencing : 'silencing',
  shoulding : 'shoulding',
  accuracy : 'accuracy',

}

var Accessors =
{
  verbosity : 'verbosity',
}

// --
// define class
// --

var Self =
{

  // exec

  exec : exec,
  _registerExitHandler : _registerExitHandler,
  _includeTestsFrom : _includeTestsFrom,
  includeTestsFrom : includeTestsFrom,
  appArgsRead : appArgsRead,

  scenarioHelp : scenarioHelp,
  scenarioScenariosList : scenarioScenariosList,
  scenarioOptionsList : scenarioOptionsList,
  scenarioSuitesList : scenarioSuitesList,

  // run

  _testAllAct : _testAllAct,
  testAll : testAll,

  _test : _test,
  test : test,

  _testingBegin : _testingBegin,
  _testingEnd : _testingEnd,

  _suitesRun : _suitesRun,

  suitesFilterOut : suitesFilterOut,
  suitesListPrint : suitesListPrint,

  // report

  _reportForm : _reportForm,
  _reportToStr : _reportToStr,
  _reportIsPositive : _reportIsPositive,
  textColor : textColor,

  // etc

  _verbositySet : _verbositySet,
  _canContinue : _canContinue,
  cancel : cancel,

  // consider

  _testCheckConsider : _testCheckConsider,
  _testCaseConsider : _testCaseConsider,
  _testRoutineConsider : _testRoutineConsider,
  _testSuiteConsider : _testSuiteConsider,
  _exceptionConsider : _exceptionConsider,

  // report formatter
  //
  // loggerToBook : loggerToBook,
  // bookExperiment : bookExperiment,

  // var

  ScenariosHelpMap : ScenariosHelpMap,
  ScenariosActionMap : ScenariosActionMap,
  ApplicationArgumentsMap : ApplicationArgumentsMap,

  SettingsNameMap : SettingsNameMap,
  SettingsOfTester : SettingsOfTester,
  SettingsOfSuite : SettingsOfSuite,
  Settings : Settings,

  settings : Object.create( null ),

  logger : new _.Logger({ name : 'LoggerForTesting' }),
  _cancelCon : new _.Consequence(),
  _canceled : 0,

  activeSuites : [],
  activeRoutines : [],
  includeFails : [],
  report : null,

  Rapidities : Rapidities,

  sourceFileLocation : sourceFileLocation,
  sourceFileStack : sourceFileStack,

  _testingBeginTime : null,
  _isFullImplementation : 1,
  _registerExitHandlerDone : 0,

  _defaultVerbosity : 2,
  verbosity : 2,

  _barOptions : null,
  _appArgs : null,
  path : null,

  TestSuite : null,
  TestRoutineDescriptor : null,

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

_.mapSupplementNulls( Self, _.Tester );

_.assert( !_realGlobal_.wTester );
_realGlobal_.wTester = _.Tester = Self;

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
