( function _Spectron_test_s_()
{

'use strict';

require( 'wTesting' );
var ElectronPath = require( 'electron' );
var Spectron = require( 'spectron' );

let _ = _realGlobal_._testerGlobal_.wTools

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

//

async function waitForVisibleInViewportThrowing( test )
{
  let self = this;
  let appPath = _.path.nativize( _.path.join( __dirname, 'main.ss' ) );
  let app, err;

  try
  {
    app = new Spectron.Application
    ({
      path : ElectronPath,
      args : [ appPath ]
    })

    await app.start();
    await _.test.waitForVisibleInViewport
    ({
      targetSelector : 'p',
      timeOut : 1,
      page : app.client,
      library : 'spectron'
    });
  }
  catch( _err )
  {
    _.errLogOnce( _err );

    if( app && app.isRunning() )
    await app.stop();

    err = _err;
  }
  finally
  {
    test.is( _.errIs( err ) );
    test.is( !app.isRunning() )
  }
}

// --
// suite
// --

let Self =
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
    clientContinuesToWorkAfterTest,
    waitForVisibleInViewportThrowing
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
