( function( ) {

'use strict';

if( typeof module !== 'undefined' )
require( 'wTesting' );

var _ = wTools;
var Self = {};

//

var arrayRange = function( test )
{

  var got = _.arrayRange([ 0,1 ]);
  var expected = [ 0 ];

  test.identical( got,expected );

}

//

var Proto =
{

  arrayRange : arrayRange,

}

_.mapExtend( Self,Proto );

if( typeof module !== 'undefined' && !module.parent )
_.testing.test( Self );

} )( );
