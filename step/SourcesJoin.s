var _ = require( 'wTools' );

_.include( 'wProcess' );
_.include( 'wFiles' );
_.include( 'wStarter' );

let step = function sourcesJoin( o )
{
  o = _.routine.optionsWithUndefined( step, o || Object.create( null ) )

  let appArgs = _.process.input();
  _.process.inputReadTo
  ({
    dst : o,
    propertiesMap : appArgs.map,
    namesMap : _.map.keys( step.defaults ),
  });

  let starter = new _.starter.System().form();

  o.outPath = _.path.resolve( o.outPath );
  o.basePath = _.path.resolve( o.basePath );

  if( o.modulesList === null )
  o.modulesList = 
  [
    'wTools',
    'wLooker',
    'wSelector',
    'wEqualer',
    'wProcessWatcher',
    'wProcess',
    'wIntrospectorBasic',
    'wCopyable',
    'wInstancing',
    'wEventHandler',
    'wLogger',
    'wConsequence',
    'wFilesBasic',
    'wFiles',
    'wfileshttp',
    'wColor',
    'wStringsExtra',
    'wCommandsAggregator',
    'wReplicator',
    'wPathTools',
    'wPathBasic',
    'wArraySorted',
    'wArraySparse',
    'wBlueprint',
    'wProto',
    'wConsequence',
    'wProcedure',
    'wCloner',
    'wTraverser',
    'wStringer',
    'wGdf',
    'wColor256',
    'wUriBasic',
    'wRegexpObject',
    'wFieldsStack',
    'wVerbal',
    'wweburibasic',
    'wVocabulary'
  ]

  o.inPath =
  {
    filePath :
    [
      _.path.resolve( `proto/wtools/atop/testing/entry/Main.s` ),
      _.path.resolve( `proto/**/*.(js|s)` ),
      _.path.resolve( `proto/node_modules/*` )
    ],
    maskDirectory : { excludeAny : /test$/, includeAny : 'testing' },
    maskTransientDirectory : { excludeAny : /test$/, includeAny : 'testing' }
  }

  _.assert( _.arrayIs( o.modulesList ), 'Expects modules list as array' );

  o.modulesList.forEach( ( module ) => 
  {
    let omodule = module;
    let modulePath = _.path.resolve( `node_modules/${module}` );
    if( !_.fileProvider.fileExists( modulePath ) )
    {
      module = module.toLowerCase();
      modulePath = _.path.resolve( `node_modules/${module}` );
    }

    _.assert( _.fileProvider.fileExists( modulePath ), `Module ${omodule} doesn't exist.` );

    let moduleJsScriptsGlob = _.path.resolve( `node_modules/${module}/proto/**/*.(js|s)` );
    let moduleIncludeScriptsGlob = _.path.resolve( `node_modules/${module}/proto/node_modules/*` )
    
    o.inPath.filePath.push( moduleJsScriptsGlob, moduleIncludeScriptsGlob );
  })

  delete o.modulesList;

  starter.sourcesJoinFiles( o );
}

let defaults = step.defaults = Object.create( null );

defaults.inPath = null;
defaults.modulesList = null;
defaults.basePath = '.';
defaults.entryPath = 'proto/wtools/atop/testing/entry/Main.s';
defaults.outPath = 'out/debug/Main.s';
defaults.interpreter = 'browser';
defaults.redirectingConsole = 0;

module.exports = step;
if( !module.parent )
step();

