'use strict';

declare let wTestSuite:any;
declare let wTester:any;
declare let _globals_:any;

require( 'wTesting' );

//

const Suite =
{
    silencing: 1,
    abstract: 1,
}

//

export const Self = wTestSuite( Suite );
