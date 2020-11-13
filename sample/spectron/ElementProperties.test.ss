( function _ElementProperties_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( 'wTools' );
  _.include( 'wTesting' );

  var ElectronPath = require( 'electron' );
  var Spectron = require( 'spectron' );

}

let _global = _global_;
let _ = _globals_.testing.wTools;

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

async function domElementProperties( test )
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
  await app.client.waitUntilTextExists( 'p','Hello world', 5000 )

  var element = await app.client.$( 'p' );

  //innerText
  var text = await element.getText();
  test.identical( text, 'Hello world' );
  //outerHtml
  var html = await element.getHTML();
  test.identical( html, '<p>Hello world</p>' );
  //Elements position on page
  var location = await element.getLocation();
  test.gt( location.x, 0 );
  test.gt( location.y, 0 );

  //Stop the electron app
  return app.stop();
}

// --
// suite
// --

let Self =
{

  name : 'Visual.Spectron.ElementProperties',



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
    domElementProperties,
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
