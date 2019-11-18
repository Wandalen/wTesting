## Input API
Testing frameworks allow simulation of keyboard,mouse,touchscreen input. This sample shows how to simulate keyboard input to DOM element.

## Spectron
[Spectron client API](https://webdriver.io/docs/api.html)

```javascript
  let app = new Spectron.Application
    ({
      path : ElectronPath,
      args : [ mainPath ]
    })

    await app.start()
    await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )

    test.case = 'keyboard';
    await app.client.$( '#input1' ).setValue( '0123' );
    var got = await app.client.getValue( '#input1' );
    test.identical( got, '0123' );

    await app.stop();
```
[Full sample](../../../../sample/spectron/Input.test.s)

## Puppeteer
[Puppeteer Keyboard API](https://pptr.dev/#?product=Puppeteer&version=v2.0.0&show=api-class-keyboard)

[Puppeteer Mouse API](https://pptr.dev/#?product=Puppeteer&version=v2.0.0&show=api-class-mouse)

[Puppeteer Touchscreen API](https://pptr.dev/#?product=Puppeteer&version=v2.0.0&show=api-class-touchscreen)

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
[Full sample](../../../../sample/puppeteer/Input.test.s)


[Back to content](../Comparison.md)
