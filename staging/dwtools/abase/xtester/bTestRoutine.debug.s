(function _bTestRoutine_debug_s_() {

'use strict';

//

var _global = _global_;
var _ = _global_.wTools;
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

  self._returnCon = null;

  self._reportForm();

  _.assert( _.routineIs( self.routine ) );
  _.assert( _.strIsNotEmpty( self.routine.name ),'Test routine should have name, ' + self.name + ' test routine of test suite',self.suite.name,'does not have name' );
  _.assert( Object.isPrototypeOf.call( _.TestSuite.prototype,self.suite ) );
  _.assert( Object.isPrototypeOf.call( Self.prototype,self ) );
  _.assert( arguments.length === 1, 'expects single argument' );

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

// --
// run
// --

function _testRoutineBegin()
{
  var trd = this;
  var suite = trd.suite;

  /* qqq : double check _hasConsoleInOutputs */
  suite._hasConsoleInOutputs = suite.logger._hasOutput( console,{ deep : 0, ignoringUnbar : 0 } );

  _.assert( arguments.length === 0 );

  var msg =
  [
    'Running test routine ( ' + trd.routine.name + ' ) ..'
  ];

  suite.logger.begin({ verbosity : -4 });

  suite.logger.begin({ 'routine' : trd.routine.name });
  suite.logger.logUp( msg.join( '\n' ) );
  suite.logger.end( 'routine' );

  suite.logger.end({ verbosity : -4 });

  _.assert( !suite.currentRoutine );
  suite.currentRoutine = trd;

  try
  {
    suite.onRoutineBegin.call( trd.context,trd );
    if( trd.eventGive )
    trd.eventGive({ kind : 'routineBegin', testRoutine : trd, context : trd.context });
  }
  catch( err )
  {
    suite._exceptionConsider( err );
  }

}

//

function _testRoutineEnd()
{
  var trd = this;
  var suite = trd.suite;
  var ok = trd._reportIsPositive();

  _.assert( arguments.length === 0 );
  _.assert( _.strIsNotEmpty( trd.routine.name ),'test routine should have name' );
  _.assert( suite.currentRoutine === trd );

  /* qqq : double check _hasConsoleInOutputs */
  var _hasConsoleInOutputs = suite.logger._hasOutput( console,{ deep : 0, ignoringUnbar : 0 } );

  if( suite._hasConsoleInOutputs !== _hasConsoleInOutputs )
  {
    var bar = _.Tester._bar.bar;
    debugger;

    _.Tester._bar.bar = 0;
    suite.logger.consoleBar( _.Tester._bar );

    if( bar )
    {
      _.Tester._bar.bar = bar;
      suite.logger.consoleBar( _.Tester._bar );
    }

    var err = _.err( 'Console is missing in logger`s outputs, probably logger was modified' + '\n at' + trd.nameFull );
    suite.exceptionReport
    ({
      err : err,
    });
  }

  try
  {
    suite.onRoutineEnd.call( trd.context,trd,ok );
    if( trd.eventGive )
    trd.eventGive({ kind : 'routineEnd', testRoutine : trd, context : trd.context });
  }
  catch( err )
  {
    suite._exceptionConsider( err );
  }

  if( trd.report.testCheckFails )
  suite.report.testRoutineFails += 1;
  else
  suite.report.testRoutinePasses += 1;

  suite.logger.begin( 'routine','end' );
  suite.logger.begin({ 'connotation' : ok ? 'positive' : 'negative' });

  suite.logger.begin({ verbosity : -3 });

  if( ok )
  {

    suite.logger.logDown( 'Passed test routine ( ' + trd.nameFull + ' ).' ); // xxx

  }
  else
  {

    suite.logger.begin({ verbosity : -3+suite.importanceOfNegative });
    suite.logger.logDown( 'Failed test routine ( ' + trd.nameFull + ' ).' ); // xxx
    suite.logger.end({ verbosity : -3+suite.importanceOfNegative });

  }

  suite.logger.end({ 'connotation' : ok ? 'positive' : 'negative' });
  suite.logger.end( 'routine','end' );

  suite.logger.end({ verbosity : -3 });

  suite.currentRoutine = null;

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
    args : [ 'Test routine ( ' + trd.nameFull + ' ) time out!' ],
    usingSourceCode : 0,
  });

  trd.description = '';

  if( err )
  {
    trd.exceptionReport
    ({
      err : err,
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

}

// --
// case
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

  _.assert( trd instanceof Self );
  _.assert( arguments.length === 0 || arguments.length === 1 );

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

function is( outcome )
{
  var trd = this;

  if( !_.boolLike( outcome ) || arguments.length !== 1 )
  {

    outcome = false;

    trd.exceptionReport
    ({
      err : '"is" expects single bool argument',
      level : 2,
    });

    // trd._outcomeReportBoolean
    // ({
    //   outcome : outcome,
    //   msg : '"is" expects single bool argument',
    // });

  }
  else
  {
    outcome = !!outcome;
    trd._outcomeReportBoolean
    ({
      outcome : outcome,
      msg : 'expected true',
    });
  }

  return outcome;
}

//

function isNot( outcome )
{
  var trd = this;

  if( !_.boolLike( outcome ) || arguments.length !== 1 )
  {

    outcome = false;

    trd.exceptionReport
    ({
      err : '"isNot" expects single bool argument',
      level : 2,
    });

    // trd._outcomeReportBoolean
    // ({
    //   outcome : outcome,
    //   msg : '"isNot" expects single bool argument',
    // });

  }
  else
  {
    outcome = !outcome;
    trd._outcomeReportBoolean
    ({
      outcome : outcome,
      msg : 'expected false',
    });
  }

  return outcome;
}

//

function isNotError( maybeError )
{
  var trd = this;
  var outcome = !_.errIs( maybeError );

  if( arguments.length !== 1 )
  {

    outcome = false;

    trd.exceptionReport
    ({
      err : '"isNotError" expects single argument',
      level : 2,
    });

    // trd._outcomeReportBoolean
    // ({
    //   outcome : outcome,
    //   msg : '"isNotError" expects single argument',
    // });

  }
  else
  {
    trd._outcomeReportBoolean
    ({
      outcome : outcome,
      msg : 'expected variable is not error',
    });
  }

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
 * @memberof wTestRoutineDescriptor
 */

function identical( got,expected )
{
  var trd = this;

  /* */

  try
  {
    var iterator = Object.create( null );
    var outcome = _.entityIdentical( got,expected,iterator );
  }
  catch( err )
  {
    trd.exceptionReport
    ({
      err : err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : '"identical" expects two argument',
      level : 2,
    });

    // trd._outcomeReportBoolean
    // ({
    //   outcome : outcome,
    //   msg : '"identical" expects two argument',
    // });

    return outcome;
  }

  /* */

  if( !iterator.iterator || iterator.iterator.lastPath === undefined )
  {
    outcome = false;
    trd._outcomeReportBoolean
    ({
      outcome : outcome,
      msg : 'something wrong with entityIdentical',
    });
    return outcome;
  }

  /* */

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : expected,
    path : iterator.iterator.lastPath,
    usingExtraDetails : 1,
  });

  /* */

  return outcome;
}

//

function notIdentical( got,expected )
{
  var trd = this;

  /* */

  try
  {
    var iterator = Object.create( null );
    var outcome = !_.entityIdentical( got,expected,iterator );
  }
  catch( err )
  {
    trd.exceptionReport
    ({
      err : err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : '"notIdentical" expects two argument',
      level : 2,
    });

    // trd._outcomeReportBoolean
    // ({
    //   outcome : outcome,
    //   msg : '"notIdentical" expects two argument',
    // });

    return outcome;
  }

  /* */

  if( !iterator.iterator || iterator.iterator.lastPath === undefined )
  {
    outcome = false;
    trd._outcomeReportBoolean
    ({
      outcome : outcome,
      msg : 'something wrong with entityIdentical',
    });
    return outcome;
  }

  /* */

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : expected,
    path : iterator.iterator.lastPath,
    usingExtraDetails : 0,
  });

  return outcome;
}

