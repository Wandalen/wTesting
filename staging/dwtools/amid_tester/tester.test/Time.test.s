( function _Time_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  var _ = _global_.wTools;

  _.include( 'wTesting' );
  _.include( 'wConsequence' );

}

var _global = _global_;
var _ = _global_.wTools;

//

function timeOut( test )
{
  var c = this;
  var testCon = new _.Consequence().give()

  /* */

  .doThen( function()
  {
    test.case = 'delay only';
    var timeBefore = _.timeNow();
    return _.timeOut( c.delay )
    .doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.is( _.routineIs( got ) );
    });
  })

  /* */

  .doThen( function()
  {
    test.case = 'delay + routine';
    var timeBefore = _.timeNow();
    return _.timeOut( c.delay, () => {} )
    .doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, undefined );
      test.identical( err, undefined );
    });
  })

  /* */

  .doThen( function()
  {
    test.case = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    return _.timeOut( c.delay, () => value )
    .doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, value );
      test.identical( err, undefined );
    });
  })

  /* */

  .doThen( function()
  {
    test.case = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    return _.timeOut( c.delay, () => _.timeOut( c.delay ) )
    .doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.is( elapsedTime >= c.delay * 2 );
      test.is( _.routineIs( got ) );
      test.identical( err, undefined );
    });
  })

  /* */

  .doThen( function()
  {
    test.case = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    return _.timeOut( c.delay, () => { _.timeOut( c.delay ) } )
    .doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( err, undefined );
      test.identical( got, undefined );
    });
  })

  /* */

  .doThen( function()
  {
    test.case = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay / 2;
    }
    return _.timeOut( c.delay, undefined, r, [ c.delay ] )
    .doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, c.delay / 2 );
      test.identical( err, undefined );
    });
  })

  /* */

  .doThen( function()
  {
    test.case = 'delay + consequence';
    var timeBefore = _.timeNow();

    return _.timeOut( c.delay, _.timeOut( c.delay * 2 ) )
    .doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.is( elapsedTime >= c.delay * 2 );
      test.is( _.routineIs( got ) );
      test.identical( err, undefined );
    });
  })

  /* */

  .doThen( function()
  {
    test.case = 'delay + consequence that returns delayed value, launched serially';
    var timeBefore = _.timeNow();
    var val = 13;

    return _.timeOut( c.delay, () => _.timeOut( c.delay * 2, () => val ) )
    .doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay * 3-timeAccuracy );
      test.identical( err, undefined );
      test.identical( got, val );
    })
  })

  /* */

  .doThen( function()
  {
    test.case = 'delay + consequence that returns delayed value, launched concurrently';
    var timeBefore = _.timeNow();
    var val = 13;

    return _.timeOut( c.delay, _.timeOut( c.delay * 2, () => val ) )
    .doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore; xxx
      test.ge( elapsedTime, c.delay * 2-timeAccuracy );
      test.identical( err, undefined );
      test.identical( got, val );
    })
  })

  /* */

  .doThen( function()
  {
    test.case = 'delay + consequence that returns delayed value, launched concurrently';
    var timeBefore = _.timeNow();

    return _.timeOut( c.delay, _.timeOut( c.delay * 2, () => _.timeOut( c.delay * 2 ) ) )
    .doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay * 4-timeAccuracy );
      test.identical( err, undefined );
      test.identical( got, _.timeOut );
    })
  })

  /* */

  .doThen( function()
  {
    test.case = 'delay + consequence + error';
    var timeBefore = _.timeNow();

    return _.timeOut( c.delay, _.timeOut( c.delay * 2, () => { throw 'err' } ) )
    .doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.is( elapsedTime >= c.delay * 2 );
      test.is( _.errIs( err ) );
      test.identical( got, undefined );
    });
  })

  /* */

  .doThen( function()
  {
    test.case = 'stop timer with error';
    var timeBefore = _.timeNow();

    var t = _.timeOut( c.delay );
    t.doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay / 2 - c.timeAccuracy );
      test.identical( err, 'stop' );
      test.identical( got, undefined );
    })
    _.timeOut( c.delay / 2, () => t.error( 'stop' ) );

    return t;
  })

  /* */

  .doThen( function()
  {
    test.case = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOut( c.delay, () => { called = true } );
    t.doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay / 2 - c.timeAccuracy );
      test.identical( got, undefined );
      test.identical( err, 'stop' );
      test.identical( called, false );
    })
    _.timeOut( c.delay / 2, () => t.error( 'stop' ) );

    return t;
  })

  /* */

  .doThen( function()
  {
    test.case = 'give err after timeOut';
    var timeBefore = _.timeNow();

    var t = _.timeOut( c.delay, () => {} );
    t.got( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, undefined );
      test.identical( err, undefined );
    });

    return _.timeOut( c.delay + 50, function()
    {
      t.error( 'stop' );
      t.got( ( err, got ) => test.identical( err, 'stop' ) );
    });

    return t;
  })

  /* */

  .doThen( function()
  {
    test.case = 'give msg before timeOut';
    var timeBefore = _.timeNow();
    var returnValue = 1;
    var msg = 2;

    var t = _.timeOut( c.delay, () => returnValue );

    return _.timeOut( c.delay / 2, function()
    {
      t.give( msg );
      t.got( ( err, got ) => test.identical( got, msg ) );
      t.got( ( err, got ) =>
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got, returnValue );
      })
    })

    return t;
  })

  /* */

  .doThen( function()
  {
    test.case = 'stop timer with error + arg, routine passed';
    var timeBefore = _.timeNow();
    var called = false;
    var stop = 'stop';

    var t = _.timeOut( c.delay, () => { called = true } );
    t.doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay / 2 - c.timeAccuracy );
      test.identical( got, undefined );
      test.identical( err, stop );
      test.identical( called, false );
    })
    _.timeOut( c.delay / 2, () => t.give( stop, undefined ) );

    return t;
  })

  /* */

  .doThen( function()
  {
    if( !Config.debug )
    return;

    test.case = 'delay must be number';
    test.shouldThrowError( () => _.timeOut( 'x' ) )

    test.case = 'if two arguments provided, second must consequence/routine';
    test.shouldThrowError( () => _.timeOut( 0, 'x' ) )

    test.case = 'if four arguments provided, third must routine';
    test.shouldThrowError( () => _.timeOut( 0, {}, 'x', [] ) )
  })

  return testCon;
}

