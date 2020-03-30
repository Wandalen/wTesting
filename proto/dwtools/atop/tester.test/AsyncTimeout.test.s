( function _AsyncTimeout_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../dwtools/Tools.s' );

  if( typeof _realGlobal_ === 'undefined' || !_realGlobal_.wTester || !_realGlobal_.wTester._isReal_ )
  require( '../tester/MainTop.s' );

  _.include( 'wLogger' );
  _.include( 'wConsequence' );
  _.include( 'wProcedure' );
  _.include( 'wAppBasic' );
  _.include( 'wFiles' );

}

var _global = _global_;
var _ = _global_.wTools;
var notTakingIntoAccount = { logger : _.Logger({ output : null }), concurrent : 1, takingIntoAccount : 0 };

// --
// tools
// --

function asyncTimeout1( test )
{
  let trd;
  let counter = 0;
  let visits = [];

  function testRoutine( t )
  {
    trd = t;
    t.description = 'description1';
    visit( 'v0' );
    return _.time.out( 1000, () =>
    {
      visit( 'v1' );
      t.identical( 0, 1 );
      t.identical( 1, 1 );
      visit( 'v2' );
    })
  }

  testRoutine.timeOut = 100;

  var suite = wTestSuite
  ({
    tests : { testRoutine },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run();

  result
  .finally( function( err, arg )
  {

    var acheck = trd.checkCurrent();
    test.identical( acheck.checkIndex, 2 );
    test.identical( suite.report.testCheckPasses, 0 );
    test.identical( suite.report.testCheckFails, 1 );

    test.is( err === undefined );
    test.is( arg === suite );
    test.identical( result.tag, suite.name );

    test.identical( visits, [ 'v0' ] );

    visit( 'v3' );

    if( err )
    throw err;
    return null;
  });

  return _.time.out( 2000, () =>
  {
    test.identical( visits, [ 'v0', 'v3', 'v1' ] );
  });

  function visit( what )
  {
    visits.push( what );
    logger.log( what );
  }

}

asyncTimeout1.timeOut = 15000;
asyncTimeout1.description =
`
- test failed because of time out
- console barring works properly
must be only test routine in the test suite!
`

// --
// declare
// --

var Self =
{

  name : 'Tools.Tester.AsyncTimeout',
  silencing : 1, /* silencing must be on */
  routineTimeOut : 30000,

  context :
  {
  },

  tests :
  {

    asyncTimeout1,

  },

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
