( function _Remote_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( 'Tools' );
  require( '../testing/entry/Basic.s' );
  _.include( 'wFiles' );
}

const _global = _global_;
const _ = _global_.wTools;
const __ = _globals_.testing.wTools;

// --
// context
// --

function onSuiteBegin()
{
  let self = this;
  self.suiteTempPath = __.path.tempOpen( __.path.join( __dirname, '../..' ), 'Tester' );
  self.assetsOriginalPath = __.path.join( __dirname, '_asset' );
  self.appStartNonThrowing = __.path.nativize( __.path.join( __.path.normalize( __dirname ), '../testing/entry/Basic.s' ) );
  self.toolsPath = __.path.nativize( __.path.join( __.path.normalize( __dirname ), 'Tools' ) );
}

function onSuiteEnd()
{
  let self = this;
  __.assert( __.strHas( self.suiteTempPath, 'Tester' ) )
  __.path.tempClose( self.suiteTempPath );
}

// --
// tests
// --

function netInterfacesGet( test )
{
  let context = this;
  let a = test.assetFor( 'hello' );

  if( process.platform !== 'linux' )
  {
    test.shouldThrowErrorSync( () => __.test.workflowSshAgentRun() );
    return;
  }

  /* */

  a.ready.then( () => __.test.netInterfacesGet() );
  a.ready.then( ( op ) =>
  {
    test.case = 'without arguments, all interfaces';
    test.true( __.arrayIs( op ) );
    test.true( op.length >= 1 );
    test.true( __.strDefined( op[ 0 ] ) );
    return null;
  });

  a.ready.then( () => __.test.netInterfacesGet({ activeInterfaces : 1 }) );
  a.ready.then( ( op ) =>
  {
    test.case = 'only active interfaces';
    test.true( __.arrayIs( op ) );
    test.true( op.length >= 0 );
    if( op.length )
    test.true( __.strDefined( op[ 0 ] ) );
    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'sync, all interfaces';
    var got = __.test.netInterfacesGet({ sync : 1 });
    test.true( __.arrayIs( got ) );
    test.true( got.length >= 1 );
    test.true( __.strDefined( got[ 0 ] ) );

    test.case = 'sync, active interfaces';
    var got = __.test.netInterfacesGet({ activeInterfaces : 1, sync : 1 });
    test.true( __.arrayIs( got ) );
    test.true( got.length >= 1 );
    if( got.length )
    test.true( __.strDefined( got[ 0 ] ) );

    return null;
  });

  /* - */

  if( Config.debug )
  {
    a.ready.then( () =>
    {
      test.case = 'extra arguments';
      test.shouldThrowErrorSync( () => __.test.netInterfacesGet( { sync : 1 }, { activeInterfaces : 1 } ) );

      test.case = 'wrong type of options map';
      test.shouldThrowErrorSync( () => __.test.netInterfacesGet( 'wrong' ) );

      test.case = 'unknown option in options map';
      test.shouldThrowErrorSync( () => __.test.netInterfacesGet({ sync : 1, unknown : 1 }) );

      return null;
    });
  }

  /* - */

  return a.ready;
}

//

