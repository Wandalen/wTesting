#! /usr/bin/env node

if( typeof module !== 'undefined' )
{
  let _ = require( '../../Tools.s' );
  _.include( 'wFiles' );
  _.include( 'wExternalFundamentals' );
}

let _ = wTools;
let shell = _.shell
({
  execPath : 'debugnode ' + _.path.join( __dirname, 'MainTop.s' ),
  verbosity : 0,
  passingThrough : 1,
  applyingExitCode : 1,
});
