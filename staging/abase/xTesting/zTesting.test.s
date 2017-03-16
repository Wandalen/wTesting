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

  if( typeof wTools === 'undefined' || !wTools.Testing._isFullImplementation )
  require( './Testing.debug.s' );

  var _ = wTools;

}

var _ = wTools;
var notTakingIntoAccount = { logger : wLogger({ output : null }), concurrent : 1, takingIntoAccount : 0 };

//

function CaseCounter()
{
  var self = this;

  self.testRoutine = null;
  self.prevCaseIndex = 1;
  self.prevCasePasses = 0;
  self.prevCaseFails = 0;
  self.acase = null;

  self.next = function next()
  {
    self.acase = self.testRoutine.caseCurrent();
    self.prevCaseIndex = self.acase._caseIndex;
    self.prevCasePasses = self.testRoutine.report.testCasePasses;
    self.prevCaseFails = self.testRoutine.report.testCaseFails;
  }

  Object.preventExtensions( self );

  return self;
}

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

    counter.testRoutine = t;

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

    counter.acase = counter.testRoutine.caseCurrent();
    test.identical( counter.acase._caseIndex, 5 );
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

  var counter = new CaseCounter();

  function r1( t )
  {

    counter.testRoutine = t;

    t.description = 'a';

    t.identical( 0,0 );
    test.description = 'does not throw error';
    t.mustNotThrowError( function ()
    {
    });

    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 2 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 0 );
    counter.next();

    /* */

    t.identical( 0,0 );

    test.description = 'throw unexpected error, synchronously';
    t.mustNotThrowError( function ()
    {
      throw _.err( 'test' );
    });

    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 1 );
    counter.next();

    /* */

    t.identical( 0,0 );

    test.description = 'throw unexpected error, asynchronously';
    t.mustNotThrowError( function ()
    {
      return _.timeOut( 250,function()
      {
        throw _.err( 'test' );
      });
    });

    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 0 );
    counter.next();

    /* */

    t.identical( 0,0 );

    test.description = 'single message, no error';
    t.mustNotThrowError( function ()
    {
      return _.timeOut( 250 );
    });

    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 0 );
    counter.next();

    /* */

    t.identical( 0,0 );

    test.description = 'not expected second message';
    t.mustNotThrowError( function ()
    {
      var con = wConsequence().give();

      _.timeOut( 250, function()
      {
        con.give();
        con.give();
      });

      return con;
    });

    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 0 );
    counter.next();

    t.identical( 0,0 );

  }

  var t = wTestSuite({ tests : { r1 : r1 }, override : notTakingIntoAccount });
  var result = t.run()
  .doThen( function( err,data )
  {

    counter.acase = counter.testRoutine.caseCurrent();

    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex, 13 );
    test.identical( t.report.testCasePasses, 10 );
    test.identical( t.report.testCaseFails, 3 );
    test.identical( counter.acase._caseIndex,t.report.testCasePasses+t.report.testCaseFails );

    if( err )
    throw err;
  });

  return result;
}

//

function shouldThrowErrorSync( test )
{

  var counter = new CaseCounter();

  function r1( t )
  {

    counter.testRoutine = t;
    t.description = 'a';

    t.identical( 0,0 );
    test.description = 'simplest, does not throw error, but expected';
    t.shouldThrowErrorSync( function ()
    {
    });

    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 1 );
    counter.next();

    /* */

    t.identical( 0,0 );

    test.description = 'expected synchronous error';
    debugger;
    t.shouldThrowErrorSync( function ()
    {
      throw _.err( 'test' );
    });

    debugger;
    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 2 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 0 );
    counter.next();

    /* */

    t.identical( 0,0 );

    test.description = 'throw unexpected asynchronous error';
    t.shouldThrowErrorSync( function ()
    {
      return _.timeOut( 250,function()
      {
        throw _.err( 'test' );
      });
    });

    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 1 );
    counter.next();

    /* */

    t.identical( 0,0 );

    test.description = 'single message, while synchronous error expected';
    debugger;
    t.shouldThrowErrorSync( function ()
    {
      return _.timeOut( 250 );
    });

    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 1 );
    counter.next();

    /* */

    t.identical( 0,0 );

    test.description = 'not expected second message'; debugger;
    t.shouldThrowErrorSync( function ()
    {
      var con = wConsequence().give();

      _.timeOut( 250, function()
      {
        con.give();
        con.give();
      });

      return con;
    });

    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 1 );
    counter.next();

    /* */

    t.identical( 0,0 );

  }

  var t = wTestSuite({ tests : { r1 : r1 }, override : notTakingIntoAccount });

  var result = t.run()
  .doThen( function( err,data )
  {

    counter.acase = counter.testRoutine.caseCurrent();

    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex, 13 );
    test.identical( t.report.testCasePasses, 8 );
    test.identical( t.report.testCaseFails, 4 );

    if( err )
    throw err;
  });

  return result;
}

