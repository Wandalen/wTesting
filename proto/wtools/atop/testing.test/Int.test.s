( function _Int_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../wtools/Tools.s' );

  if( typeof _realGlobal_ === 'undefined' || !_realGlobal_.wTester || !_realGlobal_.wTester._isReal_ )
  require( '../testing/entry/Main.s' );

  _.include( 'wLogger' );
  _.include( 'wConsequence' );
  _.include( 'wProcedure' );
  _.include( 'wProcess' );
  _.include( 'wFiles' );

}

let _global = _global_;
let _ = _global_.wTools;

/* qqq for Dmytro : parametrize all delays */
/* qqq for Dmytro : ( err, got ) -> ( err, arg ) */

// --
// tools
// --

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

function onSuiteBegin()
{
}

//

function onSuiteEnd()
{
}

// --
// etc
// --

function trivial( test )
{

  test.identical( 0, 0 );

  test.identical( test.suite.report.testCheckPasses, 1 );
  test.identical( test.suite.report.testCheckFails, 0 );

}

// --
// compare
// --

function identical( test )
{
  var testRoutine;

  test.identical( 0, 0 );

  function r1( t )
  {

    testRoutine = t;

    t.identical( 0, 0 );
    test.identical( t.suite.report.testCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails, 0 );

    t.identical( 0, false );
    test.identical( t.suite.report.testCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails, 1 );

    t.identical( 0, 1 );
    test.identical( t.suite.report.testCheckPasses, 1 );
    test.identical( t.suite.report.testCheckFails, 2 );

  }

  var suite = wTestSuite
  ({
    tests : { r1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run()
  .finally( function( err, data )
  {

    var acheck = testRoutine.checkCurrent();
    test.identical( acheck.checkIndex, 4 );
    test.identical( suite.report.testCheckPasses, 1 );
    test.identical( suite.report.testCheckFails, 2 );

    if( err )
    throw err;

    return null;
  });

  test.identical( undefined, undefined );
  test.equivalent( undefined, undefined );

  return result;
}
//

function identicalConsequence( test )
{
  var testRoutine;

  var suite = wTestSuite
  ({
    tests : { r1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run()
  .finally( function( err, data )
  {
    var acheck = testRoutine.checkCurrent();
    test.identical( acheck.checkIndex, 2 );
    test.identical( suite.report.errorsArray.length, 0 );
    test.identical( suite.report.testCheckPasses, 0 );
    test.identical( suite.report.testCheckFails, 1 );

    if( err )
    throw err;
    return null;
  });

  return result;

  function r1( t )
  {
    testRoutine = t;

    let con = _.Consequence().take( null );
    t.identical( con, null );

    return null;
  }

}

// --
// should
// --

/* aaa for Dmytro : split test cases of returnsSingleResource by ready.then */ /* Dmytro : done */
/* aaa for Dmytro : fix please test check test.returnsSingleResource() */ /* Dmytro : it is clarified during the call, the task is done */

function returnsSingleResource( test )
{
  let context = this;
  var counter = new CheckCounter();

  function r1( t )
  {

    let ready = new _.Consequence().take( null );

    counter.testRoutine = t;
    t.description = 'a';

    /* */

    ready.then( () =>
    {
      test.case = 'does does not throw error';

      t.identical( 0, 0 );
      var c1 = t.returnsSingleResource( () => {} );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t1 * 8, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c1.resourcesGet().length, 1 );

        c1.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( arg === null );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'does not throw error, string sync message';

      t.identical( 0, 0 );
      var c2 = t.returnsSingleResource( () => 'msg' );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t1 * 8, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c2.resourcesGet().length, 1 );
        c2.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( arg === 'msg' );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw unexpected error, synchronously';

      t.identical( 0, 0 );
      var c3 = t.returnsSingleResource( () => { throw _.errAttend( 'error1' ) });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t1 * 8, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c3.resourcesGet().length, 1 );

        c3.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.errIs( arg ) );
          test.true( _.strHas( arg.message, 'error1' ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw unexpected error, asynchronously';

      t.identical( 0, 0 );
      var c4 = t.returnsSingleResource( () =>
      {
        return _.time.out( context.t1, () =>
        {
          throw _.errAttend( 'error1' );
        });
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t1 * 8, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c4.argumentsCount(), 1 );
        test.identical( c4.errorsCount(), 0 );
        test.identical( c4.competitorsCount(), 0 );

        c4.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.errIs( arg ) );
          test.true( _.strHas( arg.message, 'error1' ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'single async message, no error';

      t.identical( 0, 0 );
      var c5 = t.returnsSingleResource( () => _.time.out( context.t1 ) );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t1 * 8, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c5.argumentsCount(), 1 );
        test.identical( c5.errorsCount(), 0 );
        test.identical( c5.competitorsCount(), 0 );

        c5.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.timerIs( arg ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second message';

      t.identical( 0, 0 );
      var c6 = t.returnsSingleResource( () =>
      {
        var con = _.Consequence();

        _.time.out( context.t1, () =>
        {
          con.take( 'msg1' );
          con.take( 'msg2' );
          return null;
        });

        return con;
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t1 * 8, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( c6.resourcesGet().length, 1 );
        c6.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( _.strHas( err.message, 'Got more than one message' ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second error';

      t.identical( 0, 0 );
      var c7 = t.returnsSingleResource( () =>
      {
        var con = _.Consequence();

        _.time.out( context.t1, () =>
        {
          con.error( _.errAttend( 'error1' ) );
          con.error( _.errAttend( 'error2' ) );
          return null;
        });

        return con;
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t1 * 8, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( c7.resourcesGet().length, 1 );

        c7.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( _.strHas( err.message, 'Got more than one message' ) );
          test.true( !arg );
        });
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with argument';

      t.identical( 0, 0 );
      var c8 = t.returnsSingleResource( _.Consequence().take( 'arg' ) );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t1 * 8, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c8.resourcesGet().length, 1 );

        c8.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( arg === 'arg' );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with error';

      t.identical( 0, 0 );
      var c9 = t.returnsSingleResource( _.Consequence().error( _.errAttend( 'error1' ) ) );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t1 * 8, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c9.resourcesGet().length, 1 );
        c9.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.errIs( arg ) );
          test.true( _.strHas( arg.message, 'error1' ) );
        });
        return null;
      });
    });

    /* - */

    return ready;
  }
  r1.timeOut = 15000;

  /* */

  var suite = wTestSuite
  ({
    name : 'Suite::ShouldMessageOnlyOnce',
    tests : { r1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite
  .run()
  .finally( ( err, arg ) =>
  {

    counter.acheck = counter.testRoutine.checkCurrent();
    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck.checkIndex, 19 );
    test.identical( suite.report.testCheckPasses, 16 );
    test.identical( suite.report.testCheckFails, 2 );
    test.identical( counter.acheck.checkIndex, suite.report.testCheckPasses + suite.report.testCheckFails + 1 );

    if( err )
    throw err;
    return null;
  });

  return result;
}

returnsSingleResource.timeOut = 30000;

//

function returnsSingleResource_( test )
{
  let context = this;
  var counter = new CheckCounter();

  function r1( t )
  {

    let ready = new _.Consequence().take( null );

    counter.testRoutine = t;
    t.description = 'a';

    /* */

    ready.then( () =>
    {
      test.case = 'does does not throw error';

      t.identical( 0, 0 );
      var c1 = t.returnsSingleResource_( () => {} );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t1 * 8, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c1.resourcesGet().length, 1 );

        c1.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( arg === null );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'does not throw error, string sync message';

      t.identical( 0, 0 );
      var c2 = t.returnsSingleResource_( () => 'msg' );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t1 * 8, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c2.resourcesGet().length, 1 );
        c2.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( arg === 'msg' );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw unexpected error, synchronously';

      t.identical( 0, 0 );
      var c3 = t.returnsSingleResource_( () => { throw _.errAttend( 'error1' ) });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t1 * 8, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c3.resourcesGet().length, 1 );

        c3.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.errIs( arg ) );
          test.true( _.strHas( arg.message, 'error1' ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw unexpected error, asynchronously';

      t.identical( 0, 0 );
      var c4 = t.returnsSingleResource_( () =>
      {
        return _.time.out( context.t1, () =>
        {
          throw _.errAttend( 'error1' );
        });
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t1 * 8, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c4.argumentsCount(), 1 );
        test.identical( c4.errorsCount(), 0 );
        test.identical( c4.competitorsCount(), 0 );

        c4.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.errIs( arg ) );
          test.true( _.strHas( arg.message, 'error1' ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'single async message, no error';

      t.identical( 0, 0 );
      var c5 = t.returnsSingleResource_( () => _.time.out( context.t1 ) );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t1 * 8, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c5.argumentsCount(), 1 );
        test.identical( c5.errorsCount(), 0 );
        test.identical( c5.competitorsCount(), 0 );

        c5.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.timerIs( arg ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second message';

      t.identical( 0, 0 );
      var c6 = t.returnsSingleResource_( () =>
      {
        var con = _.Consequence();

        _.time.out( context.t1, () =>
        {
          con.take( 'msg1' );
          con.take( 'msg2' );
          return null;
        });

        return con;
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t1 * 8, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( c6.resourcesGet().length, 1 );
        c6.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( _.strHas( err.message, 'Got more than one message' ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second error';

      t.identical( 0, 0 );
      var c7 = t.returnsSingleResource_( () =>
      {
        var con = _.Consequence();

        _.time.out( context.t1, () =>
        {
          con.error( _.errAttend( 'error1' ) );
          con.error( _.errAttend( 'error2' ) );
          return null;
        });

        return con;
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t1 * 8, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( c7.resourcesGet().length, 1 );

        c7.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( _.strHas( err.message, 'Got more than one message' ) );
          test.true( !arg );
        });
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with argument';

      t.identical( 0, 0 );
      var c8 = t.returnsSingleResource_( _.Consequence().take( 'arg' ) );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t1 * 8, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c8.resourcesGet().length, 1 );

        c8.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( arg === 'arg' );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with error';

      t.identical( 0, 0 );
      var c9 = t.returnsSingleResource_( _.Consequence().error( _.errAttend( 'error1' ) ) );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t1 * 8, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c9.resourcesGet().length, 1 );
        c9.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.errIs( arg ) );
          test.true( _.strHas( arg.message, 'error1' ) );
        });
        return null;
      });
    });

    /* - */

    return ready;
  }
  r1.timeOut = 15000;

  /* */

  var suite = wTestSuite
  ({
    name : 'Suite::ShouldMessageOnlyOnce_',
    tests : { r1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite
  .run()
  .finally( ( err, arg ) =>
  {

    counter.acheck = counter.testRoutine.checkCurrent();
    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck.checkIndex, 19 );
    test.identical( suite.report.testCheckPasses, 16 );
    test.identical( suite.report.testCheckFails, 2 );
    test.identical( counter.acheck.checkIndex, suite.report.testCheckPasses + suite.report.testCheckFails + 1 );

    if( err )
    throw err;
    return null;
  });

  return result;
}

returnsSingleResource_.timeOut = 30000;

//

function mustNotThrowError( test )
{
  let context = this;
  var counter = new CheckCounter();

  function r1( t )
  {

    let ready = new _.Consequence().take( null );
    counter.testRoutine = t;
    t.description = 'a';

    ready.then( () =>
    {
      test.case = 'does not throw error';

      t.identical( 0, 0 );
      var c1 = t.mustNotThrowError( () => {});

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c1.resourcesGet().length, 1 );

        c1.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( arg === null );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'does not throw error, string sync message';

      t.identical( 0, 0 );
      var c2 = t.mustNotThrowError( () => 'msg' );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c2.resourcesGet().length, 1 );

        c2.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( arg === 'msg' );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw unexpected error, synchronously';

      t.identical( 0, 0 );
      var c3 = t.mustNotThrowError( () => { throw _.err( 'test' ) } );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c3.resourcesGet().length, 1 );

        c3.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw unexpected error, asynchronously';

      t.identical( 0, 0 );
      var c4 = t.mustNotThrowError( () =>
      {
        return _.time.out( context.t1, () =>
        {
          throw _.err( 'test' );
        });
        return null;
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( c4.resourcesGet().length, 1 );

        c4.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'single async message, no error';

      t.identical( 0, 0 );
      var c5 = t.mustNotThrowError( () => _.time.out( context.t1 ) );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c5.resourcesGet().length, 1 );

        c5.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.timerIs( arg ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second message';

      t.identical( 0, 0 );
      var c6 = t.mustNotThrowError( () =>
      {
        var con = _.Consequence({ capacity : 2 });

        _.time.out( context.t1, () =>
        {
          con.take( 'msg1' );
          con.take( 'msg2' );
          return null;
        });

        return con;
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( c6.resourcesGet().length, 1 );

        c6.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( _.strHas( err.message, 'Got more than one message' ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second error';

      t.identical( 0, 0 );
      var c7 = t.mustNotThrowError( () =>
      {
        var con = _.Consequence({ capacity : 2 });

        _.time.out( context.t1, () =>
        {
          con.error( _.errAttend( 'error1' ) );
          con.error( _.errAttend( 'error2' ) );
          return null;
        });

        return con;
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( c7.resourcesGet().length, 1 );

        c7.give( ( err, arg ) =>
        {
          test.true( _.strHas( _.err( err ).message, 'error1' ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with argument';

      t.identical( 0, 0 );
      var c8 = t.mustNotThrowError( _.Consequence().take( 'arg' ) );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c8.resourcesGet().length, 1 );

        c8.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( arg === 'arg' );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with error';

      t.identical( 0, 0 );
      var c9 = t.mustNotThrowError( _.Consequence({ tag : 'strange' }).error( 'error1' ) );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c9.resourcesGet().length, 1 );

        c9.give( ( err, arg ) =>
        {
          test.true( _.strHas( _.err( err ).message, 'error1' ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    return ready;
  }

  /* */

  var suite = wTestSuite
  ({
    tests : { r1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run()
  .finally( function( err, data )
  {
    counter.acheck = counter.testRoutine.checkCurrent();
    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck.checkIndex, 19 );
    test.identical( suite.report.testCheckPasses, 13 );
    test.identical( suite.report.testCheckFails, 5 );
    test.identical( counter.acheck.checkIndex, suite.report.testCheckPasses+suite.report.testCheckFails+1 );

    if( err )
    throw err;

    return null;
  });

  return result;
}

mustNotThrowError.timeOut = 30000;

//

function mustNotThrowErrorWithCallback( test )
{
  let context = this;
  var counter = new CheckCounter();

  function r1( t )
  {

    let ready = new _.Consequence().take( null );
    counter.testRoutine = t;
    t.description = 'a';

    ready.then( () =>
    {
      test.case = 'does not throw error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c1 = t.mustNotThrowError( () => {}, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack, [ undefined, true ] );

        test.identical( c1.resourcesGet().length, 1 );
        c1.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( arg === null );
        });
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'does not throw error, string sync message';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c2 = t.mustNotThrowError( () => 'msg', onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack, [ 'msg', true ] );

        test.identical( c2.resourcesGet().length, 1 );
        c2.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( arg === 'msg' );
        });
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'throw unexpected error, synchronously';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c3 = t.mustNotThrowError( () => { throw _.err( 'test' ) }, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.strHas( errStack[ 0 ], 'test' ) );
        test.identical( errStack[ 1 ], false );

        test.identical( c3.resourcesGet().length, 1 );
        c3.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'throw unexpected error, asynchronously';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c4 = t.mustNotThrowError( () =>
      {
        return _.time.out( context.t1, () =>
        {
          throw _.err( 'test' );
        });
        return null;
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.strHas( errStack[ 0 ], 'test' ) );
        test.identical( errStack[ 1 ], false );

        test.identical( c4.resourcesGet().length, 1 );
        c4.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'single async message, no error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c5 = t.mustNotThrowError( () => { return _.time.out( context.t1 ) }, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.consequenceIs( errStack[ 0 ] ) );
        test.identical( errStack[ 1 ], true );

        test.identical( c5.resourcesGet().length, 1 );
        c5.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.timerIs( arg ) );
        });
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second message';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c6 = t.mustNotThrowError( () =>
      {
        var con = _.Consequence({ capacity : 2 });

        _.time.out( context.t1, () =>
        {
          con.take( 'msg1' );
          con.take( 'msg2' );
          return null;
        });

        return con;
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.consequenceIs( errStack[ 0 ] ) );
        test.identical( errStack[ 1 ], true );

        test.identical( c6.resourcesGet().length, 1 );
        c6.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( _.strHas( err.message, 'Got more than one message' ) );
          test.true( !arg );
        });
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c7 = t.mustNotThrowError( () =>
      {
        var con = _.Consequence({ capacity : 2 });

        _.time.out( context.t1, () =>
        {
          con.error( _.errAttend( 'error1' ) );
          con.error( _.errAttend( 'error2' ) );
          return null;
        });

        return con;
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.strHas( errStack[ 0 ], 'error1' ) );
        test.identical( errStack[ 1 ], false );

        test.identical( c7.resourcesGet().length, 1 );
        c7.give( ( err, arg ) =>
        {
          test.true( _.strHas( _.err( err ).message, 'error1' ) );
          test.true( !arg );
        });
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with argument';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c8 = t.mustNotThrowError( _.Consequence().take( 'arg' ), onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.consequenceIs( errStack[ 0 ] ) );
        test.identical( errStack[ 1 ], true );

        test.identical( c8.resourcesGet().length, 1 );
        c8.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( arg === 'arg' );
        });
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c9 = t.mustNotThrowError( _.Consequence({ tag : 'strange' }).error( 'error1' ), onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );

      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.strHas( errStack[ 0 ], 'error1' ) );
        test.identical( errStack[ 1 ], false );

        test.identical( c9.resourcesGet().length, 1 );
        c9.give( ( err, arg ) =>
        {
          test.true( _.strHas( _.err( err ).message, 'error1' ) );
          test.true( !arg );
        });
        return null;
      });
    })

    /* */

    return ready;
  }

  /* */

  var suite = wTestSuite
  ({
    tests : { r1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run()
  .finally( ( err, data ) =>
  {
    counter.acheck = counter.testRoutine.checkCurrent();
    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck.checkIndex, 19 );
    test.identical( suite.report.testCheckPasses, 13 );
    test.identical( suite.report.testCheckFails, 5 );
    test.identical( counter.acheck.checkIndex, suite.report.testCheckPasses+suite.report.testCheckFails+1 );

    if( err )
    throw err;

    return null;
  });

  return result;
}

mustNotThrowErrorWithCallback.timeOut = 10000;

//

function mustNotThrowError_WithCallback( test )
{
  let context = this;
  var counter = new CheckCounter();

  function r1( t )
  {

    let ready = new _.Consequence().take( null );
    counter.testRoutine = t;
    t.description = 'a';

    ready.then( () =>
    {
      test.case = 'does not throw error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c1 = t.mustNotThrowError_( () => {}, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack, [ undefined, true ] );

        test.identical( c1.resourcesGet().length, 1 );
        c1.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( arg === null );
        });
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'does not throw error, string sync message';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c2 = t.mustNotThrowError_( () => 'msg', onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack, [ 'msg', true ] );

        test.identical( c2.resourcesGet().length, 1 );
        c2.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( arg === 'msg' );
        });
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'throw unexpected error, synchronously';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c3 = t.mustNotThrowError_( () => { throw _.err( 'test' ) }, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.strHas( errStack[ 0 ], 'test' ) );
        test.identical( errStack[ 1 ], false );

        test.identical( c3.resourcesGet().length, 1 );
        c3.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'throw unexpected error, asynchronously';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c4 = t.mustNotThrowError_( () =>
      {
        return _.time.out( context.t1, () =>
        {
          throw _.err( 'test' );
        });
        return null;
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.strHas( errStack[ 0 ], 'test' ) );
        test.identical( errStack[ 1 ], false );

        test.identical( c4.resourcesGet().length, 1 );
        c4.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'single async message, no error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c5 = t.mustNotThrowError_( () => { return _.time.out( context.t1 ) }, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.consequenceIs( errStack[ 0 ] ) );
        test.identical( errStack[ 1 ], true );

        test.identical( c5.resourcesGet().length, 1 );
        c5.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.timerIs( arg ) );
        });
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second message';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c6 = t.mustNotThrowError_( () =>
      {
        var con = _.Consequence({ capacity : 2 });

        _.time.out( context.t1, () =>
        {
          con.take( 'msg1' );
          con.take( 'msg2' );
          return null;
        });

        return con;
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.consequenceIs( errStack[ 0 ] ) );
        test.identical( errStack[ 1 ], true );

        test.identical( c6.resourcesGet().length, 1 );
        c6.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( _.strHas( err.message, 'Got more than one message' ) );
          test.true( !arg );
        });
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c7 = t.mustNotThrowError_( () =>
      {
        var con = _.Consequence({ capacity : 2 });

        _.time.out( context.t1, () =>
        {
          con.error( _.errAttend( 'error1' ) );
          con.error( _.errAttend( 'error2' ) );
          return null;
        });

        return con;
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.strHas( errStack[ 0 ], 'error1' ) );
        test.identical( errStack[ 1 ], false );

        test.identical( c7.resourcesGet().length, 1 );
        c7.give( ( err, arg ) =>
        {
          test.true( _.strHas( _.err( err ).message, 'error1' ) );
          test.true( !arg );
        });
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with argument';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c8 = t.mustNotThrowError_( _.Consequence().take( 'arg' ), onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.consequenceIs( errStack[ 0 ] ) );
        test.identical( errStack[ 1 ], true );

        test.identical( c8.resourcesGet().length, 1 );
        c8.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( arg === 'arg' );
        });
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c9 = t.mustNotThrowError_( _.Consequence({ tag : 'strange' }).error( 'error1' ), onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );

      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.strHas( errStack[ 0 ], 'error1' ) );
        test.identical( errStack[ 1 ], false );

        test.identical( c9.resourcesGet().length, 1 );
        c9.give( ( err, arg ) =>
        {
          test.true( _.strHas( _.err( err ).message, 'error1' ) );
          test.true( !arg );
        });
        return null;
      });
    })

    /* */

    return ready;
  }

  /* */

  var suite = wTestSuite
  ({
    tests : { r1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run()
  .finally( ( err, data ) =>
  {
    counter.acheck = counter.testRoutine.checkCurrent();
    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck.checkIndex, 19 );
    test.identical( suite.report.testCheckPasses, 13 );
    test.identical( suite.report.testCheckFails, 5 );
    test.identical( counter.acheck.checkIndex, suite.report.testCheckPasses+suite.report.testCheckFails+1 );

    if( err )
    throw err;

    return null;
  });

  return result;
}

mustNotThrowError_WithCallback.timeOut = 10000;

//

function shouldThrowErrorSync( test )
{
  let context = this;
  var counter = new CheckCounter();

  function r1( t )
  {

    let ready = new _.Consequence().take( null );
    counter.testRoutine = t;
    t.description = 'a';

    /* */

    ready.then( () =>
    {
      test.case = 'trivial, does not throw error, but expected';

      t.identical( 0, 0 );
      var c1 = t.shouldThrowErrorSync( () => {} );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c1, false );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'expected synchronous error, throw string message';

      t.identical( 0, 0 );
      var c2 = t.shouldThrowErrorSync( () => { throw 'test' } );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.false( _.errIs( c2 ) );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'expected synchronous error, throw error';

      t.identical( 0, 0 );
      var c2 = t.shouldThrowErrorSync( () => { throw _.err( 'test' ) } );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.true( _.errIs( c2 ) );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw unexpected asynchronous error';

      t.identical( 0, 0 );
      var c3 = t.shouldThrowErrorSync( () =>
      {
        return _.time.out( context.t1, () =>
        {
          throw _.errAttend( 'test1' );
        });
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c3, false );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'single message, while synchronous error expected';

      t.identical( 0, 0 );
      var c4 = t.shouldThrowErrorSync( () => _.time.out( context.t1 ) );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c4, false );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second message';

      t.identical( 0, 0 );
      var c5 = t.shouldThrowErrorSync( () =>
      {
        var con = _.Consequence({ capacity : 0 });

        _.time.out( context.t1, () =>
        {
          con.take( null );
          con.take( null );
          return null;
        });

        return con;
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c5, false );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second error';

      t.identical( 0, 0 );
      var c6 = t.shouldThrowErrorSync( () =>
      {
        var con = _.Consequence({ capacity : 0 }).error( _.errAttend( 'error1' ) );

        _.time.out( context.t1, () =>
        {
          con.error( _.errAttend( 'error2' ) );
          return null;
        });

        return con;
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c6, false );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with argument';

      t.identical( 0, 0 );
      var c7 = t.shouldThrowErrorSync( _.Consequence().take( 'arg' ) );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c7, false );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with error';

      t.identical( 0, 0 );
      var c80 = _.Consequence().error( _.errAttend( 'error1' ) );
      var c8 = t.shouldThrowErrorSync( c80 );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c8, false );
        test.identical( c80.resourcesGet().length, 1 );
        c80.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    return ready;
  }

  var suite = wTestSuite
  ({
    tests : { r1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run()
  .finally( ( err, data ) =>
  {

    counter.acheck = counter.testRoutine.checkCurrent();

    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck.checkIndex, 19 );
    test.identical( suite.report.testCheckPasses, 11 );
    test.identical( suite.report.testCheckFails, 7 );
    test.identical( counter.acheck.checkIndex, suite.report.testCheckPasses+suite.report.testCheckFails+1 );

    if( err )
    throw err;

    return null;
  });

  return result;
}

shouldThrowErrorSync.timeOut = 30000;

//

function shouldThrowErrorSyncWithCallback( test )
{

  var counter = new CheckCounter();

  function r1( t )
  {
    let ready = new _.Consequence().take( null );
    counter.testRoutine = t;
    t.description = 'a';

    /* */

    ready.then( () =>
    {
      test.case = 'trivial, does not throw error, but expected';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c1 = t.shouldThrowErrorSync( () => undefined, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      test.identical( errStack, [ undefined, false ] );

      return _.time.out( 500, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.false( c1 );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'expected synchronous error, throw string';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c2 = t.shouldThrowErrorSync( () => { throw 'test' }, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      test.identical( errStack, [ 'test', true ] );

      return _.time.out( 500, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.false( _.errIs( c2 ) );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'expected synchronous error, throw error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c2 = t.shouldThrowErrorSync( () => { throw _.errBrief( 'test' ) }, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      test.identical( errStack, [ 'test', true ] );

      return _.time.out( 500, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.true( _.errIs( c2 ) );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw unexpected asynchronous error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c3 = t.shouldThrowErrorSync( () =>
      {
        return _.time.out( 150, () =>
        {
          throw _.errAttend( 'test1' );
        });
      }, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      test.identical( errStack.length, 2 );
      test.true( _.consequenceIs( errStack[ 0 ] ) );
      test.identical( errStack[ 1 ], false );

      return _.time.out( 500, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.true( c3 === false );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'single message, while synchronous error expected';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c4 = t.shouldThrowErrorSync( () =>
      {
        return _.time.out( 150 );
      }, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      test.identical( errStack.length, 2 );
      test.true( _.consequenceIs( errStack[ 0 ] ) );
      test.identical( errStack[ 1 ], false );

      return _.time.out( 500, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.true( c4 === false );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second message';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c5 = t.shouldThrowErrorSync( () =>
      {
        var con = _.Consequence({ capacity : 0 });

        _.time.out( 150, () =>
        {
          con.take( null );
          con.take( null );
          return null;
        });

        return con;
      }, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      test.identical( errStack.length, 2 );
      test.true( _.consequenceIs( errStack[ 0 ] ) );
      test.identical( errStack[ 1 ], false );

      return _.time.out( 500, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.true( c5 === false );
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c6 = t.shouldThrowErrorSync( () =>
      {
        var con = _.Consequence({ capacity : 0 })
        .error( _.errAttend( 'error1' ) );

        _.time.out( 150, () =>
        {
          con.error( _.errAttend( 'error2' ) );
          return null;
        });

        return con;
      }, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      test.identical( errStack.length, 2 );
      test.true( _.consequenceIs( errStack[ 0 ] ) );
      test.identical( errStack[ 1 ], false );

      return _.time.out( 500, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c6, false );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with argument';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c7 = t.shouldThrowErrorSync( _.Consequence().take( 'arg' ), onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      test.identical( errStack.length, 2 );
      test.true( _.consequenceIs( errStack[ 0 ] ) );
      test.identical( errStack[ 1 ], false );

      return _.time.out( 500, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c7, false );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c80 = _.Consequence().error( _.errAttend( 'error1' ) );
      var c8 = t.shouldThrowErrorSync( c80, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      test.identical( errStack.length, 2 );
      test.true( _.consequenceIs( errStack[ 0 ] ) );
      test.identical( errStack[ 1 ], false );

      return _.time.out( 500, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c8, false );
        test.identical( c80.resourcesGet().length, 1 );
        c80.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    return ready;
  }

  var suite = wTestSuite
  ({
    tests : { r1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run()
  .finally( ( err, data ) =>
  {

    counter.acheck = counter.testRoutine.checkCurrent();

    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck.checkIndex, 19 );
    test.identical( suite.report.testCheckPasses, 11 );
    test.identical( suite.report.testCheckFails, 7 );
    test.identical( counter.acheck.checkIndex, suite.report.testCheckPasses+suite.report.testCheckFails+1 );

    if( err )
    throw err;

    return null;
  });

  return result;
}

shouldThrowErrorSyncWithCallback.timeOut = 30000;

//

function shouldThrowErrorSync_WithCallback( test )
{
  let context = this;
  var counter = new CheckCounter();

  function r1( t )
  {
    let ready = new _.Consequence().take( null );
    counter.testRoutine = t;
    t.description = 'a';

    /* */

    ready.then( () =>
    {
      test.case = 'trivial, does not throw error, but expected';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c1 = t.shouldThrowErrorSync_( () => undefined, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      test.identical( errStack, [ undefined, false ] );

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.false( c1 );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'expected synchronous error, throw string';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c2 = t.shouldThrowErrorSync_( () => { throw 'test' }, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      test.identical( errStack, [ 'test', true ] );

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.false( _.errIs( c2 ) );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'expected synchronous error, throw error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c2 = t.shouldThrowErrorSync_( () => { throw _.errBrief( 'test' ) }, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      test.identical( errStack, [ 'test', true ] );

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.true( _.errIs( c2 ) );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw unexpected asynchronous error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c3 = t.shouldThrowErrorSync_( () =>
      {
        return _.time.out( context.t1, () =>
        {
          throw _.errAttend( 'test1' );
        });
      }, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      test.identical( errStack.length, 2 );
      test.true( _.consequenceIs( errStack[ 0 ] ) );
      test.identical( errStack[ 1 ], false );

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.true( c3 === false );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'single message, while synchronous error expected';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c4 = t.shouldThrowErrorSync_( () =>
      {
        return _.time.out( context.t1 );
      }, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      test.identical( errStack.length, 2 );
      test.true( _.consequenceIs( errStack[ 0 ] ) );
      test.identical( errStack[ 1 ], false );

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.true( c4 === false );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second message';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c5 = t.shouldThrowErrorSync_( () =>
      {
        var con = _.Consequence({ capacity : 0 });

        _.time.out( context.t1, () =>
        {
          con.take( null );
          con.take( null );
          return null;
        });

        return con;
      }, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      test.identical( errStack.length, 2 );
      test.true( _.consequenceIs( errStack[ 0 ] ) );
      test.identical( errStack[ 1 ], false );

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.true( c5 === false );
        return null;
      });
    })

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c6 = t.shouldThrowErrorSync_( () =>
      {
        var con = _.Consequence({ capacity : 0 })
        .error( _.errAttend( 'error1' ) );

        _.time.out( context.t1, () =>
        {
          con.error( _.errAttend( 'error2' ) );
          return null;
        });

        return con;
      }, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      test.identical( errStack.length, 2 );
      test.true( _.consequenceIs( errStack[ 0 ] ) );
      test.identical( errStack[ 1 ], false );

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c6, false );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with argument';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c7 = t.shouldThrowErrorSync_( _.Consequence().take( 'arg' ), onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      test.identical( errStack.length, 2 );
      test.true( _.consequenceIs( errStack[ 0 ] ) );
      test.identical( errStack[ 1 ], false );

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c7, false );
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c80 = _.Consequence().error( _.errAttend( 'error1' ) );
      var c8 = t.shouldThrowErrorSync_( c80, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      test.identical( errStack.length, 2 );
      test.true( _.consequenceIs( errStack[ 0 ] ) );
      test.identical( errStack[ 1 ], false );

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c8, false );
        test.identical( c80.resourcesGet().length, 1 );
        c80.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    return ready;
  }

  var suite = wTestSuite
  ({
    tests : { r1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run()
  .finally( ( err, data ) =>
  {

    counter.acheck = counter.testRoutine.checkCurrent();

    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck.checkIndex, 19 );
    test.identical( suite.report.testCheckPasses, 11 );
    test.identical( suite.report.testCheckFails, 7 );
    test.identical( counter.acheck.checkIndex, suite.report.testCheckPasses+suite.report.testCheckFails+1 );

    if( err )
    throw err;

    return null;
  });

  return result;
}

shouldThrowErrorSync_WithCallback.timeOut = 30000;

//

function shouldThrowErrorAsync( test )
{
  let context = this;
  var counter = new CheckCounter();

  test.true( test.logger.outputs.length > 0 );

  function r1( t )
  {
    let ready = new _.Consequence().take( null );

    counter.testRoutine = t;
    t.description = 'a';

    ready.then( () =>
    {
      test.case = 'trivial, does not throw error, but expected';

      t.identical( 0, 0 );
      var c1 = t.shouldThrowErrorAsync( () => {} );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c1.resourcesGet().length, 1 );

        c1.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw unexpected synchronous error';

      t.identical( 0, 0 );
      var c2 = t.shouldThrowErrorAsync( () => { throw _.err( 'test' ) } );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c2.resourcesGet().length, 1 );

        c2.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw expected asynchronous error';

      t.identical( 0, 0 );
      var c3 = t.shouldThrowErrorAsync( () =>
      {
        return _.time.out( context.t1, () =>
        {
          throw _.err( 'test' );
        });
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c3.resourcesGet().length, 1 ); /* zzz : phantom? */

        c3.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.errIs( arg ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'single message while asynchronous error expected';

      t.identical( 0, 0 );
      var c4 = t.shouldThrowErrorAsync( () =>
      {
        return _.time.out( context.t1 );
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 ); /* delayed */
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( c4.resourcesGet().length, 1 );

        c4.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'expected async string error';

      t.identical( 0, 0 );
      var c5 = t.shouldThrowErrorAsync( () =>
      {
        var con = _.Consequence();

        _.time.out( context.t1, () =>
        {
          con.error( 'error1' );
          return null;
        });

        return con;
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c5.resourcesGet().length, 1 );

        c5.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.strHas( _.err( arg ).message, 'error1' ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second message';

      t.identical( 0, 0 );
      var c6 = t.shouldThrowErrorAsync( () =>
      {
        var con = _.Consequence();

        _.time.out( context.t1, () =>
        {
          con.take( null );
          con.take( null );
          return null;
        });

        return con;
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( c6.resourcesGet().length, 1 );
        c6.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second error';

      t.identical( 0, 0 );
      var c7 = t.shouldThrowErrorAsync( () =>
      {
        var con = _.Consequence({ capacity : 0 });

        _.time.out( context.t1, () =>
        {
          con.error( _.errAttend( 'error1' ) );
          con.error( _.errAttend( 'error2' ) );
          return null;
        });

        return con;
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( c7.resourcesGet().length, 1 );

        c7.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( _.strHas( err.message, 'Got more than one message' ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with argument';

      t.identical( 0, 0 );
      var c8 = t.shouldThrowErrorAsync( _.Consequence().take( 'arg' ) );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( c8.resourcesGet().length, 1 );

        c8.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with error';

      t.identical( 0, 0 );
      var c9 = t.shouldThrowErrorAsync( _.Consequence().error( 'error1' ) );
      counter.acheck = t.checkCurrent();

      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c9.resourcesGet().length, 1 );
        c9.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.strHas( _.err( arg ).message, 'error1' ) );
        });
        return null;
      });
    });

    /* */

    return ready;
  }

  /* */

  var suite = wTestSuite
  ({
    tests : { r1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });
  var result = suite.run()
  .finally( ( err, data ) =>
  {

    counter.acheck = counter.testRoutine.checkCurrent();

    test.true( test.logger.outputs.length > 0 );
    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck.checkIndex, 19 );
    test.identical( suite.report.testCheckPasses, 12 );
    test.identical( suite.report.testCheckFails, 6 );
    test.identical( counter.acheck.checkIndex, suite.report.testCheckPasses+suite.report.testCheckFails+1 );

    if( err )
    throw err;

    return null;

  });

  return result;
}

shouldThrowErrorAsync.timeOut = 30000;

//

function shouldThrowErrorAsyncWithCallback( test )
{
  let context = this;
  var counter = new CheckCounter();

  test.true( test.logger.outputs.length > 0 );

  function r1( t )
  {

    let ready = new _.Consequence().take( null );
    counter.testRoutine = t;
    t.description = 'a';

    /* */

    ready.then( () =>
    {
      test.case = 'trivial, does not throw error, but expected';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c1 = t.shouldThrowErrorAsync( () => {}, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack, [ undefined, false ] );

        test.identical( c1.resourcesGet().length, 1 );
        c1.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw unexpected synchronous error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];
      t.identical( 0, 0 );

      var c2 = t.shouldThrowErrorAsync( () => { throw _.errBrief( 'test' ) }, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.identical( errStack, [ 'test', false ] );

        test.identical( c2.resourcesGet().length, 1 );
        c2.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw expected asynchronous error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c3 = t.shouldThrowErrorAsync( () =>
      {
        return _.time.out( context.t1, () =>
        {
          throw _.errBrief( 'test' );
        });
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.identical( errStack, [ 'test', true ] );

        test.identical( c3.resourcesGet().length, 1 );
        c3.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.errIs( arg ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'single message while asynchronous error expected';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c4 = t.shouldThrowErrorAsync( () =>
      {
        return _.time.out( context.t1 );
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.consequenceIs( errStack[ 0 ] ) );
        test.identical( errStack[ 1 ], false );

        test.identical( c4.resourcesGet().length, 1 );
        c4.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'expected async string error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c5 = t.shouldThrowErrorAsync( () =>
      {
        var con = _.Consequence();

        _.time.out( context.t1, () =>
        {
          con.error( 'error1' );
          return null;
        });
        return con;
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.strHas( errStack[ 0 ], 'error1' ) );
        test.identical( errStack[ 1 ], true );

        test.identical( c5.resourcesGet().length, 1 );
        c5.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.strHas( _.err( arg ).message, 'error1' ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second message';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c6 = t.shouldThrowErrorAsync( () =>
      {
        var con = _.Consequence();

        _.time.out( context.t1, () =>
        {
          con.take( null );
          con.take( null );
          return null;
        });
        return con;
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.consequenceIs( errStack[ 0 ] ) );
        test.identical( errStack[ 1 ], false );

        test.identical( c6.resourcesGet().length, 1 );
        c6.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c7 = t.shouldThrowErrorAsync( () =>
      {
        var con = _.Consequence({ capacity : 0 });

        _.time.out( context.t1, () =>
        {
          con.error( _.errAttend( 'error1' ) );
          con.error( _.errAttend( 'error2' ) );
          return null;
        });
        return con;
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.strHas( errStack[ 0 ], 'error1' ) );
        test.identical( errStack[ 1 ], true );

        test.identical( c7.resourcesGet().length, 1 );
        c7.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( _.strHas( err.message, 'Got more than one message' ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with argument';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c8 = t.shouldThrowErrorAsync( _.Consequence().take( 'arg' ), onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );

        test.identical( c8.resourcesGet().length, 1 );
        c8.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c9 = t.shouldThrowErrorAsync( _.Consequence().error( 'error1' ), onResult );
      counter.acheck = t.checkCurrent();

      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.strHas( errStack[ 0 ], 'error1' ) );
        test.identical( errStack[ 1 ], true );

        test.identical( c9.resourcesGet().length, 1 );
        c9.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.strHas( _.err( arg ).message, 'error1' ) );
        });
        return null;
      });
    });

    /* */

    return ready;
  }
  r1.timeOut = 15000;

  /* */

  var suite = wTestSuite
  ({
    tests : { r1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });
  var result = suite.run()
  .finally( function( err, data )
  {

    counter.acheck = counter.testRoutine.checkCurrent();

    test.true( test.logger.outputs.length > 0 );
    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck.checkIndex, 19 );
    test.identical( suite.report.testCheckPasses, 12 );
    test.identical( suite.report.testCheckFails, 6 );
    test.identical( counter.acheck.checkIndex, suite.report.testCheckPasses+suite.report.testCheckFails+1 );

    if( err )
    throw err;

    return null;

  });

  return result;
}

shouldThrowErrorAsyncWithCallback.timeOut = 30000;

//

function shouldThrowErrorAsync_WithCallback( test )
{
  let context = this;
  var counter = new CheckCounter();

  test.true( test.logger.outputs.length > 0 );

  function r1( t )
  {

    let ready = new _.Consequence().take( null );
    counter.testRoutine = t;
    t.description = 'a';

    /* */

    ready.then( () =>
    {
      test.case = 'trivial, does not throw error, but expected';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c1 = t.shouldThrowErrorAsync_( () => {}, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack, [ undefined, false ] );

        test.identical( c1.resourcesGet().length, 1 );
        c1.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw unexpected synchronous error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];
      t.identical( 0, 0 );

      var c2 = t.shouldThrowErrorAsync_( () => { throw _.errBrief( 'test' ) }, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.identical( errStack, [ 'test', false ] );

        test.identical( c2.resourcesGet().length, 1 );
        c2.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw expected asynchronous error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c3 = t.shouldThrowErrorAsync_( () =>
      {
        return _.time.out( context.t1, () =>
        {
          throw _.errBrief( 'test' );
        });
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.identical( errStack, [ 'test', true ] );

        test.identical( c3.resourcesGet().length, 1 );
        c3.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.errIs( arg ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'single message while asynchronous error expected';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c4 = t.shouldThrowErrorAsync_( () =>
      {
        return _.time.out( context.t1 );
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( 400, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.consequenceIs( errStack[ 0 ] ) );
        test.identical( errStack[ 1 ], false );

        test.identical( c4.resourcesGet().length, 1 );
        c4.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'expected async string error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c5 = t.shouldThrowErrorAsync_( () =>
      {
        var con = _.Consequence();

        _.time.out( context.t1, () =>
        {
          con.error( 'error1' );
          return null;
        });
        return con;
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( 400, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.strHas( errStack[ 0 ], 'error1' ) );
        test.identical( errStack[ 1 ], true );

        test.identical( c5.resourcesGet().length, 1 );
        c5.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.strHas( _.err( arg ).message, 'error1' ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second message';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c6 = t.shouldThrowErrorAsync_( () =>
      {
        var con = _.Consequence();

        _.time.out( context.t1, () =>
        {
          con.take( null );
          con.take( null );
          return null;
        });
        return con;
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( 400, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.consequenceIs( errStack[ 0 ] ) );
        test.identical( errStack[ 1 ], false );

        test.identical( c6.resourcesGet().length, 1 );
        c6.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c7 = t.shouldThrowErrorAsync_( () =>
      {
        var con = _.Consequence({ capacity : 0 });

        _.time.out( context.t1, () =>
        {
          con.error( _.errAttend( 'error1' ) );
          con.error( _.errAttend( 'error2' ) );
          return null;
        });
        return con;
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( 400, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.strHas( errStack[ 0 ], 'error1' ) );
        test.identical( errStack[ 1 ], true );

        test.identical( c7.resourcesGet().length, 1 );
        c7.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( _.strHas( err.message, 'Got more than one message' ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with argument';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c8 = t.shouldThrowErrorAsync_( _.Consequence().take( 'arg' ), onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );

        test.identical( c8.resourcesGet().length, 1 );
        c8.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c9 = t.shouldThrowErrorAsync_( _.Consequence().error( 'error1' ), onResult );
      counter.acheck = t.checkCurrent();

      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.strHas( errStack[ 0 ], 'error1' ) );
        test.identical( errStack[ 1 ], true );

        test.identical( c9.resourcesGet().length, 1 );
        c9.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.strHas( _.err( arg ).message, 'error1' ) );
        });
        return null;
      });
    });

    /* */

    return ready;
  }

  /* */

  var suite = wTestSuite
  ({
    tests : { r1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });
  var result = suite.run()
  .finally( function( err, data )
  {

    counter.acheck = counter.testRoutine.checkCurrent();

    test.true( test.logger.outputs.length > 0 );
    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck.checkIndex, 19 );
    test.identical( suite.report.testCheckPasses, 12 );
    test.identical( suite.report.testCheckFails, 6 );
    test.identical( counter.acheck.checkIndex, suite.report.testCheckPasses+suite.report.testCheckFails+1 );

    if( err )
    throw err;

    return null;

  });

  return result;
}

shouldThrowErrorAsync_WithCallback.timeOut = 30000;

//

function shouldThrowErrorOfAnyKind( test )
{
  let context = this;
  var counter = new CheckCounter();

  function r1( t )
  {
    let ready = new _.Consequence().take( null );

    counter.testRoutine = t;
    t.description = 'a';

    ready.then( () =>
    {
      test.case = 'does not throw error, but expected';

      t.identical( 0, 0 );
      var c1 = t.shouldThrowErrorOfAnyKind( () => {} );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c1.resourcesGet().length, 1 );

        c1.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw expected synchronous error';

      t.identical( 0, 0 );
      var c2 = t.shouldThrowErrorOfAnyKind( () =>
      {
        throw _.err( 'err1' );
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c2.resourcesGet().length, 1 );

        c2.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.errIs( arg ) );
          test.true( _.strHas( arg.message, 'err1' ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw expected asynchronous error';

      t.identical( 0, 0 );
      var c3 = t.shouldThrowErrorOfAnyKind( () =>
      {
        return _.time.out( context.t1, () =>
        {
          throw _.err( 'err1' );
        });
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c3.resourcesGet().length, 1 );

        c3.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.errIs( arg ) );
          test.true( _.strHas( arg.message, 'err1' ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'single message, but error expected';

      t.identical( 0, 0 );
      var c4 = t.shouldThrowErrorOfAnyKind( () => _.time.out( context.t1 ) );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( c4.resourcesGet().length, 1 );

        c4.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second message';

      t.identical( 0, 0 );
      var c5 = t.shouldThrowErrorOfAnyKind( () =>
      {
        var con = _.Consequence();

        _.time.out( context.t1, () =>
        {
          con.take( 'arg1' );
          con.take( 'arg2' );
          return null;
        });

        return con;
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( c5.resourcesGet().length, 1 );
        c5.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second error';

      t.identical( 0, 0 );
      var c6 = t.shouldThrowErrorOfAnyKind( () =>
      {
        var con = _.Consequence();

        _.time.out( context.t1, () =>
        {
          con.error( _.errAttend( 'error1' ) );
          con.error( _.errAttend( 'error2' ) );
          return null;
        });

        return con;
      });

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( c6.resourcesGet().length, 1 );

        c6.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( _.strHas( err.message, 'Got more than one message' ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with argument';

      t.identical( 0, 0 );
      var c8 = t.shouldThrowErrorOfAnyKind( _.Consequence().take( 'arg' ) );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( c8.resourcesGet().length, 1 );

        c8.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with error';

      t.identical( 0, 0 );
      var c9 = t.shouldThrowErrorOfAnyKind( _.Consequence().error( 'error1' ) );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( c9.resourcesGet().length, 1 );
        c9.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.strHas( _.err( arg ).message, 'error1' ) );
        });
        return null;
      });
    });

    /* */

    return ready;
  }

  var suite = wTestSuite
  ({
    tests : { r1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run()
  .finally( ( err, data ) =>
  {

    counter.acheck = counter.testRoutine.checkCurrent();
    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck.checkIndex, 17 );
    test.identical( suite.report.testCheckPasses, 11 );
    test.identical( suite.report.testCheckFails, 5 );
    test.identical( counter.acheck.checkIndex, suite.report.testCheckPasses+suite.report.testCheckFails+1 );

    if( err )
    throw err;

    return null;
  });

  return result;
}

shouldThrowErrorOfAnyKind.timeOut = 30000;

//

function shouldThrowErrorOfAnyKindWithCallback( test )
{
  let context = this;
  var counter = new CheckCounter();

  function r1( t )
  {

    let ready = new _.Consequence().take( null );
    counter.testRoutine = t;
    t.description = 'a';

    ready.then( () =>
    {
      test.case = 'does not throw error, but expected';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c1 = t.shouldThrowErrorOfAnyKind( () => {}, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.identical( errStack, [ undefined, false ] );

        test.identical( c1.resourcesGet().length, 1 );
        c1.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw expected synchronous error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c2 = t.shouldThrowErrorOfAnyKind( () =>
      {
        throw _.errBrief( 'err1' );
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.identical( errStack, [ 'err1', true ] );

        test.identical( c2.resourcesGet().length, 1 );
        c2.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.errIs( arg ) );
          test.true( _.strHas( arg.message, 'err1' ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw expected asynchronous error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c3 = t.shouldThrowErrorOfAnyKind( () =>
      {
        return _.time.out( context.t1, () =>
        {
          throw _.errBrief( 'err1' );
        });
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.identical( errStack, [ 'err1', true ] );

        test.identical( c3.resourcesGet().length, 1 );
        c3.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.errIs( arg ) );
          test.true( _.strHas( arg.message, 'err1' ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'single message, but error expected';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c4 = t.shouldThrowErrorOfAnyKind( () =>
      {
        return _.time.out( context.t1 );
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.consequenceIs( errStack[ 0 ] ) );
        test.identical( errStack[ 1 ], false );

        test.identical( c4.resourcesGet().length, 1 );
        c4.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second message';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c5 = t.shouldThrowErrorOfAnyKind( () =>
      {
        var con = _.Consequence();
        _.time.out( context.t1, () =>
        {
          con.take( 'arg1' );
          con.take( 'arg2' );
          return null;
        });
        return con;
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.consequenceIs( errStack[ 0 ] ) );
        test.identical( errStack[ 1 ], false );

        test.identical( c5.resourcesGet().length, 1 );
        c5.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c6 = t.shouldThrowErrorOfAnyKind( () =>
      {
        var con = _.Consequence();
        _.time.out( context.t1, () =>
        {
          con.error( _.errAttend( 'error1' ) );
          con.error( _.errAttend( 'error2' ) );
          return null;
        });
        return con;
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.strHas( errStack[ 0 ], 'error1' ) );
        test.identical( errStack[ 1 ], true );

        test.identical( c6.resourcesGet().length, 1 );
        c6.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( _.strHas( err.message, 'Got more than one message' ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with argument';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c8 = t.shouldThrowErrorOfAnyKind( _.Consequence().take( 'arg' ), onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.consequenceIs( errStack[ 0 ] ) );
        test.identical( errStack[ 1 ], false );

        test.identical( c8.resourcesGet().length, 1 );
        c8.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c9 = t.shouldThrowErrorOfAnyKind( _.Consequence().error( 'error1' ), onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.strHas( errStack[ 0 ], 'error1' ) );
        test.identical( errStack[ 1 ], true );

        test.identical( c9.resourcesGet().length, 1 );
        c9.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.strHas( _.err( arg ).message, 'error1' ) );
        });
        return null;
      });
    });

    /* */

    return ready;
  }

  var suite = wTestSuite
  ({
    tests : { r1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run()
  .finally( function( err, data )
  {

    counter.acheck = counter.testRoutine.checkCurrent();
    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck.checkIndex, 17 );
    test.identical( suite.report.testCheckPasses, 11 );
    test.identical( suite.report.testCheckFails, 5 );
    test.identical( counter.acheck.checkIndex, suite.report.testCheckPasses+suite.report.testCheckFails+1 );

    if( err )
    throw err;

    return null;
  });

  return result;
}

shouldThrowErrorOfAnyKindWithCallback.timeOut = 10000;

//

function shouldThrowErrorOfAnyKind_WithCallback( test )
{
  let context = this;
  var counter = new CheckCounter();

  function r1( t )
  {

    let ready = new _.Consequence().take( null );
    counter.testRoutine = t;
    t.description = 'a';

    ready.then( () =>
    {
      test.case = 'does not throw error, but expected';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c1 = t.shouldThrowErrorOfAnyKind_( () => {}, onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.identical( errStack, [ undefined, false ] );

        test.identical( c1.resourcesGet().length, 1 );
        c1.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw expected synchronous error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c2 = t.shouldThrowErrorOfAnyKind_( () =>
      {
        throw _.errBrief( 'err1' );
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 2 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.identical( errStack, [ 'err1', true ] );

        test.identical( c2.resourcesGet().length, 1 );
        c2.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.errIs( arg ) );
          test.true( _.strHas( arg.message, 'err1' ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'throw expected asynchronous error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c3 = t.shouldThrowErrorOfAnyKind_( () =>
      {
        return _.time.out( context.t1, () =>
        {
          throw _.errBrief( 'err1' );
        });
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.identical( errStack, [ 'err1', true ] );

        test.identical( c3.resourcesGet().length, 1 );
        c3.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.errIs( arg ) );
          test.true( _.strHas( arg.message, 'err1' ) );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'single message, but error expected';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c4 = t.shouldThrowErrorOfAnyKind_( () =>
      {
        return _.time.out( context.t1 );
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.consequenceIs( errStack[ 0 ] ) );
        test.identical( errStack[ 1 ], false );

        test.identical( c4.resourcesGet().length, 1 );
        c4.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second message';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c5 = t.shouldThrowErrorOfAnyKind_( () =>
      {
        var con = _.Consequence();
        _.time.out( context.t1, () =>
        {
          con.take( 'arg1' );
          con.take( 'arg2' );
          return null;
        });
        return con;
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.consequenceIs( errStack[ 0 ] ) );
        test.identical( errStack[ 1 ], false );

        test.identical( c5.resourcesGet().length, 1 );
        c5.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'not expected second error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c6 = t.shouldThrowErrorOfAnyKind_( () =>
      {
        var con = _.Consequence();
        _.time.out( context.t1, () =>
        {
          con.error( _.errAttend( 'error1' ) );
          con.error( _.errAttend( 'error2' ) );
          return null;
        });
        return con;
      },
      onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.strHas( errStack[ 0 ], 'error1' ) );
        test.identical( errStack[ 1 ], true );

        test.identical( c6.resourcesGet().length, 1 );
        c6.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( _.strHas( err.message, 'Got more than one message' ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with argument';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c8 = t.shouldThrowErrorOfAnyKind_( _.Consequence().take( 'arg' ), onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 1 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.consequenceIs( errStack[ 0 ] ) );
        test.identical( errStack[ 1 ], false );

        test.identical( c8.resourcesGet().length, 1 );
        c8.give( ( err, arg ) =>
        {
          test.true( _.errIs( err ) );
          test.true( !arg );
        });
        return null;
      });
    });

    /* */

    ready.then( () =>
    {
      test.case = 'consequence with error';
      var onResult = ( err, arg, ok ) => err ? errStack.push( err.message, ok ) : errStack.push( arg, ok );
      var errStack = [];

      t.identical( 0, 0 );
      var c9 = t.shouldThrowErrorOfAnyKind_( _.Consequence().error( 'error1' ), onResult );

      counter.acheck = t.checkCurrent();
      test.identical( counter.acheck.description, 'a' );
      test.identical( counter.acheck.checkIndex-counter.prevCheckIndex, 2 );
      test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
      test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
      counter.next();

      return _.time.out( context.t2 / 2, () =>
      {
        test.identical( t.suite.report.testCheckPasses-counter.prevCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails-counter.prevCheckFails, 0 );
        counter.next();

        test.identical( errStack.length, 2 );
        test.true( _.strHas( errStack[ 0 ], 'error1' ) );
        test.identical( errStack[ 1 ], true );

        test.identical( c9.resourcesGet().length, 1 );
        c9.give( ( err, arg ) =>
        {
          test.true( err === undefined );
          test.true( _.strHas( _.err( arg ).message, 'error1' ) );
        });
        return null;
      });
    });

    /* */

    return ready;
  }

  var suite = wTestSuite
  ({
    tests : { r1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run()
  .finally( function( err, data )
  {

    counter.acheck = counter.testRoutine.checkCurrent();
    test.identical( counter.acheck.description, '' );
    test.identical( counter.acheck.checkIndex, 17 );
    test.identical( suite.report.testCheckPasses, 11 );
    test.identical( suite.report.testCheckFails, 5 );
    test.identical( counter.acheck.checkIndex, suite.report.testCheckPasses+suite.report.testCheckFails+1 );

    if( err )
    throw err;

    return null;
  });

  return result;
}

shouldThrowErrorOfAnyKind_WithCallback.timeOut = 10000;

//

function shouldPassMessage( test )
{
  var counter = new CheckCounter();

  test.case = 'mustNotThrowError must return con with message';

  var con = new _.Consequence().take( '123' );
  test.mustNotThrowError( con )
  .then( function( arg )
  {
    test.identical( arg, '123' );
    return null;
  });

  var con = new _.Consequence().take( '123' );
  test.returnsSingleResource( con )
  .then( function( arg )
  {
    test.identical( arg, '123' );
    return null;
  });

  test.case = 'mustNotThrowError must return con original error';

  var errOriginal = _.err( 'Err' );
  var con = new _.Consequence().error( errOriginal );
  test.shouldThrowErrorOfAnyKind( con )
  .finally( function( err, arg )
  {
    test.identical( err, undefined );
    test.identical( arg, errOriginal );
    _.errAttend( err );
    return null;
  });

  return _.time.out( 500 );
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
    var con = _.Consequence().take( null );

    _.time.out( 150, function()
    {
      con.take( null );
      con.take( null );
    });

    return con;
  });

  /* */

  t.shouldThrowErrorOfAnyKind( function()
  {
    var con = _.Consequence().take( null );

    _.time.out( 2000, function()
    {
      con.take( null );
      con.take( null );
    });

    return con;
  });

  /* */

  t.shouldThrowErrorOfAnyKind( function()
  {
    return _.time.out( 150 );
  });

  /* */

  t.description = 'a';

  t.identical( 0, 0 );
  t.shouldThrowErrorAsync( function()
  {
  });

  t.identical( 0, 0 );

  t.shouldThrowErrorAsync( function()
  {
    throw _.err( 'test' );
  });

  t.identical( 0, 0 );

  t.shouldThrowErrorAsync( function()
  {
    return _.time.out( 150, function()
    {
      throw _.err( 'test' );
    });
  });

  t.identical( 0, 0 );

  t.shouldThrowErrorAsync( function()
  {
    return _.time.out( 150 );
  });

  t.identical( 0, 0 );

  t.shouldThrowErrorAsync( function()
  {
    var con = _.Consequence().take( null );

    _.time.out( 150, function()
    {
      con.take( null );
      con.take( null );
    });

    return con;
  });

  t.identical( 0, 0 );

  _.time.out( 2000, function()
  {

    counter.acheck = t.checkCurrent();
    console.log( 'checkIndex', acheck.checkIndex, 13 );
    console.log( 'testCheckPasses', test.suite.report.testCheckPasses, 8 );
    console.log( 'testCheckFails', test.suite.report.testCheckFails, 4 );

  });

  /* */

  test.case = 'trivial, does not throw error,  but expected';
  test.shouldThrowErrorAsync( function()
  {
  });

  /* */

  test.case = 'single message';
  test.mustNotThrowError( function()
  {
    return _.time.out( 150 );
  });

  /* */

  test.shouldThrowErrorSync( function()
  {
    var con = _.Consequence().take( null );

    _.time.out( 150, function()
    {
      con.take( null );
      con.take( null );
    });

    return con;
  });

  /* */

  test.shouldThrowErrorSync( function()
  {
    return _.time.out( 150 );
  });

  /* */

  test.mustNotThrowError( function()
  {
  });

  test.identical( 0, 0 );

  test.mustNotThrowError( function()
  {
    throw _.err( 'test' );
  });

  test.identical( 0, 0 );

  /* */

  test.case = 'if passes dont appears in output/passed test checks/total counter';
  test.mustNotThrowError( function()
  {
  });

  test.identical( 0, 0 );

  test.case = 'if not passes then appears in output/total counter';
  test.mustNotThrowError( function()
  {
    return _.time.out( 1000, function()
    {
      throw _.err( 'test' );
    });
    // throw _.err( 'test' );
  });

  test.identical( 0, 0 );

  test.case = 'not expected second message';
  test.mustNotThrowError( function()
  {
    var con = _.Consequence().take( null );

    _.time.out( 1000, function()
    {
      con.take( null );
      con.take( null );
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

  test.identical( test._inroutineCon.resourcesGet().length, 1 );

  var ready = new _.Consequence().take( null );

  ready
  .then( function( arg )
  {
    return test.shouldThrowErrorSync( function()
    {
      throw _.err( 'shouldThrowErrorSync a' );
    });
  })
  .then( function( arg )
  {
    return test.shouldThrowErrorSync( function()
    {
      throw _.err( 'shouldThrowErrorSync b' );
    });
  });

  return ready;
}

//

function shouldThrowErrorAsyncSimple( test )
{
  var ready = new _.Consequence().take( null );
  var counter = new CheckCounter();

  counter.testRoutine = test;
  counter.next();

  test.identical( test._inroutineCon.resourcesGet().length, 1 );

  ready.then( () =>
  {
    test.case = 'a';
    test.description = 'aa';
    var con = _.time.out( 150, () =>
    {
      throw _.errAttend( 'async error' );
    });
    return test.shouldThrowErrorAsync( con );
  });

  ready.finally( ( err, arg ) =>
  {
    test.true( err === undefined );
    test.true( _.errIs( arg ) );
    test.case = 'b';
    test.description = 'bb';

    var acheck = test.checkCurrent();
    var expectedCheck =
    {
      groupsStack : [ 'b' ],
      description : 'bb',
      checkIndex : 5,
    }
    test.identical( acheck, expectedCheck );

    var con = _.time.out( 50, () =>
    {
      throw _.errAttend( 'async error' );
    });
    return test.shouldThrowErrorAsync( con );
  });

  ready.finally( ( err, arg ) =>
  {
    test.true( err === undefined );
    test.true( _.errIs( arg ) );

    test.identical( test.report.testCheckFails-counter.prevCheckFails, 0 );
    test.identical( test.report.testCheckPasses-counter.prevCheckPasses, 9 );

    var acheck = test.checkCurrent();
    var expectedCheck =
    {
      groupsStack : [ 'b' ],
      description : 'bb',
      checkIndex : 11,
    }
    test.identical( acheck, expectedCheck );

    test.identical( test._inroutineCon.resourcesGet().length, 0 );

    return null
  });

  return ready;
}

shouldThrowErrorAsyncSimple.timeOut = 3000;

//

function shouldThrowErrorAsyncConcurrent( test )
{
  var ready = new _.Consequence().take( null );
  var counter = new CheckCounter();

  counter.testRoutine = test;
  counter.next();

  test.identical( test._inroutineCon.resourcesGet().length, 1 );

  ready.then( () =>
  {

    test.case = 'a';
    test.description = 'aa';
    var con = _.time.out( 150, () =>
    {
      throw _.errAttend( 'async error' );
    });
    var con1 = test.shouldThrowErrorAsync( con );

    test.case = 'b';
    test.description = 'bb';
    var con = _.time.out( 50, () =>
    {
      throw _.errAttend( 'async error' );
    });
    var con2 = test.shouldThrowErrorAsync( con );

    return _.time.out( 550 );
  })
  .finally( ( err, arg ) =>
  {

    test.true( _.timerIs( arg ) );
    test.identical( err, undefined );

    test.identical( test.report.testCheckPasses-counter.prevCheckPasses, 5 );
    test.identical( test.report.testCheckFails-counter.prevCheckFails, 0 );

    var acheck = test.checkCurrent();
    var expectedCheck =
    {
      groupsStack : [ 'b' ],
      description : 'bb',
      checkIndex : 8,
    }
    test.identical( acheck, expectedCheck );

    test.identical( test._inroutineCon.resourcesGet().length, 1 );

    return null;
  });

  return ready;
}

shouldThrowErrorAsyncConcurrent.timeOut = 3000;

//

function shouldThrowErrorSyncReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 1 );
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

    var got = t.shouldThrowErrorSync( () => _.Consequence().error( _.errAttend( 1 ) ) )
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
    var got = t.shouldThrowErrorSync( function(){}, 13 );
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
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
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
    var con = _.Consequence().take( null )

    .then( ( arg ) =>
    {
      return t.shouldThrowErrorAsync( () => true )
      .finally( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.shouldThrowErrorAsync( () => { throw _.err( 1 ) } )
      .finally( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.shouldThrowErrorAsync( _.Consequence().take( 1 ) )
      .finally( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.shouldThrowErrorAsync( _.Consequence().error( _.err( 'error!' ) ) )
      .finally( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.errIs( got ), true );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.shouldThrowErrorAsync( _.Consequence().error( 'error1' ) )
      .finally( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.true( _.strHas( _.err( got ).message, 'error1' ) );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.shouldThrowErrorAsync( _.time.outError( 500 ) )
      .finally( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.errIs( got ), true );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      test.case = 'no arguments';
      return t.shouldThrowErrorAsync()
      .finally( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      test.case = 'not routines';
      return t.shouldThrowErrorAsync( 'x' )
      .finally( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      test.case = 'several functions';
      return t.shouldThrowErrorAsync( function(){}, 13 )
      .finally( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        done = 1;
        return null;
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
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 3 );
    test.identical( suite.report.testCheckFails, 5 );
    test.identical( suite.report.errorsArray.length, 3 );
    test.identical( done, 1 );
  }

  /* */

  function returnTest( t )
  {
    var con = _.Consequence().take( null )

    .then( ( arg ) =>
    {
      return t.shouldThrowErrorOfAnyKind( () => true )
      .finally( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.shouldThrowErrorOfAnyKind( () => { throw _.err( 1 ) } )
      .finally( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.errIs( got ), true );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.shouldThrowErrorOfAnyKind( _.Consequence().take( 1 ) )
      .finally( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.shouldThrowErrorOfAnyKind( _.Consequence().error( 'error1' ) )
      .finally( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.true( _.strHas( _.err( got ).message, 'error1' ) );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.shouldThrowErrorOfAnyKind( _.time.outError( 1 ) )
      .finally( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.errIs( got ), true );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      test.case = 'no arguments';
      return t.shouldThrowErrorOfAnyKind()
      .finally( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      test.case = 'not routines';
      return t.shouldThrowErrorOfAnyKind( 'x' )
      .finally( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.shouldThrowErrorOfAnyKind( function(){}, 13 )
      .finally( ( err, got ) =>
      {
        test.case = 'several functions';
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        done = 1;
        return null;
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
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 2 );
    test.identical( suite.report.testCheckFails, 6 );
    test.identical( suite.report.errorsArray.length, 3 );
    test.identical( done, 1 );
  }

  /* */

  function returnTest( t )
  {
    var con = _.Consequence().take( null )

    .then( ( arg ) =>
    {
      return t.mustNotThrowError( () => true )
      .finally( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( got, true );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.mustNotThrowError( () => { throw _.err( 1 ) } )
      .finally( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.mustNotThrowError( _.Consequence().take( 1 ) )
      .finally( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( got, 1 );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.mustNotThrowError( _.Consequence().error( 'error1' ) )
      .finally( ( err, got ) =>
      {
        test.true( _.strHas( _.err( err ).message, 'error1' ) );
        test.identical( got, undefined );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.mustNotThrowError( _.time.outError( 1 ) )
      .finally( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      test.case = 'no arguments';
      return t.mustNotThrowError()
      .finally( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      test.case = 'not routines';
      return t.mustNotThrowError( 'x' )
      .finally( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.mustNotThrowError( function(){}, 13 )
      .finally( ( err, got ) =>
      {
        test.case = 'several functions';
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        done = 1;
        return null;
      })
    })

    return con;
  }

}

//

function shouldMessageOnlyOnceReturn( test )
{

  var done1 = 0;
  var done = 0;
  var suite = wTestSuite
  ({
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
  });

  // _.time.outError( 0 );

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 10 );
    test.identical( suite.report.testCheckFails, 5 );
    test.identical( suite.report.errorsArray.length, 3 );
    test.identical( done, 1 );
    test.identical( done1, 1 );
    test.identical( 1, 1 );
  }

  /* */

  function returnTest( t )
  {
    var con = _.Consequence().take( null )

    .then( ( arg ) =>
    {
      return t.returnsSingleResource( () => 1 )
      .finally( ( err, got ) =>
      {
        done1 = 1;
        test.identical( err, undefined );
        test.identical( got, 1 );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.returnsSingleResource( () => { throw _.err( 1 ) } )
      .finally( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.errIs( got ), true );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.returnsSingleResource( _.Consequence().take( 1 ) )
      .finally( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( got, 1 );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.returnsSingleResource( () => _.Consequence().take( 1 ) )
      .finally( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( got, 1 );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.returnsSingleResource( _.Consequence().error( _.errAttend( 1 ) ) )
      .finally( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.errIs( got ), true );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.returnsSingleResource( () => _.Consequence().error( _.errAttend( 1 ) ) )
      .finally( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.errIs( got ), true );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      var con = _.time.out( 1, () => _.time.out( 1 ) )
      return t.returnsSingleResource( con )
      .finally( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.timerIs( got ), true );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      var con = _.time.out( 1, () => _.time.out( 1 ) )
      return t.returnsSingleResource( () => con )
      .finally( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.timerIs( got ), true );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.returnsSingleResource( _.time.outError( 1 ).tap( ( err, arg ) => _.errAttend( err ) ) )
      .finally( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.errIs( got ), true );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.returnsSingleResource( _.time.outError( 1 ).tap( ( err, arg ) => _.errAttend( err ) ) )
      .finally( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( _.errIs( got ), true );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      var con = _.Consequence({ capacity : 2 })
      .take( 1 )
      .take( 2 );
      return t.returnsSingleResource( con )
      .finally( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      var con = _.Consequence({ capacity : 2 })
      .take( 1 )
      .take( 2 );
      return t.returnsSingleResource( () => con )
      .finally( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      test.case = 'no arguments';
      return t.returnsSingleResource()
      .finally( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      test.case = 'not routines';
      return t.returnsSingleResource( 'x' )
      .finally( ( err, got ) =>
      {
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        return null;
      })
    })

    .then( ( arg ) =>
    {
      return t.returnsSingleResource( function(){}, 13 )
      .finally( ( err, got ) =>
      {
        test.case = 'several functions';
        test.identical( _.errIs( err ), true );
        test.identical( got, undefined );
        done = 1;
        return null;
      })
    })

    return con;
  }

}

shouldMessageOnlyOnceReturn.timeOut = 30000;

//

function chainedShould( test )
{
  let context = this;
  let con = _.Consequence().take( null );

  /* qqq : too complex. think how to write simpler alternative test routines */

  var iterations =
  [

    {
      method : 'shouldThrowErrorOfAnyKind',
      throwingError : 'sync',
    },

    {
      method : 'shouldThrowErrorOfAnyKind',
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
      method : 'returnsSingleResource',
      throwingError : 0,
    },

  ]

  for( var i = 0 ; i < iterations.length ; i++ )
  {
    con.then( _.routineSeal( this, _chainedShould, [ test, iterations[ i ] ] ) );
  }

  return con;

  /* */

  function _chainedShould( test, o )
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

      return new _.Consequence().take( null )
      .finally( function()
      {

        test.case = prefix + 'beginning of the test routine';
        counter.acheck = counter.testRoutine.checkCurrent();
        test.identical( counter.acheck.checkIndex, 1 );
        test.identical( t.suite.report.testCheckPasses, 0 );
        test.identical( t.suite.report.testCheckFails, 0 );

        var con = _.time.out( 50, function()
        {
          test.case = prefix + 'give the first message';
          test.true( 1 );
          if( o.throwingError === 'async' )
          throw _.err( 'async error' );
          else if( o.throwingError === 'sync' )
          t[ method ]( function(){ throw _.err( 'sync error' ) } );
          return null;
        });

        if( o.throwingError === 'sync' )
        return con;
        else
        return t[ method ]( con );
      })
      .finally( function()
      {

        test.case = prefix + 'first ' + method + ' done';
        counter.acheck = counter.testRoutine.checkCurrent();
        test.identical( counter.acheck.checkIndex, 2 );
        test.identical( t.suite.report.testCheckPasses, 1 );
        test.identical( t.suite.report.testCheckFails, 0 );

        var con = _.time.out( 50, function()
        {
          test.case = prefix + 'give the second message';
          test.true( 1 );
          if( o.throwingError === 'async' )
          throw _.err( 'async error' );
          else if( o.throwingError === 'sync' )
          t[ method ]( function(){ throw _.err( 'sync error' ) } );
          return null;
        });

        if( o.throwingError === 'sync' )
        return con;
        else
        return t[ method ]( con );
      })
      .finally( function()
      {

        test.case = prefix + 'second ' + method + ' done';
        counter.acheck = counter.testRoutine.checkCurrent();
        test.identical( counter.acheck.checkIndex, 3 );
        test.identical( t.suite.report.testCheckPasses, 2 );
        test.identical( t.suite.report.testCheckFails, 0 );

        return null;
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

        var result = _.time.out( 50, function()
        {

          test.case = prefix + 'first timeout of the included test routine ';

          test.identical( t.suite.report.testCheckPasses, 2 );
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

          return null;
        });

        return result;
      }

      function second()
      {
        return _.time.out( 50, function()
        {
          test.case = prefix + 'first ' + method + ' done';

          test.identical( t.suite.report.testCheckPasses, 3 );
          test.identical( t.suite.report.testCheckFails, 0 );

          if( o.throwingError === 'sync' )
          t[ method ]( function(){ throw _.err( 'sync error' ) } );

          counter.acheck = counter.testRoutine.checkCurrent();
          test.identical( counter.acheck.checkIndex, 3 );

          if( o.throwingError === 'async' )
          t[ method ]( _.time.outError( 50 ).tap( ( err, arg ) => _.errAttend( err ) ) );
          else if( !o.throwingError )
          t[ method ]( _.time.out( 50 ) );
          else
          t.identical( 1, 1 );

          if( o.throwingError === 'async' )
          throw _.err( 'async error' );

          return null;
        });
      }

    };

    /* */

    var suite = wTestSuite
    ({
      tests : { row, include },
      override : this.notTakingIntoAccount,
      ignoringTesterOptions : 1,
      name : _.introspector.location().filePath + '/' + method + '/' + o.throwingError,
    });

    if( suite.on )
    suite.on( 'routineEnd', function( e )
    {

      if( e.testRoutine.routine.name === 'row' )
      {
        test.case = 'checking outcomes';
        counter.acheck = counter.testRoutine.checkCurrent();
        test.identical( counter.acheck.checkIndex, 3 );
        test.identical( suite.report.testCheckPasses, 2 );
        test.identical( suite.report.testCheckFails, 0 );
      }

    });

    /* */

    return suite.run()
    .finally( function( err, data )
    {

      test.case = 'checking outcomes';

      counter.acheck = counter.testRoutine.checkCurrent();
      test.identical( counter.acheck.checkIndex, 4 );
      test.identical( suite.report.testCheckPasses, o.throwingError === 'sync' ? 5 : 4 ); /* yyy */
      test.identical( suite.report.testCheckFails, 0 );

      if( err )
      throw err;

      return null;
    });

  }

}

chainedShould.timeOut = 30000;

// --
// return
// --

function isReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 2 );
    test.identical( suite.report.testCheckFails, 9 );
    test.identical( suite.report.errorsArray.length, 7 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {

    var got = t.true( 1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.true( 0 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.true( true );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.true( false );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'not bool-like, string';

    var got = t.true( '1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'not bool-like, map';

    var got = t.true( {} );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'not bool-like, array';

    var got = t.true( [] );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'not bool-like, routine';

    var got = t.true( t.true );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.true( true, false );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'no arguments';

    var got = t.true();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.true( { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

  }

}

//

function isNotReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 2 );
    test.identical( suite.report.testCheckFails, 9 );
    test.identical( suite.report.errorsArray.length, 7 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {

    var got = t.false( 1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.false( 0 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.false( true );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.false( false );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    test.case = 'not bool-like, string';

    var got = t.false( '1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'not bool-like, map';

    var got = t.false( {} );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'not bool-like, array';

    var got = t.false( [] );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'not bool-like, routine';

    var got = t.false( t.false );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.false( true, false );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'no arguments';

    var got = t.false();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    var got = t.false( { a : 1 }, { a : 1 } );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

  }

}

//

function identicalReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 7 );
    test.identical( suite.report.testCheckFails, 8 );
    test.identical( suite.report.errorsArray.length, 2 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {

    var got = t.identical( 1, 1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.identical( 1, 2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.identical( 1, '1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.identical( '1', '1' );
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

    var got = t.identical( d1, d2 );
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

    var got = t.identical( test, t );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

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
  }

}

//

function notIdenticalReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
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
    var got = t.notIdentical( 1, 1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notIdentical( 1, '1' );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notIdentical( '1', '1' );
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

    var got = t.notIdentical( d1, d2 );
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

    var got = t.notIdentical( test, t );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

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
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 13 );
    test.identical( suite.report.testCheckFails, 16 );
    test.identical( suite.report.errorsArray.length, 5 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {

    var got = t.equivalent( 1, 1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.equivalent( 1, 2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.equivalent( 1, '1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.equivalent( '1', 1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.equivalent( '1', '1' );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );

    var got = t.equivalent( d1, d2 );
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

    var got = t.equivalent( test, t );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.equivalent( t.notIdentical, t.notIdentical );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    t.suite.accuracy = 0.1;
    var got = t.equivalent( 1, 1.05 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    test.true( t.suite.accuracy === t.accuracy );
    test.true( _.numberIs( t.suite.accuracy ) );
    test.true( _.numberIs( t.accuracy ) );

    t.suite.accuracy = null;
    test.true( t.suite.accuracy === t.accuracy );
    test.true( _.numberIs( t.suite.accuracy ) );
    test.true( _.numberIs( t.accuracy ) );

    /* */

    t.accuracy = 0.01;
    var got = t.equivalent( 1, 1.05 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.true( t.suite.accuracy < t.accuracy );
    test.true( _.numberIs( t.suite.accuracy ) );
    test.true( _.numberIs( t.accuracy ) );

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

    test.true( t.suite.accuracy === t.accuracy );
    test.true( _.numberIs( t.suite.accuracy ) );
    test.true( _.numberIs( t.accuracy ) );

    /* */

    test.case = 'no arguments';

    var got = t.equivalent();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    t.equivalent( { a : 1 }, { a : 1 }, { a : 1 } );
    t.equivalent( 1.05, 1, null )
    t.equivalent( 1.05, 1, 'x' )
    t.equivalent( 1.05, 1, [] )

  }

}

equivalentReturn.timeOut = 30000;

//

function notEquivalentReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 10 );
    test.identical( suite.report.testCheckFails, 18 );
    test.identical( suite.report.errorsArray.length, 5 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {

    var got = t.notEquivalent( 1, 1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notEquivalent( 1, 2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notEquivalent( 1, '1' );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notEquivalent( '1', 1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notEquivalent( '1', '1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );
    var got = t.notEquivalent( d1, d2 );
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

    var got = t.notEquivalent( test, t );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.notEquivalent( t.notIdentical, t.notIdentical );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    t.suite.accuracy = 0.1;
    var got = t.notEquivalent( 1, 1.05 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.true( t.suite.accuracy === t.accuracy );
    test.true( _.numberIs( t.suite.accuracy ) );
    test.true( _.numberIs( t.accuracy ) );

    t.suite.accuracy = null;
    test.true( t.suite.accuracy === t.accuracy );
    test.true( _.numberIs( t.suite.accuracy ) );
    test.true( _.numberIs( t.accuracy ) );

    /* */

    t.accuracy = 0.01;
    var got = t.notEquivalent( 1, 1.05 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    test.true( t.suite.accuracy < t.accuracy );
    test.true( _.numberIs( t.suite.accuracy ) );
    test.true( _.numberIs( t.accuracy ) );

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

    test.true( t.suite.accuracy === t.accuracy );
    test.true( _.numberIs( t.suite.accuracy ) );
    test.true( _.numberIs( t.accuracy ) );

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

    t.notEquivalent( { a : 1 }, { a : 1 }, { a : 1 } );
    t.notEquivalent( 1.05, 1, null )
    t.notEquivalent( 1.05, 1, 'x' )
    t.notEquivalent( 1.05, 1, [] )

  }

}

//

function containReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 6 );
    test.identical( suite.report.testCheckFails, 12 );
    test.identical( suite.report.errorsArray.length, 2 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {
    var got = t.contains( 1, 1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( 1, 2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( 1, '1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( '1', 1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( '1', '1' );
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

    var got = t.contains( [ 1, 2, 3, 4 ], 5 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( [ 1, 2, 3, 4 ], 4 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( [ 1, 2, 3, 4 ], [ 4, 5 ] );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.contains( [ 1, 2, 3, 4 ], [ 3, 4 ] );
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

function ilReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 7 );
    test.identical( suite.report.testCheckFails, 8 );
    test.identical( suite.report.errorsArray.length, 2 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {

    var got = t.il( 1, 1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.il( 1, 2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.il( 1, '1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.il( '1', '1' );
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

    var got = t.il( d1, d2 );
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

    var got = t.il( test, t );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

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
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
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
    var got = t.ni( 1, 1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ni( 1, '1' );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ni( '1', '1' );
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

    var got = t.ni( d1, d2 );
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

    var got = t.ni( test, t );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

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
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 13 );
    test.identical( suite.report.testCheckFails, 16 );
    test.identical( suite.report.errorsArray.length, 5 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {

    var got = t.et( 1, 1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.et( 1, 2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.et( 1, '1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.et( '1', 1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.et( '1', '1' );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );

    var got = t.et( d1, d2 );
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

    var got = t.et( test, t );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.et( t.notIdentical, t.notIdentical );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    t.suite.accuracy = 0.1;
    var got = t.et( 1, 1.05 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    test.true( t.suite.accuracy === t.accuracy );
    test.true( _.numberIs( t.suite.accuracy ) );
    test.true( _.numberIs( t.accuracy ) );

    t.suite.accuracy = null;
    test.true( t.suite.accuracy === t.accuracy );
    test.true( _.numberIs( t.suite.accuracy ) );
    test.true( _.numberIs( t.accuracy ) );

    /* */

    t.accuracy = 0.01;
    var got = t.et( 1, 1.05 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.true( t.suite.accuracy < t.accuracy );
    test.true( _.numberIs( t.suite.accuracy ) );
    test.true( _.numberIs( t.accuracy ) );

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

    test.true( t.suite.accuracy === t.accuracy );
    test.true( _.numberIs( t.suite.accuracy ) );
    test.true( _.numberIs( t.accuracy ) );

    /* */

    test.case = 'no arguments';

    var got = t.et();
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.case = 'extra arguments';

    t.et( { a : 1 }, { a : 1 }, { a : 1 } );
    t.et( 1.05, 1, null )
    t.et( 1.05, 1, 'x' )
    t.et( 1.05, 1, [] )

  }

}

//

function neReturn( test )
{

  var suite = wTestSuite
  ({
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 10 );
    test.identical( suite.report.testCheckFails, 18 );
    test.identical( suite.report.errorsArray.length, 5 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );
  }

  /* */

  function returnTest( t )
  {

    var got = t.ne( 1, 1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ne( 1, 2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ne( 1, '1' );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ne( '1', 1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ne( '1', '1' );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );
    var got = t.ne( d1, d2 );
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

    var got = t.ne( test, t );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ne( t.notIdentical, t.notIdentical );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    t.suite.accuracy = 0.1;
    var got = t.ne( 1, 1.05 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    test.true( t.suite.accuracy === t.accuracy );
    test.true( _.numberIs( t.suite.accuracy ) );
    test.true( _.numberIs( t.accuracy ) );

    t.suite.accuracy = null;
    test.true( t.suite.accuracy === t.accuracy );
    test.true( _.numberIs( t.suite.accuracy ) );
    test.true( _.numberIs( t.accuracy ) );

    /* */

    t.accuracy = 0.01;
    var got = t.ne( 1, 1.05 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    test.true( t.suite.accuracy < t.accuracy );
    test.true( _.numberIs( t.suite.accuracy ) );
    test.true( _.numberIs( t.accuracy ) );

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

    test.true( t.suite.accuracy === t.accuracy );
    test.true( _.numberIs( t.suite.accuracy ) );
    test.true( _.numberIs( t.accuracy ) );

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

    t.ne( { a : 1 }, { a : 1 }, { a : 1 } );

    t.ne( 1.05, 1, null )

    t.ne( 1.05, 1, 'x' )

    t.ne( 1.05, 1, [] )

  }

}

//

function gtReturn( test )
{

  test.case = 'trivial';

  var got = test.gt( 2, 1 );
  test.identical( got, true );

  test.case = 'suite';

  var suite = wTestSuite
  ({
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 3 );
    test.identical( suite.report.testCheckFails, 10 );
    test.identical( suite.report.errorsArray.length, 3 );
    if( suite.report.errorsArray.length )
    console.log( suite.report.errorsArray[ 0 ] );

    test.case = 'trivial';

    var got = test.gt( 2, 1 );
    test.identical( got, true );

  }

  /* */

  function returnTest( t )
  {

    var got = t.gt( 1, 1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.gt( 1, 2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.gt( 2, 1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.gt( 1.01, 1.01 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.gt( 1.01, 1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.gt( 1.01, 1.02 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );

    var got = t.gt( d1, d2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );

    var got = t.gt( d1, d2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );
    d1.setSeconds( 20 );
    d2.setSeconds( 30 );

    var got = t.gt( d1, d2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );
    d1.setSeconds( 20 );
    d2.setSeconds( 30 );

    var got = t.gt( d2, d1 );
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
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 7 );
    test.identical( suite.report.testCheckFails, 6 );
    test.identical( suite.report.errorsArray.length, 3 );
    if( suite.report.errorsArray.length )
    console.log( suite.report.errorsArray[ 0 ] );

    test.case = 'trivial';

    var got = test.ge( 2, 1 );
    test.identical( got, true );
    var got = test.ge( 2, 2 );
    test.identical( got, true );

  }

  /* */

  function returnTest( t )
  {
    var got = t.ge( 1, 1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ge( 1, 2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ge( 2, 1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ge( 1.01, 1.01 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ge( 1.01, 1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.ge( 1.01, 1.02 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );

    var got = t.ge( d1, d2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );

    var got = t.ge( d1, d2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );
    d1.setSeconds( 20 );
    d2.setSeconds( 30 );

    var got = t.ge( d1, d2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );
    d1.setSeconds( 20 );
    d2.setSeconds( 30 );

    var got = t.ge( d2, d1 );
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
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 3 );
    test.identical( suite.report.testCheckFails, 10 );
    test.identical( suite.report.errorsArray.length, 3 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );

    test.case = 'trivial';

    var got = test.lt( 2, 3 );
    test.identical( got, true );

  }

  /* */

  function returnTest( t )
  {
    var got = t.lt( 1, 1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.lt( 1, 2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.lt( 2, 1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.lt( 1.01, 1.01 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.lt( 1.01, 1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.lt( 1.01, 1.02 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );

    var got = t.lt( d1, d2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );

    var got = t.lt( d1, d2 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );
    d1.setSeconds( 20 );
    d2.setSeconds( 30 );

    var got = t.lt( d1, d2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );
    d1.setSeconds( 20 );
    d2.setSeconds( 30 );

    var got = t.lt( d2, d1 );
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
    tests : { returnTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
    name : test.name,
    onSuiteEnd,
  });

  return suite.run();

  /* */

  function onSuiteEnd( t )
  {
    test.identical( suite.report.testCheckPasses, 7 );
    test.identical( suite.report.testCheckFails, 6 );
    test.identical( suite.report.errorsArray.length, 3 );
    if( suite.report.errorsArray.length )
    logger.log( suite.report.errorsArray[ 0 ] );

    test.case = 'trivial';

    var got = test.le( 2, 3 );
    test.identical( got, true );
    var got = test.le( 2, 2 );
    test.identical( got, true );

  }

  /* */

  function returnTest( t )
  {
    var got = t.le( 1, 1 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.le( 1, 2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.le( 2, 1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.le( 1.01, 1.01 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.le( 1.01, 1 );
    test.identical( got, false );
    test.identical( _.boolIs( got ), true );

    /* */

    var got = t.le( 1.01, 1.02 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1 );

    var got = t.le( d1, d2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );

    var got = t.le( d1, d2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );
    d1.setSeconds( 20 );
    d2.setSeconds( 30 );

    var got = t.le( d1, d2 );
    test.identical( got, true );
    test.identical( _.boolIs( got ), true );

    /* */

    var d1 = new Date( Date.now() );
    var d2 = new Date( d1.getTime() );
    d1.setSeconds( 20 );
    d2.setSeconds( 30 );

    var got = t.le( d2, d1 );
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
// grouping
// --

function testCase( test )
{
  let testRoutine;
  let visited = [];

  function routine1( t )
  {
    testRoutine = t;

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = 'abc';

    test.identical( t.case, 'abc' );
    test.identical( t.group, 'abc' );
    test.identical( t._groupsStack, [ 'abc' ] );
    test.identical( t._groupOpenedWithCase, 1 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.identical( 0, 0 );

    test.identical( t.case, 'abc' );
    test.identical( t.group, 'abc' );
    test.identical( t._groupsStack, [ 'abc' ] );
    test.identical( t._groupOpenedWithCase, 1 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.identical( 0, 1 );

    test.identical( t.case, 'abc' );
    test.identical( t.group, 'abc' );
    test.identical( t._groupsStack, [ 'abc' ] );
    test.identical( t._groupOpenedWithCase, 1 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 1 );

    t.case = 'def';

    test.identical( t.case, 'def' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'def' ] );
    test.identical( t._groupOpenedWithCase, 1 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.identical( 0, 0 );

    test.identical( t.case, 'def' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'def' ] );
    test.identical( t._groupOpenedWithCase, 1 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = null;

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = null;

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.identical( 0, 0 );

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = null;

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = '';

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = 'def';

    test.identical( t.case, 'def' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'def' ] );
    test.identical( t._groupOpenedWithCase, 1 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.identical( 0, 0 );

    test.identical( t.case, 'def' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'def' ] );
    test.identical( t._groupOpenedWithCase, 1 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = '';

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = '';

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    visited.push( 'routine1' );
  }

  var suite1 = wTestSuite
  ({
    tests : { routine1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  return suite1.run()
  .tap( () =>
  {
    test.identical( visited, [ 'routine1' ] );
    test.identical( testRoutine._groupError, null );

    var exp =
    {
      'reason' : null,
      'outcome' : false,
      'errorsArray' : [],
      'exitCode' : 0,
      'testCheckPasses' : 4,
      'testCheckFails' : 1,
      'testCasePasses' : 2,
      'testCaseFails' : 1,
    }
    var got = _.mapBut( testRoutine.report, { timeSpent : null } );
    test.identical( got, exp );

    var exp =
    {
      'outcome' : false,
      'errorsArray' : [],
      'exitCode' : 0,
      'testCheckPasses' : 4,
      'testCheckFails' : 1,
      'testCasePasses' : 2,
      'testCaseFails' : 1,
      'testRoutinePasses' : 0,
      'testRoutineFails' : 1
    }
    var got = _.mapBut( suite1.report, { timeSpent : null } );
    test.identical( got, exp );

  });
}

//

function testsGroupSameNameError( test )
{
  let testRoutine;
  let visited = [];

  function routine1( t )
  {
    testRoutine = t;

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.open( 'def' );
    t.identical( 0, 0 );

    test.identical( t.case, '' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'def' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.open( 'def' );

    t.identical( 0, 0 );

    test.identical( t.case, '' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'def', 'def' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 1 );

    t.close( 'def' );

    visited.push( 'routine1' );
  }

  var suite1 = wTestSuite
  ({
    tests : { routine1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  return suite1.run()
  .tap( () =>
  {
    test.identical( visited, [ 'routine1' ] );
    var exp = `Attempt to open group "def". Group with the same name is already opened. Might be you meant to close it?`;
    test.identical( String( testRoutine._groupError ), exp );

    var exp =
    {
      'reason' : 'grouping error',
      'outcome' : false,
      'errorsArray' : [ `Attempt to open group "def". Group with the same name is already opened. Might be you meant to close it?` ],
      'exitCode' : 0,
      'testCheckPasses' : 2,
      'testCheckFails' : 1,
      'testCasePasses' : 0,
      'testCaseFails' : 1,
    }
    var got = _.mapBut( testRoutine.report, { timeSpent : null } );
    got.errorsArray[ 0 ] = String( got.errorsArray[ 0 ] );
    test.identical( got, exp );

    var exp =
    {
      'outcome' : false,
      'errorsArray' : [ `Attempt to open group "def". Group with the same name is already opened. Might be you meant to close it?` ],
      'exitCode' : 0,
      'testCheckPasses' : 2,
      'testCheckFails' : 1,
      'testCasePasses' : 0,
      'testCaseFails' : 1,
      'testRoutinePasses' : 0,
      'testRoutineFails' : 1,
    }
    var got = _.mapBut( suite1.report, { timeSpent : null } );
    got.errorsArray[ 0 ] = String( got.errorsArray[ 0 ] );
    test.identical( got, exp );

  });

}

//

function testsGroupDiscrepancyError( test )
{
  let testRoutine;
  let visited = [];

  function routine1( t )
  {
    testRoutine = t;

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.open( 'def' );
    t.identical( 0, 0 );

    test.identical( t.case, '' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'def' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.close( 'def2' );

    visited.push( 'routine1' );
  }

  var suite1 = wTestSuite
  ({
    tests : { routine1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  return suite1.run()
  .tap( () =>
  {
    test.identical( visited, [ 'routine1' ] );
    var exp =
    `Discrepancy!. Attempt to close not the topmost tests group.\n`
    + `Attempt to close "def2", but current tests group is "def". Might be you want to close it first.`;
    test.identical( String( testRoutine._groupError ), exp );

    var msg =
    `Discrepancy!. Attempt to close not the topmost tests group.\n`
    + `Attempt to close "def2", but current tests group is "def". Might be you want to close it first.`;
    var exp =
    {
      'reason' : 'grouping error',
      'outcome' : false,
      'errorsArray' : [ msg ],
      'exitCode' : 0,
      'testCheckPasses' : 1,
      'testCheckFails' : 1,
      'testCasePasses' : 0,
      'testCaseFails' : 1,
    }
    var got = _.mapBut( testRoutine.report, { timeSpent : null } );
    got.errorsArray[ 0 ] = String( got.errorsArray[ 0 ] );
    test.identical( got, exp );

    var msg =
    `Discrepancy!. Attempt to close not the topmost tests group.\n`
    + `Attempt to close "def2", but current tests group is "def". Might be you want to close it first.`;
    var exp =
    {
      'outcome' : false,
      'errorsArray' : [ msg ],
      'exitCode' : 0,
      'testCheckPasses' : 1,
      'testCheckFails' : 1,
      'testCasePasses' : 0,
      'testCaseFails' : 1,
      'testRoutinePasses' : 0,
      'testRoutineFails' : 1,
    }
    var got = _.mapBut( suite1.report, { timeSpent : null } );
    got.errorsArray[ 0 ] = String( got.errorsArray[ 0 ] );
    test.identical( got, exp );

  });

}

//

function testsGroupSingleLevel( test )
{
  let testRoutine;
  let visited = [];

  function routine1( t )
  {
    testRoutine = t;

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.open( 'abc' );

    test.identical( t.case, '' );
    test.identical( t.group, 'abc' );
    test.identical( t._groupsStack, [ 'abc' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.identical( 0, 0 );

    test.identical( t.case, '' );
    test.identical( t.group, 'abc' );
    test.identical( t._groupsStack, [ 'abc' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.identical( 0, 1 );

    test.identical( t.case, '' );
    test.identical( t.group, 'abc' );
    test.identical( t._groupsStack, [ 'abc' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 1 );

    t.close( 'abc' );
    t.open( 'def' );

    test.identical( t.case, '' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'def' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.identical( 0, 0 );

    test.identical( t.case, '' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'def' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.close( 'def' );

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.identical( 0, 0 );

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = null;

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.identical( 0, 1 );

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 1 );

    t.case = '';

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 1 );

    t.open( 'def' );

    test.identical( t.case, '' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'def' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.identical( 0, 0 );

    test.identical( t.case, '' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'def' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = null;

    test.identical( t.case, '' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'def' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = null;

    test.identical( t.case, '' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'def' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.identical( 0, 0 );

    test.identical( t.case, '' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'def' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 2 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = '';

    test.identical( t.case, '' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'def' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 2 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = '';

    test.identical( t.case, '' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'def' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 2 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.open( 'def2' );

    test.identical( t.case, '' );
    test.identical( t.group, 'def2' );
    test.identical( t._groupsStack, [ 'def', 'def2' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.identical( 0, 0 );

    test.identical( t.case, '' );
    test.identical( t.group, 'def2' );
    test.identical( t._groupsStack, [ 'def', 'def2' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.close( 'def2' );

    test.identical( t.case, '' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'def' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.close( 'def' );

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    visited.push( 'routine1' );
  }

  var suite1 = wTestSuite
  ({
    tests : { routine1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  return suite1.run()
  .tap( () =>
  {
    test.identical( visited, [ 'routine1' ] );
    test.identical( testRoutine._groupError, null );

    var exp =
    {
      'reason' : null,
      'outcome' : false,
      'errorsArray' : [],
      'exitCode' : 0,
      'testCheckPasses' : 6,
      'testCheckFails' : 2,
      'testCasePasses' : 2,
      'testCaseFails' : 1,
    }
    var got = _.mapBut( testRoutine.report, { timeSpent : null } );
    test.identical( got, exp );

    var exp =
    {
      'outcome' : false,
      'errorsArray' : [],
      'exitCode' : 0,
      'testCheckPasses' : 6,
      'testCheckFails' : 2,
      'testCasePasses' : 2,
      'testCaseFails' : 1,
      'testRoutinePasses' : 0,
      'testRoutineFails' : 1,
    }
    var got = _.mapBut( suite1.report, { timeSpent : null } );
    test.identical( got, exp );

  });

}

//

function testsGroupMultipleLevels( test )
{
  let testRoutine;
  let visited = [];

  function routine1( t )
  {
    testRoutine = t;

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.open( 'abc' );

    test.identical( t.case, '' );
    test.identical( t.group, 'abc' );
    test.identical( t._groupsStack, [ 'abc' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.identical( 0, 0 );

    test.identical( t.case, '' );
    test.identical( t.group, 'abc' );
    test.identical( t._groupsStack, [ 'abc' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.open( 'def' );

    test.identical( t.case, '' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'abc', 'def' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.identical( 0, 1 );

    test.identical( t.case, '' );
    test.identical( t.group, 'def' );
    test.identical( t._groupsStack, [ 'abc', 'def' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 1 );

    t.close( 'def' );

    test.identical( t.case, '' );
    test.identical( t.group, 'abc' );
    test.identical( t._groupsStack, [ 'abc' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.identical( 0, 1 );

    test.identical( t.case, '' );
    test.identical( t.group, 'abc' );
    test.identical( t._groupsStack, [ 'abc' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 1 );

    t.close( 'abc' );

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.identical( 0, 1 );

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 1 );

    visited.push( 'routine1' );
  }

  var suite1 = wTestSuite
  ({
    tests : { routine1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  return suite1.run()
  .tap( () =>
  {

    test.identical( visited, [ 'routine1' ] );
    test.identical( testRoutine._groupError, null );

    var exp =
    {
      'reason' : null,
      'outcome' : false,
      'errorsArray' : [],
      'exitCode' : 0,
      'testCheckPasses' : 1,
      'testCheckFails' : 3,
      'testCasePasses' : 0,
      'testCaseFails' : 2,
    }
    var got = _.mapBut( testRoutine.report, { timeSpent : null } );
    test.identical( got, exp );

    var exp =
    {
      'outcome' : false,
      'errorsArray' : [],
      'exitCode' : 0,
      'testCheckPasses' : 1,
      'testCheckFails' : 3,
      'testCasePasses' : 0,
      'testCaseFails' : 2,
      'testRoutinePasses' : 0,
      'testRoutineFails' : 1,
    }
    var got = _.mapBut( suite1.report, { timeSpent : null } );
    test.identical( got, exp );

  });
}

//

function testsGroupTestCaseSingleLevel( test )
{
  let testRoutine;
  let visited = [];

  function routine1( t )
  {
    testRoutine = t;

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.open( 'group1' );
    t.identical( 1, 1 );

    test.identical( t.case, '' );
    test.identical( t.group, 'group1' );
    test.identical( t._groupsStack, [ 'group1' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = 'case1';
    t.identical( 1, 1 );

    test.identical( t.case, 'case1' );
    test.identical( t.group, 'case1' );
    test.identical( t._groupsStack, [ 'group1', 'case1' ] );
    test.identical( t._groupOpenedWithCase, 1 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = 'case2';
    t.identical( 1, 1 );

    test.identical( t.case, 'case2' );
    test.identical( t.group, 'case2' );
    test.identical( t._groupsStack, [ 'group1', 'case2' ] );
    test.identical( t._groupOpenedWithCase, 1 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.close( 'group1' );
    t.identical( 1, 1 );

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    visited.push( 'routine1' );
  }

  var suite1 = wTestSuite
  ({
    tests : { routine1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  return suite1.run()
  .tap( () =>
  {

    test.identical( visited, [ 'routine1' ] );
    test.identical( testRoutine._groupError, null );

    var exp =
    {
      'reason' : null,
      'outcome' : true,
      'errorsArray' : [],
      'exitCode' : 0,
      'testCheckPasses' : 4,
      'testCheckFails' : 0,
      'testCasePasses' : 2,
      'testCaseFails' : 0,
    }
    var got = _.mapBut( testRoutine.report, { timeSpent : null } );
    test.identical( got, exp );

    var exp =
    {
      'outcome' : true,
      'errorsArray' : [],
      'exitCode' : 0,
      'testCheckPasses' : 4,
      'testCheckFails' : 0,
      'testCasePasses' : 2,
      'testCaseFails' : 0,
      'testRoutinePasses' : 1,
      'testRoutineFails' : 0
    }
    var got = _.mapBut( suite1.report, { timeSpent : null } );
    test.identical( got, exp );

  });
}

//

function testsGroupTestCaseSameName( test )
{
  let testRoutine;
  let visited = [];

  function routine1( t )
  {
    testRoutine = t;

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = 'case1';
    t.identical( 1, 1 );

    test.identical( t.case, 'case1' );
    test.identical( t.group, 'case1' );
    test.identical( t._groupsStack, [ 'case1' ] );
    test.identical( t._groupOpenedWithCase, 1 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.open( 'case1' );
    t.identical( 1, 1 );

    test.identical( t.case, '' );
    test.identical( t.group, 'case1' );
    test.identical( t._groupsStack, [ 'case1' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = 'case1';
    t.identical( 1, 1 );

    test.identical( t.case, 'case1' );
    test.identical( t.group, 'case1' );
    test.identical( t._groupsStack, [ 'case1', 'case1' ] );
    test.identical( t._groupOpenedWithCase, 1 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.close( 'case1' );
    t.identical( 1, 1 );

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    visited.push( 'routine1' );
  }

  var suite1 = wTestSuite
  ({
    tests : { routine1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  return suite1.run()
  .tap( () =>
  {

    test.identical( visited, [ 'routine1' ] );
    test.identical( testRoutine._groupError, null );

    var exp =
    {
      'reason' : null,
      'outcome' : true,
      'errorsArray' : [],
      'exitCode' : 0,
      'testCheckPasses' : 4,
      'testCheckFails' : 0,
      'testCasePasses' : 2,
      'testCaseFails' : 0,
    }
    var got = _.mapBut( testRoutine.report, { timeSpent : null } );
    test.identical( got, exp );

    var exp =
    {
      'outcome' : true,
      'errorsArray' : [],
      'exitCode' : 0,
      'testCheckPasses' : 4,
      'testCheckFails' : 0,
      'testCasePasses' : 2,
      'testCaseFails' : 0,
      'testRoutinePasses' : 1,
      'testRoutineFails' : 0
    }
    var got = _.mapBut( suite1.report, { timeSpent : null } );
    test.identical( got, exp );

  });
}

//

function testsGroupAfterTestCase( test )
{
  let testRoutine;
  let visited = [];

  function routine1( t )
  {
    testRoutine = t;

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = 'case1';
    t.identical( 1, 1 );

    test.identical( t.case, 'case1' );
    test.identical( t.group, 'case1' );
    test.identical( t._groupsStack, [ 'case1' ] );
    test.identical( t._groupOpenedWithCase, 1 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.open( 'group1' );
    t.identical( 1, 1 );

    test.identical( t.case, '' );
    test.identical( t.group, 'group1' );
    test.identical( t._groupsStack, [ 'group1' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = 'case2';
    t.identical( 1, 1 );

    test.identical( t.case, 'case2' );
    test.identical( t.group, 'case2' );
    test.identical( t._groupsStack, [ 'group1', 'case2' ] );
    test.identical( t._groupOpenedWithCase, 1 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.close( 'group1' );

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    visited.push( 'routine1' );
  }

  var suite1 = wTestSuite
  ({
    tests : { routine1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  return suite1.run()
  .tap( () =>
  {

    test.identical( visited, [ 'routine1' ] );
    test.identical( testRoutine._groupError, null );

    var exp =
    {
      'reason' : null,
      'outcome' : true,
      'errorsArray' : [],
      'exitCode' : 0,
      'testCheckPasses' : 3,
      'testCheckFails' : 0,
      'testCasePasses' : 2,
      'testCaseFails' : 0,
    }
    var got = _.mapBut( testRoutine.report, { timeSpent : null } );
    test.identical( got, exp );

    var exp =
    {
      'outcome' : true,
      'errorsArray' : [],
      'exitCode' : 0,
      'testCheckPasses' : 3,
      'testCheckFails' : 0,
      'testCasePasses' : 2,
      'testCaseFails' : 0,
      'testRoutinePasses' : 1,
      'testRoutineFails' : 0
    }
    var got = _.mapBut( suite1.report, { timeSpent : null } );
    test.identical( got, exp );

  });
}

//

function testsGroupTestCaseMultipleLevels( test )
{
  let testRoutine;
  let visited = [];

  function routine1( t )
  {
    testRoutine = t;

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 0 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.open( 'group1' );
    t.identical( 1, 1 );

    test.identical( t.case, '' );
    test.identical( t.group, 'group1' );
    test.identical( t._groupsStack, [ 'group1' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.open( 'group2' );
    t.identical( 1, 1 );

    test.identical( t.case, '' );
    test.identical( t.group, 'group2' );
    test.identical( t._groupsStack, [ 'group1', 'group2' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = 'case1';
    t.identical( 1, 1 );

    test.identical( t.case, 'case1' );
    test.identical( t.group, 'case1' );
    test.identical( t._groupsStack, [ 'group1', 'group2', 'case1' ] );
    test.identical( t._groupOpenedWithCase, 1 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.case = 'case2';
    t.identical( 1, 1 );

    test.identical( t.case, 'case2' );
    test.identical( t.group, 'case2' );
    test.identical( t._groupsStack, [ 'group1', 'group2', 'case2' ] );
    test.identical( t._groupOpenedWithCase, 1 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.close( 'group2' );
    t.identical( 1, 1 );

    test.identical( t.case, '' );
    test.identical( t.group, 'group1' );
    test.identical( t._groupsStack, [ 'group1' ] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    t.close( 'group1' );
    t.identical( 1, 1 );

    test.identical( t.case, '' );
    test.identical( t.group, '' );
    test.identical( t._groupsStack, [] );
    test.identical( t._groupOpenedWithCase, 0 );
    test.identical( t._testCheckPassesOfTestCase, 1 );
    test.identical( t._testCheckFailsOfTestCase, 0 );

    visited.push( 'routine1' );
  }

  var suite1 = wTestSuite
  ({
    tests : { routine1 },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  return suite1.run()
  .tap( () =>
  {

    test.identical( visited, [ 'routine1' ] );
    test.identical( testRoutine._groupError, null );

    var exp =
    {
      'reason' : null,
      'outcome' : true,
      'errorsArray' : [],
      'exitCode' : 0,
      'testCheckPasses' : 6,
      'testCheckFails' : 0,
      'testCasePasses' : 3,
      'testCaseFails' : 0,
    }
    var got = _.mapBut( testRoutine.report, { timeSpent : null } );
    test.identical( got, exp );

    var exp =
    {
      'outcome' : true,
      'errorsArray' : [],
      'exitCode' : 0,
      'testCheckPasses' : 6,
      'testCheckFails' : 0,
      'testCasePasses' : 3,
      'testCaseFails' : 0,
      'testRoutinePasses' : 1,
      'testRoutineFails' : 0
    }
    var got = _.mapBut( suite1.report, { timeSpent : null } );
    test.identical( got, exp );

  });
}

// --
// outcome
// --

function runMultiple( test )
{
  var testRoutine;

  test.identical( 0, 0 );

  function good( t )
  {
    testRoutine = t;
    t.identical( 0, 0 );
    logger.log( 'good' );
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

function exitCode( test )
{
  var testRoutine;

  test.identical( 0, 0 );

  _.process.exitCode( 255 );

  test.identical( _.process.exitCode(), 255 );

  function good( t )
  {
    testRoutine = t;
    t.identical( 0, 0 );
    logger.log( 'good' );
  }

  var suite1 = wTestSuite
  ({
    tests : { good },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = wTester.test([ suite1 ])
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
      }
    ]
    test.contains( got, expected );

    if( err )
    throw err;
    _.process.exitCode( 0 );
    return null;
  });

  return result;
}

// --
// handler
// --

function onSuiteBeginThrowError( test )
{
  function trivial( t )
  {
    t.case = 'trivial'
    t.identical( 1, 1 );
  }

  let onSuiteBeginErr = _.err( 'onSuiteBegin: some error' );

  function onSuiteBegin()
  {
    throw onSuiteBeginErr;
  }

  let suite1 = wTestSuite
  ({
    onSuiteBegin,
    tests : { trivial },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  /* */

  var result = wTester.test([ suite1 ])
  .finally( function( err, suites )
  {
    var got = _.select( suites, '*/report' )[ 0 ];

    test.identical( got.outcome, false );
    test.identical( got.errorsArray, [ onSuiteBeginErr ] );
    test.identical( got.exitCode, 0 );
    test.identical( got.testCheckPasses, 0 );
    test.identical( got.testCheckFails, 0 );
    test.identical( got.testCasePasses, 0 );
    test.identical( got.testCaseFails, 0 );
    // test.identical( got.testCaseNumber, 0 );
    test.identical( got.testRoutinePasses, 0 );
    test.identical( got.testRoutineFails, 0 );

    _.errAttend( err );
    test.false( _.errIs( err ) );
    test.true( _.arrayIs( suites ) );

    _.process.exitCode( 0 );
    return null;
  });

  return result;
}

//

function onSuiteEndReturnsNothing( test )
{
  function trivial( t )
  {
    t.case = 'trivial'
    t.identical( 1, 1 );
  }

  function onSuiteEnd()
  {
  }

  let suite1 = wTestSuite
  ({
    onSuiteEnd,
    tests : { trivial },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  /* */

  var result = wTester.test([ suite1 ])
  .finally( function( err, suites )
  {
    var got = _.select( suites, '*/report' )[ 0 ];

    test.identical( got.outcome, true );
    test.identical( got.errorsArray.length, 0 );
    test.identical( got.exitCode, 0 );
    test.identical( got.testCheckPasses, 1 );
    test.identical( got.testCheckFails, 0 );
    test.identical( got.testCasePasses, 1 );
    test.identical( got.testCaseFails, 0 );
    test.identical( got.testRoutinePasses, 1 );
    test.identical( got.testRoutineFails, 0 );

    _.errAttend( err );
    test.false( _.errIs( err ) );
    test.true( _.arrayIs( suites ) );

    _.process.exitCode( 0 );
    return null;
  });

  return result;
}


//

function onSuiteEndThrowError( test )
{
  function trivial( t )
  {
    t.case = 'trivial'
    t.identical( 1, 1 );
  }

  let onSuiteEndErr = _.err( 'onSuiteEnd: some error' );

  function onSuiteEnd()
  {
    throw onSuiteEndErr;
  }

  let suite1 = wTestSuite
  ({
    onSuiteEnd,
    tests : { trivial },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  /* */

  var result = wTester.test([ suite1 ])
  .finally( function( err, suites )
  {
    var got = _.select( suites, '*/report' )[ 0 ];

    test.identical( got.outcome, false );
    test.identical( got.errorsArray, [ onSuiteEndErr ] );
    test.identical( got.exitCode, 0 );
    test.identical( got.testCheckPasses, 1 );
    test.identical( got.testCheckFails, 0 );
    test.identical( got.testCasePasses, 1 );
    test.identical( got.testCaseFails, 0 );
    // test.identical( got.testCaseNumber, 0 );
    test.identical( got.testRoutinePasses, 1 );
    test.identical( got.testRoutineFails, 0 );

    _.errAttend( err );
    test.false( _.errIs( err ) );
    test.true( _.arrayIs( suites ) );

    _.process.exitCode( 0 );
    return null;
  });

  return result;
}

//

function suiteEndTimeOut( test ) /* qqq : write similar test in Ext.test.s ( separate process ) */
{

  let suite1 = wTestSuite
  ({
    onSuiteEnd,
    suiteEndTimeOut : 1500,
    tests : { trivial },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  /* */

  var result = wTester.test([ suite1 ])
  .finally( function( err, suites )
  {
    var got = _.select( suites, '*/report' )[ 0 ];

    test.identical( got.outcome, false );
    test.identical( got.errorsArray.length, 1 );
    test.identical( got.errorsArray[ 0 ].reason, 'time out' );
    test.identical( got.exitCode, 0 );
    test.identical( got.testCheckPasses, 1 );
    test.identical( got.testCheckFails, 0 );
    test.identical( got.testCasePasses, 1 );
    test.identical( got.testCaseFails, 0 );
    test.identical( got.testRoutinePasses, 1 );
    test.identical( got.testRoutineFails, 0 );

    _.errAttend( err );
    test.false( _.errIs( err ) );
    test.true( _.arrayIs( suites ) );

    _.process.exitCode( 0 );

    return null;
  });

  return result;

  function trivial( t )
  {
    t.case = 'trivial'
    t.identical( 1, 1 );
  }

  function onSuiteEnd()
  {
    let con = new _.Consequence();
    return con;
  }

}

//

function onSuiteEndErrorInConsequence( test )
{
  function trivial( t )
  {
    t.case = 'trivial'
    t.identical( 1, 1 );
  }

  let ConError = _.err( 'Error from onSuiteEnd' )

  function onSuiteEnd()
  {
    let con = new _.Consequence().error( ConError );
    return con;
  }

  let suite1 = wTestSuite
  ({
    onSuiteEnd,
    tests : { trivial },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  /* */

  var result = wTester.test([ suite1 ])
  .finally( function( err, suites )
  {
    var got = _.select( suites, '*/report' )[ 0 ];

    test.identical( got.outcome, false );
    test.identical( got.errorsArray, [ ConError ] );
    test.identical( got.exitCode, 0 );
    test.identical( got.testCheckPasses, 1 );
    test.identical( got.testCheckFails, 0 );
    test.identical( got.testCasePasses, 1 );
    test.identical( got.testCaseFails, 0 );
    test.identical( got.testRoutinePasses, 1 );
    test.identical( got.testRoutineFails, 0 );

    _.errAttend( err );
    test.false( _.errIs( err ) );
    test.true( _.arrayIs( suites ) );

    _.process.exitCode( 0 );
    return null;
  });

  return result;
}

//

//

function onSuiteEndNormalConsequence( test )
{
  function trivial( t )
  {
    t.case = 'trivial'
    t.identical( 1, 1 );
  }

  function onSuiteEnd()
  {
    let con = new _.Consequence().take( 1 );
    return con;
  }

  let suite1 = wTestSuite
  ({
    onSuiteEnd,
    tests : { trivial },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  /* */

  var result = wTester.test([ suite1 ])
  .finally( function( err, suites )
  {
    var got = _.select( suites, '*/report' )[ 0 ];

    test.identical( got.outcome, true );
    test.identical( got.errorsArray.length, 0 );
    test.identical( got.exitCode, 0 );
    test.identical( got.testCheckPasses, 1 );
    test.identical( got.testCheckFails, 0 );
    test.identical( got.testCasePasses, 1 );
    test.identical( got.testCaseFails, 0 );
    test.identical( got.testRoutinePasses, 1 );
    test.identical( got.testRoutineFails, 0 );

    _.errAttend( err );
    test.false( _.errIs( err ) );
    test.true( _.arrayIs( suites ) );

    _.process.exitCode( 0 );
    return null;
  });

  return result;
}

//

function onSuiteEndDelayedConsequence( test )
{
  function trivial( t )
  {
    t.case = 'trivial'
    t.identical( 1, 1 );
  }

  function onSuiteEnd()
  {
    let con = _.time.out( 2000, () => 1 )
    return con;
  }

  let suite1 = wTestSuite
  ({
    onSuiteEnd,
    tests : { trivial },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  /* */

  var t1 = _.time.now();
  var result = wTester.test([ suite1 ])
  .finally( function( err, suites )
  {
    var t2 = _.time.now();

    test.ge( t2 - t1, 2000 );

    var got = _.select( suites, '*/report' )[ 0 ];

    test.identical( got.outcome, true );
    test.identical( got.errorsArray.length, 0 );
    test.identical( got.exitCode, 0 );
    test.identical( got.testCheckPasses, 1 );
    test.identical( got.testCheckFails, 0 );
    test.identical( got.testCasePasses, 1 );
    test.identical( got.testCaseFails, 0 );
    test.identical( got.testRoutinePasses, 1 );
    test.identical( got.testRoutineFails, 0 );

    _.errAttend( err );
    test.false( _.errIs( err ) );
    test.true( _.arrayIs( suites ) );

    _.process.exitCode( 0 );
    return null;
  });

  return result;
}

// --
// options
// --

function optionRoutine( test )
{
  let ready = _.take( null );
  let visited = [];

  /* */

  ready.then( () =>
  {
    test.case = 'all routines';

    visited = [];
    let suite1 = wTestSuite
    ({
      onSuiteEnd,
      tests : { a1, a2, b1 },
      override : this.notTakingIntoAccount,
      ignoringTesterOptions : 1,
    });

    var result = wTester.test([ suite1 ])
    .finally( function( err, suites )
    {
      var got = suites[ 0 ].report;

      test.identical( got.outcome, true );
      test.identical( got.errorsArray, [] );
      test.identical( got.exitCode, 0 );
      test.identical( got.testCheckPasses, 3 );
      test.identical( got.testCheckFails, 0 );
      test.identical( got.testCasePasses, 3 );
      test.identical( got.testCaseFails, 0 );
      // test.identical( got.testCaseNumber, 0 );
      test.identical( got.testRoutinePasses, 3 );
      test.identical( got.testRoutineFails, 0 );

      _.errAttend( err );
      test.false( _.errIs( err ) );
      test.true( _.arrayIs( suites ) );
      test.identical( visited, [ 'a1', 'a2', 'b1' ] );

      _.process.exitCode( 0 );
      return null;
    });

    return result;
  });

  /* */

  ready.then( () =>
  {
    test.case = ' routine : a1';

    visited = [];
    let suite1 = wTestSuite
    ({
      onSuiteEnd,
      tests : { a1, a2, b1 },
      override : this.notTakingIntoAccount,
      ignoringTesterOptions : 1,
      routine : 'a1',
    });

    test.identical( suite1.routine, 'a1' );

    var result = wTester.test([ suite1 ])
    .finally( function( err, suites )
    {
      var suite = suites[ 0 ];
      var report = suite.report;

      test.identical( report.outcome, true );
      test.identical( report.errorsArray, [] );
      test.identical( report.exitCode, 0 );
      test.identical( report.testCheckPasses, 1 );
      test.identical( report.testCheckFails, 0 );
      test.identical( report.testCasePasses, 1 );
      test.identical( report.testCaseFails, 0 );
      // test.identical( report.testCaseNumber, 0 );
      test.identical( report.testRoutinePasses, 1 );
      test.identical( report.testRoutineFails, 0 );

      _.errAttend( err );
      test.false( _.errIs( err ) );
      test.true( _.arrayIs( suites ) );
      test.identical( visited, [ 'a1' ] );
      test.identical( suite1.routine, 'a1' );
      test.identical( suite.routine, 'a1' );

      _.process.exitCode( 0 );
      return null;
    });

    return result;
  });

  /* */

  ready.then( () =>
  {
    test.case = ' routine : a*';

    visited = [];
    let suite1 = wTestSuite
    ({
      onSuiteEnd,
      tests : { a1, a2, b1 },
      override : this.notTakingIntoAccount,
      ignoringTesterOptions : 1,
      routine : 'a*',
    });

    test.identical( suite1.routine, 'a*' );

    var result = wTester.test([ suite1 ])
    .finally( function( err, suites )
    {
      var suite = suites[ 0 ];
      var report = suite.report;

      test.identical( report.outcome, true );
      test.identical( report.errorsArray, [] );
      test.identical( report.exitCode, 0 );
      test.identical( report.testCheckPasses, 2 );
      test.identical( report.testCheckFails, 0 );
      test.identical( report.testCasePasses, 2 );
      test.identical( report.testCaseFails, 0 );
      // test.identical( report.testCaseNumber, 0 );
      test.identical( report.testRoutinePasses, 2 );
      test.identical( report.testRoutineFails, 0 );

      _.errAttend( err );
      test.false( _.errIs( err ) );
      test.true( _.arrayIs( suites ) );
      test.identical( visited, [ 'a1', 'a2' ] );
      test.identical( suite1.routine, 'a*' );
      test.identical( suite.routine, 'a*' );

      _.process.exitCode( 0 );
      return null;
    });

    return result;
  });

  /* */

  ready.then( () =>
  {
    test.case = ' routine : c*';

    visited = [];
    let suite1 = wTestSuite
    ({
      onSuiteEnd,
      tests : { a1, a2, b1 },
      override : this.notTakingIntoAccount,
      ignoringTesterOptions : 1,
      routine : 'c*',
    });

    test.identical( suite1.routine, 'c*' );

    var result = wTester.test([ suite1 ])
    .finally( function( err, suites )
    {
      var suite = suites[ 0 ];
      var report = suite.report;

      test.identical( report.outcome, false );
      test.identical( report.errorsArray.length, 1 );
      test.identical( report.exitCode, 0 );
      test.identical( report.testCheckPasses, 0 );
      test.identical( report.testCheckFails, 0 );
      test.identical( report.testCasePasses, 0 );
      test.identical( report.testCaseFails, 0 );
      // test.identical( report.testCaseNumber, 0 );
      test.identical( report.testRoutinePasses, 0 );
      test.identical( report.testRoutineFails, 0 );

      _.errAttend( err );
      test.false( _.errIs( err ) );
      test.true( _.arrayIs( suites ) );
      test.identical( visited, [] );
      test.identical( suite1.routine, 'c*' );
      test.identical( suite.routine, 'c*' );

      _.process.exitCode( 0 );
      return null;
    });

    return result;
  });

  /* */

  return ready;

  /* */

  function a1( t )
  {
    t.case = 'trivial'
    t.identical( 1, 1 );
    visited.push( 'a1' );
  }

  function a2( t )
  {
    t.case = 'trivial'
    t.identical( 1, 1 );
    visited.push( 'a2' );
  }

  function b1( t )
  {
    t.case = 'trivial'
    t.identical( 1, 1 );
    visited.push( 'b1' );
  }

}

// --
// async
// --

function asyncTestRoutine( test )
{
  var testRoutine;

  async function asyncTest( t )
  {
    testRoutine = t;

    var got = await new _.Consequence().take( 1 );
    t.identical( got, 1 );

    var got = await _.time.out( 1000, () => 2 );
    t.identical( got, 2 );

    var got = await Promise.resolve( 3 )
    t.identical( got, 3 );

    return null;
  }

  var suite = wTestSuite
  ({
    tests : { asyncTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run()
  .finally( function( err, data )
  {

    var acheck = testRoutine.checkCurrent();
    test.identical( acheck.checkIndex, 4 );
    test.identical( suite.report.testCheckPasses, 3 );

    if( err )
    throw err;

    return null;
  });

  return result;
}

//

function syncTestRoutineWithProperty( test )
{
  var tro;

  function syncTest( t )
  {
    tro = t;
    t.identical( 1, 1 );
  }

  syncTest.description = 'description';

  var suite = wTestSuite
  ({
    tests : { syncTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run()
  .finally( function( err, data )
  {

    var acheck = tro.checkCurrent();
    test.identical( acheck.checkIndex, 2 );
    test.identical( suite.report.testCheckPasses, 1 );
    test.identical( suite.report.testCheckFails, 0 );

    if( err )
    throw err;

    return null;
  });

  return result;
}

//

function asyncTestRoutineWithProperty( test )
{
  var tro;

  async function asyncTest( t )
  {
    tro = t;
    var got = await Promise.resolve( 1 );
    t.identical( got, 1 );
    return got;
  }

  asyncTest.description = 'description';

  var suite = wTestSuite
  ({
    tests : { asyncTest },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run()
  .finally( function( err, data )
  {

    var acheck = tro.checkCurrent();
    test.identical( acheck.checkIndex, 2 );
    test.identical( suite.report.testCheckPasses, 1 );
    test.identical( suite.report.testCheckFails, 0 );

    if( err )
    throw err;

    return null;
  });

  return result;
}

//

function syncTimeout1( test )
{
  let tro;
  let testRoutineDone = 0;

  function testRoutine( t )
  {
    tro = t;
    t.description = 'description1';
    t.identical( 0, 1 );
    _.time.out( 500 ).deasync();
    t.description = 'description2';
    testRoutineDone = 1;
  }

  testRoutine.timeOut = 250;

  var suite = wTestSuite
  ({
    name : 'TestSuiteSyncTimeout1',
    tests : { testRoutine },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run();

  result
  .finally( function( err, arg )
  {

    var acheck = tro.checkCurrent();
    test.identical( acheck.checkIndex, 3 );
    test.identical( suite.report.testCheckPasses, 0 );
    test.identical( suite.report.testCheckFails, 2 );

    test.true( err === undefined );
    test.true( arg === suite );
    test.identical( result.tag, suite.name );
    test.identical( testRoutineDone, 0 );

    if( err )
    throw err;
    return null;
  });

  return result;
}

syncTimeout1.timeOut = 15000;
syncTimeout1.description =
`
- test failed because of time out
- error detected synchonously in description setter
- tester works, despite of timeout error
`

/* qqq : ask
write equivalent external test
- make sure error is printed with default verbosity
- make sure error message has proper message
*/

//

function syncTimeout2( test )
{
  let tro;
  let counter = 0;
  let testRoutineDone = 0;

  function testRoutine( t )
  {
    tro = t;
    t.description = 'description1';
    t.identical( 0, 1 );
    _.time.out( 500 ).deasync();
    t.identical( 1, 1 );
    testRoutineDone = 1;
  }

  testRoutine.timeOut = 250;

  var suite = wTestSuite
  ({
    name : 'TestSuiteSyncTimeout2',
    tests : { testRoutine },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run();

  result
  .finally( function( err, arg )
  {

    var acheck = tro.checkCurrent();
    test.identical( acheck.checkIndex, 4 );
    test.identical( suite.report.testCheckPasses, 1 );
    test.identical( suite.report.testCheckFails, 2 );

    test.true( err === undefined );
    test.true( arg === suite );
    test.identical( result.tag, suite.name );
    test.identical( testRoutineDone, 0 );

    if( err )
    throw err;
    return null;
  });

  return result;
}

syncTimeout2.timeOut = 15000;
syncTimeout2.description =
`
- test failed because of time out
- error detected synchonously in test check
- tester works, despite of timeout error
`

//

function asyncTimeout1( test )
{
  let tro;
  let counter = 0;
  let visits = [];

  function testRoutine( t )
  {
    tro = t;
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
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run();

  result
  .finally( function( err, arg )
  {

    var acheck = tro.checkCurrent();
    test.identical( acheck.checkIndex, 2 );
    test.identical( suite.report.testCheckPasses, 0 );
    test.identical( suite.report.testCheckFails, 1 );

    test.true( err === undefined );
    test.true( arg === suite );
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

//
`

//

function processWatchingOnDefault( test )
{
  let tro;

  var suite = wTestSuite
  ({
    tests : { testRoutine },
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run();

  result.finally( function( err, arg )
  {
    test.identical( suite.report.testCheckPasses, 0 );
    test.identical( suite.report.errorsArray.length, 3 );
    test.true( _.strHas( suite.report.errorsArray[ 0 ].message, 'had zombie process' ) )
    test.true( _.strHas( suite.report.errorsArray[ 1 ].message, 'had zombie process' ) )
    test.true( _.strHas( suite.report.errorsArray[ 2 ].message, 'had zombie process' ) )
    test.identical( suite.report.testCheckFails, 1 );

    test.identical( _.mapKeys( suite._processWatcherMap ).length, 0 );

    test.true( err === undefined );
    test.true( arg === suite );
    test.identical( result.tag, suite.name );

    if( err )
    throw err;

    return null;
  });

  return result;

  function testRoutine( t )
  {
    tro = t;
    t.description = 'create three zombie processes';
    var o =
    {
      execPath : 'node -e "setTimeout(()=>{},10000)"',
      inputMirroring : 0,
      throwingExitCode : 0,
      mode : 'spawn'
    }
    _.process.start( _.mapExtend( null, o ) );
    _.process.start( _.mapExtend( null, o ) );
    _.process.start( _.mapExtend( null, o ) );
  }

}

processWatchingOnDefault.description =
`
  Three processes are terminated.
  Test suite ends with three errors.
`

//

function processWatchingOnExplicit( test )
{
  let tro;
  function testRoutine( t )
  {
    tro = t;
    t.description = 'create three zombie processes';
    var o =
    {
      execPath : 'node -e "setTimeout(()=>{},10000)"',
      inputMirroring : 0,
      throwingExitCode : 0,
      mode : 'spawn'
    }
    _.process.start( _.mapExtend( null, o ) );
    _.process.start( _.mapExtend( null, o ) );
    _.process.start( _.mapExtend( null, o ) );
  }

  var suite = wTestSuite
  ({
    tests : { testRoutine },
    processWatching : 1,
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run();

  result
  .finally( function( err, arg )
  {
    test.identical( suite.report.testCheckPasses, 0 );
    test.identical( suite.report.errorsArray.length, 3 );
    test.true( _.strHas( suite.report.errorsArray[ 0 ].message, 'had zombie process' ) )
    test.true( _.strHas( suite.report.errorsArray[ 1 ].message, 'had zombie process' ) )
    test.true( _.strHas( suite.report.errorsArray[ 2 ].message, 'had zombie process' ) )
    test.identical( suite.report.testCheckFails, 1 );

    test.identical( _.mapKeys( suite._processWatcherMap ).length, 0 );

    test.true( err === undefined );
    test.true( arg === suite );
    test.identical( result.tag, suite.name );

    if( err )
    throw err;

    return null;
  });

  return result;
}

processWatchingOnExplicit.description =
`
  Three processes are terminated.
  Test suite ends with three errors.
`

//

function processWatchingOff( test )
{
  let tro;
  var o =
  {
    execPath : 'node -e "setTimeout(()=>{},10000)"',
    inputMirroring : 0,
    throwingExitCode : 0,
    mode : 'spawn'
  }
  function testRoutine( t )
  {
    tro = t;
    t.description = 'create three zombie processes';
    _.process.start( o );
    t.identical( 1, 1 );
  }

  var suite = wTestSuite
  ({
    tests : { testRoutine },
    processWatching : 0,
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run();

  result
  .finally( function( err, arg )
  {
    test.identical( suite.report.testCheckPasses, 1 );
    test.identical( suite.report.errorsArray.length, 0 );
    test.identical( suite.report.testCheckFails, 0 );
    test.identical( suite._processWatcherMap, null );
    test.true( _.process.isAlive( o.pnd.pid ) )

    test.true( err === undefined );
    test.true( arg === suite );
    test.identical( result.tag, suite.name );

    if( err )
    throw err;


    o.pnd.kill();

    return _.time.out( 1000, () =>
    {
      test.true( !_.process.isAlive( o.pnd.pid ) )
      return null;
    })
  });

  return result;
}

processWatchingOnExplicit.description =
`
  Zombie proces continues to work after testing.
  Test suite ends with positive result.
`

//

function processWatchingRoutineTimeOut( test )
{
  let tro;
  function testRoutine( t )
  {
    tro = t;
    t.description = 'create three zombie processes';
    var o =
    {
      execPath : 'node -e "setTimeout(()=>{},10000)"',
      inputMirroring : 0,
      throwingExitCode : 0,
      mode : 'spawn'
    }
    return _.process.start( o );
  }

  var suite = wTestSuite
  ({
    tests : { testRoutine },
    routineTimeOut : 100,
    processWatching : 1,
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run();

  result
  .finally( function( err, arg )
  {
    test.identical( suite.report.testCheckPasses, 0 );
    test.identical( suite.report.errorsArray.length, 2 );
    test.true( _.strHas( suite.report.errorsArray[ 0 ].message, 'timed out' ) );
    test.true( _.strHas( suite.report.errorsArray[ 1 ].message, 'had zombie process' ) );
    test.identical( suite.report.testCheckFails, 1 );

    test.identical( _.mapKeys( suite._processWatcherMap ).length, 0 );

    test.true( err === undefined );
    test.true( arg === suite );
    test.identical( result.tag, suite.name );

    if( err )
    throw err;

    return null;
  });

  return result;
}

processWatchingRoutineTimeOut.description =
`
  Test routine ends with time out error.
  Zombie proces is killed.
  Test suite end with two errors.
`

//

function processWatchingErrorInTestRoutine( test )
{
  let tro;
  function testRoutine( t )
  {
    tro = t;
    t.description = 'create three zombie processes';
    var o =
    {
      execPath : 'node -e "setTimeout(()=>{},10000)"',
      inputMirroring : 0,
      throwingExitCode : 0,
      mode : 'spawn'
    }
    _.process.start( o );
    throw _.err( 'Test' );
  }

  var suite = wTestSuite
  ({
    tests : { testRoutine },
    processWatching : 1,
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run();

  result
  .finally( function( err, arg )
  {
    test.identical( suite.report.testCheckPasses, 0 );
    test.identical( suite.report.errorsArray.length, 2 );
    test.true( _.strHas( suite.report.errorsArray[ 0 ].message, 'Test' ) )
    test.true( _.strHas( suite.report.errorsArray[ 1 ].message, 'had zombie process' ) )
    test.identical( suite.report.testCheckFails, 1 );

    test.identical( _.mapKeys( suite._processWatcherMap ).length, 0 );

    test.true( err === undefined );
    test.true( arg === suite );
    test.identical( result.tag, suite.name );

    if( err )
    throw err;

    return null;
  });

  return result;
}

processWatchingErrorInTestRoutine.description =
`
  Test routine creates zombie process and throws sync error.
  Zombie proces is killed on suite end stage.
  Test suite ends with two errors.
`

//

function processWatchingOnSuiteBegin( test )
{
  let tro;

  function onSuiteBegin()
  {
    var o =
    {
      execPath : 'node -e "setTimeout(()=>{},10000)"',
      inputMirroring : 0,
      throwingExitCode : 0,
      mode : 'spawn'
    }
    _.process.start( o );
  }
  function testRoutine( t )
  {
    tro = t;
    t.identical( 1, 1 );
  }

  var suite = wTestSuite
  ({
    onSuiteBegin,
    tests : { testRoutine },
    processWatching : 1,
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run();

  result
  .finally( function( err, arg )
  {
    test.identical( suite.report.testCheckPasses, 1 );
    test.identical( suite.report.errorsArray.length, 1 );
    test.true( _.strHas( suite.report.errorsArray[ 0 ].message, 'had zombie process' ) )
    test.identical( suite.report.testCheckFails, 0 );

    test.identical( _.mapKeys( suite._processWatcherMap ).length, 0 );

    test.true( err === undefined );
    test.true( arg === suite );
    test.identical( result.tag, suite.name );

    if( err )
    throw err;

    return null;
  });

  return result;
}

processWatchingOnSuiteBegin.description =
`
  onSuiteBegin handler creates zombie process.
  Test suite ends with single error.
  Zombie proces is killed on suite end stage.
`

//

function processWatchingOnSuiteEnd( test )
{
  let tro;

  function onSuiteEnd()
  {
    var o =
    {
      execPath : 'node -e "setTimeout(()=>{},10000)"',
      inputMirroring : 0,
      throwingExitCode : 0,
      mode : 'spawn'
    }
    _.process.start( o );
  }
  function testRoutine( t )
  {
    tro = t;
    t.identical( 1, 1 );
  }

  var suite = wTestSuite
  ({
    onSuiteEnd,
    tests : { testRoutine },
    processWatching : 1,
    override : this.notTakingIntoAccount,
    ignoringTesterOptions : 1,
  });

  var result = suite.run();

  result
  .finally( function( err, arg )
  {
    test.identical( suite.report.testCheckPasses, 1 );
    test.identical( suite.report.errorsArray.length, 1 );
    test.true( _.strHas( suite.report.errorsArray[ 0 ].message, 'had zombie process' ) )
    test.identical( suite.report.testCheckFails, 0 );

    test.identical( _.mapKeys( suite._processWatcherMap ).length, 0 );

    test.true( err === undefined );
    test.true( arg === suite );
    test.identical( result.tag, suite.name );

    if( err )
    throw err;

    return null;
  });

  return result;
}

processWatchingOnSuiteEnd.description =
`
  onSuiteEnd handler creates zombie process.
  Test suite ends with single error.
  Zombie proces is killed on suite end stage.
`

// --
// experiment
// --

// --
// declare
// --

// var notTakingIntoAccount = { concurrent : 1, takingIntoAccount : 0 };
var notTakingIntoAccount = { logger : _.Logger({ output : null }), concurrent : 1, takingIntoAccount : 0 };

let Self =
{

  name : 'Tools.Tester.Int',
  silencing : 1,
  routineTimeOut : 30000,

  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    notTakingIntoAccount,
    t1 : 100,
    t2 : 1000,
  },

  tests :
  {


    // etc

    trivial,

    // compare

    identical,
    identicalConsequence,

    // should

    returnsSingleResource,
    returnsSingleResource_,
    mustNotThrowError,
    mustNotThrowErrorWithCallback,
    mustNotThrowError_WithCallback,
    shouldThrowErrorSync,
    shouldThrowErrorSyncWithCallback,
    shouldThrowErrorSync_WithCallback,
    shouldThrowErrorAsync,
    shouldThrowErrorAsyncWithCallback,
    shouldThrowErrorAsync_WithCallback,
    shouldThrowErrorOfAnyKind,
    shouldThrowErrorOfAnyKindWithCallback,
    shouldThrowErrorOfAnyKind_WithCallback,

    shouldPassMessage,
    _throwingExperiment,

    shouldThrowErrorSyncSimple,
    shouldThrowErrorAsyncSimple,
    shouldThrowErrorAsyncConcurrent,

    shouldThrowErrorSyncReturn,
    shouldThrowErrorAsyncReturn,
    shouldThrowErrorReturn,
    mustNotThrowErrorReturn,
    shouldMessageOnlyOnceReturn,

    chainedShould,

    // return

    isReturn,
    isNotReturn,

    identicalReturn,
    notIdenticalReturn,
    equivalentReturn,
    notEquivalentReturn,
    containReturn,

    ilReturn,
    niReturn,
    etReturn,
    neReturn,

    gtReturn,
    geReturn,
    ltReturn,
    leReturn,

    // grouping

    testCase,
    testsGroupSameNameError,
    testsGroupDiscrepancyError,
    testsGroupSingleLevel,
    testsGroupMultipleLevels,
    testsGroupTestCaseSingleLevel,
    testsGroupTestCaseSameName,
    testsGroupAfterTestCase,
    testsGroupTestCaseMultipleLevels,

    // outcome

    runMultiple,
    exitCode,

    // handler

    onSuiteBeginThrowError,
    onSuiteEndReturnsNothing,
    onSuiteEndThrowError,
    suiteEndTimeOut,
    onSuiteEndErrorInConsequence,
    onSuiteEndNormalConsequence,
    onSuiteEndDelayedConsequence,
    /* qqq : please cover onRoutineBegin, onRoutineEnd */

    // options

    optionRoutine,

    // async

    asyncTestRoutine,
    syncTestRoutineWithProperty,
    asyncTestRoutineWithProperty,

    syncTimeout1,
    syncTimeout2,
    asyncTimeout1,

    //

    processWatchingOnDefault,
    processWatchingOnExplicit,
    processWatchingOff,
    processWatchingRoutineTimeOut,
    processWatchingErrorInTestRoutine,
    processWatchingOnSuiteBegin,
    processWatchingOnSuiteEnd

    // experiment

  },

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();

