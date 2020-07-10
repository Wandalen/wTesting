( function _Navigation_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( 'wTools' );
  _.include( 'wTesting' );

  var ElectronPath = require( 'electron' );
  var Spectron = require( 'spectron' );

}

var _global = _global_;
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

async function navigation( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let mainPath = _.path.nativize( _.path.join( routinePath, 'main.ss' ) );

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  // Init application
  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ]
  })

  // Start app and wait until page will be loaded
  await app.start()
  await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )

  // Open first url
  await app.client.url( 'https://www.npmjs.com/' );
  var url = await app.client.getUrl();
  test.identical( url,'https://www.npmjs.com/' );
  
  // Open second url
  await app.client.url( 'https://www.npmjs.com/wTesting' );
  var url = await app.client.getUrl();
  test.identical( url,'https://www.npmjs.com/package/wTesting' );
  
  // Move backward in history
  await app.client.back();
  var url = await app.client.getUrl();
  test.identical( url,'https://www.npmjs.com/' );
  
  // Move forward in history
  await app.client.forward();
  var url = await app.client.getUrl();
  test.identical( url,'https://www.npmjs.com/package/wTesting' );
  
  await app.stop();

  return null;
}

// --
// suite
// --

var Self =
{

  name : 'Visual.Spectron.Navigation',
  silencing : 1,
  enabled : 1,

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
    navigation,
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
