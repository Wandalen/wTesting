
require( 'wTesting' );
// const _ = require( 'wTools' );
const _ = _globals_.testing.wTools;
_.include( 'wProcess' );
let c = 0;

//

_.process.on( 'exit', () =>
{
  debugger;
  c++;
  console.log( 'onExit :', c )
})

//

function onSuiteEnd()
{
  debugger;
  c++;
  console.log( 'onSuiteEnd :', c )
}

//

function routine1( test )
{
  test.identical( 1, 1 );
  return _.time.out( 200 );
}

//

function routine2( test )
{
  process.exit( 0 );
}

//

var Self1 =
{
  name : 'manualTermination',
  onSuiteEnd,
  tests :
  {
    routine1,
    routine2,
  }
}

//

Self1 = wTestSuite( Self1 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self1.name );
