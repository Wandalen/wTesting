( function _Puppeteer_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../Tools.s' );

  require( '../tester/MainTop.s' );
  _.include( 'wFiles' );

  var Puppeteer = require( 'puppeteer' );
}

var _global = _global_;
var _ = _global_.wTools;

//

function onSuiteBegin()
{
  let self = this;

  self.tempDir = _.path.pathDirTempOpen( _.path.join( __dirname, '../..'  ), 'Tester' );
  self.assetDirPath = _.path.join( __dirname, '_asset' );
}

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.tempDir, 'Tester' ) )
  _.path.pathDirTempClose( self.tempDir );
}

// --
// tests
// --

function html( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetDirPath, 'puppeteer' );
  let routinePath = _.path.join( self.tempDir, test.name );
  let indexHtmlPath = _.path.join( routinePath, 'index.html' );
  let ready = new _.Consequence().take( null )

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : routinePath } })

  let page = null;
  let browser = null;

  setup();

  ready.then( () =>
  {
    let path = 'file:///' + _.path.nativize( indexHtmlPath );
    return page.goto( path, { waitUntil : 'load' } )
  })

  ready.then( () =>
  {
    return page.$eval( '.class1 p', ( e ) => e.innerText )
    .then( ( got ) =>
    {
      test.identical( got, 'Text1' )
      return got;
    })
  })

  ready.then( () =>
  {
    return page.$eval( '.class1 a', ( e ) => e.href )
    .then( ( got ) =>
    {
      test.is( _.strEnds( got,'index.html' ) );
      return got;
    })
  })

  ready.then( () =>
  {
    return page.$eval( '#input1', ( e ) => e.value )
    .then( ( got ) =>
    {
      test.identical( got, '123' )
      return got;
    })
  })

  ready.then( () =>
  {
    return browser.close()
    .then( () => null )
  });

  return ready;

  //

  function setup()
  {
    let ready = Puppeteer.launch({ headless : false })
    .then( ( got ) =>
    {
      browser = got;
      return browser.newPage()
    })
    .then( ( got ) =>
    {
      page = got;
      return got;
    })
    ready = _.Consequence.From( ready );
    return ready.deasync();
  }
}

//

function html2( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetDirPath, 'puppeteer' );
  let routinePath = _.path.join( self.tempDir, test.name );
  let indexHtmlPath = _.path.join( routinePath, 'index.html' );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : routinePath } })

  let puppeteer = setup();
  let browser = puppeteer.launch({ headless : false })
  let page = browser.newPage();

  let path = 'file:///' + _.path.nativize( indexHtmlPath );
  page.goto( path, { waitUntil : 'load' } );

  var got = page.$eval( '.class1 p', ( e ) => e.innerText )
  test.identical( got, 'Text1' )

  var got = page.$eval( '.class1 a', ( e ) => e.href )
  test.is( _.strEnds( got,'index.html' ) );

  var got = page.$eval( '#input1', ( e ) => e.value )
  test.identical( got, '123' );

  browser.close();

  /* */

  function setup()
  {
    let handler =
    {
      get( target, key, receiver )
      {
        let value = Reflect.get( target, key, receiver );
        if ( !_.routineIs( value ) )
        return value;
        return function (...args)
        {
          let result = value.apply( this, args );
          if( _.promiseIs( result ) )
          {
            let ready = new _.Consequence();
            result.then( ( got ) =>
            {
              if( got === undefined )
              got = true
              ready.take( got );
            })
            result.catch( ( err ) => ready.error( err ) )
            result = ready.deasync();
          }
          if( _.objectIs( result ) )
          return new Proxy( result, handler )
          return result;
        }
      }
    }

    return new Proxy( Puppeteer, handler );
  }
}

// --
// suite
// --

var Self =
{

  name : 'Tools.atop.Tester.Puppeteer',
  silencing : 0,
  enabled : 1,

  onSuiteBegin : onSuiteBegin,
  onSuiteEnd : onSuiteEnd,
  routineTimeOut : 300000,

  context :
  {
    tempDir : null,
    assetDirPath : null,
  },

  tests :
  {
    html,
    html2
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
