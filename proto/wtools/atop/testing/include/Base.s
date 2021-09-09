( function _Base_s_()
{

'use strict';

/* !!! try to tokenize the file */

if( typeof module !== 'undefined' )
{

  if( !_global_.wBase || _global_.__GLOBAL_NAME__ !== 'real' )
  {
    let toolsPath = '../../../../node_modules/Tools';
    let _externalTools = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      _externalTools = 1;
      require( 'wTools' );
    }
    if( !_externalTools )
    require( toolsPath );
  }

  const _global = _global_;
  const _ = _global_.wTools;

  _.include( 'wLooker' );
  _.include( 'wSelector' );
  _.include( 'wEqualer' );
  _.include( 'wProcessWatcher' );
  _.include( 'wProcess' );
  _.include( 'wIntrospectorExtra' );
  _.include( 'wCopyable' );
  _.include( 'wInstancing' );
  _.includeFirst( 'wEventHandler', _.optional );
  _.include( 'wLogger' );
  _.include( 'wConsequence' );
  _.include( 'wFiles' );
  _.include( 'wColor' );
  _.include( 'wStringsExtra' );
  _.include( 'wCommandsAggregator' );

  // _.includeFirst( 'wScriptLauncher' );

  _.assert( !_realGlobal_.wTester || !_realGlobal_.wTester._isReal_, 'wTester is already included' );

}

})();
