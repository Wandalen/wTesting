## How to move backward/forward in history and wait until page will be loaded.

Please check out [previous tutorial](FirstSpectronTest.md) if you don't have test suite prepared.

## Write a test routine

Add following test routine to your suite:

```javascript
async function navigation( test )
{
  let self = this;
  let routinePath = _.path.join( self.tempDir, test.name );
  let mainPath = _.path.nativize( _.path.join( routinePath, 'main.js' ) );

  _.fileProvider.filesReflect({ reflectMap : { [ self.assetDirPath ] : routinePath } })

  // Init application
  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ]
  })

  // Start app and wait until page will be loaded
  await app.start()
  await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )

  // Open first url
  await app.client.url( 'https://www.npmjs.com/' );
  var url = await app.client.getUrl();
  test.identical( url,'https://www.npmjs.com/' );
  
  // Open second url
  await app.client.url( 'https://www.npmjs.com/wTesting' );
  var url = await app.client.getUrl();
  test.identical( url,'https://www.npmjs.com/package/wTesting' );
  
  // Move backward in history
  await app.client.back();
  var url = await app.client.getUrl();
  test.identical( url,'https://www.npmjs.com/' );
  
  // Move forward in history
  await app.client.forward();
  var url = await app.client.getUrl();
  test.identical( url,'https://www.npmjs.com/package/wTesting' );
  
  await app.stop();

  return null;
}
```

## Register and run test routine

Add test routine to `tests` map and the end of test suite file.

To run test routine enter:
```
node Spectron.test.ss r:navigation v:5
```

[Full sample](../../../sample/spectron/Navigation.test.s)

[Back to content](../README.md#Tutorials)





