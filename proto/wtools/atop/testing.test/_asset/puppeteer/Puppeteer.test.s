( function _Spectron_test_s_()
{

'use strict';

require( 'wTesting' );
var Puppeteer = require( 'puppeteer' );

let _ = _realGlobal_._globals_.testing.wTools

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

  _.time.out( 5000 ).deasync();

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

  await page.waitForFunction( () => document.querySelector( 'p' ).innerText === 'Hello worldd', { timeout : 1000 } );

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

//

async function waitForVisibleInViewportThrowing( test )
{
  let self = this;
  let indexHtmlPath = _.path.join( __dirname, 'index.html' );
  let browser, err;

  try
  {
    browser = await Puppeteer.launch({ headless : true });
    let page = await browser.newPage();

    await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ), { waitUntil : 'load' } );

    await _.test.waitForVisibleInViewport
    ({
      targetSelector : 'p',
      timeOut : 1,
      page,
      library : 'puppeteer'
    });
  }
  catch( _err )
  {
    _.errLogOnce( _err );
    err = _err;
    if( browser )
    await browser.close();
  }
  finally
  {
    test.true( _.errIs( err ) );
    test.true( !browser.isConnected() )
  }

}

// --
// suite
// --

const Proto =
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
    clientContinuesToWorkAfterTest,
    waitForVisibleInViewportThrowing
  }

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
