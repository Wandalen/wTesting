## How to launch simplest Puppeteer test

This tutorial shows how to prepare minimal test and launch it.

### Prepare asset

If you already have html page for test, plese move to the next section.

Create `index.html` file and fill it with test page code:

``` html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Test</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
  <p>Hello world</p>
</body>
</html>
```

### Write simple test suite

Create `Puppeteer.test.ss` and paste there:

``` javascript
( function _Puppeteer_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( 'wTools' );
  _.include( 'wTesting' );
  _.include( 'wFiles' );

  var Puppeteer = require( 'puppeteer' );

}

let _global = _global_;
let _ = _global_.wTools;

//

async function trivial( test )
{
  let self = this;
  let indexHtmlPath = _.path.join( routinePath, 'index.html' );

  let browser = await Puppeteer.launch();
  let page = await browser.newPage();
  
  let path = 'file:///' + _.path.nativize( indexHtmlPath );
  await page.goto( path, { waitUntil : 'load' } ); )
  
  var title = await page.title();
  test.identical( title, 'Test' );

  await browser.close();

  return null;
}

// --
// suite
// --

let Self =
{
  name : 'Puppeteer.Sample',
  tests :
  {
    trivial
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();

```

### Test routine template explanation

Lets split out template routine into steps and take a look what each step is for.

```javascript
async function trivial( test )
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
  
  //Check window title
  var title = await page.title();
  test.identical( title, 'Test' );

  //Close browser
  await browser.close();

  return null;
}
```

### Run test suite

To run test Puppeteer test execute:

```
node Puppeteer.test.ss
```

[Back to content](../README.md#Tutorials)
