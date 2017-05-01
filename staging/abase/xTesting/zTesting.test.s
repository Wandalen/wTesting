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

    testRoutine = t;

    console.log( 'testRoutine',testRoutine );

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

// --
// should
// --

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
      debugger;
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

mustNotThrowError.timeOut = 30000;

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

function shouldPassMessage( test )
{
  var counter = new CaseCounter();
  // debugger;

  test.description = 'mustNotThrowError must return con with message';

  var con = new wConsequence().give( '123' );
  test.mustNotThrowError( con )
  .ifNoErrorThen( function( arg )
  {
    test.identical( arg, '123' );
  });

  var con = new wConsequence().give( '123' );
  test.shouldMessageOnlyOnce( con )
  .ifNoErrorThen( function( arg )
  {
    test.identical( arg, '123' );
  });

  test.description = 'mustNotThrowError must return con original error';

  var errOriginal = _.err( 'Err' );
  var con = new wConsequence().error( errOriginal );
  test.shouldThrowError( con )
  .doThen( function( err,arg )
  {
    // debugger;
    test.identical( err,errOriginal );
    _.errAttend( err );
  });

  return _.timeOut( 500 );
}

shouldPassMessage.timeOut = 30000;

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

_throwingExperiment.experimental = 1;

// --
// special
// --

function shouldThrowErrorSimpleSync( test )
{

  test.identical( test._inroutineCon.messagesGet().length,1 );

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
  var counter = new CaseCounter();

  counter.testRoutine = test;
  counter.next();

  test.identical( test._inroutineCon.messagesGet().length,1 );

  // debugger;

  consequence
  .doThen( function()
  {
    test.description = 'a';
    var con = _.timeOut( 50,function( err )
    {
      debugger;
      throw _.err( 'async error' );
    });
    debugger;
    return test.shouldThrowErrorAsync( con );
  })
  .doThen( function()
  {
    test.description = 'b';
    var con = _.timeOut( 50,function( err )
    {
      debugger;
      throw _.err( 'async error' );
    });
    debugger;
    return test.shouldThrowErrorAsync( con );
  })
  .doThen( function()
  {
    debugger;

    var acase = test.caseCurrent();

    test.identical( test.report.testCasePasses-counter.prevCasePasses, 3 );
    test.identical( test.report.testCaseFails-counter.prevCaseFails, 0 );

    test.identical( acase.description, 'b' );
    test.identical( acase._caseIndex, 4 );

    test.identical( test._inroutineCon.messagesGet().length,0 );

  })
  ;


  return consequence;
}

//

