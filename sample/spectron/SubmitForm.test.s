( function _SubmitForm_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( 'wTools' );
  _.include( 'wTesting' );
  _.include( 'wFiles' );

  var ElectronPath = require( 'electron' );
  var Spectron = require( 'spectron' );

}

var _global = _global_;
var _ = _global_.wTools;

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

async function submitForm( test )
{
  let self = this;
  
  // Prepare path to electron app script( main.js )
  let indexHtml = _.path.nativize( _.path.join( __dirname, 'asset/form/index.html' ) );

  // Create app instance using path to main.js and electron binary
  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ indexHtml ]//use path to index html as arg for electron app
  })

  // Start the electron app
  await app.start()
  // Waint until page will be loaded
  await app.client.waitUntilTextExists( 'p', 'Result', 5000 );
  
  // Set input field value
  await app.client.$( '#input1' ).setValue( '321' );
  
  //Click submit button
  await app.client.$( '#submit' ).click();
  
  // Check text result
  var result = await app.client.$( '#result' ).getText();
  test.identical( result, 'Result:321' )

  //Stop the electron app
  return app.stop();
}

// --
// suite
// --

var Self =
{

  name : 'Visual.Spectron.SubmitForm',
  
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
    submitForm,
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