function netInterfacesUp( test )
{
  let context = this;
  let a = test.assetFor( 'hello' );

  if( process.platform !== 'linux' )
  {
    test.shouldThrowErrorSync( () => __.test.workflowSshAgentRun() );
    return;
  }
  /* prevent disabling of interfaces on real machines */
  if( !__.process.insideTestContainer() )
  {
    test.true( true );
    return;
  }

  /* */

  let activeInterfaces = __.test.netInterfacesGet({ activeInterfaces : 1, sync : 1 });
  /* check if it is possible to disable some interface */
  if( !activeInterfaces.length )
  return test.true( true );

  a.ready.then( () => __.test.netInterfacesDown({ interfaces : activeInterfaces[ 0 ] }) );
  a.ready.then( () => __.test.netInterfacesUp({ interfaces : activeInterfaces[ 0 ] }) );
  a.ready.then( ( op ) =>
  {
    test.case = 'interfaces - string, enable single interface';
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    return null;
  });

  /* */

  a.ready.then( () => __.test.netInterfacesDown({ interfaces : activeInterfaces }) );
  a.ready.then( () => __.test.netInterfacesUp({ interfaces : activeInterfaces }) );
  a.ready.then( ( op ) =>
  {
    test.case = 'interfaces - array, enable interfaces';
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    return null;
  });

  /* */

  a.ready.then( () => __.test.netInterfacesDown({ interfaces : activeInterfaces[ 0 ] }) );
  a.ready.then( () =>
  {
    test.case = 'interfaces - string, sync interface enabling';
    var got = __.test.netInterfacesUp({ interfaces : activeInterfaces[ 0 ], sync : 1 });
    test.identical( got.exitCode, 0 );
    test.identical( got.output, '' );
    return null;
  });

  /* */

  a.ready.then( () => __.test.netInterfacesDown({ interfaces : activeInterfaces }) );
  a.ready.then( () =>
  {
    test.case = 'interfaces - array, sync interfaces enabling';
    var got = __.test.netInterfacesUp({ interfaces : activeInterfaces, sync : 1 });
    test.identical( got.exitCode, 0 );
    test.identical( got.output, '' );
    return null;
  });

  /* - */

  if( Config.debug )
  {
    a.ready.then( () =>
    {
      test.case = 'without arguments';
      test.shouldThrowErrorSync( () => __.test.netInterfacesUp() );

      test.case = 'extra arguments';
      test.shouldThrowErrorSync( () => __.test.netInterfacesUp( { interfaces : 'enp3s0' }, { sync : 0 } ) );

      test.case = 'wrong type of options map {-o-}';
      test.shouldThrowErrorSync( () => __.test.netInterfacesUp( 'wrong' ) );

      test.case = 'unknown option in options map {-o-}';
      test.shouldThrowErrorSync( () => __.test.netInterfacesUp({ interfaces : 'enp3s0', unknown : 1 }) );

      test.case = 'o.interfaces is not defined string, not array of strings';
      test.shouldThrowErrorSync( () => __.test.netInterfacesUp({ interfaces : undefined }) );
      test.shouldThrowErrorSync( () => __.test.netInterfacesUp({ interfaces : '' }) );

      test.case = 'o.interfaces is empty array';
      test.shouldThrowErrorSync( () => __.test.netInterfacesUp({ interfaces : [] }) );

      test.case = 'o.interfaces is array with not defined string';
      test.shouldThrowErrorSync( () => __.test.netInterfacesUp({ interfaces : [ 'enp3s0', undefined ] }) );
      test.shouldThrowErrorSync( () => __.test.netInterfacesUp({ interfaces : [ 'enp3s0', '' ] }) );

      return null;
    });
  }

  a.ready.finally( () => __.test.netInterfacesUp({ interfaces : activeInterfaces }) );

  /* - */

  return a.ready;
}

//

function netInterfacesDown( test )
{
  let context = this;
  let a = test.assetFor( 'hello' );

  if( process.platform !== 'linux' )
  {
    test.shouldThrowErrorSync( () => __.test.workflowSshAgentRun() );
    return;
  }
  /* prevent disabling of interfaces on real machines */
  if( !__.process.insideTestContainer() )
  {
    test.true( true );
    return;
  }

  /* */

  let activeInterfaces = __.test.netInterfacesGet({ activeInterfaces : 1, sync : 1 });
  /* check if it is possible to disable some interface */
  if( !activeInterfaces.length )
  return test.true( true );

  a.ready.then( () => __.test.netInterfacesDown({ interfaces : activeInterfaces[ 0 ] }) );
  a.ready.then( ( op ) =>
  {
    test.case = 'interfaces - string, disable single interface';
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    return null;
  });
  a.ready.then( () => __.test.netInterfacesUp({ interfaces : activeInterfaces[ 0 ] }) );

  /* */

  a.ready.then( () => __.test.netInterfacesDown({ interfaces : activeInterfaces }) );
  a.ready.then( ( op ) =>
  {
    test.case = 'interfaces - array, disable interfaces';
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    return null;
  });
  a.ready.then( () => __.test.netInterfacesUp({ interfaces : activeInterfaces }) );

  /* */

  a.ready.then( () =>
  {
    test.case = 'interfaces - string, sync interface disabling';
    var got = __.test.netInterfacesDown({ interfaces : activeInterfaces[ 0 ], sync : 1 });
    test.identical( got.exitCode, 0 );
    test.identical( got.output, '' );
    return null;
  });
  a.ready.then( () => __.test.netInterfacesUp({ interfaces : activeInterfaces }) );

  /* */

  a.ready.then( () =>
  {
    test.case = 'interfaces - array, sync interfaces disabling';
    var got = __.test.netInterfacesDown({ interfaces : activeInterfaces, sync : 1 });
    test.identical( got.exitCode, 0 );
    test.identical( got.output, '' );
    return null;
  });
  a.ready.then( () => __.test.netInterfacesUp({ interfaces : activeInterfaces }) );

  /* - */

  if( Config.debug )
  {
    a.ready.then( () =>
    {
      test.case = 'without arguments';
      test.shouldThrowErrorSync( () => __.test.netInterfacesDown() );

      test.case = 'extra arguments';
      test.shouldThrowErrorSync( () => __.test.netInterfacesDown( { interfaces : 'enp3s0' }, { sync : 0 } ) );

      test.case = 'wrong type of options map {-o-}';
      test.shouldThrowErrorSync( () => __.test.netInterfacesDown( 'wrong' ) );

      test.case = 'unknown option in options map {-o-}';
      test.shouldThrowErrorSync( () => __.test.netInterfacesDown({ interfaces : 'enp3s0', unknown : 1 }) );

      test.case = 'o.interfaces is not defined string, not array of strings';
      test.shouldThrowErrorSync( () => __.test.netInterfacesDown({ interfaces : undefined }) );
      test.shouldThrowErrorSync( () => __.test.netInterfacesDown({ interfaces : '' }) );

      test.case = 'o.interfaces is empty array';
      test.shouldThrowErrorSync( () => __.test.netInterfacesDown({ interfaces : [] }) );

      test.case = 'o.interfaces is array with not defined string';
      test.shouldThrowErrorSync( () => __.test.netInterfacesDown({ interfaces : [ 'enp3s0', undefined ] }) );
      test.shouldThrowErrorSync( () => __.test.netInterfacesDown({ interfaces : [ 'enp3s0', '' ] }) );

      return null;
    });
  }

  a.ready.finally( () => __.test.netInterfacesUp({ interfaces : activeInterfaces }) );

  /* - */

  return a.ready;
}

