## Wait until element will be visible in viewport

How to wait until element with specific selector will be intersecting viewport.

## Puppeteer

```javascript
await _.test.waitForVisibleInViewport
({ 
  library : 'puppeteer', 
  page, 
  timeOut : 5000, 
  targetSelector : 'p' 
});
```

[Full sample](../../../../sample/puppeteer/WaitForVisibleInViewport.test.s)

## Spectron

```javascript
await _.test.waitForVisibleInViewport
({ 
  library : 'spectron', 
  page : app.client, 
  timeOut : 5000, 
  targetSelector : 'p' 
});
```

[Full sample](../../../../sample/spectron/WaitForVisibleInViewport.test.s)

[Back to content](../Comparison.md)
