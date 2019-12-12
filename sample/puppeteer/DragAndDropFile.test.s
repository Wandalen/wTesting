( function _DragAndDropFile_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( 'wTools' );
  require( '../..' );
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

async function fileDragAndDrop( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let indexHtmlPath = _.path.join( routinePath, 'fileDragAndDrop.html' );

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  let browser = await Puppeteer.launch({ headless : false });
  let page = await browser.newPage();
  
  var fileInputId = 'fileInput';
  var dropZoneSelector = '#dropzone';
  
  await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ), { waitUntil : 'load' } );
  
  await page.evaluate(( fileInputId, dropZoneSelector) => 
  { 
    let input = document.createElement( 'input' );
    input.id = fileInputId,
    input.type = 'file'
    input.onchange = ( e ) => 
    { 
      let event = new Event( 'drop' );
      Object.assign( event, { dataTransfer: { files: e.target.files } } )
      document.querySelector( dropZoneSelector ).dispatchEvent( event );
    }
    document.body.appendChild( input );
  
  }, fileInputId, dropZoneSelector );

  const fileInput = await page.$(`#${fileInputId}`);
  await fileInput.uploadFile( __filename );
  let result = await page.evaluate( () => window.dropFiles );
  test.identical( result, [ _.path.name({ path : __filename, full : 1 }) ] )
  await browser.close();

  return null;
}

//

async function fileDragAndDrop2( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let indexHtmlPath = _.path.join( routinePath, 'fileDragAndDrop.html' );

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  let browser = await Puppeteer.launch({ headless : false });
  let page = await browser.newPage();
  
  await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ), { waitUntil : 'load' } );
  
  await _.test.fileDrop
  ({
    filePath : [ __filename ],
    targetSelector : '#dropzone',
    fileInputId : 'fileInput',
    page : page,
    library : 'puppeteer'
  })
  let result = await page.evaluate( () => window.dropFiles );
  test.identical( result, [ _.path.name({ path : __filename, full : 1 }) ] )
  await browser.close();

  return null;
}

// --
// suite
// --

var Self =
{

  name : 'Visual.Puppeteer.DragAndDropFile',
  
  

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
    fileDragAndDrop,
    fileDragAndDrop2
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
