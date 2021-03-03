( function _Screenshots_test_s_( ) {

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

  self.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..'  ), 'Tester' );
  self.assetDirPath = _.path.join( __dirname, 'asset' );
}

//

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.suiteTempPath, 'Tester' ) )
  _.path.tempClose( self.suiteTempPath );
}

// --
// tests
// --

async function screenshot( test )
{
  let context = this;
  let a = test.assetFor( false );

  a.fileProvider.dirMake( a.abs( '.' ) );

  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  test.case = 'go to npm and check url'
  page.goto( 'https://www.npmjs.com/' )
  await page.waitForNavigation();

  test.case = 'screenshot whole window'
  var screenshot = await page.screenshot();
  test.true( _.bufferNodeIs( screenshot ) )

  test.case = 'screenshot whole window and save to disk'
  var path = _.path.nativize( a.abs( 'screenshot.png' ) );
  await page.screenshot({ path });
  test.true( _.fileProvider.fileExists( path ) )

  test.case = 'screenshot element'
  var element = await page.$( '#search');
  var screenshot = await element.screenshot();
  test.true( _.bufferNodeIs( screenshot ) )

  await browser.close();

  return null;
}

// --
// suite
// --

var Self =
{

  name : 'Visual.Puppeteer.Screenshots',



  onSuiteBegin : onSuiteBegin,
  onSuiteEnd : onSuiteEnd,
  routineTimeOut : 300000,

  context :
  {
    suiteTempPath : null,
    assetDirPath : null,
  },

  tests :
  {
    screenshot
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
