(function _zLast_debyg_s_() {

'use strict';

var _global = _global_; var _ = _global_.wTools;

var testsWas = _globalReal_.wTests;
_globalReal_.wTests = _global_.wTests = wTestSuit.instancesMap;

if( testsWas )
wTestSuit.prototype._registerSuits( testsWas );

if( _global_.WTOOLS_PRIVATE )
{
  _.assert( _global_.wTools !== _globalReal_.wTools );
}

_.assert( _global_.wTools === _ );
_.assert( _globalReal_.wTestSuit );
_.assert( !_globalReal_.wTestRoutineDescriptor );
_.assert( _globalReal_.wTests );
_.assert( _globalReal_.wTester );

if( _global_.WTOOLS_PRIVATE )
_globalReal_._global_ = _global_._globalWas_;

if( typeof module !== 'undefined' && !module.parent && !module.isBrowser )
_global_.wTester.exec();

})();
