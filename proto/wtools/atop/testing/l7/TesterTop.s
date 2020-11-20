( function _TesterTop_s_()
{

'use strict';

if( Config.interpreter === 'browser' )
debugger;

let _global = _global_;
let _ = _global.wTools;

_.assert( _.mapIs( _realGlobal_.wTester ) );

//

let Parent = _realGlobal_.wTesterBasic;
let Self = wTesterCli;
function wTesterCli( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'TesterCli';

// --
// exec
// --

function Exec()
{
  let tester = new this.Self();
  return tester.exec();
}

//

function exec()
{
  let tester = this;

  _.assert( _.instanceIs( tester ) );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  let logger = tester.logger;
  let fileProvider = tester.fileProvider;
  let appArgs = _.process.input({ keyValDelimeter : 0 });
  let ca = tester._commandsMake();

  return ca.appArgsPerform({ appArgs });
}

//

function init( o )
{
  let tester = this;
  return Parent.prototype.init.apply( tester, arguments );
}

//

function _commandHandleSyntaxError( o )
{
  let tester = this;
  let ca = tester.ca;
  return ca.commandPerform({ command : '.run ' + o.command });
  // return _.CommandsAggregator.prototype.onSyntaxError.call( ca, o );
}

//

function _commandsMake()
{
  let tester = this;
  let logger = tester.logger;
  let fileProvider = tester.fileProvider;
  let appArgs = _.process.input();

  _.assert( _.instanceIs( tester ) );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  /*
  qqq : make possible to use any convention: .suites.list, suites list, suites.list
  */

  let commands =
  {

    'help' :                    { e : _.routineJoin( tester, tester.commandHelp ),                        h : 'Get help.' },
    'version' :                 { e : _.routineJoin( tester, tester.commandVersion ),                     h : 'Get current version.' },
    'imply' :                   { e : _.routineJoin( tester, tester.commandImply ),                       h : 'Change state or imply value of a variable.' },
    'run' :                     { e : _.routineJoin( tester, tester.commandRun ),                         h : 'Run test suites found at a specified path.' },
    'suites list' :             { e : _.routineJoin( tester, tester.commandSuitesList ),                  h : 'Find test suites at a specified path.' },

  }

  let ca = tester.ca = _.CommandsAggregator
  ({
    basePath : fileProvider.path.current(),
    commands,
    commandPrefix : 'node ',
    logger : tester.logger,
    onSyntaxError : ( o ) => tester._commandHandleSyntaxError( o ),
  })

  _.assert( ca.logger === tester.logger );
  _.assert( ca.verbosity === tester.verbosity );

  //tester._commandsConfigAdd( ca );

  ca.form();

  return ca;
}

//

function commandHelp( e )
{
  let tester = this;
  let ca = e.ca;
  let logger = tester.logger;

  logger.log( 'Known commands' );

  ca._commandHelp( e );

  tester.scenarioOptionsList();

}

//

function commandVersion( e )
{
  let cui = this;
  cui.form();
  return _.npm.versionLog
  ({
    localPath : _.path.join( __dirname, '../../../../..' ),
    remotePath : 'wTesting!alpha',
    logger : cui.logger
  });
}

commandVersion.hint = 'Get information about version.';

//

/*
qqq : implement and cover by medium tests command .imply
*/

function commandImply( e )
{
  let tester = this.form();
  let ca = e.ca;
  let logger = tester.logger;

  let request = _.strRequestParse( e.commandArgument );
  tester.appArgsRead({ subject : request.subject, propertiesMap : request.map });

  // let namesMap =
  // {
  //   v : 'verbosity',
  //   verbosity : 'verbosity',
  //   beeping : 'beeping',
  // }
  //
  // let request = tester.Resolver.strRequestParse( e.commandArgument );
  //
  // _.process.inputReadTo
  // ({
  //   dst : tester,
  //   propertiesMap : request.map,
  //   namesMap : namesMap,
  // });

}

//

function commandRun( e )
{
  let tester = this.form();
  let ca = e.ca;
  let fileProvider = tester.fileProvider;
  let path = tester.fileProvider.path;
  let logger = tester.logger;

  let request = _.strCommandParse({ src : e.commandArgument, commandFormat : 'subject options?' });
  tester.appArgsRead({ subject : request.subject, propertiesMap : request.map });
  tester.scenarioTest();

  return null;
}

//

function commandSuitesList( e )
{
  let tester = this.form();
  let ca = e.ca;
  let fileProvider = tester.fileProvider;
  let path = tester.fileProvider.path;
  let logger = tester.logger;
  let request = _.strRequestParse( e.commandArgument );

  tester.appArgsRead({ subject : request.subject, propertiesMap : request.map });
  tester.scenarioSuitesList();

  return null;
}

// --
// relations
// --

let Composes =
{
  // beeping : 0,
}

let Aggregates =
{
}

let Associates =
{
}

let Restricts =
{
  ca : null,
}

let Statics =
{
  Exec,
}

let Forbids =
{
}

let Accessors =
{
}

// --
// declare
// --

let Extension =
{

  // exec

  Exec,
  exec,
  init,

  _commandHandleSyntaxError,
  _commandsMake,

  commandHelp,
  commandVersion,
  commandImply,
  commandRun,
  commandSuitesList,

  // relation

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,
  Accessors,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extension,
});

//

_realGlobal_[ Self.name ] = _global[ Self.name ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

if( !_.instanceIs( _realGlobal_.wTester ) && !_.symbolIs( _realGlobal_.wTester ) )
_realGlobal_.wTester = _global.wTester = new Self().form();

if( Config.interpreter === 'browser' )
debugger;
if( !module.parent )
Self.Exec();

})();