//

/**
 * Checks if test passes a specified condition by deep soft comparsing result of code execution( got )
 * with target( expected ). Uses recursive comparsion for objects,arrays and array-like objects. Two entities are equivalent if
 * difference between their values are less or equal to( accuracy ). Example: ( got - expected ) <= ( accuracy ).
 * If entity( got ) is equivalent to entity( expected ) test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {*} got - Source entity.
 * @param {*} expected - Target entity.
 * @param {*} [ accuracy=1e-7 ] - Maximal distance between two values.
 *
 * @example
 * function sometest( test )
 * {
 *  test.description = 'single number';
 *  var got = 0.5;
 *  var expected = 1;
 *  var accuracy = 0.5;
 *  test.equivalent( got, expected, accuracy );//returns true
 *
 *  test.description = 'single number';
 *  var got = 0.5;
 *  var expected = 2;
 *  var accuracy = 0.5;
 *  test.equivalent( got, expected, accuracy );//returns false
 * }
 * _.Tester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method equivalent
 * @memberof wTestRoutineDescriptor
 */

function equivalent( got, expected, options )
{
  var trd = this;

  /* */

  try
  {
    var iterator = Object.create( null );
    iterator.accuracy = trd.accuracy;
    if( _.mapIs( options ) )
    _.mapExtend( iterator, options )
    else if( _.numberIs( options ) )
    iterator.accuracy = options;
    else _.assert( options === undefined );
    var outcome = _.entityEquivalent( got, expected, iterator );
  }
  catch( err )
  {
    trd.exceptionReport
    ({
      err : err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 && arguments.length !== 3 )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : '"equivalent" expects two argument',
      level : 2,
    });

    // trd._outcomeReportBoolean
    // ({
    //   outcome : outcome,
    //   msg : '"equivalent" expects two argument',
    // });

    return outcome;
  }

  /* */

  if( !iterator.iterator || iterator.iterator.lastPath === undefined )
  {
    outcome = false;
    trd._outcomeReportBoolean
    ({
      outcome : outcome,
      msg : 'something wrong with entityIdentical',
    });
    return outcome;
  }

  /* */

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : expected,
    path : iterator.iterator.lastPath,
    usingExtraDetails : 1,
  });

  return outcome;
}

