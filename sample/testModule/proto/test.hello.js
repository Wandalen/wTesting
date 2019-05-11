if( typeof module !== 'undefined' )
{
  let _ = require( '../Tools.s' );

  if( typeof _realGlobal_ === 'undefined' || !_realGlobal_.wTester || !_realGlobal_.wTester._isReal_ )

  _.include( 'wLogger' );
  _.include( 'wTesting' );

}

let a = require('./hello.js');
var _global = _global_;
var _ = _global_.wTools;

//

function hello(test)
{
  test.case = 'test output';
  test.will = 'hello';
  var got = a.hello("Hello, ", "World!" );
  var expected = "Hello, World!";
  test.identical( got, expected );
}

function integers(test)
{
  test.case = 'test output2';
  test.will = 'integers';
  var got = a.hello( 1, 2 );
  var expected = "12";
  console.log(got);
  test.identical( got, expected );
}

//

var Self =
{
  name : 'Sample',
  silencing : 0,

  tests :
  {
    hello : hello,
    integers : integers,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );
