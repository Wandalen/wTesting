
require( 'wTesting' );
// const _ = require( 'wTools' );
const _ = _globals_.testing.wTools;
_.include( 'wConsequence' );

//

function asyncErrorHandling( test )
{
  _.Consequence.UncaughtTimeOut = 1;

  let con = new _.Consequence().take( null )

  // /*
  //   In first case error is handled right after creation and tester has time to perform the check.
  //   This case can be commented out.
  // */
  //
  // .then( () =>
  // {
  //   test.case = 'catch handler before test check'
  //   let ready = new _.Consequence().error( 'Test' );
  //   ready.catch( ( err ) =>
  //   {
  //     _.errAttend( err )
  //     throw err;
  //   })
  //   return test.shouldThrowErrorOfAnyKind( ready );
  // })

  /*
    In second case error is not handled right after creation and
    uncaught async error is thrown before tester perform the check
    This case doesn't work as expected.
  */

  .then( () =>
  {
    test.case = 'no catch handler before test check';
    let ready = new _.Consequence().error( 'Test' );
    debugger;
    return test.shouldThrowErrorAsync( ready );
  })

  /*  */

  return con;
}


//

const Proto =
{
  name : 'AsyncErrorHandling',
  tests :
  {
    asyncErrorHandling
  }
}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