//

function notEquivalent( got, expected, options )
{
  var trd = this;

  /* */

  try
  {
    var iterator = Object.create( null );
    iterator.accuracy = trd.accuracy;
    if( _.mapIs( options ) )
    _.mapExtend( iterator, options )
    else if( _.numberIs( options ) )
    iterator.accuracy = options;
    else _.assert( options === undefined );
    var outcome = !_.entityEquivalent( got, expected, iterator );
  }
  catch( err )
  {
    trd.exceptionReport
    ({
      err : err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 && arguments.length !== 3 )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : '"notEquivalent" expects two argument',
      level : 2,
    });

    // trd._outcomeReportBoolean
    // ({
    //   outcome : outcome,
    //   msg : '"equivalent" expects two argument',
    // });
    return outcome;

  }

  /* */

  if( !iterator.iterator || iterator.iterator.lastPath === undefined )
  {
    outcome = false;
    trd._outcomeReportBoolean
    ({
      outcome : outcome,
      msg : 'something wrong with entityIdentical',
    });
    return outcome;
  }

  /* */

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : expected,
    path : iterator.iterator.lastPath,
    usingExtraDetails : 1,
  });

  return outcome;
}


//

/**
 * Checks if test passes a specified condition by deep contains comparsing result of code execution( got )
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
 *  test.contains( got, expected );//returns true
 *
 *  test.description = 'array';
 *  var got = [ 0, 1, 2 ];
 *  var expected = [ 4 ];
 *  test.contains( got, expected );//returns false
 * }
 * _.Tester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method contains
 * @memberof wTestRoutineDescriptor
 */

function contains( got,expected )
{
  var trd = this;

  /* */

  try
  {
    var iterator = Object.create( null );
    var outcome = _.entityContains( got, expected, iterator );
  }
  catch( err )
  {
    trd.exceptionReport
    ({
      err : err,
    });
    return false;
  }

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : '"contains" expects two argument',
      level : 2,
    });

    return outcome;
  }

  /* */

  if( !iterator.iterator || iterator.iterator.lastPath === undefined )
  {
    outcome = false;
    trd._outcomeReportBoolean
    ({
      outcome : outcome,
      msg : 'something wrong with entityIdentical',
    });
    return outcome;
  }

  /* */

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : expected,
    path : iterator.iterator.lastPath,
    usingExtraDetails : 1,
  });

  /* */

  return outcome;
}

//

