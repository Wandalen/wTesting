## Access to raw Chrome Devtools Protocol
How to establish raw communication with [Chrome DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/). Open url by sending `Page.navigate` command.

## Spectron

>Does not work on Spectron v7.0.0

Spectron allows to access Chrome DevTools Protocol by using [Electron Debugger API](https://electronjs.org/docs/api/debugger#debuggersendcommandmethod-commandparams-callback).

```javascript
```
[Full sample](../../../../sample/spectron/CDP.test.s)

## Puppeteer

[Puppeteer CDP API](https://pptr.dev/#?product=Puppeteer&version=v2.0.0&show=api-class-cdpsession)

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
[Full sample](../../../../sample/puppeteer/CDP.test.s)


[Back to content](../Comparison.md)
