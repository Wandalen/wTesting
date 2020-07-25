( function _Time_test_s_( ) {

'use strict';

/* xxx : remove the suite from tester */

if( typeof module !== 'undefined' )
{

  try
  {
    let _ = require( '../../../../wtools/Tools.s' );
  }
  catch( err )
  {
    let _ = require( '../../../wtools/Tools.s' );
  }

  let _ = _global_.wTools;

  try
  {
    require( '../tester/entry/Main.s' );
  }
  catch( err )
  {
    _.include( 'wTesting' );
  }

  _.include( 'wConsequence' );

}

let _global = _global_;
let _ = _global_.wTools;

// --
// basic
// --

function timerIs( test )
{
  test.case = 'without argument';
  var got = _.timerIs();
  test.identical( got, false );

  test.case = 'check null';
  var got = _.timerIs( null );
  test.identical( got, false );

  test.case = 'check undefined';
  var got = _.timerIs( undefined );
  test.identical( got, false );

  test.case = 'check _.nothing';
  var got = _.timerIs( _.nothing );
  test.identical( got, false );

  test.case = 'check zero';
  var got = _.timerIs( 0 );
  test.identical( got, false );

  test.case = 'check empty string';
  var got = _.timerIs( '' );
  test.identical( got, false );

  test.case = 'check false';
  var got = _.timerIs( false );
  test.identical( got, false );

  test.case = 'check NaN';
  var got = _.timerIs( NaN );
  test.identical( got, false );

  test.case = 'check Symbol';
  var got = _.timerIs( Symbol() );
  test.identical( got, false );

  test.case = 'check empty array';
  var got = _.timerIs( [] );
  test.identical( got, false );

  test.case = 'check empty arguments array';
  var got = _.timerIs( _.argumentsArrayMake( [] ) );
  test.identical( got, false );

  test.case = 'check empty unroll';
  var got = _.timerIs( _.unrollMake( [] ) );
  test.identical( got, false );

  test.case = 'check empty map';
  var got = _.timerIs( {} );
  test.identical( got, false );

  test.case = 'check empty pure map';
  var got = _.timerIs( Object.create( null ) );
  test.identical( got, false );

  test.case = 'check empty Set';
  var got = _.timerIs( new Set( [] ) );
  test.identical( got, false );

  test.case = 'check empty Map';
  var got = _.timerIs( new Map( [] ) );
  test.identical( got, false );

  test.case = 'check empty BufferRaw';
  var got = _.timerIs( new BufferRaw() );
  test.identical( got, false );

  test.case = 'check empty BufferTyped';
  var got = _.timerIs( new U8x() );
  test.identical( got, false );

  test.case = 'check number';
  var got = _.timerIs( 3 );
  test.identical( got, false );

  test.case = 'check bigInt';
  var got = _.timerIs( 1n );
  test.identical( got, false );

  test.case = 'check object Number';
  var got = _.timerIs( new Number( 2 ) );
  test.identical( got, false );

  test.case = 'check string';
  var got = _.timerIs( 'str' );
  test.identical( got, false );

  test.case = 'check not empty array';
  var got = _.timerIs( [ null ] );
  test.identical( got, false );

  test.case = 'check not empty map';
  var got = _.timerIs( { '' : null } );
  test.identical( got, false );

  test.case = 'check instance of constructor';
  var Constr = function(){ this.x = 1; return this };
  var src = new Constr();
  var got = _.timerIs( src );
  test.identical( got, false );

  test.case = 'check _begin timer';
  var src = _.time._begin( undefined );
  var got = _.timerIs( src );
  test.identical( got, true );
  _.time.cancel( src );

  test.case = 'check _finally timer';
  var src = _.time._finally( undefined, undefined );
  var got = _.timerIs( src );
  test.identical( got, true );
  _.time.cancel( src );

  test.case = 'check _periodic timer';
  var src = _.time._periodic( 1000, ( t ) => t.original );
  var got = _.timerIs( src );
  test.identical( got, true );
  _.time.cancel( src );

  test.case = 'check imitation of timer';
  var src = { type : 'timer', time : true, cancel : true, original : true  };
  var got = _.timerIs( src );
  test.identical( got, true );
}

//

function _begin( test )
{
  var onTime = () => 0;
  var onCancel = () => -1;
  var con = new _.Consequence().take( null );

  /* - */

  con.finally( () =>
  {
    test.open( 'delay - undefined' );
    return null;
  })

  .then( function()
  {
    test.case = 'without callbacks';
    var timer = _.time._begin( undefined );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, undefined );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime';
    var timer = _.time._begin( undefined, onTime );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute onTime';
    var timer = _.time._begin( undefined, onTime );
    timer.time();
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel';
    var timer = _.time._begin( undefined, undefined, onCancel );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, undefined );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel, execute onCancel';
    var timer = _.time._begin( undefined, undefined, onCancel );
    _.time.cancel( timer );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, undefined );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, -2 );
      test.identical( got.result, -1 );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel';
    var timer = _.time._begin( undefined, onTime, onCancel );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel, execution of callbacks';
    var timer = _.time._begin( undefined, onTime, onCancel );
    timer.time(); /* qqq2 : user should not call methods of timer | Dmytro : direct call of callbacks used only in test cases delay === undefined, it has no variants to change state of timer because delay === Infinity */
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );

      _.time.cancel( got ); /* qqq2 : test should ensure that there is no transitions from final states -2 either +2 to any another state. ask | Dmytro : timer not change state from state 2 to -2. State -2 changes to 2 if user call callback timer.time() */

      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original );

      return null;
    });
  })

  con.finally( () =>
  {
    test.close( 'delay - undefined' );
    return null;
  });

  /* - */

  con.finally( () =>
  {
    test.open( 'delay - 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'without callbacks';
    var timer = _.time._begin( 0 );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, undefined );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime';
    var timer = _.time._begin( 0, onTime );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute onTime';
    var timer = _.time._begin( 0, onTime );
    timer.time()
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel';
    var timer = _.time._begin( 0, undefined, onCancel );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, undefined );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel, execute onCancel';
    var timer = _.time._begin( 0, undefined, onCancel );
    _.time.cancel( timer )
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, undefined );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, -2 );
      test.identical( got.result, -1 );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel';
    var timer = _.time._begin( 0, onTime, onCancel );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel, execution of callbacks';
    var timer = _.time._begin( 0, onTime, onCancel );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );

      _.time.cancel( got );

      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'only one execution';
    var times = 5;
    var result = [];
    var onTime = function()
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time._begin( 0, onTime );
    return _.time.out( 100, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      test.identical( times, 4 );
      test.identical( result, [ 1 ] );
      clearTimeout( got.original );

      return null;
    });
  })

  .finally( () =>
  {
    test.close( 'delay - 0' );
    return null;
  });

  /* - */

  con.finally( () =>
  {
    test.open( 'delay > 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'without callbacks, timeout < check time';
    var timer = _.time._begin( 5 );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, undefined );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'without callbacks, timeout > check time';
    var timer = _.time._begin( 100 );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, undefined );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout < check time';
    var timer = _.time._begin( 5, onTime );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time';
    var timer = _.time._begin( 100, onTime );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time, execute onTime';
    var timer = _.time._begin( 100, onTime );
    timer.time()
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel, timeout < check time';
    var timer = _.time._begin( 5, undefined, onCancel );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, undefined );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onCancel, timeout < check time, execute onCancel';
    var timer = _.time._begin( 5, undefined, onCancel );
    _.time.cancel( timer )
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, undefined );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, -2 );
      test.identical( got.result, -1 );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel, timeout < check time';
    var timer = _.time._begin( 5, onTime, onCancel );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel, timeout > check time';
    var timer = _.time._begin( 100, onTime, onCancel );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel, execution of callbacks';
    var timer = _.time._begin( 10, onTime, onCancel );
    return _.time.out( 100, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );

      _.time.cancel( got );

      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'only one execution';
    var times = 5;
    var result = [];
    var onTime = function()
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time._begin( 5, onTime );
    return _.time.out( 100, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      test.identical( times, 4 );
      test.identical( result, [ 1 ] );
      clearTimeout( got.original );

      return null;
    });
  })

  con.finally( ( err, arg ) =>
  {
    test.close( 'delay > 0' );

    if( err )
    throw err;
    return arg;
  });

  /* */

  return con;
}

