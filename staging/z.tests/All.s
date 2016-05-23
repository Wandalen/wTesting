( function( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../object/zTesting.debug.s' );

  require( './ArraySorted.test.s' );
  require( './Consequence.test.s' );
  require( './EventHandler.test.s' );
  require( './String.test.s' );

}

if( typeof module !== 'undefined' && !module.parent )
wTools.testing.testAll();

} )( );
