(function _aBase_debug_s_() {

'use strict';

/*

+ implement test case tracking
+ move test routine methods out of test suit
+ implement routine only as option of test suit
+ adjust verbosity levels
+ make possible switch off parents test routines : fileStat : null
+ make "should/must not error" pass original messages through
  test.description = 'mustNotThrowError must return con with message';

  var con = new _.Consequence().give( '123' );
  test.mustNotThrowError( con )
  .ifNoErrorThen( function( got )
  {
    test.identical( got, '123' );
  })

+ improve inheritance
+ global search cant find test suits with inheritance
+ after the last test case of test routine description should be changed
+ test.identical( undefined,undefined ) -> strange output, replacing undefined by null!
+ test suit should not pass if 0 / 0 test checks
+ track number of thrown errors
+ global / suit / routine basis statistic tracking
+ fails issue
+ implement silencing from test suit
+ no suit/tester sanitare period if errror
+ issue if first test suit has silencing:0 and other silencing:1
+ less static information with verbosity:7, to introduce higher verbosity levels
+ when error not throwen under test.mustNotThrowError have "error was not thrown asynchronously, but expected"
+ implement scenario options.list

- print information about case with color directive avoiding change of color state of logger

- implement support of glob path

- manual launch of test suit + global tests execution should not give extra test suit runs

- run test suit only once, even if asked several

- time measurements of testing

- sort-cuts for command line otpions : h,r..

- warning if command line option is strange

- warning if test routine has unknown fields

- warning if no test suit under path found

- make onSuitBegin, onSuitEnd asynchronous

- tester should has its own copy of environment, even if included from test suit file

- checkers ( identical, contain, equivalent ... ) should return boolean

*/

var _global = undefined;
if( !_global && typeof Global !== 'undefined' && Global.Global === Global ) _global = Global;
if( !_global && typeof global !== 'undefined' && global.global === global ) _global = global;
if( !_global && typeof window !== 'undefined' && window.window === window ) _global = window;
if( !_global && typeof self   !== 'undefined' && self.self === self ) _global = self;
var _globalReal = _global;
var _globalWas = _global._global_;
if( _global._global_ )
_global = _global._global_;
_global._global_ = _global;
_globalReal._globalReal_ = _globalReal;

if( _globalReal_._SeparatingTester_ )
{
  _global = _global._global_ = Object.create( _global._global_ );
  _global._UsingWtoolsPrivately_ = true;
  _global._globalWas_ = _globalWas;
}

if( typeof module !== 'undefined' )
{

  if( !_global_.wBase || _global_._UsingWtoolsPrivately_ )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let _externalTools = 0;
    try
    {
      require.resolve( toolsPath );
    }
    catch( err )
    {
      _externalTools = 1;
      require( 'wTools' );
    }
    if( !_externalTools )
    require( toolsPath );
  }

  var _ = _global_.wTools;

  _.include( 'wCopyable' );
  _.include( 'wInstancing' );
  _.includeAny( 'wEventHandler','' );
  _.include( 'wConsequence' );
  _.include( 'wFiles' );
  _.include( 'wLogger' );

  _.assert( !_globalReal_.wTester || !_globalReal_.wTester._isFullImplementation,'wTester is already included' );

  // _.includeAny( 'wScriptLauncher' );

  require( './aTestSuit.debug.s' );
  require( './bTestRoutine.debug.s' );
  require( './cTester.debug.s' );
  require( './zLast.debug.s' );

}

})();
