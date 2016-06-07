( function _Consequence_s_(){

'use strict';

if( typeof module !== 'undefined' )
{

  try
  {
    require( 'wTools' );
  }
  catch( err )
  {
    require( '../wTools.s' );
  }

  try
  {
    require( 'wProto' );
    require( 'wCopyable' );
  }
  catch( err )
  {
    require( '../component/Proto.s' );
    require( '../mixin/Copyable.s' );
  }

}

var _ = wTools;
var Parent = null;
var Self = function wConsequence( options )
{
  if( !( this instanceof Self ) )
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

/*

 !!! move promise / event property from object to taker

 !!! test difference :

    if( errs.length )
    return new wConsequence().error( errs[ 0 ] );

    if( errs.length )
    throw _.err( errs[ 0 ] );


*/

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

var _gotterAppend = function( o )
{
  var self = this;
  var taker = o.taker;
  var name = o.name || taker ? taker.name : null || null;

  _.assert( arguments.length === 1 );
  _.assert( _.boolIs( o.thenning ) );
  _.assert( _.routineIs( taker ) || taker instanceof Self );

  if( _.routineIs( taker ) )
  {
    if( o.context !== undefined || o.argument !== undefined )
    taker = _.routineJoin( o.context,taker,o.argument );
  }
  else
  {
    _.assert( o.context === undefined && o.argument === undefined );
  }

  self._taker.push
  ({
    onGot : taker,
    thenning : o.thenning,
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
  _.assert( this instanceof Self )
  _.assert( arguments.length <= 3 );

  return this._gotterAppend
  ({
    taker : Self.ifNoErrorThen( arguments[ 0 ] ),
    context : arguments[ 1 ],
    argument : arguments[ 2 ],
    thenning : true,
  });

}

//

var ifNoErrorThenClass = function()
{

  _.assert( arguments.length === 1 );
  _.assert( this === Self );

  var onEnd = arguments[ 0 ];
  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( onEnd ) );

  return function ifNoErrorThen( err,data )
  {

    _.assert( arguments.length === 2 );

    if( !err )
    {
      return onEnd( err,data );
    }
    else
    {
      debugger;
      return wConsequence().error( _.err( err ) );
    }

  }

}

//

var thenDebug = function thenDebug()
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

  var _given = self._given[ 0 ];
  self._given.splice( 0,1 );

  //

  var _giveToConsequence = function( _taker )
  {

    result = _taker.onGot.giveWithError.call( _taker.onGot,_given.error,_given.argument );
    if( self.mode === 'promise' && _taker.thenning )
    {
      self.giveWithError( _given.error,_given.argument );
    }

  }

  //

  var _giveToRoutine = function( _taker )
  {

    try
    {
      result = _taker.onGot.call( self,_given.error,_given.argument );
    }
    catch( err )
    {
      debugger;
      var err = _.err( err );
      err.respected = 1;
      result = new wConsequence().error( err );
      if( Config.debug )
      console.error( 'Consequence caught error' );
      if( Config.debug )
      {
        _.timeOut( 1, function()
        {
          if( err.respected )
          {
            console.error( 'Uncaught error caught by Consequence:' );
            _.errLog( err );
          }
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

  //

  var _giveTo = function( _taker )
  {

    if( _taker.onGot === _onDebug )
    debugger;

    if( _taker.onGot instanceof Self )
    {
      _giveToConsequence( _taker );
    }
    else
    {
      _giveToRoutine( _taker );
    }

  }

  //

  if( self.mode === 'promise' )
  {

    var _taker = self._taker[ 0 ];
    self._taker.splice( 0,1 );
    _giveTo( _taker );

  }
  else if( self.mode === 'event' )
  {

    for( var i = 0 ; i < self._taker.length ; i++ )
    _giveTo( self._taker[ i ] );

  }
  else throw _.err( 'unexepected' );

  /*if( mutex )*/
  if( self._given.length )
  self._handleGot();

  return result;
}

//

var _giveClass = function _giveClass( o )
{
  var context;

  if( !( _.arrayIs( o.args ) && o.args.length <= 1 ) )
  debugger;

  _.assert( arguments.length );
  _.assert( _.objectIs( o ) );
  _.assert( _.arrayIs( o.args ) && o.args.length <= 1, 'not tested' );

  //

  if( o.consequence instanceof Self )
  {
/*
    if( o.error === undefined )
    give = o.consequence.give;
    else
    give = o.consequence.giveWithError;
*/
    _.assert( _.arrayIs( o.args ) && o.args.length <= 1 );

    context = o.consequence;

    if( o.error !== undefined )
    {
      o.consequence.giveWithError( o.error,o.args[ 0 ] );
    }
    else
    {
      o.consequence.give( o.args[ 0 ] );
    }
/*
    if( o.args )
    give.apply( context,o.args );
    else
    give.call( context,got );
*/
  }
  else if( _.routineIs( o.consequence ) )
  {

    _.assert( _.arrayIs( o.args ) && o.args.length <= 1 );

/*
    give = o.consequence;
    context = o.context;

    if( o.error !== undefined )
    {
      o.args = o.args || [];
      o.args.unshift( o.error );
    }

    if( o.args )
    o.consequence.apply( context,o.args );
    else
    o.consequence.call( context,got );
*/

    if( o.error !== undefined )
    {
      return o.consequence.call( context,o.error,o.args[ 0 ] );
    }
    else
    {
      return o.consequence.call( context,null,o.args[ 0 ] );
    }

  }
  else throw _.err( 'Unknown type of consequence : ' + _.strTypeOf( o.consequence ) );


}

//
/*
var giveWithContextTo = function giveWithContextTo( consequence,context,got )
{

  var args = [ got ];
  if( arguments.length > 3 )
  args = _.arraySlice( arguments,2 );

  return _giveClass
  ({
    consequence : consequence,
    context : context,
    error : undefined,
    args : args,
  });

}
*/
//

var giveClass = function( consequence )
{

  _.assert( arguments.length === 2 || arguments.length === 3 );

  var err,got;
  if( arguments.length === 2 )
  {
    got = arguments[ 1 ];
  }
  else if( arguments.length === 3 )
  {
    err = arguments[ 1 ];
    got = arguments[ 2 ];
  }

  var args = [ got ];

  return _giveClass
  ({
    consequence : consequence,
    context : undefined,
    error : err,
    args : args,
  });

}

//

var errorClass = function( consequence,error )
{

  _.assert( arguments.length === 2 );

  return _giveClass
  ({
    consequence : consequence,
    context : undefined,
    error : error,
    args : [],
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

  return _giveClass
  ({
    consequence : consequence,
    context : context,
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

//

var toStr = function()
{
  var self = this;
  var result = self.nickName;

  var names = _.entitySelect( self.takersGet(),'*.name' );

  result += '\n  given : ' + self.givenGet().length;
  result += '\n  takers : ' + self.takersGet().length;
  result += '\n  takers : ' + names.join( ' ' );

  return result;
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
  ifNoErrorThen: ifNoErrorThen,
  thenDebug: thenDebug,
  timeOut: timeOut,

  give: give,
  error: error,
  giveWithError: giveWithError,
  ping: ping,

  _handleGot: _handleGot,
  _giveClass: _giveClass,

  //
/*

  giveWithContextTo: giveWithContextTo,
  giveTo: giveTo,
  errorTo: errorTo,
  giveWithContextAndErrorTo: giveWithContextAndErrorTo,

*/

  //

  takersGet: takersGet,
  givenGet: givenGet,
  toStr: toStr,


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

  give: giveClass,
  error: errorClass,

  giveWithContextAndErrorTo: giveWithContextAndErrorTo,

  ifNoErrorThen: ifNoErrorThenClass,

}

_.protoMake
({
  constructor : Self,
  parent : Parent,
  extend : Proto,
});

_.mapExtend( Self,Static );

if( _global_.wCopyable )
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

_global_.wConsequence = wTools.Consequence = Self;
return Self;

})();
