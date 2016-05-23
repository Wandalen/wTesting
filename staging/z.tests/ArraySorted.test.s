( function( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  require( '../object/zTesting.debug.s' );
}

_global_.wTests = _global_.wTests === undefined ? {} : _global_.wTests;

var _ = wTools;
var Self = {};

// --
// test
// --

var arraySortedAdd = function( test )
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
    expected.sort();
    test.identical( got,expected );
  }

}

//

var arraySortedClosest = function( test )
{
  var self = this;

  var samples =
  [

    //[],
    [ 0 ],

    [ 0,0 ],
    [ 0,1 ],

    [ 0,1,2 ],
    [ 0,1,1 ],
    [ 0,0,1 ],
    [ 0,0,0 ],
    [ 0,2,2 ],
    [ 0,2,4 ],

    [ 0,0,1,1 ],
    [ 0,0,1,4 ],
    [ -1,1,2,4 ],

  ];

  for( var s = 0 ; s < samples.length ; s++ )
  {
    var sample = samples[ s ];

    for( var current = -1 ; current < 5 ; current++ )
    {

      var closest = _.arraySortedClosest( sample,current );

      for( var i = 0 ; i < sample.length ; i++ )
      if( !( Math.abs( sample[ i ] - current ) >= Math.abs( closest.value - current ) ) )
      test.identical( true,false );

    }

  }

  test.identical( true,true );
}

// --
// proto
// --

var Proto =
{

  tests:
  {

    arraySortedAdd: arraySortedAdd,
    arraySortedClosest: arraySortedClosest,

  },

  name : 'SortedArrayTests',

};

Self.__proto__ = Proto;
wTests[ Self.name ] = Self;

if( typeof module !== 'undefined' && !module.parent )
_.testing.test( Self );

} )( );