//

function shouldThrowErrorAsync( test )
{

  var counter = new CaseCounter();

  function r1( t )
  {

    counter.testRoutine = t;
    t.description = 'a';

    t.identical( 0,0 );
    test.description = 'simplest, does not throw error, but expected';
    t.shouldThrowErrorAsync( function ()
    {
    });

    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 1 );
    counter.next();

    /* */

    t.identical( 0,0 );

    test.description = 'throw unexpected synchronous error';
    debugger;
    t.shouldThrowErrorAsync( function ()
    {
      throw _.err( 'test' );
    });

    debugger;
    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 1 );
    counter.next();

    /* */

    t.identical( 0,0 );

    test.description = 'throw expected asynchronous error';
    t.shouldThrowErrorAsync( function ()
    {
      return _.timeOut( 250,function()
      {
        throw _.err( 'test' );
      });
    });

    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 0 );
    counter.next();

    /* */

    t.identical( 0,0 );

    test.description = 'single message while asynchronous error expected';
    debugger;
    t.shouldThrowErrorAsync( function ()
    {
      return _.timeOut( 250 );
    });

    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 0 );
    counter.next();

    /* */

    t.identical( 0,0 );

    test.description = 'not expected second message'; debugger;
    t.shouldThrowErrorAsync( function ()
    {
      var con = wConsequence().give();

      _.timeOut( 250, function()
      {
        con.give();
        con.give();
      });

      return con;
    });

    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 1 );
    counter.next();

    /* */

    t.identical( 0,0 );

  }

  var t = wTestSuite({ tests : { r1 : r1 }, override : notTakingIntoAccount });

  var result = t.run()
  .doThen( function( err,data )
  {

    counter.acase = counter.testRoutine.caseCurrent();

    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex, 13 );
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

  var counter = new CaseCounter();

  function r1( t )
  {

    counter.testRoutine = t;
    t.description = 'a';

    t.identical( 0,0 );
    test.description = 'simplest, does not throw error, but expected';
    t.shouldThrowError( function ()
    {
    });

    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 1 );
    counter.next();

    /* */

    t.identical( 0,0 );

    test.description = 'throw expected synchronous error';
    debugger;
    t.shouldThrowError( function ()
    {
      throw _.err( 'test' );
    });

    debugger;
    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 2 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 0 );
    counter.next();

    /* */

    t.identical( 0,0 );

    test.description = 'throw expected asynchronous error';
    t.shouldThrowError( function ()
    {
      return _.timeOut( 250,function()
      {
        throw _.err( 'test' );
      });
    });

    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 0 );
    counter.next();

    /* */

    t.identical( 0,0 );

    test.description = 'single message, but error expected';
    debugger;
    t.shouldThrowError( function ()
    {
      return _.timeOut( 250 );
    });

    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 0 );
    counter.next();

    /* */

    t.identical( 0,0 );

    test.description = 'not expected second message'; debugger;
    t.shouldThrowError( function ()
    {
      var con = wConsequence().give();

      _.timeOut( 250, function()
      {
        con.give();
        con.give();
      });

      return con;
    });

    counter.acase = t.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex-counter.prevCaseIndex, 2 );
    test.identical( t.report.testCasePasses-counter.prevCasePasses, 1 );
    test.identical( t.report.testCaseFails-counter.prevCaseFails, 1 );
    counter.next();

    /* */

    t.identical( 0,0 );

  }

  var t = wTestSuite({ tests : { r1 : r1 }, override : notTakingIntoAccount });

  var result = t.run()
  .doThen( function( err,data )
  {

    counter.acase = counter.testRoutine.caseCurrent();
    test.identical( counter.acase.description, 'a' );
    test.identical( counter.acase._caseIndex, 13 );
    test.identical( t.report.testCasePasses, 9 );
    test.identical( t.report.testCaseFails, 3 );

    if( err )
    throw err;
  });

  return result;
}

//

