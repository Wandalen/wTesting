
if( typeof module !== 'undefined' )
require( 'wTesting' );

let _ = _globals_.testing.wTools;

//

function arrayFromRange( test )
{

  test.case = 'single zero';
  var got = _.longFromRange([ 0,1 ]);
  var expected = [ 0 ];
  test.identical( got,expected );

  test.case = 'nothing';
  var got = _.longFromRange([ 1,1 ]);
  var expected = [];
  test.identical( got,expected );

  test.case = 'single not zero';
  var got = _.longFromRange([ 1,2 ]);
  var expected = [ 1 ];
  test.identical( got,expected );

  test.case = 'couple of elements';
  var got = _.longFromRange([ 1,3 ]);
  var expected = [ 1,2 ];
  test.identical( got,expected );

  test.case = 'single number as argument';
  var got = _.longFromRange( 3 );
  var expected = [ 0,1,2 ];
  test.identical( got,expected );

  test.case = 'complex case';
  var got = _.longFromRange([ 3,9 ]);
  var expected = [ 3,4,5,6,7,8 ];
  test.identical( got,expected );

  /* */

  if( !Config.debug )
  return;

  test.case = 'extra argument';
  test.shouldThrowErrorSync( function()
  {
    _.longFromRange( [ 1,3 ],'wrong arguments' );
  });

  test.case = 'argument not wrapped into array';
  test.shouldThrowErrorSync( function()
  {
    _.longFromRange( 1,3 );
  });

  test.case = 'wrong type of argument';
  test.shouldThrowErrorSync( function()
  {
    _.longFromRange( 'wrong arguments' );
  });

  test.case = 'no arguments'
  test.shouldThrowErrorSync( function()
  {
    _.longFromRange();
  });

}

//

let Self =
{

  name : 'Sample/Trivial',
  silencing : 1,

  tests :
  {

    arrayFromRange : arrayFromRange,

  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