function gt( got, than )
{
  var trd = this;
  var outcome = got > than;
  var diff = got - than;

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : '"gt" expects two argument',
      level : 2,
    });

    // trd._outcomeReportBoolean
    // ({
    //   outcome : outcome,
    //   msg : '"gt" expects two argument',
    // });

    return outcome;
  }

  /* */

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : than,
    nameOfPositiveExpected : 'greater than',
    nameOfNegativeExpected : 'not greater than',
    diff : diff,
    usingExtraDetails : 1,
  });

  return outcome;
}

//

function ge( got, than )
{
  var trd = this;
  var greater = got > than;
  var outcome = got >= than;
  var diff = got - than;

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : '"ge" expects two argument',
      level : 2,
    });

    // trd._outcomeReportBoolean
    // ({
    //   outcome : outcome,
    //   msg : '"ge" expects two argument',
    // });

    return outcome;
  }

  /* */

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : than,
    nameOfPositiveExpected : greater ? 'greater than' : 'identical with',
    nameOfNegativeExpected : 'not greater neither identical with',
    diff : diff,
    usingExtraDetails : 1,
  });

  /* */

  return outcome;
}

//

function lt( got, than )
{
  var trd = this;
  var outcome = got < than;
  var diff = got - than;

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : '"lt" expects two argument',
      level : 2,
    });

    // trd._outcomeReportBoolean
    // ({
    //   outcome : outcome,
    //   msg : '"gt" expects two argument',
    // });

    return outcome;
  }

  /* */

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : than,
    nameOfPositiveExpected : 'less than',
    nameOfNegativeExpected : 'not less than',
    diff : diff,
    usingExtraDetails : 1,
  });

  /* */

  return outcome;
}

//