timeOut.timeOut = 30000;

//

function timeOutError( test )
{
  var c = this;
  var testCon = new _.Consequence().give()

  /* */

  .doThen( function()
  {
    test.case = 'delay only';
    var timeBefore = _.timeNow();
    return _.timeOutError( c.delay )
    .doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.is( _.errIs( err ) );
    });
  })

  /* */

  .doThen( function()
  {
    test.case = 'delay + routine';
    var timeBefore = _.timeNow();
    return _.timeOutError( c.delay, () => {} )
    .doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, undefined );
      test.is( _.errIs( err ) );
    });
  })

  /* */

  .doThen( function()
  {
    test.case = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    return _.timeOutError( c.delay, () => value )
    .doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, undefined );
      test.is( _.errIs( err ) );
    });
  })

  // /* */

  .doThen( function()
  {
    test.case = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    return _.timeOutError( c.delay, () => _.timeOut( c.delay ) )
    .doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.is( elapsedTime >= c.delay * 2 );
      test.identical( got, undefined );
      test.is( _.errIs( err ) );
    });
  })

  /* */

  .doThen( function()
  {
    test.case = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    return _.timeOutError( c.delay, () => { _.timeOut( c.delay ) } )
    .doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, undefined );
      test.is( _.errIs( err ) );
    });
  })

  /* */

  .doThen( function()
  {
    test.case = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay / 2;
    }
    return _.timeOutError( c.delay, undefined, r, [ c.delay ] )
    .doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, undefined );
      test.is( _.errIs( err ) );
    });
  })

  /* */

  .doThen( function()
  {
    test.case = 'delay + consequence';
    var timeBefore = _.timeNow();

    return _.timeOutError( c.delay, _.timeOut( c.delay * 2 ) )
    .doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay * 2-timeAccuracy );
      test.identical( got, undefined );
      test.is( _.errIs( err ) );
    });

  })

  /* */

  .doThen( function()
  {
    test.case = 'stop timer with error';
    var timeBefore = _.timeNow();

    var t = _.timeOutError( c.delay );
    t.doThen( function( err, got )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay / 2 - c.timeAccuracy );
      test.identical( got, undefined );
      test.is( !!err );
      test.identical( t.resourcesGet().length, 0 );
    })
    _.timeOut( c.delay / 2, () => t.error( 'stop' ) );

    return t;
  })

  /* */

  .doThen( function()
  {
    test.case = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOutError( c.delay, () => { called = true } );
    t.doThen( function( err, arg )
    {
      var elapsedTime = _.timeNow() - timeBefore;
      test.ge( elapsedTime, c.delay / 2 - c.timeAccuracy );
      test.identical( arg, undefined );
      test.identical( err, 'stop' );
      test.identical( called, false );
      test.identical( t.resourcesGet().length, 0 );
    })
    _.timeOut( c.delay / 2, () => t.error( 'stop' ) );

    return t;
  })

  .doThen( function( err,arg )
  {
    return;
  });

  return testCon;
}

