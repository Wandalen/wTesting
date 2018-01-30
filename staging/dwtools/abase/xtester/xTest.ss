#! /usr/bin/env node

if( typeof module !== "undefined" )
{

  // debugger;
  _SeparatingTester_ = 1;
  require( './aBase.debug.s' );
  _SeparatingTester_ = 0;
  // debugger;
  wTester.exec();

  // require( './aBase.debug.s' );
  // var _ = wTools;
  // _.Tester.exec();

}
