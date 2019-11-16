## Abstract
## Spectron
```javascript
 
```
[Full sample](../../../sample/spectron/Input.test.s)

## Puppeteer

```javascript
  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ), { waitUntil : 'load' } );

  test.case = 'keyboard';
  await page.focus( '#input1' );
  await page.keyboard.type( '0' );
  var got = await page.$eval( '#input1', ( e ) => e.value );
  test.identical( got, '0123' );

  await browser.close();
```
[Full sample](../../../sample/puppeteer/Input.test.s)
