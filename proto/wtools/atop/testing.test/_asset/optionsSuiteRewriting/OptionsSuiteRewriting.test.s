const _ = require( 'wTesting' );

function routine( test )
{
  var testRoutine;

  test.identical( 0, 0 );

  function good( t )
  {
    testRoutine = t;
    t.identical( 0, 0 );
    console.log( 'good' );
  }

  function thr( t )
  {
    testRoutine = t;
    t.identical( 1, 1 );
    return x;
  }

  var suite1 = wTestSuite
  ({
    tests : { good },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var suite2 = wTestSuite
  ({
    tests : { thr },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var suite3 = wTestSuite
  ({
    tests : { good },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = wTester.test([ suite1, suite2, suite3 ])
  .finally( function( err, data )
  {

    var got = _.select( data, '*/report' );
    var expected =
    [
      {
        'outcome' : true,
        'errorsArray' : [],
        'exitCode' : 0,
        'testCheckPasses' : 1,
        'testCheckFails' : 0,
        'testCasePasses' : 0,
        'testCaseFails' : 0,
        // 'testCaseNumber' : 0,
        'testRoutinePasses' : 1,
        'testRoutineFails' : 0
      },
      {
        'outcome' : false,
        'exitCode' : 0,
        'testCheckPasses' : 1,
        'testCheckFails' : 1,
        'testCasePasses' : 0,
        'testCaseFails' : 0,
        // 'testCaseNumber' : 0,
        'testRoutinePasses' : 0,
        'testRoutineFails' : 1
      },
      {
        'outcome' : true,
        'errorsArray' : [],
        'exitCode' : 0,
        'testCheckPasses' : 1,
        'testCheckFails' : 0,
        'testCasePasses' : 0,
        'testCaseFails' : 0,
        // 'testCaseNumber' : 0,
        'testRoutinePasses' : 1,
        'testRoutineFails' : 0
      }
    ]
    test.contains( got, expected );

    if( err )
    throw err;
    return null;
  });

  return result;
}

//


var notTakingIntoAccount = { logger : _.Logger({ output : null }), concurrent : 1, takingIntoAccount : 0 };

var suite1 = wTestSuite
({
  silencing : 1,
  context : { notTakingIntoAccount },
  tests : { routine },
});
