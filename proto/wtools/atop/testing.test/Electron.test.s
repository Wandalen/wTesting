( function _Electron_test_s_()
{

'use strict';

let ElectronPath, Spectron;

if( typeof module !== 'undefined' )
{
  let _ = require( '../../Tools.s' );

  require( '../testing/entry/Main.s' );

  _.include( 'wFiles' );

  ElectronPath = require( 'electron' );
  Spectron = require( 'spectron' );

}

let _global = _global_;
let _ = _global_.wTools;

// --
// context
// --

function onSuiteBegin()
{
  let self = this;
  self.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..'  ), 'Tester' );
  self.assetsOriginalPath = _.path.join( __dirname, '_asset' );
  self.appStartNonThrowing = _.path.nativize( _.path.join( _.path.normalize( __dirname ), '../testing/entry/Main.s' ) );
  self.toolsPath = _.path.nativize( _.path.join( _.path.normalize( __dirname ), '../../Tools.s' ) );
  self.spectronPath = require.resolve( 'spectron' );
  self.electronPath = require.resolve( 'electron' );
}

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.suiteTempPath, 'Tester' ) )
  _.path.tempClose( self.suiteTempPath );
}

//

function assetFor( test, asset )
{
  let self = this;
  let a = test.assetFor( asset );

  a.reflect = function reflect()
  {

    let reflected = a.fileProvider.filesReflect({ reflectMap : { [ a.originalAssetPath ] : a.routinePath }, onUp });

    reflected.forEach( ( r ) =>
    {
      if( r.dst.ext !== 'js' && r.dst.ext !== 's' )
      return;
      var read = a.fileProvider.fileRead( r.dst.absolute );
      read = _.strReplace( read, `'wTesting'`, `'${_.strEscape( self.appStartNonThrowing )}'` );
      read = _.strReplace( read, `'wTools'`, `'${_.strEscape( self.toolsPath )}'` );
      read = _.strReplace( read, `require( 'spectron' )`, `require( '${_.strEscape( self.spectronPath )}' )` );
      read = _.strReplace( read, `require( 'electron' )`, `require( '${_.strEscape( self.electronPath )}' )` );
      a.fileProvider.fileWrite( r.dst.absolute, read );
    });

  }

  return a;

  function onUp( r )
  {
    if( !_.strHas( r.dst.relative, '.atest.' ) )
    return;
    let relative = _.strReplace( r.dst.relative, '.atest.', '.test.' );
    r.dst.relative = relative;
    _.assert( _.strHas( r.dst.absolute, '.test.' ) );
  }

}

// --
// tests
// --

function html( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetsOriginalPath, 'electron' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let mainPath = _.path.nativize( _.path.join( routinePath, 'main.js' ) );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : routinePath } })

  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ]
  })

  let ready = app.start()

  .then( () => app.client.waitUntilTextExists( 'p', 'Hello world', 5000 ) )

  .then( () =>
  {
    test.case = 'Check element text'
    return app.client.$( '.class1 p' ).then( ( e ) => e.getText() )
    .then( ( got ) =>
    {
      test.identical( got, 'Text1' )
    })
  })

  .then( () =>
  {
    test.case = 'Check href attribute'
    return app.client.$( '.class1 a' ).then( ( e ) => e.getAttribute( 'href' ) )
    .then( ( got ) =>
    {
      test.true( _.strEnds( got, '/index.html' ) )
    })
  })

  .then( () =>
  {
    test.case = 'Check input field value'
    return app.client.$( '#input1' ).then( ( e ) => e.getValue() )
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
    .then( ( e ) => e.setValue( '321' ).then( () => e.getValue() ) )
    .then( ( got ) =>
    {
      test.identical( got, '321' )
    })
  })

  .then( () => app.stop() )

  return _.Consequence.From( ready );
}

//

async function htmlAwait( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetsOriginalPath, 'electron' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let mainPath = _.path.nativize( _.path.join( routinePath, 'main.js' ) );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : routinePath } })

  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ]
  })

  await app.start()
  await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )

  test.case = 'Check element text'
  var got = await app.client.$( '.class1 p' ).then( ( e ) => e.getText() );
  test.identical( got, 'Text1' )

  test.case = 'Check href attribute'
  var got = await app.client.$( '.class1 a' ).then( ( e) => e.getAttribute( 'href' ) );
  test.true( _.strEnds( got, '/index.html' ) )

  test.case = 'Check input field value'
  var got = await app.client.$( '#input1' ).then( ( e ) => e.getValue() );
  test.identical( got, '123' )

  test.case = 'Change input field value and check it'
  await app.client.$( '#input1' ).then( ( e ) => e.setValue( '321' ) );
  var got = await app.client.$( '#input1' ).then( ( e ) => e.getValue() );
  test.identical( got, '321' )

  await app.stop();

  return null;
}

