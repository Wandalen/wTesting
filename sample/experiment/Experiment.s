( function Experiment_js( ) {

'use strict';

//----ORIGINAL
// if( typeof module !== 'undefined' )
// require( 'wTesting' );

// var _ = wTools;
// var Self = {};
// -------

if( typeof module !== 'undefined' )
{
  let _ = require( 'wTools' );
  _.include( 'wTesting' );

}

var _global = _global_;
let _ = _testerGlobal_.wTools;
var Self = {};

var singleMessage = function( test )
{
 var consequence = new wConsequence().take( null );
 consequence
 .ifNoErrorThen( function()
 {
    test.description = 'single message';
    var con = new wConsequence().take( 'data' );
    return test.returnsSingleResource( con )
  //  return test.shouldMessageOnlyOnce( con );
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
  var consequence = new wConsequence().give();

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
    _.timeOut( 1000,function()
    {
      con.take( null, 'data' );
    });
    return test.returnsSingleResource( con );
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
