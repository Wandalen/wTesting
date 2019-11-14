( function _Electron_test_s_( ) {

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

function chaining( test )
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

  return app.start()
  .then( () =>
  {
    test.case = 'wait for load then check innerText property'
    return app.client
    .waitUntilTextExists( 'p','Hello world', 5000 )
    .$( '.class1 p' )
    .getText()
    .then( ( text ) => test.identical( text, 'Text1' ) )
  })
  .then( () => app.stop() )
}

// --
// suite
// --

var Self =
{

  name : 'Visual.Spectron.Html.Chaining',
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
    chaining
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
