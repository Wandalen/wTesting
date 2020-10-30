( function _DragAndDropFile_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( 'wTools' );
  _.include( 'wTesting' );

  var ElectronPath = require( 'electron' );
  var Spectron = require( 'spectron' );

}

let _global = _global_;
let _ = _testerGlobal_.wTools;

// --
// context
// --

function onSuiteBegin()
{
  let self = this;
  self.tempDir = _.path.tempOpen( _.path.join( __dirname, '../..'  ), 'Tester' );
  self.assetDirPath = _.path.join( __dirname, 'asset' );
}

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.tempDir, 'Tester' ) )
  _.path.tempClose( self.tempDir );
}

// --
// tests
// --

//

async function dragAndDropFile( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  /* Fails with `read ECONNRESET` error on high load
    Opening html file from electron app helps to solve the problem
  */
  let mainFilePath = _.path.nativize( _.path.join( routinePath, 'dragAndDrop.ss' ) );

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainFilePath ]
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
  var element = await app.client.$(`#${fileInputId}`);
  await element.setValue( file )
  let result = await app.client.execute( () => window.dropFiles );
  test.identical( result, [ _.path.name({ path : __filename, full : 1 }) ] )
  
  await app.stop();

  return null;
}

//

async function dragAndDropFileWithHelper( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let mainFilePath = _.path.nativize( _.path.join( routinePath, 'dragAndDrop.ss' ) );

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainFilePath ]
  })

  await app.start()
  await app.client.waitUntilTextExists( 'p', 'Drag & Drop file', 5000 )
  
  await _.test.fileDrop
  ({
    filePath : __filename,
    targetSelector : '#dropzone',
    fileInputId : 'fileInput',
    page : app.client,
    library : 'spectron'
  })
  
  let result = await app.client.execute( () => window.dropFiles );
  test.identical( result, [ _.path.name({ path : __filename, full : 1 }) ] )
  
  await app.stop();

  return null;
}

// --
// suite
// --

let Self =
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
    dragAndDropFileWithHelper
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