timeOutError.timeOut = 30000;

//

function timeOutMode01( test )
{
  var c = this;
  var mode = _.Consequence.asyncModeGet();
  var testCon = new _.Consequence().give()

  /* asyncTaking : 0, asyncGiving : 1 */

  .doThen( () => _.Consequence.asyncModeSet([ 0, 1 ]) )
  .doThen( function()
  {
    debugger;
    test.case = 'delay only';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( _.routineIs( got ) );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'delay + routine';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => {} );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got , undefined );
        test.is( err === undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    var t = _.timeOut( c.delay, () => value );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( got === value );
        test.is( err === undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => _.timeOut( c.delay ) );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( _.routineIs( got ));
        test.is( err === undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => _.timeOut( c.delay ) );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got, _.timeOut );
        test.identical( err, undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay * 13;
    }
    var t = _.timeOut( c.delay, undefined, r, [ c.delay ] );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got, c.delay * 13 );
        test.identical( err, undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'stop timer with error';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay );
    _.timeOut( c.delay / 2, () => t.error( 'stop' ) );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime , c.delay / 2 );
        test.identical( got , undefined );
        test.identical( err , 'stop' );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOut( c.delay, () => { called = true } );
    _.timeOut( c.delay / 2, () => t.error( 'stop' ) );

    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime , c.delay / 2 );
        test.identical( got, undefined );
        test.identical( err, 'stop' );
        test.identical( called, false );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'give err after timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => {} );

    var con = new _.Consequence();
    con.first( t );
    con.doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got, undefined );
        test.identical( err, undefined );
      })
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })

    return _.timeOut( c.delay + 50, function()
    {
      t.error( 'stop' );
      t.got( ( err, got ) => test.identical( err, 'stop' ) );
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .doThen( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );

      _.Consequence.asyncModeSet( mode );

    });

  })

  return testCon;
}

timeOutMode10.timeOut = 30000;

//

