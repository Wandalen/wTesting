'use strict';

declare let wTestSuite:any;
declare let wTester:any;
declare let _globals_:any;

require( 'wTesting' );

import { Self as Abstract } from './Abstract.test';

const __ = _globals_.testing.wTools;

//

function trivial ( test:any )
{
  let ready = __.take( true );
  ready.then( ( got:boolean ) =>
  {
    test.true( got );
    return null;
  })
  return ready;
}

//

const Suite =
{
  silencing: 1,

  tests :
  {
    trivial
  }
}

//

export const Self = wTestSuite( Suite ).inherit( Abstract );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
