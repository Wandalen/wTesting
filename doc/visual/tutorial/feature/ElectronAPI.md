## Electron API
How to use Electron API from Spectron. Get current window title.

## Spectron
[Spectron API](https://github.com/electron-userland/spectron#application-api)

```javascript
  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ]
  })

  await app.start()
  await app.client.waitUntilTextExists( 'p', 'Hello world', 5000 )
  //app.browserWindow is a shortcut to app.electron.remote.getCurrentWindow()
  let title = await app.browserWindow.getTitle();
  test.identical( title, 'Test' );
  await app.stop();
```
[Full sample](../../../../sample/spectron/Electron.test.s)


[Back to content](../Comparison.md)
