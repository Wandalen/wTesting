require( 'wTesting' );
let num = require( './Number.s' );

//

function numberIs( test )
{
  test.case = 'src is positive integer';
  var src = 5;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is negative integer';
  var src = -5;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is positive float';
  var src = 1.234;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is negative float';
  var src = -1.234;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is zero';
  var src = 0;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is positive float';
  var src = 0.123;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is negative float';
  var src = -0.123;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is binary number';
  var src = 0b1010;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is binary number';
  var src = 0o31;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is hex number';
  var src = 0xAB;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is positive zero';
  var src = +0;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is negative zero';
  var src = -0;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is Infinity';
  var src = Infinity;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is -Infinity';
  var src = -Infinity;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is NaN';
  var src = NaN;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is number created by Number constructor';
  var src = Number( '1' );
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is BigInt';
  var src = 10n;
  var got = num.numberIs( src );
  var expected = false;
  test.identical( got, expected );

  test.case = 'src is null';
  var src = null;
  var got = num.numberIs( src );
  var expected = false;
  test.identical( got, expected );

  test.case = 'src is undefined';
  var src = undefined;
  var got = num.numberIs( src );
  var expected = false;
  test.identical( got, expected );

  test.case = 'src is an array';
  var src = [ 1, 2 ];
  var got = num.numberIs( src );
  var expected = false;
  test.identical( got, expected );

  test.case = 'src is constructor Number';
  var src = Number;
  var got = num.numberIs( src );
  var expected = false;
  test.identical( got, expected );

  if( !Config.debug )
  return;

  test.case = 'call without arguments';
  test.shouldThrowErrorSync( () => num.numberIs() );

  test.case = 'call with extra argument';
  test.shouldThrowErrorSync( () => num.numberIs( 1, 'extra' ) );
}

let Self =
{

  name : 'Number',
  enabled : 1,

  tests :
  {

    numberIs,

  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

