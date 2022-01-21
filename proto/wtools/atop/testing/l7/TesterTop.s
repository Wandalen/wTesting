( function _TesterTop_s_()
{

'use strict';

if( Config.interpreter === 'browser' )
debugger;

const _global = _global_;
const _ = _global.wTools;

_.assert( _.mapIs( _realGlobal_.wTester ) );

//

const Parent = _realGlobal_.wTesterBasic;
const Self = wTesterCli;
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
  let cui = new this.Self();
  cui.form();
  return cui.exec();
}

//

function exec()
{
  let cui = this;

  _.assert( _.instanceIs( cui ) );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  let logger = cui.logger;
  let fileProvider = cui.fileProvider;
  // let appArgs = _.process.input({ keyValDelimeter : 0 });
  let appArgs = _.process.input();
  let aggregator = cui._commandsMake();

  return _.Consequence.Try( () =>
  {
    return aggregator.programPerform
    ({
      program : _.strUnquote( appArgs.original ),
      withParsed : 0,
      severalValues : 1,
      subjectWinPathsMaybe : Config.interpreter === 'njs' ? process.platform === 'win32' : false,
    });
  })
  .finally( ( err, arg ) =>
  {
    if( err )
    {
      _.process.exitCode( -1 );
      err = _.err( err );
      logger.error( _.errOnce( err ) );
      throw err;
    }
    return arg;
  });
}

//
// function exec()
// {
//   let cui = this;
//
//   _.assert( _.instanceIs( cui ) );
//   _.assert( arguments.length === 0, 'Expects no arguments' );
//
//   let logger = cui.logger;
//   let fileProvider = cui.fileProvider;
//   let appArgs = _.process.input({ keyValDelimeter : 0 });
//   let aggregator = cui._commandsMake();
//
//   return aggregator.appArgsPerform({ appArgs });
// }


//

function init( o )
{
  const cui = this;
  return Parent.prototype.init.apply( cui, arguments );
}

//

function _commandHandleSyntaxError( o )
{
  const cui = this;
  const aggregator = cui.aggregator;
  const subjectWinPathsMaybe = Config.interpreter === 'njs' ? process.platform === 'win32' : false;
  const request = _.strRequestParse({ src : o.command, subjectWinPathsMaybe });
  return aggregator.instructionPerform({ command : '.run ' + request.subject, propertiesMap : request.map });
}

//

function _commandsMake()
{
  let cui = this;
  let logger = cui.logger;
  let fileProvider = cui.fileProvider;
  let appArgs = _.process.input();

  _.assert( _.instanceIs( cui ) );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  /*
  qqq : make possible to use any convention: .suites.list, suites list, suites.list
  */

  let commands =
  {

    'help' :                    { ro : _.routineJoin( cui, cui.commandHelp ),                        h : 'Get help.' },
    'version' :                 { ro : _.routineJoin( cui, cui.commandVersion ),                     h : 'Get information about version.' },
    'imply' :                   { ro : _.routineJoin( cui, cui.commandImply ),                       h : 'Change state or imply value of a variable.' },
    'context' :                 { ro : _.routineJoin( cui, cui.commandContext ),                     h : 'Change existed context variables to defined value.' },
    'run' :                     { ro : _.routineJoin( cui, cui.commandRun ),                         h : 'Run test suites found at a specified path.' },
    'suites list' :             { ro : _.routineJoin( cui, cui.commandSuitesList ),                  h : 'Find test suites at a specified path.' },

  }

  let aggregator = cui.aggregator = _.CommandsAggregator
  ({
    basePath : fileProvider.path.current(),
    commands,
    commandPrefix : 'node ',
    logger : cui.logger,
    onSyntaxError : ( o ) => cui._commandHandleSyntaxError( o ),
    commandsImplicitDelimiting : 1,
  })

  _.assert( aggregator.logger === cui.logger );
  _.assert( aggregator.logger.verbosity === cui.verbosity );

  aggregator.form();

  return aggregator;
}

//

function commandHelp( e )
{
  let cui = this;
  let aggregator = e.aggregator;
  let logger = cui.logger;

  logger.log( 'Known commands' );
  aggregator._commandHelp( e );
  cui.scenarioOptionsList();
}

//

function commandVersion( e )
{
  let cui = this.form();
  return _.npm.versionLog
  ({
    localPath : _.path.join( __dirname, '../../../../..' ),
    remotePath : 'wTesting',
    tags : [ 'latest', 'stable' ],
    logger : cui.logger
  });
}

var command = commandVersion.command = Object.create( null );
command.hint = 'Get information about version.';

//

/*
qqq : implement and cover by medium tests command .imply
*/

function commandImply( e )
{
  let cui = this.form();

  cui.appArgsRead({ subject : e.subject, propertiesMap : e.propertiesMap });
}

//

function commandContext( e )
{
  let cui = this.form();

  cui.formContext( e.propertiesMap );
}

//

function commandRun( e )
{
  let cui = this.form();

  cui.appArgsRead({ subject : e.subject, propertiesMap : e.propertiesMap });
  cui.scenarioTest();

  return null;
}

//

function commandSuitesList( e )
{
  let cui = this.form();

  cui.appArgsRead({ subject : e.subject, propertiesMap : e.propertiesMap });
  cui.scenarioSuitesList();

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
  aggregator : null,
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
  commandContext,
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