function _throwingExperiment( test )
{
  var t = test;

  return;

  /* */

  debugger;
  t.mustNotThrowError( function ()
  {
    var con = wConsequence().give();

    _.timeOut( 250, function()
    {
      con.give();
      con.give();
    });

    return con;
  });

  /* */

  debugger;
  t.shouldThrowError( function ()
  {
    var con = wConsequence().give();

    _.timeOut( 2000, function()
    {
      con.give();
      con.give();
    });

    return con;
  });

  /* */

  debugger;
  t.shouldThrowError( function ()
  {
    return _.timeOut( 250 );
  });

  /* */

  t.description = 'a';

  t.identical( 0,0 );
  t.shouldThrowErrorAsync( function ()
  {
  });

  t.identical( 0,0 );

  t.shouldThrowErrorAsync( function ()
  {
    throw _.err( 'test' );
  });

  t.identical( 0,0 );

  t.shouldThrowErrorAsync( function ()
  {
    return _.timeOut( 250,function()
    {
      throw _.err( 'test' );
    });
  });

  t.identical( 0,0 );

  t.shouldThrowErrorAsync( function ()
  {
    return _.timeOut( 250 );
  });

  t.identical( 0,0 );

  t.shouldThrowErrorAsync( function ()
  {
    var con = wConsequence().give();

    _.timeOut( 250, function()
    {
      con.give();
      con.give();
    });

    return con;
  });

  t.identical( 0,0 );

  _.timeOut( 2000, function()
  {

    counter.acase = t.caseCurrent();
    console.log( 'caseIndex',acase._caseIndex, 13 );
    console.log( 'testCasePasses',test.report.testCasePasses, 8 );
    console.log( 'testCaseFails',test.report.testCaseFails, 4 );

  });

  /* */

  test.description = 'simplest, does not throw error,  but expected';
  debugger;
  test.shouldThrowErrorAsync( function ()
  {
  });

  /* */

  test.description = 'single message';
  test.mustNotThrowError( function ()
  {
    return _.timeOut( 250 );
  });

  /* */

  test.shouldThrowErrorSync( function ()
  {
    var con = wConsequence().give();

    _.timeOut( 250, function()
    {
      con.give();
      con.give();
    });

    return con;
  });

  /* */

  debugger;
  test.shouldThrowErrorSync( function ()
  {
    return _.timeOut( 250 );
  });
  debugger;

  /* */

  debugger;
  test.mustNotThrowError( function ()
  {
  });

  test.identical( 0,0 );

  debugger;
  test.mustNotThrowError( function ()
  {
    throw _.err( 'test' );
  });

  test.identical( 0,0 );

  /* */

  test.description = 'if passes dont appears in output/passed test cases/total counter';
  test.mustNotThrowError( function ()
  {
  });

  test.identical( 0,0 );

  test.description = 'if not passes then appears in output/total counter';
  test.mustNotThrowError( function ()
  {
    return _.timeOut( 1000,function()
    {
      throw _.err( 'test' );
    });
    // throw _.err( 'test' );
  });

  test.identical( 0,0 );

  test.description = 'not expected second message';
  test.mustNotThrowError( function ()
  {
    var con = wConsequence().give();

    _.timeOut( 1000, function()
    {
      con.give();
      con.give();
    });

    return con;
  });

}

// --
// special
// --

function shouldThrowErrorSimpleSync( test )
{

  var consequence = new wConsequence().give();
  consequence
  .ifNoErrorThen( function()
  {
    return test.shouldThrowErrorSync( function()
    {
      throw _.err( 'shouldThrowErrorSync a' );
    });
  })
  .ifNoErrorThen( function()
  {
    return test.shouldThrowErrorSync( function()
    {
      throw _.err( 'shouldThrowErrorSync b' );
    });
  });

  return consequence;
}

//

function shouldThrowErrorSimpleAsync( test )
{
  var consequence = new wConsequence().give();

  debugger;

  consequence
  .ifNoErrorThen( function()
  {
    test.description = 'a';
    var con = _.timeOut( 50,function( err )
    {
      debugger;
      throw _.err( 'something' );
    });
    debugger;
    return test.shouldThrowErrorAsync( con );
  })
  .ifNoErrorThen( function()
  {
    test.description = 'b';
    var con = _.timeOut( 50,function( err )
    {
      debugger;
      throw _.err( 'something' );
    });
    debugger;
    return test.shouldThrowErrorAsync( con );
  })
  .ifNoErrorThen( function()
  {
    debugger;

    var acase = test.caseCurrent();

    test.identical( acase.description, 'b' );
    test.identical( test.report.testCaseFails, 0 );
    test.identical( test.report.testCasePasses, 7 );
    test.identical( acase._caseIndex, 3 );

  });


  return consequence;
}

//

