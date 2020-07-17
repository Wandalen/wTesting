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
let _ = _testerGlobal_.wTools;
let Self = {};

var singleMessage = function( test )
{
 var consequence = new wConsequence().give();
 consequence
 .ifNoErrorThen( function()
 {
   test.description = 'single message';
   var con = new wConsequence().give( 'data' );
   return test.shouldMessageOnlyOnce( con );
 })
 .ifNoErrorThen( function ( data )
 {
   test.identical( data, 'data' );
 });

 return consequence;
}

//

var multipleMessages = function( test )
{
  var consequence = new wConsequence().give();
  consequence
  .ifNoErrorThen( function()
  {
    test.identical( 'data', 'data' );
  })
  .ifNoErrorThen( function()
  {
    test.description = 'two messages';
    var con = new wConsequence()
    .give( null, 'data' )
    .give( null, 'data' );
    return test.shouldMessageOnlyOnce( con );
  })
  .ifNoErrorThen( function( data )
  {
    test.identical( 'data', 'data' );
  })
  .ifNoErrorThen( function( data )
  {
    test.identical( 'data', 'data' );
  })
  ;

 return consequence;
}

//

var multipleMessagesAsync = function( test )
{
  var consequence = new wConsequence().give();

  consequence
  .ifNoErrorThen( function()
  {
    test.identical( 'data', 'data' );
  })
  .ifNoErrorThen( function()
  {
    test.description = 'two messages';
    var con = new wConsequence();
    con.give( null, 'data' );
    _.timeOut( 1000,function()
    {
      con.give( null, 'data' );
    });
    return test.shouldMessageOnlyOnce( con );
  })
  .ifNoErrorThen( function( data )
  {
    test.identical( 'data', 'data' );
  })
  .ifNoErrorThen( function( data )
  {
    test.identical( 'data', 'data' );
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
    singleMessage : singleMessage,
    multipleMessages : multipleMessages,
    multipleMessagesAsync : multipleMessagesAsync,
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
