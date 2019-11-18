## Commands chaining
How to run commands in series to get text value of DOM element.
Running command in chain allows to omit resolving of intermediate results. 
Result of previous command is passed to next command.

[Spectron commands chaining](https://webdriver.io/docs/pageobjects.html#chaining-commands)

## Spectron
```javascript
  let app = new Spectron.Application
  ({
    path : ElectronPath,
    args : [ mainPath ]
  })

  await app.start()
  test.case = 'wait for load then check innerText property'
  var text = await app.client
  .waitUntilTextExists( 'p','Hello world', 5000 )
  .$( '.class1 p' )
  .getText()
  test.identical( text, 'Text1' );
  await app.stop();
```
[Full sample](../../../../sample/spectron/Chaining.test.s)

## Puppeteer

Puppeteer commands return Promise as result, but don't support chaining.

```javascript
  let page = null;
  let browser = null;

  setup();

  ready.then( () =>
  {
    let path = 'file:///' + _.path.nativize( indexHtmlPath );
    return page.goto( path, { waitUntil : 'load' } )
  })

  ready.then( () =>
  {
    return page.$( '.class1 p' )
    .then( ( element ) => element.evaluate( ( e ) => e.innerText ) )
    .then( ( innerText ) =>
    {
      test.identical( innerText, 'Text1')
      return null;
    })
  })

  ready.then( () =>
  {
    return browser.close()
    .then( () => null )
  });

  return ready;

  //

  function setup()
  {
    let ready = Puppeteer.launch({ headless : true })
    .then( ( got ) =>
    {
      browser = got;
      return browser.newPage()
    })
    .then( ( got ) =>
    {
      page = got;
      return got;
    })
    ready = _.Consequence.From( ready );
    return ready.deasync();
  }
```
[Full sample](../../../../sample/puppeteer/Chaining.test.s)


[Back to content](../Comparison.md)