function _chainedShould( test,o )
{

  var method = o.method;
  var counter = new CaseCounter();

  function row( t )
  {
    var prefix = method + ' . ' + 'in row' + ' . ';

    counter.testRoutine = t;

    return new wConsequence().give()
    .doThen( function()
    {

      test.description = prefix + 'beginning of the test routine';
      counter.acase = counter.testRoutine.caseCurrent();
      test.identical( counter.acase._caseIndex, 1 );
      test.identical( t.report.testCasePasses, 0 );
      test.identical( t.report.testCaseFails, 0 );

      var con = _.timeOut( 50,function( err )
      {
        test.description = prefix + 'give the first message';
        test.shouldBe( 1 );
        if( o.throwingError === 'async' )
        throw _.err( 'async error' );
        else if( o.throwingError === 'sync' )
        t[ method ]( function(){ throw _.err( 'sync error' ) } );
      });

      if( o.throwingError === 'sync' )
      return con;
      else
      return t[ method ]( con );
    })
    .doThen( function()
    {

      test.description = prefix + 'first ' + method + ' done';
      counter.acase = counter.testRoutine.caseCurrent();
      test.identical( counter.acase._caseIndex, 2 );
      test.identical( t.report.testCasePasses, 1 );
      test.identical( t.report.testCaseFails, 0 );

      var con = _.timeOut( 50,function( err )
      {
        test.description = prefix + 'give the second message';
        test.shouldBe( 1 );
        if( o.throwingError === 'async' )
        throw _.err( 'async error' );
        else if( o.throwingError === 'sync' )
        t[ method ]( function(){ throw _.err( 'sync error' ) } );
      });

      if( o.throwingError === 'sync' )
      return con;
      else
      return t[ method ]( con );
    })
    .doThen( function()
    {

      test.description = prefix + 'second ' + method + ' done';
      counter.acase = counter.testRoutine.caseCurrent();
      test.identical( counter.acase._caseIndex, 3 );
      test.identical( t.report.testCasePasses, 2 );
      test.identical( t.report.testCaseFails, 0 );

    });

  };

  /* */

  function include( t )
  {

    var prefix = method + ' . ' + 'include' + ' . ';
    counter.testRoutine = t;

    function second()
    {
      return _.timeOut( 50,function()
      {

        test.description = prefix + 'first ' + method + ' done';

        test.identical( t.report.testCasePasses, o.lowerCount ? 4 : 5 );
        test.identical( t.report.testCaseFails, 0 );

        if( o.throwingError === 'sync' )
        t[ method ]( function(){ throw _.err( 'sync error' ) } );

        counter.acase = counter.testRoutine.caseCurrent();
        test.identical( counter.acase._caseIndex, o.lowerCount ? 3 : 4 );

        if( o.throwingError === 'async' )
        t[ method ]( _.timeOutError( 50 ) );
        else if( !o.throwingError )
        t[ method ]( _.timeOut( 50 ) );

        if( o.throwingError === 'async' )
        throw _.err( 'async error' );
      });
    }

    function first()
    {

      var result = _.timeOut( 50,function()
      {

        test.description = prefix + 'first timeout of the included test routine ';

        test.identical( t.report.testCasePasses, 3 );
        test.identical( t.report.testCaseFails, 0 );

        if( o.throwingError === 'sync' )
        t[ method ]( function(){ throw _.err( 'sync error' ); } );

        counter.acase = counter.testRoutine.caseCurrent();
        test.identical( counter.acase._caseIndex, 2 );

        if( o.throwingError === 'sync' )
        return second();
        else
        t[ method ]( second );

        if( o.throwingError === 'async' )
        throw _.err( 'async error' );
      });

      return result;
    }

    test.description = prefix + 'beginning of the included test routine ';

    if( o.throwingError === 'sync' )
    return first();
    else
    return t[ method ]( first );
  };

  /* */

  var t = wTestSuite
  ({
    tests : { row : row, include : include },
    override : notTakingIntoAccount,
    name : _.diagnosticLocation().name + '.' + method + '.' + o.throwingError,
  });

  if( t.on )
  t.on( 'routineEnd',function( e )
  {

    console.log( 'routineEnd',e.testRoutine.routine.name );

    if( e.testRoutine.routine.name === 'row' )
    {
      test.description = 'checking outcomes';
      counter.acase = counter.testRoutine.caseCurrent();
      test.identical( counter.acase._caseIndex, 4 );
      test.identical( t.report.testCasePasses, 3 );
      test.identical( t.report.testCaseFails, 0 );
    }

  });

  /* */

  return t.run()
  .doThen( function( err,data )
  {

    test.description = 'checking outcomes';
    counter.acase = counter.testRoutine.caseCurrent();
    // test.identical( counter.acase._caseIndex, 5 );
    // test.identical( t.report.testCasePasses, 7 );
    // test.identical( t.report.testCaseFails, 0 );

    if( err )
    throw err;
  });

}

_chainedShould.experimental = 1;

//

function chainedShould( test )
{
  var con = wConsequence().give();

  var iterations =
  [

    {
      method : 'shouldThrowError',
      throwingError : 'sync',
      lowerCount : 1,
    },
    {
      method : 'shouldThrowError',
      throwingError : 'async',
    },

    {
      method : 'shouldThrowErrorSync',
      throwingError : 'sync',
      lowerCount : 1,
    },

    {
      method : 'shouldThrowErrorAsync',
      throwingError : 'async',
    },

    {
      method : 'mustNotThrowError',
      throwingError : 0,
    },

    {
      method : 'shouldMessageOnlyOnce',
      throwingError : 0,
    },

  ]

  for( var i = 0 ; i < iterations.length ; i++ )
  con.ifNoErrorThen( _.routineSeal( this, _chainedShould, [ test,iterations[ i ] ] ) );

  return con;
}

chainedShould.timeOut = 30000;

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

asyncExperiment.experimental = 1;

//

function failExperiment( test )
{

  test.description = 'this test fails';

  test.identical( 0,1 );
  test.identical( 0,1 );

}

failExperiment.experimental = 1;

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

    simplest : simplest,
    identical : identical,

    // should

    mustNotThrowError : mustNotThrowError,
    shouldThrowErrorSync : shouldThrowErrorSync,
    shouldThrowErrorAsync : shouldThrowErrorAsync,
    shouldThrowError : shouldThrowError,
    shouldPassMessage : shouldPassMessage,
    _throwingExperiment : _throwingExperiment,

    shouldThrowErrorSimpleSync : shouldThrowErrorSimpleSync,
    shouldThrowErrorSimpleAsync : shouldThrowErrorSimpleAsync,

    _chainedShould : _chainedShould,
    chainedShould : chainedShould,

    // etc

    asyncExperiment : asyncExperiment,
    failExperiment : failExperiment,

  },

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self.name );

})();
