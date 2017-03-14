( function _zTesting_test_s_( ) {

'use strict';

/*

node builder/include/abase/xTesting/zTesting.test.s verbosity:6 importanceOfNegative:2 verbosityOfDetails:0
node builder/include/abase/xTesting/zTesting.test.s verbosity:6 importanceOfNegative:2 verbosityOfDetails:0

node builder/include/abase/z.test/Path.path.test.s verbosity:4 importanceOfNegative:2 verbosityOfDetails:0

node builder/Test builder/include/abase/printer
node builder/Test builder/include/abase/z.test

builder/include/abase/printer/z.test/Chaining.test.s
builder/include/abase/printer/z.test/Backend.test.ss
builder/include/abase/printer/z.test/Logger.test.s
builder/include/abase/printer/z.test/Other.test.s
builder/include/abase/printer/z.test/Browser.test.s
builder/include/abase/xTesting/zTesting.test.s
builder/include/abase/z.test/ArraySorted.test.s
builder/include/abase/z.test/Consequence.test.s
builder/include/abase/z.test/EventHandler.test.s
builder/include/abase/z.test/String.test.s
builder/include/abase/z.test/RegExp.test.s
builder/include/abase/z.test/Map.test.s
builder/include/abase/z.test/Changes.test.s
builder/include/abase/z.test/ExecTools.test.s
builder/include/abase/z.test/Path.path.test.s
builder/include/abase/z.test/Path.url.test.s
builder/include/abase/z.test/ProtoLike.test.s
builder/include/abase/z.test/Sample.test.s

-

node builder/include/abase/z.test/Path.path.test.s
node builder/include/abase/z.test/Path.path.test.s verbosity:4
node builder/include/abase/z.test/Path.path.test.s verbosity:4 importanceOfNegative:3
node builder/include/abase/z.test/Path.path.test.s verbosity:3 importanceOfNegative:3

-

node builder/include/abase/xTesting/zTesting.test.s
node builder/include/abase/xTesting/zTesting.test.s verbosityOfDetails:-8
node builder/include/abase/xTesting/zTesting.test.s verbosityOfDetails:-8 verbosity:4
node builder/include/abase/xTesting/zTesting.test.s verbosityOfDetails:-8 verbosity:4 importanceOfNegative:3
node builder/include/abase/xTesting/zTesting.test.s verbosityOfDetails:-8 verbosity:3 importanceOfNegative:3

node builder/Test builder/include/abase/xTesting/zTesting.test.s
node builder/Test builder/include/abase/z.test/Path.path.test.s
node builder/Test builder/include/abase/z.test
node builder/Test builder/include/abase/z.test verbosity:2

echo $?

*/

if( typeof module !== 'undefined' )
{

  if( typeof wTesting === 'undefined' )
  try
  {
    require( './Testing.debug.s' );
  }
  catch( err )
  {
    require( 'wTesting' );
  }

  var _ = wTools;

}

var _ = wTools;
var notTakingIntoAccount = { logger : wLogger({ output : null }), concurrent : 1, takingIntoAccount : 0 };

//

function simplest( test )
{

  test.identical( 0,0 );

  test.identical( test.report.testCasePasses, 1 );
  test.identical( test.report.testCaseFails, 0 );

}

//

function identical( test )
{
  var testRoutine;

  test.identical( 0,0 );

  function r1( t )
  {

    testRoutine = t;

    t.identical( 0,0 );
    test.identical( t.report.testCasePasses, 1 );
    test.identical( t.report.testCaseFails, 0 );

    t.identical( 0,false );
    test.identical( t.report.testCasePasses, 1 );
    test.identical( t.report.testCaseFails, 1 );

    t.identical( 0,1 );
    test.identical( t.report.testCasePasses, 1 );
    test.identical( t.report.testCaseFails, 2 );

  }

  var t = wTestSuite({ tests : { r1 : r1 }, override : notTakingIntoAccount });

  var result = t.run()
  .doThen( function( err,data )
  {

    var acase = testRoutine.caseCurrent();

    test.identical( acase._caseIndex, 5 );
    test.identical( t.report.testCasePasses, 2 );
    test.identical( t.report.testCaseFails, 2 );

    if( err )
    throw err;
  });

  return result;
}

//

function mustNotThrowError( test )
{


  var testRoutine;
  var prevCaseIndex = 1;
  var prevCasePasses = 0;
  var prevCaseFails = 0;

  function next()
  {
    var acase = testRoutine.caseCurrent();
    prevCaseIndex = acase._caseIndex;
    prevCasePasses = testRoutine.report.testCasePasses;
    prevCaseFails = testRoutine.report.testCaseFails;
  }

  function r1( t )
  {

    testRoutine = t;
    t.description = 'a';

    t.identical( 0,0 );
    test.description = 'does not throw error';
    t.mustNotThrowError( function ()
    {
    });

    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 2 );
    test.identical( t.report.testCaseFails-prevCaseFails, 0 );
    next();

    /* */

    t.identical( 0,0 );

    test.description = 'throw unexpected error, synchronously';
    t.mustNotThrowError( function ()
    {
      throw _.err( 'test' );
    });

    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-prevCaseFails, 1 );
    next();

    /* */

    t.identical( 0,0 );

    test.description = 'throw unexpected error, asynchronously';
    t.mustNotThrowError( function ()
    {
      return _.timeOut( 500,function()
      {
        throw _.err( 'test' );
      });
    });

    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-prevCaseFails, 0 );
    next();

    /* */

    t.identical( 0,0 );

    test.description = 'single message';
    t.mustNotThrowError( function ()
    {
      return _.timeOut( 500 );
    });

    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-prevCaseFails, 0 );
    next();

    /* */

    t.identical( 0,0 );

    test.description = 'not expected second message';
    t.mustNotThrowError( function ()
    {
      var con = wConsequence().give();

      _.timeOut( 500, function()
      {
        con.give();
        con.give();
      });

      return con;
    });

    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-prevCaseFails, 0 );
    next();

    /* */

    t.identical( 0,0 );

  }

  var t = wTestSuite({ tests : { r1 : r1 }, override : notTakingIntoAccount });

  var result = t.run()
  .doThen( function( err,data )
  {

    debugger;
    var acase = testRoutine.caseCurrent();

    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex, 13 );
    test.identical( t.report.testCasePasses, 10 );
    test.identical( t.report.testCaseFails, 3 );
    test.identical( acase._caseIndex,t.report.testCasePasses+t.report.testCaseFails );

    // test.identical( t.report.testCasePasses, 2 );
    // test.identical( t.report.testCaseFails, 1 );

    if( err )
    throw err;
  });

  return result;
}

