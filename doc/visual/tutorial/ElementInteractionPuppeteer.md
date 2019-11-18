## How to find DOM element on page and access it properties using Puppeteer

Please check out [previous tutorial](FirstPuppeteerTemplate.md) if you don't have test suite prepared.

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
  var location = await page.$( 'p' ).boundingBox();
  test.gt( location.x, 0 );
  test.gt( location.y, 0 );

  //Close browser
  await browser.close();
}
```

## Register and run test routine

Add test routine to `tests` map:
```javascript
tests :
{
  domElementProperties,
}
```

To run test routine enter:
```
node Puppeteer.test.ss r:domElementProperties vs:5
```

[Full sample](../../../sample/puppeteer/ElementProperties.test.s)

[Back to content](../README.md#Tutorials)





