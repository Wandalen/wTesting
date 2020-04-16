( function _Main_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( './include/Top.s' );

}

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _testerGlobal_.wTools;

if( !module.parent )
_realGlobal_.wTester.exec();

})();