//

function _finally( test )
{
  var onTime = () => 0;
  var con = new _.Consequence().take( null );

  /* - */

  con.finally( () =>
  {
    test.open( 'delay - undefined' );
    return null;
  })

  .then( function()
  {
    test.case = 'without callbacks';
    var timer = _.time._finally( undefined, undefined );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, undefined );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime';
    var timer = _.time._finally( undefined, onTime );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute onTime';
    var timer = _.time._finally( undefined, onTime );
    timer.time()
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute onCancel';
    var timer = _.time._finally( undefined, onTime );
    _.time.cancel( timer )
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, -2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original )

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execution of callbacks';
    var timer = _.time._finally( undefined, onTime );
    timer.time();
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );

      _.time.cancel( got )

      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original );

      return null;
    });
  })


  con.finally( () =>
  {
    test.close( 'delay - undefined' );
    return null;
  });

  /* - */

  con.finally( () =>
  {
    test.open( 'delay - 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'without callbacks';
    var timer = _.time._finally( 0, undefined );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, undefined );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      clearTimeout( got.original )

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime';
    var timer = _.time._finally( 0, onTime );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original )

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime';
    var timer = _.time._finally( 0, onTime );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original )

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute onCancel';
    var timer = _.time._finally( 0, onTime );
    _.time.cancel( timer )
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, -2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original )

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel, execution of callbacks';
    var timer = _.time._finally( 0, onTime );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );

      _.time.cancel( got );

      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'only one execution';
    var times = 5;
    var result = [];
    var onTime = function()
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time._finally( 0, onTime );
    return _.time.out( 100, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      test.identical( times, 4 );
      test.identical( result, [ 1 ] );
      clearTimeout( got.original )

      return null;
    });
  })


  .finally( () =>
  {
    test.close( 'delay - 0' );
    return null;
  });

  /* - */

  con.finally( () =>
  {
    test.open( 'delay > 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'without callbacks, timeout < check time';
    var timer = _.time._finally( 5, undefined );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, undefined );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      clearTimeout( got.original )

      return null;
    });
  })

  .then( function()
  {
    test.case = 'without callbacks, timeout > check time';
    var timer = _.time._finally( 100, undefined );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, undefined );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      clearTimeout( got.original )

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout < check time';
    var timer = _.time._finally( 5, onTime );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original )

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time';
    var timer = _.time._finally( 100, onTime );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      clearTimeout( got.original )

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time, execute onCancel';
    var timer = _.time._finally( 100, onTime );
    _.time.cancel( timer );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, -2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original )

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time';
    var timer = _.time._finally( 100, onTime );
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 0 );
      test.identical( got.result, undefined );
      clearTimeout( got.original )

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, timeout > check time, execute onTime';
    var timer = _.time._finally( 100, onTime );
    timer.time()
    return _.time.out( 10, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original )

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel, execution of callbacks';
    var timer = _.time._finally( 10, onTime );
    return _.time.out( 100, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );

      _.time.cancel( got );

      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, 0 );
      clearTimeout( got.original );

      return null;
    });
  })

  .then( function()
  {
    test.case = 'only one execution';
    var times = 5;
    var result = [];
    var onTime = function()
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time._finally( 0, onTime );
    return _.time.out( 100, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onTime );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      test.identical( times, 4 );
      test.identical( result, [ 1 ] );
      clearTimeout( got.original )

      return null;
    });
  });


  con.finally( ( err, arg ) =>
  {
    test.close( 'delay > 0' );

    if( err )
    throw err;
    return arg;
  });

  /* */

  return con;
}

//

