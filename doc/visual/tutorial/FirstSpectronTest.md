## How to launch simplest Spectron test

This tutorial shows how to prepare minimal test and launch it.

### Prepare asset

If you already have electron application, please move to the next section.

Create file structure:
```
  ├── main.js
  └── index.html
```
Fill `index.html` with test page code:

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

Paste minimal script of electron application to `main.js`:

``` javascript
let {app, BrowserWindow} = require('electron');

let mainWindow;

app.on( 'window-all-closed', () =>
{
  if (process.platform != 'darwin')
    app.quit();
});

app.on( 'ready', () =>
{
  mainWindow = new BrowserWindow
  ({
    width : 800,
    height : 600,
    webPreferences : { nodeIntegration : true },
  })

  mainWindow.loadFile( './index.html' );
  mainWindow.on( 'closed', () =>
  {
    mainWindow = null;
  });
});


```

### Write simple test suite

Add `Spectron.test.ss` to the structure and paste there:

``` javascript
( function _Spectron_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( 'wTools' );
  _.include( 'wTesting' );
  _.include( 'wFiles' );

  var ElectronPath = require( 'electron' );
  var Spectron = require( 'spectron' );

}

let _global = _global_;
let _ = _global_.wTools;

//

async function trivial( test )
{
  let self = this;
  let mainJsPath = _.path.nativize( _.path.join( __dirname, 'main.js' ) );

  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainJsPath ]
  })

  await app.start()
  await app.client.waitUntilTextExists( 'p','Hello world', 5000 )
  
  var title = await app.client.getTitle();
  test.identical( title, 'Test' )

  return app.stop();
}

// --
// suite
// --

let Self =
{
  name : 'Spectron.Sample',
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
  
  // Prepare path to electron app script( main.js )
  let mainJsPath = _.path.nativize( _.path.join( __dirname, 'main.js' ) );

  // Create app instance using path to main.js and electron binary
  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainJsPath ]
  })

  // Start the electron app
  await app.start()
  // Waint until page will be loaded( Text appears on page )
  await app.client.waitUntilTextExists( 'p','Hello world', 5000 )
  
  //Check window title
  var title = await app.client.getTitle();
  test.identical( title, 'Test' )

  //Stop the electron app
  return app.stop();
}
```

### Run test suite

To run test Spectron test execute:

```
node Spectron.test.ss
```

[Back to content](../README.md#Tutorials)
