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

  test.case = 'Check element html'
  var got = await app.client.$( '.class1 p' ).getHTML();
  test.identical( got, '<p>Text1</p>' )

  await app.stop();
```
[Full sample](../../../sample/spectron/Element.test.s)

## Puppeteer

```javascript
  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ), { waitUntil : 'load' } );

  test.case = 'Check element html'
  var html = await page.$eval( '.class1 p', ( e ) => e.outerHTML );
  test.identical( html, '<p>Text1</p>' );

  await browser.close();
```
[Full sample](../../../sample/puppeteer/Element.test.s)
