( function _Navigation_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( 'wTools' );
  _.include( 'wTesting' );
  _.include( 'wFiles' );

  var Puppeteer = require( 'puppeteer' );
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

//

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.tempDir, 'Tester' ) )
  _.path.pathDirTempClose( self.tempDir );
}

// --
// tests
// --

async function navigation( test )
{
  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  test.case = 'go to npm and check url'
  page.goto( 'https://www.npmjs.com/' )
  await page.waitForNavigation();
  test.identical( page.url(), 'https://www.npmjs.com/' )

  test.case = 'go to package page and check url'
  await page.goto( 'https://www.npmjs.com/wTesting', { waitUntil : 'load' } )
  test.identical( page.url(), 'https://www.npmjs.com/package/wTesting' )

  test.case = 'go back to main page and check url'
  await page.goBack()
  test.identical( page.url(), 'https://www.npmjs.com/' )

  test.case = 'go forward to package page and check url'
  await page.goForward()
  test.identical( page.url(), 'https://www.npmjs.com/package/wTesting' )

  await browser.close();

  return null;
}

// --
// suite
// --

var Self =
{

  name : 'Visual.Puppeteer.Navigation',
  
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
    navigation
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
