## Abstract

Collection of routines that allows interaction with DOM element from page. For example:
- Find the element on the page
- Get/Set properties of the element
- Click,Drag,Focus,Input
- Evaluate script on the element
- Upload file

[Spectron Element API](https://webdriver.io/docs/api.html)

[Puppeteer Element API](https://pptr.dev/#?product=Puppeteer&version=v2.0.0&show=api-class-elementhandle)

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
