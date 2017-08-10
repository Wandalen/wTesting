( function Experiment_js( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../staging/abase/object/Tester.debug.s' );

  try
  {
    require( '../staging/abase/object/Tester.debug.s' );
  }
  catch( err )
  {
    require( 'wTesting' );
  }

}

var _ = wTools;
var Self = {};

//

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
  verbose : 1,

  tests :
  {
    singleMessage : singleMessage,
    multipleMessages : multipleMessages,
    multipleMessagesAsync : multipleMessagesAsync,
  }

}

//

_.mapExtend( Self,Proto );

if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self );

} )( );
