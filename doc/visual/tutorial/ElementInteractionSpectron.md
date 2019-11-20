## How to find DOM element on page and access it properties using Spectron

Please check out [previous tutorial](FirstSpectronTest.md) if you don't have test suite prepared.

## Write a test routine
Add following test routine to your suite:

```javascript
async function domElementProperties( test )
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
  
  //innerText
  var text = await app.client.$( 'p' ).getText();
  test.identical( text, 'Hello world' );
  
  //outerHtml 
  var html = await app.client.$( 'p' ).getHTML();
  test.identical( html, '<p>Hello world</p>' );
  
  //Elements position on page
  var location = await app.client.$( 'p' ).getLocation();
  test.gt( location.x, 0 );
  test.gt( location.y, 0 );

  //Stop the electron app
  return app.stop();
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
node Spectron.test.ss r:domElementProperties v:5
```

[Full sample](../../../sample/spectron/ElementProperties.test.s)

[Back to content](../README.md#Tutorials)





