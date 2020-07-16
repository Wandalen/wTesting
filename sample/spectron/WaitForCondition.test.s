( function _WaitForCondition_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( 'wTools' );
  _.include( 'wTesting' );

  var ElectronPath = require( 'electron' );
  var Spectron = require( 'spectron' );

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
  let mainJsPath = _.path.nativize( _.path.join( __dirname, 'asset/main.js' ) );

  // Create app instance using path to main.js and electron binary
  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainJsPath ]
  })

  // Start the electron app
  await app.start()
  // Waint until page will be loaded( Text appears on page )
  await app.client.waitUntilTextExists( 'p','Hello world', 5000 )

  //Change text property after delay
  _.timeOut( 1500, () => 
  {
     app.client.execute( () => 
     {  
      let element = document.querySelector( 'p' );
      element.innerText = 'Hello from test'
     })
  })
  
  //Wait until text will be changed
  await app.client.waitUntil( async () => 
  {
    return await app.client.$( 'p' ).getText() === 'Hello from test';
  })
  
  //Check text property
  var got = await app.client.$( 'p' ).getText();
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
  
  onSuiteBegin : onSuiteBegin,
  onSuiteEnd : onSuiteEnd,
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
