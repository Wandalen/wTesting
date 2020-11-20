## Device emulation
How to simulate other device.
Device simulation can be used to test how page looks on different browser,screen size,etc.

## Spectron
```javascript
  
```
[Full sample](../../../../sample/spectron/Device.test.s)

## Puppeteer

[Puppeteer emulate method](https://pptr.dev/#?product=Puppeteer&version=v2.0.0&show=api-pageemulateoptions)

```javascript
  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  test.case = 'emulate iphone and check userAgent'
  await page.emulate( Puppeteer.devices[ 'iPhone 6' ] );
  let agent = await page.evaluate( () => window.navigator.userAgent )
  test.true( _.strHas( agent, 'iPhone' ) )

  await browser.close();
```
[Full sample](../../../../sample/puppeteer/Device.test.s)


[Back to content](../Comparison.md)
