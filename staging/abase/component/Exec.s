( function _Exec_s_() {

'use strict';

var Self = wTools;
var _ = wTools;

var _ArraySlice = Array.prototype.slice;
var _FunctionBind = Function.prototype.bind;
var _ObjectToString = Object.prototype.toString;
var _ObjectHasOwnProperty = Object.hasOwnProperty;

var _assert = _.assert;
var _arraySlice = _.arraySlice;

/*

  !!! rewrite or deprecate?
  !!! introduce paramter to continue on error

*/

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

var execStages = function( stages,o )
{

  // o

  var o = o || {};
  _.assertMapOnly( o,execStages.defaults );
  _.mapComplement( o,execStages.defaults );

  if( o.context === null )
  o.context = this;

  // validation

  if( o.onUpdate )
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

  if( o.onBegin )
  wConsequence.giveWithContextAndErrorTo( o.onBegin,o.context,null,o );

  // end

  var handleEnd = function( err )
  {

    if( err )
    {
      debugger;
      _.errLog( err );
    }

    if( o.onEnd )
    wConsequence.giveWithContextAndErrorTo( o.onEnd,o.context,err,o );

    conEnd._giveWithError( err,null );

  }

  // next

  var handleNext = function( err )
  {

    if( err )
    return handleEnd( err );

    _.timeOut( o.delay,handleStage );

    return true;
  }

  // staging

  var handleStage = function()
  {

    var stage = stages[ keys[ s ] ];
    o.index = s;
    o.key = keys[ s ];
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
    args = o.args ? _.arraySlice( o.args ) : [];

    /*args.push( handleNext ); */

    // next

    var handleStageEnd = function( err,ret )
    {

      if( err )
      return handleEnd( _.err( err ) );

      var isSyn = stage.syn || ( o.syn && !stage.asyn );

      if( !isSyn && !( ret instanceof wConsequence ) )
      {
        isSyn = false;
      }
      else if( isSyn && ( ret instanceof wConsequence ) )
      throw _.err( 'Synchronous stage should not return wConsequence' );

      if( !isSyn || ret instanceof wConsequence )
      {
        if( ret instanceof wConsequence )
        ret.then_( handleNext );
        else
        handleNext( null );
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
      if( o.onEach )
      {
        ret = o.onEach.call( o.context,o,stage );
      }

      if( !( ret instanceof wConsequence ) )
      ret = new wConsequence().give( ret );

      if( !o.manual )
      //if( ret instanceof wConsequence )
      ret.then_( _.routineJoin( o.context,routine,args ) );
      //else
      //ret = routine.apply( o.context,args );

      ret.then_( handleStageEnd );

    }
    catch( err )
    {
      handleEnd( _.err( err ) );
    }

  }

  //

  _.timeOut( o.delay,handleStage );

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
var execForEach = function execForEach( elements,o )
{

  // validation

  if( !elements ) throw _.err( 'execForEach:','require elements' );
  if( !o ) throw _.err( 'execForEach:','require o' );
  if( o.onEach === undefined ) throw _.err( 'execForEach:','o require onEach' );
  if( o.range === undefined ) throw _.err( 'execForEach:','o require range' );

  // correction

  if( o.batch === undefined ) o.batch = 1;
  if( o.delay === undefined ) o.delay = 0;
  if( o.batch === 0 ) o.batch = o.range[ 1 ] - o.range[ 0 ];

  // begin

  if( o.onBegin ) o.onBegin.call( o.context );

  var r = o.range[ 0 ];

  var range = o.range.slice();

  var exec = function()
  {

    for( var l = Math.min( range[ 1 ],r+o.batch ) ; r < l ; r++ )
    {
      o.onEach.call( o.context,r );
    }

    if( r < range[ 1 ] )
    {
      _.timeOut( o.delay,exec );
    }
    else
    {
      if( o.onEnd ) o.onEnd.call( o.context );
    }

  }

  exec();

}
*/
//

var execInRange = function execInRange( o )
{

  if( !o ) throw _.err( '_.execInRange:','require o' );
  if( o.onEach === undefined ) throw _.err( '_.execInRange:','o require onEach' );
  if( o.range === undefined ) throw _.err( '_.execInRange:','o require range' );

  if( o.batch === undefined ) o.batch = 1;
  if( o.delay === undefined ) o.delay = 0;
  if( o.batch === 0 ) o.batch = o.range[ 1 ] - o.range[ 0 ];
  if( o.onBegin ) o.onBegin.call( o.context );

  var r = o.range[ 0 ];

  var range = o.range.slice();

  var exec = function()
  {

    for( var l = Math.min( range[ 1 ],r+o.batch ) ; r < l ; r++ )
    {
      o.onEach.call( o.context,r );
    }

    if( r < range[ 1 ] )
    {
      _.timeOut( o.delay,exec );
    }
    else
    {
      if( o.onEnd ) o.onEnd.call( o.context );
    }

  }

  exec();

}

//

var execInRanges = function( o )
{

  _.assertMapOnly( o,execInRanges.defaults );
  _assert( _.objectIs( o ) )
  _assert( _.arrayIs( o.ranges ) || _.objectIs( o.ranges ),'execInRanges:','expects o.ranges as array or object' )
  _assert( _.routineIs( o.onEach ),'execInRanges:','expects o.onEach as routine' )
  _assert( !o.delta || o.delta.length === o.ranges.length,'execInRanges:','o.delta must be same length as ranges' );

  /**/

  var iterationNumber = 1;
  var l = 0;
  var delta = _.objectIs( o.delta ) ? [] : null;
  var ranges = [];
  var names = null;
  if( _.objectIs( o.ranges ) )
  {
    _assert( _.objectIs( o.delta ) || !o.delta );

    names = [];
    var i = 0;
    for( var r in o.ranges )
    {
      names[ i ] = r;
      ranges[ i ] = o.ranges[ r ];
      if( delta )
      {
        if( !o.delta[ r ] )
        throw _.err( 'no delta for',r );
        delta[ i ] = o.delta[ r ];
      }
    }

    l = names.length;

  }
  else
  {
    ranges = o.ranges.slice();
    delta = _.arrayLike( o.delta ) ? o.delta.slice() : null;
    l = o.ranges.length;
  }

  var last = ranges.length-1;

  /* adjust range */

  var adjustRange = function( r )
  {

    if( _.numberIs( ranges[ r ] ) )
    ranges[ r ] = [ 0,ranges[ r ] ];

    if( !_.arrayLike( ranges[ r ] ) )
    throw _.err( 'expects range as array :',ranges[ r ] );

    _assert( ranges[ r ].length === 2 );
    _assert( _.numberIs( ranges[ r ][ 0 ] ) );
    _assert( _.numberIs( ranges[ r ][ 1 ] ) );

    iterationNumber *= ranges[ r ][ 1 ] - ranges[ r ][ 0 ];

  }

  if( _.objectIs( ranges ) )
  for( var r in ranges )
  adjustRange( r );
  else
  for( var r = 0 ; r < ranges.length ; r++ )
  adjustRange( r );

  /* estimate */

  if( o.estimate )
  {

    if( !ranges.length )
    return 0;

    return { length : iterationNumber };

  }

  /**/

  var adjustIndex = function( arg ){ return arg.slice(); };
  if( names )
  adjustIndex = function( arg )
  {
    var result = {};
    for( var i = 0 ; i < names.length ; i++ )
    result[ names[ i ] ] = arg[ i ];
    return result;
  }

  /**/

  var counter = [];
  for( var r = 0 ; r < ranges.length ; r++ )
  counter[ r ] = ranges[ r ][ 0 ];

  /**/

  var i = 0;
  while( counter[ last ] < ranges[ last ][ 1 ] )
  {

    var res = o.onEach.call( o.context,adjustIndex( counter ),i );

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

  /**/

  return i;
}

execInRanges.defaults =
{
  ranges : null,
  delta : null,
  onEach : null,
  estimate : 0,
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