//

function shouldThrowErrorSync( test )
{

  var testRoutine;
  var prevCaseIndex = 1;
  var prevCasePasses = 0;
  var prevCaseFails = 0;

  function next()
  {
    var acase = testRoutine.caseCurrent();
    prevCaseIndex = acase._caseIndex;
    prevCasePasses = testRoutine.report.testCasePasses;
    prevCaseFails = testRoutine.report.testCaseFails;
  }

  function r1( t )
  {

    testRoutine = t;
    t.description = 'a';

    t.identical( 0,0 );
    test.description = 'simplest, does not throw error, but expected';
    t.shouldThrowErrorSync( function ()
    {
    });

    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-prevCaseFails, 1 );
    next();

    /* */

    t.identical( 0,0 );

    test.description = 'throw expects synchronous error';
    debugger;
    t.shouldThrowErrorSync( function ()
    {
      throw _.err( 'test' );
    });

    debugger;
    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 2 );
    test.identical( t.report.testCaseFails-prevCaseFails, 0 );
    next();

    /* */

    t.identical( 0,0 );

    test.description = 'throw unexpected error, but asynchronously';
    t.shouldThrowErrorSync( function ()
    {
      return _.timeOut( 500,function()
      {
        throw _.err( 'test' );
      });
    });

    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-prevCaseFails, 1 );
    next();

    /* */

    t.identical( 0,0 );

    test.description = 'single message, while synchronous error expected';
    debugger;
    t.shouldThrowErrorSync( function ()
    {
      return _.timeOut( 500 );
    });

    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-prevCaseFails, 1 );
    next();

    /* */

    t.identical( 0,0 );

    test.description = 'not expected second message'; debugger;
    t.shouldThrowErrorSync( function ()
    {
      var con = wConsequence().give();

      _.timeOut( 500, function()
      {
        con.give();
        con.give();
      });

      return con;
    });

    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-prevCaseFails, 1 );
    next();

    /* */

    t.identical( 0,0 );

  }

  var t = wTestSuite({ tests : { r1 : r1 }, override : notTakingIntoAccount });

  var result = t.run()
  .doThen( function( err,data )
  {

    debugger;
    var acase = testRoutine.caseCurrent();

    // test.identical( t.report.testCasePasses, 3 );
    // test.identical( t.report.testCaseFails, 1 );

    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex, 13 );
    test.identical( t.report.testCasePasses, 8 );
    test.identical( t.report.testCaseFails, 4 );
    // test.identical( acase._caseIndex,t.report.testCasePasses+t.report.testCaseFails );

    if( err )
    throw err;
  });

  return result;
}

//

