( function _DragAndDropFile_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../..' );
  require( 'wFiles' )

  var ElectronPath = require( 'electron' );
  var Spectron = require( 'spectron' );

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

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.tempDir, 'Tester' ) )
  _.path.pathDirTempClose( self.tempDir );
}

// --
// tests
// --

//

async function dragAndDropFile( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let htmlFilePath = _.path.nativize( _.path.join( routinePath, 'fileDragAndDrop.html' ) );

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ htmlFilePath ]
  })

  await app.start()
  await app.client.waitUntilTextExists( 'p', 'Drag & Drop file', 5000 )

  var fileInputId = 'fileInput';
  var dropZoneSelector = '#dropzone';
  
  await app.client.execute(( fileInputId, dropZoneSelector) => 
  { 
    let input = document.createElement( 'input' );
    input.id = fileInputId,
    input.type = 'file';
    input.multiple = 'multiple';
    input.onchange = ( e ) => 
    { 
      let event = new Event( 'drop' );
      Object.assign( event, { dataTransfer: { files: e.target.files } } )
      document.querySelector( dropZoneSelector ).dispatchEvent( event );
    }
    document.body.appendChild( input );
  
  }, fileInputId, dropZoneSelector );
  
  let file = await app.client.uploadFile( __filename );
  await app.client.$(`#${fileInputId}`).setValue( file.value )
  let result = await app.client.execute( () => window.dropFiles );
  test.identical( result.value, [ _.path.name({ path : __filename, full : 1 }) ] )
  
  await app.stop();

  return null;
}

// --
// suite
// --

var Self =
{

  name : 'Visual.Spectron.DragAndDropFile',
  silencing : 1,
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
    dragAndDropFile,
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
