## Abstract
## Spectron
```javascript
```
[Full sample](../../../sample/spectron/CDP.test.s)

## Puppeteer

```javascript
  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  test.case = 'create cdp session and navigate to url'
  let client = await page.target().createCDPSession();
  await client.send( 'Page.enable' );
  await client.send( 'Page.navigate', { url : 'https://www.npmjs.com/' });
  await page.waitForNavigation();
  let url = await page.url();
  test.identical( url, 'https://www.npmjs.com/' )
  await client.detach();
  await browser.close();
```
[Full sample](../../../sample/puppeteer/CDP.test.s)
