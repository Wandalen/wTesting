(function _Exec_s_(){

'use strict';

var Self = wTools;
var _ = wTools;

var _ArraySlice = Array.prototype.slice;
var _FunctionBind = Function.prototype.bind;
var _ObjectToString = Object.prototype.toString;
var _ObjectHasOwnProperty = Object.hasOwnProperty;

var _assert = _.assert;
var _arraySlice = _.arraySlice;

// --
// exec
// --

var execAsyn = function( routine,onEnd,context )
{
  _assert( arguments.length >= 3,'execAsyn:','expects 3 arguments or more' );

  var args = arraySlice( arguments,3 ); throw _.err( 'not tested' );

  _.timeOut( 0,function()
  {

    routine.apply( context,args );
    onEnd();

  });

}

//

var execStages = function( stages,options )
{

  // options

  var options = options || {};
  _.assertMapOnly( options,execStages.defaults );
  _.mapComplement( options,execStages.defaults );

  if( options.context === null )
  options.context = this;

  // validation

  if( options.onUpdate )
  throw _.err( 'execStages :','onUpdate is deprecated, please use onEach' );

  _.assert( _.objectIs( stages ) || _.arrayLike( stages ) )

  for( var s in stages )
  {

    if( !stages[ s ] )
    throw _.err( 'execStages :','#'+s,'stage is not defined' );

    var routine = stages[ s ];

    if( !_.routineIs( routine ) )
    routine = stages[ s ].syn || stages[ s ].asyn;

    if( !_.routineIs( routine ) )
    throw _.err( 'execStages :','stage','#'+s,'does not have routine to execute' );

  }

  //  var

  var conEnd = new wConsequence();
  var arrayLike = _.arrayLike( stages );
  var keys = Object.keys( stages );
  var s = 0;

  // begin

  if( options.onBegin )
  wConsequence.giveWithContextAndErrorTo( options.onBegin,options.context,null,options );

  // end

  var handleEnd = function( err )
  {

    if( err )
    {
      debugger;
      _.errLog( err );
    }

    if( options.onEnd )
    wConsequence.giveWithContextAndErrorTo( options.onEnd,options.context,err,options );

    conEnd.giveWithError( err,null );

  }

  // next

  var handleNext = function( err )
  {

    if( err )
    return handleEnd( err );

    _.timeOut( options.delay,handleStage );

    return true;
  }

  // staging

  var handleStage = function()
  {

    var stage = stages[ keys[ s ] ];
    options.index = s;
    options.key = keys[ s ];
    s += 1;

    if( !stage )
    return handleEnd( null );

    // arguments

    handleNext.staging = 1;
    var routine = stage;
    var args;

    if( !_.routineIs( routine ) )
    {
      routine = stage.syn || stage.asyn;
      if( stage.args )
      args = _.arraySlice( stage.args );
    }

    if( !args )
    args = options.args ? _.arraySlice( options.args ) : [];

    /*args.push( handleNext ); */

    // next

    var handleStageEnd = function( err,ret )
    {

      var isSyn = stage.syn || ( options.syn && !stage.asyn );

      if( !isSyn && !( ret instanceof wConsequence ) )
      {
        isSyn = false;
      }
      else if( isSyn && ( ret instanceof wConsequence ) )
      throw _.err( 'Synchronous stage should not return wConsequence' );

      if( !isSyn || ret instanceof wConsequence  )
      {
        ret.got( handleNext );
      }
      else
      {
        handleNext();
      }

    }

    // exec

    try
    {

      var ret;
      if( options.onEach )
      {
        ret = options.onEach.call( options.context,options,stage );
        debugger;
      }

      if( !( ret instanceof wConsequence ) )
      ret = new wConsequence().give( ret );

      if( !options.manual )
      //if( ret instanceof wConsequence )
      ret.then_( _.routineJoin( options.context,routine,args ) );
      //else
      //ret = routine.apply( options.context,args );

      ret.then_( handleStageEnd );

    }
    catch( err )
    {
      handleEnd( _.err( err ) );
    }

  }

  //

  _.timeOut( options.delay,handleStage );

  return conEnd;
}

execStages.defaults =
{
  syn : 0,
  delay : 1,
  args : [],
  context : null,
  manual : false,
  stages : null,

  onEach : null,
  onBegin : null,
  onEnd : null,
}

//
/*
var execForEach = function execForEach( elements,options )
{

  // validation

  if( !elements ) throw _.err( 'execForEach:','require elements' );
  if( !options ) throw _.err( 'execForEach:','require options' );
  if( options.onEach === undefined ) throw _.err( 'execForEach:','options require onEach' );
  if( options.range === undefined ) throw _.err( 'execForEach:','options require range' );

  // correction

  if( options.batch === undefined ) options.batch = 1;
  if( options.delay === undefined ) options.delay = 0;
  if( options.batch === 0 ) options.batch = options.range[ 1 ] - options.range[ 0 ];

  // begin

  if( options.onBegin ) options.onBegin.call( options.context );

  var r = options.range[ 0 ];

  var range = options.range.slice();

  var exec = function()
  {

    for( var l = Math.min( range[ 1 ],r+options.batch ) ; r < l ; r++ )
    {
      options.onEach.call( options.context,r );
    }

    if( r < range[ 1 ] )
    {
      _.timeOut( options.delay,exec );
    }
    else
    {
      if( options.onEnd ) options.onEnd.call( options.context );
    }

  }

  exec();

}
*/
//

var execInRange = function execInRange( options )
{

  if( !options ) throw _.err( '_.execInRange:','require options' );
  if( options.onEach === undefined ) throw _.err( '_.execInRange:','options require onEach' );
  if( options.range === undefined ) throw _.err( '_.execInRange:','options require range' );

  if( options.batch === undefined ) options.batch = 1;
  if( options.delay === undefined ) options.delay = 0;
  if( options.batch === 0 ) options.batch = options.range[ 1 ] - options.range[ 0 ];
  if( options.onBegin ) options.onBegin.call( options.context );

  var r = options.range[ 0 ];

  var range = options.range.slice();

  var exec = function()
  {

    for( var l = Math.min( range[ 1 ],r+options.batch ) ; r < l ; r++ )
    {
      options.onEach.call( options.context,r );
    }

    if( r < range[ 1 ] )
    {
      _.timeOut( options.delay,exec );
    }
    else
    {
      if( options.onEnd ) options.onEnd.call( options.context );
    }

  }

  exec();

}

//

var execInRanges = function( options )
{

  _.assertMapOnly( options,execInRanges.defaults );
  _assert( _.objectIs( options ) )
  _assert( _.arrayIs( options.ranges ) || _.objectIs( options.ranges ),'execInRanges:','expects options.ranges as array or object' )
  _assert( _.routineIs( options.onEach ),'execInRanges:','expects options.onEach as routine' )
  _assert( !options.delta || options.delta.length === options.ranges.length,'execInRanges:','options.delta must be same length as ranges' );

  var delta = _.objectIs( options.delta ) ? [] : null;
  var ranges = [];
  var names = null;
  if( _.objectIs( options.ranges ) )
  {
    _assert( _.objectIs( options.delta ) || !options.delta );

    names = [];
    var i = 0;
    for( var r in options.ranges )
    {
      names[ i ] = r;
      ranges[ i ] = options.ranges[ r ];
      if( delta )
      {
        if( !options.delta[ r ] )
        throw _.err( 'no delta for',r );
        delta[ i ] = options.delta[ r ];
      }
    }

  }
  else
  {
    ranges = options.ranges.slice();
    delta = _.arrayLike( options.delta ) ? options.delta.slice() : null;
  }

  var last = ranges.length-1;

  for( var r = 0 ; r < ranges.length ; r++ )
  {

    if( _.numberIs( ranges[ r ] ) )
    ranges[ r ] = [ 0,ranges[ r ] ];

    if( !_.arrayLike( ranges[ r ] ) )
    throw _.err( 'expects range as array :',ranges[ r ] );

    _assert( ranges[ r ].length === 2 );
    _assert( _.numberIs( ranges[ r ][ 0 ] ) );
    _assert( _.numberIs( ranges[ r ][ 1 ] ) );

  }

  //

  var adjust = function( arg ){ return arg.slice(); };
  if( names )
  adjust = function( arg )
  {
    var result = {};
    for( var i = 0 ; i < names.length ; i++ )
    result[ names[ i ] ] = arg[ i ];
    return result;
  }

  //

  var counter = [];
  for( var r = 0 ; r < ranges.length ; r++ )
  counter[ r ] = ranges[ r ][ 0 ];

  //

  var i = 0;
  while( counter[ last ] < ranges[ last ][ 1 ] )
  {

    var res = options.onEach.call( options.context,adjust( counter ),i );

    if( res === false )
    break;

    i += 1;

    var c = 0;
    do
    {
      if( c >= ranges.length )
      break;
      if( c > 0 )
      counter[ c-1 ] = ranges[ c-1 ][ 0 ];
      if( delta )
      counter[ c ] += delta[ c ];
      else
      counter[ c ] += 1;
      c += 1;
    }
    while( counter[ c-1 ] >= ranges[ c-1 ][ 1 ] );

  }

  return i;
}

execInRanges.defaults =
{
  ranges : null,
  delta : null,
  onEach : null,
}

// --
// prototype
// --

var Proto =
{

  // exec

  execAsyn: execAsyn,
  execStages: execStages,
  execInRange: execInRange,
  execInRanges: execInRanges,

}

_.mapExtend( Self, Proto );

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
{
  module[ 'exports' ] = Self;
}

})();
