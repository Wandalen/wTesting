( function _Electron_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../Tools.s' );

  require( '../tester/MainTop.s' );
  _.include( 'wFiles' );

  var electronPath = require( 'electron' );
  var spectron = require( 'spectron' );

}

var _global = _global_;
var _ = _global_.wTools;

//

function onSuiteBegin()
{
  let self = this;

  self.tempDir = _.path.pathDirTempOpen( _.path.join( __dirname, '../..'  ), 'Tester' );
  self.assetDirPath = _.path.join( __dirname, '_asset' );
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
  let originalDirPath = _.path.join( self.assetDirPath, 'electron' );
  let routinePath = _.path.join( self.tempDir, test.name );
  let mainPath = _.path.join( routinePath, 'main.js' );
  let mainPathNativized= _.path.nativize( mainPath );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : routinePath } })

  let app = new spectron.Application
  ({
    path : electronPath,
    args : [ mainPathNativized ]
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

//

function consequenceFromExperiment( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetDirPath, 'html' );
  let routinePath = _.path.join( self.tempDir, test.name );
  let mainPath = _.path.join( routinePath, 'main.js' );
  let mainPathNativized= _.path.nativize( mainPath );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : routinePath } })

  let app = new spectron.Application
  ({
    path : electronPath,
    args : [ mainPathNativized ]
  })

  let ready = app.start(); //returns promise

  test.is( _.promiseIs( ready ) )

  ready.then( () => app.client.waitUntilTextExists( 'p','Hello world', 5000 ) )

  ready = _.Consequence.From( ready );

  ready.then( () => _.Consequence.From( app.client.getValue( '#input1' ) ) )// returns promiseLike object

  ready.then( ( got ) =>
  {
    test.case = 'input field value expected, but not object';

    console.log( 'promiseIs:', _.promiseIs( got ) )
    console.log( 'promiseLike:', _.promiseLike( got ) )
    console.log( 'typeof:', typeof got )
    console.log( 'has then routine:', _.routineIs( got.then ) )
    console.log( 'has catch routine:', _.routineIs( got.catch ) )

    test.identical( got, '123' )
    return got;
  })

  ready.then( () =>_.Consequence.From( app.stop() ) )

  return ready;

}

consequenceFromExperiment.experimental = 1;

// --
// suite
// --

var Self =
{

  name : 'Tools.atop.Tester.Electron',
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
    html,
    consequenceFromExperiment
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