function _periodic( test )
{
  var onCancel = () => -1;
  var con = new _.Consequence().take( null );

  /* - */

  con.finally( () =>
  {
    test.open( 'delay - 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'onTime';
    var times = 5;
    var result = [];
    var onTime = function()
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time._periodic( 0, onTime );
    return _.time.out( 100, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );
      clearTimeout( got.original )

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute onTime';
    var times = 5;
    var result = [];
    var onTime = function()
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time._periodic( 0, onTime );
    return _.time.out( 100, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );
      clearTimeout( got.original )

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel';
    var times = 5;
    var result = [];
    var onTime = function()
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time._periodic( 0, onTime, onCancel );
    return _.time.out( 100, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );
      clearTimeout( got.original )

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel, execution of callbacks';
    var times = 5;
    var result = [];
    var onTime = function()
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time._periodic( 0, onTime, onCancel );
    return _.time.out( 100, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      _.time.cancel( got );

      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, -2 );
      test.identical( got.result, -1 );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );
      clearTimeout( got.original );

      return null;
    });
  })

  .finally( () =>
  {
    test.close( 'delay - 0' );
    return null;
  });
  /* - */

  con.finally( () =>
  {
    test.open( 'delay > 0' );
    return null;
  })

  .then( function()
  {
    test.case = 'onTime';
    var times = 5;
    var result = [];
    var onTime = function()
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time._periodic( 5, onTime );
    return _.time.out( 200, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, undefined );
      test.is( got.state === 2 || got.state === 1 );
      test.identical( got.result, undefined );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );
      clearTimeout( got.original )

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, execute onTime';
    var times = 5;
    var result = [];
    var onTime = function()
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time._periodic( 5, onTime );
    return _.time.out( 200, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, undefined );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );
      clearTimeout( got.original )

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel';
    var times = 5;
    var result = [];
    var onTime = function()
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time._periodic( 5, onTime, onCancel );
    return _.time.out( 200, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.is( got.state === 2 || got.state === 1 );
      test.identical( got.result, undefined );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );
      clearTimeout( got.original )

      return null;
    });
  })

  .then( function()
  {
    test.case = 'onTime, onCancel, execution of callbacks';
    var times = 5;
    var result = [];
    var onTime = function()
    {
      if( times > 0 )
      {
        result.push( 1 );
        times--;
      }
    };

    var timer = _.time._periodic( 5, onTime, onCancel );
    return _.time.out( 200, () => timer )
    .finally( function( err, got )
    {
      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, 2 );
      test.identical( got.result, undefined );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );

      _.time.cancel( got );

      test.identical( got.onTime, onTime );
      test.identical( got.onCancel, onCancel );
      test.identical( got.state, -2 );
      test.identical( got.result, -1 );
      test.identical( times, 0 );
      test.identical( result, [ 1, 1, 1, 1, 1 ] );
      clearTimeout( got.original );

      return null;
    });
  })

  /* - */

  con.finally( ( err, arg ) =>
  {
    test.close( 'delay > 0' );

    if( err )
    throw err;
    return arg;
  });

  /* */

  return con;
}

//

function _cancel( test )
{
  test.open( 'timer - _begin' );

  test.case = 'delay - undefined';
  var timer = _.time._begin( undefined );
  var got = _.time._cancel( timer );
  test.identical( got.onTime, undefined );
  test.identical( got.onCancel, undefined );
  test.identical( got.state, -2 );
  test.identical( got.result, undefined );

  test.case = 'delay - undefined, onTime';
  var onTime = () => 0;
  var timer = _.time._begin( undefined, onTime );
  var got = _.time._cancel( timer );
  test.identical( got.onTime, onTime );
  test.identical( got.onCancel, undefined );
  test.identical( got.state, -2 );
  test.identical( got.result, undefined );

  test.case = 'delay - undefined, onCancel';
  var onCancel = () => -1;
  var timer = _.time._begin( undefined, undefined, onCancel );
  var got = _.time._cancel( timer );
  test.identical( got.onTime, undefined );
  test.identical( got.onCancel, onCancel );
  test.identical( got.state, -2 );
  test.identical( got.result, -1 );

  test.case = 'delay - undefined, onTime, onCancel';
  var onTime = () => 0;
  var onCancel = () => -1;
  var timer = _.time._begin( undefined, onTime, onCancel );
  var got = _.time._cancel( timer );
  test.identical( got.onTime, onTime );
  test.identical( got.onCancel, onCancel );
  test.identical( got.state, -2 );
  test.identical( got.result, -1 );

  test.close( 'timer - _begin' );

  /* - */

  test.open( 'timer - _finally' );

  test.case = 'delay - undefined';
  var timer = _.time._finally( undefined, undefined );
  var got = _.time._cancel( timer );
  test.identical( got.onTime, undefined );
  test.identical( got.onCancel, undefined );
  test.identical( got.state, -2 );
  test.identical( got.result, undefined );

  test.case = 'delay - undefined, onTime';
  var onTime = () => 0;
  var timer = _.time._finally( undefined, onTime );
  var got = _.time._cancel( timer );
  test.identical( got.onTime, onTime );
  test.identical( got.onCancel, onTime );
  test.identical( got.state, -2 );
  test.identical( got.result, 0 );

  test.close( 'timer - _finally' );

  /* - */

  test.open( 'timer - _periodic' );

  test.case = 'delay - 0, onTime';
  var onTime = () => 0;
  var timer = _.time._periodic( 1000, onTime ) ;
  var got = _.time._cancel( timer );
  test.identical( got.onTime, onTime );
  test.identical( got.onCancel, undefined );
  test.identical( got.state, -2 );
  test.identical( got.result, undefined );

  test.case = 'delay - 0, onTime, onCancel';
  var onTime = () => 0;
  var onCancel = () => -1;
  var timer = _.time._periodic( 1000, onTime, onCancel ) ;
  var got = _.time._cancel( timer );
  test.identical( got.onTime, onTime );
  test.identical( got.onCancel, onCancel );
  test.identical( got.state, -2 );
  test.identical( got.result, -1 );

  test.close( 'timer - _periodic' );
}

//

function timeOutCancelInsideOfCallback( test )
{
  let context = this;
  let visited = [];

  var timer = _.time.begin( 1, () =>
  {
    visited.push( 'v1' );
    debugger;
    _.time.cancel( timer );
    visited.push( 'v2' );
  });

  visited.push( 'v0' );

  return _.time.out( context.dt*5 ).then( () =>
  {
    test.identical( visited, [ 'v0', 'v1', 'v2' ] );
    return null;
  });
}

