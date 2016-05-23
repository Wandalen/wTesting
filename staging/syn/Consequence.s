( function(){

'use strict';

if( typeof wCopyable === 'undefined' && typeof module !== 'undefined' )
{
  require( '../component/Proto.s' );
  require( '../component/Exec.s' );
  require( '../object/printer/aPrinter.s' );
  require( '../mixin/Copyable.s' );
}

var _ = wTools;
var Parent = null;
var Self = function wConsequence( options )
{
  if( !( this instanceof Self ) )
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

//

var init = function init( options )
{
  var self = this;

  if( _.routineIs( options ) )
  options = { all : options };

  _.mapExtendFiltering( _.filter.notAtomicCloningOwn(),self,Composes );

  if( options )
  {
    self.copy( options );
  }

  _.assert( self.mode === 'promise' || self.mode === 'event' );

  _.constant( self,{ mode : self.mode } );

}

// --
// mode
// --

/*
var _modeGet = function _modeGet( value )
{
  var self = this;
  var fieldSymbol = Symbol.for( 'mode' );
  return self[ fieldSymbol ];
}

//

var _modeSet = function _modeSet( value )
{
  var self = this;
  var fieldSymbol = Symbol.for( 'mode' );

  if( value === undefined )
  value = true;
  else
  value = !!value;

  self[ fieldSymbol ] = value;

  return self;
}
*/

// --
// mechanics
// --

var _gotterAppend = function( options )
{
  var self = this;
  var taker = options.taker;
  var name = options.name || taker ? taker.name : null || null;

  _.assert( arguments.length === 1 );
  _.assert( _.boolIs( options.thenning ) );
  _.assert( _.routineIs( taker ) || taker instanceof Self );

  if( _.routineIs( taker ) )
  {
    if( options.context !== undefined || options.argument !== undefined )
    taker = _.routineBind( taker,options.context,options.argument );
  }
  else
  {
    _.assert( options.context === undefined && options.argument === undefined );
  }

  self._taker.push
  ({
    onGot : taker,
    thenning : options.thenning,
    name : name,
  });

  if( self._given.length )
  self._handleGot();

  return self;
}

//

var got = function got( taker )
{
  var self = this;

  _.assert( arguments.length <= 3 );

  if( arguments.length === 0 && taker === undefined )
  {
    taker = function(){};
  }

  return self._gotterAppend
  ({
    taker : taker,
    context : arguments[ 1 ],
    argument : arguments[ 2 ],
    thenning : false,
  });
}

//

var gotOnce = function gotOnce( taker )
{
  var self = this;
  var key = taker.name;

  _.assert( _.strIs( key ) && key );
  _.assert( arguments.length === 1 );

  var i = _.arrayLeftIndexOf( self._taker,key,function( a )
  {
    if( a.name === key )
    return true;
  });

  if( i >= 0 )
  return self;

  return self._gotterAppend
  ({
    taker : taker,
    context : arguments[ 1 ],
    argument : arguments[ 2 ],
    thenning : false,
  });
}

//

var then_ = function then_( taker )
{
  var self = this;

  _.assert( arguments.length <= 3 );

  if( taker instanceof Self )
  {
    //debugger;
    //throw _.err( 'not tested' );
  }

  return self._gotterAppend
  ({
    taker : taker,
    context : arguments[ 1 ],
    argument : arguments[ 2 ],
    thenning : true,
  });
}

//

var ifNoErrorThen = function()
{

  _.assert( arguments.length === 1 );

  if( this === Self )
  {

    var onEnd = arguments[ 0 ];
    _.assert( arguments.length === 1 );
    _.assert( _.routineIs( onEnd ) );

    return function ifNoErrorThen( err,data )
    {

      _.assert( arguments.length === 2 );

      if( !err )
      {
        return onEnd();
      }
      else
      {
        debugger;
/*
        if( Config.debug )
        _.errLog( err );
*/
        return wConsequence().error( err );
      }

    }

  }
  else if( this instanceof Self )
  {

    _.assert( arguments.length <= 3 );

    return this._gotterAppend
    ({
      taker : Self.ifNoErrorThen( arguments[ 0 ] ),
      context : arguments[ 1 ],
      argument : arguments[ 2 ],
      thenning : true,
    });

  }
  else throw _.err( 'unexpected' );

}

//

var thenDebug = function thenDebug( taker )
{
  var self = this;

  _.assert( arguments.length === 0 );

  return self._gotterAppend
  ({
    taker : _onDebug,
    thenning : true,
  });

}

//

var timeOut = function timeOut( time,taker )
{
  var self = this;

  _.assert( arguments.length === 2 );
  _.assert( _.routineIs( taker ),'not implemented' );

  return self._gotterAppend
  ({
    taker : function( err,data ){
      return _.timeOut( time,self,taker,[ err,data ] );
    },
    context : arguments[ 1 ],
    argument : arguments[ 2 ],
    thenning : true,
  });

}
/*
con.then_( _.routineSeal( _,_.timeOut,[ 8000,_.routineSeal( session, session.makeAndSaveMinimal, [] ) ] ) );
*/
//

var give = function give( given )
{
  var self = this;
  _.assert( arguments.length === 1 || arguments.length === 0 );
  return self.giveWithError( null,given );
}

//

var error = function( error )
{
  var self = this;
  _.assert( arguments.length === 1 || arguments.length === 0 );
  if( arguments.length === 0  )
  error = _.err();
  return self.giveWithError( error,undefined );
}

//

var giveWithError = function( error,argument )
{
  var self = this;

  _.assert( arguments.length === 2 );

  var given =
  {
    error : error,
    argument : argument,
  }

  self._given.push( given );
  self._handleGot();

  return self;
}

//

var ping = function( error,argument )
{
  var self = this;

  _.assert( arguments.length === 2 );

  var given =
  {
    error : error,
    argument : argument,
  }

  self._given.push( given );
  var result = self._handleGot();

  return result;
}

//

var _handleGot = function()
{
  var self = this;
  var mutex = self.mutex;
  var result;

  if( !self._taker.length )
  return;

  _.assert( self._given.length );

  var mark = self.mark;
  self.mark = null;
  var _given = self._given[ 0 ];
  self._given.splice( 0,1 );

  //

  var giveTo = function( _taker )
  {

    if( _taker.onGot === _onDebug )
    debugger;

    if( mark )
    debugger;

    if( _taker.onGot instanceof Self )
    {
      result = _taker.onGot.giveWithError.call( _taker.onGot,_given.error,_given.argument );
      if( self.mode === 'promise' && _taker.thenning )
      {
        self.giveWithError( _given.error,_given.argument );
      }
    }
    else
    {
      try
      {
        result = _taker.onGot.call( self,_given.error,_given.argument );
      }
      catch( err )
      {
        debugger;
        /*if( Config.debug )*/
        /*_.errLog( err );*/
        var err = _.err( err );
        result = new wConsequence().error( err );
        if( Config.debug )
        if( !self._taker.length )
        {
          self.mark = self.mark || [];
          self.mark.push( err );
          _.timeOut( 1, function()
          {
            if( self.mark && self.mark.indexOf( err ) !== -1 )
            _.errLog( err );
          });
        }
      }
      if( self.mode === 'promise' && _taker.thenning )
      {
        if( result instanceof Self )
        result.got( self );
        else
        self.give( result );
      }
    }

  }

  //

  if( self.mode === 'promise' )
  {

    var _taker = self._taker[ 0 ];
    self._taker.splice( 0,1 );
    giveTo( _taker );

  }
  else if( self.mode === 'event' )
  {

    for( var i = 0 ; i < self._taker.length ; i++ )
    giveTo( self._taker[ i ] );

  }
  else throw _.err( 'unexepected' );

  /*if( mutex )*/
  if( self._given.length )
  self._handleGot();

  return result;
}

// --
// class
// --

var _giveTo = function _giveTo( options )
{
  var give, context;
  var args = options.args;

  _.assert( arguments.length );
  _.assert( _.objectIs( options ) );

  if( options.error === undefined )
  options.error = undefined;

  if( options.context === undefined )
  options.context = undefined;

  //

  if( options.consequence instanceof Self )
  {
    if( options.error === undefined )
    give = options.consequence.give;
    else
    give = options.consequence.giveWithError;
    context = options.consequence;
  }
  else if( _.routineIs( options.consequence ) )
  {
    give = options.consequence;
    context = options.context;
  }
  else throw _.err( 'Unknown type of consequence' );

  if( options.error !== undefined )
  args.unshift( options.error );

  if( options.args )
  give.apply( context,options.args );
  else
  give.call( context,got );

}

//

var giveWithContextTo = function giveWithContextTo( consequence,context,got )
{

  var args = [ got ];
  if( arguments.length > 3 )
  args = _.arraySlice( arguments,2 );

  return _giveTo
  ({
    consequence : consequence,
    context : context,
    error : undefined,
    args : args,
  });

}

//

var giveTo = function( consequence,got )
{

  _.assert( arguments.length === 2 );

  var args = [ got ];
  if( arguments.length > 2 )
  args = _.arraySlice( arguments,1 );

  return _giveTo
  ({
    consequence : consequence,
    context : undefined,
    error : undefined,
    args : args,
  });

}

//

var errorTo = function( consequence,error )
{

  _.assert( arguments.length === 2 );

  return _giveTo
  ({
    consequence : consequence,
    context : undefined,
    error : error,
    args : undefined,
  });

}

//

var giveWithContextAndErrorTo = function giveWithContextAndErrorTo( consequence,context,err,got )
{

  if( err === undefined )
  err = null;

  var args = [ got ];
  if( arguments.length > 4 )
  args = _.arraySlice( arguments,3 );

  return _giveTo
  ({
    consequence : consequence,
    context : context,
    error : err,
    args : args,
  });

}

//

var giveWithErrorTo = function giveWithErrorTo( consequence,err,got )
{

  if( err === undefined )
  err = null;

  var args = [ got ];
  if( arguments.length > 3 )
  args = _.arraySlice( arguments,2 );

  return _giveTo
  ({
    consequence : consequence,
    context : undefined,
    error : err,
    args : args,
  });

}

// --
// taker / given
// --

var takersGet = function()
{
  var self = this;
  return self._taker;
}

//

var givenGet = function()
{
  var self = this;
  return self._given;
}

// --
// clear
// --

var clearTakers = function clearTakers( taker )
{
  var self = this;

  _.assert( arguments.length === 0 || _.routineIs( taker ) );

  if( arguments.length === 0 )
  self._taker.splice( 0,self._taker.length );
  else
  {
    throw _.err( 'not tested' );
    _.arrayRemoveOnce( self._taker,taker );
  }

}

//

var clearGiven = function clearGiven( data )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( arguments.length === 0 )
  self._given.splice( 0,self._given.length );
  else
  {
    throw _.err( 'not tested' );
    _.arrayRemoveOnce( self._given,data );
  }

}

//

var clear = function clear( data )
{
  var self = this;
  _.assert( arguments.length === 0 );

  self.clearTakers();
  self.clearGiven();

}

//

var _onDebug = function()
{
  debugger;
}

// --
// relationships
// --

var Composes =
{
  name : '',
  _taker : [],
  _given : [],
  mode : 'promise',
}

var Aggregates =
{
}

var Restricts =
{
  mark : null,
}

// --
// proto
// --

var Proto =
{

  init: init,

  // mode

/*
  '_modeGet': _modeGet,
  '_modeSet': _modeSet,
*/


  // mechanics

  _gotterAppend: _gotterAppend,

  got: got,
  done: got,
  gotOnce: gotOnce,
  then_: then_,
  thenDebug: thenDebug,
  timeOut: timeOut,

  give: give,
  error: error,
  giveWithError: giveWithError,
  ping: ping,

  _handleGot: _handleGot,

  _giveTo: _giveTo,

  giveWithContextTo: giveWithContextTo,
  giveTo: giveTo,
  errorTo: errorTo,
  ifNoErrorThen: ifNoErrorThen,

  giveWithContextAndErrorTo: giveWithContextAndErrorTo,
  giveWithErrorTo: giveWithErrorTo,


  //

  takersGet: takersGet,
  givenGet: givenGet,


  //

  clearTakers: clearTakers,
  clearGiven: clearGiven,
  clear: clear,


  //

  _onDebug: _onDebug,


  // ident

  constructor: Self,
  Composes: Composes,
  Aggregates: Aggregates,
  Restricts: Restricts,

}

var Static =
{

  giveWithContextTo: giveWithContextTo,
  giveTo: giveTo,
  errorTo: errorTo,
  ifNoErrorThen: ifNoErrorThen,

}

_.protoMake
({
  constructor : Self,
  parent : Parent,
  extend : Proto,
  usingGlobalName : true,
  wname : { Consequence : 'Consequence' },
});

_.mapExtend( Self,Static );

/*
_.mapExtend( Self,Proto );
_.mapExtend( Self.prototype,Proto );
_global_.wConsequence = wTools.Consequence = Self;
*/

wCopyable.mixin( Self.prototype );

//

_.accessor
({
  object : Self.prototype,
  names :
  {
    mutex : 'mutex',
  }
});

//

_.accessorForbid( Self.prototype,
  {
    every : 'every',
  },
  'please use "mutex" instead of "every"'
);

//

_.mapExtendFiltering( _.filter.atomicOwn(),Self.prototype,Composes );

if( typeof module !== 'undefined' )
{
  module[ 'exports' ] = Self;
}

//

return Self;

})();
