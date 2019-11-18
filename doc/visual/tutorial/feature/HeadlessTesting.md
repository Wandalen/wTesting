## Headless testing
How to run visual testing in headless mode. Headless mode is needed to run test on 
continuous integration services.

## Spectron
For Spectron headless testing is not supported out of the box, but Electron app can be executed without window. Take a look on [main script](../../../../sample/spectron/asset/headless.js) file used in that sample.

```javascript
  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ]
  })

  await app.start()
  await app.client.waitUntilTextExists( 'p','Hello world', 5000 )
  
  var title = await app.client.getTitle();
  test.identical( title, 'Test' );
    
  await app.stop();
```
[Full sample](../../../../sample/spectron/Headless.test.s)

## Puppeteer

```javascript
  test.case = 'find npm package in headless mode'
  var browser = await Puppeteer.launch({ headless : true });
  var page = await browser.newPage();
  await page.goto( 'https://www.npmjs.com', { waitUntil : 'load' } );
  await page.focus( 'input[type="search"' );
  await page.keyboard.type( 'wTesting', { delay : 200 } );
  await page.keyboard.press( 'Enter' );
  await page.waitForNavigation();
  var url = await page.url();
  test.identical( url, 'https://www.npmjs.com/package/wTesting' );
  await browser.close();
```
[Full sample](../../../../sample/puppeteer/Headless.test.s)


[Back to content](../Comparison.md)
