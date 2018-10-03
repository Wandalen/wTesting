( function _General_test_s_( ) {

'use strict';


/*

node builder/include/dwtools/atop/tester/zTesting.test.s v:4 n:1

echo $?

*/

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || typeof _global_.wBase === 'undefined' )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let _externalTools = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      _externalTools = 1;
      require( 'wTools' );
    }
    if( !_externalTools )
    require( toolsPath );
  }

  if( typeof _realGlobal_ === 'undefined' || !_realGlobal_.wTester || !_realGlobal_.wTester._isReal_ )
  require( '../xtester/aBase.debug.s' );
  var _global = _global_;
  var _ = _global_.wTools;

  _.include( 'wLogger' );
  _.include( 'wConsequence' );

}

var _global = _global_;
var _ = _global_.wTools;
var notTakingIntoAccount = { logger : _.Logger({ output : null }), concurrent : 1, takingIntoAccount : 0, routine : null };

//

function CheckCounter()
{
  var self = this;

  self.testRoutine = null;
  self.prevCheckIndex = 1;
  self.prevCheckPasses = 0;
  self.prevCheckFails = 0;
  self.acheck = null;

  self.next = function next()
  {
    self.acheck = self.testRoutine.checkCurrent();
    self.prevCheckIndex = self.acheck.checkIndex;
    self.prevCheckPasses = self.testRoutine.report.testCheckPasses;
    self.prevCheckFails = self.testRoutine.report.testCheckFails;
  }

  Object.preventExtensions( self );

  return self;
}

//

function simplest( test )
{

  test.identical( 0,0 );

  test.identical( test.suite.report.testCheckPasses, 1 );
  test.identical( test.suite.report.testCheckFails, 0 );

}

//

