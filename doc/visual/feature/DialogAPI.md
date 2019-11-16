## Abstract
## Spectron
```javascript
  
```
[Full sample](../../../sample/spectron/Dialog.test.s)

## Puppeteer

```javascript
  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  page.on( 'dialog', async dialog =>
  {
    let message = dialog.message();
    test.identical( message, 'Alert message' )
    await dialog.dismiss();
  })

  page.evaluate( () => alert( 'Alert message' ) );

  await page.waitFor( 1000 );
  await browser.close();
```
[Full sample](../../../sample/puppeteer/Dialog.test.s)