//

function timeOutCancelOutsideOfCallback( test )
{
  let context = this;
  let visited = [];

  var timer = _.time.begin( context.dt*1, () =>
  {
    visited.push( 'v1' );
  });

  _.time.cancel( timer );
  visited.push( 'v0' );

  return _.time.out( context.dt*5 ).then( () =>
  {
    test.identical( visited, [ 'v0' ] );
    return null;
  });
}

//

function timeOutCancelZeroDelayInsideOfCallback( test )
{
  let context = this;
  let visited = [];

  var timer = _.time.begin( 0, () =>
  {
    visited.push( 'v1' );
    _.time.cancel( timer );
    visited.push( 'v2' );
  });

  visited.push( 'v0' );

  return _.time.out( context.dt*5 ).then( () =>
  {
    test.identical( visited, [ 'v0', 'v1', 'v2' ] );
    return null;
  });
}

//

function timeOutCancelZeroDelayOutsideOfCallback( test )
{
  let context = this;
  let visited = [];

  debugger;
  var timer = _.time.begin( 0, () =>
  {
    visited.push( 'v1' );
  });

  _.time.cancel( timer );
  visited.push( 'v0' );

  return _.time.out( context.dt*5 ).then( () =>
  {
    test.identical( visited, [ 'v0' ] );
    return null;
  });
}

// --
// tests
// --

