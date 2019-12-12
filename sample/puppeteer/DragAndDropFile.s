( function _DragAndDropFile_test_s_( ) {

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

async function fileDragAndDrop( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let indexHtmlPath = _.path.join( routinePath, 'fileDragAndDrop.html' );

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  let browser = await Puppeteer.launch({ headless : false });
  let page = await browser.newPage();
  
  var fileInputIdentifier = "fileInput";
  var dropZoneSelector = "#drop_zone";
  var filePath = __filename;
  
  await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ), { waitUntil : 'load' } );
  
  await page.evaluate((fileInputIdentifier, dropZoneSelector) => 
  {
    document.body.appendChild( Object.assign(
        document.createElement( "input" ),
        {
            id: fileInputIdentifier,
            type: "file",
            onchange: e => 
            {
              document.querySelector(dropZoneSelector).dispatchEvent(Object.assign(
                  new Event("drop"),
                  { dataTransfer: { files: e.target.files } }
              ));
            }
        }
    ));
  }, fileInputIdentifier, dropZoneSelector );

  const fileInput = await page.$(`#${fileInputIdentifier}`);
  await fileInput.uploadFile(filePath);
  
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
    fileDragAndDrop
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
