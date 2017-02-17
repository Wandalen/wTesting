( function _Simple_s( ) {

'use strict';

if( typeof module !== 'undefined' )
require( 'wTesting' );

var _ = wTools;

//

function arrayRange( test )
{

  test.description = 'single zero';
  var got = _.arrayRange([ 0,1 ]);
  var expected = [ 0 ];
  test.identical( got,expected );

  test.description = 'nothing';
  var got = _.arrayRange([ 1,1 ]);
  var expected = [];
  test.identical( got,expected );

  test.description = 'single not zero';
  var got = _.arrayRange([ 1,2 ]);
  var expected = [ 1 ];
  test.identical( got,expected );

  test.description = 'couple of elements';
  var got = _.arrayRange([ 1,3 ]);
  var expected = [ 1,2 ];
  test.identical( got,expected );

  test.description = 'single number as argument';
  var got = _.arrayRange( 3 );
  var expected = [ 0,1,2 ];
  test.identical( got,expected );

  test.description = 'complex case';
  var got = _.arrayRange([ 3,9 ]);
  var expected = [ 3,4,5,6,7,8 ];
  test.identical( got,expected );

  /**/

  if( Config.debug )
  {

    test.description = 'extra argument';
    test.shouldThrowError( function()
    {
      _.arrayRange( [ 1,3 ],'wrong arguments' );
    });

    test.description = 'argument not wrapped into array';
    test.shouldThrowError( function()
    {
      _.arrayRange( 1,3 );
    });

    test.description = 'wrong type of argument';
    test.shouldThrowError( function()
    {
      _.arrayRange( 'wrong arguments' );
    });

    test.description = 'no arguments'
    test.shouldThrowError( function()
    {
      _.arrayRange();
    });

  }

}

//

var Self =
{

  name : 'simple1',

  tests :
  {

    arrayRange : arrayRange,

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self );

} )( );
