
const _ = require( 'wTesting' );

//

function identical1( test )
{
  test.case = 'maps with 1 identical funcs, without path';
  var srcs =
  [
    {
      f : func1,
      a : 'reducing1',
      b : [ 1, 3 ],
      c : true,
    },
    {
      f : func1,
      a : 'reducing2',
      b : [ 1, 3 ],
      c : true,
    },
  ]
  test.identical( srcs[ 0 ], srcs[ 1 ] );

  /* - */

  function func1(){};

}

//

function identical2( test )
{
  test.case = 'maps with 1 identical func and 1 different';
  var srcs =
  [
    {
      f1 : func1,
      f2 : function b(){},
      a : 'reducing1',
      b : [ 1, 3 ],
      c : true,
    },
    {
      f1 : func1,
      f2 : function b(){},
      a : 'reducing2',
      b : [ 1, 3 ],
      c : true,
    },
  ]
  test.identical( srcs[ 0 ], srcs[ 1 ] );

  /* - */

  function func1(){};
}

//

function identical3( test )
{
  test.case = 'maps with 3 identical func and 1 different, with async';
  var srcs =
  [
    {
      f1 : func1,
      f2 : func2,
      f3 : func3a,
      f4 : function a(){},
      a : 'reducing1',
      b : [ 1, 3 ],
      c : true,
    },
    {
      f1 : func1,
      f2 : func2,
      f3 : func3a,
      f4 : function a(){},
      a : 'reducing2',
      b : [ 1, 3 ],
      c : true,
    },
  ]
  test.identical( srcs[ 0 ], srcs[ 1 ] );

  /* - */

  function func1(){};

  function func2(){};

  async function func3a(){};

}

//

const Proto =
{
  name : 'Fail',
  tests :
  {
    identical1,
    identical2,
    identical3,
  }
}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
