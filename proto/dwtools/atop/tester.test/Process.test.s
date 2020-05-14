( function _Process_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  if( typeof _realGlobal_ === 'undefined' || !_realGlobal_.wTester || !_realGlobal_.wTester._isReal_ )
  require( '../tester/MainTop.s' );

  _.include( 'wLogger' );
  _.include( 'wConsequence' );
  _.include( 'wProcedure' );
  _.include( 'wAppBasic' );
  _.include( 'wFiles' );

}

var _global = _global_;
var _ = _global_.wTools;

function onSuiteEnd()
{
  throw 1;
}

// --
// tools
// --

function trivial( test )
{
  var o = 
  {
    execPath : 'node -e "setTimeout(()=>{},10000)"', 
    inputMirroring : 1,
    throwingExitCode : 1,
    mode : 'spawn'
  }
  return _.process.start( o )
}

var Self =
{

  name : 'Tools.Tester.Process',
  silencing : 1,
  onSuiteEnd,
  routineTimeOut : 3000,
  processWatching : 1,

  context :
  {
  },

  tests :
  {

    trivial,
  },

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
