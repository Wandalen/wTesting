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

/**
 * Routine netInterfacesGet() gets the list of network interfaces in OS.
 *
 * @example
 * let ready = _globals_.testing.wTools.test.netInterfacesGet();
 * ready.deasync();
 * let result = ready.sync();
 * console.log( result );
 * // log : [ 'lo', 'enp3s0', 'wlx503eaa413cd5' ]
 *
 * @example
 * let result = _globals_.testing.wTools.test.netInterfacesGet({ sync : 1 });
 * console.log( result );
 * // log : [ 'lo', 'enp3s0', 'wlx503eaa413cd5' ]
 *
 * @example
 * let result = _globals_.testing.wTools.test.netInterfacesGet({ sync : 1 });
 * console.log( result );
 * // log : [ 'lo', 'enp3s0', 'wlx503eaa413cd5' ]
 *
 * @example
 * let ready = _globals_.testing.wTools.test.netInterfacesGet({ activeInterfaces : 1 });
 * ready.deasync();
 * let result = ready.sync();
 * console.log( result );
 * // log : [ 'wlx503eaa413cd5' ]
 *
 * @example
 * let result = _globals_.testing.wTools.test.netInterfacesGet({ activeInterfaces : 1, sync : 1 });
 * console.log( result );
 * // log : [ 'wlx503eaa413cd5' ]
 *
 * @param { Map } o - Options map.
 * @param { BoolLike } o.activeInterfaces - If it is true, then routine filters only active network interfaces. Default is false.
 * @param { BoolLike } o.sync - If it is true, then routine returns result synchronously. Default is false.
 * @returns { Consequence|Array } - Returns a Consequence which resolves to array with network interfaces names. If {-o.sync-}
 * is true, returns array with network interfaces names.
 * @function netInterfacesGet
 * @throws { Error } If arguments.length is greater than 1.
 * @throws { Error } If options map {-o-} has not valid type.
 * @throws { Error } If options map {-o-} has unknown option.
 * @namespace wTesting.wTools.test
 * @module Tools/top/testing
 */

