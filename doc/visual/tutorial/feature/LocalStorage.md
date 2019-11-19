## LocalStorage support
How to set and get localStorage item using Spectron and Puppeteer.
Samples are using custom user data directory to cache localStorage.

## Spectron
```javascript
  
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
