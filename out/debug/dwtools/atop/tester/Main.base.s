(function _Main_base_s_() {

/**
 * Framework for convenient unit testing. Testing provides the intuitive interface, simple tests structure, asynchronous code handling mechanism, colorful report, verbosity control and more. Use the module to get free of routines which can be automated..
  @module Tools/Tester
*/

/**
 * @file Main.bse.s
 */

'use strict';

if( typeof module !== 'undefined' )
{

  require( './Include.mid.s' );

}

var _global = _global_;
var _ = _global_.wTools;

var testsWas = _realGlobal_.wTests;
_realGlobal_.wTests = _global_.wTests = wTestSuite.instancesMap;

if( testsWas )
wTestSuite.prototype._testSuitesRegister( testsWas );

if( _global_.WTOOLS_PRIVATE )
{
  _.assert( _global_ !== _realGlobal_ );
  _.assert( _global_.wTools !== _realGlobal_.wTools );
}

_.assert( _global_.wTools === _ );
_.assert( _.routineIs( _realGlobal_.wTestSuite ) );
_.assert( !_realGlobal_.wTestRoutineDescriptor );
_.assert( _.objectIs( _realGlobal_.wTests ) );
_.assert( _.objectIs( _realGlobal_.wTester ) );

// if( _global_.WTOOLS_PRIVATE )
// _realGlobal_._global_ = _global_._wasGlobal_;
//
// if( typeof module !== 'undefined' && !module.parent && !module.isBrowser )
// _global_.wTester.exec();

})();
