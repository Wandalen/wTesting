_global_.wWaiter = wTools.Waiter =
( function(){

'use strict';

//var wTools = typeof require !== 'undefined' ? require( './wTools' ) : null;

var _ = wTools;
var Parent = null;
var Self = function ()
{
  if( !( this instanceof Self ) )
  return new( _.routineBind( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

// --
// constructor
// --

var init = function( options )
{

  var self = this;
  if( !options ) options = {};
  _.enityExtend( self,options );

  /*_.assert( self.autoEnter === undefined,'wWaiter:','autoEnter is depreated' );*/

  if( self.silentAbort === undefined ) self.silentAbort = 0;
  if( self.context === undefined ) self.context = self;
  if( self.counter === undefined ) self.counter = 0;

  self.abort( 1 );
}

//

var abort = function( silent )
{
  var self = this;

  self._instanceCounter[ 0 ] += 1;
  self.id = self._instanceCounter[ 0 ];

  self.args = [];
  self.err = null;

  self.enter = self._enterMake();
  self.leave = self._leaveMake();

  if( ( silent === undefined || !silent ) && !self.silentAbort )
  {
    if( self.onAbort )
    wConsequence.prototype.giveWithContextAndErrorTo( self.onAbort, self.context );
    if( self.onEnd )
    wConsequence.prototype.giveWithContextAndErrorTo( self.onEnd, self.context, new ErrorAbort() );
  }

  return this;
}

//

var _enterMake = function()
{
  var id = this.id;

  return function()
  {

    if( id !== this.id )
    return null;

    this.counter++;

    //console.log( 'enter',this.counter );

    return this;
  }

}

//

var _leaveMake = function()
{
  var id = this.id;

  return function leave()
  {
    var self = this;
    this.counter--;

    _.assert( this.counter >= 0 );

    if( id !== self.id )
    return null;

    var args = _.arraySlice( arguments );
    self.args.push( args );
    self.err = self.err || args[ 0 ]

    if( self.onLeave ) self.onLeave.apply( self,args );

    if( self.counter === 0 )
    {
      if( self.onEnd )
      wConsequence.prototype.giveWithContextAndErrorTo( self.onEnd, self.context, self.err, self.args );
    }

    return self;
  }

}

// --
// type
// --

var ErrorAbort = function()
{
  this.message = arguments.length ? _.toArray( arguments ) : 'Aborted';
};
ErrorAbort.prototype = Object.create( Error.prototype );

// --
// var
// --

var _instanceCounter = [ 0 ];

// --
// proto
// --

var Proto =
{

  init: init,
  abort: abort,
  _enterMake : _enterMake,
  _leaveMake : _leaveMake,

  //

  _instanceCounter : _instanceCounter,
  ErrorAbort : ErrorAbort,

}

//

Self.prototype = Proto;

_.accessorForbid( Self.prototype,
{
  autoEnter : 'autoEnter',
});

if (typeof module !== 'undefined' && module !== null)
{
  module['exports'] = Self;
}

return Self;

})();
