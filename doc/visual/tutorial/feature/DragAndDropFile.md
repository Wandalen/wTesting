## Drag and drop
How to drag file from system into to browser window.

## Spectron

```javascript
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
```

[Full sample](../../../../sample/spectron/DragAndDropFile.test.s)

## Puppeteer

```javascript

  let browser = await Puppeteer.launch({ headless : false });
  let page = await browser.newPage();
  
  await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ), { waitUntil : 'load' } );
  
  var fileInputId = 'fileInput';
  var dropZoneSelector = '#dropzone';
  
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
  
```
[Full sample](../../../../sample/puppeteer/DragAndDropFile.test.s)


[Back to content](../Comparison.md)