function shouldThrowErrorAsync( test )
{

  var testRoutine;
  var prevCaseIndex = 1;
  var prevCasePasses = 0;
  var prevCaseFails = 0;

  function next()
  {
    var acase = testRoutine.caseCurrent();
    prevCaseIndex = acase._caseIndex;
    prevCasePasses = testRoutine.report.testCasePasses;
    prevCaseFails = testRoutine.report.testCaseFails;
  }

  function r1( t )
  {

    testRoutine = t;
    t.description = 'a';

    t.identical( 0,0 );
    test.description = 'simplest, does not throw error, but expected';
    t.shouldThrowErrorAsync( function ()
    {
    });

    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-prevCaseFails, 1 );
    next();

    /* */

    t.identical( 0,0 );

    test.description = 'throw unexpected synchronous error';
    debugger;
    t.shouldThrowErrorAsync( function ()
    {
      throw _.err( 'test' );
    });

    debugger;
    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-prevCaseFails, 1 );
    next();

    /* */

    t.identical( 0,0 );

    test.description = 'throw expected asynchronous error';
    t.shouldThrowErrorAsync( function ()
    {
      return _.timeOut( 500,function()
      {
        throw _.err( 'test' );
      });
    });

    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-prevCaseFails, 0 );
    next();

    /* */

    t.identical( 0,0 );

    test.description = 'single message while asynchronous error expected';
    debugger;
    t.shouldThrowErrorAsync( function ()
    {
      return _.timeOut( 500 );
    });

    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-prevCaseFails, 0 );
    next();

    /* */

    t.identical( 0,0 );

    test.description = 'not expected second message'; debugger;
    t.shouldThrowErrorAsync( function ()
    {
      var con = wConsequence().give();

      _.timeOut( 500, function()
      {
        con.give();
        con.give();
      });

      return con;
    });

    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-prevCaseFails, 1 );
    next();

    /* */

    t.identical( 0,0 );

  }

  var t = wTestSuite({ tests : { r1 : r1 }, override : notTakingIntoAccount });

  var result = t.run()
  .doThen( function( err,data )
  {

    debugger;
    var acase = testRoutine.caseCurrent();

    // test.identical( t.report.testCasePasses, 3 );
    // test.identical( t.report.testCaseFails, 1 );

    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex, 13 );
    test.identical( t.report.testCasePasses, 8 );
    test.identical( t.report.testCaseFails, 4 );

    if( err )
    throw err;
  });

  return result;
}

//

function shouldThrowError( test )
{

  var testRoutine;
  var prevCaseIndex = 1;
  var prevCasePasses = 0;
  var prevCaseFails = 0;

  function next()
  {
    var acase = testRoutine.caseCurrent();
    prevCaseIndex = acase._caseIndex;
    prevCasePasses = testRoutine.report.testCasePasses;
    prevCaseFails = testRoutine.report.testCaseFails;
  }

  function r1( t )
  {

    testRoutine = t;
    t.description = 'a';

    t.identical( 0,0 );
    test.description = 'simplest, does not throw error,  but expected';
    t.shouldThrowError( function ()
    {
    });

    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-prevCaseFails, 1 );
    next();

    /* */

    t.identical( 0,0 );

    test.description = 'throw unexpected synchronous error';
    debugger;
    t.shouldThrowError( function ()
    {
      throw _.err( 'test' );
    });

    debugger;
    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 2 );
    test.identical( t.report.testCaseFails-prevCaseFails, 0 );
    next();

    /* */

    t.identical( 0,0 );

    test.description = 'throw expected asynchronous error';
    t.shouldThrowError( function ()
    {
      return _.timeOut( 500,function()
      {
        throw _.err( 'test' );
      });
    });

    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-prevCaseFails, 0 );
    next();

    /* */

    t.identical( 0,0 );

    test.description = 'single message, error expected';
    debugger;
    t.shouldThrowError( function ()
    {
      return _.timeOut( 500 );
    });

    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-prevCaseFails, 0 );
    next();

    /* */

    t.identical( 0,0 );

    test.description = 'not expected second message'; debugger;
    t.shouldThrowError( function ()
    {
      var con = wConsequence().give();

      _.timeOut( 500, function()
      {
        con.give();
        con.give();
      });

      return con;
    });

    var acase = t.caseCurrent();
    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex-prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-prevCaseFails, 1 );
    next();

    /* */

    t.identical( 0,0 );

  }

  var t = wTestSuite({ tests : { r1 : r1 }, override : notTakingIntoAccount });

  var result = t.run()
  .doThen( function( err,data )
  {

    debugger;
    var acase = testRoutine.caseCurrent();

    // test.identical( t.report.testCasePasses, 2 );
    // test.identical( t.report.testCaseFails, 1 );

    test.identical( acase.description, 'a' );
    test.identical( acase._caseIndex, 13 );
    test.identical( t.report.testCasePasses, 9 );
    test.identical( t.report.testCaseFails, 3 );

    if( err )
    throw err;
  });

  return result;
}

//

