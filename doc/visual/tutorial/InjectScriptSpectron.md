## How to use Spectron to inject a snippet of JavaScript into the page for execution in browser context.

Please check out [previous tutorial](FirstSpectronTest.md) if you don't have test suite prepared.

## Write a test routine

Add following test routine to your suite:

```javascript
async function injectScript( test )
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
  
  //Inject script that changes text property of DOM element and return it as value
  let got = await app.client.execute( () => 
  {
    let element = document.querySelector( 'p' );
    element.innerText = 'Hello from test';
    return element.innerText;
  })
  test.identical( got.value, 'Hello from test' );

  //Stop the electron app
  return app.stop();
}
```

## Register and run test routine

Add test routine to `tests` map and the end of test suite file.

To run test routine enter:
```
node Spectron.test.ss r:injectScript v:5
```

[Full sample](../../../sample/spectron/InjectScript.test.s)

[Back to content](../README.md#Tutorials)





