( function _Puppeteer_test_s_( ) {

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

async function htmlAwait( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let indexHtmlPath = _.path.join( routinePath, 'index.html' );

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  let path = 'file:///' + _.path.nativize( indexHtmlPath );
  await page.goto( path, { waitUntil : 'load' } );

  test.case = 'Check element text'
  var got = await page.$eval( '.class1 p', ( e ) => e.innerText );
  test.identical( got, 'Text1' )

  test.case = 'Check href attribute'
  var got = await page.$eval( '.class1 a', ( e ) => e.href );
  test.true( _.strEnds( got,'index.html' ) );

  test.case = 'Check input field value'
  var got = await page.$eval( '#input1', ( e ) => e.value )
  test.identical( got, '123' )

  test.case = 'Change input field value and check it'
  await page.$eval( '#input1', ( e ) => { e.value = '321' })
  var got = await page.$eval( '#input1', ( e ) => e.value )
  test.identical( got, '321' );

  await browser.close();

  return null;
}

// --
// suite
// --

let Self =
{

  name : 'Visual.Puppeteer.Html.Await',



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
    htmlAwait
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
