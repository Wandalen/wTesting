#! /usr/bin/env node

if( typeof module !== "undefined" )
{

  require( './Tester.debug.s' );

  var _ = wTools;

  // if( typeof module !== 'undefined' && !module.parent )
  _.Tester.exec();

}
