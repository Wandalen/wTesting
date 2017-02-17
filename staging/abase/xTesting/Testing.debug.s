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

// if( !_.toStr )
// _.toStr = function(){ return String( arguments ) };

_.assert( _.toStr );

// --
// tester
// --

// function register( testSuite )
// {
//   var self = this;
//
//   _.assert( arguments.length > 0 );
//
//   for( var a = 0 ; a < arguments.length ; a++ )
//   {
//
//     var testSuite = arguments[ a ];
//
//     _.assert( _.strIsNotEmpty( testSuite.name ),'Test suite should have name' );
//     _.assert( !_global_.wTests[ testSuite.name ],'Test suite with name',testSuite.name,'already registered!' );
//
//     _global_.wTests[ testSuite.name ] = wTestSuite( testSuite );
//
//     // console.log( 'Test suite ',testSuite.name,_global_.wTests[ testSuite.name ].logger );
//
//   }
//
//   return self;
// }

//

function testAll()
{
  var self = this;

  _.assert( arguments.length === 0 );

  self.logger.log( 'Launching all test suites' );

  for( var t in wTests )
  {
    self.test( t );
  }

}

//

function test( _suite )
{
  var proto = this;
  var args = arguments;

  _.assert( this === Self );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( _suite === undefined )
  return testAll();

  var suite = wTestSuite.instanceByName( _suite );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( suite instanceof wTestSuite,'Test suite',_suite,'was not found' );
  _.assert( _.strIsNotEmpty( suite.name ),'testing suite should has name' );
  _.assert( _.objectIs( suite.tests ),'testing suite should has map with test routines' );

  return suite._testSuiteRunDelayed();
}

// --
//
// --

// var Statics =
// {
//
//   // EPS : 1e-5,
//
//   // safe : 1,
//   // usingSourceCode : 1,
//   // verbosity : 0,
//
//   // _conSyn : null,
//   // logger : logger,
//
// }

// --
// prototype
// --

var Self =
{


  // tester

  /* register : register, */

  testAll : testAll,
  test : test,

  //

  _full : true,

}

// _.mapExtend( Self,Statics );

wTools.Testing = Self;

if( typeof module !== 'undefined' && module !== null )
{
  require( './aTestSuite.debug.s' );
  module[ 'exports' ] = Self;
}

var wTestsWas = _global_.wTests;
_global_.wTests = wTestSuite.instancesMap;
debugger;
if( wTestsWas )
wTestSuite.prototype._registerSuites( wTestsWas );

})();
