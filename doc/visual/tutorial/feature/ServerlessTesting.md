## Opening the HTML page using local path without server

How to open HTML page from local drive.

## Spectron

```javascript
async function loadLocalHtmlFile( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let indexHtmlPath = _.path.nativize( _.path.join( routinePath, 'serverless/index.html' ) );

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ indexHtmlPath ]
  })
  await app.start()
  await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )

  var got = await app.client.execute( () => window.scriptLoaded )
  test.identical( got.value, true );
  
  var got = await app.client.getCssProperty( 'p', 'color' )
  test.identical( got.value, 'rgba(192,192,192,1)' );

  await app.stop();

  return null;
}
```

[Full sample](../../../../sample/spectron/LocalStorage.test.s)

## Puppeteer

```javascript
  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ), { waitUntil : 'load' } );
    
  test.case = 'script and style files are loaded'
  
  var got = await page.evaluate( () => window.scriptLoaded )
  test.identical( got, true );
  
  var got = await page.evaluate( () => 
  {
    let p = document.querySelector( 'p' );
    let styles = window.getComputedStyle( p );
    return styles.getPropertyValue( 'color' )
  })
  test.identical( got, 'rgb(192, 192, 192)' );
  
  await browser.close();
```

[Full sample](../../../../sample/puppeteer/LocalStorage.test.s)

[Back to content](../Comparison.md)
