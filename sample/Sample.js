( function _Sample_test_s_( ) {

'use strict';

/*

to run this test
from the project directory run

npm install
node ./staging/layer1.test/Sample.test.s

*/

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  var _ = _global_.wTools;

  _.include( 'wTesting' );

}

var _ = _global_.wTools;

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
  test.shouldThrowErrorSync( function()
  {
    _.arrayFromRange( [ 1,3 ],'wrong arguments' );
  });

  test.description = 'argument not wrapped into array';
  test.shouldThrowErrorSync( function()
  {
    _.arrayFromRange( 1,3 );
  });

  test.description = 'wrong type of argument';
  test.shouldThrowErrorSync( function()
  {
    _.arrayFromRange( 'wrong arguments' );
  });

  test.description = 'no arguments'
  test.shouldThrowErrorSync( function()
  {
    _.arrayFromRange();
  });

}

//

var Self =
{

  name : 'simple1',
  silencing : 1,

  tests :
  {

    arrayFromRange : arrayFromRange,

  }

}

//

Self = wTestSuit( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();
