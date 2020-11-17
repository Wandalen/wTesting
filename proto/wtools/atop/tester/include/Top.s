( function _IncludeTop_s_()
{

'use strict';

// global

let _global = undefined;
if( typeof _global_ !== 'undefined' && _global_._global_ === _global_ )
_global = _global_;
else if( typeof globalThis !== 'undefined' && globalThis.globalThis === globalThis )
_global = globalThis;
else if( typeof Global !== 'undefined' && Global.Global === Global )
_global = Global;
else if( typeof global !== 'undefined' && global.global === global )
_global = global;
else if( typeof window !== 'undefined' && window.window === window )
_global = window;
else if( typeof self   !== 'undefined' && self.self === self )
_global = self;
if( !_global._globals_ )
{
  _global._globals_ = Object.create( null );
  _global._globals_.real = _global;
  _global._realGlobal_ = _global;
  _global._global_ = _global;
}

//

let _wasGlobal, _wasCache;
function globalNamespaceOpen( _global, name )
{
  if( _realGlobal_._globals_[ name ] )
  throw Error( 'Global namespace::name already exists!' );
  let Module = require( 'module' );
  _wasCache = Module._cache;
  _wasGlobal = _global;
  Module._cache = Object.create( null );
  _global = Object.create( _global );
  _global.__GLOBAL_NAME__ = name;
  _global._global_ = _global;
  _realGlobal_._global_ = _global;
  _realGlobal_._globals_[ name ] = _global;
  return _global;
}

//

function globalNamespaceClose()
{
  let Module = require( 'module' );
  Module._cache = _wasCache;
  _realGlobal_._global_ = _wasGlobal;
}

//

if( typeof module !== 'undefined' )
{

  if( _realGlobal_.wTester && _realGlobal_.wTester._isReal_ )
  return;

  _global = globalNamespaceOpen( _global, 'testing' );

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
  _.assert( _.routineIs( _realGlobal_.wTestSuite ) );
  _.assert( !_realGlobal_.wTestRoutineObject );
  _.assert( _.objectIs( _realGlobal_.wTests ) );
  _.assert( _.objectIs( _realGlobal_.wTester ) );

  if( _global_ === _realGlobal_ || _global_.wTools === _realGlobal_.wTools )
  {
    debugger;
    throw Error( 'Something wrong, global should not be real!' );
  }

  if( Config.interpreter === 'browser' )
  debugger;
  globalNamespaceClose();

}

if( typeof module !== 'undefined' )
module[ 'exports' ] = _globals_.testing.wTools;

})();
