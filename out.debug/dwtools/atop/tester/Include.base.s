(function _Include_base_s_() {

'use strict';

/* !!! try to tokenize the file */

// let _global = undefined;
// if( !_global && typeof Global !== 'undefined' && Global.Global === Global ) _global = Global;
// if( !_global && typeof global !== 'undefined' && global.global === global ) _global = global;
// if( !_global && typeof window !== 'undefined' && window.window === window ) _global = window;
// if( !_global && typeof self   !== 'undefined' && self.self === self ) _global = self;
// let _realGlobal = _global._realGlobal_ = _global;
// let _wasGlobal = _global._global_ || _global;
// _global = _wasGlobal;
// _global._global_ = _wasGlobal;
//
// if( _realGlobal_._SeparatingTester_ )
// {
//   _global = _global._global_ = Object.create( _global._global_ );
//   _global.WTOOLS_PRIVATE = true;
//   _global._wasGlobal_ = _wasGlobal;
// }

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  _.include( 'wLooker' );
  _.include( 'wSelector' );
  _.include( 'wComparator' );
  // _.include( 'wLookerExtra' );
  _.include( 'wExternalFundamentals' );
  _.include( 'wCopyable' );
  _.include( 'wInstancing' );
  _.includeAny( 'wEventHandler','' );
  _.include( 'wLogger' );
  _.include( 'wConsequence' );
  _.include( 'wFiles' );
  _.include( 'wLogger' );
  _.include( 'wStringsExtra' );

  // _.includeAny( 'wScriptLauncher' );

  _.assert( !_realGlobal_.wTester || !_realGlobal_.wTester._isReal_,'wTester is already included' );

  // require( './aTestSuite.debug.s' );
  // require( './bTestRoutine.debug.s' );
  // require( './cTester.debug.s' );
  // require( './zLast.debug.s' );

}

})();
