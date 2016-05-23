_global_.wInstancing = wTools.Instancing =
( function(){

'use strict';

var _ = wTools;

//

/**
 * Mixin instancing into prototype of another object.
 * @param {object} dst - prototype of another object.
 * @method mixin
 * @memberof wInstancing#
 */

var mixin = function( dst )
{

  _.assert( !dst.instances );

  _.mixin
  ({
    dst : dst,
    Proto : Proto,
    Functors : Functors,
    name : 'Instancing',
  });

  dst.instances = [];

  // constructor

  dst.constructor.instances = dst.instances;

  _.accessorReadOnly
  ({
    object : dst.constructor,
    methods : { '_firstInstanceGet' : _firstInstanceGet },
    names : { firstInstance : 'firstInstance' },
    noField : true,
  });

  _.accessorForbid( dst.constructor,
  {
    instance : 'instance',
  });

}

//

/**
 * Functor to produce init.
 * @param {object} Prototype - prototype of another object.
 * @method init
 * @memberof wInstancing#
 */

var init = function( Prototype )
{

  var originalInit = Prototype.init;

  return function initInstancing()
  {
    var self = this;

    self.instances.push( self );

    return originalInit.apply( self,arguments );
  }

}

//

/**
 * Functor to produce finit.
 * @param {object} Prototype - prototype of another object.
 * @method finit
 * @memberof wInstancing#
 */

var finit = function( Prototype )
{

  var originalFinit = Prototype.finit;

  return function finitInstancing()
  {
    var self = this;

    _.arrayRemoveOnce( self.instances,self );

    return originalFinit.apply( self,arguments );
  }

}

//

/**
 * Iterate through instances of this type.
 * @param {routine} onEach - on each handler.
 * @method eachInstance
 * @memberof wInstancing#
 */

var eachInstance = function( onEach )
{
  var self = this;

  /*if( self.Self.prototype === self )*/

  for( var i = 0 ; i < self.instances.length ; i++ )
  {
    var instance = self.instances[ i ];
    if( instance instanceof self.Self )
    onEach.call( instance );
  }

  return self;
}

//

/**
 * Get first instance.
 * @method _firstInstanceGet
 * @memberof wInstancing#
 */

var _firstInstanceGet = function()
{
  var self = this;
  return self.instances[ 0 ];
}

// --
// proto
// --

var Functors =
{

  init : init,
  finit : finit,

}

var Proto =
{

  '_firstInstanceGet' : _firstInstanceGet,
  eachInstance : eachInstance,

}

var Self =
{

  mixin: mixin,

}

_.mapExtend( Self,Proto );

return Self;

})();
