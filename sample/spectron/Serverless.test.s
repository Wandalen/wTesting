( function _Serverless_test_s_( ) {

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

async function loadLocalHtmlFile( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let indexHtmlPath = _.path.nativize( _.path.join( routinePath, 'serverless/index.html' ) );

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ indexHtmlPath ]
  })
  await app.start()
  await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )

  var got = await app.client.execute( () => window.scriptLoaded )
  test.identical( got.value, true );
  
  var got = await app.client.getCssProperty( 'p', 'color' )
  test.identical( got.value, 'rgba(192,192,192,1)' );

  await app.stop();

  return null;
}

// --
// suite
// --

var Self =
{

  name : 'Visual.Spectron.Serverless',
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
    loadLocalHtmlFile,
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