function identical( test )
{
  var testRoutine;

  test.identical( 0,0 );
  // test.identical( 0,1 );

  function r1( t )
  {

    testRoutine = t;

    // console.log( 'testRoutine',testRoutine );
    console.log( 'x' );

    t.identical( 0,0 );
    test.identical( t.suite.report.testCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails, 0 );

    t.identical( 0,false );
    test.identical( t.suite.report.testCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails, 1 );

    t.identical( 0,1 );
    test.identical( t.suite.report.testCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails, 2 );

  }

  var suite = wTestSuite
  ({
    tests : { r1 : r1 },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run()
  .doThen( function( err,data )
  {

    var acheck = testRoutine.checkCurrent();
    test.identical( acheck.checkIndex, 5 );
    test.identical( suite.report.testCheckPasses, 2 );
    test.identical( suite.report.testCheckFails, 2 );

    if( err )
    throw err;
  });

  test.identical( undefined,undefined );
  test.equivalent( undefined,undefined );

  return result;
}

// --
// should
// --

function shouldMessageOnlyOnce( test )
{

  var counter = new CheckCounter();

  function r1( t )
  {

    counter.testRoutine = t;
    t.will = 'a';

    t.identical( 0,0 );
    test.case = 'does not throw error';
    var c1 = t.shouldMessageOnlyOnce( function()
    {
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c1.resourcesGet().length, 1 );
      c1.got( function( err,arg )
      {
        test.is( err === undefined );
        test.is( arg === undefined );
      });
    });

    /* */

    t.identical( 0,0 );
    test.case = 'does not throw error, string sync message';
    var c2 = t.shouldMessageOnlyOnce( function()
    {
      return 'msg'
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c2.resourcesGet().length, 1 );
      c2.got( function( err,arg )
      {
        test.is( err === undefined );
        test.is( arg === 'msg' );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'throw unexpected error, synchronously';
    var c3 = t.shouldMessageOnlyOnce( function()
    {
      throw _.errAttend( 'error1' );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c3.resourcesGet().length, 1 );
      c3.got( function( err,arg )
      {
        test.is( err === undefined );
        test.is( _.errIs( arg ) );
        test.is( _.strHas( arg.message,'error1' ) );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'throw unexpected error, asynchronously';
    var c4 = t.shouldMessageOnlyOnce( function()
    {
      return _.timeOut( 250,function()
      {
        throw _.errAttend( 'error1' );
      });
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c4.resourcesGet().length, 1 );
      c4.got( function( err,arg )
      {
        test.is( err === undefined );
        test.is( _.errIs( arg ) );
        test.is( _.strHas( arg.message,'error1' ) );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'single async message, no error';
    var c5 = t.shouldMessageOnlyOnce( function()
    {
      return _.timeOut( 250 );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c5.resourcesGet().length, 1 );
      c5.got( function( err,arg )
      {
        test.is( err === undefined );
        test.is( arg === _.timeOut );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'not expected second message';
    var c6 = t.shouldMessageOnlyOnce( function()
    {
      var con = _.Consequence();

      _.timeOut( 250, function()
      {
        con.give( 'msg1' );
        con.give( 'msg2' );
      });

      return con;
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c6.resourcesGet().length, 1 );
      c6.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( _.strHas( err.message,'got more than one message' ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'not expected second error';
    var c7 = t.shouldMessageOnlyOnce( function()
    {
      var con = _.Consequence();

      _.timeOut( 250, function()
      {
        con.error( 'error1' );
        con.error( 'error2' );
      });

      return con;
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c7.resourcesGet().length, 1 );
      c7.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( _.strHas( err.message,'got more than one message' ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'consequence with argument';
    var c8 = t.shouldMessageOnlyOnce( _.Consequence().give( 'arg' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c8.resourcesGet().length, 1 );
      c8.got( function( err,arg )
      {
        test.is( err === undefined );
        test.is( arg === 'arg' );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'consequence with error';
    var c9 = t.shouldMessageOnlyOnce( _.Consequence().error( 'error' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c9.resourcesGet().length, 1 );
      c9.got( function( err,arg )
      {
        test.is( err === undefined );
        test.is( arg === 'error' );
      });
    });

    /* */

    return _.timeOut( 950 );
  }

  /* */

  var suite = wTestSuite
  ({
    tests : { r1 : r1 },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });
  var result = suite.run()
  .doThen( function( err,data )
  {

    counter.acheck = counter.testRoutine.checkCurrent();

    test.identical( counter.acheck.will, '' );
    test.identical( counter.acheck.checkIndex, 20 );
    test.identical( suite.report.testCheckPasses, 17 );
    test.identical( suite.report.testCheckFails, 2 );
    test.identical( counter.acheck.checkIndex,suite.report.testCheckPasses+suite.report.testCheckFails+1 );

    if( err )
    throw err;
  });

  return result;
}

shouldMessageOnlyOnce.timeOut = 30000;

//

function mustNotThrowError( test )
{

  var counter = new CheckCounter();

  function r1( t )
  {

    counter.testRoutine = t;
    t.will = 'a';

    t.identical( 0,0 );
    test.case = 'does not throw error';
    var c1 = t.mustNotThrowError( function()
    {
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c1.resourcesGet().length, 1 );
      c1.got( function( err,arg )
      {
        test.is( err === undefined );
        test.is( arg === undefined );
      });
    });

    /* */

    t.identical( 0,0 );
    test.case = 'does not throw error, string sync message';
    var c2 = t.mustNotThrowError( function()
    {
      return 'msg'
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c2.resourcesGet().length, 1 );
      c2.got( function( err,arg )
      {
        test.is( err === undefined );
        test.is( arg === 'msg' );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'throw unexpected error, synchronously';
    var c3 = t.mustNotThrowError( function()
    {
      throw _.err( 'test' );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c3.resourcesGet().length, 1 );
      c3.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'throw unexpected error, asynchronously';
    var c4 = t.mustNotThrowError( function()
    {
      return _.timeOut( 250,function()
      {
        throw _.err( 'test' );
      });
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c4.resourcesGet().length, 1 );
      c4.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'single async message, no error';
    var c5 = t.mustNotThrowError( function()
    {
      return _.timeOut( 250 );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c5.resourcesGet().length, 1 );
      c5.got( function( err,arg )
      {
        test.is( err === undefined );
        test.is( arg === _.timeOut );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'not expected second message';
    var c6 = t.mustNotThrowError( function()
    {
      var con = _.Consequence();

      _.timeOut( 250, function()
      {
        con.give( 'msg1' );
        con.give( 'msg2' );
      });

      return con;
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c6.resourcesGet().length, 1 );
      c6.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( _.strHas( err.message,'got more than one message' ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'not expected second error';
    var c7 = t.mustNotThrowError( function()
    {
      var con = _.Consequence();

      _.timeOut( 250, function()
      {
        con.error( 'error1' );
        con.error( 'error2' );
      });

      return con;
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c7.resourcesGet().length, 1 );
      c7.got( function( err,arg )
      {
        test.is( err === 'error1' );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'consequence with argument';
    var c8 = t.mustNotThrowError( _.Consequence().give( 'arg' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c8.resourcesGet().length, 1 );
      c8.got( function( err,arg )
      {
        test.is( err === undefined );
        test.is( arg === 'arg' );
      });
    });

    /* */

    test.identical( counter.prevCheckIndex, 17 );
    test.identical( counter.prevCheckPasses, 10 );
    test.identical( counter.prevCheckFails, 1 );

    t.identical( 0,0 );

    test.case = 'consequence with error';
    debugger;
    var c9 = t.mustNotThrowError( _.Consequence({ tag : 'strange' }).error( 'error' ) );
    debugger;

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );

    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c9.resourcesGet().length, 1 );
      c9.got( function( err,arg )
      {
        test.is( err === 'error' );
        test.is( !arg );
      });
    });

    /* */

    return _.timeOut( 950 );
  }

  /* */

  var suite = wTestSuite
  ({
    tests : { r1 : r1 },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });
  var result = suite.run()
  .doThen( function( err,data )
  {

    counter.acheck = counter.testRoutine.checkCurrent();

    test.identical( counter.acheck.will, '' );
    test.identical( counter.acheck.checkIndex, 20 );
    test.identical( suite.report.testCheckPasses, 14 );
    test.identical( suite.report.testCheckFails, 5 );
    test.identical( counter.acheck.checkIndex,suite.report.testCheckPasses+suite.report.testCheckFails+1 );

    if( err )
    throw err;
  });

  return result;
}

mustNotThrowError.timeOut = 30000;

//

function shouldThrowErrorSync( test )
{

  var counter = new CheckCounter();

  function r1( t )
  {

    counter.testRoutine = t;
    t.will = 'a';

    t.identical( 0,0 );
    test.case = 'simplest, does not throw error, but expected';
    var c1 = t.shouldThrowErrorSync( function()
    {
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c1.resourcesGet().length, 1 );
      c1.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'expected synchronous error';
    var c2 = t.shouldThrowErrorSync( function()
    {
      throw _.err( 'test' );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c2.resourcesGet().length, 1 );
      c2.got( function( err,arg )
      {
        test.is( err === null );
        test.is( _.errIs( arg ) );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'throw unexpected asynchronous error';
    var c3 = t.shouldThrowErrorSync( function()
    {
      return _.timeOut( 250,function()
      {
        throw _.err( 'test' );
      });
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c3.resourcesGet().length, 1 );
      c3.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'single message, while synchronous error expected';
    var c4 = t.shouldThrowErrorSync( function()
    {
      return _.timeOut( 250 );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c4.resourcesGet().length, 1 );
      c4.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'not expected second message';
    var c5 = t.shouldThrowErrorSync( function()
    {
      var con = _.Consequence();

      _.timeOut( 250, function()
      {
        con.give();
        con.give();
      });

      return con;
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c5.resourcesGet().length, 1 );
      c5.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'not expected second error';
    var c6 = t.shouldThrowErrorSync( function()
    {
      var con = _.Consequence().error( 'error' );

      _.timeOut( 250, function()
      {
        con.error( 'error' );
      });

      return con;
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c6.resourcesGet().length, 1 );
      c6.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'consequence with argument';
    var c7 = t.shouldThrowErrorSync( _.Consequence().give( 'arg' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c7.resourcesGet().length, 1 );
      c7.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'consequence with error';
    var c8 = t.shouldThrowErrorSync( _.Consequence().error( 'error' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c8.resourcesGet().length, 1 );
      c8.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( !arg );
      });
    });

    /* */

    return _.timeOut( 950 );
  }

  var suite = wTestSuite
  ({
    tests : { r1 : r1 },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run()
  .doThen( function( err,data )
  {

    counter.acheck = counter.testRoutine.checkCurrent();

    test.identical( counter.acheck.will, '' );
    test.identical( counter.acheck.checkIndex, 18 );
    test.identical( suite.report.testCheckPasses, 10 );
    test.identical( suite.report.testCheckFails, 7 );
    test.identical( counter.acheck.checkIndex,suite.report.testCheckPasses+suite.report.testCheckFails+1 );

    if( err )
    throw err;
  });

  return result;
}

//

function shouldThrowErrorAsync( test )
{

  var counter = new CheckCounter();

  test.is( test.logger.outputs.length > 0 );

  function r1( t )
  {

    counter.testRoutine = t;
    t.will = 'a';

    t.identical( 0,0 );
    test.case = 'simplest, does not throw error, but expected';
    var c1 = t.shouldThrowErrorAsync( function()
    {
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c1.resourcesGet().length,1 );
      c1.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'throw unexpected synchronous error';
    var c2 = t.shouldThrowErrorAsync( function()
    {
      throw _.err( 'test' );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c2.resourcesGet().length, 1 );
      c2.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'throw expected asynchronous error';
    var c3 = t.shouldThrowErrorAsync( function()
    {
      return _.timeOut( 250,function()
      {
        throw _.err( 'test' );
      });
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c3.resourcesGet().length, 1 );
      c3.got( function( err,arg )
      {
        test.is( err === undefined );
        test.is( _.errIs( arg ) );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'single message while asynchronous error expected';
    var c4 = t.shouldThrowErrorAsync( function()
    {
      return _.timeOut( 250 );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 ); /* delayed */
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c4.resourcesGet().length, 1 );
      c4.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'expected async string error';
    var c5 = t.shouldThrowErrorAsync( function()
    {
      var con = _.Consequence();

      _.timeOut( 250, function()
      {
        con.error( 'error' );
      });

      return con;
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c5.resourcesGet().length, 1 );
      c5.got( function( err,arg )
      {
        test.is( err === undefined );
        test.is( arg === 'error' );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'not expected second message';
    var c6 = t.shouldThrowErrorAsync( function()
    {
      var con = _.Consequence();

      _.timeOut( 250, function()
      {
        con.give();
        con.give();
      });

      return con;
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 ); /* delayed */
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c6.resourcesGet().length, 1 );
      c6.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'not expected second error';
    var c7 = t.shouldThrowErrorAsync( function()
    {
      var con = _.Consequence();

      _.timeOut( 250, function()
      {
        con.error( 'error' );
        con.error( 'error' );
      });

      return con;
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 ); /* delayed */
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c7.resourcesGet().length, 1 );
      c7.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( _.strHas( err.message,'got more than one message' ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'consequence with argument';
    var c8 = t.shouldThrowErrorAsync( _.Consequence().give( 'arg' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c8.resourcesGet().length, 1 );
      c8.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'consequence with error';
    var c9 = t.shouldThrowErrorAsync( _.Consequence().error( 'error' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c9.resourcesGet().length, 1 );
      c9.got( function( err,arg )
      {
        test.is( err === undefined );
        test.is( arg === 'error' );
      });
    });

    /* */

    return _.timeOut( 950 );
  }

  /* */

  var suite = wTestSuite
  ({
    tests : { r1 : r1 },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });
  var result = suite.run()
  .doThen( function( err,data )
  {

    counter.acheck = counter.testRoutine.checkCurrent();

    test.is( test.logger.outputs.length > 0 );
    test.identical( counter.acheck.will, '' );
    test.identical( counter.acheck.checkIndex, 20 );
    test.identical( suite.report.testCheckPasses, 13 );
    test.identical( suite.report.testCheckFails, 6 );
    test.identical( counter.acheck.checkIndex,suite.report.testCheckPasses+suite.report.testCheckFails+1 );

    if( err )
    throw err;

  });

  return result;
}

//

function shouldThrowError( test )
{

  var counter = new CheckCounter();

  function r1( t )
  {

    counter.testRoutine = t;
    t.will = 'a';

    t.identical( 0,0 );
    test.case = 'does not throw error, but expected';
    var c1 = t.shouldThrowError( function()
    {
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c1.resourcesGet().length, 1 );
      c1.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'throw expected synchronous error';
    var c2 = t.shouldThrowError( function()
    {
      throw _.err( 'err1' );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c2.resourcesGet().length, 1 );
      c2.got( function( err,arg )
      {
        test.is( err === undefined );
        test.is( _.errIs( arg ) );
        test.is( _.strHas( arg.messge,'err1' ) );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'throw expected asynchronous error';
    var c3 = t.shouldThrowError( function()
    {
      return _.timeOut( 250,function()
      {
        throw _.err( 'err1' );
      });
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c3.resourcesGet().length, 1 );
      c3.got( function( err,arg )
      {
        test.is( err === undefined );
        test.is( _.errIs( arg ) );
        test.is( _.strHas( arg.messge,'err1' ) );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'single message, but error expected';
    var c4 = t.shouldThrowError( function()
    {
      return _.timeOut( 250 );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c4.resourcesGet().length, 1 );
      c4.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'not expected second message';
    var c5 = t.shouldThrowError( function()
    {
      var con = _.Consequence();

      _.timeOut( 250, function()
      {
        con.give( 'arg1' );
        con.give( 'arg2' );
      });

      return con;
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 ); /* delayed */
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c5.resourcesGet().length, 1 );
      c5.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'not expected second error';
    var c6 = t.shouldThrowError( function()
    {
      var con = _.Consequence();

      _.timeOut( 250, function()
      {
        con.error( 'error1' );
        con.error( 'error1' );
      });

      return con;
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 ); /* delayed */
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c6.resourcesGet().length, 1 );
      c6.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( _.strHas( err.message,'got more than one message' ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'consequence with argument';
    var c8 = t.shouldThrowError( _.Consequence().give( 'arg' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c8.resourcesGet().length, 1 );
      c8.got( function( err,arg )
      {
        test.is( _.errIs( err ) );
        test.is( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.case = 'consequence with error';
    var c9 = t.shouldThrowError( _.Consequence().error( 'error' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.will, 'a' );
    test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c9.resourcesGet().length, 1 );
      c9.got( function( err,arg )
      {
        test.is( err === undefined );
        test.is( arg === 'error' );
      });
    });

    /* */

    return _.timeOut( 950 );
  }

  var suite = wTestSuite
  ({
    tests : { r1 : r1 },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run()
  .doThen( function( err,data )
  {

    counter.acheck = counter.testRoutine.checkCurrent();
    test.identical( counter.acheck.will, '' );
    test.identical( counter.acheck.checkIndex, 18 );
    test.identical( suite.report.testCheckPasses, 12 );
    test.identical( suite.report.testCheckFails, 5 );
    test.identical( counter.acheck.checkIndex,suite.report.testCheckPasses+suite.report.testCheckFails+1 );

    if( err )
    throw err;
  });

  return result;
}

//

function shouldPassMessage( test )
{
  var counter = new CheckCounter();

  test.case = 'mustNotThrowError must return con with message';

  var con = new _.Consequence().give( '123' );
  test.mustNotThrowError( con )
  .ifNoErrorThen( function( arg )
  {
    test.identical( arg, '123' );
  });

  var con = new _.Consequence().give( '123' );
  test.shouldMessageOnlyOnce( con )
  .ifNoErrorThen( function( arg )
  {
    test.identical( arg, '123' );
  });

  test.case = 'mustNotThrowError must return con original error';

  var errOriginal = _.err( 'Err' );
  var con = new _.Consequence().error( errOriginal );
  test.shouldThrowError( con )
  .doThen( function( err,arg )
  {
    test.identical( err, undefined );
    test.identical( arg, errOriginal );
    _.errAttend( err );
  });

  return _.timeOut( 500 );
}

shouldPassMessage.timeOut = 15000;

//

function _throwingExperiment( test )
{
  var t = test;

  return;

  /* */

  t.mustNotThrowError( function()
  {
    var con = _.Consequence().give();

    _.timeOut( 250, function()
    {
      con.give();
      con.give();
    });

    return con;
  });

  /* */

  t.shouldThrowError( function()
  {
    var con = _.Consequence().give();

    _.timeOut( 2000, function()
    {
      con.give();
      con.give();
    });

    return con;
  });

  /* */

  t.shouldThrowError( function()
  {
    return _.timeOut( 250 );
  });

  /* */

  t.will = 'a';

  t.identical( 0,0 );
  t.shouldThrowErrorAsync( function()
  {
  });

  t.identical( 0,0 );

  t.shouldThrowErrorAsync( function()
  {
    throw _.err( 'test' );
  });

  t.identical( 0,0 );

  t.shouldThrowErrorAsync( function()
  {
    return _.timeOut( 250,function()
    {
      throw _.err( 'test' );
    });
  });

  t.identical( 0,0 );

  t.shouldThrowErrorAsync( function()
  {
    return _.timeOut( 250 );
  });

  t.identical( 0,0 );

  t.shouldThrowErrorAsync( function()
  {
    var con = _.Consequence().give();

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

    counter.acheck = t.checkCurrent();
    console.log( 'checkIndex',acheck.checkIndex, 13 );
    console.log( 'testCheckPasses',test.suite.report.testCheckPasses, 8 );
    console.log( 'testCheckFails',test.suite.report.testCheckFails, 4 );

  });

  /* */

  test.case = 'simplest, does not throw error,  but expected';
  test.shouldThrowErrorAsync( function()
  {
  });

  /* */

  test.case = 'single message';
  test.mustNotThrowError( function()
  {
    return _.timeOut( 250 );
  });

  /* */

  test.shouldThrowErrorSync( function()
  {
    var con = _.Consequence().give();

    _.timeOut( 250, function()
    {
      con.give();
      con.give();
    });

    return con;
  });

  /* */

  test.shouldThrowErrorSync( function()
  {
    return _.timeOut( 250 );
  });

  /* */

  test.mustNotThrowError( function()
  {
  });

  test.identical( 0,0 );

  test.mustNotThrowError( function()
  {
    throw _.err( 'test' );
  });

  test.identical( 0,0 );

  /* */

  test.case = 'if passes dont appears in output/passed test checks/total counter';
  test.mustNotThrowError( function()
  {
  });

  test.identical( 0,0 );

  test.case = 'if not passes then appears in output/total counter';
  test.mustNotThrowError( function()
  {
    return _.timeOut( 1000,function()
    {
      throw _.err( 'test' );
    });
    // throw _.err( 'test' );
  });

  test.identical( 0,0 );

  test.case = 'not expected second message';
  test.mustNotThrowError( function()
  {
    var con = _.Consequence().give();

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

function shouldThrowErrorSyncSimple( test )
{

  test.identical( test._inroutineCon.resourcesGet().length,1 );

  var consequence = new _.Consequence().give();
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

function shouldThrowErrorAsyncSimple( test )
{
  var consequence = new _.Consequence().give();
  var counter = new CheckCounter();

  counter.testRoutine = test;
  counter.next();

  test.identical( test._inroutineCon.resourcesGet().length,1 );

  consequence
  .doThen( function()
  {
    test.case = 'a';
    test.will = 'aa';
    var con = _.timeOut( 150,function()
    {
      throw _.errAttend( 'async error' );
    });
    return test.shouldThrowErrorAsync( con );
  })
  .doThen( function( err, arg )
  {
    test.is( err === undefined );
    test.is( _.errIs( arg ) );
    test.case = 'b';
    test.will = 'bb';

    var acheck = test.checkCurrent();
    var expectedCheck =
    {
      testsGroupsStack : [ 'b' ],
      will : 'bb',
      checkIndex : 5,
    }
    test.identical( acheck, expectedCheck );

    var con = _.timeOut( 50,function()
    {
      throw _.errAttend( 'async error' );
    });
    return test.shouldThrowErrorAsync( con );
  })
  .doThen( function( err, arg )
  {
    test.is( err === undefined );
    test.is( _.errIs( arg ) );

    test.identical( test.report.testCheckFails-counter.prevCheckFails, 0 );
    test.identical( test.report.testCheckPasses-counter.prevCheckPasses, 9 );

    var acheck = test.checkCurrent();
    var expectedCheck =
    {
      testsGroupsStack : [ 'b' ],
      will : 'bb',
      checkIndex : 11,
    }
    test.identical( acheck, expectedCheck );

    test.identical( test._inroutineCon.resourcesGet().length,0 );

  })
  ;

  return consequence;
}

shouldThrowErrorAsyncSimple.timeOut = 3000;

//

function shouldThrowErrorAsyncConcurrent( test )
{
  var consequence = new _.Consequence().give();
  var counter = new CheckCounter();

  counter.testRoutine = test;
  counter.next();

  test.identical( test._inroutineCon.resourcesGet().length,1 );

  consequence
  .doThen( function()
  {

    test.case = 'a';
    test.will = 'aa';
    var con = _.timeOut( 150,function()
    {
      throw _.errAttend( 'async error' );
    });
    var con1 = test.shouldThrowErrorAsync( con );

    test.case = 'b';
    test.will = 'bb';
    var con = _.timeOut( 50,function()
    {
      throw _.errAttend( 'async error' );
    });
    var con2 = test.shouldThrowErrorAsync( con );

    return _.timeOut( 200 );
  })
  .doThen( function( err,arg )
  {

    test.identical( arg, _.timeOut );
    test.identical( err, undefined );

    test.identical( test.report.testCheckPasses-counter.prevCheckPasses, 5 );
    test.identical( test.report.testCheckFails-counter.prevCheckFails, 0 );

    var acheck = test.checkCurrent();
    var expectedCheck =
    {
      testsGroupsStack : [ 'b' ],
      will : 'bb',
      checkIndex : 8,
    }
    test.identical( acheck, expectedCheck );

    test.identical( test._inroutineCon.resourcesGet().length, 1 );

  })
  ;

  return consequence;
}

shouldThrowErrorAsyncConcurrent.timeOut = 3000;

//

function _chainedShould( test,o )
{

  var method = o.method;
  var counter = new CheckCounter();

  /* */

  function row( t )
  {
    var prefix = method + ' . ' + 'in row' + ' . ';

    counter.testRoutine = t;

    counter.acheck = counter.testRoutine.checkCurrent();
    test.identical( counter.acheck.checkIndex, 1 );
    test.identical( suite.report.testCheckPasses, 0 );
    test.identical( suite.report.testCheckFails, 0 );

    return new _.Consequence().give()
    .doThen( function()
    {

      test.case = prefix + 'beginning of the test routine';
      counter.acheck = counter.testRoutine.checkCurrent();
      test.identical( counter.acheck.checkIndex, 1 );
      test.identical( t.suite.report.testCheckPasses, 0 );
      test.identical( t.suite.report.testCheckFails, 0 );

      var con = _.timeOut( 50,function( err )
      {
        test.case = prefix + 'give the first message';
        test.is( 1 );
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

      test.case = prefix + 'first ' + method + ' done';
      counter.acheck = counter.testRoutine.checkCurrent();
      test.identical( counter.acheck.checkIndex, 2 );
      test.identical( t.suite.report.testCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails, 0 );

      var con = _.timeOut( 50,function( err )
      {
        test.case = prefix + 'give the second message';
        test.is( 1 );
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

      test.case = prefix + 'second ' + method + ' done';
      counter.acheck = counter.testRoutine.checkCurrent();
      test.identical( counter.acheck.checkIndex, 3 );
      test.identical( t.suite.report.testCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails, 0 );

    });

  };

  /* */

  function include( t )
  {

    var prefix = method + ' . ' + 'include' + ' . ';
    counter.testRoutine = t;

    test.case = prefix + 'beginning of the included test routine ';

    if( o.throwingError === 'sync' )
    return first();
    else
    return t[ method ]( first );

    function first()
    {

      var result = _.timeOut( 50,function()
      {

        test.case = prefix + 'first timeout of the included test routine ';

        test.identical( t.suite.report.testCheckPasses, 3 );
        test.identical( t.suite.report.testCheckFails, 0 );

        if( o.throwingError === 'sync' )
        t[ method ]( function(){ throw _.err( 'sync error' ); } );

        counter.acheck = counter.testRoutine.checkCurrent();
        test.identical( counter.acheck.checkIndex, 2 );

        if( o.throwingError === 'sync' )
        {
          return second();
        }
        else
        t[ method ]( second );

        if( o.throwingError === 'async' )
        throw _.err( 'async error' );
      });

      return result;
    }

    function second()
    {
      return _.timeOut( 50,function()
      {

        test.case = prefix + 'first ' + method + ' done';

        test.identical( t.suite.report.testCheckPasses, 4 );
        test.identical( t.suite.report.testCheckFails, 0 );

        if( o.throwingError === 'sync' )
        t[ method ]( function(){ throw _.err( 'sync error' ) } );

        counter.acheck = counter.testRoutine.checkCurrent();
        test.identical( counter.acheck.checkIndex, 3 );

        if( o.throwingError === 'async' )
        t[ method ]( _.timeOutError( 50 ) );
        else if( !o.throwingError )
        t[ method ]( _.timeOut( 50 ) );
        else
        t.identical( 1,1 );

        if( o.throwingError === 'async' )
        throw _.err( 'async error' );
      });
    }

  };

  /* */

  var suite = wTestSuite
  ({
    tests : { row : row, include : include },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : _.diagnosticLocation().name + '/' + method + '/' + o.throwingError,
  });

  if( suite.on )
  suite.on( 'routineEnd',function( e )
  {

    // console.log( 'routineEnd',e.testRoutine.routine.name );

    if( e.testRoutine.routine.name === 'row' )
    {
      test.case = 'checking outcomes';
      counter.acheck = counter.testRoutine.checkCurrent();
      test.identical( counter.acheck.checkIndex, 4 );
      test.identical( suite.report.testCheckPasses, 3 );
      test.identical( suite.report.testCheckFails, 0 );
    }

  });

  /* */

  return suite.run()
  .doThen( function( err,data )
  {

    test.case = 'checking outcomes';

    counter.acheck = counter.testRoutine.checkCurrent();
    test.identical( counter.acheck.checkIndex, 5 ); /* 4 */
    test.identical( suite.report.testCheckPasses, 7 ); /* 6 */
    test.identical( suite.report.testCheckFails, 0 );

    if( err )
    throw err;
  });

}

_chainedShould.experimental = 1;

//

function chainedShould( test )
{
  var con = _.Consequence().give();

  /* qqq : double check _hasConsoleInOutputs */

  var iterations =
  [

    {
      method : 'shouldThrowError',
      throwingError : 'sync',
    },

    {
      method : 'shouldThrowError',
      throwingError : 'async',
    },

    {
      method : 'shouldThrowErrorSync',
      throwingError : 'sync',
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

//

function isReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 3 );
    test.identical( suite.report.testCheckFails, 9 );
    test.identical( suite.report.errorsArray.length, 7 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {

    var got = t.is( 1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.is( 0 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.is( true );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.is( false );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'not bool-like, string';

    var got = t.is( '1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'not bool-like, map';

    var got = t.is( {} );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'not bool-like, array';

    var got = t.is( [] );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'not bool-like, routine';

    var got = t.is( t.is );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.is( true, false );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'no arguments';

    var got = t.is();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.is( { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

  }

}

//

function isNotReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 3 );
    test.identical( suite.report.testCheckFails, 9 );
    test.identical( suite.report.errorsArray.length, 7 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {

    debugger;
    var got = t.isNot( 1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );
    debugger;

    /* */

    var got = t.isNot( 0 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.isNot( true );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.isNot( false );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'not bool-like, string';

    var got = t.isNot( '1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'not bool-like, map';

    var got = t.isNot( {} );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'not bool-like, array';

    var got = t.isNot( [] );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'not bool-like, routine';

    var got = t.isNot( t.isNot );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.isNot( true, false );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'no arguments';

    var got = t.isNot();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.isNot( { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

  }

}

//

function isNotErrorReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 9 );
    test.identical( suite.report.testCheckFails, 5 );
    test.identical( suite.report.errorsArray.length, 3 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {

    var got = t.isNotError( 1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.isNotError( 0 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.isNotError( '1' );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.isNotError( true );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.isNotError( false );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.isNotError( {} );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.isNotError( [] );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.isNotError( t.is );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.isNotError( _.err( 'msg' ) );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.isNotError( new Error( 'msg' ) );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'no arguments';

    var got = t.isNotError();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.isNotError( { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.isNotError( true, false );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

  }

}

//

function identicalReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 8 );
    test.identical( suite.report.testCheckFails, 7 );
    test.identical( suite.report.errorsArray.length, 2 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {

    var got = t.identical( 1,1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.identical( 1,2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.identical( 1,'1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.identical( '1','1' );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.identical( true, true );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.identical( false, true );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );

    var got = t.identical( d1,d2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.identical( [ 1 ], [ 1 ] );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.identical( [ 1 ], [ 2 ] );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.identical( { a : 1 }, { a : 1 } );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.identical( { a : 1 }, { a : 2 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    /* qqq : fix this case */
    // debugger;
    // var got = t.identical( test, t );
    // debugger;
    // test.identical( got, false );
    // test.identical( _.boolIs( got ), true );

    /* */

    var got = t.identical( t.notIdentical, t.notIdentical );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'no arguments';

    var got = t.identical();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.identical( { a : 1 }, { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    debugger;
  }

}

//

function notIdenticalReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 5 );
    test.identical( suite.report.testCheckFails, 9 );
    test.identical( suite.report.errorsArray.length, 2 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {
    var got = t.notIdentical( 1,1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notIdentical( 1,'1' );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notIdentical( '1','1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notIdentical( true, true );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notIdentical( false, true );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );

    var got = t.notIdentical( d1,d2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notIdentical( [ 1 ], [ 1 ] );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notIdentical( [ 1 ], [ 2 ] );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notIdentical( { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notIdentical( { a : 1 }, { a : 2 } );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    /* qqq : fix this case */
    // var got = t.notIdentical( test, t );
    // test.identical( got, true );
    // test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notIdentical( t.notIdentical, t.notIdentical );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'no arguments';

    var got = t.notIdentical();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.notIdentical( { a : 1 }, { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

  }

}

//

function equivalentReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 16 );
    test.identical( suite.report.testCheckFails, 13 );
    test.identical( suite.report.errorsArray.length, 5 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {

    var got = t.equivalent( 1,1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.equivalent( 1,2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.equivalent( 1,'1' );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.equivalent( '1',1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.equivalent( '1','1' );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );

    var got = t.equivalent( d1,d2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.equivalent( true, true );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.equivalent( false, true );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.equivalent( [ 1 ], [ 1 ] );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.equivalent( [ 1 ], [ 2 ] );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.equivalent( { a : 1 }, { a : 1 } );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.equivalent( { a : 1 }, { a : 2 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    /* qqq : fix this case */
    // var got = t.equivalent( test, t );
    // test.identical( got, false );
    // test.identical( _.boolIs( got ), true );

    /* */

    var got = t.equivalent( t.notIdentical, t.notIdentical );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    t.suite.accuracy = 0.1;
    var got = t.equivalent( 1, 1.05 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    test.is( t.suite.accuracy === t.accuracy );
    test.is( _.numberIs( t.suite.accuracy ) );
    test.is( _.numberIs( t.accuracy ) );

    t.suite.accuracy = null;
    test.is( t.suite.accuracy === t.accuracy );
    test.is( _.numberIs( t.suite.accuracy ) );
    test.is( _.numberIs( t.accuracy ) );

    /* */

    t.accuracy = 0.01;
    var got = t.equivalent( 1, 1.05 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.is( t.suite.accuracy < t.accuracy );
    test.is( _.numberIs( t.suite.accuracy ) );
    test.is( _.numberIs( t.accuracy ) );

    /* */

    test.case = 'third argument is accuracy';

    var got = t.equivalent( 1, 1.05, 0.01 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    var got = t.equivalent( 1, 1.05, 0.1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'third argument is options map with accuracy';

    var got = t.equivalent( 1, 1.05, { accuracy : 0.01 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    var got = t.equivalent( 1, 1.05, { accuracy : 0.1 } );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    t.accuracy = 0.1;
    var got = t.equivalent( 1, 1.05 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    t.accuracy = null;
    t.suite.accuracy = 0.01;
    var got = t.equivalent( 1, 1.05 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );
    var got = t.equivalent( 1, 1.005 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    var got = t.equivalent( 1, 1 + 1e-11 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    test.is( t.suite.accuracy === t.accuracy );
    test.is( _.numberIs( t.suite.accuracy ) );
    test.is( _.numberIs( t.accuracy ) );

    debugger;

    /* */

    test.case = 'no arguments';

    var got = t.equivalent();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.equivalent( { a : 1 }, { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.equivalent( 1.05, 1, null )
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.equivalent( 1.05, 1, 'x' )
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.equivalent( 1.05, 1, [] )
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

  }

}

equivalentReturn.timeOut = 30000;

//

function notEquivalentReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 8 );
    test.identical( suite.report.testCheckFails, 20 );
    test.identical( suite.report.errorsArray.length, 5 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {

    var got = t.notEquivalent( 1,1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notEquivalent( 1,2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notEquivalent( 1,'1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notEquivalent( '1',1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notEquivalent( '1','1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );
    var got = t.notEquivalent( d1,d2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notEquivalent( true, true );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notEquivalent( false, true );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notEquivalent( [ 1 ], [ 1 ] );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notEquivalent( [ 1 ], [ 2 ] );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notEquivalent( { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notEquivalent( { a : 1 }, { a : 2 } );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    /* qqq : fix this case */
    // var got = t.notEquivalent( test, t );
    // test.identical( got, true );
    // test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notEquivalent( t.notIdentical, t.notIdentical );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    t.suite.accuracy = 0.1;
    var got = t.notEquivalent( 1, 1.05 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.is( t.suite.accuracy === t.accuracy );
    test.is( _.numberIs( t.suite.accuracy ) );
    test.is( _.numberIs( t.accuracy ) );

    t.suite.accuracy = null;
    test.is( t.suite.accuracy === t.accuracy );
    test.is( _.numberIs( t.suite.accuracy ) );
    test.is( _.numberIs( t.accuracy ) );

    /* */

    t.accuracy = 0.01;
    var got = t.notEquivalent( 1, 1.05 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    test.is( t.suite.accuracy < t.accuracy );
    test.is( _.numberIs( t.suite.accuracy ) );
    test.is( _.numberIs( t.accuracy ) );

    /* */

    t.accuracy = 0.1;
    var got = t.notEquivalent( 1, 1.05 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    t.accuracy = null;
    t.suite.accuracy = 0.1;
    var got = t.notEquivalent( 1, 1.05 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    var got = t.notEquivalent( 1, 1 + 1e-11 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.is( t.suite.accuracy === t.accuracy );
    test.is( _.numberIs( t.suite.accuracy ) );
    test.is( _.numberIs( t.accuracy ) );

    /* */

    test.case = 'third argument is accuracy';

    var got = t.notEquivalent( 1, 1.05, 0.01 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    var got = t.notEquivalent( 1, 1.05, 0.1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'third argument is options map with accuracy';

    var got = t.notEquivalent( 1, 1.05, { accuracy : 0.01 } );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    var got = t.notEquivalent( 1, 1.05, { accuracy : 0.1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'no arguments';

    var got = t.notEquivalent();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.notEquivalent( { a : 1 }, { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.notEquivalent( 1.05, 1, null )
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.notEquivalent( 1.05, 1, 'x' )
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.notEquivalent( 1.05, 1, [] )
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

  }

}

//

function containReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 7 );
    test.identical( suite.report.testCheckFails, 12 );
    test.identical( suite.report.errorsArray.length, 2 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {
    var got = t.contains( 1,1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( 1,2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( 1,'1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( '1',1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( '1','1' );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( true, true );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( false, true );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( [ 1 ], [ 1 ] );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( [ 1 ], [ 2 ] );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( [ 1,2,3,4 ], 5 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( [ 1,2,3,4 ], 4 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( [ 1,2,3,4 ], [ 4,5 ] );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( [ 1,2,3,4 ], [ 3,4 ] );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( { a : 1 }, { a : 1 } );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( { a : 1 }, { a : 2 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( { a : 1, b : 2 }, { b : 2 } );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'no arguments';

    var got = t.contains();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.contains( { a : 1 }, { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

  }

}

//

function shouldThrowErrorSyncReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 2 );
    test.identical( suite.report.testCheckFails, 5 );
    test.identical( suite.report.errorsArray.length, 3 );
  }

  /* */

  function returnTest( t )
  {

    var got = t.shouldThrowErrorSync( () => true );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.shouldThrowErrorSync( () => { throw _.err( 1 ) } );
    test.identical( !!got, true );
    test.identical( _.errIs( got ), true );

    /* */

    var got = t.shouldThrowErrorSync( () => _.Consequence().error( 1 ) );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'no arguments';
    var got = t.shouldThrowErrorSync()
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'not routines';
    var got = t.shouldThrowErrorSync( 'x' )
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'several functions';
    var got = t.shouldThrowErrorSync( function(){}, function(){} )
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

  }

}

//

function shouldThrowErrorAsyncReturn( test )
{

  var done = 0;
  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 4 );
    test.identical( suite.report.testCheckFails, 6 );
    test.identical( suite.report.errorsArray.length, 3 );
    test.identical( done, 1 );
  }

  /* */

  function returnTest( t )
  {
    var con = _.Consequence().give()

    .ifNoErrorThen( () =>
    {
      return t.shouldThrowErrorAsync( () => true )
      .doThen( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.shouldThrowErrorAsync( () => { throw _.err( 1 ) } )
      .doThen( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.shouldThrowErrorAsync( _.Consequence().give( 1 ) )
      .doThen( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.shouldThrowErrorAsync( _.Consequence().error( _.err( 'error!' ) ) )
      .doThen( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.errIs( got ), true );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.shouldThrowErrorAsync( _.Consequence().error( 1 ) )
      .doThen( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( got, 1 );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.shouldThrowErrorAsync( _.timeOutError( 1 ) )
      .doThen( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.errIs( got ), true );
      })
    })

    .ifNoErrorThen( () =>
    {
      test.case = 'no arguments';
      return t.shouldThrowErrorAsync()
      .doThen( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
      })
    })

    .ifNoErrorThen( () =>
    {
      test.case = 'not routines';
      return t.shouldThrowErrorAsync( 'x' )
      .doThen( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
      })
    })

    .ifNoErrorThen( () =>
    {
      test.case = 'several functions';
      return t.shouldThrowErrorAsync( function(){}, function(){} )
      .doThen( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        done = 1;
      })
    })

    return con;
  }

}

//

function shouldThrowErrorReturn( test )
{

  var done = 0;
  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 4 );
    test.identical( suite.report.testCheckFails, 5 );
    test.identical( suite.report.errorsArray.length, 3 );
    test.identical( done, 1 );
  }

  /* */

  function returnTest( t )
  {
    var con = _.Consequence().give()

    .ifNoErrorThen( () =>
    {
      return t.shouldThrowError( () => true )
      .doThen( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.shouldThrowError( () => { throw _.err( 1 ) } )
      .doThen( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.errIs( got ), true );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.shouldThrowError( _.Consequence().give( 1 ) )
      .doThen( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.shouldThrowError( _.Consequence().error( 1 ) )
      .doThen( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( got, 1 );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.shouldThrowError( _.timeOutError( 1 ) )
      .doThen( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.errIs( got ), true );
      })
    })

    .ifNoErrorThen( () =>
    {
      test.case = 'no arguments';
      return t.shouldThrowError()
      .doThen( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
      })
    })

    .ifNoErrorThen( () =>
    {
      test.case = 'not routines';
      return t.shouldThrowError( 'x' )
      .doThen( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.shouldThrowError( function(){}, function(){} )
      .doThen( ( err, got ) =>
      {
        test.case = 'several functions';
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        done = 1;
      })
    })

    return con;
  }

}

//

function mustNotThrowErrorReturn( test )
{

  var done = 0;
  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 3 );
    test.identical( suite.report.testCheckFails, 6 );
    test.identical( suite.report.errorsArray.length, 3 );
    test.identical( done, 1 );
  }

  /* */

  function returnTest( t )
  {
    var con = _.Consequence().give()

    .ifNoErrorThen( () =>
    {
      return t.mustNotThrowError( () => true )
      .doThen( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( got, true );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.mustNotThrowError( () => { throw _.err( 1 ) } )
      .doThen( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.mustNotThrowError( _.Consequence().give( 1 ) )
      .doThen( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( got, 1 );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.mustNotThrowError( _.Consequence().error( 1 ) )
      .doThen( ( err, got ) =>
      {
        test.identical( err, 1 );
        test.identical( got, undefined );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.mustNotThrowError( _.timeOutError( 1 ) )
      .doThen( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
      })
    })

    .ifNoErrorThen( () =>
    {
      test.case = 'no arguments';
      return t.mustNotThrowError()
      .doThen( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
      })
    })

    .ifNoErrorThen( () =>
    {
      test.case = 'not routines';
      return t.mustNotThrowError( 'x' )
      .doThen( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.mustNotThrowError( function(){}, function(){} )
      .doThen( ( err, got ) =>
      {
        test.case = 'several functions';
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        done = 1;
      })
    })

    return con;
  }

}

//

function shouldMessageOnlyOnceReturn( test )
{

  var done = 0;
  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 11 );
    test.identical( suite.report.testCheckFails, 5 );
    test.identical( suite.report.errorsArray.length, 3 );
    test.identical( done, 1 );
  }

  /* */

  function returnTest( t )
  {
    var con = _.Consequence().give()

    .ifNoErrorThen( () =>
    {
      return t.shouldMessageOnlyOnce( () => 1 )
      .doThen( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( got, 1 );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.shouldMessageOnlyOnce( () => { throw _.err( 1 ) } )
      .doThen( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.errIs( got ), true );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.shouldMessageOnlyOnce( _.Consequence().give( 1 ) )
      .doThen( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( got, 1 );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.shouldMessageOnlyOnce( () => _.Consequence().give( 1 ) )
      .doThen( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( got, 1 );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.shouldMessageOnlyOnce( _.Consequence().error( _.err( 1 ) ) )
      .doThen( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.errIs( got ), true );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.shouldMessageOnlyOnce( () => _.Consequence().error( _.err( 1 ) ) )
      .doThen( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.errIs( got ), true );
      })
    })

    .ifNoErrorThen( () =>
    {
      var con = _.timeOut( 1, () => _.timeOut( 1 ) )
      return t.shouldMessageOnlyOnce( con )
      .doThen( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.routineIs( got ), true );
      })
    })

    .ifNoErrorThen( () =>
    {
      var con = _.timeOut( 1, () => _.timeOut( 1 ) )
      return t.shouldMessageOnlyOnce( () => con )
      .doThen( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.routineIs( got ), true );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.shouldMessageOnlyOnce( _.timeOutError( 1 ) )
      .doThen( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.errIs( got ), true );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.shouldMessageOnlyOnce( () => _.timeOutError( 1 ) )
      .doThen( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.errIs( got ), true );
      })
    })

    .ifNoErrorThen( () =>
    {
      var con = _.Consequence().give( 1 ).give( 2 );
      return t.shouldMessageOnlyOnce( con )
      .doThen( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
      })
    })

    .ifNoErrorThen( () =>
    {
      var con = _.Consequence().give( 1 ).give( 2 );
      return t.shouldMessageOnlyOnce( () => con )
      .doThen( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
      })
    })

    .ifNoErrorThen( () =>
    {
      test.case = 'no arguments';
      return t.shouldMessageOnlyOnce()
      .doThen( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
      })
    })

    .ifNoErrorThen( () =>
    {
      test.case = 'not routines';
      return t.shouldMessageOnlyOnce( 'x' )
      .doThen( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
      })
    })

    .ifNoErrorThen( () =>
    {
      return t.shouldMessageOnlyOnce( function(){}, function(){} )
      .doThen( ( err, got ) =>
      {
        test.case = 'several functions';
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        done = 1;
      })
    })

    return con;
  }

}

//

function ilReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 8 );
    test.identical( suite.report.testCheckFails, 7 );
    test.identical( suite.report.errorsArray.length, 2 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {

    var got = t.il( 1,1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.il( 1,2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.il( 1,'1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.il( '1','1' );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.il( true, true );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.il( false, true );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );

    var got = t.il( d1,d2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.il( [ 1 ], [ 1 ] );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.il( [ 1 ], [ 2 ] );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.il( { a : 1 }, { a : 1 } );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.il( { a : 1 }, { a : 2 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    /* qqq : fix this case */
    // debugger;
    // var got = t.il( test, t );
    // debugger;
    // test.identical( got, false );
    // test.identical( _.boolIs( got ), true );

    /* */

    var got = t.il( t.notIdentical, t.notIdentical );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'no arguments';

    var got = t.il();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.il( { a : 1 }, { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

  }

}

//

function niReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 5 );
    test.identical( suite.report.testCheckFails, 9 );
    test.identical( suite.report.errorsArray.length, 2 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {
    var got = t.ni( 1,1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ni( 1,'1' );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ni( '1','1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ni( true, true );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ni( false, true );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );

    var got = t.ni( d1,d2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ni( [ 1 ], [ 1 ] );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ni( [ 1 ], [ 2 ] );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ni( { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ni( { a : 1 }, { a : 2 } );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    /* qqq : fix this case */
    // var got = t.ni( test, t );
    // test.identical( got, true );
    // test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ni( t.ni, t.ni );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'no arguments';

    var got = t.ni();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.ni( { a : 1 }, { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

  }

}

//

function etReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 16 );
    test.identical( suite.report.testCheckFails, 13 );
    test.identical( suite.report.errorsArray.length, 5 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {

    var got = t.et( 1,1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.et( 1,2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.et( 1,'1' );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.et( '1',1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.et( '1','1' );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );

    var got = t.et( d1,d2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.et( true, true );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.et( false, true );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.et( [ 1 ], [ 1 ] );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.et( [ 1 ], [ 2 ] );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.et( { a : 1 }, { a : 1 } );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.et( { a : 1 }, { a : 2 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    /* qqq : fix this case */
    // var got = t.et( test, t );
    // test.identical( got, false );
    // test.identical( _.boolIs( got ), true );

    /* */

    var got = t.et( t.notIdentical, t.notIdentical );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    t.suite.accuracy = 0.1;
    var got = t.et( 1, 1.05 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    test.is( t.suite.accuracy === t.accuracy );
    test.is( _.numberIs( t.suite.accuracy ) );
    test.is( _.numberIs( t.accuracy ) );

    t.suite.accuracy = null;
    test.is( t.suite.accuracy === t.accuracy );
    test.is( _.numberIs( t.suite.accuracy ) );
    test.is( _.numberIs( t.accuracy ) );

    /* */

    t.accuracy = 0.01;
    var got = t.et( 1, 1.05 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.is( t.suite.accuracy < t.accuracy );
    test.is( _.numberIs( t.suite.accuracy ) );
    test.is( _.numberIs( t.accuracy ) );

    /* */

    test.case = 'third argument is accuracy';

    var got = t.et( 1, 1.05, 0.01 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    var got = t.et( 1, 1.05, 0.1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'third argument is options map with accuracy';

    var got = t.et( 1, 1.05, { accuracy : 0.01 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    var got = t.et( 1, 1.05, { accuracy : 0.1 } );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    t.accuracy = 0.1;
    var got = t.et( 1, 1.05 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    t.accuracy = null;
    t.suite.accuracy = 0.01;
    var got = t.et( 1, 1.05 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );
    var got = t.et( 1, 1.005 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    var got = t.et( 1, 1 + 1e-11 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    test.is( t.suite.accuracy === t.accuracy );
    test.is( _.numberIs( t.suite.accuracy ) );
    test.is( _.numberIs( t.accuracy ) );

    /* */

    test.case = 'no arguments';

    var got = t.et();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.et( { a : 1 }, { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.et( 1.05, 1, null )
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.et( 1.05, 1, 'x' )
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.et( 1.05, 1, [] )
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

  }

}

//

function neReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 8 );
    test.identical( suite.report.testCheckFails, 20 );
    test.identical( suite.report.errorsArray.length, 5 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {

    var got = t.ne( 1,1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ne( 1,2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ne( 1,'1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ne( '1',1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ne( '1','1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );
    var got = t.ne( d1,d2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ne( true, true );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ne( false, true );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ne( [ 1 ], [ 1 ] );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ne( [ 1 ], [ 2 ] );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ne( { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ne( { a : 1 }, { a : 2 } );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    /* qqq : fix this case */
    // var got = t.ne( test, t );
    // test.identical( got, true );
    // test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ne( t.notIdentical, t.notIdentical );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    t.suite.accuracy = 0.1;
    var got = t.ne( 1, 1.05 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.is( t.suite.accuracy === t.accuracy );
    test.is( _.numberIs( t.suite.accuracy ) );
    test.is( _.numberIs( t.accuracy ) );

    t.suite.accuracy = null;
    test.is( t.suite.accuracy === t.accuracy );
    test.is( _.numberIs( t.suite.accuracy ) );
    test.is( _.numberIs( t.accuracy ) );

    /* */

    t.accuracy = 0.01;
    var got = t.ne( 1, 1.05 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    test.is( t.suite.accuracy < t.accuracy );
    test.is( _.numberIs( t.suite.accuracy ) );
    test.is( _.numberIs( t.accuracy ) );

    /* */

    t.accuracy = 0.1;
    var got = t.ne( 1, 1.05 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    t.accuracy = null;
    t.suite.accuracy = 0.1;
    var got = t.ne( 1, 1.05 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    var got = t.ne( 1, 1 + 1e-11 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.is( t.suite.accuracy === t.accuracy );
    test.is( _.numberIs( t.suite.accuracy ) );
    test.is( _.numberIs( t.accuracy ) );

    /* */

    test.case = 'third argument is accuracy';

    var got = t.ne( 1, 1.05, 0.01 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    var got = t.ne( 1, 1.05, 0.1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'third argument is options map with accuracy';

    var got = t.ne( 1, 1.05, { accuracy : 0.01 } );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    var got = t.ne( 1, 1.05, { accuracy : 0.1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'no arguments';

    var got = t.ne();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.ne( { a : 1 }, { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.ne( 1.05, 1, null )
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.ne( 1.05, 1, 'x' )
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.ne( 1.05, 1, [] )
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

  }

}

//

function gtReturn( test )
{

  test.case = 'trivial';

  var got = test.gt( 2,1 );
  test.identical( got, true );

  test.case = 'suite';

  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 4 );
    test.identical( suite.report.testCheckFails, 10 );
    test.identical( suite.report.errorsArray.length, 3 );
    if( suite.report.errorsArray.length )
    console.log( suite.report.errorsArray[ 0 ] );

    test.case = 'trivial';

    var got = test.gt( 2,1 );
    test.identical( got, true );

  }

  /* */

  function returnTest( t )
  {

    var got = t.gt( 1,1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.gt( 1,2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.gt( 2,1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.gt( 1.01,1.01 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.gt( 1.01,1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.gt( 1.01,1.02 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );

    var got = t.gt( d1,d2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );

    var got = t.gt( d1,d2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );
    d1.setSeconds( 20 );
    d2.setSeconds( 30 );

    var got = t.gt( d1,d2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );
    d1.setSeconds( 20 );
    d2.setSeconds( 30 );

    var got = t.gt( d2,d1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'no arguments';

    var got = t.gt();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.gt( { a : 1 }, { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.gt( 1.05, 1, 0.1 )
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

  }

}

//

function geReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 8 );
    test.identical( suite.report.testCheckFails, 6 );
    test.identical( suite.report.errorsArray.length, 3 );
    if( suite.report.errorsArray.length )
    console.log( suite.report.errorsArray[ 0 ] );

    test.case = 'trivial';

    var got = test.ge( 2,1 );
    test.identical( got, true );
    var got = test.ge( 2,2 );
    test.identical( got, true );

  }

  /* */

  function returnTest( t )
  {
    var got = t.ge( 1,1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ge( 1,2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ge( 2,1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ge( 1.01,1.01 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ge( 1.01,1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ge( 1.01,1.02 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );

    var got = t.ge( d1,d2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );

    var got = t.ge( d1,d2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );
    d1.setSeconds( 20 );
    d2.setSeconds( 30 );

    var got = t.ge( d1,d2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );
    d1.setSeconds( 20 );
    d2.setSeconds( 30 );

    var got = t.ge( d2,d1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'no arguments';

    var got = t.ge();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.ge( { a : 1 }, { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.ge( 1.05, 1, 0.1 )
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

  }

}

//

function ltReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 4 );
    test.identical( suite.report.testCheckFails, 10 );
    test.identical( suite.report.errorsArray.length, 3 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );

    test.case = 'trivial';

    var got = test.lt( 2,3 );
    test.identical( got, true );

  }

  /* */

  function returnTest( t )
  {
    var got = t.lt( 1,1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.lt( 1,2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.lt( 2,1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.lt( 1.01,1.01 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.lt( 1.01,1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.lt( 1.01,1.02 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );

    var got = t.lt( d1,d2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );

    var got = t.lt( d1,d2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );
    d1.setSeconds( 20 );
    d2.setSeconds( 30 );

    var got = t.lt( d1,d2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );
    d1.setSeconds( 20 );
    d2.setSeconds( 30 );

    var got = t.lt( d2,d1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'no arguments';

    var got = t.lt();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.lt( { a : 1 }, { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.lt( 1.05, 1, 0.1 )
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

  }

}

//

function leReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd : onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 8 );
    test.identical( suite.report.testCheckFails, 6 );
    test.identical( suite.report.errorsArray.length, 3 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );

    test.case = 'trivial';

    var got = test.le( 2,3 );
    test.identical( got, true );
    var got = test.le( 2,2 );
    test.identical( got, true );

  }

  /* */

  function returnTest( t )
  {
    var got = t.le( 1,1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.le( 1,2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.le( 2,1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.le( 1.01,1.01 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.le( 1.01,1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.le( 1.01,1.02 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );

    var got = t.le( d1,d2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );

    var got = t.le( d1,d2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );
    d1.setSeconds( 20 );
    d2.setSeconds( 30 );

    var got = t.le( d1,d2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );
    d1.setSeconds( 20 );
    d2.setSeconds( 30 );

    var got = t.le( d2,d1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'no arguments';

    var got = t.le();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.le( { a : 1 }, { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.le( 1.05, 1, 0.1 )
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

  }

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

  return con;
}

asyncExperiment.experimental = 1;

//

function failExperiment( test )
{

  test.case = 'this test fails';

  test.identical( 0,1 );
  test.identical( 0,1 );

}

failExperiment.experimental = 1;

//

function mustNotThrowErrorExperiment( test )
{

  test.case = 'mustNotThrowError experiment';

  var con = test.mustNotThrowError( function()
  {
    console.log( 'x' );
    return _.timeOut( 500 );
  });

  // var con = test.shouldMessageOnlyOnce( function()
  // {
  //   throw _.err( 'err1' );
  // });

  // var con = test.shouldThrowError( function()
  // {
  //   throw _.err( 'err1' );
  // });

  return con;
}

mustNotThrowErrorExperiment.experimental = 1;

function experimentIdentical( test )
{
  var suite = wTestSuite
  ({
    tests : { returnTest : returnTest },
    override : notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
  });

  return suite.run();

  /* */

  /* */

  function returnTest( t )
  {
    debugger;
    var got = t.identical( test, t );
    debugger;
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );
  }
}

experimentIdentical.experimental = 1;

// --
// declare
// --

var Self =
{

  name : 'Tools/tester/General',
  silencing : 1,
  // enabled : 1,
  // routine : 'mustNotThrowError',

  context :
  {
  },

  tests :
  {

    simplest : simplest,
    identical : identical,

    // should

    shouldMessageOnlyOnce : shouldMessageOnlyOnce,
    mustNotThrowError : mustNotThrowError,
    shouldThrowErrorSync : shouldThrowErrorSync,
    shouldThrowErrorAsync : shouldThrowErrorAsync,
    shouldThrowError : shouldThrowError,

    shouldPassMessage : shouldPassMessage,
    _throwingExperiment : _throwingExperiment,

    shouldThrowErrorSyncSimple : shouldThrowErrorSyncSimple,
    shouldThrowErrorAsyncSimple : shouldThrowErrorAsyncSimple,
    shouldThrowErrorAsyncConcurrent : shouldThrowErrorAsyncConcurrent,

    _chainedShould : _chainedShould,
    chainedShould : chainedShould,

    //return

    isReturn : isReturn,
    isNotReturn : isNotReturn,
    isNotErrorReturn : isNotErrorReturn,

    identicalReturn : identicalReturn,
    notIdenticalReturn : notIdenticalReturn,
    equivalentReturn : equivalentReturn,
    notEquivalentReturn : notEquivalentReturn,
    containReturn : containReturn,

    shouldThrowErrorSyncReturn : shouldThrowErrorSyncReturn,
    shouldThrowErrorAsyncReturn : shouldThrowErrorAsyncReturn,
    shouldThrowErrorReturn : shouldThrowErrorReturn,
    mustNotThrowErrorReturn : mustNotThrowErrorReturn,
    shouldMessageOnlyOnceReturn : shouldMessageOnlyOnceReturn,

    ilReturn : ilReturn,
    niReturn : niReturn,
    etReturn : etReturn,
    neReturn : neReturn,

    /* */

    gtReturn : gtReturn,
    geReturn : geReturn,
    ltReturn : ltReturn,
    leReturn : leReturn,

    // etc

    asyncExperiment : asyncExperiment,
    failExperiment : failExperiment,
    mustNotThrowErrorExperiment : mustNotThrowErrorExperiment,
    experimentIdentical : experimentIdentical,

  },

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();
