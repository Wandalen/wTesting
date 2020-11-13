( function _ElementProperties_test_s_( ) {

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

//

async function domElementProperties( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let indexHtmlPath = _.path.join( routinePath, 'index.html' );

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  //Create browser and new page instance
  let browser = await Puppeteer.launch();
  let page = await browser.newPage();

  //Open test page
  let path = 'file:///' + _.path.nativize( indexHtmlPath );
  await page.goto( path, { waitUntil : 'load' } );

  //innerText
  var text = await page.$eval( 'p', ( e ) => e.innerText )
  test.identical( text, 'Hello world' );

  //outerHtml
  var html = await page.$eval( 'p', ( e ) => e.outerHTML )
  test.identical( html, '<p>Hello world</p>' );

  //Elements position on page
  var element = await page.$( 'p' );
  var location = await element.boundingBox();
  test.gt( location.x, 0 );
  test.gt( location.y, 0 );

  //Close browser
  await browser.close();

  return null;
}

// --
// suite
// --

let Self =
{

  name : 'Visual.Puppeteer.ElementProperties',



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
    domElementProperties
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
