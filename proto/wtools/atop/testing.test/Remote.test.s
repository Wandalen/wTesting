( function _Remote_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../Tools.s' );
  require( '../testing/entry/Main.s' );
  _.include( 'wFiles' );
}

let _global = _global_;
let _ = _globals_.testing.wTools;

// --
// context
// --

function onSuiteBegin()
{
  let self = this;
  self.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..'  ), 'Tester' );
  self.assetsOriginalPath = _.path.join( __dirname, '_asset' );
  self.appStartNonThrowing = _.path.nativize( _.path.join( _.path.normalize( __dirname ), '../testing/entry/Main.s' ) );
  self.toolsPath = _.path.nativize( _.path.join( _.path.normalize( __dirname ), '../../Tools.s' ) );
}

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.suiteTempPath, 'Tester' ) )
  _.path.tempClose( self.suiteTempPath );
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
    test.shouldThrowErrorSync( () => _.test.workflowSshAgentRun() );
    return;
  }

  /* */

  a.ready.then( () => _.test.netInterfacesGet() );
  a.ready.then( ( op ) =>
  {
    test.case = 'without arguments, all interfaces';
    test.true( _.arrayIs( op ) );
    test.true( op.length >= 1 );
    test.true( _.strDefined( op[ 0 ] ) );
    return null;
  });

  a.ready.then( () => _.test.netInterfacesGet({ activeInterfaces : 1 }) );
  a.ready.then( ( op ) =>
  {
    test.case = 'only active interfaces';
    test.true( _.arrayIs( op ) );
    test.true( op.length >= 0 );
    if( op.length )
    test.true( _.strDefined( op[ 0 ] ) );
    return null;
  });

  a.ready.then( () =>
  {
    test.case = 'sync, all interfaces';
    var got = _.test.netInterfacesGet({ sync : 1 });
    test.true( _.arrayIs( got ) );
    test.true( got.length >= 1 );
    test.true( _.strDefined( got[ 0 ] ) );

    test.case = 'sync, active interfaces';
    var got = _.test.netInterfacesGet({ activeInterfaces : 1, sync : 1 });
    test.true( _.arrayIs( got ) );
    test.true( got.length >= 1 );
    if( got.length )
    test.true( _.strDefined( got[ 0 ] ) );

    return null;
  });

  /* - */

  if( Config.debug )
  {
    a.ready.then( () =>
    {
      test.case = 'extra arguments';
      test.shouldThrowErrorSync( () => _.test.netInterfacesGet( { sync : 1 }, { activeInterfaces : 1 } ) );

      test.case = 'wrong type of options map';
      test.shouldThrowErrorSync( () => _.test.netInterfacesGet( 'wrong' ) );

      test.case = 'unknown option in options map';
      test.shouldThrowErrorSync( () => _.test.netInterfacesGet({ sync : 1, unknown : 1 }) );

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
    test.shouldThrowErrorSync( () => _.test.workflowSshAgentRun() );
    return;
  }
  /* prevent disabling of interfaces on real machines */
  if( !_.process.insideTestContainer() )
  {
    test.true( true );
    return;
  }

  /* */

  let activeInterfaces = _.test.netInterfacesGet({ activeInterfaces : 1, sync : 1 });
  /* check if it is possible to disable some interface */
  if( !activeInterfaces.length )
  return test.true( true );

  a.ready.then( () => _.test.netInterfacesDown({ interfaces : activeInterfaces[ 0 ] }) );
  a.ready.then( () => _.test.netInterfacesUp({ interfaces : activeInterfaces[ 0 ] }) );
  a.ready.then( ( op ) =>
  {
    test.case = 'interfaces - string, enable single interface';
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    return null;
  });

  /* */

  a.ready.then( () => _.test.netInterfacesDown({ interfaces : activeInterfaces }) );
  a.ready.then( () => _.test.netInterfacesUp({ interfaces : activeInterfaces }) );
  a.ready.then( ( op ) =>
  {
    test.case = 'interfaces - array, enable interfaces';
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    return null;
  });

  /* */

  a.ready.then( () => _.test.netInterfacesDown({ interfaces : activeInterfaces[ 0 ] }) );
  a.ready.then( () =>
  {
    test.case = 'interfaces - string, sync interface enabling';
    var got = _.test.netInterfacesUp({ interfaces : activeInterfaces[ 0 ], sync : 1 });
    test.identical( got.exitCode, 0 );
    test.identical( got.output, '' );
    return null;
  });

  /* */

  a.ready.then( () => _.test.netInterfacesDown({ interfaces : activeInterfaces }) );
  a.ready.then( () =>
  {
    test.case = 'interfaces - array, sync interfaces enabling';
    var got = _.test.netInterfacesUp({ interfaces : activeInterfaces, sync : 1 });
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
      test.shouldThrowErrorSync( () => _.test.netInterfacesUp() );

      test.case = 'extra arguments';
      test.shouldThrowErrorSync( () => _.test.netInterfacesUp( { interfaces : 'enp3s0' }, { sync : 0 } ) );

      test.case = 'wrong type of options map {-o-}';
      test.shouldThrowErrorSync( () => _.test.netInterfacesUp( 'wrong' ) );

      test.case = 'unknown option in options map {-o-}';
      test.shouldThrowErrorSync( () => _.test.netInterfacesUp({ interfaces : 'enp3s0', unknown : 1 }) );

      test.case = 'o.interfaces is not defined string, not array of strings';
      test.shouldThrowErrorSync( () => _.test.netInterfacesUp({ interfaces : undefined }) );
      test.shouldThrowErrorSync( () => _.test.netInterfacesUp({ interfaces : '' }) );

      test.case = 'o.interfaces is empty array';
      test.shouldThrowErrorSync( () => _.test.netInterfacesUp({ interfaces : [] }) );

      test.case = 'o.interfaces is array with not defined string';
      test.shouldThrowErrorSync( () => _.test.netInterfacesUp({ interfaces : [ 'enp3s0', undefined ] }) );
      test.shouldThrowErrorSync( () => _.test.netInterfacesUp({ interfaces : [ 'enp3s0', '' ] }) );

      return null;
    });
  }

  a.ready.finally( () => _.test.netInterfacesUp({ interfaces : activeInterfaces }) );

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
    test.shouldThrowErrorSync( () => _.test.workflowSshAgentRun() );
    return;
  }
  /* prevent disabling of interfaces on real machines */
  if( !_.process.insideTestContainer() )
  {
    test.true( true );
    return;
  }

  /* */

  let activeInterfaces = _.test.netInterfacesGet({ activeInterfaces : 1, sync : 1 });
  /* check if it is possible to disable some interface */
  if( !activeInterfaces.length )
  return test.true( true );

  a.ready.then( () => _.test.netInterfacesDown({ interfaces : activeInterfaces[ 0 ] }) );
  a.ready.then( ( op ) =>
  {
    test.case = 'interfaces - string, disable single interface';
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    return null;
  });
  a.ready.then( () => _.test.netInterfacesUp({ interfaces : activeInterfaces[ 0 ] }) );

  /* */

  a.ready.then( () => _.test.netInterfacesDown({ interfaces : activeInterfaces }) );
  a.ready.then( ( op ) =>
  {
    test.case = 'interfaces - array, disable interfaces';
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    return null;
  });
  a.ready.then( () => _.test.netInterfacesUp({ interfaces : activeInterfaces }) );

  /* */

  a.ready.then( () =>
  {
    test.case = 'interfaces - string, sync interface disabling';
    var got = _.test.netInterfacesDown({ interfaces : activeInterfaces[ 0 ], sync : 1 });
    test.identical( got.exitCode, 0 );
    test.identical( got.output, '' );
    return null;
  });
  a.ready.then( () => _.test.netInterfacesUp({ interfaces : activeInterfaces }) );

  /* */

  a.ready.then( () =>
  {
    test.case = 'interfaces - array, sync interfaces disabling';
    var got = _.test.netInterfacesDown({ interfaces : activeInterfaces, sync : 1 });
    test.identical( got.exitCode, 0 );
    test.identical( got.output, '' );
    return null;
  });
  a.ready.then( () => _.test.netInterfacesUp({ interfaces : activeInterfaces }) );

  /* - */

  if( Config.debug )
  {
    a.ready.then( () =>
    {
      test.case = 'without arguments';
      test.shouldThrowErrorSync( () => _.test.netInterfacesDown() );

      test.case = 'extra arguments';
      test.shouldThrowErrorSync( () => _.test.netInterfacesDown( { interfaces : 'enp3s0' }, { sync : 0 } ) );

      test.case = 'wrong type of options map {-o-}';
      test.shouldThrowErrorSync( () => _.test.netInterfacesDown( 'wrong' ) );

      test.case = 'unknown option in options map {-o-}';
      test.shouldThrowErrorSync( () => _.test.netInterfacesDown({ interfaces : 'enp3s0', unknown : 1 }) );

      test.case = 'o.interfaces is not defined string, not array of strings';
      test.shouldThrowErrorSync( () => _.test.netInterfacesDown({ interfaces : undefined }) );
      test.shouldThrowErrorSync( () => _.test.netInterfacesDown({ interfaces : '' }) );

      test.case = 'o.interfaces is empty array';
      test.shouldThrowErrorSync( () => _.test.netInterfacesDown({ interfaces : [] }) );

      test.case = 'o.interfaces is array with not defined string';
      test.shouldThrowErrorSync( () => _.test.netInterfacesDown({ interfaces : [ 'enp3s0', undefined ] }) );
      test.shouldThrowErrorSync( () => _.test.netInterfacesDown({ interfaces : [ 'enp3s0', '' ] }) );

      return null;
    });
  }

  a.ready.finally( () => _.test.netInterfacesUp({ interfaces : activeInterfaces }) );

  /* - */

  return a.ready;
}

