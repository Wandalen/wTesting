( function _WaitForVisibleInViewport_test_s_()
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

async function waitForVisibleInViewport( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let mainPath = _.path.nativize( _.path.join( routinePath, 'main.ss' ) );

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ]
  })

  await app.start()
  await _.test.waitForVisibleInViewport
  ({
    library : 'spectron',
    page : app.client,
    timeOut : 5000,
    targetSelector : 'p'
  });

  var element = await app.client.$( 'p' );
  var got = await element.isDisplayedInViewport();
  test.identical( got, true );

  await app.stop();

  return null;
}

// --
// suite
// --

var Self =
{

  name : 'Visual.Spectron.WaitForVisibleInViewport',
  silencing : 1,
  enabled : 1,

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
    waitForVisibleInViewport,
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
