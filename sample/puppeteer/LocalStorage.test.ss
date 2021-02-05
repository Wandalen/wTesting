( function _LocalStorage_test_s_( ) {

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

async function localStorage( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let indexHtmlPath = _.path.join( routinePath, 'index.html' );
  let userDataDirPath = _.path.nativize( _.path.join( routinePath, 'user-dir' ) );
  indexHtmlPath = _.path.nativize( indexHtmlPath );

  test.identical( 1,1 ); //https://github.com/puppeteer/puppeteer/issues/2538
  return null;

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  /* Use custom userDataDir to persist localStorage between launches */

  test.case = 'create new item'
  var browser = await Puppeteer.launch({ headless : true, userDataDir : userDataDirPath });
  var page = await browser.newPage();
  await page.goto( 'file:///' + indexHtmlPath, { waitUntil : 'load' } );
  var got = await page.evaluate( () =>
  {
    localStorage.setItem( 'itemKey', 'itemValue' );
    return localStorage.getItem( 'itemKey' );
  })
  test.identical( got, 'itemValue' );
  await browser.close();

  //

  test.case = 'reload browser and get item value'
  var browser = await Puppeteer.launch({ headless : true, userDataDir : userDataDirPath });
  var page = await browser.newPage();
  await page.goto( 'file:///' + indexHtmlPath, { waitUntil : 'load' } );
  var got = await page.evaluate( () =>
  {
    return localStorage.getItem( 'itemKey' );
  })
  test.identical( got, 'itemValue' );
  await browser.close();

  return null;
}

// --
// suite
// --

let Self =
{

  name : 'Visual.Puppeteer.LocalStorage',



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
    localStorage
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
