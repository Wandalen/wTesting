( function _WaitForDialog_test_s_( ) {

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

async function WaitForDialog( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let mainPath = _.path.nativize( _.path.join( routinePath, 'main.js' ) );

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ]
  })

  await app.start()
  await app.client.waitForVisible( 'p', 5000 )
  await app.client.execute( () => alert( 'test message') );
  test.identical( await app.client.alertText(), 'test message' );
  await app.client.alertAccept();
  await app.stop();

  return null;
}

// --
// suite
// --

var Self =
{

  name : 'Visual.Spectron.WaitForDialog',
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
    WaitForDialog,
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
