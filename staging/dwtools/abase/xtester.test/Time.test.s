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

  var _global = _global_; var _ = _global_.wTools;

  _.include( 'wTesting' );
  _.include( 'wConsequence' );

}

var _global = _global_; var _ = _global_.wTools;

//

function timeOut( test )
{
  var delay = 350;
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
      var time = _.timeNow() - timeBefore;
      // test.description = 'stop timer with error + arg, routine passed, time:' + time;
      console.log( 'time', time );
      test.shouldBe( time >= delay / 2 );
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

//

function timeOutAsync( test )
{
  var delay = 300;
  function setAsync( giving, taking )
  {
    wConsequence.prototype.asyncGiving = giving;
    wConsequence.prototype.asyncTaking = taking;
  }
  var testCon = new _.Consequence().give()

  /* asyncGiving : 1, asyncTaking : 0 */

  .doThen( () => setAsync( 1, 0 ) )
  .doThen( function()
  {
    test.description = 'delay only';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( _.routineIs( got ) );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => {} );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === undefined );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    var t = _.timeOut( delay, () => value );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === value );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => _.timeOut( delay ) );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay * 2 );
        test.shouldBe( _.routineIs( got ));
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => { _.timeOut( delay ) } );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === undefined );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay / 2;
    }
    var t = _.timeOut( delay, undefined, r, [ delay ] );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === delay / 2 );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'stop timer with error';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay );
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
        test.shouldBe( got === 'stop' );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOut( delay, () => { called = true } );
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );

    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
        test.identical( got, 'stop' );
        test.identical( called, false );
        test.identical( err, null )
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'give err after timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => {} );

    var con = new _.Consequence();
    con.first( t );
    con.doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.identical( got, undefined );
        test.identical( err, null );
      })
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })

    return _.timeOut( delay + 50, function()
    {
      t.error( 'stop' );
      t.got( ( err, got ) => test.identical( err, 'stop' ) );
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen( function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    });
  })

  /* asyncGiving : 0, asyncTaking : 1 */

  .doThen( () => setAsync( 0, 1 ) )
  .doThen( function()
  {
    test.description = 'delay only';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( _.routineIs( got ) );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1, function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => {} );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === undefined );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1, function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    var t = _.timeOut( delay, () => value );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === value );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => _.timeOut( delay ) );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay * 2 );
        test.shouldBe( _.routineIs( got ));
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => { _.timeOut( delay ) } );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === undefined );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay / 2;
    }
    var t = _.timeOut( delay, undefined, r, [ delay ] );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === delay / 2 );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'stop timer with error';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay );
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
        test.shouldBe( got === 'stop' );
        test.shouldBe( err === null );
        test.identical( t.messagesGet().length, 0 );
        test.identical( t.correspondentsEarlyGet().length, 0 );
      });

      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOut( delay, () => { called = true } );
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );

    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
        test.identical( got, 'stop' );
        test.identical( called, false );
        test.identical( err, null );
        test.identical( t.messagesGet().length, 0 );
        test.identical( t.correspondentsEarlyGet().length, 0 );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'give err after timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => {} );

    var con = new _.Consequence();
    con.first( t );
    con.doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.identical( got, undefined );
        test.identical( err, null );
      })
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
    .doThen( function()
    {
      t.error( 'stop' );
      t.got( ( err, got ) => test.identical( err, 'stop' ) );
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    });

    return con;
  })

  /* asyncGiving : 1, asyncTaking : 1 */

  .doThen( () => setAsync( 1, 1 ) )
  .doThen( function()
  {
    test.description = 'delay only';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( _.routineIs( got ) );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1, function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => {} );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === undefined );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1, function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    var t = _.timeOut( delay, () => value );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === value );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => _.timeOut( delay ) );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay * 2 );
        test.shouldBe( _.routineIs( got ));
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => { _.timeOut( delay ) } );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === undefined );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay / 2;
    }
    var t = _.timeOut( delay, undefined, r, [ delay ] );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === delay / 2 );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'stop timer with error';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay );
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );
    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
        test.shouldBe( got === 'stop' );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOut( delay, () => { called = true } );
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );

    return new _.Consequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
        test.identical( got, 'stop' );
        test.identical( called, false );
        test.identical( err, null )
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'give err after timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => {} );

    var con = new _.Consequence();
    con.first( t );
    con.doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.identical( got, undefined );
        test.identical( err, null );
      })
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
    .doThen( function()
    {
      t.error( 'stop' );
      t.got( ( err, got ) => test.identical( err, 'stop' ) );
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    });

    return con;
  })

  return testCon;
}

timeOutAsync.timeOut = 30000;

//

function timeOutError( test )
{
  var delay = 100;
  var testCon = new _.Consequence().give()

  /* */

  .doThen( function()
  {
    test.description = 'delay only';
    var timeBefore = _.timeNow();
    return _.timeOutError( delay )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.shouldBe( _.errIs( err ) );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + routine';
    var timeBefore = _.timeNow();
    return _.timeOutError( delay, () => {} )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.identical( got, undefined );
      test.shouldBe( _.errIs( err ) );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    return _.timeOutError( delay, () => value )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.identical( got, undefined );
      test.shouldBe( _.errIs( err ) );
    });
  })

  // /* */

  .doThen( function()
  {
    test.description = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    return _.timeOutError( delay, () => _.timeOut( delay ) )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay * 2 );
      test.identical( got, undefined );
      test.shouldBe( _.errIs( err ) );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    return _.timeOutError( delay, () => { _.timeOut( delay ) } )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.identical( got, undefined );
      test.shouldBe( _.errIs( err ) );
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
    return _.timeOutError( delay, undefined, r, [ delay ] )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.identical( got, undefined );
      test.shouldBe( _.errIs( err ) );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + consequence';
    var timeBefore = _.timeNow();

    return _.timeOutError( delay, _.timeOut( delay * 2 ) )
    .doThen( function( err, got )
    {
      console.log( 'xxx' );
      test.shouldBe( _.timeNow() - timeBefore >= delay * 2 );
      test.identical( got, undefined );
      test.shouldBe( _.errIs( err ) );
    });

  })

  /* */

  .doThen( function()
  {
    test.description = 'stop timer with error';
    var timeBefore = _.timeNow();

    var t = _.timeOutError( delay );
    t.doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
      test.identical( got, undefined );
      test.shouldBe( !!err );
      test.identical( t.messagesGet().length, 0 );
    })
    _.timeOut( delay / 2, () => t.error( 'stop' ) );

    return t;
  })

  /* */

  .doThen( function()
  {
    test.description = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOutError( delay, () => { called = true } );
    t.doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
      test.identical( got, undefined );
      test.identical( called, false );
      test.shouldBe( !!err );
      test.identical( t.messagesGet().length, 0 );
    })
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );

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

var Self =
{

  name : 'Time' + Math.random(),
  silencing : 1,

  tests :
  {
    timeOut : timeOut,
    timeOutAsync : timeOutAsync,
    timeOutError : timeOutError
  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
