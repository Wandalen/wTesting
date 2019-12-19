## Wait until element will be visible

How to wait until element(s) with specific selector will be visible on page.

## Puppeteer

```javascript
let browser = await Puppeteer.launch({ headless : true });
let page = await browser.newPage();

await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ), { waitUntil : 'load' } );
await page.waitForSelector( 'p', { visible : true } );
var text = await page.$eval( 'p', ( e ) => e.innerText )
test.identical( text, 'Hello world' );
await browser.close();
```
[Full sample](../../../../sample/puppeteer/WaitForVisible.test.s)

## Spectron
```javascript
let app = new Spectron.Application
({
  path : ElectronPath,
  args : [ mainPath ]
})

await app.start()
await app.client.waitForVisible( 'p', 5000 )

var got = await app.client.$( 'p' ).isVisible();
test.identical( got, true );

await app.stop();
```

[Full sample](../../../../sample/spectron/WaitForVisible.test.s)

[Back to content](../Comparison.md)
