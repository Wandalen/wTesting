( function simple1_js( ) {

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

  var got = _.arrayRange([ 1,1 ]);
  var expected = [];
  test.identical( got,expected );

  var got = _.arrayRange([ 1,2 ]);
  var expected = [ 1 ];
  test.identical( got,expected );

  var got = _.arrayRange([ 1,3 ]);
  var expected = [ 1,2 ];
  test.identical( got,expected );

  var got = _.arrayRange( 3 );
  var expected = [ 0,1,2 ];
  test.identical( got,expected );

  var got = _.arrayRange([ 3,9 ]);
  var expected = [ 3,4,5,6,7,8 ];
  test.identical( got,expected );

  /**/

  if( Config.debug )
  {

    test.shouldThrowError( function()
    {
      _.arrayRange( [ 1,3 ],'wrong arguments' );
    });

    test.shouldThrowError( function()
    {
      _.arrayRange( 1,3 );
    });

    test.shouldThrowError( function()
    {
      _.arrayRange( 'wrong arguments' );
    });

    test.shouldThrowError( function()
    {
      _.arrayRange();
    });

  }

}

//

var Proto =
{

  name : 'simple1',

  tests:
  {

    arrayRange : arrayRange,

  }

}

_.mapExtend( Self,Proto );

if( typeof module !== 'undefined' && !module.parent )
_.testing.test( Self );

} )( );
