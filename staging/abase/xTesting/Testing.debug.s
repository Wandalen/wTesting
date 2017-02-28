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

_.assert( _.toStr,'wTesting needs wTools/staging/abase/component/StringTools.s' );
_.assert( _.execStages,'wTesting needs wTools/staging/abase/component/ExecTools.s' );
_.assert( _.Consequence,'wTesting needs wConsequence/staging/abase/syn/Consequence.s' );

// --
// tester
// --

function exec()
{

  _.assert( arguments.length === 0 );

  var path = process.argv[ 2 ] || _.pathCurrent();
  console.log( 'argv :', process.argv );

  path = _.pathJoin( _.pathCurrent(),path );

  _.include( '../z.test/Path.all.test.s' );
  //_.includeFrom( path );

  this.testAll();

}

// function testAll()
// {
//   var testing = this;
//
//   debugger;
//   return _.timeReady( function()
//   {
//     debugger;
//     return testing._testAllAct();
//   });
//
// }

//

function _testAllAct()
{
  var testing = this;
  debugger;

  _.assert( arguments.length === 0 );

  testing._testingBegin();

  for( var t in wTests )
  {
    if( wTests[ t ].abstract )
    continue;
    testing.test( t );
  }

  wTestSuite._suiteCon.doThen( function()
  {
    return testing._testingEnd();
  });

  return wTestSuite._suiteCon.splitThen();
}

//

var testAll = _.timeReadyJoin( undefined,_testAllAct );

//

// function test()
// {
//   var testing = this;
//   var args = arguments;
//
//   debugger;
//   return _.timeReady( function()
//   {
//     debugger;
//     return testing._testAct.apply( testing,args );
//   });
//
// }

//

function _testAct()
{
  var testing = this;

  _.assert( this === Self );

  if( arguments.length === 0 )
  return testing._testAllAct();

  testing._testingBegin( arguments );

  for( var a = 0 ; a < arguments.length ; a++ )
  {
    var _suite = arguments[ a ];
    var suite = wTestSuite.instanceByName( _suite );

    _.assert( suite instanceof wTestSuite,'Test suite',_suite,'was not found' );
    _.assert( _.strIsNotEmpty( suite.name ),'testing suite should has ( name )' );
    _.assert( _.objectIs( suite.tests ),'testing suite should has map with test routines ( tests )' );

    suite._testSuiteRunLater();
  }

  return wTestSuite._suiteCon
  .splitThen( function()
  {
    return testing._testingEnd();
  });
}

//

var test = _.timeReadyJoin( undefined,_testAct );

//

function _testingReportNew()
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

function _testingBegin()
{
  var testing = this;
  var logger = testing.logger || _global_.logger;

  if( arguments.length )
  logger.logUp( 'Launching several test suites ..' );
  else
  logger.logUp( 'Launching all test suites ..' );

  logger.log();

  testing._testingReportNew();

}

//

function _testingEnd()
{
  var testing = this;
  var logger = testing.logger || _global_.logger;
  var ok = testing.report.testCaseFails === 0;

  var msg = '';
  msg += 'Passed test cases ' + ( testing.report.testCasePasses ) + ' / ' + ( testing.report.testCasePasses + testing.report.testCaseFails ) + '\n';
  msg += 'Passed test routines ' + ( testing.report.testRoutinePasses ) + ' / ' + ( testing.report.testRoutinePasses + testing.report.testRoutineFails ) + '\n';
  msg += 'Passed test suites ' + ( testing.report.testSuitePasses ) + ' / ' + ( testing.report.testSuitePasses + testing.report.testSuiteFailes ) + '';

  // var msg =
  // [
  //   '' + _.toStr( testing.report,{ wrap : 0, multiline : 1 } )
  // ];

  logger.log();
  logger.log( _.strColor.style( msg,[ ok ? 'good' : 'bad' ] ) );

  var msg = _.strColor.style( 'Testing .. ' + ( ok ? 'ok' : 'failed' ),[ ok ? 'good' : 'bad' ] );

  logger.logDown( msg );

}

// --
//
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
  routines = _.entityMap( routines, function( routine,k )
  {
    routine.folderPath = _.pathDir( k );
    routine.itemsPath = _.pathDir( routine.folderPath );
    routine.itemsData = _.entitySelect( data,routine.itemsPath );

    if( routine.tail )
    {
      routineHead.data.report = [ routine ];
      return;
    }

    /* cases */

    var cases = _.entitySearch({ src : routine, ins : 'case', searchingValue : 0, searchingSubstring : 0, returnParent : 1 });

    var routineMore = [];
    cases = _.entityMap( cases, function( acase,k )
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

      result.kind = 'terminal';
      result.data.report = routineMore;
      routineMore = [];
      return result;
    });

    cases = _.mapValues( cases );

    /* folder */

    var result = Object.create( null );
    result.kind = 'branch';
    result.data = routine;
    result.text = routine.routine;
    result.elements = cases;

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
// prototype
// --

var Self =
{

  // routine

  exec : exec,

  _testAllAct : _testAllAct,
  testAll : testAll,

  _testAct : _testAct,
  test : test,

  _testingReportNew : _testingReportNew,
  _testingBegin : _testingBegin,
  _testingEnd : _testingEnd,


  //

  loggerToBook : loggerToBook,


  // var

  testRoutineTimeOut : 3000,

  verbosity : null,
  logger : null,

  currentSuite : null,
  _full : true,
  sourceFilePath : sourceFilePath,

  report : null,
  constructor : function wTesting(){},

}

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