function timeOutMode10( test )
{
  var c = this;
  var mode = _.Consequence.asyncModeGet();
  var testCon = new _.Consequence().give()
  /* asyncTaking : 1, asyncGiving : 0, */

  .doThen( () => _.Consequence.asyncModeSet([ 1, 0 ]) )
  .doThen( function()
  {
    test.case = 'delay only';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( _.routineIs( got ) );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .timeOutThen( 1, function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'delay + routine';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => {} );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got , undefined );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .timeOutThen( 1, function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    var t = _.timeOut( c.delay, () => value );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( got === value );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => _.timeOut( c.delay ) );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( _.routineIs( got ));
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => { _.timeOut( c.delay ) } );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got , undefined );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay / 2;
    }
    var t = _.timeOut( c.delay, undefined, r, [ c.delay ] );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( got === c.delay / 2 );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'stop timer with error';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay );
    _.timeOut( c.delay / 2, () => t.error( 'stop' ) );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime , c.delay / 2 );
        test.identical( got , undefined );
        test.identical( err , 'stop' );
        test.identical( t.resourcesGet().length, 0 );
        test.identical( t.competitorsEarlyGet().length, 0 );
      });

      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOut( c.delay, () => { called = true } );
    _.timeOut( c.delay / 2, () => t.error( 'stop' ) );

    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime , c.delay / 2 );
        test.identical( got, undefined );
        test.identical( err, 'stop' );
        test.identical( called, false );
        test.identical( t.resourcesGet().length, 0 );
        test.identical( t.competitorsEarlyGet().length, 0 );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'give err after timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => {} );

    var con = new _.Consequence();
    con.first( t );
    con.doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got, undefined );
        test.identical( err, undefined );
      })
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
    .doThen( function()
    {
      t.error( 'stop' );
      t.got( ( err, got ) => test.identical( err, 'stop' ) );
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );

      _.Consequence.asyncModeSet( mode );

    });

    return con;
  })

  return testCon;
}

timeOutMode01.timeOut = 30000;

//

function timeOutMode11( test )
{
  var c = this;
  var mode = _.Consequence.asyncModeGet();
  var testCon = new _.Consequence().give()

  /* asyncGiving : 1, asyncTaking : 1 */

  .doThen( () => _.Consequence.asyncModeSet([ 1, 1 ]) )
  .doThen( function()
  {
    test.case = 'delay only';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( _.routineIs( got ) );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .timeOutThen( 1, function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'delay + routine';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => {} );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got , undefined );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .timeOutThen( 1, function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    var t = _.timeOut( c.delay, () => value );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( got === value );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => _.timeOut( c.delay ) );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( _.routineIs( got ));
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => { _.timeOut( c.delay ) } );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got , undefined );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay / 2;
    }
    var t = _.timeOut( c.delay, undefined, r, [ c.delay ] );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( got === c.delay / 2 );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'stop timer with error';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay );
    _.timeOut( c.delay / 2, () => t.error( 'stop' ) );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime , c.delay / 2 );
        test.identical( got , undefined );
        test.identical( err , 'stop' );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOut( c.delay, () => { called = true } );
    _.timeOut( c.delay / 2, () => t.error( 'stop' ) );

    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime , c.delay / 2 );
        test.identical( got, undefined );
        test.identical( err, 'stop' )
        test.identical( called, false );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.case = 'give err after timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( c.delay, () => {} );

    var con = new _.Consequence();
    con.first( t );
    con.doThen( function()
    {
      t.got( function( err, got )
      {
        var elapsedTime = _.timeNow() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got, undefined );
        test.identical( err, undefined );
      })
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
    })
    .doThen( function()
    {
      t.error( 'stop' );
      t.got( ( err, got ) => test.identical( err, 'stop' ) );
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );

      _.Consequence.asyncModeSet( mode );

    });

    return con;
  })

  return testCon;
}

timeOutMode11.timeOut = 30000;

//

var Self =
{

  name : 'Tools/Time/' + Math.floor( Math.random()*100000 ),
  silencing : 1,
  // enabled : 0, // !!!

  context :
  {
    timeAccuracy : 1,
    delay : 200,
  },

  tests :
  {

    timeOut : timeOut,
    timeOutError : timeOutError,

    timeOutMode01 : timeOutMode01,
    timeOutMode10 : timeOutMode10,
    timeOutMode11 : timeOutMode11,

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
