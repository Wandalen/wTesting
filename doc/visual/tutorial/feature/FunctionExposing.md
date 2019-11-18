## Function exposing
How to register user-defined function on window object and call it from the page.

## Puppeteer
[Puppeteer exposeFunction](https://pptr.dev/#?product=Puppeteer&version=v2.0.0&show=api-pageexposefunctionname-puppeteerfunction)

```javascript
  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();
  let os = require( 'os' );

  test.case = 'expose node js os.platform function'
  await page.exposeFunction( 'platformGet', () => os.platform() );
  let platform = await page.evaluate( () => window.platformGet() );
  test.identical( platform, os.platform() )

  await browser.close();
```
[Full sample](../../../../sample/puppeteer/FunctionExposing.test.s)


[Back to content](../Comparison.md)
