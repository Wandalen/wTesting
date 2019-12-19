( function _Spectron_test_s_( ) {

'use strict';

var _ = require( 'wTesting' );
var Puppeteer = require( 'puppeteer' );

var _ = _realGlobal_._testerGlobal_.wTools

// --
// tests
// --

//

async function routineTimeOut( test )
{
  let self = this;
  let indexHtmlPath = _.path.join( __dirname, 'index.html' );

  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ), { waitUntil : 'load' } );

  _.time.out( 5000 ).deasyncWait();

  await browser.close();

  return null;
}

routineTimeOut.timeOut = 3000;

//

async function puppeteerTimeOut( test )
{
  let self = this;
  let indexHtmlPath = _.path.join( __dirname, 'index.html' );

  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ), { waitUntil : 'load' } );

  await page.waitFor( () => document.querySelector( 'p' ).innerText === 'Hello worldd',{ timeout : 1000 } );

  await browser.close();

  return null;
}

//

async function errorInTest( test )
{
  let self = this;
  let indexHtmlPath = _.path.join( __dirname, 'index.html' );

  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ), { waitUntil : 'load' } );
  
  throw _.err( 'Test' );
}

//

async function clientContinuesToWorkAfterTest( test )
{
  let self = this;
  let indexHtmlPath = _.path.join( __dirname, 'index.html' );

  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ), { waitUntil : 'load' } );
}

// --
// suite
// --

var Self =
{

  name : 'Visual.Puppeteer.Zombie',
  silencing : 1,
  enabled : 1,

  routineTimeOut : 300000,

  context :
  {
  },

  tests :
  {
    routineTimeOut,
    puppeteerTimeOut,
    errorInTest,
    clientContinuesToWorkAfterTest
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
