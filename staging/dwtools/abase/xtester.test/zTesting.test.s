( function _zTesting_test_s_( ) {

'use strict';

/*

node builder/include/dwtools/abase/xtester/zTesting.test.s verbosity:6 importanceOfNegative:2 importanceOfDetails:0

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
      require.resolve( toolsPath );
    }
    catch( err )
    {
      _externalTools = 1;
      require( 'wTools' );
    }
    if( !_externalTools )
    require( toolsPath );
  }

  if( typeof _globalReal_ === 'undefined' || !_globalReal_.wTester || !_globalReal_.wTester._isFullImplementation )
  require( '../xtester/aBase.debug.s' );

  var _ = _global_.wTools;

  _.include( 'wLogger' );
  _.include( 'wConsequence' );

}

var _ = _global_.wTools;
var notTakingIntoAccount = { logger : _.Logger({ output : null }), concurrent : 1, takingIntoAccount : 0 };

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
    self.prevCheckIndex = self.acheck._checkIndex;
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

  test.identical( test.suit.report.testCheckPasses, 1 );
  test.identical( test.suit.report.testCheckFails, 0 );

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
    test.identical( t.suit.report.testCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails, 0 );

    t.identical( 0,false );
    test.identical( t.suit.report.testCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails, 1 );

    t.identical( 0,1 );
    test.identical( t.suit.report.testCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails, 2 );

  }

  var suit = wTestSuit({ tests : { r1 : r1 }, override : notTakingIntoAccount });

  var result = suit.run()
  .doThen( function( err,data )
  {

    var acheck = testRoutine.checkCurrent();
    test.identical( acheck._checkIndex, 5 );
    test.identical( suit.report.testCheckPasses, 2 );
    test.identical( suit.report.testCheckFails, 2 );

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
    t.description = 'a';

    t.identical( 0,0 );
    test.description = 'does not throw error';
    var c1 = t.shouldMessageOnlyOnce( function()
    {
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 2 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c1.messagesGet().length, 1 );
      c1.got( function( err,arg )
      {
        test.shouldBe( err === null );
        test.shouldBe( arg === undefined );
      });
    });

    /* */

    t.identical( 0,0 );
    test.description = 'does not throw error, string sync message';
    var c2 = t.shouldMessageOnlyOnce( function()
    {
      return 'msg'
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 2 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c2.messagesGet().length, 1 );
      c2.got( function( err,arg )
      {
        test.shouldBe( err === null );
        test.shouldBe( arg === 'msg' );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'throw unexpected error, synchronously';
    var c3 = t.shouldMessageOnlyOnce( function()
    {
      throw _.errAttend( 'error1' );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 2 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c3.messagesGet().length, 1 );
      c3.got( function( err,arg )
      {
        test.shouldBe( err === null );
        test.shouldBe( _.errIs( arg ) );
        test.shouldBe( _.strHas( arg.message,'error1' ) );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'throw unexpected error, asynchronously';
    var c4 = t.shouldMessageOnlyOnce( function()
    {
      return _.timeOut( 250,function()
      {
        throw _.errAttend( 'error1' );
      });
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c4.messagesGet().length, 1 );
      c4.got( function( err,arg )
      {
        test.shouldBe( err === null );
        test.shouldBe( _.errIs( arg ) );
        test.shouldBe( _.strHas( arg.message,'error1' ) );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'single async message, no error';
    var c5 = t.shouldMessageOnlyOnce( function()
    {
      return _.timeOut( 250 );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c5.messagesGet().length, 1 );
      c5.got( function( err,arg )
      {
        test.shouldBe( err === null );
        test.shouldBe( arg === _.timeOut );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'not expected second message';
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
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c6.messagesGet().length, 1 );
      c6.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( _.strHas( err.message,'got more than one message' ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'not expected second error';
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
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c7.messagesGet().length, 1 );
      c7.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( _.strHas( err.message,'got more than one message' ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'consequence with argument';
    var c8 = t.shouldMessageOnlyOnce( _.Consequence().give( 'arg' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c8.messagesGet().length, 1 );
      c8.got( function( err,arg )
      {
        test.shouldBe( err === null );
        test.shouldBe( arg === 'arg' );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'consequence with error';
    var c9 = t.shouldMessageOnlyOnce( _.Consequence().error( 'error' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c9.messagesGet().length, 1 );
      c9.got( function( err,arg )
      {
        test.shouldBe( err === null );
        test.shouldBe( arg === 'error' );
      });
    });

    /* */

    return _.timeOut( 950 );
  }

  /* */

  var suit = wTestSuit({ tests : { r1 : r1 }, override : notTakingIntoAccount });
  var result = suit.run()
  .doThen( function( err,data )
  {

    counter.acheck = counter.testRoutine.checkCurrent();

    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck._checkIndex, 20 );
    test.identical( suit.report.testCheckPasses, 17 );
    test.identical( suit.report.testCheckFails, 2 );
    test.identical( counter.acheck._checkIndex,suit.report.testCheckPasses+suit.report.testCheckFails+1 );

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
    t.description = 'a';

    t.identical( 0,0 );
    test.description = 'does not throw error';
    var c1 = t.mustNotThrowError( function()
    {
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 2 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c1.messagesGet().length, 1 );
      c1.got( function( err,arg )
      {
        test.shouldBe( err === null );
        test.shouldBe( arg === undefined );
      });
    });

    /* */

    t.identical( 0,0 );
    test.description = 'does not throw error, string sync message';
    var c2 = t.mustNotThrowError( function()
    {
      return 'msg'
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 2 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c2.messagesGet().length, 1 );
      c2.got( function( err,arg )
      {
        test.shouldBe( err === null );
        test.shouldBe( arg === 'msg' );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'throw unexpected error, synchronously';
    var c3 = t.mustNotThrowError( function()
    {
      throw _.err( 'test' );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c3.messagesGet().length, 1 );
      c3.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'throw unexpected error, asynchronously';
    var c4 = t.mustNotThrowError( function()
    {
      return _.timeOut( 250,function()
      {
        throw _.err( 'test' );
      });
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c4.messagesGet().length, 1 );
      c4.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'single async message, no error';
    var c5 = t.mustNotThrowError( function()
    {
      return _.timeOut( 250 );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c5.messagesGet().length, 1 );
      c5.got( function( err,arg )
      {
        test.shouldBe( err === null );
        test.shouldBe( arg === _.timeOut );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'not expected second message';
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
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c6.messagesGet().length, 1 );
      c6.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( _.strHas( err.message,'got more than one message' ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'not expected second error';
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
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c7.messagesGet().length, 1 );
      c7.got( function( err,arg )
      {
        test.shouldBe( err === 'error1' );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'consequence with argument';
    var c8 = t.mustNotThrowError( _.Consequence().give( 'arg' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c8.messagesGet().length, 1 );
      c8.got( function( err,arg )
      {
        test.shouldBe( err === null );
        test.shouldBe( arg === 'arg' );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'consequence with error';
    var c9 = t.mustNotThrowError( _.Consequence().error( 'error' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c9.messagesGet().length, 1 );
      c9.got( function( err,arg )
      {
        test.shouldBe( err === 'error' );
        test.shouldBe( !arg );
      });
    });

    /* */

    return _.timeOut( 950 );
  }

  /* */

  var suit = wTestSuit({ tests : { r1 : r1 }, override : notTakingIntoAccount });
  var result = suit.run()
  .doThen( function( err,data )
  {

    counter.acheck = counter.testRoutine.checkCurrent();

    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck._checkIndex, 20 );
    test.identical( suit.report.testCheckPasses, 14 );
    test.identical( suit.report.testCheckFails, 5 );
    test.identical( counter.acheck._checkIndex,suit.report.testCheckPasses+suit.report.testCheckFails+1 );

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
    t.description = 'a';

    t.identical( 0,0 );
    test.description = 'simplest, does not throw error, but expected';
    var c1 = t.shouldThrowErrorSync( function()
    {
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c1.messagesGet().length, 1 );
      c1.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'expected synchronous error';
    var c2 = t.shouldThrowErrorSync( function()
    {
      throw _.err( 'test' );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 2 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c2.messagesGet().length, 1 );
      c2.got( function( err,arg )
      {
        test.shouldBe( err === null );
        test.shouldBe( _.errIs( arg ) );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'throw unexpected asynchronous error';
    var c3 = t.shouldThrowErrorSync( function()
    {
      return _.timeOut( 250,function()
      {
        throw _.err( 'test' );
      });
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c3.messagesGet().length, 1 );
      c3.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'single message, while synchronous error expected';
    var c4 = t.shouldThrowErrorSync( function()
    {
      return _.timeOut( 250 );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c4.messagesGet().length, 1 );
      c4.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'not expected second message';
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
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c5.messagesGet().length, 1 );
      c5.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'not expected second error';
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
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c6.messagesGet().length, 1 );
      c6.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'consequence with argument';
    var c7 = t.shouldThrowErrorSync( _.Consequence().give( 'arg' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c7.messagesGet().length, 1 );
      c7.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'consequence with error';
    var c8 = t.shouldThrowErrorSync( _.Consequence().error( 'error' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c8.messagesGet().length, 1 );
      c8.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    return _.timeOut( 950 );
  }

  var suit = wTestSuit({ tests : { r1 : r1 }, override : notTakingIntoAccount });

  var result = suit.run()
  .doThen( function( err,data )
  {

    counter.acheck = counter.testRoutine.checkCurrent();

    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck._checkIndex, 18 );
    test.identical( suit.report.testCheckPasses, 10 );
    test.identical( suit.report.testCheckFails, 7 );
    test.identical( counter.acheck._checkIndex,suit.report.testCheckPasses+suit.report.testCheckFails+1 );

    if( err )
    throw err;
  });

  return result;
}

//

function shouldThrowErrorAsync( test )
{

  var counter = new CheckCounter();

  test.shouldBe( test.logger.outputs.length > 0 );

  function r1( t )
  {

    counter.testRoutine = t;
    t.description = 'a';

    t.identical( 0,0 );
    test.description = 'simplest, does not throw error, but expected';
    var c1 = t.shouldThrowErrorAsync( function()
    {
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c1.messagesGet().length,1 );
      c1.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'throw unexpected synchronous error';
    var c2 = t.shouldThrowErrorAsync( function()
    {
      throw _.err( 'test' );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c2.messagesGet().length, 1 );
      c2.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'throw expected asynchronous error';
    var c3 = t.shouldThrowErrorAsync( function()
    {
      return _.timeOut( 250,function()
      {
        throw _.err( 'test' );
      });
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c3.messagesGet().length, 1 );
      c3.got( function( err,arg )
      {
        test.shouldBe( err === null );
        test.shouldBe( _.errIs( arg ) );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'single message while asynchronous error expected';
    var c4 = t.shouldThrowErrorAsync( function()
    {
      return _.timeOut( 250 );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 ); /* delayed */
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c4.messagesGet().length, 1 );
      c4.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'expected async string error';
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
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c5.messagesGet().length, 1 );
      c5.got( function( err,arg )
      {
        test.shouldBe( err === null );
        test.shouldBe( arg === 'error' );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'not expected second message';
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
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 ); /* delayed */
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c6.messagesGet().length, 1 );
      c6.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'not expected second error';
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
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 ); /* delayed */
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c7.messagesGet().length, 1 );
      c7.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( _.strHas( err.message,'got more than one message' ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'consequence with argument';
    var c8 = t.shouldThrowErrorAsync( _.Consequence().give( 'arg' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c8.messagesGet().length, 1 );
      c8.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'consequence with error';
    var c9 = t.shouldThrowErrorAsync( _.Consequence().error( 'error' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c9.messagesGet().length, 1 );
      c9.got( function( err,arg )
      {
        test.shouldBe( err === null );
        test.shouldBe( arg === 'error' );
      });
    });

    /* */

    return _.timeOut( 950 );
  }

  /* */

  var suit = wTestSuit({ tests : { r1 : r1 }, override : notTakingIntoAccount });
  var result = suit.run()
  .doThen( function( err,data )
  {

    counter.acheck = counter.testRoutine.checkCurrent();

    test.shouldBe( test.logger.outputs.length > 0 );
    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck._checkIndex, 20 );
    test.identical( suit.report.testCheckPasses, 13 );
    test.identical( suit.report.testCheckFails, 6 );
    test.identical( counter.acheck._checkIndex,suit.report.testCheckPasses+suit.report.testCheckFails+1 );

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
    t.description = 'a';

    t.identical( 0,0 );
    test.description = 'does not throw error, but expected';
    var c1 = t.shouldThrowError( function()
    {
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c1.messagesGet().length, 1 );
      c1.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'throw expected synchronous error';
    var c2 = t.shouldThrowError( function()
    {
      throw _.err( 'err1' );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 2 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c2.messagesGet().length, 1 );
      c2.got( function( err,arg )
      {
        test.shouldBe( err === null );
        test.shouldBe( _.errIs( arg ) );
        test.shouldBe( _.strHas( arg.messge,'err1' ) );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'throw expected asynchronous error';
    var c3 = t.shouldThrowError( function()
    {
      return _.timeOut( 250,function()
      {
        throw _.err( 'err1' );
      });
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c3.messagesGet().length, 1 );
      c3.got( function( err,arg )
      {
        test.shouldBe( err === null );
        test.shouldBe( _.errIs( arg ) );
        test.shouldBe( _.strHas( arg.messge,'err1' ) );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'single message, but error expected';
    var c4 = t.shouldThrowError( function()
    {
      return _.timeOut( 250 );
    });

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c4.messagesGet().length, 1 );
      c4.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'not expected second message';
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
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 ); /* delayed */
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c5.messagesGet().length, 1 );
      c5.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'not expected second error';
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
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 ); /* delayed */
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c6.messagesGet().length, 1 );
      c6.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( _.strHas( err.message,'got more than one message' ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'consequence with argument';
    var c8 = t.shouldThrowError( _.Consequence().give( 'arg' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 1 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c8.messagesGet().length, 1 );
      c8.got( function( err,arg )
      {
        test.shouldBe( _.errIs( err ) );
        test.shouldBe( !arg );
      });
    });

    /* */

    t.identical( 0,0 );

    test.description = 'consequence with error';
    var c9 = t.shouldThrowError( _.Consequence().error( 'error' ) );

    counter.acheck = t.checkCurrent();
    test.identical( counter.acheck.description, 'a' );
    test.identical( counter.acheck._checkIndex-counter.prevCheckIndex, 2 );
    test.identical( t.suit.report.testCheckPasses-counter.prevCheckPasses, 1 );
    test.identical( t.suit.report.testCheckFails-counter.prevCheckFails, 0 );
    counter.next();

    _.timeOut( 500,function()
    {
      test.identical( c9.messagesGet().length, 1 );
      c9.got( function( err,arg )
      {
        test.shouldBe( err === null );
        test.shouldBe( arg === 'error' );
      });
    });

    /* */

    return _.timeOut( 950 );
  }

  var suit = wTestSuit({ tests : { r1 : r1 }, override : notTakingIntoAccount });

  var result = suit.run()
  .doThen( function( err,data )
  {

    counter.acheck = counter.testRoutine.checkCurrent();
    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck._checkIndex, 18 );
    test.identical( suit.report.testCheckPasses, 12 );
    test.identical( suit.report.testCheckFails, 5 );
    test.identical( counter.acheck._checkIndex,suit.report.testCheckPasses+suit.report.testCheckFails+1 );

    if( err )
    throw err;
  });

  return result;
}

//

function shouldPassMessage( test )
{
  var counter = new CheckCounter();

  test.description = 'mustNotThrowError must return con with message';

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

  test.description = 'mustNotThrowError must return con original error';

  var errOriginal = _.err( 'Err' );
  var con = new _.Consequence().error( errOriginal );
  test.shouldThrowError( con )
  .doThen( function( err,arg )
  {
    test.identical( err,null );
    test.identical( arg,errOriginal );
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

  t.description = 'a';

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
    console.log( 'checkIndex',acheck._checkIndex, 13 );
    console.log( 'testCheckPasses',test.suit.report.testCheckPasses, 8 );
    console.log( 'testCheckFails',test.suit.report.testCheckFails, 4 );

  });

  /* */

  test.description = 'simplest, does not throw error,  but expected';
  test.shouldThrowErrorAsync( function()
  {
  });

  /* */

  test.description = 'single message';
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

  test.description = 'if passes dont appears in output/passed test checks/total counter';
  test.mustNotThrowError( function()
  {
  });

  test.identical( 0,0 );

  test.description = 'if not passes then appears in output/total counter';
  test.mustNotThrowError( function()
  {
    return _.timeOut( 1000,function()
    {
      throw _.err( 'test' );
    });
    // throw _.err( 'test' );
  });

  test.identical( 0,0 );

  test.description = 'not expected second message';
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

function shouldThrowErrorSimpleSync( test )
{

  test.identical( test._inroutineCon.messagesGet().length,1 );

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

function shouldThrowErrorSimpleAsync( test )
{
  var consequence = new _.Consequence().give();
  var counter = new CheckCounter();

  counter.testRoutine = test;
  counter.next();

  test.identical( test._inroutineCon.messagesGet().length,1 );

  consequence
  .doThen( function()
  {
    test.description = 'a';
    var con = _.timeOut( 50,function( err )
    {
      throw _.err( 'async error' );
    });
    return test.shouldThrowErrorAsync( con );
  })
  .doThen( function()
  {
    test.description = 'b';
    var con = _.timeOut( 50,function( err )
    {
      throw _.err( 'async error' );
    });
    return test.shouldThrowErrorAsync( con );
  })
  .doThen( function()
  {
    var acheck = test.checkCurrent();

    test.identical( test.report.testCheckPasses-counter.prevCheckPasses, 3 );
    test.identical( test.report.testCheckFails-counter.prevCheckFails, 0 );

    test.identical( acheck.description, 'b' );
    test.identical( acheck._checkIndex, 4 );

    test.identical( test._inroutineCon.messagesGet().length,0 );

  })
  ;

  return consequence;
}

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
    test.identical( counter.acheck._checkIndex, 1 );
    test.identical( suit.report.testCheckPasses, 0 );
    test.identical( suit.report.testCheckFails, 0 );

    return new _.Consequence().give()
    .doThen( function()
    {

      test.description = prefix + 'beginning of the test routine';
      counter.acheck = counter.testRoutine.checkCurrent();
      test.identical( counter.acheck._checkIndex, 1 );
      test.identical( t.suit.report.testCheckPasses, 0 );
      test.identical( t.suit.report.testCheckFails, 0 );

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
      counter.acheck = counter.testRoutine.checkCurrent();
      test.identical( counter.acheck._checkIndex, 2 );
      test.identical( t.suit.report.testCheckPasses, 1 );
      test.identical( t.suit.report.testCheckFails, 0 );

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
      counter.acheck = counter.testRoutine.checkCurrent();
      test.identical( counter.acheck._checkIndex, 3 );
      test.identical( t.suit.report.testCheckPasses, 2 );
      test.identical( t.suit.report.testCheckFails, 0 );

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

        test.identical( t.suit.report.testCheckPasses, o.lowerCount ? 4 : 5 );
        test.identical( t.suit.report.testCheckFails, 0 );

        if( o.throwingError === 'sync' )
        t[ method ]( function(){ throw _.err( 'sync error' ) } );

        counter.acheck = counter.testRoutine.checkCurrent();
        test.identical( counter.acheck._checkIndex, o.lowerCount ? 3 : 4 );

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

    function first()
    {

      var result = _.timeOut( 50,function()
      {

        test.description = prefix + 'first timeout of the included test routine ';

        test.identical( t.suit.report.testCheckPasses, 3 );
        test.identical( t.suit.report.testCheckFails, 0 );

        if( o.throwingError === 'sync' )
        t[ method ]( function(){ throw _.err( 'sync error' ); } );

        counter.acheck = counter.testRoutine.checkCurrent();
        test.identical( counter.acheck._checkIndex, 2 );

        if( o.throwingError === 'sync' )
        {
          // t.identical( 1,1 );
          return second();
        }
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

  var suit = wTestSuit
  ({
    tests : { row : row, include : include },
    override : notTakingIntoAccount,
    name : _.diagnosticLocation().name + '.' + method + '.' + o.throwingError,
  });

  if( suit.on )
  suit.on( 'routineEnd',function( e )
  {

    // console.log( 'routineEnd',e.testRoutine.routine.name );

    if( e.testRoutine.routine.name === 'row' )
    {
      test.description = 'checking outcomes';
      counter.acheck = counter.testRoutine.checkCurrent();
      test.identical( counter.acheck._checkIndex, 4 );
      test.identical( suit.report.testCheckPasses, 3 );
      test.identical( suit.report.testCheckFails, 0 );
    }

  });

  /* */

  return suit.run()
  .doThen( function( err,data )
  {

    test.description = 'checking outcomes';

    counter.acheck = counter.testRoutine.checkCurrent();
    test.identical( counter.acheck._checkIndex, 5 ); /* 4 */
    test.identical( suit.report.testCheckPasses, 7 ); /* 6 */
    test.identical( suit.report.testCheckFails, 0 );

    if( err )
    throw err;
  });

}

_chainedShould.experimental = 1;

//

function chainedShould( test )
{
  var con = _.Consequence().give();

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
      lowerCount : 1,
    },

    {
      method : 'shouldThrowErrorSync',
      throwingError : 'sync',
      lowerCount : 1,
    },

    {
      method : 'shouldThrowErrorAsync',
      throwingError : 'async',
      lowerCount : 1,
    },

    {
      method : 'mustNotThrowError',
      throwingError : 0,
      lowerCount : 1,
    },

    {
      method : 'shouldMessageOnlyOnce',
      throwingError : 0,
      lowerCount : 1,
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

//

function mustNotThrowErrorExperiment( test )
{

  test.description = 'mustNotThrowError experiment';

  debugger;
  var con = test.mustNotThrowError( function()
  {
    debugger;
    xxx
    console.log( 'x' );
    return _.timeOut( 500 );
  });
  debugger;

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

//

function timeOut( test )
{
  var delay = 300;
  var testCon = new _.Consequence().give()

  /* */

  .doThen( function()
  {
    if( !Config.debug )
    return;

    test.description = 'delay must be number';
    test.shouldThrowError( () => _.timeOut( 'x' ) )

    test.description = 'if two arguments provided, second must consequence/routine';
    test.shouldThrowError( () => _.timeOut( 0, 'x' ) )

    test.description = 'if four arguments provided, third must routine';
    test.shouldThrowError( () => _.timeOut( 0, {}, 'x', [] ) )
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay only';
    var timeBefore = _.timeNow();
    return _.timeOut( delay )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.shouldBe( _.routineIs( got ) );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + routine';
    var timeBefore = _.timeNow();
    return _.timeOut( delay, () => {} )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.identical( got, undefined );
      test.identical( err, null );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    return _.timeOut( delay, () => value )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.identical( got, value );
      test.identical( err, null );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    return _.timeOut( delay, () => _.timeOut( delay ) )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay * 2 );
      test.shouldBe( _.routineIs( got ) );
      test.identical( err, null );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    return _.timeOut( delay, () => { _.timeOut( delay ) } )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.identical( err, null );
      test.identical( got, undefined );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay / 2;
    }
    return _.timeOut( delay, undefined, r, [ delay ] )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.identical( got, delay / 2 );
      test.identical( err, null );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + consequence';
    var timeBefore = _.timeNow();

    return _.timeOut( delay, _.timeOut( delay * 2 ) )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay * 2 );
      test.shouldBe( _.routineIs( got ) );
      test.identical( err, null );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + consequence that returns value';
    var timeBefore = _.timeNow();
    var val = 0;

    return _.timeOut( delay, _.timeOut( delay * 2, () => val ) )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay * 2 );
      test.identical( err, null );
      test.identical( got, val );
    })
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + consequence + error';
    var timeBefore = _.timeNow();

    return _.timeOut( delay, _.timeOut( delay * 2, () => { throw 'err' } ) )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay * 2 );
      test.shouldBe( _.errIs( err ) );
      test.identical( got, undefined );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'stop timer with error';
    var timeBefore = _.timeNow();

    var t = _.timeOut( delay );
    t.doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
      test.identical( err, null );
      test.identical( got, 'stop' )
    })
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );

    return t;
  })

  /* */

  .doThen( function()
  {
    test.description = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOut( delay, () => { called = true } );
    t.doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
      test.identical( got, 'stop' );
      test.identical( called, false );
      test.identical( err, null )
    })
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );

    return t;
  })

  /* */

  .doThen( function()
  {
    test.description = 'give err after timeOut';
    var timeBefore = _.timeNow();

    var t = _.timeOut( delay, () => {} );
    t.got( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.identical( got, undefined );
      test.identical( err, null );
    })

    return _.timeOut( delay + 50, function()
    {
      t.error( 'stop' );
      t.got( ( err, got ) => test.identical( err, 'stop' ) );
    })

    return t;
  })

  /* */

  .doThen( function()
  {
    test.description = 'give msg before timeOut';
    var timeBefore = _.timeNow();
    var returnValue = 1;
    var msg = 2;

    var t = _.timeOut( delay, () => returnValue );

    return _.timeOut( delay / 2, function()
    {
      t.give( msg );
      t.got( ( err, got ) => test.identical( got, msg ) );
      t.got( ( err, got ) =>
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.identical( got, returnValue );
      })
    })

    return t;
  })

  /* */

  .doThen( function()
  {
    test.description = 'stop timer with error + arg, routine passed';
    var timeBefore = _.timeNow();
    var called = false;
    var stop = 'stop';
    var arg = 'arg';

    var t = _.timeOut( delay, () => { called = true } );
    t.doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
      test.identical( got, [ stop, arg ] );
      test.identical( called, false );
      test.identical( err, null )
    })
    _.timeOut( delay/ 2, () => t.give( stop, arg ) );

    return t;
  })

  return testCon;
}

timeOut.timeOut = 30000;

// --
// proto
// --

var Self =
{

  name : 'wTesting / general tests',
  // verbosity : 9,
  silencing : 1,

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

    shouldThrowErrorSimpleSync : shouldThrowErrorSimpleSync,
    shouldThrowErrorSimpleAsync : shouldThrowErrorSimpleAsync,

    _chainedShould : _chainedShould,
    chainedShould : chainedShould,

    // etc

    asyncExperiment : asyncExperiment,
    failExperiment : failExperiment,
    mustNotThrowErrorExperiment : mustNotThrowErrorExperiment,
    timeOut : timeOut,

  },

}

Self = wTestSuit( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();
