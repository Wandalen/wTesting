( function _file_All_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  try
  {
    require( '../../abase/xTesting/Testing.debug.s' );
  }
  catch( err )
  {
    require( 'wTesting' );
  }

  require( './ArraySorted.test.s' );
  require( './Consequence.test.s' );
  require( './EventHandler.test.s' );
  require( './String.test.s' );

  require( './RegExp.test.s' );
  require( './Map.test.s' );

}

if( typeof module !== 'undefined' && !module.parent )
wTools.Testing.testAll();

} )( );
