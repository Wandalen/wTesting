
require( 'wTesting' );

let _ = _globals_.testing.wTools;

_.include( 'wProcedure' );
_.include( 'wConsequence' );

//

function procedure1( test )
{

  test.case = 'give msg before timeOut';
  var t = 100;

  var con1 = _.time.out( t*2, () => 1 );

  console.log( 'v1' );

  _.time.out( t, function()
  {
    console.log( 'v2' )
    con1.error( _.dont );
    con1.give( ( er, got ) =>
    {
      console.log( 'v3' )
    })
    con1.give( ( er, got ) =>
    {
      console.log( 'v4' )
    })
    con1.give( ( er, got ) =>
    {
      console.log( 'v5' )
    })
  })

  return _.time.out( t*5 ).then( () =>
  {
    test.identical( con1.argumentsCount(), 0 );
    test.identical( con1.errorsCount(), 0 );
    test.identical( con1.competitorsCount(), 1 );
    con1.cancel();
    return null;
  });
}

//

var Self1 =
{
  name : 'Bug1TestSuite',
  tests :
  {
    procedure1,
  }
}

//

Self1 = wTestSuite( Self1 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self1.name );
