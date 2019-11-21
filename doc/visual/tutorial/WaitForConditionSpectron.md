## How to register condition and wait it will be fulfilled with a truthy value

This tutorial shows how to wait until text property of a DOM element will be changed.

Please check out [previous tutorial](FirstSpectronTest.md) if you don't have test suite prepared.

## Write a test routine

Add following test routine to your suite:

```javascript
async function waitForTextChange( test )
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
  
  //Change text property after delay
  _.timeOut( 1500, () => 
  {
     app.client.execute( () => 
     {  
      let element = document.querySelector( 'p' );
      element.innerText = 'Hello from test'
     })
  })
  
  //Wait until text will be changed
  await app.client.waitUntil( async () => 
  {
    return await app.client.$( 'p' ).getText() === 'Hello from test';
  })
  
  //Check text property
  var got = await app.client.$( 'p' ).getText();
  test.identical( got, 'Hello from test' );

  //Stop the electron app
  return app.stop();
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





