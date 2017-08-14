( function _zInheritance_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof wTools === 'undefined' || !wTools.Tester._isFullImplementation )
  require( './cTester.debug.s' );

  var _ = wTools;

}

var _ = wTools;
var routines = [];
var childSuiteName = 'childSuite';
var firstParentName = 'parentSuite1';
var secondParentName = 'parentSuite2';

/* Parent 1 */

function test1( test )
{
  var self = this;

  routines.push( test.name );

  test.description = 'check if child suite runs this test';
  test.identical( _.Tester.activeSuites[ 0 ].name, childSuiteName );
}

var ParentSuite1 =
{
  name : firstParentName,
  abstract : 1,
  verbosity : 10,

  context :
  {
    parentValue1 : 1
  },

  tests :
  {
    test1 : test1
  },

};

wTestSuite( ParentSuite1 );


/* Parent 2 */


function test2( test )
{
  var self = this;

  routines.push( test.name );

  test.description = 'check if child suite inherits tests, options, context from parent';
  var tests = _.mapOwnKeys( wTests[ childSuiteName ].tests );
  test.identical( tests, [ 'test1', 'test2' ] );
  test.identical( wTests[ childSuiteName ].abstract, 0 );
  test.identical( wTests[ firstParentName ].verbosity , wTests[ childSuiteName ].verbosity );
  test.identical( wTests[ secondParentName ].debug , wTests[ childSuiteName ].debug );

  test.identical( self.parentValue1 , 1 );
  test.identical( self.parentValue2 , 2 );
  test.identical( self.childValue , 3 );
}

var ParentSuite2 =
{
  name : secondParentName,
  abstract : 1,
  debug : 1,

  context :
  {
    parentValue2 : 2
  },

  tests :
  {
    test2 : test2
  },

};

wTestSuite( ParentSuite2 );

// --
// proto
// --

function onSuiteEnd( t )
{
  _.assert( routines.length === _.mapOwnKeys( t.tests ).length, 'All test routines must be executed' );
}
var childSuite =
{

  name : childSuiteName,
  abstract : 0,
  onSuiteEnd : onSuiteEnd,

  tests :
  {
  },

  context :
  {
    childValue : 3
  },


}

var Self = new wTestSuite( childSuite )
.inherit( wTests[ firstParentName ] )
.inherit( wTests[ secondParentName] );

if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();
