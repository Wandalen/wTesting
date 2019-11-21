## How to use Spectron to inject a snippet of JavaScript into the page for execution in browser context.

Please check out [previous tutorial](FirstPuppeteerTest.md) if you don't have test suite prepared.

## Write a test routine

Add following test routine to your suite:

```javascript
async function injectScript( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let indexHtmlPath = _.path.join( routinePath, 'index.html' );

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })
  
  // Create browser instance and new page
  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  // Open html file and wait until page loads
  await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ), { waitUntil : 'load' } );

  //Inject script that changes text property of DOM element and return its value
  let got = await page.evaluate( () => 
  {
    let element = document.querySelector( 'p' );
    element.innerText = 'Hello from test';
    return element.innerText;
  })
  test.identical( got, 'Hello from test' );

  // Close the browser
  await browser.close();

  return null;
}
```

## Register and run test routine

Add test routine to `tests` map and the end of test suite file.

To run test routine enter:
```
node Puppeteer.test.ss r:injectScript v:5
```

[Full sample](../../../sample/puppeteer/InjectScript.test.s)

[Back to content](../README.md#Tutorials)





