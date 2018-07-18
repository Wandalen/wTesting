(function _zLast_debyg_s_() {

'use strict';

var _global = _global_;
var _ = _global_.wTools;

var testsWas = _realGlobal_.wTests;
_realGlobal_.wTests = _global_.wTests = wTestSuite.instancesMap;

if( testsWas )
wTestSuite.prototype._testSuitesRegister( testsWas );

if( _global_.WTOOLS_PRIVATE )
{
  _.assert( _global_.wTools !== _realGlobal_.wTools );
}

_.assert( _global_.wTools === _ );
_.assert( _realGlobal_.wTestSuite );
_.assert( !_realGlobal_.wTestRoutineDescriptor );
_.assert( _realGlobal_.wTests );
_.assert( _realGlobal_.wTester );

if( _global_.WTOOLS_PRIVATE )
_realGlobal_._global_ = _global_._globalWas_;

if( typeof module !== 'undefined' && !module.parent && !module.isBrowser )
_global_.wTester.exec();

})();
