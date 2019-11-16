## Abstract
## Spectron
```javascript

```
[Full sample](../../../sample/spectron/FunctionExposing.test.s)

## Puppeteer

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
[Full sample](../../../sample/puppeteer/FunctionExposing.test.s)
