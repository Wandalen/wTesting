## How to find DOM element on page and access it properties using Puppeteer

Please check out [previous tutorial](FirstPuppeteerTest.md) if you don't have test suite prepared.

## Write a test routine
Add following test routine to your suite:

```javascript
async function domElementProperties( test )
{
  let self = this;
  
  //Prepare path to test page
  let indexHtmlPath = _.path.join( routinePath, 'index.html' );

  //Create browser and new page instance
  let browser = await Puppeteer.launch();
  let page = await browser.newPage();
  
  //Open test page
  let path = 'file:///' + _.path.nativize( indexHtmlPath );
  await page.goto( path, { waitUntil : 'load' } ); )
  
  //innerText
  var text = await page.$eval( 'p', ( e ) => e.innerText )
  test.identical( text, 'Hello world' );
  
  //outerHtml 
  var html = await page.$eval( 'p', ( e ) => e.outerHTML )
  test.identical( html, '<p>Hello world</p>' );
  
  //Elements position on page
  var element = await page.$( 'p' );
  var location = await element.boundingBox();
  test.gt( location.x, 0 );
  test.gt( location.y, 0 );

  //Close browser
  await browser.close();
  
  return null;
}
```

## Register and run test routine

Add test routine to `tests` map. It should look like:
```javascript
tests :
{ 
  trivial,
  domElementProperties
}
```

To run test routine enter:
```
node Puppeteer.test.ss r:domElementProperties v:5
```

[Full sample](../../../sample/puppeteer/ElementProperties.test.s)

[Back to content](../README.md#Tutorials)





