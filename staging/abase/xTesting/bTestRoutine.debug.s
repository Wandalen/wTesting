(function _bTestRoutine_debug_s_() {

'use strict';

var isBrowser = true;
if( typeof module !== 'undefined' )
{

  isBrowser = false;

  if( typeof wBase === 'undefined' )
  try
  {
    require( '../../abase/wTools.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  var _ = wTools;

}

//

var _ = wTools;
var Parent = null;
var Self = function wTestRoutineDescriptor( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'TestRoutineDescriptor';

//

function init( o )
{
  var self = this;

  _.instanceInit( self );

  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  self._cancelCon = new wConsequence();
  self._returnCon = null;

  self._reportForm();

  _.assert( _.routineIs( self.routine ) );
  _.assert( _.strIsNotEmpty( self.routine.name ),'Test routine should have name, ' + self.name + ' test routine of test suite',self.suite.name,'does not have name' );
  // _.assert( self.routine.name === self.name,'routine should have same name, but',self.routine.name, '!=', self.name );
  _.assert( Object.isPrototypeOf.call( wTestSuite.prototype,self.suite ) );
  // _.assert( Object.isPrototypeOf.call( wTestSuite.prototype,self ) );
  _.assert( Object.isPrototypeOf.call( wTestRoutineDescriptor.prototype,self ) );
  _.assert( arguments.length === 1 );

  var proxy =
  {
    get : function( obj, k )
    {
      if( obj[ k ] !== undefined )
      return obj[ k ];
      return obj.suite[ k ];
    }
  }

  var self = new Proxy( self, proxy );

  return self;
}

//

function _reportForm()
{
  var self = this;

  _.assert( !self.report );
  var report = self.report = Object.create( null );

  report.errorsArray = [];

  report.testCheckPasses = 0;
  report.testCheckFails = 0;

  report.testCheckPassesOfTestCase = 0;
  report.testCheckFailsOfTestCase = 0;

  report.testCasePasses = 0;
  report.testCaseFails = 0;

  Object.preventExtensions( report );

}

//

function _testRoutineHandleReturn( err,msg )
{
  var trd = this;
  var suite = trd.suite;

  if( err )
  if( err.timeOut )
  err = _._err
  ({
    args : [ 'Test routine ( ' + trd.routine.name + ' ) time out!' ],
    usingSourceCode : 0,
  });

  if( err )
  {
    trd.exceptionReport
    ({
      err : err,
      trd : trd,
      usingSourceCode : 0,
    });
  }
  else
  {
    if( trd.report.testCheckPasses === 0 && trd.report.testCheckFails === 0 )
    trd._outcomeReportBoolean
    ({
      outcome : 0,
      msg : 'test routine has passed none test check',
      usingSourceCode : 0,
      usingDescription : 0,
    });
    else
    trd._outcomeReportBoolean
    ({
      outcome : 1,
      msg : 'test routine has not thrown an error',
      usingSourceCode : 0,
      usingDescription : 0,
    });
  }

  suite._testRoutineEnd( trd,!trd.report.testCheckFails );

}

// --
//
// --

function _descriptionGet()
{
  var trd = this;
  return trd[ descriptionSymbol ];
}

//

function _descriptionSet( src )
{
  var trd = this;
  trd[ descriptionSymbol ] = src;

  if( src )
  trd.testCaseNext();

}

//

function testCaseNext()
{
  var trd = this;
  var report = trd.report;

  trd._testCaseConsider( !report.testCheckFailsOfTestCase );
  // trd._testCaseConsider( report.testCheckPassesOfTestCase && !report.testCheckFailsOfTestCase );

}

//

function _testCaseConsider( outcome )
{
  var trd = this;
  var report = trd.report;

  if( outcome )
  report.testCasePasses += 1;
  else
  report.testCaseFails += 1;

  trd.suite._testCaseConsider( outcome );
}

// --
// store
// --

function checkCurrent()
{
  var trd = this;
  var result = Object.create( null );

  _.assert( arguments.length === 0 );

  result.description = trd.description;
  result._checkIndex = trd._checkIndex;

  return result;
}

//

function checkNext( description )
{
  var trd = this;

  _.assert( trd instanceof wTestRoutineDescriptor );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !trd._checksStack.length )
  if( trd.name === 'row' || trd.name === 'include' )
  {
    console.log( 'trd._checkIndex',trd._checkIndex );
    console.log( _.diagnosticStack() );
    debugger;
  }

  if( !trd._checkIndex )
  trd._checkIndex = 1;
  else
  trd._checkIndex += 1;

  if( description !== undefined )
  trd.description = description;

  return trd.checkCurrent();
}

//

function checkStore()
{
  var trd = this;
  var result = trd.checkCurrent();

  _.assert( arguments.length === 0 );

  trd._checksStack.push( result );

  return result;
}

//

function checkRestore( acheck )
{
  var trd = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( acheck )
  {
    trd.checkStore();
  }
  else
  {
    _.assert( _.arrayIs( trd._checksStack ) && trd._checksStack.length, 'checkRestore : no stored check in stack' );
    acheck = trd._checksStack.pop();
  }

  trd.description = acheck.description;
  trd._checkIndex = acheck._checkIndex;

  return trd;
}

// --
// equalizer
// --

function shouldBe( outcome )
{
  var trd = this;

  // _.assert( _.boolLike( outcome ),'shouldBe expects single bool argument' );
  // _.assert( arguments.length === 1,'shouldBe expects single bool argument' );

  if( !_.boolLike( outcome ) || arguments.length !== 1 )
  trd._outcomeReportBoolean
  ({
    outcome : 0,
    msg : 'shouldBe expects single bool argument',
  });
  else
  trd._outcomeReportBoolean
  ({
    outcome : outcome,
    msg : 'expected true',
  });

  return outcome;
}

//

function shouldBeNotError( maybeErrror )
{
  var trd = this;

  // _.assert( arguments.length === 1,'shouldBeNotError expects single argument' );

  if( arguments.length !== 1 )
  trd._outcomeReportBoolean
  ({
    outcome : 0,
    msg : 'shouldBeNotError expects single argument',
  });
  else
  trd._outcomeReportBoolean
  ({
    outcome : !_.errIs( maybeErrror ),
    msg : 'expected variable is not error',
  });

}

//

function notIdentical( got,expected )
{
  var trd = this;
  var iterator = Object.create( null );

  _.assert( arguments.length === 2 );

  var outcome = _.entityIdentical( got,expected,iterator );

  _.assert( iterator.lastPath !== undefined );

  trd._outcomeReportCompare // ( !outcome,got,expected,iterator.lastPath );
  ({
    outcome : !outcome,
    got : got,
    expected : expected,
    path : iterator.lastPath,
    usingExtraDetails : 0,
  });

  return outcome;
}

//

/**
 * Checks if test passes a specified condition by deep strict comparsing result of code execution( got )
 * with target( expected ). Uses recursive comparsion for objects,arrays and array-like objects.
 * If entity( got ) is equal to entity( expected ) test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {*} got - Source entity.
 * @param {*} expected - Target entity.
 *
 * @example
 * function someTest( test )
 * {
 *  test.description = 'single zero';
 *  var got = 0;
 *  var expected = 0;
 *  test.identical( got, expected );//returns true
 *
 *  test.description = 'single number';
 *  var got = 2;
 *  var expected = 1;
 *  test.identical( got, expected );//returns false
 * }
 *
 * _.Tester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method identical
 * @memberof wTools
 */

function identical( got,expected )
{
  var trd = this;
  var iterator = Object.create( null );

  _.assert( arguments.length === 2 );

  var outcome = _.entityIdentical( got,expected,iterator );

  _.assert( iterator.lastPath !== undefined );

  trd._outcomeReportCompare //( outcome,got,expected,iterator.lastPath );
  ({
    outcome : outcome,
    got : got,
    expected : expected,
    path : iterator.lastPath,
    usingExtraDetails : 1,
  });

  return outcome;
}

//

/**
 * Checks if test passes a specified condition by deep soft comparsing result of code execution( got )
 * with target( expected ). Uses recursive comparsion for objects,arrays and array-like objects. Two entities are equivalent if
 * difference between their values are less or equal to( eps ). Example: ( got - expected ) <= ( eps ).
 * If entity( got ) is equivalent to entity( expected ) test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {*} got - Source entity.
 * @param {*} expected - Target entity.
 * @param {*} [ eps=1e-5 ] - Maximal distance between two values.
 *
 * @example
 * function sometest( test )
 * {
 *  test.description = 'single number';
 *  var got = 0.5;
 *  var expected = 1;
 *  var eps = 0.5;
 *  test.equivalent( got, expected, eps );//returns true
 *
 *  test.description = 'single number';
 *  var got = 0.5;
 *  var expected = 2;
 *  var eps = 0.5;
 *  test.equivalent( got, expected, eps );//returns false
 * }
 * _.Tester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method equivalent
 * @memberof wTools
 */

function equivalent( got,expected,eps )
{
  var trd = this;
  var iterator = Object.create( null );

  if( eps === undefined )
  eps = trd.eps;

  iterator.eps = eps;

  _.assert( arguments.length === 2 || arguments.length === 3 );

  var outcome = _.entityEquivalent( got,expected,iterator );

  trd._outcomeReportCompare // ( outcome,got,expected,iterator.lastPath );
  ({
    outcome : outcome,
    got : got,
    expected : expected,
    path : iterator.lastPath,
    usingExtraDetails : 1,
  });

  return outcome;
}

//

/**
 * Checks if test passes a specified condition by deep contain comparsing result of code execution( got )
 * with target( expected ). Uses recursive comparsion for objects,arrays and array-like objects.
 * If entity( got ) contains keys/values from entity( expected ) or they are indentical test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {*} got - Source entity.
 * @param {*} expected - Target entity.
 *
 * @example
 * function sometest( test )
 * {
 *  test.description = 'array';
 *  var got = [ 0, 1, 2 ];
 *  var expected = [ 0 ];
 *  test.contain( got, expected );//returns true
 *
 *  test.description = 'array';
 *  var got = [ 0, 1, 2 ];
 *  var expected = [ 4 ];
 *  test.contain( got, expected );//returns false
 * }
 * _.Tester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method contain
 * @memberof wTools
 */

function contain( got,expected )
{
  var trd = this;
  var iterator = Object.create( null );

  var outcome = _.entityContain( got,expected,iterator );

  trd._outcomeReportCompare // ( outcome,got,expected,iterator.lastPath );
  ({
    outcome : outcome,
    got : got,
    expected : expected,
    path : iterator.lastPath,
    usingExtraDetails : 1,
  });

  return outcome;
}

//

function _shouldDo( o )
{
  var trd = this;
  var second = 0;
  var reported = 0;
  var good = 1;
  var async = 0;
  var stack = _.diagnosticStack( 2,-1 );
  var logger = trd.logger;
  var err,arg;

  _.routineOptions( _shouldDo,o );
  _.assert( arguments.length === 1 );

  var acheck = trd.checkCurrent();
  trd._inroutineCon.choke();
  var con = new wConsequence();

  /* */

  function begin( positive )
  {
    if( positive )
    _.assert( !reported );
    good = positive;

    if( reported || async )
    trd.checkRestore( acheck );

    logger.begin({ verbosity : positive ? -5 : -5+trd.importanceOfNegative });
    logger.begin({ connotation : positive ? 'positive' : 'negative' });
  }

  function end( positive,arg )
  {
    _.assert( arguments.length === 2 );

    // debugger;
    logger.end({ verbosity : positive ? -5 : -5+trd.importanceOfNegative });
    logger.end({ connotation : positive ? 'positive' : 'negative' });

    if( reported )
    debugger;
    if( reported || async )
    trd.checkRestore();

    if( positive )
    con.give( null,arg );
    else
    con.give( arg,null );

    trd._inroutineCon.give();

    reported = 1;
  }

  /* */

  function reportAsync()
  {

    if( reported )
    return;

    if( o.ignoringError )
    {
      debugger;
      begin( 1 );

      trd._outcomeReportBoolean
      ({
        outcome : 1,
        msg : 'got single message',
        stack : stack,
      });

      end( 1,err ? err : arg );
    }
    else if( err )
    {
      begin( o.expectingAsyncError );

      logger.begin({ verbosity : -6+( o.expectingAsyncError ? 0 : trd.importanceOfNegative ) });
      if( !_.errIsAttended( err ) )
      logger.log( _.errAttend( err ) );
      logger.end({ verbosity : -6+( o.expectingAsyncError ? 0 : trd.importanceOfNegative ) });

      if( o.expectingAsyncError )
      trd._outcomeReportBoolean
      ({
        outcome : o.expectingAsyncError,
        msg : 'error thrown asynchronously as expected',
        stack : stack,
      });
      else
      trd._outcomeReportBoolean
      ({
        outcome : o.expectingAsyncError,
        msg : 'error thrown asynchronously, not expected',
        stack : stack,
      });

      if( o.expectingAsyncError )
      end( o.expectingAsyncError,err );
      else
      end( o.expectingAsyncError,err );
    }
    else
    {
      begin( !o.expectingAsyncError );

      var msg = 'error was not thrown asynchronously, but expected';
      if( o.expectingAsyncError )
      var msg = 'error was thrown asynchronously as expected';

      trd._outcomeReportBoolean
      ({
        outcome : !o.expectingAsyncError,
        msg : msg,
        stack : stack,
      });

      if( o.expectingAsyncError )
      end( !o.expectingAsyncError,_.err( msg ) );
      else
      end( !o.expectingAsyncError,arg );

    }

  }

  /* */

  if( !_.routineIs( o.routine ) )
  {

    begin( 0 );
    trd._outcomeReportBoolean
    ({
      outcome : 0,
      msg : 'expects Routine or Consequence, but got ' + _.strTypeOf( o.routine ),
      stack : stack,
    });
    end( 0,null );

    _.assert( !_.consequenceIs( o.routine ) )
    return con;
  }

  /* */

  var result;
  if( _.consequenceIs( o.routine ) )
  {
    result = o.routine;
  }
  else try
  {
    result = o.routine.call( this );
  }
  catch( _err )
  {

    err = _err;

    if( o.ignoringError )
    {
      begin( 1 );
      trd._outcomeReportBoolean
      ({
        outcome : 1,
        msg : 'error throwen synchronously, ignored',
        stack : stack,
      });
      end( 1,err );
      return con;
    }

    logger.begin({ verbosity : -6+( o.expectingSyncError ? 0 : trd.importanceOfNegative ) });

    if( !_.errIsAttended( err ) )
    logger.log( _.errAttend( err ) );

    logger.end({ verbosity : -6+( o.expectingSyncError ? 0 : trd.importanceOfNegative ) });

    if( !o.ignoringError )
    {

      begin( o.expectingSyncError );

      if( o.expectingSyncError )
      {

        trd._outcomeReportBoolean
        ({
          outcome : o.expectingSyncError,
          msg : 'error thrown synchronously as expected',
          stack : stack,
        });

      }
      else
      {

        trd._outcomeReportBoolean
        ({
          outcome : o.expectingSyncError,
          msg : 'error thrown synchronously, something wrong',
          stack : stack,
        });

      }

      end( o.expectingSyncError,err );

      return con;
    }

    // end( o.expectingSyncError,err );

  }

  /* no error, but expected */

  if( !o.ignoringError && !o.expectingAsyncError && o.expectingSyncError && !err )
  {
    begin( 0 );

    var msg = 'error not thrown synchronously, but expected';

    trd._outcomeReportBoolean
    ({
      outcome : 0,
      msg : msg,
      stack : stack,
    });

    end( 0,_.err( msg ) );
    return con;
  }

  /* */

  if( _.consequenceIs( result ) )
  {

    trd.checkNext();
    async = 1;

    result.got( function( _err,_arg )
    {
      err = _err;
      arg = _arg;

      if( !o.ignoringError && !reported )
      if( err && !o.expectingAsyncError )
      reportAsync();
      else if( !err && o.expectingAsyncError )
      reportAsync();

      /* */

      if( !reported )
      if( !o.allowingMultipleMessages )
      _.timeOut( 10,function()
      {

        if( result.messagesGet().length )
        if( reported )
        {
          _.assert( !good );
        }
        else
        {

          begin( 0 );
          debugger;

          _.assert( !reported );

          trd._outcomeReportBoolean
          ({
            outcome : 0,
            msg : 'got more than one message',
            stack : stack,
          });

          end( 0,_.err( msg ) );
        }

        if( !reported )
        reportAsync();

      });

    });

    /* */

    if( !o.allowingMultipleMessages )
    result.doThen( function( err,data )
    {
      if( reported && !good )
      return;

      begin( 0 );

      second = 1;
      var msg = 'got more than one message';

      trd._outcomeReportBoolean
      ({
        outcome : 0,
        msg : msg,
        stack : stack,
      });

      end( 0,_.err( msg ) );
    });

  }
  else
  {

    if( ( o.expectingAsyncError || o.expectingSyncError ) && !err )
    {
      begin( 0 );

      var msg = 'error not thrown asynchronously, but expected';
      if( o.expectingAsyncError )
      msg = 'error not thrown, but expected either synchronosuly or asynchronously';

      trd._outcomeReportBoolean
      ({
        outcome : 0,
        msg : msg,
        stack : stack,
      });

      end( 0,_.err( msg ) );
    }
    else if( !o.expectingSyncError && !err )
    {
      begin( 1 );

      trd._outcomeReportBoolean
      ({
        outcome : 1,
        msg : 'no error thrown, as expected',
        stack : stack,
      });

      end( 1,result );
    }
    else
    {
      debugger;
      _.assert( 0,'unexpected' );
      trd.checkNext();
    }

  }

  /* */

  return con;
}

_shouldDo.defaults =
{
  routine : null,
  expectingSyncError : 1,
  expectingAsyncError : 1,
  ignoringError : 0,
  allowingMultipleMessages : 0,
}

//

function shouldThrowErrorAsync( routine )
{
  var trd = this;

  return trd._shouldDo
  ({
    routine : routine,
    expectingSyncError : 0,
    expectingAsyncError : 1,
  });

}

//

function shouldThrowErrorSync( routine )
{
  var trd = this;

  return trd._shouldDo
  ({
    routine : routine,
    expectingSyncError : 1,
    expectingAsyncError : 0,
  });

}

//

/**
 * Error throwing test. Expects one argument( routine ) - function to call or wConsequence instance.
 * If argument is a function runs it and checks if it throws an error. Otherwise if argument is a consequence  checks if it has a error message.
 * If its not a error or consequence contains more then one message test is failed. After check function reports result of test to the testing system.
 * If test is failed function also outputs additional information. Returns wConsequence instance to perform next call in chain.
 *
 * @param {Function|wConsequence} routine - Funtion to call or wConsequence instance.
 *
 * @example
 * function sometest( test )
 * {
 *  test.description = 'shouldThrowErrorSync';
 *  test.shouldThrowErrorSync( function()
 *  {
 *    throw _.err( 'Error' );
 *  });
 * }
 * _.Tester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @example
 * function sometest( test )
 * {
 *  var consequence = new wConsequence().give();
 *  consequence
 *  .ifNoErrorThen( function()
 *  {
 *    test.description = 'shouldThrowErrorSync';
 *    var con = new wConsequence( )
 *    .error( _.err() ); //wConsequence instance with error message
 *    return test.shouldThrowErrorSync( con );//test passes
 *  })
 *  .ifNoErrorThen( function()
 *  {
 *    test.description = 'shouldThrowError2';
 *    var con = new wConsequence( )
 *    .error( _.err() )
 *    .error( _.err() ); //wConsequence instance with two error messages
 *    return test.shouldThrowErrorSync( con ); //test fails
 *  });
 *
 *  return consequence;
 * }
 * _.Tester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @throws {Exception} If passed argument is not a Routine.
 * @method shouldThrowErrorSync
 * @memberof wTools
 */

function shouldThrowError( routine )
{
  var trd = this;

  return trd._shouldDo
  ({
    routine : routine,
    expectingSyncError : 1,
    expectingAsyncError : 1,
  });

}

//

function mustNotThrowError( routine )
{
  var trd = this;

  return trd._shouldDo
  ({
    routine : routine,
    ignoringError : 0,
    expectingSyncError : 0,
    expectingAsyncError : 0,
  });

}

//

function shouldMessageOnlyOnce( routine )
{
  var trd = this;

  return trd._shouldDo
  ({
    routine : routine,
    ignoringError : 1,
    expectingSyncError : 0,
    expectingAsyncError : 0,
  });

}

// --
// output
// --

function _outcomeConsider( outcome )
{
  var trd = this;

  _.assert( arguments.length === 1 );
  _.assert( trd.constructor === Self );

  if( outcome )
  {
    trd.report.testCheckPasses += 1;
    trd.report.testCheckPassesOfTestCase += 1;
  }
  else
  {
    trd.report.testCheckFails += 1;
    trd.report.testCheckFailsOfTestCase += 1;
  }

  trd.suite._outcomeConsider( outcome );

  trd.checkNext();

}

//

function _exceptionConsider( err )
{
  var trd = this;

  _.assert( arguments.length === 1 );
  _.assert( trd.constructor === Self );

  trd.report.errorsArray.push( err );
  trd.suite._exceptionConsider( err );

}

//

function _outcomeReportAct( outcome )
{
  var trd = this;

  trd._outcomeConsider( outcome );

  if( !_.Tester._canContinue() )
  {
    trd._returnCon.cancel();
    trd._cancelCon.error( _.err( 'Too many fails',_.Tester.fails, '<=', trd.report.testCheckFails ) );
  }

  _.assert( arguments.length === 1 );

}

//

function _outcomeReport( o )
{
  var trd = this;
  var logger = trd.logger;
  var sourceCode = '';

  _.routineOptions( _outcomeReport,o );
  _.assert( arguments.length === 1 );

  /* */

  function sourceCodeGet()
  {
    var code;
    if( trd.usingSourceCode && o.usingSourceCode )
    {
      var _location = o.stack ? _.diagnosticLocation({ stack : o.stack }) : _.diagnosticLocation({ level : 4 });
      var _code = _.diagnosticCode
      ({
        location : _location,
        selectMode : 'end',
        numberOfLines : 5,
      });
      if( _code )
      code = '\n' + _code;
      // code = '\n' + _location.full + '\n' + _code;
      else
      code = '\n' + _location.full;
    }

    if( code )
    code = '#trackingColor : 0#' + code + '#trackingColor : 1#';

    return code;
  }

  /* */

  logger.begin({ verbosity : -4 });
  logger.begin({ 'check' : trd.description || trd._checkIndex });
  logger.begin({ 'checkIndex' : trd._checkIndex });

  trd._outcomeReportAct( o.outcome );

  if( o.outcome )
  {
    logger.begin({ verbosity : -4 });
    logger.up();
    logger.begin({ 'connotation' : 'positive' });

    logger.begin({ verbosity : -5 });

    if( o.details )
    logger.begin( 'details' ).log( o.details ).end( 'details' );

    sourceCode = sourceCodeGet();
    if( sourceCode )
    logger.begin( 'sourceCode' ).log( sourceCode ).end( 'sourceCode' );

    logger.end({ verbosity : -5 });

    logger.begin( 'message' ).logDown( o.msg ).end( 'message' );

    logger.end({ 'connotation' : 'positive' });
    if( logger.verbosityReserve() > 1 )
    logger.log();

    logger.end({ verbosity : -4 });
  }
  else
  {

    sourceCode = sourceCodeGet();

    logger.begin({ verbosity : -4+trd.importanceOfNegative });

    logger.up();
    if( logger.verbosityReserve() > 1 )
    logger.log();
    logger.begin({ 'connotation' : 'negative' });

    logger.begin({ verbosity : -5+trd.importanceOfNegative });

    if( o.details )
    logger.begin( 'details' ).log( o.details ).end( 'details' );

    if( sourceCode )
    logger.begin( 'sourceCode' ).log( sourceCode ).end( 'sourceCode' );

    logger.end({ verbosity : -5+trd.importanceOfNegative });

    logger.begin( 'message' ).logDown( o.msg ).end( 'message' );

    logger.end({ 'connotation' : 'negative' });
    if( logger.verbosityReserve() > 1 )
    logger.log();

    logger.end({ verbosity : -4+trd.importanceOfNegative });

  }

  logger.end( 'check','checkIndex' );
  logger.end({ verbosity : -4 });

}

_outcomeReport.defaults =
{
  outcome : null,
  msg : null,
  details : null,
  stack : null,
  usingSourceCode : 1,
}

//

function _outcomeReportBoolean( o )
{
  var trd = this;

  _.assert( arguments.length === 1 );
  _.routineOptions( _outcomeReportBoolean,o );

  o.msg = trd._currentTestCaseTextMake( o.outcome,o.msg,o.usingDescription );

  trd._outcomeReport
  ({
    outcome : o.outcome,
    msg : o.msg,
    details : '',
    stack : o.stack,
    usingSourceCode : o.usingSourceCode,
  });

}

_outcomeReportBoolean.defaults =
{
  outcome : null,
  msg : null,
  stack : null,
  usingSourceCode : 1,
  usingDescription : 1,
}

//

function _outcomeReportCompare( o )
{
  var trd = this;

  var got = o.got;
  var expected = o.expected;

  _.assert( trd._testRoutineDescriptorIs );
  _.assert( arguments.length === 1 );
  _.routineOptions( _outcomeReportCompare,o );

  o.got = got;
  o.expected = expected;

  /**/

  function msgExpectedGot()
  {
    return '' +
    'got :\n' + _.toStr( o.got,{ stringWrapper : '' } ) + '\n' +
    'expected :\n' + _.toStr( o.expected,{ stringWrapper : '' } ) +
    '';
  }

  /**/

  if( o.outcome )
  {

    var details = msgExpectedGot();
    var msg = trd._currentTestCaseTextMake( 1 );

    trd._outcomeReport
    ({
      outcome : o.outcome,
      msg : msg,
      details : details,
    });

  }
  else
  {

    var details = msgExpectedGot();

    if( o.usingExtraDetails )
    if( !_.atomicIs( o.got ) && !_.atomicIs( o.expected ) && o.path )
    details +=
    (
      '\nat : ' + o.path +
      '\ngot :\n' + _.toStr( _.entitySelect( o.got,o.path ) ) +
      '\nexpected :\n' + _.toStr( _.entitySelect( o.expected,o.path ) ) +
      ''
    );

    if( o.usingExtraDetails )
    if( _.strIs( o.expected ) && _.strIs( o.got ) )
    details += '\ndifference :\n' + _.strDifference( o.expected,o.got );

    var msg = trd._currentTestCaseTextMake( 0 );

    trd._outcomeReport
    ({
      outcome : o.outcome,
      msg : msg,
      details : details,
    });

    if( trd.debug )
    debugger;
  }

}

_outcomeReportCompare.defaults =
{
  got : null,
  expected : null,
  outcome : null,
  path : null,
  usingExtraDetails : 1,
}

//

function exceptionReport( o )
{
  var trd = this;

  _.routineOptions( exceptionReport,o );
  _.assert( arguments.length === 1 );

  if( o.trd.onError )
  o.trd.onError.call( trd,o.trd );

  var msg = o.trd._currentTestCaseTextMake() + ' ... failed throwing error';
  if( o.sync !== null )
  msg += ( o.sync ? 'synchronously' : 'asynchronously' );
  var err = _.errAttend( o.err );
  var details = err.toString();

  trd._exceptionConsider( err );

  o.trd._outcomeReport
  ({
    outcome : 0,
    msg : msg,
    details : details,
    stack : o.stack,
    usingSourceCode : o.usingSourceCode
  });

}

exceptionReport.defaults =
{
  err : null,
  trd : null,
  stack : null,
  usingSourceCode : 1,
  sync : null,
}

//

function _currentTestCaseTextMake( value,hint,usingDescription )
{
  var trd = this;

  if( usingDescription === undefined )
  usingDescription = 1;

  _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 || arguments.length === 3 );
  _.assert( value === undefined || _.boolLike( value ) );
  _.assert( hint === undefined || _.strIs( hint ) );
  _.assert( trd._testRoutineDescriptorIs );
  _.assert( trd._checkIndex >= 0 );
  _.assert( _.strIsNotEmpty( trd.routine.name ),'test routine descriptor should have name' );

  var name = trd.routine.name;

  if( trd.description && usingDescription )
  name += ' : ' + trd.description;

  var result = '' +
    'Test check' + ' ( ' + name + ' )' +
    ' # ' + trd._checkIndex
  ;

  if( hint )
  result += ' : ' + hint;

  if( value !== undefined )
  {
    if( value )
    result += ' ... ok';
    else
    result += ' ... failed';
  }

  return result;
}

// --
// relationships
// --

var descriptionSymbol = Symbol.for( 'description' );

var Composes =
{
  name : null,
  description : null,
}

var Aggregates =
{
}

var Associates =
{
  suite : null,
  routine : null,
}

var Restricts =
{

  _checkIndex : 1,
  _testRoutineDescriptorIs : 1,

  _cancelCon : null,
  _returnCon : null,

  report : null,
  _checksStack : [],

}

var Statics =
{
}

var Events =
{
}

var Forbids =
{
  _storedStates : '_storedStates',
  _currentRoutineFails : '_currentRoutineFails',
  _currentRoutinePasses : '_currentRoutinePasses',
}

var Accessors =
{
  description : 'description',
  will : 'will',
}

// --
// prototype
// --

var Proto =
{

  // inter

  init : init,

  _reportForm : _reportForm,

  _testRoutineHandleReturn : _testRoutineHandleReturn,


  // case

  _descriptionGet : _descriptionGet,
  _descriptionSet : _descriptionSet,
  _willGet : _descriptionGet,
  _willSet : _descriptionSet,

  testCaseNext : testCaseNext,
  _testCaseConsider : _testCaseConsider,


  // check

  checkCurrent : checkCurrent,
  checkNext : checkNext,
  checkStore : checkStore,
  checkRestore : checkRestore,


  // equalizer

  shouldBe : shouldBe,
  shouldBeNotError : shouldBeNotError,
  notIdentical : notIdentical,
  identical : identical,
  equivalent : equivalent,
  contain : contain,

  _shouldDo : _shouldDo,

  shouldThrowErrorSync : shouldThrowErrorSync,
  shouldThrowErrorAsync : shouldThrowErrorAsync,
  shouldThrowError : shouldThrowError,
  mustNotThrowError : mustNotThrowError,
  shouldMessageOnlyOnce : shouldMessageOnlyOnce,


  // output

  _outcomeConsider : _outcomeConsider,
  _exceptionConsider : _exceptionConsider,

  _outcomeReportAct : _outcomeReportAct,
  _outcomeReport : _outcomeReport,
  _outcomeReportBoolean : _outcomeReportBoolean,
  _outcomeReportCompare : _outcomeReportCompare,

  exceptionReport : exceptionReport,

  _currentTestCaseTextMake : _currentTestCaseTextMake,


  // relationships

  strictEventHandling : 0,
  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,
  Events : Events,

}

//

_.prototypeMake
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

wCopyable.mixin( Self );

_.accessorForbid( Self.prototype,Forbids );
_.accessor( Self.prototype,Accessors );

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;

})();
