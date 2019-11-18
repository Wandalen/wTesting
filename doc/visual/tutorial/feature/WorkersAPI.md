## Workerks API
How to get list of available workers and inject js script to execute from worker's context.

## Spectron
```javascript
  
```
[Full sample](../../../../sample/spectron/Worker.test.s)

## Puppeteer

[Worker clas](https://pptr.dev/#?product=Puppeteer&version=v2.0.0&show=api-class-worker)

```javascript
  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ), { waitUntil : 'load' } );

  page.on( 'workercreated', async () =>
  {
    let workers = await page.workers();

    test.case = 'check number of workers';
    test.identical( workers.length, 1 );

    test.case = 'execute code from worker context and check result';
    let worker = workers[ 0 ];
    await worker.evaluate( () => { postMessage( 123 ) });
    let workerMessages = await page.evaluate( () => window.workerMessages );
    test.identical( workerMessages, [ 123 ] );
  })

  await page.waitFor( 1000 );

  await browser.close();
```
[Full sample](../../../../sample/puppeteer/Worker.test.s)


[Back to content](../Comparison.md)
