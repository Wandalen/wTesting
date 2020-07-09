( function _Device_test_s_( ) {

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

async function device( test )
{
  let self = this;

  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  test.case = 'emulate iphone and check userAgent'
  await page.emulate( Puppeteer.devices[ 'iPhone 6' ] );
  let agent = await page.evaluate( () => window.navigator.userAgent )
  test.is( _.strHas( agent, 'iPhone' ) )

  await browser.close();

  return null;
}

// --
// suite
// --

var Self =
{

  name : 'Visual.Puppeteer.Device',



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
    device
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
