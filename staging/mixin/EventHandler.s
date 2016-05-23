(function(){

'use strict';

/*
var wEventHandler = function()
{
  Self.prototype.init.apply( this,arguments );
};
*/

/*var Self = {};*/
var _ = wTools;

//

/**
 * Mixin this methods into prototype of another object.
 * @param {object} dst - prototype of another object.
 * @method copy
 * @memberof wEventHandler#
 */

var mixin = function( dst )
{

  _.mixin
  ({
    dst : dst,
    Proto : Proto,
    Functors : Functors,
    name : 'EventHandler',
  });

  _.accessorForbid( dst,
  {
    _eventHandlers : '_eventHandlers',
    _eventHandlerOwners : '_eventHandlerOwners',
  });

  _.assert( dst.Restricts._eventHandlerDescriptors );

}

// --
// Functor
// --

/**
 * Functor to produce init.
 * @param {object} Prototype - prototype of another object.
 * @method init
 * @memberof wEventHandler#
 */

var init = function( Prototype )
{

  var originalInit = Prototype.init;

  return function initEventHandler()
  {
    var self = this;
    var result = originalInit.apply( self,arguments );

    self.eventHandle( 'init' );

    return result;
  }

}

//

/**
 * Functor to produce finit.
 * @param {object} Prototype - prototype of another object.
 * @method finit
 * @memberof wEventHandler#
 */

var finit = function( Prototype )
{

  var originalFinit = Prototype.finit;
/*
  if( !originalFinit )
  {
    debugger;
    console.warn( 'finit is not defined' );
    return;
  }
*/
  return function finitEventHandler()
  {
    var self = this;

    self.eventHandle( 'finit' );

    if( originalFinit )
    var result = originalFinit.apply( self,arguments );

    self.eventHandlerUnregister();

    return result;
  }

}

// --
// register
// --

var eventHandlerRegister = function( kind, onHandle )
{
  var self = this;
  var owner;

  _.assert( arguments.length === 2 || arguments.length === 3,'eventHandlerRegister:','expects "kind" and "onHandle" as arguments' );

  if( arguments.length === 3 )
  {
    owner = arguments[ 1 ];
    onHandle = arguments[ 2 ];
  }

  var descriptor =
  {
    kind : kind,
    onHandle : onHandle,
    owner : owner,
  }

  self._eventHandlerRegister( descriptor );

  return self;
}

//

var eventHandlerRegisterOneTime = function( kind, onHandle )
{
  var self = this;
  var owner;

  _.assert( arguments.length === 2 || arguments.length === 3,'eventHandlerRegisterOneTime:','expects "kind" and "onHandle" as arguments' );

  if( arguments.length === 3 )
  {
    owner = arguments[ 1 ];
    onHandle = arguments[ 2 ];
  }

  var descriptor =
  {
    kind : kind,
    onHandle : onHandle,
    owner : owner,
    once : 1,
  }

  self._eventHandlerRegister( descriptor );

  return self;
}

//

var _eventHandlerRegister = function _eventHandlerRegister( descriptor )
{
  var self = this;
  var handlers = self._eventHandlerDescriptorsByKind( descriptor.kind );

  // verification

  _.assert( _.strIs( descriptor.kind ) );
  _.assert( _.routineIs( descriptor.onHandle ) );
  _.assertMapOnly( descriptor,_eventHandlerRegister.defaults );
  _.assert( arguments.length === 1 );

  if( self._eventKinds && self._eventKinds.indexOf( kind ) === -1 )
  throw _.err( 'eventHandlerRegister:','Object does not support such kind of events:',kind,self );

  // once

  if( descriptor.once )
  if( self._eventHandlerDescriptorByKindAndHandler( descriptor.kind,descriptor.onHandle ) )
  return self;

  descriptor.onHandleEffective = descriptor.onHandle;
  if( descriptor.once )
  descriptor.onHandleEffective = function handleOnce()
  {
    var result = descriptor.onHandle.apply( this,arguments );

    self._eventHandlerUnregister
    ({
      kind : descriptor.kind,
      onHandle : descriptor.onHandle,
      strict : 0,
    });

    return result;
  }
  // owner

  if( descriptor.owner !== undefined && descriptor.owner !== null )
  self.eventHandlerUnregisterByKindAndOwner( descriptor.kind,descriptor.owner );

  //

  handlers.push( descriptor );

  // kinds

  if( self._eventKinds )
  {
    _.arrayAppendOnce( self._eventKinds,kind );
    debugger;
  }

  return self;
}

_eventHandlerRegister.defaults =
{
  kind : null,
  onHandle : null,
  owner : null,
  proxy : 0,
  once : 0,
}

// --
// unregister
// --

var eventHandlerUnregister = function( kind, onHandle )
{
  var self = this;

  var handlers = self._eventHandlerDescriptors;
  if( !handlers )
  return self;

  if( arguments.length === 0 )
  {

    self._eventHandlerUnregister({});

  }
  else if( arguments.length === 1 )
  {

    if( _.strIs( arguments[ 0 ] ) )
    {

      self._eventHandlerUnregister
      ({
        kind : arguments[ 0 ],
      });

    }
    else if( _.routineIs( arguments[ 0 ] ) )
    {

      self._eventHandlerUnregister
      ({
        onHandle : arguments[ 0 ],
      });

    }
    else throw _.err( 'unexpected' );

  }
  else if( arguments.length === 2 )
  {

    if( _.strIs( onHandle ) )
    self._eventHandlerUnregister
    ({
      kind : kind,
      owner : onHandle,
    });
    else
    self._eventHandlerUnregister
    ({
      kind : kind,
      onHandle : onHandle,
    });

  }
  else throw _.err( 'unexpected' );

  return self;
}

//

var _eventHandlerUnregister = function( options )
{
  var self = this;

/*
  if( self.name === 'cells cloud' )
  debugger;
*/

  _.assert( arguments.length === 1 );
  _.assertMapOnly( options,_eventHandlerUnregister.defaults );
  if( options.strict === undefined )
  options.strict = 1;

  var handlers = self._eventHandlerDescriptors;
  if( !handlers )
  return self;

  var length = Object.keys( options ).length;

  if( options.kind !== undefined )
  _.assert( _.strIs( options.kind ),'eventHandlerUnregister:','expects "kind" as string' );

  if( options.onHandle !== undefined )
  _.assert( _.routineIs( options.onHandle ),'eventHandlerUnregister:','expects "onHandle" as routine' );

  if( length === 0 )
  {

    for( var h in handlers )
    handlers[ h ].splice( 0,handlers[ h ].length );

  }
  else if( length === 1 && options.kind )
  {

    var handlers = handlers[ options.kind ];
    if( !handlers )
    return self;

    handlers.splice( 0,handlers.length );

  }
  else
  {

    var equalizer = function( a,b )
    {

      if( options.kind !== undefined )
      if( a.kind !== b.kind )
      return false;

      if( options.onHandle !== undefined )
      if( a.onHandle !== b.onHandle )
      return false;

      if( options.owner !== undefined )
      if( a.owner !== b.owner )
      return false;

      return true;
    }

    var removed = 0;
    if( options.kind )
    {

      var handlers = handlers[ options.kind ];
      if( handlers )
      removed = _.arrayRemovedAll( handlers,options,equalizer );

    }
    else for( var h in handlers )
    {

      removed += _.arrayRemovedAll( handlers[ h ],options,equalizer );

    }

    if( !removed && options.onHandle && options.strict )
    throw _.err( 'eventHandlerUnregister :','handler was not registered to unregister it' );

  }

  return self;
}

_eventHandlerUnregister.defaults =
{
  kind : null,
  onHandle : null,
  owner : null,
  strict : 1,
}

//

/*
var eventHandlerUnregisterAll = function( kind, handlersToUnregister )
{
  var self = this;

  _.assert( arguments.length === 1,'not implemented' );

  var handlers = self._eventHandlerDescriptors;
  if( !handlers )
  return self;

  handlers = handlers[ kind ];
  if( !handlers )
  return self;

  handlers.splice( 0,handlers.length );

  return self;
}
*/

//

var eventHandlerUnregisterByKindAndOwner = function( kind, owner )
{
  var self = this;

  _.assert( arguments.length === 2 && owner,'eventHandlerUnregister:','expects "kind" and "owner" as arguments' );

  var handlers = self._eventHandlerDescriptors;
  if( !handlers )
  return self;

  handlers = handlers[ kind ];
  if( !handlers )
  return self;

  do
  {

    var descriptor = self._eventHandlerDescriptorByKindAndOwner( kind,owner );

    if( descriptor )
    _.arrayRemoveOnce( handlers,descriptor );

  }
  while( descriptor );

  return self;
}


// --
// handle
// --

var eventHandle = function( event )
{
  var self = this;

  _.assert( arguments.length === 1 );

  if( _.strIs( event ) )
  event = { kind : event };

  return self._eventHandle( event,{} );
}

//

var eventHandleUntil = function( event,value )
{
  var self = this;

  _.assert( arguments.length === 2 );

  if( _.strIs( event ) )
  event = { kind : event };

  return self._eventHandle( event,{ until : value } );
}

//

var _eventHandle = function( event,options )
{
  var self = this;
  var result = options.result = options.result || [];

  _.assert( arguments.length === 2 );

  if( event.type !== undefined || event.kind === undefined )
  throw _.err( 'event should have "kind" field, no "type" field' );

  if( self.usingEventLogging )
  logger.log( 'fired event', self.nickName + '.' + event.kind );

  var isUntil = options.hasOwnProperty( 'until' );

  var handlers = self._eventHandlerDescriptors;
  if( handlers === undefined )
  return result;

  var handlerArray = handlers[ event.kind ];
  if( handlerArray === undefined )
  return result;

  handlerArray = handlerArray.slice( 0 );

  event.target = self;

  if( self.usingEventLogging )
  logger.up();

  //

  for( var i = 0, il = handlerArray.length; i < il; i ++ )
  {

    var handler = handlerArray[ i ];

    if( self.usingEventLogging )
    logger.log( event.kind,'caught by',handler.onHandle.name );

    if( handler.proxy )
    {
      handler.onHandleEffective.call( self, event, options );
    }
    else
    {
      result.push( handler.onHandleEffective.call( self, event ) );
      if( isUntil )
      {
        if( result[ result.length-1 ] === options.until )
        {
          isUntil = 'found';
          result = options.until;
          break;
        }
      }
    }

  }

  //

  if( self.usingEventLogging )
  logger.down();

  if( isUntil === true )
  result = undefined;
  return result;
}

// --
// get
// --

var _eventHandlerDescriptorByKindAndOwner = function( kind,owner )
{
  var self = this;

  var handlers = self._eventHandlerDescriptors;
  if( !handlers )
  return;

  handlers = handlers[ kind ];
  if( !handlers )
  return;

  _.assert( arguments.length === 2 );

  var eq = function( a,b ){ return a.kind === b.kind && a.owner === b.owner; };
  var element = { kind : kind, owner : owner };
  var index = _.arrayLeftIndexOf( handlers,element,eq );

  if( !( index >= 0 ) )
  return;

  var result = handlers[ index ];
  result.index = index;

  return result;
}

//

var _eventHandlerDescriptorByKindAndHandler = function( kind,onHandle )
{
  var self = this;

  var handlers = self._eventHandlerDescriptors;
  if( !handlers )
  return;

  handlers = handlers[ kind ];
  if( !handlers )
  return;

  _.assert( arguments.length === 2 );

  var eq = function( a,b ){ return a.kind === b.kind && a.onHandle === b.onHandle; };
  var element = { kind : kind, onHandle : onHandle };
  var index = _.arrayLeftIndexOf( handlers,element,eq );

  if( !( index >= 0 ) )
  return;

  var result = handlers[ index ];
  result.index = index;

  return result;
}

//

var _eventHandlerDescriptorByHandler = function( onHandle )
{
  var self = this;

  _.assert( _.routineIs( onHandle ) );
  _.assert( arguments.length === 1 );

  var handlers = self._eventHandlerDescriptors;
  if( !handlers )
  return;

  for( var h in handlers )
  {

    var index = _.arrayLeftIndexOf( handlers[ h ],{ onHandle : onHandle },function( a,b ){ return a.onHandle === b.onHandle } );

    if( index >= 0 )
    {
      handlers[ h ][ index ].index = index;
      return handlers[ h ][ index ];
    }

  }

}

//

var _eventHandlerDescriptorsByKind = function( kind )
{
  var self = this;

  if( self._eventHandlerDescriptors === undefined )
  self._eventHandlerDescriptors = {};

  var handlers = self._eventHandlerDescriptors;
  var handlers = handlers[ kind ] = handlers[ kind ] || [];

  return handlers;
}

// --
// proxy
// --

var eventProxyTo = function( dst,rename )
{
  var self = this;

  _.assert( arguments.length === 2 );
  _.assert( _.objectIs( dst ) && _.routineIs( dst.eventHandle ) );
  _.assert( _.mapIs( rename ) || _.strIs( rename ) );

  if( _.strIs( rename ) )
  {
    var r = {};
    r[ rename ] = rename;
    rename = r;
  }

  for( var r in rename ) (function()
  {
    var name = r;
    _.assert( rename[ r ] && _.strIs( rename[ r ] ),'eventProxyTo :','expects name as string' );

    self._eventHandlerRegister
    ({
      kind : r,
      onHandle : function( event,options )
      {
        if( name !== rename[ name ] )
        {
          event = _.mapExtend( {},event );
          event.kind = rename[ name ];
        }
        return dst._eventHandle( event,options );
      },
      proxy : 1,
    });

  })();

}

//

var eventProxyFrom = function( src,rename )
{
  var self = this;

  _.assert( arguments.length === 2 );

  return src.eventProxyTo( self,rename );
}

// --
// relationships
// --

var Composes =
{
}

var Restricts =
{
  usingEventLogging : 0,
  _eventHandlerDescriptors : {},

  //_eventHandlers : {},
  //_eventHandlerOwners : [],
}

// --
// proto
// --

var Functors =
{

  init : init,
  finit : finit,

}

//

var Proto =
{

  // register

  eventHandlerRegister : eventHandlerRegister,
  addEventListener : eventHandlerRegister,
  on : eventHandlerRegister,

  eventHandlerRegisterOneTime : eventHandlerRegisterOneTime,
  once : eventHandlerRegisterOneTime,
  _eventHandlerRegister: _eventHandlerRegister,

  // unregister

  removeListener : eventHandlerUnregister,
  removeEventListener : eventHandlerUnregister,
  eventHandlerUnregister : eventHandlerUnregister,
  _eventHandlerUnregister : _eventHandlerUnregister,
  eventHandlerUnregisterByKindAndOwner: eventHandlerUnregisterByKindAndOwner,


  // handle

  dispatchEvent : eventHandle,
  emit : eventHandle,
  eventHandle : eventHandle,
  eventHandleUntil : eventHandleUntil,
  _eventHandle : _eventHandle,

  // get

  _eventHandlerDescriptorByKindAndOwner : _eventHandlerDescriptorByKindAndOwner,
  _eventHandlerDescriptorByKindAndHandler : _eventHandlerDescriptorByKindAndHandler,
  _eventHandlerDescriptorByHandler : _eventHandlerDescriptorByHandler,
  _eventHandlerDescriptorsByKind : _eventHandlerDescriptorsByKind,

  // proxy

  eventProxyTo : eventProxyTo,
  eventProxyFrom : eventProxyFrom,

  // ident

  Composes : Composes,
  Restricts : Restricts,

}

//

var Self =
{

  mixin : mixin,

}

Self.__proto__ = Proto;

_global_.wEventHandler = wTools.EventHandler = Self;

return Self;

})();
