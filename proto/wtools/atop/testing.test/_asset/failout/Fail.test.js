
let _ = require( 'wTesting' );
// let Hello = require( './Hello.js' );

//

function identical1( test )
{
  test.case = 'maps with > 1 el, 2 identical funcs, without path';
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
  // test.identical( _.strStrip( got ), _.strStrip( expected ) );
  test.identical( srcs[ 0 ], srcs[ 1 ] );

  // test.case = 'maps with > 1 el, 2 identical funcs, without path';
//   var expected =
// `- got :
//   { 'a' : 'reducing1' }
// - expected :
//   { 'a' : 'reducing2' }
// - difference :
//   { 'a' : 'reducing*
// `

//   var srcs =
//   [
//     {
//       f : func1,
//       a : 'reducing1',
//       b : [ 1,3 ],
//       c : true,
//     },
//     {
//       f : func1,
//       a : 'reducing2',
//       b : [ 1,3 ],
//       c : true,
//     },
//   ]

//   var got = _.entityDiffExplanation
//   ({
//     name1 : '- got',
//     name2 : '- expected',
//     srcs,
//     accuracy : null,
//   });
//   test.identical( _.strStrip( got ), _.strStrip( expected ) );

//   /* */

//   test.case = 'maps with > 1 el, 1 identical func and 1 different, without path';

//   var expected =
// `- got :
//   { 'f2' : [ routine b ], 'a' : 'reducing1' }
// - expected :
//   { 'f2' : [ routine b ], 'a' : 'reducing2' }
// - difference :
//   { 'f2' : [ routine b ], 'a' : 'reducing*
// `

//   var srcs =
//   [
//     {
//       f1 : func1,
//       f2 : function b(){},
//       a : 'reducing1',
//       b : [ 1,3 ],
//       c : true,
//     },
//     {
//       f1 : func1,
//       f2 : function b(){},
//       a : 'reducing2',
//       b : [ 1,3 ],
//       c : true,
//     },
//   ]

//   var got = _.entityDiffExplanation
//   ({
//     name1 : '- got',
//     name2 : '- expected',
//     srcs,
//     accuracy : null,
//   });
//   test.identical( _.strStrip( got ), _.strStrip( expected ) );

//   /* */

//   test.case = 'maps with > 1 el, 3 identical func and 1 different, with async, without path';

//   var expected =
// `- got :
//   { 'f4' : [ routine a ], 'a' : 'reducing1' }
// - expected :
//   { 'f4' : [ routine a ], 'a' : 'reducing2' }
// - difference :
//   { 'f4' : [ routine a ], 'a' : 'reducing*
// `

//   var srcs =
//   [
//     {
//       f1 : func1,
//       f2 : func2,
//       f3 : func3a,
//       f4 : function a(){},
//       a : 'reducing1',
//       b : [ 1,3 ],
//       c : true,
//     },
//     {
//       f1 : func1,
//       f2 : func2,
//       f3 : func3a,
//       f4 : function a(){},
//       a : 'reducing2',
//       b : [ 1,3 ],
//       c : true,
//     },
//   ]

//   var got = _.entityDiffExplanation
//   ({
//     name1 : '- got',
//     name2 : '- expected',
//     srcs,
//     accuracy : null,
//   });
//   test.identical( _.strStrip( got ), _.strStrip( expected ) );

  /* - */

  function func1(){};

  function func2(){};

  async function func3a(){}
}

//

function equivalent( test )
{

  // test.case = 'pass';
  // test.identical( Hello.join( 1, 3 ), '13' );

  // test.case = 'fail';
  // test.identical( Hello.join( 1, 3 ), 13 );

}

//

let Self =
{
  name : 'Fail',
  tests :
  {
    identical1,
    equivalent,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
