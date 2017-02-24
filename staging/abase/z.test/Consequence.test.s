( function _Consequence_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  try
  {
    require( '../../abase/xTesting/Testing.debug.s' );
  }
  catch( err )
  {
    require( 'wTesting' );
  }

}

var _ = wTools;
var sourceFilePath = _.diagnosticLocation().full; // typeof module !== 'undefined' ? __filename : document.scripts[ document.scripts.length-1 ].src;

// --
// test
// --

function ordinarMessage( test )
{
  var self = this;

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

    var con = new wConsequence();

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

    var con = new wConsequence();

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

function persistantMessage( test )
{
  var self = this;

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

    var con = new wConsequence();

    con.persist( ( function(){ var first = 1; return function( err,data )
    {

      test.description = 'first message got with persist';
      test.identical( arguments[ sample.gotArgument ],first );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );
      //test.identical( arguments[ sample.gotArgument ] !== 3,true );
      first += 1;

    }}()) );

    con[ sample.giveMethod ]( 1 );
    con[ sample.giveMethod ]( 2 );
    con.correspondentsCancel();

    /**/

    var got8 = 0;

    con.persist( ( function(){ var first = 3; return function( err,data )
    {

      test.description = 'second message got with persist';
      test.identical( arguments[ sample.gotArgument ],first );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );
      first += 1;

      if( arguments[ sample.gotArgument ] === 8 )
      got8 += 1;

    }}()) );

    con.persist( ( function(){ var first = 3; return function( err,data )
    {

      test.description = 'third message got with persist';
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

    con.persist( ( function(){ var first = 7; return function( err,data )
    {

      test.description = 'got many messages with persist';
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
    var con = new wConsequence();

    con[ sample.giveMethod ]( 1 );
    con[ sample.giveMethod ]( 2 );

    con.persist( ( function(){ var first = 1; return function( err,data )
    {

      test.description = 'got two messages with persist';
      test.identical( arguments[ sample.gotArgument ],first );
      test.identical( arguments[ sample.anotherArgument ],sample.anotherArgumentValue );
      first += 1;

      if( arguments[ sample.gotArgument ] === 2 )
      got2 += 1;

    }}()) );

    con.persist( ( function(){ var first = 7; return function( err,data )
    {

      test.description = 'should never happened';
      test.identical( false,true );

    }}()) );

    _.timeOut( 25, function()
    {
      test.description = 'got one only messages';
      test.identical( got2,1 );
    });

  }

}

//

function then( test )
{
  var self = this;

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

    con.doThen( function()
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

    con.doThen( function()
    {

      test.identical( counter,4 );
      counter = 6;

    });

    con.doThen( function()
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

var Self =
{

  name : 'Consequence',
  sourceFilePath : sourceFilePath,

  tests :
  {

    ordinarMessage : ordinarMessage,
    persistantMessage : persistantMessage,

    then : then,

  },

};

Self = wTestSuite( Self );

if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self.name );

} )( );
