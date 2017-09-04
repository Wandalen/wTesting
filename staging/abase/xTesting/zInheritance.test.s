( function _zInheritance_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof wTools === 'undefined' || !wTools.Tester._isFullImplementation )
  require( './cTester.debug.s' );

}

var _ = wTools;

//

function inherit( test )
{
  var routines = [];
  var childSuiteName = 'childSuite';
  var firstParentName = 'parentSuite1';
  var secondParentName = 'parentSuite2';
  var checksCount = 0;

  var notTakingIntoAccount = { logger : wLogger({ output : null }), concurrent : 1, takingIntoAccount : 0 };

  routines.push( test.name );

  // parent 1

  function test1()
  {
    var self = this;

    routines.push( test.name );

    test.description = 'check if child suite runs this test';
    test.identical( _.Tester.activeSuites[ 1 ].name, childSuiteName );
    checksCount += test.checkCurrent()._checkIndex;
  }

  var ParentSuite1 =
  {
    name : firstParentName,
    abstract : 1,
    verbosity : 10,
    override : notTakingIntoAccount,

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

  // parent 2

  function test2()
  {
    var self = this;

    routines.push( test.name );

    test.description = 'check if child suite inherits tests, options, context from parent';
    var tests = _.mapOwnKeys( wTests[ childSuiteName ].tests );
    test.identical( tests, [ 'test1', 'test2' ] );
    test.identical( wTests[ childSuiteName ].abstract, 0 );

    console.log( '_.Tester.settings.verbosity',_.Tester.settings.verbosity );

    if( _.Tester.settings.verbosity !== null && _.Tester.settings.verbosity !== undefined )
    test.identical( wTests[ childSuiteName ].verbosity , _.Tester.settings.verbosity );
    else
    test.identical( wTests[ childSuiteName ].verbosity , wTests[ firstParentName ].verbosity );

    test.identical( wTests[ childSuiteName ].debug, wTests[ secondParentName ].debug );

    test.identical( self.parentValue1 , 1 );
    test.identical( self.parentValue2 , 2 );
    test.identical( self.childValue , 3 );

    checksCount += test.checkCurrent()._checkIndex;

  }

  var ParentSuite2 =
  {
    name : secondParentName,
    abstract : 1,
    debug : 1,
    override : notTakingIntoAccount,

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

  // child

  var childSuite =
  {

    name : childSuiteName,
    abstract : 0,
    override : notTakingIntoAccount,

    tests :
    {
    },

    context :
    {
      childValue : 3
    },

  }

  var suite = new wTestSuite( childSuite )
  .inherit( wTests[ firstParentName ] )
  .inherit( wTests[ secondParentName] );

  return suite.run()
  .doThen( function()
  {
    test.identical( test.report.testCheckPasses + routines.length, checksCount );
    test.identical( test.report.testCheckFails, 0 );
    test.identical( routines.length, 3 );
    test.identical( _.mapOwnKeys( suite.tests ).length, 2 );
  })
}

//

var Proto =
{

  name : 'Inheritance test',
  // verbosity : 5,
  silencing : 1,

  tests :
  {
    inherit : inherit
  },

}

//

var Self = new wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self );

})();