function netInterfacesGet( o )
{
  if( arguments.length === 0 )
  o = Object.create( null );

  _.assert( arguments.length === 0 || arguments.length === 1, 'Expects single options map {-o-}' );
  _.routineOptions( netInterfacesGet, o );

  if( process.platform !== 'linux' )
  _.assert( 0, 'not implemented' );

  let execPath = 'ip a | awk ';
  if( o.activeInterfaces )
  execPath += '\'/state UP/{print $2}\'';
  else
  execPath += '\'/state /{print $2}\'';

  const ready = _.process.start
  ({
    currentPath : _.path.current(),
    execPath,
    outputCollecting : 1,
    inputMirroring : 0,
    mode : 'shell',
  });
  ready.then( ( op ) =>
  {
    let result = op.output.split( '\n' );
    for( let i = 0; i < result.length; i++ )
    {
      result[ i ] = result[ i ].replace( /(.*):/, '$1' );
      if( result[ i ] === '' )
      result.splice( i, 1 );
    }
    return result;
  });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

netInterfacesGet.defaults =
{
  activeInterfaces : 0,
  sync : 0,
};

//

/**
 * Routine netInterfacesUp() enables network interfaces from list {-o.interfaces-}.
 *
 * @example
 * _globals_.testing.wTools.test.netInterfacesUp({ interfaces : 'enp3s0' });
 * // returns Consequence which resolves into Process instance
 *
 * @example
 * _globals_.testing.wTools.test.netInterfacesUp({ interfaces : [ 'enp3s0', 'wlx503eaa413cd5' ] });
 * // returns Consequence which resolves into Process instance
 *
 * @example
 * let result = _globals_.testing.wTools.test.netInterfacesUp({ interfaces : 'enp3s0', sync : 1 });
 * // returns Process instance
 *
 * @example
 * let result = _globals_.testing.wTools.test.netInterfacesUp({ interfaces : [ 'enp3s0', 'wlx503eaa413cd5' ], sync : 1 });
 * // returns Process instance
 *
 * @param { Map } o - Options map.
 * @param { String|Array } o.interfaces - Name or array of names of network interfaces to enable.
 * @param { BoolLike } o.sync - If it is true, then routine returns result synchronously. Default is false.
 * @returns { Consequence|Process } - Returns a Consequence which resolves to Process instance with result of execution.
 * If {-o.sync-} is true, returns Process instance synchronously.
 * @function netInterfacesUp
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If options map {-o-} has not valid type.
 * @throws { Error } If options map {-o-} has unknown option.
 * @throws { Error } If option {-o.interfaces-} has not valid type.
 * @throws { Error } If option {-o.interfaces-} is empty array.
 * @namespace wTesting.wTools.test
 * @module Tools/top/testing
 */

function netInterfacesUp( o )
{
  _.assert( arguments.length === 1, 'Expects single options map {-o-}' );
  _.routineOptions( netInterfacesUp, o );

  if( process.platform !== 'linux' )
  _.assert( 0, 'not implemented' );

  o.interfaces = _.arrayAs( o.interfaces );
  _.assert( _.strsDefined( o.interfaces ), 'Expects defined interfaces {-o.interfaces-}' );
  _.assert( o.interfaces.length, 'Expects interfaces {-o.interfaces-} to enable' );

  const ready = _.take( null );
  const shell = _.process.starter
  ({
    currentPath : _.path.current(),
    outputCollecting : 1,
    inputMirroring : 0,
    mode : 'shell',
    ready,
  });

  for( let i = 0 ; i < o.interfaces.length ; i++ )
  shell( `sudo ip link set ${ o.interfaces[ i ] } up` );

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}


netInterfacesUp.defaults =
{
  interfaces : null,
  sync : 0,
};

//

/**
 * Routine netInterfacesDown() disables network interfaces from list {-o.interfaces-}.
 *
 * @example
 * _globals_.testing.wTools.test.netInterfacesDown({ interfaces : 'enp3s0' });
 * // returns Consequence which resolves into Process instance
 *
 * @example
 * _globals_.testing.wTools.test.netInterfacesDown({ interfaces : [ 'enp3s0', 'wlx503eaa413cd5' ] });
 * // returns Consequence which resolves into Process instance
 *
 * @example
 * let result = _globals_.testing.wTools.test.netInterfacesDown({ interfaces : 'enp3s0', sync : 1 });
 * // returns Process instance
 *
 * @example
 * let result = _globals_.testing.wTools.test.netInterfacesDown({ interfaces : [ 'enp3s0', 'wlx503eaa413cd5' ], sync : 1 });
 * // returns Process instance
 *
 * @param { Map } o - Options map.
 * @param { String|Array } o.interfaces - Name or array of names of network interfaces to disable.
 * @param { BoolLike } o.sync - If it is true, then routine returns result synchronously. Default is false.
 * @returns { Consequence|Process } - Returns a Consequence which resolves to Process instance with result of execution.
 * If {-o.sync-} is true, returns Process instance synchronously.
 * @function netInterfacesDown
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If options map {-o-} has not valid type.
 * @throws { Error } If options map {-o-} has unknown option.
 * @throws { Error } If option {-o.interfaces-} has not valid type.
 * @throws { Error } If option {-o.interfaces-} is empty array.
 * @namespace wTesting.wTools.test
 * @module Tools/top/testing
 */

function netInterfacesDown( o )
{
  _.assert( arguments.length === 1, 'Expects single options map {-o-}' );
  _.routineOptions( netInterfacesDown, o );

  if( process.platform !== 'linux' )
  _.assert( 0, 'not implemented' );

  o.interfaces = _.arrayAs( o.interfaces );
  _.assert( _.strsDefined( o.interfaces ), 'Expects defined interfaces {-o.interfaces-}' );
  _.assert( o.interfaces.length, 'Expects interfaces {-o.interfaces-} to disable' );

  const ready = _.take( null );
  const shell = _.process.starter
  ({
    currentPath : _.path.current(),
    outputCollecting : 1,
    inputMirroring : 0,
    mode : 'shell',
    ready,
  });

  for( let i = 0 ; i < o.interfaces.length ; i++ )
  shell( `sudo ip link set ${ o.interfaces[ i ] } down` );

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

netInterfacesDown.defaults =
{
  interfaces : null,
  sync : 0,
};

//

/**
 * Routine workflowTriggerGet() determines what trigger activate workflow run.
 *
 * @example
 * _globals_.testing.wTools.test.workflowTriggerGet();
 * // returns : 'local_run'
 *
 * @returns { String } - Returns a String with name of trigger:
 * - 'pull_request' - for pull requests;
 * - 'publish' - if pushed commit has module version in commit message;
 * - 'push' - for regular pushes;
 * - 'local_run' - for runs on local machines.
 * @function workflowTriggerGet
 * @throws { Error } If workflow run is activated by unknown trigger.
 * @namespace wTesting.wTools.test
 * @module Tools/top/testing
 */

function workflowTriggerGet( localPath )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strDefined( localPath ) );

  if( !_.process.insideTestContainer() )
  return 'local_run';

  if( process.env.CIRCLECI )
  {
    if( process.env.CI_PULL_REQUEST )
    return 'pull_request';
    if( publishPushIs() )
    return 'publish';
    else
    return 'push';
  }

  if( publishPushIs() )
  return 'publish';
  if( process.env.GITHUB_EVENT_NAME === 'push' )
  return 'push';
  if( process.env.GITHUB_EVENT_NAME === 'pull_request' )
  return 'pull_request';
  console.log( `process.env.GITHUB_EVENT_NAME : ${process.env.GITHUB_EVENT_NAME}` );
  return process.env.GITHUB_EVENT_NAME || null;
  // else
  // _.assert( 0, 'Unknown trigger' );

  /* */

  function publishPushIs()
  {
    let lastCommitLog = _.process.start
    ({
      currentPath : localPath,
      execPath : 'git log --format=%B -n 1',
      outputCollecting : 1,
      sync : 1,
    });
    let commitMsg = lastCommitLog.output;
    return _.strBegins( commitMsg, 'version' );
  }
}

