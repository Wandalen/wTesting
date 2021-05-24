
const _ = require( 'wTesting' );

//

function open( test )
{
  test.identical( 1, 1 );
}

//

function build( test )
{
  test.identical( 1, 1 );
}

//

function importOne( test )
{
  test.identical( 1, 1 );
}

//

function exportOne( test )
{
  test.identical( 1, 1 );
}

//

function module( test )
{
  test.identical( 1, 1 );
}

//

function submodule( test )
{
  test.identical( 1, 1 );
}

//

var Self1 =
{
  name : 'RunWithArrayOfRoutines',
  tests :
  {

    open,
    build,
    importOne,
    exportOne,
    module,
    submodule,

  }
}

//

Self1 = wTestSuite( Self1 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self1.name );
