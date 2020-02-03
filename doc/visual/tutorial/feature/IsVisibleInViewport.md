## Check if element is visible in viewport

How to check if element is intersecting viewport.

## Puppeteer

```javascript
var got = await _.test.isVisibleWithinViewport
({ 
  library : 'puppeteer', 
  page,
  timeOut : 5000, 
  targetSelector : 'p' 
});
test.identical( got, true );
```

[Full sample](../../../../sample/puppeteer/IsVisibleInViewport.test.s)

## Spectron

```javascript
var got = await _.test.isVisibleWithinViewport
({ 
  library : 'spectron', 
  page : app.client,
  timeOut : 5000, 
  targetSelector : 'p' 
});
test.identical( got, true );
```

[Full sample](../../../../sample/spectron/IsVisibleInViewport.test.s)

[Back to content](../Comparison.md)
