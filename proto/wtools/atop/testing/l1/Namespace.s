( function _Namespace_s_()
{

'use strict';

const _global = _global_;
const _ = _global_.wTools;
_.test = _.test || Object.create( null );

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
  _.routine.options_( netInterfacesGet, o );

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
  _.routine.options_( netInterfacesUp, o );

  if( process.platform !== 'linux' )
  _.assert( 0, 'not implemented' );

  o.interfaces = _.array.as( o.interfaces );
  _.assert( _.strsDefined( o.interfaces ), 'Expects defined interfaces {-o.interfaces-}' );
  _.assert( o.interfaces.length > 0, 'Expects interfaces {-o.interfaces-} to enable' );

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
  _.routine.options_( netInterfacesDown, o );

  if( process.platform !== 'linux' )
  _.assert( 0, 'not implemented' );

  o.interfaces = _.array.as( o.interfaces );
  _.assert( _.strsDefined( o.interfaces ), 'Expects defined interfaces {-o.interfaces-}' );
  _.assert( o.interfaces.length > 0, 'Expects interfaces {-o.interfaces-} to disable' );

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
  _.routine.options_( workflowSshAgentRun, o );
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
  // utilities

  netInterfacesGet,
  netInterfacesUp,
  netInterfacesDown,

  workflowTriggerGet,
  workflowSshAgentRun,

}

Object.assign( _.test, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
