(function _Include_base_s_() {

'use strict';

/* !!! try to tokenize the file */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  // if( !_global_.wBase || _global_.WTOOLS_PRIVATE )
  // {
  //   let toolsPath = '../../../dwtools/Base.s';
  //   let _externalTools = 0;
  //   try
  //   {
  //     toolsPath = require.resolve( toolsPath );
  //   }
  //   catch( err )
  //   {
  //     _externalTools = 1;
  //     require( 'wTools' );
  //   }
  //   if( !_externalTools )
  //   require( toolsPath );
  // }

  let _global = _global_;
  // let _ = _global_.wTools;

  debugger;
  _.include( 'wLooker' );
  _.include( 'wSelector' );
  debugger;
  _.include( 'wComparator' );
  _.include( 'wExternalFundamentals' );
  _.include( 'wCopyable' );
  _.include( 'wInstancing' );
  _.includeAny( 'wEventHandler','' );
  _.include( 'wLogger' );
  debugger;
  _.include( 'wConsequence' );
  debugger;
  _.include( 'wFiles' );
  _.include( 'wLogger' );
  _.include( 'wStringsExtra' );

  // _.includeAny( 'wScriptLauncher' );

  _.assert( !_realGlobal_.wTester || !_realGlobal_.wTester._isReal_, 'wTester is already included' );

}

})();
