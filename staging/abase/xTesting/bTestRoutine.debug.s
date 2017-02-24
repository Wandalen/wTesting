(function _bTestRoutine_debug_s_() {

'use strict';

var isBrowser = true;
if( typeof module !== 'undefined' )
{

  isBrowser = false;

  if( typeof wBase === 'undefined' )
  try
  {
    require( '../../abase/wTools.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  var _ = wTools;

}

//

var _ = wTools;
var Parent = null;

// var Self = function wTestRoutine( o )
// {
//   // if( !( this instanceof Self ) )
//   // if( o instanceof Self )
//   // return o;
//   // else
//   // return new( _.routineJoin( Self, Self, arguments ) );
//   // return Self.prototype.init.apply( this,arguments );
// }

//

var Self = function wTestRoutine( o )
{
  // var testRoutineDescriptor = this;
  // var suite = this;
  // var result = null;
  // var report = suite.report;
  // var caseFails = report.caseFails;

  if( ( this instanceof Self ) )
  throw _.err( 'Intended to be called without new' );

  _.routineOptions( wTestRoutine,o );

  var testRoutineDescriptorParent = Object.create( o.suite );
  testRoutineDescriptorParent.constructor = function wTestRoutine(){};
  Object.preventExtensions( testRoutineDescriptorParent );

  var testRoutineDescriptor = Object.create( testRoutineDescriptorParent );
  testRoutineDescriptor.routine = o.routine;
  testRoutineDescriptor.description = '';
  testRoutineDescriptor.suite = o.suite;
  testRoutineDescriptor._caseIndex = 0;
  testRoutineDescriptor._testRoutineDescriptorIs = 1;
  testRoutineDescriptor._storedStates = null;
  Object.preventExtensions( testRoutineDescriptor );

  _.assert( _.routineIs( o.routine ) );
  _.assert( _.strIsNotEmpty( o.routine.name ),'Test routine should have name, few test routine of test suite',o.suite.name,'does not' );
  _.assert( o.routine.name === o.name );
  _.assert( Object.isPrototypeOf.call( wTestSuite.prototype,o.suite ) );
  _.assert( Object.isPrototypeOf.call( wTestSuite.prototype,testRoutineDescriptor ) );
  _.assert( arguments.length === 1 );

  // _.instanceInit( suite );
  //
  // Object.preventExtensions( suite );
  //
  // if( o )
  // suite.copy( o );

  return testRoutineDescriptor;
}

Self.nameShort = 'TestRoutine';

Self.defaults =
{
  name : null,
  routine : null,
  suite : null,
}

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;

return Self;

})();
