( function _ArraySorted_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  try
  {
    require( '../../amid/diagnostic/Testing.debug.s' );
  }
  catch( err )
  {
    require( 'wTesting' );
  }

}

var _ = wTools;
var Self = {};

// --
// test
// --

var makeArray = function makeArray( length,density )
{
  var top = length / density;

  if( top < 1 ) top = 1;

  var array = [];
  for( var i = 0 ; i < length ; i += 1 )
  array[ i ] = Math.round( Math.random()*top );

  array.sort( function( a,b ){ return a-b } );

  return array;
}

//

var arraySortedLookUpIndex = function arraySortedLookUpIndex( test )
{

  test.description = 'simples';

  // [16, 17, 34, 34, 37, 42, 44, 44, 5, 9]
  // [ 1,2,3 ]
  // 0 -1
  // 1 0,1
  // 2 0,1

  var a = [ 1,2,3 ];

  var i = _.arraySortedLookUpIndex( a,0 );
  test.shouldBe( i === 0 );

  var i = _.arraySortedLookUpIndex( a,1 );
  test.shouldBe( i === 0 );

  var i = _.arraySortedLookUpIndex( a,2 );
  test.shouldBe( i === 1 );

  var i = _.arraySortedLookUpIndex( a,3 );
  test.shouldBe( i === 2 );

  var i = _.arraySortedLookUpIndex( a,4 );
  test.shouldBe( i === 3 );

  function testArray( array,top )
  {

    for( var ins = -1 ; ins < top+1 ; ins++ )
    {
      var index = _.arraySortedLookUpIndex( array,ins );

      if( 1 <= index && index <= array.length-1 )
      test.shouldBe( array[ index-1 ] <= array[ index ] );

      if( 0 <= index && index <= array.length-2 )
      test.shouldBe( array[ index ] <= array[ index+1 ] );

      if( ins !== array[ index ] )
      {

        if( 0 <= index && index <= array.length-1 )
        test.shouldBe( ins < array[ index ] );

        if( 1 <= index && index <= array.length-1 )
        test.shouldBe( array[ index-1 ] < ins );

      }

    }

  }

  for( var c = 10 ; c <= 100 ; c *= 10 )
  {
    var array = makeArray( c,5 );
    testArray( array,c/5 );
  }

  for( var c = 10 ; c <= 100 ; c *= 10 )
  {
    var array = makeArray( c,0.2 );
    testArray( array,c/0.2 );
  }

  test.identical( true,true );
}

//

var arraySortedAdd = function arraySortedAdd( test )
{
  var self = this;

  // 13.00 13.00 10.00 10.00 10.00 2.000 10.00 15.00 2.000 14.00 10.00 6.000 6.000 15.00 4.000 8.000

  var samples =
  [

    [],
    [ 0 ],

    [ 0,1 ],
    [ 1,0 ],

    [ 1,0,2 ],
    [ 2,0,1 ],
    [ 0,1,2 ],
    [ 0,2,1 ],
    [ 2,1,0 ],
    [ 1,2,0 ],

    [ 0,1,1 ],
    [ 1,0,1 ],
    [ 1,1,0 ],

    [ 0,0,1,1 ],
    [ 0,1,1,0 ],
    [ 1,1,0,0 ],
    [ 1,0,1,0 ],
    [ 0,1,0,1 ],

    //_.arrayFill({ times : 16 }).map( function(){ return Math.floor( Math.random() * 16 ) } ),

  ];

  for( var s = 0 ; s < samples.length ; s++ )
  {
    var expected = samples[ s ].slice();
    var got = [];
    for( var i = 0 ; i < expected.length ; i++ )
    _.arraySortedAdd( got,expected[ i ] );
    expected.sort( function( a,b ){ return a-b } );
    test.identical( got,expected );
  }

}

//

