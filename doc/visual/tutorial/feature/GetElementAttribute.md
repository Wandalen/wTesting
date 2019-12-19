## Get element(s) attribute value
How to get attribute value from multiple elements.

## Spectron
```javascript
let app = new Spectron.Application
({
  path : ElectronPath,
  args : [ indexPath ]
})

await app.start()
await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )

var got = await app.client.getAttribute( 'div[attr]', 'attr' );
test.identical( got, [ '1', '2', '3' ] )

await app.stop();
```
[Full sample](../../../../sample/spectron/GetAttributes.test.s)

## Puppeteer

```javascript
let browser = await Puppeteer.launch({ headless : false });
let page = await browser.newPage();

await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ), { waitUntil : 'load' } );

var got = await page.$$eval( 'div[attr]', ( elements ) => elements.map( e => e.getAttribute( 'attr') ) );
test.identical( got, [ '1', '2', '3' ] );

await browser.close();
  
```
[Full sample](../../../../sample/puppeteer/GetAttributes.test.s)


[Back to content](../Comparison.md)
