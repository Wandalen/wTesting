(function(){

'use strict';

// require

if( typeof module !== 'undefined' && typeof Printer === 'undefined' )
{

  /*require( 'include/wTools.s' );*/
  require( './aPrinter.s' )

}

//

var _ = wTools;
var Parent = wPrinter;
var Self = function ()
{
  Self.prototype.init.apply( this,arguments );
}

//

var init = function( options )
{

  var self = this;
  Parent.prototype.init.call( self,options );

  var methods =
  [
    'log', 'debug', 'error',
    'exception', 'info', 'warn',
  ];

  for( var m = 0 ; m < methods.length ; m++ )
  self.bindWriter( methods[ m ],console[ methods[ m ] ],console );

}

//

var _wrapProtoHandler = function( methodName, originalMethod, proto )
{

  return function()
  {
    logger.logUp( proto.constructor.name + '.' + methodName,'(','with',arguments.length,'arguments',')' );
    var result = originalMethod.apply( this,arguments );
    logger.logDown();
    return result;
  }

}

//

var wrapProto = function( proto,options )
{
  var self = this;
  var options = options || {};

  _.assert( _.objectIs( proto ) || _.routineIs( proto ) );

  if( proto.constructor.wrappedByLogger )
  return;

  proto.constructor.wrappedByLogger = true;

  console.log( 'wrapProto:',proto.constructor.name );

  var methods = options.methods || proto;
  for( var r in methods )
  {

    if( r === 'constructor' )
    continue;

    var descriptor = Object.getOwnPropertyDescriptor( proto,r );

    if( !descriptor )
    continue;

    if( !descriptor.configurable )
    continue;

    var routine = proto[ r ];

    if( !_.routineIs( routine ) )
    continue;

    proto[ r ] = _wrapProtoHandler( r,routine,proto );
    proto[ r ].original = routine;

  }

}

//

var unwrapProto = function( proto )
{
  var self = this;
  var options = options || {};

  _.assert( _.objectIs( proto ) || _.routineIs( proto ) );

  if( !proto.constructor.wrappedByLogger )
  return;

  proto.constructor.wrappedByLogger = false;

  console.log( 'unwrapProto:',proto.constructor.name );

  var methods = options.methods || proto;
  for( var r in methods )
  {

    if( r === 'constructor' )
    continue;

    var descriptor = Object.getOwnPropertyDescriptor( proto,r );

    if( !descriptor )
    continue;

    if( !descriptor.configurable )
    {
      continue;
    }

    var routine = proto[ r ];

    if( !_.routineIs( routine ) )
    continue;

    if( !_.routineIs( routine.original ) )
    continue;

    proto[ r ] = routine.original;

  }

}

//

var _hookConsoleToFileHandler = function( wasMethod, methodName, fileName )
{

  return function ()
  {

    var args = arguments;
    //var args = _.arrayAppendMerging( [],arguments,_.stack() );

    wasMethod.apply( console,args );

    if( _.fileWrite )
    {

      var strOptions = { levels : 7 };
      _.fileWrite
      ({
        path: fileName,
        data: _.toStr( args,strOptions ) + '\n',
        append: true,
      });

    }

  };

}

//

var hookConsoleToFile = function( fileName )
{
  var self = this;

  require( 'include/abase/component/Path.s' );
  require( 'include/Files.ss' );

  fileName = fileName || 'log.txt';
  fileName = _.pathJoin( _.pathMainDir(),fileName );

  console.log( 'hookConsoleToFile:',fileName );

  for( var i = 0, l = self._methods.length; i < l; i++ )
  {
    var m = self._methods[ i ];
    if( m in console )
    {
      var wasMethod = console[ m ];
      console[ m ] = self._hookConsoleToFileHandler( wasMethod,m,fileName );
    }
  }

/*
  if( typeof window !== 'undefined' )
  window.onerror = function( msg, url, line )
  {
    alert( 'Window error: ' + msg + ', ' + url + ', line ' + line );
  };
*/

}

//

var _hookConsoleToAlertHandler = function( wasMethod, methodName )
{

  return function ()
  {

    var args = _.arrayAppendMerging( [],arguments,_.stack() );

    wasMethod.apply( console,args );
    alert( args.join( '\n' ) );

  }

}

//

var hookConsoleToAlert = function()
{
  var self = this;

  console.log( 'hookConsoleToAlert' );

  for( var i = 0, l = self._methods.length; i < l; i++ )
  {
    var m = self._methods[ i ];
    if( m in console )
    {
      var wasMethod = console[ m ];
      console[ m ] = self._hookConsoleToAlertHandler( wasMethod,m );
    }
  }

/*
  if( typeof window !== 'undefined' )
  window.onerror = function( msg, url, line )
  {
    alert( 'Window error: ' + msg + ', ' + url + ', line ' + line );
  };
*/

}

//

var _hookConsoleToDomHandler = function( options, wasMethod, methodName )
{

  return function()
  {

    /*var args = _.arrayAppendMerging( [],arguments,_.stack() );*/
    wasMethod.apply( console,arguments );
    var text = [].join.call( arguments,' ' );
    options.consoleDom.prepend( '<p>' + text + '</p>' );

  }

}

//

var hookConsoleToDom = function( options )
{
  var self = this;
  var options = options || {};
  var $ = jQuery;

  $( document ).ready( function( )
  {

    if( !options.dom )
    options.dom = $( document.body );

    var consoleDom = options.consoleDom = $( '<div>' ).appendTo( options.dom );
    consoleDom.css
    ({
      'display' : 'block',
      'position' : 'absolute',
      'bottom' : '0',
      'width' : '100%',
      'height' : '50%',
      'z-index' : '10000',
      'background-color' : 'rgba( 255,0,0,0.1 )',
      'overflow-x' : 'hidden',
      'overflow-y' : 'auto',
      'padding' : '1em',
    });

    console.log( 'hookConsoleToDom' );

    for( var i = 0, l = self._methods.length; i < l; i++ )
    {
      var m = self._methods[ i ];
      if( m in console )
      {
        var wasMethod = console[ m ];
        console[ m ] = self._hookConsoleToDomHandler( options,wasMethod,m );
      }
    }

  });

}

//

var _hookConsoleToServerSend = function( options, data )
{
  var self = this;

  var request = $.ajax
  ({
    url: options.url,
    crossDomain: true,
    method: 'post',
    /*dataType: 'json',*/
    data: JSON.stringify( data ),
    error: _.routineBind( self.unhookConsole,self,[ false ] ),
  });

}

//

var _hookConsoleToServerHandler = function( options, originalMethod, methodName )
{
  var self = this;

  return function()
  {

    originalMethod.apply( console,arguments );
    var text = [].join.call( arguments,' ' );
    var data = {};
    data.text = text;
    data.way = 'message';
    data.method = methodName;
    data.options = options;

    self._hookConsoleToServerSend( options,data );

  }

}

//

var hookConsoleToServer = function( options )
{
  var self = this;

  if( console._hook )
  return;

  console._hook = 'hookConsoleToServer';

  // var

  var $ = jQuery;
  var options = options || {};
  var optionsDefault =
  {
    url : null,
    id : null,
    pathname : '/log',
  }

  throw _.err( 'not tested' );

  _.assertMapOnly( options,optionsDefault,_.urlMake.components,undefined );
  _.mapSupplement( options,optionsDefault );

  if( !options.url )
  options.url = _.urlFor( options );

  if( !options.id )
  options.id = _.numberRandomInt( 1 << 30 );

  console.log( 'hookConsoleToServer:',options.url );

  //

  for( var i = 0, l = self._methods.length; i < l; i++ )
  {
    var m = self._methods[ i ];
    if( m in console )
    {
      var originalMethod = console[ m ];
      console[ m ] = self._hookConsoleToServerHandler( options,originalMethod,m );
      console[ m ].original = originalMethod;
    }
  }

  // handshake

  var data = {};
  data.way = 'handshake';
  data.options = options;

  self._hookConsoleToServerSend( options,data );

}

//

var unhookConsole = function( force )
{
  var self = this;

  if( !console._hook && !force )
  return;

  console._hook = false;
  console.log( 'unhookConsole:' );

  for( var i = 0, l = self._methods.length; i < l; i++ )
  {
    var m = self._methods[ i ];
    if( m in console )
    {
      _.assert( _.routineIs( console[ m ].original ) );
      console[ m ] = console[ m ].original;
    }
  }

}

//

var _methods =
[
  'log', 'assert', 'clear', 'count',
  'debug', 'dir', 'dirxml', 'error',
  'exception', 'group', 'groupCollapsed',
  'groupEnd', 'info', 'profile', 'profileEnd',
  'table', 'time', 'timeEnd', 'timeStamp',
  'trace', 'warn'
];

// --
// prototype
// --

var Proto =
{

  init : init,

  _wrapProtoHandler : _wrapProtoHandler,
  wrapProto : wrapProto,
  unwrapProto : unwrapProto,

  _hookConsoleToFileHandler : _hookConsoleToFileHandler,
  hookConsoleToFile : hookConsoleToFile,

  _hookConsoleToAlertHandler : _hookConsoleToAlertHandler,
  hookConsoleToAlert : hookConsoleToAlert,

  _hookConsoleToDomHandler : _hookConsoleToDomHandler,
  hookConsoleToDom : hookConsoleToDom,

  _hookConsoleToServerSend: _hookConsoleToServerSend,
  _hookConsoleToServerHandler : _hookConsoleToServerHandler,
  hookConsoleToServer : hookConsoleToServer,

  unhookConsole : unhookConsole,

  // var

  _methods : _methods,

};

Self.prototype = Object.create( Parent.prototype );
_.mapExtend( Self.prototype,Proto );

// --
// export
// --

if (typeof module !== 'undefined' && module !== null)
{
  module[ 'exports' ] = Self;
}
else if (typeof window !== 'undefined' && window !== null)
{
  window[ 'Logger' ] = Self;
}

_global_.wLogger = wTools.Logger = Self;

return Self;

})();

var logger = _global_.logger = new wLogger();
_global_[ 'logger' ] = logger;
logger.log = logger[ 'log' ];
logger.logUp = logger[ 'logUp' ];
logger.logDown = logger[ 'logDown' ];

//if( typeof require !== 'undefined' )
//logger.hookConsoleToFile(); // xxx

//if( typeof require === 'undefined' )
//logger.hookConsoleToAlert(); // xxx

//logger.hookConsoleToDom();
