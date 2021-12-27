( function _Test_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( 'wTools' );
  _.include( 'wTesting' );
  // require( '../testing/entry/Basic.s' );
  _.include( 'wFiles' );
}

const _global = _global_;
const _ = _global_.wTools;
const __ = _globals_.testing.wTools;

// --
// context
// --

function onSuiteBegin()
{
  let self = this;
}

function onSuiteEnd()
{
  let self = this;
}

// --
// tests
// --

function trivial( test )
{
  test.identical( 1,1 );
}

// --
// declare
// --

const Proto =
{

  name : 'Test',
  silencing : 1,
  enabled : 1,

  onSuiteBegin,
  onSuiteEnd,
  routineTimeOut : 300000,

  context :
  {
  },

  tests :
  {

    trivial
  }

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
