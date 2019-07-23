(function _Include_mid_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  require( './IncludeBase.s' );

  require( './l5/Routine.s' );
  require( './l5/Suite.s' );
  require( './l5/Tester.s' );

}

var _global = _global_;
var _ = _global_.wTools;

var testsWas = _realGlobal_.wTests;
_realGlobal_.wTests = _global_.wTests = wTestSuite.instancesMap;

if( testsWas )
wTestSuite.prototype.Froms( testsWas );

// if( _global_.WTOOLS_PRIVATE )
{
  _.assert( _global_ !== _realGlobal_ );
  _.assert( _global_.wTools !== _realGlobal_.wTools );
}

_.assert( _global_.wTools === _ );
_.assert( _.routineIs( _realGlobal_.wTestSuite ) );
_.assert( !_realGlobal_.wTestRoutineDescriptor );
_.assert( _.objectIs( _realGlobal_.wTests ) );
_.assert( _.objectIs( _realGlobal_.wTester ) );

})();
