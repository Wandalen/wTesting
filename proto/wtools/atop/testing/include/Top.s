( function _IncludeTop_s_()
{

'use strict';

//

if( typeof module !== 'undefined' )
{
  /* xxx : write test for moduling checking the module file is ok */
  require( '../../../abase/l0/l0/l0/Global.s' );

  if( _realGlobal_.wTester && _realGlobal_.wTester._isReal_ )
  return;

  const __ = _realGlobal_.wTools;
  const _global = __.global.new( 'testing', _global_ );
  __.global.open( 'testing' );
  __.module.fileSetEnvironment( module, 'testing' );

  //

  require( './Base.s' );

  require( '../l1/Namespace.s' )

  require( '../l3/TesterBasic.s' );

  require( '../l5/Routine.s' );
  require( '../l5/Suite.s' );

  require( '../l7/TesterTop.s' );

  //

  const _ = _global_.wTools;

  _.assert( _global_ !== _realGlobal_ );
  _.assert( _global_.wTools !== _realGlobal_.wTools );
  _.assert( _.routineIs( _realGlobal_.wTestSuite ) );
  _.assert( !_realGlobal_.wTestRoutineObject );
  _.assert( _.object.isBasic( _realGlobal_.wTests ) );
  _.assert( _.object.isBasic( _realGlobal_.wTester ) );
  _.assert
  (
    !_realGlobal_.wTools.time || _realGlobal_.wTools.time.sleep !== _globals_.testing.wTools.time.sleep,
    'Should have own varesion _globals_.testing.wTools.time.sleep, but does not have'
  );

  if( _global_ === _realGlobal_ || _global_.wTools === _realGlobal_.wTools )
  {
    debugger;
    throw Error( 'Something wrong, global should not be real!' );
  }

  if( Config.interpreter === 'browser' )
  debugger;
  __.global.close( 'testing' );

}

if( typeof module !== 'undefined' )
module[ 'exports' ] = _globals_.testing.wTools;

})();
