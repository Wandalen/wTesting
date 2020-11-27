( function _Puppeteer_test_s_()
{

'use strict';

let Puppeteer;

if( typeof module !== 'undefined' )
{
  let _ = require( '../../Tools.s' );

  require( '../testing/entry/Main.s' );
  _.include( 'wFiles' );

  Puppeteer = require( 'puppeteer' );
}

let _global = _global_;
let _ = _global_.wTools;

// --
// context
// --

function onSuiteBegin()
{
  let self = this;

  self.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..'  ), 'Tester' );
  self.assetsOriginalPath = _.path.join( __dirname, '_asset' );
  self.appJsPath = _.path.nativize( _.path.join( _.path.normalize( __dirname ), '../testing/entry/Exec' ) );
  self.toolsPath = _.path.nativize( _.path.join( _.path.normalize( __dirname ), '../../Tools.s' ) );
  self.puppeteerPath = require.resolve( 'puppeteer' );
}

//

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.suiteTempPath, 'Tester' ) )
  _.path.tempClose( self.suiteTempPath );
}

//

function assetFor( test, asset )
{
  let self = this;
  let a = test.assetFor( asset );

  a.reflect = function reflect()
  {

    let reflected = a.fileProvider.filesReflect({ reflectMap : { [ a.originalAssetPath ] : a.routinePath }, onUp });

    reflected.forEach( ( r ) =>
    {
      if( r.dst.ext !== 'js' && r.dst.ext !== 's' )
      return;
      var read = a.fileProvider.fileRead( r.dst.absolute );
      read = _.strReplace( read, `'wTesting'`, `'${_.strEscape( self.appJsPath )}'` );
      read = _.strReplace( read, `'wTools'`, `'${_.strEscape( self.toolsPath )}'` );
      read = _.strReplace( read, `require( 'puppeteer' )`, `require( '${_.strEscape( self.puppeteerPath )}' )` );
      a.fileProvider.fileWrite( r.dst.absolute, read );
    });

  }

  return a;

  function onUp( r )
  {
    if( !_.strHas( r.dst.relative, '.atest.' ) )
    return;
    let relative = _.strReplace( r.dst.relative, '.atest.', '.test.' );
    r.dst.relative = relative;
    _.assert( _.strHas( r.dst.absolute, '.test.' ) );
  }

}

// --
// tests
// --

function html( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetsOriginalPath, 'puppeteer' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
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
      test.true( _.strEnds( got, 'index.html' ) );
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
    ready.deasync();
    ready.sync();
  }
}

//

async function htmlAwait( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetsOriginalPath, 'puppeteer' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let indexHtmlPath = _.path.join( routinePath, 'index.html' );

  _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : routinePath } })

  let browser = await Puppeteer.launch({ headless : false });
  let page = await browser.newPage();

  let path = 'file:///' + _.path.nativize( indexHtmlPath );
  await page.goto( path, { waitUntil : 'load' } );

  test.case = 'Check element text'
  var got = await page.$eval( '.class1 p', ( e ) => e.innerText );
  test.identical( got, 'Text1' )

  test.case = 'Check href attribute'
  var got = await page.$eval( '.class1 a', ( e ) => e.href );
  test.true( _.strEnds( got, 'index.html' ) );

  test.case = 'Check input field value'
  var got = await page.$eval( '#input1', ( e ) => e.value )
  test.identical( got, '123' )

  test.case = 'Change input field value and check it'
  await page.$eval( '#input1', ( e ) => { e.value = '321' })
  var got = await page.$eval( '#input1', ( e ) => e.value )
  test.identical( got, '321' );

  await browser.close();

  return null;
}

//

// function html2( test )
// {
//   let self = this;
//   let originalDirPath = _.path.join( self.assetsOriginalPath, 'puppeteer' );
//   let routinePath = _.path.join( self.suiteTempPath, test.name );
//   let indexHtmlPath = _.path.join( routinePath, 'index.html' );

//   _.fileProvider.filesReflect({ reflectMap : { [ originalDirPath ] : routinePath } })

//   let puppeteer = setup();
//   let browser = puppeteer.launch({ headless : false })
//   let page = browser.newPage();

