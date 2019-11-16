## Abstract
Allows to simulate other device to test how page will look on device with different browser,screen size, etc.

[Puppeteer emulate method](https://pptr.dev/#?product=Puppeteer&version=v2.0.0&show=api-pageemulateoptions)

## Spectron
```javascript
  
```
[Full sample](../../../sample/spectron/Device.test.s)

## Puppeteer

```javascript
  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  test.case = 'emulate iphone and check userAgent'
  await page.emulate( Puppeteer.devices[ 'iPhone 6' ] );
  let agent = await page.evaluate( () => window.navigator.userAgent )
  test.is( _.strHas( agent, 'iPhone' ) )

  await browser.close();
```
[Full sample](../../../sample/puppeteer/Device.test.s)
