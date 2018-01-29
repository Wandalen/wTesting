#! /usr/bin/env node

if( typeof module !== "undefined" )
{

  _SeparatingTester_ = 1;
  require( './aBase.debug.s' );
  _SeparatingTester_ = 0;
  wTester.exec();

  // require( './aBase.debug.s' );
  // var _ = wTools;
  // _.Tester.exec();

}
