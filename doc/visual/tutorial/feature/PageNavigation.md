## Page navigation
How to move forward and backward in page history.

## Spectron
[Spectron Navigation methods](https://webdriver.io/docs/api/webdriver.html#navigateto)

```javascript
  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ]
  })

  await app.start()
  await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )

  await app.client.url( 'https://www.npmjs.com/' );
  var url = await app.client.getUrl();
  test.identical( url,'https://www.npmjs.com/' );
  
  await app.client.url( 'https://www.npmjs.com/wTesting' );
  var url = await app.client.getUrl();
  test.identical( url,'https://www.npmjs.com/package/wTesting' );
  
  await app.client.back();
  var url = await app.client.getUrl();
  test.identical( url,'https://www.npmjs.com/' );
  
  await app.client.forward();
  var url = await app.client.getUrl();
  test.identical( url,'https://www.npmjs.com/package/wTesting' );
  
  await app.stop();
```
[Full sample](../../../../sample/spectron/Navigation.test.s)

## Puppeteer
[Puppeteer Navigation methods](https://pptr.dev/#?product=Puppeteer&version=v2.0.0&show=api-pagegoforwardoptions)

```javascript
  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  test.case = 'go to npm and check url'
  page.goto( 'https://www.npmjs.com/' )
  await page.waitForNavigation();
  test.identical( page.url(), 'https://www.npmjs.com/' )

  test.case = 'go to package page and check url'
  await page.goto( 'https://www.npmjs.com/wTesting', { waitUntil : 'load' } )
  test.identical( page.url(), 'https://www.npmjs.com/package/wTesting' )

  test.case = 'go back to main page and check url'
  await page.goBack()
  test.identical( page.url(), 'https://www.npmjs.com/' )

  test.case = 'go forward to package page and check url'
  await page.goForward()
  test.identical( page.url(), 'https://www.npmjs.com/package/wTesting' )

  await browser.close();
```
[Full sample](../../../../sample/puppeteer/Navigation.test.s)


[Back to content](../Comparison.md)