function timeOut( test )
{
  var c = this;
  var ready = new _.Consequence().take( null )

  /* */

  .then( function()
  {
    test.case = 'delay only';
    var timeBefore = _.time.now();
    return _.time.out( c.delay )
    .finally( function( err, got )
    {
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.is( _.routineIs( got ) );
      return null;
    });
  })

  /* */

  .then( function()
  {
    test.case = 'delay + routine';
    var timeBefore = _.time.now();
    return _.time.out( c.delay, () => null )
    .finally( function( err, got )
    {
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, null );
      test.identical( err, undefined );
      return null;
    });
  })

  /* */

  .then( function()
  {
    test.case = 'delay + routine that returns a value';
    var timeBefore = _.time.now();
    var value = 'value';
    return _.time.out( c.delay, () => value )
    .finally( function( err, got )
    {
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, value );
      test.identical( err, undefined );
      return null;
    });
  })

  /* */

  .then( function()
  {
    test.case = 'delay + routine that returns a consequence';
    var timeBefore = _.time.now();
    return _.time.out( c.delay, () => _.time.out( c.delay ) )
    .finally( function( err, got )
    {
      var elapsedTime = _.time.now() - timeBefore;
      // test.is( elapsedTime >= c.delay * 2 );
      test.ge( elapsedTime, 2 * c.delay-c.timeAccuracy );
      test.is( _.routineIs( got ) );
      test.identical( err, undefined );
      return null;
    });
  })

  /* */

  .then( function()
  {
    test.case = 'delay + routine that calls another timeOut';
    var timeBefore = _.time.now();
    return _.time.out( c.delay, () => { _.time.out( c.delay ); return null } )
    .finally( function( err, got )
    {
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( err, undefined );
      test.identical( got, null );
      return null;
    });
  })

  /* */

  .then( function()
  {
    test.case = 'delay + context + routine + arguments';
    var timeBefore = _.time.now();
    function r( delay )
    {
      return delay / 2;
    }
    return _.time.out( c.delay, undefined, r, [ c.delay ] )
    .finally( function( err, got )
    {
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, c.delay / 2 );
      test.identical( err, undefined );
      return null;
    });
  })

  /* */

  .then( function()
  {
    test.case = 'delay + consequence, first delay greater';
    var timeBefore = _.time.now();

    return _.time.out( c.delay, _.time.out( c.delay * 2 ) )
    .finally( function( err, got )
    {
      var elapsedTime = _.time.now() - timeBefore;
      // test.is( elapsedTime >= c.delay * 2 );
      test.ge( elapsedTime, 2 * c.delay-c.timeAccuracy );
      test.is( _.routineIs( got ) );
      test.identical( err, undefined );
      return null;
    });
  })

  /* */

  .then( function()
  {
    test.case = 'delay + consequence, second delay greater';
    var timeBefore = _.time.now();

    return _.time.out( c.delay*3, _.time.out( c.delay * 2 ) )
    .finally( function( err, got )
    {
      var elapsedTime = _.time.now() - timeBefore;
      // test.is( elapsedTime >= c.delay * 2 );
      test.ge( elapsedTime, 3 * c.delay-c.timeAccuracy );
      test.is( _.routineIs( got ) );
      test.identical( err, undefined );
      return null;
    });
  })

  /* */

  .then( function()
  {
    test.case = 'delay + consequence that returns delayed value, launched serially';
    var timeBefore = _.time.now();
    var val = 13;

    return _.time.out( c.delay, () => _.time.out( c.delay * 2, () => val ) )
    .finally( function( err, got )
    {
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay * 3-c.timeAccuracy );
      test.identical( err, undefined );
      test.identical( got, val );
      return null;
    })
  })

  /* */

  .then( function()
  {
    test.case = 'delay + consequence that returns delayed value, launched concurrently';
    var timeBefore = _.time.now();
    var val = 13;

    return _.time.out( c.delay, _.time.out( c.delay * 2, () => val ) )
    .finally( function( err, got )
    {
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay * 2-c.timeAccuracy );
      test.identical( err, undefined );
      test.identical( got, val );
      return null;
    })
  })

  /* */

  .then( function()
  {
    test.case = 'delay + consequence that returns delayed value, launched concurrently';
    var timeBefore = _.time.now();

    return _.time.out( c.delay, _.time.out( c.delay * 2, () => _.time.out( c.delay * 2 ) ) )
    .finally( function( err, got )
    {
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay * 4-c.timeAccuracy );
      test.identical( err, undefined );
      test.identical( got, _.time.out );
      return null;
    })
  })

  /* */

  .then( function()
  {
    test.case = 'delay + consequence + error';
    var timeBefore = _.time.now();

    return _.time.out( c.delay, _.time.out( c.delay * 2, () => { throw 'err' } ) )
    .finally( function( err, got )
    {
      if( err )
      _.errAttend( err );
      var elapsedTime = _.time.now() - timeBefore;
      // test.is( elapsedTime >= c.delay * 2 );
      test.ge( elapsedTime, 2 * c.delay-c.timeAccuracy );
      test.is( _.errIs( err ) );
      test.identical( got, undefined );
      return null;
    });
  })

  /* */

  .then( function()
  {
    test.case = 'stop timer with dont';
    var timeBefore = _.time.now();

    var t = _.time.out( c.delay );
    t.finally( function( err, got )
    {
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay / 2 - c.timeAccuracy );
      // test.identical( _.strHas( _.err( err ).message, 'stop' ), true );
      // test.identical( got, undefined );
      test.identical( err, undefined );
      test.identical( got, _.dont );
      return null;
    })
    _.time.out( c.delay / 2, () =>
    {
      t.take( _.dont );
      return null;
    });
    // _.time.out( c.delay / 2, () => { t.take( _.dont ); return null; });
    // _.time.out( c.delay / 2, () => { t.error( _.errAttend( 'stop' ) ); return null; });

    return t;
  })

  /* */

  .then( function()
  {
    test.case = 'stop timer with error, routine passed';
    var timeBefore = _.time.now();
    var called = false;

    var t = _.time.out( c.delay, () => { called = true } );
    t.finally( function( err, got )
    {
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay / 2 - c.timeAccuracy );
      // test.identical( got, undefined );
      // test.identical( _.strHas( _.err( err ).message, 'stop' ), true );
      test.identical( err, undefined );
      test.identical( got, _.dont );
      test.identical( called, false );
      return null;
    })
    _.time.out( c.delay / 2, () =>
    {
      t.take( _.dont );
      return null;
    });
    // _.time.out( c.delay / 2, () => { t.error( _.errAttend( 'stop' ) ); return null; });

    return t;
  })

  /* */

  .then( function()
  {
    test.case = 'stop after timeOut';
    var timeBefore = _.time.now();

    var t = _.time.out( c.delay, () => null );
    t.give( function( err, got )
    {
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, null );
      test.identical( err, undefined );
    });

    return _.time.out( c.delay + 50, function()
    {
      // t.error( _.errAttend( 'stop' ) );
      t.take( _.dont );
      t.give( ( err, got ) =>
      {
        // test.identical( _.strHas( _.err( err ).message, 'stop' ), true )
        test.identical( err, undefined );
        test.identical( got, _.dont );
      });
      return null;
    });

    return t;
  })

  /* */

  .then( function()
  {
    test.case = 'give msg before timeOut';
    var timeBefore = _.time.now();
    var returnValue = 1;
    var msg = 2;

    var t = _.time.out( c.delay, () => returnValue );

    return _.time.out( c.delay / 2, function()
    {
      t.take( msg );
      t.give( ( err, got ) => test.identical( got, msg ) );
      t.give( ( err, got ) =>
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got, returnValue );

      })
      return null;
    })

    return t;
  })

  /* */

  .then( function()
  {
    test.case = 'stop timer with error + arg, routine passed';
    var timeBefore = _.time.now();
    var called = false;

    var t = _.time.out( c.delay, () => { called = true } );
    t.finally( function( err, got )
    {
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay / 2 - c.timeAccuracy );
      // test.identical( got, undefined );
      // test.identical( _.strHas( _.err( err ).message, 'stop' ), true )
      test.identical( err, undefined );
      test.identical( got, _.dont );
      test.identical( called, false );
      return null;
    })
    _.time.out( c.delay / 2, () =>
    {
      t.take( _.dont );
      return null;
    });
    // _.time.out( c.delay / 2, () =>
    // {
    //   t.take( _.errAttend( 'stop' ), undefined );
    //   return null;
    // });

    return t;
  })

  /* */

  .then( function()
  {

    test.case = 'could have the second argument';

    let f = function(){ return 'a' };

    test.mustNotThrowError( () => _.time.out( 0, 'x' ) );
    test.mustNotThrowError( () => _.time.out( 0, 13 ) );
    test.mustNotThrowError( () => _.time.out( 0, f ) );

    _.time.out( 0, 'x' ).finally( ( err, arg ) => test.identical( arg, 'x' ) );
    _.time.out( 0, 13 ).finally( ( err, arg ) => test.identical( arg, 13 ) );
    _.time.out( 0, f ).finally( ( err, arg ) => test.identical( arg, 'a' ) );

    return _.time.out( 50 );
  })

  /* */

  .then( function()
  {

    if( !Config.debug )
    return null;

    test.case = 'delay must be number';
    test.shouldThrowErrorSync( () => _.time.out( 'x' ) );

    test.case = 'if two arguments provided, second must consequence/routine';
    test.shouldThrowErrorSync( () => _.time.out() );

    test.case = 'if four arguments provided, third must routine';
    test.shouldThrowErrorSync( () => _.time.out( 0, {}, 'x', [] ) );

    return null;
  })

  ready.tap( ( err, arg ) =>
  {
    debugger;
  });

  return ready;
}

timeOut.timeOut = 20000;

//