//

function workflowSshAgentRun( test )
{
  let context = this;
  let a = test.assetFor( 'hello' );

  let keyData = process.env.PRIVATE_WTOOLS_BOT_SSH_KEY;
  let insideTestContainer =  __.process.insideTestContainer();
  let validPlatform = process.platform === 'linux';
  if( !insideTestContainer || !validPlatform || !keyData )
  {
    test.shouldThrowErrorSync( () => __.test.workflowSshAgentRun() );
    return;
  }

  /* */

  a.ready.then( () => __.test.workflowSshAgentRun() );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, 'Identity added' ), 1 );
    test.true( process.env.SSH_AUTH_SOCK !== undefined );
    test.true( /\d+/.test( process.env.SSH_AGENT_PID ) );
    return null;
  });

  /* */

  a.shell({ currentPath : a.path.current(), execPath : 'ssh-add -D' });
  a.ready.then( () => __.test.workflowSshAgentRun({ keyData : process.env.PRIVATE_WTOOLS_BOT_SSH_KEY }) );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, 'Identity added' ), 1 );
    test.true( process.env.SSH_AUTH_SOCK !== undefined );
    test.true( /\d+/.test( process.env.SSH_AGENT_PID ) );
    return null;
  });

  /* - */

  if( Config.debug )
  {
    a.ready.then( () =>
    {
      test.case = 'extra argument';
      test.shouldThrowErrorSync( () => __.test.workflowSshAgentRun( { keyData : process.env.PRIVATE_WTOOLS_BOT_SSH_KEY }, 'extra' ) );

      test.case = 'not valid environment';
      let tmp = process.env.PRIVATE_WTOOLS_BOT_SSH_KEY;
      delete process.env.PRIVATE_WTOOLS_BOT_SSH_KEY;
      __.test.workflowSshAgentRun.defaults.keyData = '';
      test.shouldThrowErrorSync( () => __.test.workflowSshAgentRun() );
      process.env[ 'PRIVATE_WTOOLS_BOT_SSH_KEY' ] = tmp;
      test.shouldThrowErrorSync( () => __.test.workflowSshAgentRun({ keyData : '' }) );

      test.case = 'unknown option in options map';
      test.shouldThrowErrorSync( () =>
      {
        __.test.workflowSshAgentRun({ keyData : process.env.PRIVATE_WTOOLS_BOT_SSH_KEY, unknown : 1 });
      });

      return null;
    });
  }

  return a.ready;
}

// --
// declare
// --

const Proto =
{

  name : 'Tools.Tester.Remote',
  silencing : 1,
  enabled : 1,

  onSuiteBegin,
  onSuiteEnd,
  routineTimeOut : 300000,

  context :
  {
    suiteTempPath : null,
    assetsOriginalPath : null,
    appStartNonThrowing : null,
    toolsPath : null,
  },

  tests :
  {

    netInterfacesGet,
    netInterfacesUp,
    netInterfacesDown,

    workflowSshAgentRun,

  }

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
