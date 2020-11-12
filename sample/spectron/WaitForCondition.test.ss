( function _WaitForCondition_test_s_()
{

'use strict';

let ElectronPath, Spectron;

if( typeof module !== 'undefined' )
{
  let _ = require( 'wTools' );
  _.include( 'wTesting' );

  ElectronPath = require( 'electron' );
  Spectron = require( 'spectron' );

}

let _global = _global_;
let _ = _testerGlobal_.wTools;

// --
// context
// --

function onSuiteBegin()
{
  let self = this;
  self.tempDir = _.path.tempOpen( _.path.join( __dirname, '../..'  ), 'Tester' );
  self.assetDirPath = _.path.join( __dirname, 'asset' );
}

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.tempDir, 'Tester' ) )
  _.path.tempClose( self.tempDir );
}

// --
// tests
// --

//

async function waitForCondition( test )
{
  let self = this;

  // Prepare path to electron app script( main.js )
  let mainJsPath = _.path.nativize( _.path.join( __dirname, 'asset/main.ss' ) );

  // Create app instance using path to main.js and electron binary
  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainJsPath ]
  })

  // Start the electron app
  await app.start()
  // Waint until page will be loaded( Text appears on page )
  await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )

  //Change text property after delay
  _.time.out( 1500, () =>
  {
    app.client.execute( () =>
    {
      let element = document.querySelector( 'p' );
      element.innerText = 'Hello from test'
    })
  })

  let element = await app.client.$( 'p' );

  //Wait until text will be changed
  await app.client.waitUntil( async () =>
  {
    let text = await element.getText();
    return text === 'Hello from test';
  })

  //Check text property
  var got = await element.getText();
  test.identical( got, 'Hello from test' );

  //Stop the electron app
  return app.stop();
}

// --
// suite
// --

var Self =
{

  name : 'Visual.Spectron.WaitForCondition',

  onSuiteBegin,
  onSuiteEnd,
  routineTimeOut : 300000,

  context :
  {
    tempDir : null,
    assetDirPath : null,
  },

  tests :
  {
    waitForCondition,
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
