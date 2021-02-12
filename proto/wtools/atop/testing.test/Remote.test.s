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
let _ = _global_.wTools;

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

function workflowSshAgentRun( test )
{
  let context = this;
  let a = test.assetFor( 'hello' );
  let testing = _globals_.testing.wTools;

  if( !_.process.insideTestContainer() || process.platform !== 'linux' )
  {
    test.shouldThrowErrorSync( () => testing.test.workflowSshAgentRun() );
    return;
  }

  /* */

  a.ready.then( () => testing.test.workflowSshAgentRun() );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Identity added' ), 1 );
    test.true( process.env.SSH_AUTH_SOCK !== undefined );
    test.true( /\d+/.test( process.env.SSH_AGENT_PID ) );
    return null;
  });

  /* */

  if( Config.debug )
  {
    a.ready.then( () =>
    {
      test.case = 'extra argument';
      test.shouldThrowErrorSync( () => testing.test.workflowSshAgentRun( 'extra' ) );

      test.case = 'not valid environment';
      process.env.SSH_PRIVATE_KEY = '';
      test.shouldThrowErrorSync( () => testing.test.workflowSshAgentRun() );

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

    workflowSshAgentRun,

  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
