( function _Headless_test_s_( ) {

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

async function headless( test )
{
  test.case = 'find npm package in headless mode'
  var browser = await Puppeteer.launch({ headless : true });
  var page = await browser.newPage();
  await page.goto( 'https://www.npmjs.com', { waitUntil : 'load' } );
  await page.focus( 'input[type="search"' );
  await page.keyboard.type( 'wTesting', { delay : 200 } );
  await page.keyboard.press( 'Enter' );
  await page.waitForNavigation();
  var url = await page.url();
  test.identical( url, 'https://www.npmjs.com/package/wTesting' );
  await browser.close();

  return null;
}

//

async function nonHeadless( test )
{
  test.case = 'find npm package in non headless mode'
  var browser = await Puppeteer.launch({ headless : false });
  var page = await browser.newPage();
  await page.goto( 'https://www.npmjs.com', { waitUntil : 'load' } );
  await page.focus( 'input[type="search"' );
  await page.keyboard.type( 'wTesting', { delay : 200 } );
  await page.keyboard.press( 'Enter' );
  await page.waitForNavigation();
  var url = await page.url();
  test.identical( url, 'https://www.npmjs.com/package/wTesting' );
  await browser.close();

  return null;
}

// --
// suite
// --

let Self =
{

  name : 'Visual.Puppeteer.Headless',



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
    headless,
    nonHeadless
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
