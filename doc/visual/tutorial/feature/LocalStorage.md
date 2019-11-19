## LocalStorage support
How to set and get localStorage item using Spectron and Puppeteer.
Samples are using custom user data directory to persist localStorage between launches of the browser.

## Spectron
[Spectron localStorage API](http://v4.webdriver.io/api/protocol/localStorage.html)

```javascript
  test.case = 'create new item'
  var app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ],
    chromeDriverArgs: [ `--user-data-dir=${userDataDirPath}` ]
  })
  await app.start()
  await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )
  await app.client.localStorage( 'POST', { key : 'itemKey', value : 'itemValue' })
  await app.stop();
  
  //
  
  test.case = 'open browser again and get item value'
  var app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ],
    chromeDriverArgs: [ `--user-data-dir=${userDataDirPath}` ]
  })
  await app.start()
  await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )
  var got = await app.client.localStorage( 'GET', 'itemKey' );
  test.identical( got.value, 'itemValue' );
  await app.stop();
```

[Full sample](../../../../sample/spectron/LocalStorage.test.s)

## Puppeteer

```javascript
  test.case = 'create new item'
  var browser = await Puppeteer.launch({ headless : true, userDataDir : userDataDirPath });
  var page = await browser.newPage();
  await page.goto( 'file:///' + indexHtmlPath, { waitUntil : 'load' } );
  var got = await page.evaluate( () => 
  { 
    localStorage.setItem( 'itemKey', 'itemValue' );
    return localStorage.getItem( 'itemKey' );
  })
  test.identical( got, 'itemValue' );
  await browser.close();
  
  //
  
  test.case = 'reload browser and get item value'
  var browser = await Puppeteer.launch({ headless : true, userDataDir : userDataDirPath });
  var page = await browser.newPage();
  await page.goto( 'file:///' + indexHtmlPath, { waitUntil : 'load' } );
  var got = await page.evaluate( () => 
  { 
    return localStorage.getItem( 'itemKey' );
  })
  test.identical( got, 'itemValue' );
  await browser.close();
```

[Full sample](../../../../sample/puppeteer/LocalStorage.test.s)


[Back to content](../Comparison.md)