// var arraySortedClosest = function arraySortedClosest( test )
// {
//   var self = this;
//
//   var samples =
//   [
//
//     //[],
//     [ 0 ],
//
//     [ 0,0 ],
//     [ 0,1 ],
//
//     [ 0,1,2 ],
//     [ 0,1,1 ],
//     [ 0,0,1 ],
//     [ 0,0,0 ],
//     [ 0,2,2 ],
//     [ 0,2,4 ],
//
//     [ 0,0,1,1 ],
//     [ 0,0,1,4 ],
//     [ -1,1,2,4 ],
//
//   ];
//
//   for( var s = 0 ; s < samples.length ; s++ )
//   {
//     var sample = samples[ s ];
//
//     for( var current = -1 ; current < 5 ; current++ )
//     {
//
//       var closest = _.arraySortedClosest( sample,current );
//
//       for( var i = 0 ; i < sample.length ; i++ )
//       if( !( Math.abs( sample[ i ] - current ) >= Math.abs( closest.value - current ) ) )
//       test.identical( true,false );
//
//     }
//
//   }
//
//   test.identical( true,true );
// }

//

var arraySortedLookUpInterval = function arraySortedLookUpInterval( test )
{
  var self = this;

  /* */

  var arr = [ 0,0,0,0,1,1,1,1 ];

  var range = _.arraySortedLookUpInterval( arr,[ 1,1 ] );
  test.identical( [ 4,8 ],range );

  var range = _.arraySortedLookUpInterval( arr,[ 1,2 ] );
  test.identical( [ 4,8 ],range );

  var range = _.arraySortedLookUpInterval( arr,[ 0,0 ] );
  test.identical( [ 0,4 ],range );

  var range = _.arraySortedLookUpInterval( arr,[ -1,0 ] );
  test.identical( [ 0,4 ],range );

  var range = _.arraySortedLookUpInterval( arr,[ 0,1 ] );
  test.identical( [ 0,8 ],range );

  var range = _.arraySortedLookUpInterval( arr,[ -1,3 ] );
  test.identical( [ 0,8 ],range );

  var range = _.arraySortedLookUpInterval( arr,[ -2,-1 ] );
  test.identical( [ 0,0 ],range );

  var range = _.arraySortedLookUpInterval( arr,[ 2,3 ] );
  test.identical( [ 8,8 ],range );

  /* */

  var arr = [ 2, 2, 4, 18, 25, 25, 25, 26, 33, 36 ];

  debugger;
  var range = _.arraySortedLookUpInterval( arr,[ 7,28 ] );
  test.identical( [ 3,8 ],range );

  /* */

  function testArray( arr,top )
  {

    for( var val = 0 ; val < top ; val++ )
    {
      var interval = [ Math.round( Math.random()*( top+2 )-1 ) ];
      interval[ 1 ] = interval[ 0 ] + Math.round( Math.random()*( top+2 - interval[ 0 ] ) );

      // debugger;
      var range = _.arraySortedLookUpInterval( arr,interval );

      if( range[ 0 ] < arr.length )
      test.shouldBe( arr[ range[ 0 ] ] >= interval[ 0 ] );

      test.shouldBe( range[ 0 ] >= 0 );
      test.shouldBe( range[ 1 ] <= arr.length );

      if( range[ 0 ] < range[ 1 ] )
      {
        test.shouldBe( arr[ range[ 0 ] ] >= interval[ 0 ] );
        test.shouldBe( arr[ range[ 1 ]-1 ] <= interval[ 1 ] );

        if( range[ 0 ] > 0 )
        test.shouldBe( arr[ range[ 0 ]-1 ] < interval[ 0 ] );

        if( range[ 1 ] < arr.length )
        test.shouldBe( arr[ range[ 1 ] ] > interval[ 1 ] );

      }

    }

  }

  /* */

  debugger;

  for( var c = 10 ; c <= 100 ; c *= 10 )
  {
    var arr = makeArray( c,5 );
    testArray( arr,c/5 );
  }

  for( var c = 10 ; c <= 100 ; c *= 10 )
  {
    var arr = makeArray( c,0.2 );
    testArray( arr,c/0.2 );
  }

  /* */

  test.identical( true,true );
  debugger;
}

// --
// proto
// --

var Proto =
{

  tests :
  {

    arraySortedLookUpIndex : arraySortedLookUpIndex,
    arraySortedAdd : arraySortedAdd,
    // arraySortedClosest : arraySortedClosest,
    arraySortedLookUpInterval : arraySortedLookUpInterval,

  },

  name : 'ArraySorted',
  verbose : 0,

};

_.mapExtend( Self, Proto );

_global_.wTests = _global_.wTests === undefined ? {} : _global_.wTests;
wTests[ Self.name ] = Self;

// debugger;
if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self );

} )( );
