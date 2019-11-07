( function _Puppeteer_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../Tools.s' );

  require( '../tester/MainTop.s' );
  _.include( 'wFiles' );

  var puppeteer = require( 'puppeteer' );
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
  let originalDirPath = _.path.join( self.assetDirPath, 'puppeteer' );
  let routinePath = _.path.join( self.tempDir, test.name );
  let indexHtmlPath = _.path.join( routinePath, 'index.html' );
  let ready = new _.Consequence().take( null )

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : routinePath } })

  let page = createPage();

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
      test.is( _.strEnds( got,'index.html' ) );
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
    return page.$eval( '#input1', ( e ) => { e.value = '321'; return e.value })
    .then( ( got ) =>
    {
      test.identical( got, '321' )
      return got;
    })
  })

  return ready;

  //

  function createPage()
  {
    let ready = puppeteer.launch({ headless : false })
    .then( ( browser ) => browser.newPage() )
    ready = _.Consequence.From( ready );
    return ready.deasync();
  }
}


// --
// suite
// --

var Self =
{

  name : 'Tools.atop.Tester.Puppeteer',
  silencing : 0,
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
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
