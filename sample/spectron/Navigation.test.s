( function _Navigation_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../..' );
  require( 'wFiles' )

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
  self.tempDir = _.path.pathDirTempOpen( _.path.join( __dirname, '../..'  ), 'Tester' );
  self.assetDirPath = _.path.join( __dirname, 'asset' );
}

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.tempDir, 'Tester' ) )
  _.path.pathDirTempClose( self.tempDir );
}

// --
// tests
// --

//

async function navigation( test )
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
  await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )

  await app.client.url( 'https://www.npmjs.com/' );
  var url = await app.client.getUrl();
  test.identical( url,'https://www.npmjs.com/' );
  
  await app.client.url( 'https://www.npmjs.com/wTesting' );
  var url = await app.client.getUrl();
  test.identical( url,'https://www.npmjs.com/package/wTesting' );
  
  await app.client.back();
  var url = await app.client.getUrl();
  test.identical( url,'https://www.npmjs.com/' );
  
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
