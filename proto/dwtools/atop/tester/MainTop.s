( function _MainTop_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( './IncludeTop.s' );

}

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _realGlobal_.wTester;

if( !module.parent )
_realGlobal_.wTester.exec();

})();