function throwingExperiment( test )
{
  var t = test;

  /* */

  debugger;
  t.mustNotThrowError( function ()
  {
    var con = wConsequence().give();

    _.timeOut( 500, function()
    {
      con.give();
      con.give();
    });

    return con;
  });

  /* */

  // debugger;
  // t.shouldThrowError( function ()
  // {
  //   var con = wConsequence().give();
  //
  //   _.timeOut( 2000, function()
  //   {
  //     con.give();
  //     con.give();
  //   });
  //
  //   return con;
  // });

  /* */

  // debugger;
  // t.shouldThrowError( function ()
  // {
  //   return _.timeOut( 500 );
  // });

  /* */

  // t.description = 'a';
  //
  // t.identical( 0,0 );
  // t.shouldThrowErrorAsync( function ()
  // {
  // });
  //
  // t.identical( 0,0 );
  //
  // t.shouldThrowErrorAsync( function ()
  // {
  //   throw _.err( 'test' );
  // });
  //
  // t.identical( 0,0 );
  //
  // t.shouldThrowErrorAsync( function ()
  // {
  //   return _.timeOut( 500,function()
  //   {
  //     throw _.err( 'test' );
  //   });
  // });
  //
  // t.identical( 0,0 );
  //
  // t.shouldThrowErrorAsync( function ()
  // {
  //   return _.timeOut( 500 );
  // });
  //
  // t.identical( 0,0 );
  //
  // t.shouldThrowErrorAsync( function ()
  // {
  //   var con = wConsequence().give();
  //
  //   _.timeOut( 500, function()
  //   {
  //     con.give();
  //     con.give();
  //   });
  //
  //   return con;
  // });
  //
  // t.identical( 0,0 );
  //
  // _.timeOut( 2000, function()
  // {
  //
  //   var acase = test.caseCurrent();
  //   console.log( 'caseIndex',acase._caseIndex, 13 );
  //   console.log( 'testCasePasses',test.report.testCasePasses, 8 );
  //   console.log( 'testCaseFails',test.report.testCaseFails, 4 );
  //
  // });

  /* */

  // test.description = 'simplest, does not throw error,  but expected';
  // debugger;
  // test.shouldThrowErrorAsync( function ()
  // {
  // });

  /* */

  // test.description = 'single message';
  // test.mustNotThrowError( function ()
  // {
  //   return _.timeOut( 500 );
  // });

  /* */

  // test.shouldThrowErrorSync( function ()
  // {
  //   var con = wConsequence().give();
  //
  //   _.timeOut( 500, function()
  //   {
  //     con.give();
  //     con.give();
  //   });
  //
  //   return con;
  // });

  /* */

  // debugger;
  // test.shouldThrowErrorSync( function ()
  // {
  //   return _.timeOut( 500 );
  // });
  // debugger;

  /* */

  // debugger;
  // test.mustNotThrowError( function ()
  // {
  // });
  //
  // test.identical( 0,0 );
  //
  // debugger;
  // test.mustNotThrowError( function ()
  // {
  //   throw _.err( 'test' );
  // });
  //
  // test.identical( 0,0 );

  /* */

  // test.description = 'if passes dont appears in output/passed test cases/total counter';
  // test.mustNotThrowError( function ()
  // {
  // });
  //
  // test.identical( 0,0 );
  //
  // test.description = 'if not passes then appears in output/total counter';
  // test.mustNotThrowError( function ()
  // {
  //   return _.timeOut( 1000,function()
  //   {
  //     throw _.err( 'test' );
  //   });
  //   // throw _.err( 'test' );
  // });
  //
  // test.identical( 0,0 );

  // test.description = 'not expected second message';
  // test.mustNotThrowError( function ()
  // {
  //   var con = wConsequence().give();
  //
  //   _.timeOut( 1000, function()
  //   {
  //     con.give();
  //     con.give();
  //   });
  //
  //   return con;
  // });

}

//

function asyncTest( test )
{
  var con = _.timeOutError( 1000 );

  test.identical( 0,0 );

  con.doThen( function()
  {
  });

  debugger;
  return con;
}

//

function thisTestFails( test )
{

  test.description = 'this test fails';

  test.identical( 0,1 );
  test.identical( 0,1 );

}

// --
// proto
// --

var Self =
{

  debug : 1,
  name : 'TestingOfTesting',
  verbosityOfDetails : 0,

  tests :
  {

    simplest : simplest,
    identical : identical,

    mustNotThrowError : mustNotThrowError,
    shouldThrowErrorSync : shouldThrowErrorSync,
    shouldThrowErrorAsync : shouldThrowErrorAsync,
    shouldThrowError : shouldThrowError,

    // throwingExperiment : throwingExperiment,
    // asyncTest : asyncTest,
    thisTestFails : thisTestFails,

  },

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self.name );


})();
