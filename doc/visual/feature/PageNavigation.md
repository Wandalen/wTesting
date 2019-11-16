## Abstract
## Spectron
```javascript
  
```
[Full sample](../../../sample/spectron/Navigation.test.s)

## Puppeteer

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
[Full sample](../../../sample/puppeteer/Navigation.test.s)
