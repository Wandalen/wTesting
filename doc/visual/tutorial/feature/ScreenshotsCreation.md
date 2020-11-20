## Screenshots creation
How to create screenshow of whole page and selected DOM element.

## Spectron
[Spectron capturePage](https://github.com/electron-userland/spectron#capturepage)

```javascript
  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ]
  })

  await app.start()
  await app.client.waitUntilTextExists( 'p','Hello world', 5000 )
  
  var screenshot = await app.browserWindow.capturePage();
  test.true( _.bufferNodeIs( screenshot ) )

  await app.stop();
```

[Full sample](../../../../sample/spectron/Screenshots.test.s)

## Puppeteer
[Puppeteer screenshot](https://pptr.dev/#?product=Puppeteer&version=v2.0.0&show=api-pagescreenshotoptions)

```javascript
  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  test.case = 'go to npm and check url'
  page.goto( 'https://www.npmjs.com/' )
  await page.waitForNavigation();
    
  test.case = 'screenshot whole window'
  var screenshot = await page.screenshot();
  test.true( _.bufferNodeIs( screenshot ) )
  
  test.case = 'screenshot whole window and save to disk'
  var path = _.path.nativize( _.path.join( __dirname, 'screenshot.png' ) );
  await page.screenshot({ path });
  test.true( _.fileProvider.fileExists( path ) )
  
  test.case = 'screenshot element'
  var element = await page.$( '#search');
  var screenshot = await element.screenshot();
  test.true( _.bufferNodeIs( screenshot ) )

  await browser.close();
```

[Full sample](../../../../sample/puppeteer/Screenshots.test.s)


[Back to content](../Comparison.md)