function timeOutMode01( test )
{
  var c = this;
  var mode = _.Consequence.AsyncModeGet();
  var ready = new _.Consequence().take( null )

  /* AsyncCompetitorHanding : 0, AsyncResourceAdding : 1 */

  .finally( () =>
  {
    _.Consequence.AsyncModeSet([ 0, 1 ]);
    return null;
  })
  .then( function( arg )
  {
    test.case = 'delay only';
    var timeBefore = _.time.now();
    var t = _.time.out( c.delay );
    return new _.Consequence().first( t )
    .then( function( arg )
    {
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay - c.timeAccuracy );
        test.is( _.routineIs( got ) );
      });
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .finally(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'delay + routine';
    var timeBefore = _.time.now();
    var t = _.time.out( c.delay, () => null );
    return new _.Consequence().first( t )
    .then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got , null );
        test.is( err === undefined );
      });
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .finally(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'delay + routine that returns a value';
    var timeBefore = _.time.now();
    var value = 'value';
    var t = _.time.out( c.delay, () => value );
    return new _.Consequence().first( t )
    .then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( got === value );
        test.is( err === undefined );
      });
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .finally(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'delay + routine that returns a consequence';
    var timeBefore = _.time.now();
    var t = _.time.out( c.delay, () => _.time.out( c.delay ) );
    return new _.Consequence().first( t )
    .then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( _.routineIs( got ));
        test.is( err === undefined );
      });
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .finally(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'delay + routine that calls another timeOut';
    var timeBefore = _.time.now();
    var t = _.time.out( c.delay, () => _.time.out( c.delay ) );
    return new _.Consequence().first( t )
    .then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got, _.time.out );
        test.identical( err, undefined );
      });
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .finally(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'delay + context + routine + arguments';
    var timeBefore = _.time.now();
    function r( delay )
    {
      return delay * 13;
    }
    var t = _.time.out( c.delay, undefined, r, [ c.delay ] );
    return new _.Consequence().first( t )
    .then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got, c.delay * 13 );
        test.identical( err, undefined );
      });
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .finally(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'stop timer with error';
    var timeBefore = _.time.now();
    var t = _.time.out( c.delay );

    // _.time.out( c.delay / 2, () => { t.error( _.errAttend( 'stop' ) ); return null; });
    _.time.out( c.delay / 2, () =>
    {
      t.take( _.dont );
      return null;
    });

    return new _.Consequence().first( t )
    .then( function( arg )
    {
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime , c.delay / 2 );
        // test.identical( got , undefined );
        // test.identical( _.strHas( _.err( err ).message, 'stop' ), true );
        test.identical( err, undefined );
        test.identical( got, _.dont );
      });
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .finally( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'stop timer with error, routine passed';
    var timeBefore = _.time.now();
    var called = false;

    var t = _.time.out( c.delay, () => { called = true } );
    // _.time.out( c.delay / 2, () => { t.error( _.errAttend( 'stop' ) ); return null; });
    _.time.out( c.delay / 2, () =>
    {
      t.take( _.dont );
      return null;
    });

    return new _.Consequence().first( t )
    .then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime , c.delay / 2 );
        // test.identical( got, undefined );
        // test.identical( _.strHas( _.err( err ).message, 'stop' ), true );
        test.identical( err, undefined );
        test.identical( got, _.dont );
        test.identical( called, false );
      });
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .finally( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'stop after timeOut';
    var timeBefore = _.time.now();
    var t = _.time.out( c.delay, () => null );

    var con = new _.Consequence();
    con.first( t );
    con.then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got, null );
        test.identical( err, undefined );
      })
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .finally(function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })

    return _.time.out( c.delay + 50, function()
    {
      // t.error( _.errAttend( 'stop' ) );
      t.take( _.dont );
      t.give( ( err, got ) =>
      {
        test.identical( err, undefined );
        test.identical( got, _.dont );
        // test.identical( _.strHas( _.err( err ).message, 'stop' ), true );
      });
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .then( function( arg )
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );

      _.Consequence.AsyncModeSet( mode );
      return null;
    });

  })

  /**/

  return ready;
}

timeOutMode10.timeOut = 30000;

//

function timeOutMode10( test )
{
  var c = this;
  var mode = _.Consequence.AsyncModeGet();
  var ready = new _.Consequence().take( null )
  /* AsyncCompetitorHanding : 1, AsyncResourceAdding : 0, */

  .finally( () =>
  {
    _.Consequence.AsyncModeSet([ 1, 0 ])
    return null;
  })
  .then( function( arg )
  {
    test.case = 'delay only';
    var timeBefore = _.time.now();
    var t = _.time.out( c.delay );
    return new _.Consequence().first( t )
    .then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( _.routineIs( got ) );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1 )
    .then( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'delay + routine';
    var timeBefore = _.time.now();
    var t = _.time.out( c.delay, () => null );
    return new _.Consequence().first( t )
    .then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got , null );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1 )
    .then( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'delay + routine that returns a value';
    var timeBefore = _.time.now();
    var value = 'value';
    var t = _.time.out( c.delay, () => value );
    return new _.Consequence().first( t )
    .then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( got === value );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1 )
    .then( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'delay + routine that returns a consequence';
    var timeBefore = _.time.now();
    var t = _.time.out( c.delay, () => _.time.out( c.delay ) );
    return new _.Consequence().first( t )
    .then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( _.routineIs( got ));
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1 )
    .then( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'delay + routine that calls another timeOut';
    var timeBefore = _.time.now();
    var t = _.time.out( c.delay, () => { _.time.out( c.delay ); return null; } );
    return new _.Consequence().first( t )
    .then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got , null );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1 )
    .then( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'delay + context + routine + arguments';
    var timeBefore = _.time.now();
    function r( delay )
    {
      return delay / 2;
    }
    var t = _.time.out( c.delay, undefined, r, [ c.delay ] );
    return new _.Consequence().first( t )
    .then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( got === c.delay / 2 );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1 )
    .then( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'stop timer with error';
    var timeBefore = _.time.now();
    var t = _.time.out( c.delay );

    // _.time.out( c.delay / 2, () =>
    // {
    //   t.error( _.errAttend( 'stop' ) );
    //   return null;
    // });

    _.time.out( c.delay / 2, () =>
    {
      t.take( _.dont );
      return null;
    });

    return new _.Consequence().first( t )
    .finally( function()
    {

      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime , c.delay / 2 );
        // test.identical( got , undefined );
        // test.identical( _.strHas( _.err( err ).message, 'stop' ), true );;
        test.identical( err, undefined );
        test.identical( got, _.dont );
        test.identical( t.resourcesGet().length, 0 );
        test.identical( t.competitorsEarlyGet().length, 0 );
      });

      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'stop timer with error, routine passed';
    var timeBefore = _.time.now();
    var called = false;

    var t = _.time.out( c.delay, () => { called = true } );
    // _.time.out( c.delay / 2, () => { t.error( _.errAttend( 'stop' ) ); return null; });

    _.time.out( c.delay / 2, () =>
    {
      t.take( _.dont );
      return null;
    });

    return new _.Consequence().first( t )
    .finally( function()
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime , c.delay / 2 );
        // test.identical( got, undefined );
        // test.identical( _.strHas( _.err( err ).message, 'stop' ), true );
        test.identical( err, undefined );
        test.identical( got, _.dont );
        test.identical( called, false );
        test.identical( t.resourcesGet().length, 0 );
        test.identical( t.competitorsEarlyGet().length, 0 );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'stop after timeOut';
    var timeBefore = _.time.now();
    var t = _.time.out( c.delay, () => null );

    var con = new _.Consequence();
    con.first( t );
    con.then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got, null );
        test.identical( err, undefined );
      })
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1 )
    .then( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .then( function( arg )
    {
      // t.error( _.errAttend( 'stop' ) );
      t.take( _.dont );
      t.give( ( err, got ) =>
      {
        // test.identical( _.strHas( _.err( err ).message, 'stop' ), true )
        test.identical( err, undefined );
        test.identical( got, _.dont );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1 )
    .then( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );

      _.Consequence.AsyncModeSet( mode );

      return null;
    });

    return con;
  })

  return ready;
}

