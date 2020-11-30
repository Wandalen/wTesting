
let _ = require( 'wTesting' );

//

function identical1( test )
{
  test.case = 'identical maps, 1 with __proto__ : {}';
  var srcs =
  [
    {
      a : 'hello',
      b : 'hello2',
      __proto__ : {}
    },
    {
      a : 'hello',
      b : 'hello2'
    },
  ]
  test.identical( srcs[ 0 ], srcs[ 1 ] );

}

//

function identical2( test )
{
  test.case = 'identical maps, 2 with __proto__ : {}';
  var srcs =
  [
    {
      a : 'hello1',
      b : 'hello2',
      __proto__ : {}
    },
    {
      a : 'hello1',
      b : 'hello2',
      __proto__ : {}
    },
  ]
  test.identical( srcs[ 0 ], srcs[ 1 ] );
}

//

function identical3( test )
{
  test.case = 'not identical maps, 1 with __proto__ : {}';
  var srcs =
  [
    {
      a : 'hello1',
      b : 'hello2',
      __proto__ : {}
    },
    {
      a : 'hello',
      b : 'hello2',
    },
  ]
  test.identical( srcs[ 0 ], srcs[ 1 ] );

}

//

function identical4( test )
{
  test.case = 'not identical maps, 2 with non empty identical __proto__';
  var srcs =
  [
    {
      a : 'hello1',
      b : 'hello2',
      __proto__ : { c : 'hello3' }
    },
    {
      a : 'hello',
      b : 'hello2',
      __proto__ : { c : 'hello3' }
    },
  ]
  test.identical( srcs[ 0 ], srcs[ 1 ] );

}

//

function identical5( test )
{
  test.case = 'not identical maps, 2 with non empty not identical __proto__';
  var srcs =
  [
    {
      a : 'hello1',
      b : 'hello2',
      __proto__ : { c : 'hello3' }
    },
    {
      a : 'hello',
      b : 'hello2',
      __proto__ : { c : 'hello4' }
    },
  ]
  test.identical( srcs[ 0 ], srcs[ 1 ] );

}

//

let Self =
{
  name : 'Fail',
  tests :
  {
    identical1,
    identical2,
    identical3,
    identical4,
    identical5,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
