## Page API
Page API allows to:
- Open url
- Inject script into page
- Register event handler
- Find element
- Access browser context
- Navigate in history
- Make screenshot
- Wait for defined condition

This sample shows how to get page HTML code. 

[Puppeteer Page API](https://pptr.dev/#?product=Puppeteer&version=v2.0.0&show=api-class-page)

## Spectron
[Spectron client API](https://webdriver.io/docs/api.html)

```javascript
  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ]
  })

  await app.start()
  await app.client.waitUntilTextExists( 'p','Hello world', 5000 )

  test.case = 'Check Page html'
  var html = await app.client.execute( () => document.documentElement.outerHTML );
  test.true( _.strHas( html.value, '<p>Hello world</p>' ) );

  await app.stop();
```
[Full sample](../../../../sample/spectron/Page.test.s)

## Puppeteer

```javascript
  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ) );

  test.case = 'Get page html'
  var html = await page.content();
  test.true( _.strHas( html, '<p>Hello world</p>' ) );

  await browser.close();
```
[Full sample](../../../../sample/puppeteer/Page.test.s)


[Back to content](../Comparison.md)