timeOutMode01.timeOut = 30000;

//

function timeOutMode11( test )
{
  var c = this;
  var mode = _.Consequence.AsyncModeGet();
  var ready = new _.Consequence().take( null )

  /* AsyncResourceAdding : 1, AsyncCompetitorHanding : 1 */

  .finally( () =>
  {
    _.Consequence.AsyncModeSet([ 1, 1 ])
    return null;
  })
  .then( function( arg )
  {
    test.case = 'delay only';
    var timeBefore = _.time.now();
    var t = _.time.out( c.delay );
    return new _.Consequence().first( t )
    .then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( _.routineIs( got ) );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1 )
    .then( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'delay + routine';
    var timeBefore = _.time.now();
    var t = _.time.out( c.delay, () => null );
    return new _.Consequence().first( t )
    .then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got , null );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1 )
    .then( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'delay + routine that returns a value';
    var timeBefore = _.time.now();
    var value = 'value';
    var t = _.time.out( c.delay, () => value );
    return new _.Consequence().first( t )
    .then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( got === value );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1 )
    .then( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'delay + routine that returns a consequence';
    var timeBefore = _.time.now();
    var t = _.time.out( c.delay, () => _.time.out( c.delay ) );
    return new _.Consequence().first( t )
    .then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( _.routineIs( got ));
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1 )
    .then( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'delay + routine that calls another timeOut';
    var timeBefore = _.time.now();
    var t = _.time.out( c.delay, () => { _.time.out( c.delay );return null; } );
    return new _.Consequence().first( t )
    .then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got , null );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1 )
    .then( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'delay + context + routine + arguments';
    var timeBefore = _.time.now();
    function r( delay )
    {
      return delay / 2;
    }
    var t = _.time.out( c.delay, undefined, r, [ c.delay ] );
    return new _.Consequence().first( t )
    .then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.is( got === c.delay / 2 );
        test.identical( err , undefined );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1 )
    .then( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'stop timer with error';
    var timeBefore = _.time.now();
    var t = _.time.out( c.delay );

    // _.time.out( c.delay / 2, () => { t.error( _.errAttend( 'stop' ) ); return null; });
    _.time.out( c.delay / 2, () =>
    {
      t.take( _.dont );
      return null;
    });

    return new _.Consequence().first( t )
    .finally( function()
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime , c.delay / 2 );
        // test.identical( got , undefined );
        // test.identical( _.strHas( _.err( err ).message, 'stop' ), true );;
        test.identical( err, undefined );
        test.identical( got, _.dont );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1 )
    .then( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'stop timer with error, routine passed';
    var timeBefore = _.time.now();
    var called = false;

    var t = _.time.out( c.delay, () => { called = true; return null; } );
    // _.time.out( c.delay / 2, () => { t.error( _.errAttend( 'stop' ) ); return null; });
    _.time.out( c.delay / 2, () =>
    {
      t.take( _.dont );
      return null;
    });

    return new _.Consequence().first( t )
    .finally( function()
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime , c.delay / 2 );
        // test.identical( got, undefined );
        // test.identical( _.strHas( _.err( err ).message, 'stop' ), true )
        test.identical( err, undefined );
        test.identical( got, _.dont );
        test.identical( called, false );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1 )
    .then( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
  })

  /**/

  .then( function( arg )
  {
    test.case = 'stop after timeOut';
    var timeBefore = _.time.now();
    var t = _.time.out( c.delay, () => null );

    var con = new _.Consequence();
    con.first( t );
    con.then( function( arg )
    {
      t.give( function( err, got )
      {
        var elapsedTime = _.time.now() - timeBefore;
        test.ge( elapsedTime, c.delay-c.timeAccuracy );
        test.identical( got, null );
        test.identical( err, undefined );
      })
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1 )
    .then( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );
      return null;
    })
    .then( function( arg )
    {
      // t.error( _.errAttend( 'stop' ) );
      t.take( _.dont );
      t.give( ( err, got ) =>
      {
        // test.identical( _.strHas( _.err( err ).message, 'stop' ), true );
        test.identical( err, undefined );
        test.identical( got, _.dont );
      });
      test.identical( t.resourcesGet().length, 1 );
      test.identical( t.competitorsEarlyGet().length, 1 );
      return null;
    })
    .timeOut( 1 )
    .then( function()
    {
      test.identical( t.resourcesGet().length, 0 );
      test.identical( t.competitorsEarlyGet().length, 0 );

      _.Consequence.AsyncModeSet( mode );
      return null;
    });

    return con;
  })

  return ready;
}

timeOutMode11.timeOut = 30000;

//

