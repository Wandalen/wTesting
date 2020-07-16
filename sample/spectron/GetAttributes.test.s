( function _GetAttributes_test_s_( ) {

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

async function elementsAttributeGet( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let indexPath = _.path.nativize( _.path.join( routinePath, 'index.html' ) );

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ indexPath ]
  })

  await app.start()
  await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )

  var got = await app.client.getAttribute( 'div[attr]', 'attr' );
  test.identical( got, [ '1', '2', '3' ] )
  
  await app.stop();

  return null;
}

// --
// suite
// --

let Self =
{

  name : 'Visual.Spectron.GetAttributes',
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
    elementsAttributeGet,
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