function shouldThrowErrorChainAsync( test )
{
  var method = 'shouldThrowErrorAsync';
  var throwingAsyncError = 1;

  var method = 'mustNotThrowError';
  var throwingAsyncError = 0;

  var counter = new CaseCounter();

  function row( t )
  {

    counter.testRoutine = t;

    return new wConsequence().give()
    .ifNoErrorThen( function()
    {

      test.description = 'beginning of the test routine';
      counter.acase = counter.testRoutine.caseCurrent();
      test.identical( counter.acase._caseIndex, 1 );
      test.identical( t.report.testCasePasses, 0 );
      test.identical( t.report.testCaseFails, 0 );

      var con = _.timeOut( 50,function( err )
      {
        test.description = 'throw the first error';
        test.shouldBe( 1 );
        if( throwingAsyncError )
        throw _.err( 'something' );
      });

      return t[ method ]( con );
    })
    .ifNoErrorThen( function()
    {

      test.description = 'first ' + method + ' done';
      counter.acase = counter.testRoutine.caseCurrent();
      test.identical( counter.acase._caseIndex, 2 );
      test.identical( t.report.testCasePasses, 1 );
      test.identical( t.report.testCaseFails, 0 );

      var con = _.timeOut( 50,function( err )
      {
        test.description = 'throw the second error';
        test.shouldBe( 1 );
        if( throwingAsyncError )
        throw _.err( 'something' );
      });

      return t[ method ]( con );
    })
    .ifNoErrorThen( function()
    {

      test.description = 'second ' + method + ' done';
      counter.acase = counter.testRoutine.caseCurrent();
      test.identical( counter.acase._caseIndex, 3 );
      test.identical( t.report.testCasePasses, 2 );
      test.identical( t.report.testCaseFails, 0 );

    });

  };

  /* */

  function include( t )
  {

    counter.testRoutine = t;

    function second()
    {
      return _.timeOut( 50,function()
      {

        test.description = 'first ' + method + ' done';
        counter.acase = counter.testRoutine.caseCurrent();
        test.identical( counter.acase._caseIndex, 3 );
        test.identical( t.report.testCasePasses, 4 );
        test.identical( t.report.testCaseFails, 0 );

        t[ method ]( _.timeOutError( 50 ) );

        if( throwingAsyncError )
        throw _.err( 'error' );
      });
    }

    function first()
    {
      return _.timeOut( 50,function()
      {

        test.description = 'beginning of the test routine';
        counter.acase = counter.testRoutine.caseCurrent();
        test.identical( counter.acase._caseIndex, 2 );
        test.identical( t.report.testCasePasses, 3 );
        test.identical( t.report.testCaseFails, 0 );

        t[ method ]( second );

        if( throwingAsyncError )
        throw _.err( 'error' );
      });
    }

    return t[ method ]( first );

  };

  /* */

  var t = wTestSuite({ tests : { row : row, include : include }, override : notTakingIntoAccount });
  if( t.on )
  t.on( 'routineEnd',function( e )
  {

    console.log( 'routineEnd',e.testRoutine.routine.name );

    if( e.testRoutine.routine.name === 'row' )
    {
      counter.acase = counter.testRoutine.caseCurrent();
      test.identical( counter.acase._caseIndex, 4 );
      test.identical( t.report.testCasePasses, 3 );
      test.identical( t.report.testCaseFails, 0 );
    }

  });

  return t.run()
  .doThen( function( err,data )
  {

    counter.acase = counter.testRoutine.caseCurrent();
    test.identical( counter.acase._caseIndex, 5 );
    test.identical( t.report.testCasePasses, 7 );
    test.identical( t.report.testCaseFails, 0 );

    if( err )
    throw err;
  });

}

// --
// etc
// --

function asyncExperiment( test )
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

function failExperiment( test )
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
  // verbosity : 6,
  // verbosityOfDetails : 0,

  tests :
  {

    // simplest : simplest,
    // identical : identical,

    // mustNotThrowError : mustNotThrowError,
    // shouldThrowErrorSync : shouldThrowErrorSync,
    // shouldThrowErrorAsync : shouldThrowErrorAsync,
    // shouldThrowError : shouldThrowError,
    // _throwingExperiment : _throwingExperiment,

    // sepcial

    // shouldThrowErrorSimpleSync : shouldThrowErrorSimpleSync,
    // shouldThrowErrorSimpleAsync : shouldThrowErrorSimpleAsync,
    shouldThrowErrorChainAsync : shouldThrowErrorChainAsync,

    // etc

    // asyncExperiment : asyncExperiment,
    // failExperiment : failExperiment,

  },

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self.name );

})();
