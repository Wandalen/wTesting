## Request and Response API
How to send and intercept requests using Puppeteer.

[Puppeteer Request](https://pptr.dev/#?product=Puppeteer&version=v2.0.0&show=api-class-request)

[Puppeteer Response](https://pptr.dev/#?product=Puppeteer&version=v2.0.0&show=api-class-response)

## Spectron
```javascript
  
```
[Full sample](../../../../sample/spectron/RequestResponse.test.s)

## Puppeteer

```javascript
  let browser = await Puppeteer.launch({ headless : true, args : [ '--disable-web-security' ] });
  let page = await browser.newPage();

  await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ), { waitUntil : 'load' } );

  page.on( 'requestfinished', async ( request ) =>
  {
    let response = request.response();
    let data = await response.json();
    test.identical( data.name, 'wTesting' );
  })

  await page.waitFor( 5000 );
  await browser.close();
```
[Full sample](../../../../sample/puppeteer/RequestResponse.test.s)


[Back to content](../Comparison.md)