function timeOutError( test )
{
  var c = this;
  var ready = new _.Consequence().take( null );

  /* */

  ready
  .then( function( arg )
  {
    test.case = 'delay only';
    var timeBefore = _.time.now();
    return _.time.outError( c.delay )
    .finally( function( err, got )
    {
      if( err )
      _.errAttend( err );
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.is( _.errIs( err ) );
      return null;
    });
  })

  /* */

  .then( function( arg )
  {
    test.case = 'delay + routine';
    var timeBefore = _.time.now();
    return _.time.outError( c.delay, () => null )
    .finally( function( err, got )
    {
      if( err )
      _.errAttend( err );
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, undefined );
      test.is( _.errIs( err ) );
      return null;
    });
  })

  /* */

  .then( function( arg )
  {
    test.case = 'delay + routine that returns a value';
    var timeBefore = _.time.now();
    var value = 'value';
    return _.time.outError( c.delay, () => value )
    .finally( function( err, got )
    {
      if( err )
      _.errAttend( err );
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, undefined );
      test.is( _.errIs( err ) );
      return null;
    });
  })

  /* */

  .then( function( arg )
  {
    test.case = 'delay + routine that returns a consequence';
    var timeBefore = _.time.now();
    return _.time.outError( c.delay, () => _.time.out( c.delay ) )
    .finally( function( err, got )
    {
      if( err )
      _.errAttend( err );
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, 2 * c.delay-c.timeAccuracy );
      test.identical( got, undefined );
      test.is( _.errIs( err ) );
      return null;
    });
  })

  /* */

  .then( function( arg )
  {
    test.case = 'delay + routine that calls another timeOut';
    var timeBefore = _.time.now();
    return _.time.outError( c.delay, () => { _.time.out( c.delay ) } )
    .finally( function( err, got )
    {
      if( err )
      _.errAttend( err );
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, undefined );
      test.is( _.errIs( err ) );
      return null;
    });
  })

  /* */

  .then( function( arg )
  {
    test.case = 'delay + context + routine + arguments';
    var timeBefore = _.time.now();
    function r( delay )
    {
      return delay / 2;
    }
    return _.time.outError( c.delay, undefined, r, [ c.delay ] )
    .finally( function( err, got )
    {
      if( err )
      _.errAttend( err );
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay-c.timeAccuracy );
      test.identical( got, undefined );
      test.is( _.errIs( err ) );
      return null;
    });
  })

  /* */

  .then( function( arg )
  {
    test.case = 'delay + consequence';
    var timeBefore = _.time.now();

    return _.time.outError( c.delay, _.time.out( c.delay * 2 ) )
    .finally( function( err, got )
    {
      if( err )
      _.errAttend( err );
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay * 2-c.timeAccuracy );
      test.identical( got, undefined );
      test.is( _.errIs( err ) );
      return null;
    });

  })

  /* */

  .then( function( arg )
  {
    test.case = 'stop timer with dont';
    var timeBefore = _.time.now();

    var t = _.time.outError( c.delay );
    t.finally( function( err, got )
    {
      if( err )
      _.errAttend( err );
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay / 2 - c.timeAccuracy );
      test.identical( got, _.dont );
      test.is( !err );
      test.identical( t.resourcesGet().length, 0 );
      return null;
    })
    _.time.out( c.delay / 2, () => { t.take( _.dont ); return null; } );
    // _.time.out( c.delay / 2, () => { t.error( _.errAttend( 'stop' ) ); return null; } );

    return t;
  })

  /* */

  .then( function( arg )
  {
    test.case = 'stop timer with dont, routine passed';
    var timeBefore = _.time.now();
    var called = false;

    var t = _.time.outError( c.delay, () => { called = true } );
    t.finally( function( err, arg )
    {
      var elapsedTime = _.time.now() - timeBefore;
      test.ge( elapsedTime, c.delay / 2 - c.timeAccuracy );
      // test.identical( arg, _.dont );
      // test.identical( _.strHas( _.err( err ).message, 'stop' ), true );
      test.identical( err, undefined );
      test.identical( arg, _.dont );
      test.identical( called, false );
      test.identical( t.resourcesGet().length, 0 );
      return null;
    })

    _.time.out( c.delay / 2, () =>
    {
      t.take( _.dont );
      return null;
    });

    // _.time.out( c.delay / 2, () => { t.take( _.dont ); return null; } );
    // _.time.out( c.delay / 2, () => { t.error( _.errAttend( 'stop' ) ); return null; } );

    return t;
  })

  /* */

  .finally( function( err, arg )
  {
    if( err )
    throw err;
    return null;
  });

  return ready;
}

timeOutError.timeOut = 30000;
timeOutError.description =
`
throw error on time out
stop timer with error
`

//

function asyncStackTimeOutError( test )
{
  let context = this;
  let ready = _.now();
  let visited = [];

  ready.then( () =>
  {

    let error;
    let con = _.time.outError( 1 ).tap( ( err, arg ) => error = _.errAttend( err ) );

    return _.time.out( 100, () =>
    {
      logger.log( error );
      test.identical( _.strCount( String( error ), 'Time.test.s' ), 3 );
      test.identical( _.strCount( error.asyncCallsStack.join( '' ), 'Time.test.s' ), 2 );
      test.identical( error.asyncCallsStack.length, 1 );
    });
  });

  return ready;
}

//

function asyncStackTimeOut( test )
{
  let context = this;
  let ready = _.now();
  let visited = [];

  ready.then( () =>
  {

    let error;
    let con = _.time.out( 1 )
    .then( ( arg ) =>
    {
      throw 'Error';
    })
    .finally( ( err, arg ) =>
    {
      logger.log( err );
      test.identical( _.strCount( String( err ), 'Time.test.s' ), 2 );
      test.identical( _.strCount( err.asyncCallsStack.join( '' ), 'Time.test.s' ), 2 );
      test.identical( err.asyncCallsStack.length, 1 );
      return null;
    })

    return con;
  });

  return ready;
}

// --
// test suite
// --

let Self =
{

  name : 'Tools/Time/' + Math.floor( Math.random()*100000 ),
  silencing : 1,
  enabled : 1,

  context :
  {
    timeAccuracy : 1,
    delay : 400,
    dt : 25,
  },

  tests :
  {

    // basic

    timerIs,
    _begin,
    _finally,
    _periodic,
    _cancel,
    timeOutCancelInsideOfCallback,
    timeOutCancelOutsideOfCallback,
    timeOutCancelZeroDelayInsideOfCallback,
    timeOutCancelZeroDelayOutsideOfCallback,

    //

    timeOut,
    timeOutMode01,
    timeOutMode10,
    timeOutMode11,
    timeOutError,
    asyncStackTimeOutError,
    asyncStackTimeOut,

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