function le( got, than )
{
  var trd = this;
  var less = got < than;
  var outcome = got <= than;
  var diff = got - than;

  /* */

  if( arguments.length !== 2 )
  {
    outcome = false;

    trd.exceptionReport
    ({
      err : '"le" expects two argument',
      level : 2,
    });

    // trd._outcomeReportBoolean
    // ({
    //   outcome : outcome,
    //   msg : '"ge" expects two argument',
    // });

    return outcome;
  }

  /* */

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : than,
    nameOfPositiveExpected : less ? 'less than' : 'identical with',
    nameOfNegativeExpected : 'not less neither identical with',
    diff : diff,
    usingExtraDetails : 1,
  });

  /* */

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
  var err, arg;
  var con = new _.Consequence();

  try
  {
    _.routineOptions( _shouldDo,o );
    _.assert( arguments.length === 1, 'expects single argument' );
    _.assert( o.args.length === 1 );
    _.assert( _.routineIs( o.args[ 0 ] ) );
  }
  catch( err )
  {
    err = _.errRestack( err, 3 );
    err = _._err
    ({
      args : [ 'Illegal usage of should in', trd.nameFull, '\n', err ],
    });
    err = trd.exceptionReport
    ({
      err : err,
    });
    debugger;
    con.error( err );
    if( !o.ignoringError && !o.expectingAsyncError && o.expectingSyncError )
    return false;
    else
    return con;
  }

  o.routine = o.args[ 0 ];
  var acheck = trd.checkCurrent();
  trd._inroutineCon.choke();

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
    return handleError( _err );
  }

  /* no sync error, but expected */

  if( !o.ignoringError && !o.expectingAsyncError && o.expectingSyncError && !err )
  return handleLackOfSyncError();

  /* */

  if( _.consequenceIs( result ) )
  handleAsyncResult()
  else
  handleSyncResult();

  /* */

  return con;

  /* */

  function handleError( _err )
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
      end( 1, err );
      return con;
    }

    trd.exceptionReport
    ({
      err : err,
      sync : 1,
      considering : 0,
      outcome : o.expectingSyncError,
    });

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
          msg : 'error thrown synchronously, what was not expected',
          stack : stack,
        });

      }

      end( o.expectingSyncError,err );

      if( !o.ignoringError && !o.expectingAsyncError && o.expectingSyncError )
      return err;
      else
      return con;
    }

  }

  /* */

  function handleLackOfSyncError()
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

    return false;
  }

  /* */

  function handleAsyncResult()
  {

    trd.checkNext();
    async = 1;

    // if( result.tag === 'strange' )
    // console.log( '1\n', result.toStr() );
    result.got( function( _err,_arg )
    {

      // if( result.tag === 'strange' )
      // console.log( '2\n', result.toStr() );

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

  /* */

  function handleSyncResult()
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

  /* */

  function end( positive, arg )
  {
    _.assert( arguments.length === 2, 'expects exactly two arguments' );

    logger.end({ verbosity : positive ? -5 : -5+trd.importanceOfNegative });
    logger.end({ connotation : positive ? 'positive' : 'negative' });

    if( reported )
    debugger;
    if( reported || async )
    trd.checkRestore();

    if( positive )
    con.give( undefined,arg );
    else
    con.give( arg,undefined );

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
      begin( 1 );

      trd._outcomeReportBoolean
      ({
        outcome : 1,
        msg : 'got single message',
        stack : stack,
      });

      end( 1, err ? err : arg );
    }
    else if( err )
    {
      begin( o.expectingAsyncError );

      trd.exceptionReport
      ({
        err : err,
        sync : 0,
        considering : 0,
        outcome : o.expectingAsyncError,
      });

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

      end( o.expectingAsyncError, err );
    }
    else
    {
      begin( !o.expectingAsyncError );

      var msg = 'error was not thrown asynchronously, but expected';
      if( o.expectingAsyncError )
      debugger;
      if( o.expectingAsyncError )
      msg = 'error was thrown asynchronously as expected';
      else if( !o.expectingAsyncError && !o.expectingSyncError && good )
      msg = 'error was not thrown as expected';

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

}

_shouldDo.defaults =
{
  args : null,
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
    args : arguments,
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
    args : arguments,
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
 *  var consequence = new _.Consequence().give();
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
 * @memberof wTestRoutineDescriptor
 */

function shouldThrowError( routine )
{
  var trd = this;

  return trd._shouldDo
  ({
    args : arguments,
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
    args : arguments,
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
    args : arguments,
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

  _.assert( arguments.length === 1, 'expects single argument' );
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
    // console.log( 'wTestRoutineDescriptor.testCheckFailsOfTestCase += 1' )
    // debugger;
  }

  trd.suite._outcomeConsider( outcome );

  trd.checkNext();

}

//

function _exceptionConsider( err )
{
  var trd = this;

  _.assert( arguments.length === 1, 'expects single argument' );
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
    if( trd._returnCon )
    trd._returnCon.cancel();
    _.Tester.cancel( _.err( 'Too many fails',_.Tester.settings.fails, '<=', trd.report.testCheckFails ) );
  }

  _.assert( arguments.length === 1, 'expects single argument' );

}

//

function _outcomeReport( o )
{
  var trd = this;
  var logger = trd.logger;
  var sourceCode = '';

  _.routineOptions( _outcomeReport,o );
  _.assert( arguments.length === 1, 'expects single argument' );

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
      else
      code = '\n' + _location.full;
    }

    if( code )
    code = ' #ignoreDirectives : 1# ' + code + ' #ignoreDirectives : 0# ';

    return code;
  }

  /* */

  logger.begin({ verbosity : o.verbosity });

  if( o.considering )
  {
    logger.begin({ 'check' : trd.description || trd._checkIndex });
    logger.begin({ 'checkIndex' : trd._checkIndex });
  }

  if( o.considering )
  trd._outcomeReportAct( o.outcome );

  /* */

  var verbosity = o.outcome ? 0 : trd.importanceOfNegative;
  sourceCode = sourceCodeGet();

  logger.begin({ verbosity : o.verbosity+verbosity });

  logger.up();
  if( logger.verbosityReserve() > 1 )
  logger.log();
  logger.begin({ 'connotation' : o.outcome ? 'positive' : 'negative' });

  logger.begin({ verbosity : o.verbosity-1+verbosity });

  if( o.details )
  logger.begin( 'details' ).log( o.details ).end( 'details' );

  if( sourceCode )
  logger.begin( 'sourceCode' ).log( sourceCode ).end( 'sourceCode' );

  logger.end({ verbosity : o.verbosity-1+verbosity });

  logger.begin( 'message' ).logDown( o.msg ).end( 'message' );

  logger.end({ 'connotation' : o.outcome ? 'positive' : 'negative' });
  if( logger.verbosityReserve() > 1 )
  logger.log();

  logger.end({ verbosity : o.verbosity+verbosity });

  // if( o.outcome )
  // {
  //   sourceCode = sourceCodeGet();
  //
  //   logger.begin({ verbosity : o.verbosity });
  //   logger.up();
  //   logger.begin({ 'connotation' : 'positive' });
  //
  //   logger.begin({ verbosity : o.verbosity-1 });
  //
  //   if( o.details )
  //   logger.begin( 'details' ).log( o.details ).end( 'details' );
  //
  //   if( sourceCode )
  //   logger.begin( 'sourceCode' ).log( sourceCode ).end( 'sourceCode' );
  //
  //   logger.end({ verbosity : o.verbosity-1 });
  //
  //   logger.begin( 'message' ).logDown( o.msg ).end( 'message' );
  //
  //   logger.end({ 'connotation' : 'positive' });
  //   if( logger.verbosityReserve() > 1 )
  //   logger.log();
  //
  //   logger.end({ verbosity : o.verbosity });
  // }
  // else
  // {
  //   sourceCode = sourceCodeGet();
  //
  //   logger.begin({ verbosity : o.verbosity+trd.importanceOfNegative });
  //
  //   logger.up();
  //   if( logger.verbosityReserve() > 1 )
  //   logger.log();
  //   logger.begin({ 'connotation' : 'negative' });
  //
  //   logger.begin({ verbosity : o.verbosity-1+trd.importanceOfNegative });
  //
  //   if( o.details )
  //   logger.begin( 'details' ).log( o.details ).end( 'details' );
  //
  //   if( sourceCode )
  //   logger.begin( 'sourceCode' ).log( sourceCode ).end( 'sourceCode' );
  //
  //   logger.end({ verbosity : o.verbosity-1+trd.importanceOfNegative });
  //
  //   logger.begin( 'message' ).logDown( o.msg ).end( 'message' );
  //
  //   logger.end({ 'connotation' : 'negative' });
  //   if( logger.verbosityReserve() > 1 )
  //   logger.log();
  //
  //   logger.end({ verbosity : o.verbosity+trd.importanceOfNegative });
  //
  // }

  if( o.considering )
  logger.end( 'check','checkIndex' );
  logger.end({ verbosity : o.verbosity });

}

_outcomeReport.defaults =
{
  outcome : null,
  msg : null,
  details : null,
  stack : null,
  usingSourceCode : 1,
  considering : 1,
  verbosity : -4,
}

//

function _outcomeReportBoolean( o )
{
  var trd = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( _outcomeReportBoolean,o );

  o.msg = trd._reportTestCaseTextMake
  ({
    outcome : o.outcome,
    msg : o.msg,
    usingDescription : o.usingDescription,
  });

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

  _.assert( trd._testRoutineDescriptorIs );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptionsWithUndefines( _outcomeReportCompare,o );

  var nameOfExpected = ( o.outcome ? o.nameOfPositiveExpected : o.nameOfNegativeExpected );
  var details = '';

  /**/

  if( !o.outcome )
  if( o.usingExtraDetails )
  {
    details += _.entityDiffDescription
    ({
      src1 : o.got,
      src2 : o.expected,
      path : o.path,
      name1 : 'got',
      name2 : 'expected',
    });
  }

  var msg = trd._reportTestCaseTextMake({ outcome : o.outcome });

  trd._outcomeReport
  ({
    outcome : o.outcome,
    msg : msg,
    details : details,
  });

  if( !o.outcome )
  if( trd.debug )
  debugger;

  /**/

  function msgExpectedGot()
  {
    return '' +
    'got :\n' + _.toStr( o.got,{ stringWrapper : '\'' } ) + '\n' +
    nameOfExpected + ' :\n' + _.toStr( o.expected,{ stringWrapper : '\'' } ) +
    '';
  }

}

_outcomeReportCompare.defaults =
{
  got : null,
  expected : null,
  diff : null,
  nameOfPositiveExpected : 'expected',
  nameOfNegativeExpected : 'expected',
  outcome : null,
  path : null,
  usingExtraDetails : 1,
}

//

function exceptionReport( o )
{
  var trd = this;

  _.routineOptions( exceptionReport,o );
  _.assert( arguments.length === 1, 'expects single argument' );

  o.stack = o.stack || o.err.stack;

  if( trd.onError )
  debugger;
  if( trd.onError )
  trd.onError.call( trd,o );

  var msg = null;
  if( o.considering )
  {
    msg = trd._reportTestCaseTextMake({ outcome : null }) + ' ... failed throwing error';
  }
  else
  {
    msg = 'Error throwen'
  }

  if( o.sync !== null )
  msg += ( o.sync ? ' synchronously' : ' asynchronously' );

  var err = _._err({ args : [ o.err ], level : _.numberIs( o.level ) ? o.level+1 : o.level });
  _.errAttend( err );
  var details = err.toString();

  if( o.considering )
  trd._exceptionConsider( err );

  trd._outcomeReport
  ({
    outcome : o.outcome,
    msg : msg,
    details : details,
    stack : o.stack,
    usingSourceCode : o.usingSourceCode,
    considering : o.considering,
  });

  return err;
}

exceptionReport.defaults =
{
  err : null,
  level : null,
  stack : null,
  usingSourceCode : 0,
  considering : 1,
  outcome : 0,
  sync : null,
}

// --
// report
// --

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

function _reportIsPositive()
{
  var self = this;

  if( self.report.testCheckFails !== 0 )
  return false;

  if( !( self.report.testCheckPasses > 0 ) )
  return false;

  if( self.report.errorsArray.length )
  return false;

  return true;
}

//

function _reportTestCaseTextMake( o )
{
  var trd = this;

  o = _.routineOptions( _reportTestCaseTextMake,o );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( o.outcome === null || _.boolLike( o.outcome ) );
  _.assert( o.msg === null || _.strIs( o.msg ) );
  _.assert( trd._testRoutineDescriptorIs );
  _.assert( trd._checkIndex >= 0 );
  _.assert( _.strIsNotEmpty( trd.routine.name ),'test routine descriptor should have name' );

  // var name = trd.routine.name;
  var name = trd.nameFull;
  if( trd.description && o.usingDescription )
  name += ' : ' + trd.description;

  var result = '' +
    'Test check' + ' ( ' + name + ' )' +
    ' # ' + trd._checkIndex
  ;

  if( o.msg )
  result += ' : ' + o.msg;

  if( o.outcome !== null )
  {
    if( o.outcome )
    result += ' ... ok';
    else
    result += ' ... failed';
  }

  return result;
}

_reportTestCaseTextMake.defaults =
{
  outcome : null,
  msg : null,
  usingDescription : 1,
}

// --
// etc
// --

function _accuracySet( accuracy )
{
  var trd = this;
  if( !_.numberIs( accuracy ) )
  accuracy = null;
  trd[ accuracySymbol ] = accuracy;
  return accuracy;
}

//

function _accuracyGet( accuracy )
{
  var trd = this;
  if( trd[ accuracySymbol ] !== null )
  return trd[ accuracySymbol ];
  return trd.suite.accuracy;
}

//

function _nameFullGet()
{
  var trd = this;
  return trd.suite.name + ' / ' + trd.name;
}

// --
// var
// --

var descriptionSymbol = Symbol.for( 'description' );
var accuracySymbol = Symbol.for( 'accuracy' );

// --
// relationships
// --

var Composes =
{
  name : null,
  description : null,
  accuracy : null,
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
  _cancelCon : '_cancelCon',
  _storedStates : '_storedStates',
  _currentRoutineFails : '_currentRoutineFails',
  _currentRoutinePasses : '_currentRoutinePasses',
}

var AccessorsReadOnly =
{
  nameFull : 'nameFull',
}

var Accessors =
{
  description : 'description',
  will : 'will',
  accuracy : 'accuracy',
}

// --
// define class
// --

var Proto =
{

  // inter

  init : init,

  // run

  _testRoutineBegin : _testRoutineBegin,
  _testRoutineEnd : _testRoutineEnd,
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

  is : is,
  isNot : isNot,
  isNotError : isNotError,

  identical : identical,
  notIdentical : notIdentical,
  equivalent : equivalent,
  notEquivalent : notEquivalent,
  contains : contains,

  il : identical,
  ni : notIdentical,
  et : equivalent,
  ne : notEquivalent,

  gt : gt,
  ge : ge,
  lt : lt,
  le : le,

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

  // report

  _reportForm : _reportForm,
  _reportIsPositive : _reportIsPositive,
  _reportTestCaseTextMake : _reportTestCaseTextMake,

  // etc

  _accuracySet : _accuracySet,
  _accuracyGet : _accuracyGet,
  _nameFullGet : _nameFullGet,

  // relationships

  strictEventHandling : 0,
  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,
  Events : Events,
  Forbids : Forbids,
  AccessorsReadOnly : AccessorsReadOnly,
  Accessors : Accessors,

}

//

_.classMake
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_[ Self.nameShort ] = Self;

})();
