( function _Dialog_test_s_( ) {

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

async function dialog( test )
{
  let self = this;

  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  page.on( 'dialog', async dialog =>
  {
    let message = dialog.message();
    test.identical( message, 'Alert message' )
    await dialog.dismiss();
  })

  page.evaluate( () => alert( 'Alert message' ) );

  await page.waitFor( 1000 );
  await browser.close();

  return null;
}

// --
// suite
// --

let Self =
{

  name : 'Visual.Puppeteer.Dialog',



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
    dialog
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
