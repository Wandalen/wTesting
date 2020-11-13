( function _Electron_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( 'wTools' );
  _.include( 'wTesting' );

  var ElectronPath = require( 'electron' );
  var Spectron = require( 'spectron' );

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

async function htmlAwait( test )
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
  await app.client.waitUntilTextExists( 'p','Hello world', 5000 )

  test.case = 'Check element text'
  var element = await app.client.$( '.class1 p' );
  var got = await element.getText();
  test.identical( got, 'Text1' )

  test.case = 'Check href attribute'
  var element = await app.client.$( '.class1 a' );
  var got = await element.getAttribute( 'href');
  test.is( _.strEnds( got, '/index.html' ) )

  test.case = 'Check input field value'
  var element = await app.client.$( '#input1' );
  var got = await element.getValue();
  test.identical( got, '123' )

  test.case = 'Change input field value and check it'
  var element = await app.client.$( '#input1' );
  await element.setValue( '321' );
  var got = await element.getValue( '#input1' )
  test.identical( got, '321' )

  await app.stop();

  return null;
}

// --
// suite
// --

let Self =
{

  name : 'Visual.Spectron.Html.Await',



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
    htmlAwait,
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
