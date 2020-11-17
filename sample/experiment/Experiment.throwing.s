( function Experiment_js( ) {

'use strict';

//----ORIGINAL
// if( typeof module !== 'undefined' )
// require( 'wTesting' );

// let _ = wTools;
// let Self = {};
// -------

if( typeof module !== 'undefined' )
{
  let _ = require( 'wTools' );
  _.include( 'wTesting' );

}

let _global = _global_;
let _ = _globals_.testing.wTools;
let Self = {};

var singleMessage = function( test )
{
 var consequence = new wConsequence().take( null );
 consequence
 .ifNoErrorThen( function()
 {
    test.description = 'single message';
    var con = new wConsequence().take( 'data' );
    return test.returnsSingleResource( con )
    // return test.shouldMessageOnlyOnce( con );
    // return test.shouldMessageOnlyOnceReturn( con )
 })
 .ifNoErrorThen( function ( data )
 {
   return test.identical( data, 'data' );
 });

 return consequence;
}

//

var multipleMessages = function( test )
{
  var consequence = new wConsequence().take( null );
  consequence
  .ifNoErrorThen( function()
  {
    return test.identical( 'data', 'data' );
  })
  .ifNoErrorThen( function()
  {
    test.description = 'two messages';
    var con = new wConsequence({ capacity : 0 })
    .take( null, 'data' )
    .take( null, 'data' );
    return test.returnsSingleResource( con );
    // return test.shouldMessageOnlyOnceReturn( con )
  })
  .ifNoErrorThen( function( data )
  {
    return test.identical( 'data', 'data' );
  })
  .ifNoErrorThen( function( data )
  {
    return test.identical( 'data', 'data' );
  })
  ;

 return consequence;
}

//

var multipleMessagesAsync = function( test )
{
  var consequence = new wConsequence().take( null );

  consequence
  .ifNoErrorThen( function()
  {
    return test.identical( 'data', 'data' );
  })
  .ifNoErrorThen( function()
  {
    test.description = 'two messages';
    var con = new wConsequence({ capacity : 0 });
    con.take( null, 'data' );
    _.time.out( 1000,function()
    {
      con.take( null, 'data' );
    });
    return test.returnsSingleResource( con );
    // return test.shouldMessageOnlyOnceReturn( con )
  })
  .ifNoErrorThen( function( data )
  {
    return test.identical( 'data', 'data' );
  })
  .ifNoErrorThen( function( data )
  {
    return test.identical( 'data', 'data' );
  })
  ;

 return consequence;
}

//

var Proto =
{

  name : 'Experiment',
  // abstract : 0,
  // verbose : 1,

  tests :
  {
    singleMessage,
    multipleMessages,
    multipleMessagesAsync,
  }

}

//

// ---ORIGINAL
// _.mapExtend( Self, Proto );

// if( typeof module !== 'undefined' && !module.parent )
// _.Tester.test( Self );
// -------

Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );


} )( );
