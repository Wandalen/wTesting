
const _ = require( 'wTesting' );

function onSuiteBegin()
{
  const context = this;
  this.suiteContextVariable = 2;
}

//

function runWithoutChangedContext( test )
{
  const context = this;

  var exp = [ 'suiteContextVariable', 'variableWithDefaultValue', 'variableWithoutDefaultValue' ];
  test.identical( _.props.keys( context ), exp );
  test.identical( context.suiteContextVariable, 2 );
  test.identical( context.variableWithDefaultValue, 1 );
  test.identical( context.variableWithoutDefaultValue, null );
}

//

function runWithChangingSuiteVariable( test )
{
  const context = this;

  var exp = [ 'suiteContextVariable', 'variableWithDefaultValue', 'variableWithoutDefaultValue' ];
  test.identical( _.props.keys( context ), exp );
  test.identical( context.suiteContextVariable, 2 );
  test.identical( context.variableWithDefaultValue, 1 );
  test.identical( context.variableWithoutDefaultValue, null );
}

//

function runWithChangingVariableWithDefaultValue( test )
{
  const context = this;

  var exp = [ 'suiteContextVariable', 'variableWithDefaultValue', 'variableWithoutDefaultValue' ];
  test.identical( _.props.keys( context ), exp );
  test.identical( context.suiteContextVariable, 2 );
  test.identical( context.variableWithDefaultValue, 3 );
  test.identical( context.variableWithoutDefaultValue, null );
}

//

function runWithChangingVariableWithoutDefaultValue( test )
{
  const context = this;

  var exp = [ 'suiteContextVariable', 'variableWithDefaultValue', 'variableWithoutDefaultValue' ];
  test.identical( _.props.keys( context ), exp );
  test.identical( context.suiteContextVariable, 2 );
  test.identical( context.variableWithDefaultValue, 1 );
  test.identical( context.variableWithoutDefaultValue, 3 );
}

//

function runWithChangingSeveralVariables( test )
{
  const context = this;

  var exp = [ 'suiteContextVariable', 'variableWithDefaultValue', 'variableWithoutDefaultValue' ];
  test.identical( _.props.keys( context ), exp );
  test.identical( context.suiteContextVariable, 2 );
  test.identical( context.variableWithDefaultValue, 3 );
  test.identical( context.variableWithoutDefaultValue, 1 );
}

//

function runWithExtendingContext( test )
{
  const context = this;

  var exp = [ 'suiteContextVariable', 'variableWithDefaultValue', 'variableWithoutDefaultValue' ];
  test.identical( _.props.keys( context ), exp );
  test.identical( context.suiteContextVariable, 2 );
  test.identical( context.variableWithDefaultValue, 1 );
  test.identical( context.variableWithoutDefaultValue, null );
}

//

function runWithVectorisingContextVariables( test )
{
  const context = this;

  var exp = [ 'suiteContextVariable', 'variableWithDefaultValue', 'variableWithoutDefaultValue' ];
  test.identical( _.props.keys( context ), exp );
  test.identical( context.suiteContextVariable, 2 );
  test.identical( context.variableWithDefaultValue, [ 1, 2 ] );
  test.identical( context.variableWithoutDefaultValue, [ 'a', 'b' ] );
}

//

function severalRunsWithRewritingByLast( test )
{
  const context = this;

  var exp = [ 'suiteContextVariable', 'variableWithDefaultValue', 'variableWithoutDefaultValue' ];
  test.identical( _.props.keys( context ), exp );
  test.identical( context.suiteContextVariable, 2 );
  test.identical( context.variableWithDefaultValue, 2 );
  test.identical( context.variableWithoutDefaultValue, null );
}

//

function severalRunsWithExtendingByLast( test )
{
  const context = this;

  var exp = [ 'suiteContextVariable', 'variableWithDefaultValue', 'variableWithoutDefaultValue' ];
  test.identical( _.props.keys( context ), exp );
  test.identical( context.suiteContextVariable, 2 );
  test.identical( context.variableWithDefaultValue, 3 );
  test.identical( context.variableWithoutDefaultValue, 1 );
}

//

const Self =
{
  name : 'Context',

  onSuiteBegin,

  context :
  {
    suiteContextVariable : null,
    variableWithDefaultValue : 1,
    variableWithoutDefaultValue : null,
  },

  tests :
  {
    runWithoutChangedContext,
    runWithChangingSuiteVariable,
    runWithChangingVariableWithDefaultValue,
    runWithChangingVariableWithoutDefaultValue,
    runWithChangingSeveralVariables,
    runWithExtendingContext,
    runWithVectorisingContextVariables,
    severalRunsWithRewritingByLast,
    severalRunsWithExtendingByLast,
  },
}

//

const Suite = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Suite.name );
