#! /usr/bin/env node

if( typeof module !== 'undefined' ) /*bbb*/
{

  _SeparatingTester_ = 1;
  require( './aBase.debug.s' );
  _SeparatingTester_ = 0;
  wTester.exec();

}
