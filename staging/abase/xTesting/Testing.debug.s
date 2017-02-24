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
var sourceFilePath = typeof module !== 'undefined' ? __filename : document.scripts[ document.scripts.length-1 ].src;

// if( !_.toStr )
// _.toStr = function(){ return String( arguments ) };

_.assert( _.toStr,'wTesting needs wTools/staging/abase/component/StringTools.s' );
_.assert( _.execStages,'wTesting needs wTools/staging/abase/component/ExecTools.s' );
_.assert( _.Consequence,'wTesting needs wConsequence/staging/abase/syn/Consequence.s' );

// --
// tester
// --

function testAll()
{
  var self = this;
  var logger = self.logger || _global_.logger;

  _.assert( arguments.length === 0 );

  debugger;

  logger.logUp( 'Launching all test suites ..' );

  for( var t in wTests )
  {
    if( wTests[ t ].abstract )
    continue;
    self.test( t );
  }

  wTestSuite._suiteCon.doThen( function()
  {

    logger.logDown( 'All test suites ran out.' );

  });

  return wTestSuite._suiteCon.splitThen();
}

//

function test( )
{
  var proto = this;
  var args = arguments;

  _.assert( this === Self );

  if( arguments.length === 0 )
  return proto.testAll();

  for( var a = 0 ; a < arguments.length ; a++ )
  {
    var _suite = arguments[ a ];
    var suite = wTestSuite.instanceByName( _suite );

    _.assert( suite instanceof wTestSuite,'Test suite',_suite,'was not found' );
    _.assert( _.strIsNotEmpty( suite.name ),'testing suite should has ( name )' );
    _.assert( _.objectIs( suite.tests ),'testing suite should has map with test routines ( tests )' );

    suite._testSuiteRunLater();
  }

  return wTestSuite._suiteCon.splitThen();
}

// --
// prototype
// --

var Self =
{

  // routine

  testAll : testAll,
  test : test,

  // var

  verbosity : null,
  logger : null,

  currentSuite : null,
  _full : true,
  sourceFilePath : sourceFilePath,

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
