( function _file_All_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  if( require( 'fs' ).existsSync( __dirname + '/../object/Testing.debug.s' ) )
  require( '../object/Testing.debug.s' );
  else
  require( 'wTesting' );

  require( './ArraySorted.test.s' );
  require( './Consequence.test.s' );
  require( './EventHandler.test.s' );
  require( './String.test.s' );

  require( './RegExp.test.s' );
  require( './Map.test.s' );

}

if( typeof module !== 'undefined' && !module.parent )
wTools.testing.testAll();

} )( );
