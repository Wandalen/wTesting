## Abstract
## Spectron
```javascript
  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ]
  })

  await app.start()
  await app.client.waitUntilTextExists( 'p','Hello world', 5000 )

  test.case = 'check browser window size'
  var size = await app.browserWindow.getSize();
  test.identical( size, [ 800,600 ] )

  test.case = 'check userAgent'
  var userAgent = await app.webContents.getUserAgent();
  test.is( _.strHas( userAgent, 'Electron' ) );

  await app.stop();
```
[Full sample](../../../sample/spectron/Browser.test.s)

## Puppeteer

```javascript
  let browser = await Puppeteer.launch({ headless : true });

  var version = await browser.version();
  test.is( _.strHas( version, '79.0' ) );

  var agent = await browser.userAgent();
  test.is( _.strHas( agent, '79.0' ) );

  await browser.close();
```
[Full sample](../../../sample/puppeteer/Browser.test.s)