//   let path = 'file:///' + _.path.nativize( indexHtmlPath );
//   page.goto( path, { waitUntil : 'load' } );

//   var got = page.$eval( '.class1 p', ( e ) => e.innerText )
//   test.identical( got, 'Text1' )

//   var got = page.$eval( '.class1 a', ( e ) => e.href )
//   test.true( _.strEnds( got,'index.html' ) );

//   var got = page.$eval( '#input1', ( e ) => e.value )
//   test.identical( got, '123' );

//   browser.close();

//   /* */

//   function setup()
//   {
//     let handler =
//     {
//       get( target, key, receiver )
//       {
//         let value = Reflect.get( target, key, receiver );
//         if ( !_.routineIs( value ) )
//         return value;
//         return function (...args)
//         {
//           let result = value.apply( this, args );
//           var con = _.Consequence.From( result );
//           con.deasync();
//           result = con.sync();
//           if( _.objectIs( result ) )
//           return new Proxy( result, handler )
//           return result;
//         }
//       }
//     }

//     return new Proxy( Puppeteer, handler );
//   }
// }

//

function chaining( test )
{
  let self = this;
  let originalDirPath = _.path.join( self.assetsOriginalPath, 'puppeteer' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
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
    .then( ( text ) =>
    {
      test.identical( text, 'Text1' )
      return null;
    })
  })

  ready.then( async () =>
  {
    let pages = await browser.pages();
    await _.Consequence.And( ... pages.map( ( p ) => p.close() ) )
    await browser.close() //qqq Phantom bug: https://github.com/puppeteer/puppeteer/issues/6341
    return null;
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

function waitForVisibleInViewportThrowing( test )
{
  let self = this;
  let a = self.assetFor( test, 'puppeteer' );
  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = ''
    return null;
  })

  a.appStartNonThrowing({ execPath : `Puppeteer.test.s r:waitForVisibleInViewportThrowing v:7 ` })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    test.identical( _.strCount( got.output, 'Waiting for selector "p" failed' ), 1 );
    test.identical( _.strCount( got.output, 'waiting for function failed: timeout 1ms exceeded' ), 1 );
    test.identical( _.strCount( got.output, `had zombie process` ), 0 );
    return null;
  })

  /* - */

  return a.ready;
}


//

function processWatchingOnPuppeteerZombie( test )
{
  let self = this;
  let a = self.assetFor( test, 'puppeteer' );
  a.reflect();

  /* - */

  a.ready
  .then( () =>
  {
    test.case = ''
    return null;
  })

  a.appStartNonThrowing({ execPath : `Puppeteer.test.s r:routineTimeOut ` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 2 error' ), 2 );
    test.identical( _.strCount( got.output, `had zombie process` ), 1 );
    return null;
  })

  a.appStartNonThrowing({ execPath : `Puppeteer.test.s r:puppeteerTimeOut ` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 2 error' ), 2 );
    test.identical( _.strCount( got.output, `had zombie process` ), 1 );
    return null;
  })

  a.appStartNonThrowing({ execPath : `Puppeteer.test.s r:errorInTest ` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 2 error' ), 2 );
    test.identical( _.strCount( got.output, `had zombie process` ), 1 );
    return null;
  })

  a.appStartNonThrowing({ execPath : `Puppeteer.test.s r:clientContinuesToWorkAfterTest ` })
  .then( ( got ) =>
  {
    test.notIdentical( got.exitCode, 0 );

    test.identical( _.strCount( got.output, 'Thrown 1 error' ), 2 );
    test.identical( _.strCount( got.output, `had zombie process` ), 1 );
    return null;
  })

  /* - */

  return a.ready;
}

// --
// suite
// --

let Self =
{

  name : 'Tools.Tester.Puppeteer',
  silencing : 0,
  enabled : 1,

  onSuiteBegin,
  onSuiteEnd,
  routineTimeOut : 300000,

  context :
  {
    assetFor,

    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null,
    toolsPath : null,
    puppeteerPath : null
  },

  tests :
  {
    html,
    htmlAwait,
    // html2,
    chaining,
    waitForVisibleInViewportThrowing,
    processWatchingOnPuppeteerZombie
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
