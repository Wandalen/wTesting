## Dialog API
How to interact with dialog created by [alert](https://developer.mozilla.org/en-US/docs/Web/API/Window/alert).

## Spectron
```javascript
  
```
[Full sample](../../../../sample/spectron/Dialog.test.s)

## Puppeteer

[Puppeteer Dialog API](https://pptr.dev/#?product=Puppeteer&version=v2.0.0&show=api-class-dialog)

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
[Full sample](../../../../sample/puppeteer/Dialog.test.s)


[Back to content](../Comparison.md)
