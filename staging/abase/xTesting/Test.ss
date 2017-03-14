#! /usr/bin/env NODE

if( typeof module !== "undefined" )
{

  require( './include/abase/xTesting/Testing.debug.s' );

  var _ = wTools;

  if( typeof module !== 'undefined' && !module.parent )
  _.Testing.exec();

}
