( function _Spectron_test_s_( ) {

'use strict';

var _ = require( 'wTesting' );
var ElectronPath = require( 'electron' );
var Spectron = require( 'spectron' );

var _ = _realGlobal_._testerGlobal_.wTools

// --
// tests
// --

//

async function routineTimeOut( test )
{
  let self = this;
  let indexHtmlPath = _.path.nativize( _.path.join( __dirname, 'index.html' ) );

  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ indexHtmlPath ]
  })

  await app.start()
  await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )
  _.time.out( 5000 ).deasync();
  test.identical( 1, 1 );
  await app.stop();

  return null;
}

routineTimeOut.timeOut = 3000;

//

async function spectronTimeOut( test )
{
  let self = this;
  let indexHtmlPath = _.path.nativize( _.path.join( __dirname, 'index.html' ) );

  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ indexHtmlPath ]
  })

  await app.start()
  await app.client.waitUntilTextExists( 'p', 'Hello worldd', 3000 )
  test.identical( 1, 1 );
  await app.stop();

  return null;
}

//

async function errorInTest( test )
{
  let self = this;
  let indexHtmlPath = _.path.nativize( _.path.join( __dirname, 'index.html' ) );

  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ indexHtmlPath ]
  })

  await app.start()
  await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )
  throw _.err( 'Test' );
}

//

async function clientContinuesToWorkAfterTest( test )
{
  let self = this;
  let indexHtmlPath = _.path.nativize( _.path.join( __dirname, 'index.html' ) );

  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ indexHtmlPath ]
  })

  await app.start()
  await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )
}

// --
// suite
// --

var Self =
{

  name : 'Visual.Spectron.Zombie',
  silencing : 1,
  enabled : 1,

  routineTimeOut : 300000,

  context :
  {
  },

  tests :
  {
    routineTimeOut,
    spectronTimeOut,
    errorInTest,
    clientContinuesToWorkAfterTest
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
