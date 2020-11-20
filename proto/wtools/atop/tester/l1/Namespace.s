( function _Namespace_s_()
{

'use strict';

let _global = _global_;
let _ = _global_.wTools;
let Self = _.test = _.test || Object.create( null );

// --
// UI Testing
// --

function fileDrop( o )
{
  _.assert( arguments.length === 1 );
  _.routineOptions( fileDrop, o );
  _.assert( _.strIs( o.filePath ) || _.arrayIs( o.filePath ) );
  _.assert( _.strIs( o.targetSelector ) )
  _.assert( _.strIs( o.fileInputId ) )
  _.assert( o.library === 'puppeteer' || o.library === 'spectron' );
  _.assert( _.objectIs( o.page ) )

  let ready = new _.Consequence().take( null );
  let filePath = _.path.s.nativize( _.arrayAs( o.filePath ) );

  if( o.library === 'puppeteer' )
  fileDropPuppeteer();
  else if( o.library === 'spectron' )
  fileDropSpectron();

  return ready;

  /* */

  function fileDropPuppeteer()
  {
    ready
    .then( () => o.page.evaluate( fileInputCreate, o.fileInputId, o.targetSelector, filePath ) )
    .then( () => o.page.$(`#${ o.fileInputId }`) )
    .then( ( fileInput ) => fileInput.uploadFile.apply( fileInput, filePath ) )
  }

  function fileDropSpectron()
  {
    ready
    .then( () => o.page.execute( fileInputCreate, o.fileInputId, o.targetSelector ) )
    // .then( () => _.Consequence.And( filePath.map( path => _.Consequence.From( o.page.uploadFile( path ) ) ) ) )
    .then( () => o.page.$(`#${o.fileInputId}`).then( ( e ) => e.addValue( filePath.join( '\n' ) ) ) )
  }

  function fileInputCreate( fileInputId, targetSelector, filePaths )
  {
    let input = document.createElement( 'input' );
    input.id = fileInputId;
    input.type = 'file';
    input.multiple = 'multiple';
    input.onchange = ( e ) =>
    {
      let event = new Event( 'drop' );
      if( filePaths )
      filePaths.forEach( ( path, i ) =>
      {
        e.target.files[ i ].path = path;
      })
      Object.assign( event, { dataTransfer : { files : e.target.files } } );
      document.querySelector( targetSelector ).dispatchEvent( event );
    }
    document.body.appendChild( input );
  }
}

fileDrop.defaults =
{
  filePath : null,
  targetSelector : null,
  fileInputId : null,
  page : null,
  library : null
}

//

function eventDispatch( o )
{
  _.assert( arguments.length === 1 );
  _.routineOptions( eventDispatch, o );
  _.assert( _.strIs( o.targetSelector ) )
  _.assert( _.strIs( o.eventType ) )
  _.assert( _.objectIs( o.eventData ) || o.eventData === null )
  _.assert( o.library === 'puppeteer' || o.library === 'spectron' );
  _.assert( _.objectIs( o.page ) )

  if( o.eventData === null )
  o.eventData = {};

  let ready = new _.Consequence().take( null );

  if( o.library === 'puppeteer' )
  eventDispatchPuppeteer();
  else if( o.library === 'spectron' )
  eventDispatchSpectron();

  return ready;

  /* */

  function eventDispatchPuppeteer()
  {
    ready.then( () => o.page.evaluate( _eventDispatch, o.eventType, o.eventData, o.targetSelector ) )
  }

  function eventDispatchSpectron()
  {
    ready.then( () => o.page.execute( _eventDispatch, o.eventType, o.eventData, o.targetSelector ) )
  }

  function _eventDispatch( eventType, eventData, targetSelector )
  {
    let event = new Event( eventType );
    Object.assign( event, eventData )
    document.querySelector( targetSelector ).dispatchEvent( event );
  }
}

eventDispatch.defaults =
{
  targetSelector : null,
  eventType : null,
  eventData : null,
  page : null,
  library : null
}

//

function waitForVisibleInViewport( o )
{
  let test = this;

  _.assert( arguments.length === 1 );
  _.routineOptions( waitForVisibleInViewport, o );
  _.assert( _.strIs( o.targetSelector ) )
  _.assert( _.numberIs( o.timeOut ) )
  _.assert( o.library === 'puppeteer' || o.library === 'spectron' );
  _.assert( _.objectIs( o.page ) )

  let o2 = _.mapBut( o, { library : null } );

  if( o.library === 'spectron' )
  return test.waitForVisibleInViewportSpectron( o2 );
  else
  return test.waitForVisibleInViewportPuppeteer( o2 );
}

waitForVisibleInViewport.defaults =
{
  targetSelector : null,
  timeOut : 5000,
  page : null,
  library : null
}

//

function waitForVisibleInViewportPuppeteer( o )
{
  let test = this;

  _.assert( arguments.length === 1 );
  _.routineOptions( waitForVisibleInViewportPuppeteer, o );
  _.assert( _.strIs( o.targetSelector ) )
  _.assert( _.numberIs( o.timeOut ) )
  _.assert( _.objectIs( o.page ) )

  let ready = _.Consequence().take( null )

  ready.then( () =>
  {
    let func = o.page._pageBindings.get( 'puppeteerWaitForVisible' );
    if( _.routineIs( func ) )
    return null;
    return o.page.exposeFunction( 'puppeteerWaitForVisible', waitForVisible )
  })
  ready.then( () => o.page.waitForFunction( waitFunction, { timeout : o.timeOut }, o.targetSelector ) )

  ready.catch( ( err ) =>
  {
    _.errAttend( err );
    throw _.err( `Waiting for selector ${_.strQuote( o.targetSelector )} failed, reason:\n`, err );
  })

  return ready;

  /* */

  async function waitFunction( selector )
  {
    let result = await window.puppeteerWaitForVisible( selector );
    return result;
  }

  /* */

  async function waitForVisible( selector )
  {
    let element = await o.page.$( selector );
    if( !element )
    return false;
    return element.isIntersectingViewport();
  }
}

waitForVisibleInViewportPuppeteer.defaults =
{
  targetSelector : null,
  timeOut : 5000,
  page : null
}

//

function waitForVisibleInViewportSpectron( o )
{
  let test = this;

  _.assert( arguments.length === 1 );
  _.routineOptions( waitForVisibleInViewportSpectron, o );
  _.assert( _.strIs( o.targetSelector ) )
  _.assert( _.numberIs( o.timeOut ) )
  _.assert( _.objectIs( o.page ) )

  let timeOutError = _.time.outError( o.timeOut );
  let result = _.Consequence();
  let visilbe = _.Consequence.From( _waitForVisibleInViewport() );

  result.orKeeping( [ visilbe, timeOutError ] );

  result.finally( ( err, arg ) =>
  {
    if( !err || err.reason !== 'time out' )
    timeOutError.error( _.dont );

    if( !err )
    return arg;

    _.errAttend( err )

    if( err.reason === 'time out' )
    return visilbe.then( () =>
    {
      throw _.err( `Waiting for selector ${_.strQuote( o.targetSelector )} failed: timeout ${o.timeOut}ms exceeded` );
    })

    throw err;
  })

  return result;

  /* */

  async function _waitForVisibleInViewport()
  {
    if( timeOutError.resourcesCount() )
    return null;

    let element = await o.page.$( o.targetSelector );

    if( element.isExisting() )
    {
      let isIntersectingViewport = await test.isVisibleWithinViewport
      ({
        targetSelector : o.targetSelector,
        page : o.page,
        library : 'spectron'
      });
      if( isIntersectingViewport )
      return true;
    }

    return _waitForVisibleInViewport();
  }
}

waitForVisibleInViewportSpectron.defaults =
{
  targetSelector : null,
  timeOut : 5000,
  page : null
}

//

function isVisibleWithinViewport( o )
{
  _.assert( arguments.length === 1 );
  _.routineOptions( isVisibleWithinViewport, o );
  _.assert( _.strIs( o.targetSelector ) )
  _.assert( _.numberIs( o.timeOut ) )
  _.assert( o.library === 'puppeteer' || o.library === 'spectron' );
  _.assert( _.objectIs( o.page ) )

  /* Common way to query selector */

  let con = _.Consequence().take( true );

  con.then( () => o.page.$( o.targetSelector ) )

  con.then( ( element ) =>
  {
    if( o.library === 'spectron' )
    if( !element.isExisting() )
    return null;

    return element;
  })

  con.then( ( element ) =>
  {
    if( !element )
    throw _.err( `Failed to find element that matches the specified selector: ${_.strQuote( o.targetSelector )}` );
    return element;
  })

  /* Puppeteer */

  if( o.library === 'puppeteer' )
  {
    con.then( ( element ) => element.isIntersectingViewport() );
    return con;
  }

  /*
    Solution for Spectron is based on code of isIntersectingViewport from Puppeeteer.
    Spectron has own version of this method( isVisibleWithinViewport ), but it has an issue in current version v4 of WebDriverIO
  */

  con.then( () =>
  {
    o.page.setTimeout
    ({
      'script' : o.timeOut
    });
    return o.page.executeAsync( ( selector, onIntersectionRationCallback ) =>
    {
      let element = document.querySelector( selector );
      let observer = new IntersectionObserver( ( entries ) =>
      {
        onIntersectionRationCallback( entries[ 0 ].intersectionRatio > 0 );
        observer.disconnect();
      });
      observer.observe( element );
    }, o.targetSelector );
  });

  /* */

  return con;
}

isVisibleWithinViewport.defaults =
{
  targetSelector : null,
  timeOut : 25000,
  page : null,
  library : null
}

//

let Extension =
{
  fileDrop,
  eventDispatch,
  waitForVisibleInViewport,
  waitForVisibleInViewportPuppeteer,
  waitForVisibleInViewportSpectron,
  isVisibleWithinViewport
}

_.mapExtend( Self, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
