( function Experiment_js( ) {

'use strict';

if( typeof module !== 'undefined' )
require( 'wTesting' );

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
   test.description = 'two messages';
   var con = new wConsequence()
   .give( null, 'data' )
   .give( null, 'data' );
   return test.shouldMessageOnlyOnce( con );
 })
 .ifNoErrorThen( function ( data )
 {
   test.identical( data, 'data' );
 });

 return consequence;
}

//

var Proto =
{

  name : 'Experiment',

  tests:
  {
    singleMessage : singleMessage,
    multipleMessages : multipleMessages,
  }

}

_.mapExtend( Self,Proto );

if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self );

} )( );
