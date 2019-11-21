## How to register condition and wait it will be fulfilled with a truthy value

This tutorial shows how to wait until text property of a DOM element will be changed.

Please check out [previous tutorial](FirstPuppeteerTest.md) if you don't have test suite prepared.

## Write a test routine

Add following test routine to your suite:

```javascript
async function waitForTextChange( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let indexHtmlPath = _.path.join( routinePath, 'index.html' );

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  let browser = await Puppeteer.launch({ headless : true });
  let page = await browser.newPage();

  await page.goto( 'file:///' + _.path.nativize( indexHtmlPath ), { waitUntil : 'load' } );

  //Change text property after delay
  _.timeOut( 1500, () => 
  {
    page.$eval( 'p', ( e ) => 
    {  
      e.innerText = 'Hello from test'
    })
  })

  //Wait until text will be changed
  await page.waitFor( () => 
  {
    return document.querySelector( 'p' ).innerText === 'Hello from test';
  })

  //Check text property
  var got = await page.$eval( 'p', ( e ) => e.innerText )
  test.identical( got, 'Hello from test' );

  await browser.close();

  return null;
}
```

## Register and run test routine

Add test routine to `tests` map and the end of test suite file.

To run test routine enter:
```
node Spectron.test.ss r:waitForTextChange v:5
```

[Full sample](../../../sample/spectron/WaitForCondition.test.s)

[Back to content](../README.md#Tutorials)





