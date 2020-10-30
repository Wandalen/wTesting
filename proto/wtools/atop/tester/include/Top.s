( function _IncludeTop_s_()
{

'use strict';

// global

let _global = undefined;
if( !_global && typeof Global !== 'undefined' && Global.Global === Global ) _global = Global;
if( !_global && typeof global !== 'undefined' && global.global === global ) _global = global;
if( !_global && typeof window !== 'undefined' && window.window === window ) _global = window;
if( !_global && typeof self   !== 'undefined' && self.self === self ) _global = self;
if( !_global._globals_ )
{
  _global._globals_ = Object.create( null );
  _global._globals_.real = _global;
}
let _realGlobal = _global._realGlobal_ = _global;
let _wasGlobal = _global._global_ || _global;
_global = _wasGlobal;
_global._global_ = _wasGlobal;

//

if( typeof module !== 'undefined' )
{

  if( _realGlobal_.wTester && _realGlobal_.wTester._isReal_ )
  {
    return;
  }

  let Module = require( 'module' );
  let cache = Module._cache;
  Module._cache = Object.create( null );

  _global = _global._global_ = Object.create( _global._global_ );
  _global.__GLOBAL_WHICH__ = 'wTesting';
  _realGlobal_._testerGlobal_ = _global;
  _realGlobal_._globals_.testing = _global;

  //

  require( './Base.s' );

  require( '../l1/Namespace.s' )

  require( '../l3/TesterBasic.s' );

  require( '../l5/Routine.s' );
  require( '../l5/Suite.s' );

  require( '../l7/TesterTop.s' );

  //

  let _ = _global_.wTools;

  _.assert( _global_ !== _realGlobal_ );
  _.assert( _global_.wTools !== _realGlobal_.wTools );
  _.assert( _global_.wTools === _ );
  _.assert( _.routineIs( _realGlobal_.wTestSuite ) );
  _.assert( !_realGlobal_.wTestRoutineDescriptor );
  _.assert( _.objectIs( _realGlobal_.wTests ) );
  _.assert( _.objectIs( _realGlobal_.wTester ) );

  if( _global_ === _realGlobal_ || _global_.wTools === _realGlobal_.wTools )
  {
    debugger;
    throw Error( 'Something wrong, global should not be real!' );
  }

  if( Config.interpreter === 'browser' )
  debugger;
  Module._cache = cache;
  _global_ = _wasGlobal;

}

if( typeof module !== 'undefined' )
module[ 'exports' ] = _testerGlobal_.wTools;

})();
