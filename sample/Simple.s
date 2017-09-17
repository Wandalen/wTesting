'use strict';

if( typeof module !== 'undefined' )
require( 'wTester' );

var _ = wTools;

//

function arrayFromRange( test )
{

  test.description = 'single zero';
  var got = _.arrayFromRange([ 0,1 ]);
  var expected = [ 0 ];
  test.identical( got,expected );

  test.description = 'nothing';
  var got = _.arrayFromRange([ 1,1 ]);
  var expected = [];
  test.identical( got,expected );

  test.description = 'single not zero';
  var got = _.arrayFromRange([ 1,2 ]);
  var expected = [ 1 ];
  test.identical( got,expected );

  test.description = 'couple of elements';
  var got = _.arrayFromRange([ 1,3 ]);
  var expected = [ 1,2 ];
  test.identical( got,expected );

  test.description = 'single number as argument';
  var got = _.arrayFromRange( 3 );
  var expected = [ 0,1,2 ];
  test.identical( got,expected );

  test.description = 'complex case';
  var got = _.arrayFromRange([ 3,9 ]);
  var expected = [ 3,4,5,6,7,8 ];
  test.identical( got,expected );

  /**/

  if( !Config.debug )
  return;

  test.description = 'extra argument';
  test.shouldThrowError( function()
  {
    _.arrayFromRange( [ 1,3 ],'wrong arguments' );
  });

  test.description = 'argument not wrapped into array';
  test.shouldThrowError( function()
  {
    _.arrayFromRange( 1,3 );
  });

  test.description = 'wrong type of argument';
  test.shouldThrowError( function()
  {
    _.arrayFromRange( 'wrong arguments' );
  });

  test.description = 'no arguments'
  test.shouldThrowError( function()
  {
    _.arrayFromRange();
  });

}

//

var Self =
{

  name : 'Simple Sample',

  tests :
  {

    arrayFromRange : arrayFromRange,

  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self );