//

function consequenceFromExperiment( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetsOriginalPath, 'electron' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let mainPath = _.path.nativize( _.path.join( routinePath, 'main.js' ) );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : routinePath } })

  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ],
  })

  let ready = app.start();

  test.true( _.promiseIs( ready ) );

  ready.then( () => app.client.waitUntilTextExists( 'p', 'Hello world', 5000 ) )

  ready = _.Consequence.From( ready );

  ready.then( () => _.Consequence.From( app.client.$( '#input1' ).then( ( e ) => e.getValue() ) ) ) /* returns promiseLike object */

  ready.then( ( got ) =>
  {
    test.case = 'input field value expected, but not object';

    debugger;
    console.log( 'promiseIs:', _.promiseIs( got ) )
    console.log( 'promiseLike:', _.promiseLike( got ) )
    console.log( 'typeof:', typeof got )
    console.log( 'has then routine:', _.routineIs( got.then ) )
    console.log( 'has catch routine:', _.routineIs( got.catch ) )

    test.identical( got, '123' )
    return got;
  })

  ready.then( () => _.Consequence.From( app.stop() ) )

  return ready;
}

consequenceFromExperiment.experimental = 1;

//

function chaining( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetsOriginalPath, 'electron' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let mainPath = _.path.nativize( _.path.join( routinePath, 'main.js' ) );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : routinePath } })

  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ]
  })

  let ready = app.start()

  .then( () => app.client.waitUntilTextExists( 'p', 'Hello world', 5000 ) )

  //select command is chained with .getText

  .then( () => app.client.$( '.class1 p' ).then( ( e ) => e.getText() ))

  .then( ( text ) =>
  {
    test.identical( text, 'Text1' );
    return app.stop();
  })

  return _.Consequence.From( ready );
}

//

function waitForVisibleInViewportThrowing( test )
{
  let self = this;
  let a = self.assetFor( test, 'spectron' );
  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = ''
    return null;
  })

  a.appStartNonThrowing({ execPath : `Spectron.test.s r:waitForVisibleInViewportThrowing v:7` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    test.identical( _.strCount( got.output, 'Waiting for selector "p" failed: timeout 1ms exceeded' ), 1 );
    test.identical( _.strCount( got.output, `had zombie process` ), 0 );
    return null;
  })

  /* - */

  return a.ready;
}

//

function processWatchingOnSpectronZombie( test )
{
  let self = this;
  let a = self.assetFor( test, 'spectron' );
  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = ''
    return null;
  })

  a.appStartNonThrowing({ execPath : `Spectron.test.s r:routineTimeOut ` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 2 error' ), 2 );
    test.identical( _.strCount( got.output, `had zombie process` ), 1 );
    return null;
  })

  a.appStartNonThrowing({ execPath : `Spectron.test.s r:spectronTimeOut ` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 2 error' ), 2 );
    test.identical( _.strCount( got.output, `had zombie process` ), 1 );
    return null;
  })

  a.appStartNonThrowing({ execPath : `Spectron.test.s r:errorInTest ` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 2 error' ), 2 );
    test.identical( _.strCount( got.output, `had zombie process` ), 1 );
    return null;
  })

  a.appStartNonThrowing({ execPath : `Spectron.test.s r:clientContinuesToWorkAfterTest ` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 1 error' ), 2 );
    test.identical( _.strCount( got.output, `had zombie process` ), 1 );
    return null;
  })

  /* - */

  return a.ready;
}

// --
// suite
// --

let Self =
{

  name : 'Tools.Tester.Electron',
  silencing : 0,
  enabled : 1,

  onSuiteBegin,
  onSuiteEnd,
  routineTimeOut : 300000,

  context :
  {
    assetFor,

    suiteTempPath : null,
    assetsOriginalPath : null,
    appStartNonThrowing : null,
    toolsPath : null,
    spectronPath : null,
    electronPath : null
  },

  tests :
  {
    html,
    htmlAwait,
    consequenceFromExperiment,
    chaining,
    waitForVisibleInViewportThrowing,

    processWatchingOnSpectronZombie
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