workflowTriggerGet.defaults =
{
  localPath : null,
};

//

/**
 * Routine workflowSshAgentRun() setup the ssh-agent on remote workflow.
 *
 * @example
 * _globals_.testing.wTools.test.workflowSshAgentRun();
 * // returns : Consequence which resolves into Process instance
 *
 * @returns { Consequence } - Returns a Consequence which resolves to Process instance with result of setup.
 * @function workflowSshAgentRun
 * @throws { Error } If arguments are provided.
 * @throws { Error } If routine runs on local machine.
 * @throws { Error } If environment variable `SSH_PRIVATE_KEY` does not exist.
 * @throws { Error } If environment variable `SSH_PRIVATE_KEY` has not supported format.
 * @namespace wTesting.wTools.test
 * @module Tools/top/testing
 */

function workflowSshAgentRun( o )
{
  if( arguments.length === 0 )
  o = Object.create( null );
  else
  _.assert( arguments.length === 1, 'Expects single options map {-o-}' );

  _.assert( _.process.insideTestContainer(), 'Should be used only in CI' );
  _.routineOptions( workflowSshAgentRun, o );
  _.assert( _.strDefined( o.keyData ), 'Expects data for ssh private key' );

  if( process.platform !== 'linux' )
  _.assert( 0, 'not implemented' );

  const ready = _.take( null );
  const shell = _.process.starter
  ({
    currentPath : _.path.current(),
    outputCollecting : 1,
    inputMirroring : 0,
    outputPiping : 1,
    mode : 'shell',
    ready,
  });

  /* */

  let keyPath;
  ready.then( sshKeyWrite );
  shell( 'ssh-agent' );
  ready.then( sshAgentEnvironmentsSetup );
  shell( `ssh-add ${ keyPath }` );

  return ready;

  /* */

  function sshKeyWrite()
  {
    const provider = _.fileProvider;
    const path = provider.path;
    const keyFileName = 'private.key';
    provider.dirMake( path.join( process.env.HOME, '.ssh' ) );
    keyPath = path.join( process.env.HOME, '.ssh', keyFileName );
    provider.fileWrite( keyPath, o.keyData );
    provider.rightsWrite({ filePath : keyPath, setRights : 0o600 });
    return keyPath;
  }

  /* */

  function sshAgentEnvironmentsSetup( op )
  {
    const lines = op.output.split( '\n' );
    for( let i = 0 ; i < lines.length ; i++ )
    {
      const matches = /^(SSH_AUTH_SOCK|SSH_AGENT_PID)=(.*); export \1/.exec( lines[ i ] );
      if( matches && matches.length > 0 )
      process.env[ matches[ 1 ] ] = String( matches[ 2 ] );
    }
    return null;
  }
}

workflowSshAgentRun.defaults =
{
  keyData : process.env.PRIVATE_WTOOLS_BOT_SSH_KEY,
};

//

let Extension =
{
  fileDrop,
  eventDispatch,
  waitForVisibleInViewport,
  waitForVisibleInViewportPuppeteer,
  waitForVisibleInViewportSpectron,
  isVisibleWithinViewport,

  // utilities

  netInterfacesGet,
  netInterfacesUp,
  netInterfacesDown,

  workflowTriggerGet,
  workflowSshAgentRun,

}

_.mapExtend( Self, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
