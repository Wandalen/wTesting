( function _LocalStorage_test_s_( ) {

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

async function localStorage( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let mainPath = _.path.nativize( _.path.join( routinePath, 'main.js' ) );
  let userDataDirPath = _.path.nativize( _.path.join( routinePath, 'user-dir' ) );

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  /* Use custom user-data-dir to persist localStorage between launches */
  
  test.case = 'create new item'
  var app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ],
    chromeDriverArgs: [ `--user-data-dir=${userDataDirPath}` ]
  })
  await app.start()
  await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )
  await app.client.localStorage( 'POST', { key : 'itemKey', value : 'itemValue' })
  await app.stop();
  
  //
  
  test.case = 'open browser again and get item value'
  var app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ],
    chromeDriverArgs: [ `--user-data-dir=${userDataDirPath}` ]
  })
  await app.start()
  await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )
  var got = await app.client.localStorage( 'GET', 'itemKey' );
  test.identical( got.value, 'itemValue' );
  await app.stop();

  return null;
}

// --
// suite
// --

var Self =
{

  name : 'Visual.Spectron.LocalStorage',
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
    localStorage,
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
