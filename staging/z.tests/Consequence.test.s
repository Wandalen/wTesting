( function( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  try
  {
    require( 'wTesting' );
  }
  catch( err )
  {
    require( '../object/Testing.debug.s' );
  }
}

_global_.wTests = _global_.wTests === undefined ? {} : _global_.wTests;

var _ = wTools;
var Self = {};

// --
// test
// --

var promiseMode = function( test )
{
  var self = this;

  var mode = 'promise';
  var samples =
  [

    {
      giveMethod : { give : 'give' },
      gotArgument : 1,
      anotherArgument : 0,
      anotherArgumentValue : null,
    },

    {
      giveMethod : { error : 'error' },
      gotArgument : 0,
      anotherArgument : 1,
      anotherArgumentValue : undefined,
    },

  ];


  //

  for( var s = 0 ; s < samples.length ; s++ )
  {
    var sample = samples[ s ];

    sample.giveMethod = _.nameUnfielded( sample.giveMethod ).coded;

    /**/

    var con = new wConsequence({ mode : mode });

    con.got( function( err,data )
    {

      test.identical( arguments[ sample.gotArgument ],1 );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );

    });

    con.got( function( err,data )
    {

      test.identical( arguments[ sample.gotArgument ],2 );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );

    });

    con[ sample.giveMethod ]( 1 );
    con[ sample.giveMethod ]( 2 );
    con[ sample.giveMethod ]( 3 );
    con[ sample.giveMethod ]( 4 );

    con.got( function( err,data )
    {

      test.identical( arguments[ sample.gotArgument ],3 );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );

    });

    con.got( function( err,data )
    {

      test.identical( arguments[ sample.gotArgument ],4 );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );

    });

    con.got( function( err,data )
    {

      test.identical( arguments[ sample.gotArgument ],5 );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );

    });

    con.got( function( err,data )
    {

      test.identical( arguments[ sample.gotArgument ],6 );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );

    });

    con[ sample.giveMethod ]( 5 );
    con[ sample.giveMethod ]( 6 );

    /**/

    var con = new wConsequence({ mode : mode });

    con[ sample.giveMethod ]( 1 );
    con[ sample.giveMethod ]( 2 );

    con.got( function( err,data )
    {

      test.identical( arguments[ sample.gotArgument ],1 );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );

    });

    con.got( function( err,data )
    {

      test.identical( arguments[ sample.gotArgument ],2 );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );

    });

    con.got( function( err,data )
    {

      test.identical( arguments[ sample.gotArgument ],3 );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );

    });

    con.got( function( err,data )
    {

      test.identical( arguments[ sample.gotArgument ],4 );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );

    });

    con[ sample.giveMethod ]( 3 );
    con[ sample.giveMethod ]( 4 );
    con[ sample.giveMethod ]( 5 );
    con[ sample.giveMethod ]( 6 );

    con.got( function( err,data )
    {

      test.identical( arguments[ sample.gotArgument ],5 );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );

    });

    con.got( function( err,data )
    {

      test.identical( arguments[ sample.gotArgument ],6 );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );

    });

  }

}

//

var eventMode = function( test )
{
  var self = this;

  var mode = 'event';
  var samples =
  [

    {
      giveMethod : { give : 'give' },
      gotArgument : 1,
      anotherArgument : 0,
      anotherArgumentValue : null,
    },

    {
      giveMethod : { error : 'error' },
      gotArgument : 0,
      anotherArgument : 1,
      anotherArgumentValue : undefined,
    },

  ];

  //

  for( var s = 0 ; s < samples.length ; s++ )
  {
    var sample = samples[ s ];

    sample.giveMethod = _.nameUnfielded( sample.giveMethod ).coded;

    /**/

    var con = new wConsequence({ mode : mode });

    con.got( ( function(){ var first = 1; return function( err,data )
    {

      test.identical( arguments[ sample.gotArgument ],first );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );
      test.identical( arguments[ sample.gotArgument ] !== 3,true );
      first += 1;

    }}()) );

    con[ sample.giveMethod ]( 1 );
    con[ sample.giveMethod ]( 2 );
    con.clearTakers();

    /**/

    var got8 = 0;

    con.got( ( function(){ var first = 3; return function( err,data )
    {

      test.identical( arguments[ sample.gotArgument ],first );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );
      first += 1;

      if( arguments[ sample.gotArgument ] === 8 )
      got8 += 1;

    }}()) );

    con.got( ( function(){ var first = 3; return function( err,data )
    {

      test.identical( arguments[ sample.gotArgument ],first );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );
      first += 1;

      if( arguments[ sample.gotArgument ] === 8 )
      got8 += 1;

    }}()) );

    con[ sample.giveMethod ]( 3 );
    con[ sample.giveMethod ]( 4 );
    con[ sample.giveMethod ]( 5 );
    con[ sample.giveMethod ]( 6 );

    con.got( ( function(){ var first = 7; return function( err,data )
    {

      test.identical( arguments[ sample.gotArgument ],first );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );
      first += 1;

      if( arguments[ sample.gotArgument ] === 8 )
      got8 += 1;

    }}()) );

    con[ sample.giveMethod ]( 7 );
    con[ sample.giveMethod ]( 8 );

    test.identical( got8,3 );

    /**/

    var got2 = 0;
    var con = new wConsequence({ mode : mode });

    con[ sample.giveMethod ]( 1 );
    con[ sample.giveMethod ]( 2 );

    con.got( ( function(){ var first = 1; return function( err,data )
    {

      test.identical( arguments[ sample.gotArgument ],first );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );
      first += 1;

      if( arguments[ sample.gotArgument ] === 2 )
      got2 += 1;

    }}()) );

    con.got( ( function(){ var first = 7; return function( err,data )
    {

      test.identical( false,true );

    }}()) );

    test.identical( got2,1 );

  }

}

//

var then = function( test )
{
  var self = this;

  var mode = 'event';
  var samples =
  [

    {
      giveMethod : { give : 'give' },
      gotArgument : 1,
      anotherArgument : 0,
      anotherArgumentValue : null,
    },

    {
      giveMethod : { error : 'error' },
      gotArgument : 0,
      anotherArgument : 1,
      anotherArgumentValue : undefined,
    },

  ];

  //

  for( var s = 0 ; s < samples.length ; s++ )
  {
    var sample = samples[ s ];

    var con = new wConsequence();
    var counter = 0;

    con.then_( function()
    {

      test.identical( counter,0 );
      counter = 2;

    });

    test.identical( counter,0 );
    con.give();

    con.got( function()
    {

      test.identical( counter,2 );
      counter = 4;

    });

    con.then_( function()
    {

      test.identical( counter,4 );
      counter = 6;

    });

    con.then_( function()
    {

      test.identical( counter,6 );
      counter = 8;

    });

    test.identical( counter,4 );
    con.give();
    test.identical( counter,8 );

  }

}

// --
// proto
// --

var Proto =
{

  tests:
  {

    promiseMode: promiseMode,
    eventMode: eventMode,

    then: then,

  },

  name : 'Consequence',

};

Self.__proto__ = Proto;
wTests[ Self.name ] = Self;

if( typeof module !== 'undefined' && !module.parent )
_.testing.test( Self );

} )( );