//

function workflowSshAgentRun( test )
{
  let context = this;
  let a = test.assetFor( 'hello' );

  if( !_.process.insideTestContainer() || process.platform !== 'linux' )
  {
    test.shouldThrowErrorSync( () => _.test.workflowSshAgentRun() );
    return;
  }

  /* */

  a.ready.then( () => _.test.workflowSshAgentRun() );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Identity added' ), 1 );
    test.true( process.env.SSH_AUTH_SOCK !== undefined );
    test.true( /\d+/.test( process.env.SSH_AGENT_PID ) );
    return null;
  });

  /* */

  a.shell( 'ssh-add -D' )
  a.ready.then( () => _.test.workflowSshAgentRun({ keyData : process.env.PRIVATE_WTOOLS_BOT_SSH_KEY }) );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Identity added' ), 1 );
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
      test.shouldThrowErrorSync( () => _.test.workflowSshAgentRun( { keyData : process.env.PRIVATE_WTOOLS_BOT_SSH_KEY } ,'extra' ) );

      test.case = 'not valid environment';
      process.env.PRIVATE_WTOOLS_BOT_SSH_KEY = '';
      test.shouldThrowErrorSync( () => _.test.workflowSshAgentRun() );
      test.shouldThrowErrorSync( () => _.test.workflowSshAgentRun({ keyData : '' }) );

      test.case = 'unknown option in options map';
      test.shouldThrowErrorSync( () =>
      {
        _.test.workflowSshAgentRun({ keyData : process.env.PRIVATE_WTOOLS_BOT_SSH_KEY, unknown : 1 });
      });

      return null;
    });
  }

  return a.ready;
}

// --
// declare
// --

let Self =
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

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
