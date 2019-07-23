(function _Include_top_s_() {

'use strict';

// global

let _global = undefined;
if( !_global && typeof Global !== 'undefined' && Global.Global === Global ) _global = Global;
if( !_global && typeof global !== 'undefined' && global.global === global ) _global = global;
if( !_global && typeof window !== 'undefined' && window.window === window ) _global = window;
if( !_global && typeof self   !== 'undefined' && self.self === self ) _global = self;
let _realGlobal = _global._realGlobal_ = _global;
let _wasGlobal = _global._global_ || _global;
_global = _wasGlobal;
_global._global_ = _wasGlobal;

//

if( typeof module !== 'undefined' )
{

  if( _realGlobal.wTester && _realGlobal.wTester._isReal_ )
  {
    return;
  }

  let Module = require( 'module' );
  let cache = Module._cache;
  Module._cache = Object.create( null );

  _global = _global._global_ = Object.create( _global._global_ );
  // _global.WTOOLS_PRIVATE = true;
  _global.__GLOBAL_WHICH__ = 'wTesting';
  // _realGlobal.__GLOBAL_SEPARATING_FOR_TESTER__ = _global.__GLOBAL_SEPARATING_FOR_TESTER__ = 1;
  _realGlobal._testerGlobal_ = _global;

  //

  require( './IncludeMid.s' );

  var _ = _global_.wTools;

  var testsWas = _realGlobal_.wTests;
  _realGlobal_.wTests = _global_.wTests = wTestSuite.instancesMap;

  if( testsWas )
  wTestSuite.prototype.Froms( testsWas );

  // if( _global_.WTOOLS_PRIVATE )
  // {
    _.assert( _global_ !== _realGlobal_ );
    _.assert( _global_.wTools !== _realGlobal_.wTools );
  // }

  _.assert( _global_.wTools === _ );
  _.assert( _.routineIs( _realGlobal_.wTestSuite ) );
  _.assert( !_realGlobal_.wTestRoutineDescriptor );
  _.assert( _.objectIs( _realGlobal_.wTests ) );
  _.assert( _.objectIs( _realGlobal_.wTester ) );

  //

  if( _global_ === _realGlobal_ || _global_.wTools === _realGlobal_.wTools )
  {
    debugger;
    throw 'Something wrong, global should not be real!';
  }

  // _realGlobal.__GLOBAL_SEPARATING_FOR_TESTER__ = _global.__GLOBAL_SEPARATING_FOR_TESTER__ = 2;
  Module._cache = cache;
  _global_ = _wasGlobal;

}

if( typeof module !== 'undefined' && !module.parent )
_global.wTester.exec();

})();
