## Abstract
## Spectron
```javascript
  
```
[Full sample](../../../sample/spectron/Headless.test.s)

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
[Full sample](../../../sample/puppeteer/Headless.test.s)
