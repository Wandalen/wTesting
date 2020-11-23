( function _Puppeteer_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( 'wTools' );
  _.include( 'wTesting' );

  var Puppeteer = require( 'puppeteer' );
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

//

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.tempDir, 'Tester' ) )
  _.path.tempClose( self.tempDir );
}

// --
// tests
// --

function htmlThenable( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let indexHtmlPath = _.path.join( routinePath, 'index.html' );
  let ready = new _.Consequence().take( null )

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  let page = null;
  let browser = null;

  setup();

  ready.then( () =>
  {
    let path = 'file:///' + _.path.nativize( indexHtmlPath );
    return page.goto( path, { waitUntil : 'load' } )
  })

  ready.then( () =>
  {
    return page.$eval( '.class1 p', ( e ) => e.innerText )
    .then( ( got ) =>
    {
      test.identical( got, 'Text1' )
      return got;
    })
  })

  ready.then( () =>
  {
    return page.$eval( '.class1 a', ( e ) => e.href )
    .then( ( got ) =>
    {
      test.true( _.strEnds( got,'index.html' ) );
      return got;
    })
  })

  ready.then( () =>
  {
    return page.$eval( '#input1', ( e ) => e.value )
    .then( ( got ) =>
    {
      test.identical( got, '123' )
      return got;
    })
  })

  ready.then( () =>
  {
    return browser.close()
    .then( () => null )
  });

  return ready;

  //

  function setup()
  {
    let ready = Puppeteer.launch({ headless : true })
    .then( ( got ) =>
    {
      browser = got;
      return browser.newPage()
    })
    .then( ( got ) =>
    {
      page = got;
      return got;
    })
    ready = _.Consequence.From( ready );
    return ready.deasync();
  }
}

// --
// suite
// --

let Self =
{

  name : 'Visual.Puppeteer.Html.Thenable',



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
    htmlThenable,
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
