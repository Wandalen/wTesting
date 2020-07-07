
if( typeof module !== 'undefined' )
require( 'wTesting' );

var _ = _global_.wTools;

//

function arrayFromRange( test )
{

  test.case = 'single zero';
  var got = _.arrayFromRange([ 0,1 ]);
  var expected = [ 0 ];
  test.identical( got,expected );

  test.case = 'nothing';
  var got = _.arrayFromRange([ 1,1 ]);
  var expected = [];
  test.identical( got,expected );

  test.case = 'single not zero';
  var got = _.arrayFromRange([ 1,2 ]);
  var expected = [ 1 ];
  test.identical( got,expected );

  test.case = 'couple of elements';
  var got = _.arrayFromRange([ 1,3 ]);
  var expected = [ 1,2 ];
  test.identical( got,expected );

  test.case = 'single number as argument';
  var got = _.arrayFromRange( 3 );
  var expected = [ 0,1,2 ];
  test.identical( got,expected );

  test.case = 'complex case';
  var got = _.arrayFromRange([ 3,9 ]);
  var expected = [ 3,4,5,6,7,8 ];
  test.identical( got,expected );

  /* */

  if( !Config.debug )
  return;

  test.case = 'extra argument';
  test.shouldThrowErrorSync( function()
  {
    _.arrayFromRange( [ 1,3 ],'wrong arguments' );
  });

  test.case = 'argument not wrapped into array';
  test.shouldThrowErrorSync( function()
  {
    _.arrayFromRange( 1,3 );
  });

  test.case = 'wrong type of argument';
  test.shouldThrowErrorSync( function()
  {
    _.arrayFromRange( 'wrong arguments' );
  });

  test.case = 'no arguments'
  test.shouldThrowErrorSync( function()
  {
    _.arrayFromRange();
  });

}

//

var Self =
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
_.Tester.test( Self.name );
