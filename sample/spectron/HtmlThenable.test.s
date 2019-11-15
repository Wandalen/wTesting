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

function html( test )
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

  let ready = app.start()

  .then( () => app.client.waitUntilTextExists( 'p','Hello world', 5000 ) )

  .then( () =>
  {
    test.case = 'Check element text'
    return app.client.$( '.class1 p' ).getText()
    .then( ( got ) =>
    {
      test.identical( got, 'Text1' )
    })
  })

  .then( () =>
  {
    test.case = 'Check href attribute'
    return app.client.$( '.class1 a' ).getAttribute( 'href')
    .then( ( got ) =>
    {
      test.is( _.strEnds( got, '/index.html' ) )
    })
  })

  .then( () =>
  {
    test.case = 'Check input field value'
    return app.client.getValue( '#input1' )
    .then( ( got ) =>
    {
      test.identical( got, '123' )
    })
  })

  .then( () =>
  {
    test.case = 'Change input field value and check it'
    return app.client
    .$( '#input1' )
    .setValue( '321' )
    .getValue( '#input1' )
    .then( ( got ) =>
    {
      test.identical( got, '321' )
    })
  })

  .then( () => app.stop() )

  return _.Consequence.From( ready );
}

// --
// suite
// --

var Self =
{

  name : 'Visual.Spectron.Html.Thenable',
  
  

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
    html
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
