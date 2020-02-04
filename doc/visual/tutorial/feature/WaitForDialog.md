## Wait until element will be visible

How to wait until dialog appears on page.

## Puppeteer

```javascript

let ready = _.time.outError( 5000 );
page.on( 'dialog', ( e ) => 
{ 
  test.identical( e.message(), 'test message' );
  e.accept();
  ready.take( _.dont );
});
await page.evaluate( () => alert( 'test message' ) );
await ready;

```

[Full sample](../../../../sample/puppeteer/WaitForDialog.test.s)


## Spectron

```javascript
await app.client.execute( () => alert( 'test message') );
test.identical( await app.client.alertText(), 'test message' );
await app.client.alertAccept();
```

[Full sample](../../../../sample/spectron/WaitForDialog.test.s)


[Back to content](../Comparison.md)
