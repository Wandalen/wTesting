(function() {

'use strict';

var Self = wTools;
var _ = wTools;

var _ArraySlice = Array.prototype.slice;
var _FunctionBind = Function.prototype.bind;
var _ObjectToString = Object.prototype.toString;
var _ObjectHasOwnProperty = Object.hasOwnProperty;

var _assert = _.assert;
var _arraySlice = _.arraySlice;
var strTypeOf = _.strTypeOf;

//

var toStrMethods = function( src,options )
{
  var options = options || {};
  options.onlyRoutines = 1;
  var result = toStrFine( src,options );
  return result;
}

//

var toStrFields = function( src,options )
{
  var options = options || {};
  options.noRoutine = 1;
  var result = toStrFine( src,options );
  return result;
}

//

var toStrFine_gen = function()
{

  var primeFilter =
  {

    noRoutine : 0,
    noAtomic : 0,
    noArray : 0,
    noObject : 0,
    noRow : 0,
    noError : 0,
    noNumber : 0,
    noString : 0,
    noDate : 0,

  }

  var composes =
  {

    levels : 1,
    wrap : 1,
    prependTab : 1,
    errorAsMap : 0,
    tab : '',
    dtab : '  ',
    colon : ' : ',

  }

  /**/

  var optional =
  {

    /* secondary filter */

    onlyRoutines : 0,
    noSubObject : 0,
    singleElementPerLine : 0,

    /**/

    precision : 3,
    fixed : 3,
    comma : ', ',
    multiline : 0,
    unescape : 0,

  }

  var restricts =
  {
    level : 0,
  }

  Object.preventExtensions( primeFilter );
  Object.preventExtensions( composes );
  Object.preventExtensions( optional );
  Object.preventExtensions( restricts );

  var def = _.protoUnitedInterface([ primeFilter,composes,optional ]);

  var routine = function toStrFine( src,options )
  {

    if( options !== undefined && !_.objectIs( options ) )
    throw _.err( '_.toStrFine:','options must be object' );

    var options = options || {};

    _.assertMapOnly( options,composes,primeFilter,optional );
    options = _.mapSupplement( {},options,composes,restricts );

    if( options.onlyRoutines )
    {
      for( var f in primeFilter )
      options[ f ] = 1;
      options.noRoutine = 0;
    }

    if( options.comma === undefined )
    options.comma = options.wrap ? optional.comma : ' ';

    if( options.comma && !_.strIs( options.comma ) )
    options.comma = optional.comma;

    var r = _toStrFine( src,options );

    return r ? r.text : '';
  }

  routine.defaults = def;
  routine.methods = toStrMethods;
  routine.fields = toStrFields;

  routine.notMethod = 1;

  return routine;
}

//

var _toStrFine = function _toStrFine( src,options )
{
  var result = '';
  var simple = 1;

  if( options.level >= options.levels )
  {
    return { text : _toStrShort( src,options ), simple : 1 };
  }

  var isAtomic = _.atomicIs( src );
  var isArray = _.arrayLike( src );
  var isObject = !isArray && _.objectLike( src );

  if( options.noAtomic )
  if( _.atomicIs( src ) )
  return;

  /*options.noError = 1;*/

  if( isArray && options.noArray )
  return;

  if( isObject && options.noObject )
  return;

  //

  if( !isAtomic && _.routineIs( src.toStr ) && !src.toStr.notMethod )
  {
    var r = src.toStr( options );
    if( _.objectIs( r ) )
    {
      _assert( r.simple !== undefined && r.text !== undefined );
      simple = r.simple;
      result += r.text;
    }
    else if( _.strIs( r ) )
    {
      simple = r.indexOf( '\n' ) === -1;
      result += r;
    }
    else throw _.err( 'unexpected' );
  }
  else if( _.rowIs( src ) )
  {
    if( options.noRow )
    return;
    result += _.row.toStr( src,options );
  }
  else if( _.errorIs( src ) && !options.errorAsMap )
  {
    if( options.noError )
    return;
    result += src.toString();
    /*result += src.message;*/
  }
  else if( _.routineIs( src ) )
  {
    if( options.noRoutine )
    return;
    result += '{ routine ' + ( src.name || 'noname' ) + ' }';
  }
  else if( _.numberIs( src ) )
  {
    if( options.noNumber )
    return;
    result += _toStrFromNumber( src,options );
  }
  else if( _.strIs( src ) )
  {
    if( options.noString )
    return;
    result += _toStrFromStr( src,options );
  }
  else if( src instanceof Date )
  {
    if( options.noDate )
    return;

    result += src.toISOString();
  }
  else if( isArray )
  {
    var r = _toStrFromArray( src,options );
    result += r.text;
    simple = r.simple;
  }
  else if( isObject )
  {
    var r = _toStrFromObject( src,options );
    result += r.text;
    simple = r.simple;
  }
  else if( !isAtomic && _.routineIs( src.toString ) )
  {
    /*throw _.err( 'not tested' );*/
    result += src.toString();
  }
  else
  {
    result += String( src );
  }

  return { text : result, simple : simple };
}

//

var _toStrShort = function( src,options )
{
  var result = '';

  if( _.rowIs( src ) )
  {
    result += '[ Row with ' + src.length + ' elements' + ' ]';
  }
  else if( _.errorIs( src ) )
  {
    result += _ObjectToString.call( src );
  }
  else if( _.routineIs( src ) )
  {
    result += _ObjectToString.call( src );
  }
  else if( _.numberIs( src ) )
  {
    result += _toStrFromNumber( src,options );
  }
  else if( _.strIs( src ) )
  {
    var maxStringLength = 40;
    var nl = src.substr( 0,Math.min( src.length,maxStringLength ) ).indexOf( '\n' );
    if( nl === -1 ) nl = src.length;
    if( src.length > maxStringLength || nl !== src.length )
    {
      result += '"' + src.substr( 0,Math.min( maxStringLength,nl ) ) + '"' + '...';
    }
    else
    result += '"' + src + '"';
  }
  else if( src && !_.objectIs( src ) && _.numberIs( src.length ) )
  {

    result += '[ ' + strTypeOf( src ) + ' with ' + src.length + ' elements ]';

  }
  else if( _.objectIs( src ) || _.objectLike( src ) )
  {

    result += '{ ' + strTypeOf( src ) + ' with ' + _.entityLength( src ) + ' elements' + ' }';

  }
  else
  {
    result += String( src );
  }

  return result;
}

//

var _toStrFromNumber = function( src,options )
{
  var result = '';

  if( _.numberIs( options.precision ) )
  result += src.toPrecision( options.precision );
  else if( _.numberIs( options.fixed ) )
  result += src.toFixed( options.fixed );
  else
  result += String( src );

  return result;
}

//

var _toStrFromStr = function( src,options )
{
  var result = '';

  if( options.unescape )
  {
    result += '"';
    for( var s = 0 ; s < src.length ; s++ )
    {
      var c = src[ s ];
      switch( c )
      {

        case '\\' :
          debugger;
          result += '\\\\';
          break;

        case '\n' :
          result += '\\n';
          break;

        default :
          result += c;

      }
    }
    result += '"';
  }
  else
  {
    result = '"' + src + '"';
  }

  return result;
}

//

var _toStrFromArray = function( src,options )
{
  var result = '';

  _assert( src && _.numberIs( src.length ) );

  if( options.level >= options.levels )
  {
    return { text : _toStrShort( src,options ), simple : 1 };
  }

  if( src.length === 0 )
  {
    if( !options.wrap )
    return { text : '', simple : 1 };
    return { text : '[]', simple : 1 };
  }

  //

  var length = src.length;
  var o = _.mapExtend( {},options );
  o.tab = options.tab + options.dtab;
  o.level = options.level + 1;
  o.prependTab = 0;

  //

  var simple = !options.multiline;
  if( simple )
  for( var i = 0 ; i < length ; i++ )
  {
    simple = _toStrIsSimpleElement( src[ i ] );;
    if( !simple )
    break;
  }

  //

  result += _toStrFromContainer
  ({
    values : src,
    containerOptions : options,
    itemOptions : o,
    simple : simple,
    prefix : '[',
    postfix : ']',
  });

  return { text : result, simple : simple };
}

//

var _toStrFromObject = function( src,options )
{
  var result = '';

  _assert( _.objectIs( src ) || _.objectLike( src ) );

  if( options.level >= options.levels )
  {
    return { text : _toStrShort( src,options ), simple : 1 };
  }

  if( options.noObject )
  return;

  //

  var names = _.mapKeys( src );
  var length = names.length;
  if( length === 0 )
  {
    if( !options.wrap )
    return { text : '', simple : 1 };
    return { text : '{}', simple : 1 };
  }

  //

  var simple = !options.multiline;
  if( simple )
  simple = length < 4;
  if( simple )
  for( var k in src )
  {
    simple = _toStrIsSimpleElement( src[ k ] );
    if( !simple )
    break;
  }

  //

  var o = _.mapExtend( {},options );
  o.noObject = options.noSubObject ? 1 : 0;
  o.tab = options.tab + options.dtab;
  o.level = options.level + 1;
  o.prependTab = 0;

  result += _toStrFromContainer
  ({
    values : src,
    names : names,
    containerOptions : options,
    itemOptions : o,
    simple : simple,
    prefix : '{',
    postfix : '}',
  });

  return { text : result, simple : simple };
}

//

var _toStrFromContainer = function( options )
{
  var result = '';

  var values = options.values;
  var names = options.names;
  var containerOptions = options.containerOptions;
  var o = options.itemOptions;

  var simple = options.simple;
  var prefix = options.prefix;
  var postfix = options.postfix;

  // line postfix

  var linePostfix = '';
  if( containerOptions.comma )
  linePostfix += containerOptions.comma;
  if( !simple )
  linePostfix += '\n' + o.tab;

  // prepend

  if( containerOptions.prependTab  )
  {
    if( containerOptions.wrap )
    {
      //if( !simple )
      //result += '\n';
      result += containerOptions.tab;
    }
  }

  // wrap

  if( containerOptions.wrap )
  {
    result += prefix;
    if( simple )
    result += ' ';
    else
    result += '\n' + o.tab;
  }
  else if( !simple )
  {
    /*result += '\n' + o.tab;*/
  }

  // prepend

  if( containerOptions.prependTab  )
  {
    if( !containerOptions.wrap )
    {
      //if( !simple )
      //result += '\n';
      result += o.tab;
    }
  }

  //

  var r;
  var written = 0;
  for( var n = 0, l = ( names ? names.length : values.length ) ; n < l ; n++ )
  {

    _assert( o.tab === containerOptions.tab + containerOptions.dtab );
    _assert( o.level === containerOptions.level + 1 );

    if( names )
    r = _toStrFine( values[ names[ n ] ],o );
    else
    r = _toStrFine( values[ n ],o );

    if( r === undefined )
    continue;

    if( r.text === undefined )
    continue;

    _assert( o.tab === containerOptions.tab + containerOptions.dtab );

    if( written > 0 )
    result += linePostfix;

    if( names )
    {
      result += String( names[ n ] ) + containerOptions.colon;
      if( !r.simple )
      result += '\n' + o.tab;

    }

    result += r.text;
    written += 1;

  }

  // wrap

  if( containerOptions.wrap )
  {
    if( simple )
    result += ' ';
    else
    result += '\n' + containerOptions.tab;
    result += postfix;
  }

  return result;
}

//

var _toStrIsSimpleElement = function( element )
{
  if( _.strIs( element ) )
  return element.length < 40;
  else if( element && !_.objectIs( element ) && _.numberIs( element.length ) )
  return !element.length;
  else if( _.objectIs( element ) || _.objectLike( element ) )
  return !_.entityLength( element );
  else
  return _.atomicIs( element );
}

//

var toStrForRange = function( range )
{
  var result;

  _assert( arguments.length === 1 );
  _assert( _.arrayIs( range ) );

  result = '[ ' + range[ 0 ] + '..' + range[ 1 ] + ' ]';

  return result;
}

//

var toStrForCall = function( nameOfRoutine,args,ret,options )
{
  var result = nameOfRoutine + '( ';
  var first = true;

  _assert( _.arrayIs( args ) || _.objectIs( args ) );
  _assert( arguments.length <= 4 );

  _.each( args,function( e,k )
  {

    if( first === false )
    result += ', ';

    if( _.objectIs( e ) )
    result += k + ':' + _.toStr( e,options );
    else
    result += _.toStr( e,options );

    first = false;

  });

  result += ' )';

  if( arguments.length >= 3 )
  result += ' -> ' + _.toStr( ret,options );

  return result;
}

//

var strCapitalize = function( src )
{
  _.assert( _.strIs( src ) );
  _.assert( arguments.length === 1 );
  return src[ 0 ].toUpperCase() + src.substring( 1 );
}

//

var strTimes = function( s,times )
{
  var result = '';

  _.assert( arguments.length === 2 );
  _.assert( _.numberIs( times ) );

  for( var t = 0 ; t < times ; t++ )
  result += s;

  return result;
}

//

var strLineCount = function( src )
{
  var result = src.indexOf( '\n' ) !== -1 ? src.split( '\n' ).length : 1;
  return result;
}

//

var strSplitStrNumber = function( src )
{
  var result = {};
  var mnumber = src.match(/\d+/);
  if( mnumber && mnumber.length )
  {
    var mstr = src.match(/[^\d]*/);
    result.str = mstr[ 0 ];
    result.number = _.numberFrom( mnumber[0] );
  }
  else result.str = src;
  return result;
}

//

var strSplitChunks = function( src,options )
{

  var result = { chunks : [] };
  var options = options || {};

  _.mapSupplement( options,strSplitChunks.defaults );
  _.assertMapOnly( options,strSplitChunks.defaults );
  _.assert( _.strIs( src ) );

  if( !_.regexpIs( options.prefix ) )
  options.prefix = RegExp( _.regexpEscape( options.prefix ),'m' );

  if( !_.regexpIs( options.postfix ) )
  options.postfix = RegExp( _.regexpEscape( options.postfix ),'m' );

  //

  var columnEval = function( text )
  {
    var i = text.lastIndexOf( '\n' );

    if( i === -1 )
    {
      column += text.length;
    }
    else
    {
      column = text.length - i;
    }

    _.assert( column >= 0 );
  }

  //

  var line = 0;
  var column = 0;
  var chunkIndex = 0;
  while( src )
  {

    /* begin */

    var begin = src.search( options.prefix );
    if( begin === -1 ) begin = src.length;

    /* text chunk */

    if( begin > 0 )
    {
      var chunk = {};
      chunk.line = line;
      chunk.text = src.substring( 0,begin );
      chunk.index = chunkIndex;
      result.chunks.push( chunk );

      src = src.substring( begin );
      line += _.strLineCount( chunk.text ) - 1;
      chunkIndex += 1;

      columnEval( chunk.text );

    }

    /* break */

    if( !src )
    break;

    /* end */

    var end = src.search( options.postfix );
    if( end === -1 )
    {
      result.lines = src.split( '\n' ).length;
      result.error = _.err( 'Openning prefix',options.prefix,'of chunk #' + result.chunks.length,'at'+line,'line does not have closing tag:',options.postfix );
      return result;
    }

    /* code chunk */

    var chunk = {};
    chunk.line = line;
    chunk.column = column;
    chunk.index = chunkIndex;
    chunk.prefix = src.match( options.prefix )[ 0 ];
    chunk.code = src.substring( chunk.prefix.length,end );
    if( options.investigate )
    {
      chunk.lines = chunk.code.split( '\n' );
      chunk.tab = /^\s*/.exec( chunk.lines[ chunk.lines.length-1 ] )[ 0 ];
    }

    columnEval( chunk.code );

    result.chunks.push( chunk );

    /* postfix */

    src = src.substring( chunk.prefix.length + chunk.code.length );
    chunk.postfix = src.match( options.postfix )[ 0 ];
    src = src.substring( chunk.postfix.length );

    /* wind */

    chunkIndex += 1;
    line += _.strLineCount( chunk.prefix + chunk.code + chunk.postfix ) - 1;

  }

  return result;
}

strSplitChunks.defaults =
{
  investigate : 1,
  prefix : '//>-' + '->//',
  postfix : '//<-' + '-<//',
}

//

var strInhalf = function( o )
{
  var result = [];

  if( _.strIs( o ) )
  o = { src : o };

  //logger.log( 'strInhalf.src :',o.src );

  _.mapSupplement( o,strInhalf.defaults );
  _.assertMapOnly( o,strInhalf.defaults );
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( o.src ) );
  _.assert( _.strIs( o.splitter ) || _.arrayIs( o.splitter ) );

  o.splitter = _.arrayAs( o.splitter );

  if( !o.splitter.length )
  return [ o.src,'' ];

  var splitter = _.entityMin( o.splitter,function( a )
  {

    var index = o.src.indexOf( a );
    if( index === -1 )
    return o.src.length;

    return index;
  });

  result[ 0 ] = o.src.substring( 0,splitter.value );
  result[ 1 ] = o.src.substring( splitter.value + o.splitter[ splitter.index ].length );

  //logger.log( 'strInhalf.result :',result );

  return result;
}

strInhalf.defaults =
{
  src : null,
  splitter : ' ',
}

//

var strSplit = function( o )
{

  if( _.strIs( o ) )
  o = { src : o };

  _.mapSupplement( o,strSplit.defaults );
  _.assertMapOnly( o,strSplit.defaults );
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( o.src ) );
  _.assert( _.strIs( o.splitter ) || _.arrayIs( o.splitter ) );

  var splitter = _.arrayIs( o.splitter ) ? o.splitter.slice() : [ o.splitter ];
  var result = o.src.split( splitter[ 0 ] );
  splitter.splice( 0,1 );

  /**/

  while( splitter.length )
  {

    for( var r = result.length-1 ; r >= 0 ; r-- )
    {

      var sub = result[ r ].split( splitter[ 0 ] );
      if( sub.length > 1 )
      _.arraySplice( result,r,r+1,sub );

    }

    splitter.splice( 0,1 );

  }

  /**/

  for( var r = result.length-1 ; r >= 0 ; r-- )
  {

    if( o.strip )
    result[ r ] = strStrip( result[ r ] );
    if( !result[ r ] )
    result.splice( r,1 );

  }

  return result;
}

strSplit.defaults =
{
  src : null,
  splitter : ' ',
  strip : 1,
}

//

var strStrip = function( o )
{

  if( _.strIs( o ) )
  o = { src : o };

  _.mapSupplement( o,strStrip.defaults );
  _.assertMapOnly( o,strStrip.defaults );
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( o.src ),'expects string or array o.src, got',_.strTypeOf( o.src ) );
  _.assert( _.strIs( o.stripper ) || _.arrayIs( o.stripper ),'expects string or array o.stripper' );

  //logger.log( 'strStrip.src :',o.src ); debugger;

  if( o.stripper === ' ' )
  {
    return o.src.replace( /^(\s|\n|\0)+|(\s|\n|\0)+$/gm,'' );
  }
  else
  {

    o.stripper = _.arrayAs( o.stripper );

    for( var b = 0 ; b < o.src.length ; b++ )
    if( o.stripper.indexOf( o.src[ b ] ) === -1 )
    break;

    for( var e = o.src.length-1 ; e >= 0 ; e-- )
    if( o.stripper.indexOf( o.src[ e ] ) === -1 )
    break;

    //logger.log( 'strStrip.result :',o.src.substring( b,e+1 ) );

    return o.src.substring( b,e+1 );
  }

}

strStrip.defaults =
{
  src : null,
  stripper : ' ',
}

//

var strRemoveAllSpaces = function( src,sub )
{
  if( sub === undefined ) sub = '';
  return src.replace( /\s/g,sub );
}

//

var strStripEmptyLines = function( srcStr )
{
  var result = '';
  var lines = srcStr.split( '\n' );

  _.assert( _.strIs( srcStr ) );
  _.assert( arguments.length === 1 );

  for( var l = 0; l < lines.length; l += 1 )
  {
    var line = lines[ l ];

    if( !_.strStrip( line ) )
    continue;

    result += line + '\n';
  }

  return result;
}

//

var strIron = function()
{
t
  var result = '';

  for( var a = 0 ; a < arguments.length ; a++ )
  {

    var argument = arguments[ a ];

    if( !_.strIs( argument ) && !_.objectIs( argument ) && !_.arrayIs( argument ) )
    throw _.err( '_.strIron:','argument could be string, array or object' );

    if( _.strIs( argument ) )
    {
      result += argument;
    }
    else _.each( argument,function( e,k,i ){

      result += _.strIron( e );

    });

  }

  return result;
}

//

var strReplaceAll = function( src, ins, sub )
{
  return src.replace( new RegExp( _.regexpEscape( ins ),'gm' ), sub );
}

  //

var strReplaceNames = function( src,ins,sub )
{
  _.assert( _.arrayIs( ins ) );
  _.assert( _.arrayIs( sub ) );
  _.assert( ins.length === sub.length );

  var result = src;
  for( var i = 0 ; i < ins.length ; i++ )
  {
    var r = new RegExp( '(\\W|^)' + ins[ i ] + '(?=\\W|$)','gm' );
    result = result.replace( r,function( original )
    {

      if( original[ 0 ] !== sub[ i ][ 0 ] )
      return original[ 0 ] + sub[ i ];
      else
      return sub[ i ];

    });
  }

  return result;
}

//

var strJoin = function()
{
  var result = [ '' ];
  var arrayEncountered = 0;
  var arrayLength;

  var join = function( s,src )
  {
    result[ s ] += src;
  }

  /**/

  for( var a = 0 ; a < arguments.length ; a++ )
  {
    var src = arguments[ a ];

    _.assert( _.strIs( src ) || _.numberIs( src ) || _.arrayIs( src ) );

    if( _.arrayIs( src ) )
    {

      if( arrayEncountered === 0 )
      for( var s = 1 ; s < src.length ; s++ )
      result[ s ] = result[ 0 ];

      _.assert( arrayLength === undefined || arrayLength === src.length, 'strJoin : all arrays should has same length' );

      arrayEncountered = 1;
      for( var s = 0 ; s < src.length ; s++ )
      join( s,src[ s ] );

    }
    else
    {

      for( var s = 0 ; s < result.length ; s++ )
      join( s,src );

    }

  }

  if( arrayEncountered )
  return result;
  else
  return result[ 0 ];
}

//

var strUnjoin = function( srcStr,maskArray )
{

  _.assert( arguments.length === 2 );
  _.assert( _.strIs( srcStr ) );
  _.assert( _.arrayIs( maskArray ) );

  var result = [];
  var index = 0;
  var rindex = -1;

  /**/

  var checkRoutine = function()
  {

    if( rindex !== -1 )
    {
      _.assert( rindex <= index );
      result.push( srcStr.substring( rindex,index ) );
      rindex = -1;
      return true;
    }

    return false;
  }

  /**/

  var checkMask = function( mask )
  {

    _.assert( _.strIs( mask ) || _.routineIs( mask ) )

    if( _.strIs( mask ) )
    {
      index = srcStr.indexOf( mask,index );

      if( index === -1 )
      return false;

      checkRoutine();

      result.push( mask );
      index += mask.length;

    }
    else if( _.routineIs( mask ) )
    {
      rindex = index;
    }

    return true;
  }

  /**/

  for( var m = 0 ; m < maskArray.length ; m++ )
  {

    var mask = maskArray[ m ];

    if( !checkMask( mask ) )
    return;

  }

  if( checkRoutine() )
  debugger;

  /**/

  return result;
}

strUnjoin.any = function( src )
{
  return src;
}

//

var strDropPrefix = function( src,prefix )
{
  if( src.indexOf( prefix ) !== -1 )
  return src.substr( prefix.length,src.length-prefix.length );
  else return src;
}

//

var strDropPostfix = function( src,postfix )
{
  throw _.err( 'Not tested' );
  var l = src.length - postfix.length;
  if( src.length > postfix.length && src.indexOf( postfix ) === l )
  return src.substr( 0,l );
  else return src;
}

//

var strDifference = function( src1,src2,options )
{
  _assert( _.strIs( src1 ) );
  _assert( _.strIs( src2 ) );

  if( src1 === src2 )
  return false;

  for( var i = 0, l = Math.min( src1.length, src2.length ) ; i < l ; i++ )
  if( src1[ i ] !== src2[ i ] )
  return src1.substr( 0,i ) + '*';

  return src1.substr( 0,i ) + '*';
}

//

var strSimilarity = function( src1,src2,options )
{
  _assert( _.strIs( src1 ) );
  _assert( _.strIs( src2 ) );

  var latter = [ _.strLattersSpectre( src1 ),_.strLattersSpectre( src2 ) ];
  var result = _.lattersSpectreComparison( latter[ 0 ],latter[ 1 ] );
  return result;
}

//

var strLattersSpectre = function( src )
{

  var result = {};

  for( var s = 0 ; s < src.length ; s++ )
  {
    if( !result[ src[ s ] ] ) result[ src[ s ] ] = 1;
    else result[ src[ s ] ] += 1;
  }

  result.length = src.length;
  return result;
}

//

var lattersSpectreComparison = function( src1,src2 )
{

  var same = 0;

  if( src1.length === 0 && src2.length === 0 ) return 1;

  for( var l in src1 )
  {
    if( l === 'length' ) continue;
    if( src2[ l ] ) same += Math.min( src1[ l ],src2[ l ] );
  }

  return same / Math.max( src1.length,src2.length );
}

//

var strToDom = function( xmlStr )
{

  var xmlDoc = null;
  var isIEParser = window.ActiveXObject || "ActiveXObject" in window;

  if( xmlStr === undefined ) return xmlDoc;

  if ( window.DOMParser )
  {

    var parser = new window.DOMParser();
    var parsererrorNS = null;

    if( !isIEParser ) {

      try {
        parsererrorNS = parser.parseFromString( "INVALID", "text/xml" ).childNodes[0].namespaceURI;
      }
      catch( err ) {
        parsererrorNS = null;
      }
    }

    try
    {
      xmlDoc = parser.parseFromString( xmlStr, "text/xml" );
      if( parsererrorNS!= null && xmlDoc.getElementsByTagNameNS( parsererrorNS, "parsererror" ).length > 0 )
      {
        throw 'Error parsing XML';
        xmlDoc = null;
      }
    }
    catch( err )
    {
      throw 'Error parsing XML';
      xmlDoc = null;
    }
  }
  else
  {
    if( xmlStr.indexOf( "<?" )==0 )
    {
      xmlStr = xmlStr.substr( xmlStr.indexOf( "?>" ) + 2 );
    }
    xmlDoc = new ActiveXObject( "Microsoft.XMLDOM" );
    xmlDoc.async = "false";
    xmlDoc.loadXML( xmlStr );
  }

  return xmlDoc;
};

//

var _strHtmlEscapeMap =
{
  '&' : '&amp;',
  '<' : '&lt;',
  '>' : '&gt;',
  '"' : '&quot;',
  '\'': '&#39;',
  '/' : '&#x2F;'
};

var strHtmlEscape = function( str )
{
  return String( str ).replace( /[&<>"'\/]/g, function( s )
  {
    return _strHtmlEscapeMap[ s ];
  });
}

//

var strToConfig = function( src,options ){

  var result = {};
  if( !_.strIs( src ) ) throw _.err( '_.strToConfig:','require string' );

  var options = options || {};
  if( options.delimeter === undefined ) options.delimeter = ':';

  var src = src.split( '\n' );

  for( var s = 0 ; s < src.length ; s++ )
  {

    var row = src[ s ];
    var i = row.indexOf( options.delimeter );
    if( i === -1 ) continue;

    var key = row.substr( 0,i ).trim();
    var val = row.substr( i+1 ).trim();

    result[ key ] = val;

  }

  return result;
}

//

var strIndentation = function( src,tab )
{

  _assert( _.strIs( src ),'strIndentation:','argument must be string' );
  _assert( _.strIs( tab ),'strIndentation:','argument must be string' );

  if( src.indexOf( '\n' ) === -1 ) return tab + src;

  var result = src.split( '\n' );
  result = tab + result.join( '\n' + tab );

  return result;
}

//

var strNumberLines = function( srcStr )
{

  var lines = srcStr.split( '\n' );

  for( var l = 0; l < lines.length; l += 1 )
  {

    lines[ l ] = ( l + 1 ) + ': ' + lines[ l ];

  }

  return lines.join( '\n' );
}

//

var strCount = function( src,ins )
{
  var result = -1;

  _.assert( _.strIs( src ) );
  _.assert( _.strIs( ins ) );

  var i = -1;
  do
  {
    result += 1;
    i = src.indexOf( ins,i+1 );
  }
  while( i !== -1 );

  return result;
}

//

var strToBytes = function( str )
{

  var result = new Uint8Array( str.length );

  for( var s = 0, sl = str.length ; s < sl ; s++ )
  {
    result[ s ] = str.charCodeAt( s );
  }

  return result;
}

//

var strTimeFormat = function( time )
{
  var result = strMetricFormat( time*0.001,{ fixed : 3 } ) + 's';
  return result;
}

// -- number

var _metrics =
{

  '24'  : { name : 'yotta', symbol : 'Y' , word : 'septillion' },
  '21'  : { name : 'zetta', symbol : 'Z' , word : 'sextillion' },
  '18'  : { name : 'exa'  , symbol : 'E' , word : 'quintillion' },
  '15'  : { name : 'peta' , symbol : 'P' , word : 'quadrillion' },
  '12'  : { name : 'tera' , symbol : 'T' , word : 'trillion' },
  '9'   : { name : 'giga' , symbol : 'G' , word : 'billion' },
  '6'   : { name : 'mega' , symbol : 'M' , word : 'million' },
  '3'   : { name : 'kilo' , symbol : 'k' , word : 'thousand' },
  '2'   : { name : 'hecto', symbol : 'h' , word : 'hundred' },
  '1'   : { name : 'deca' , symbol : 'da', word : 'ten' },

  '0'   : { name : ''     , symbol : ''  , word : '' },

  '-1'  : { name : 'deci' , symbol : 'd' , word : 'tenth' },
  '-2'  : { name : 'centi', symbol : 'c' , word : 'hundredth' },
  '-3'  : { name : 'milli', symbol : 'm' , word : 'thousandth' },
  '-6'  : { name : 'micro', symbol : 'μ' , word : 'millionth' },
  '-9'  : { name : 'nano' , symbol : 'n' , word : 'billionth' },
  '-12' : { name : 'pico' , symbol : 'p' , word : 'trillionth' },
  '-15' : { name : 'femto', symbol : 'f' , word : 'quadrillionth' },
  '-18' : { name : 'atto' , symbol : 'a' , word : 'quintillionth' },
  '-21' : { name : 'zepto', symbol : 'z' , word : 'sextillionth' },
  '-24' : { name : 'yocto', symbol : 'y' , word : 'septillionth' },

  range : [ -24,+24 ],

}

var strMetricFormat = function( number,options )
{

  var options = options || {};

  if( _.strIs( number ) ) number = parseFloat( number );
  if( !_.numberIs( number ) ) throw _.err( 'strMetricFormat:','"number" should be Number' );

  if( options.divisor === undefined ) options.divisor = 3;
  if( options.thousand === undefined ) options.thousand = 1000;
  if( options.fixed === undefined ) options.fixed = 1;
  if( options.dimensions === undefined ) options.dimensions = 1;
  if( options.metric === undefined ) options.metric = 0;

  if( options.dimensions !== 1 ) options.thousand = Math.pow( options.thousand,options.dimensions );

  var metric = options.metric;
  var original = number;

  if( Math.abs( number ) > options.thousand )
  {

    while( Math.abs( number ) > options.thousand || !_metrics[ String( metric ) ] )
    {

      if( metric + options.divisor > _metrics.range[ 1 ] ) break;

      number /= options.thousand;
      metric += options.divisor;

    }

  }
  else if( Math.abs( number ) < 1 )
  {

    while( Math.abs( number ) < 1 || !_metrics[ String( metric ) ] )
    {

      if( metric - options.divisor < _metrics.range[ 0 ] ) break;

      number *= options.thousand;
      metric -= options.divisor;

    }

  }

  var result = '';

  if( _metrics[ String( metric ) ] )
  {
    result = number.toFixed( options.fixed ) + ' ' + _metrics[ String( metric ) ].symbol;
  }
  else
  {
    result = original.toFixed( options.fixed ) + ' ';
  }

  return result;
}

//

var strMetricFormatBytes = function( number,options )
{

  var options = options || {};
  var defaultOptions =
  {
    divisor : 3,
    thousand : 1024,
  };

  _.mapSupplement( options,defaultOptions );

  return _.strMetricFormat( number,options ) + 'b';
}

//

var strCsvFrom = function( src,options )
{

  var result = '';
  var options = options || {};

  if( !options.header )
  {

    options.header = [];

    _.eachRecursive( _.entityValueWithIndex( src,0 ),function( e,k,i ){
      options.header.push( k );
    });

  }

  if( options.cellSeparator === undefined ) options.cellSeparator = ',';
  if( options.rowSeparator === undefined ) options.rowSeparator = '\n';
  if( options.substitute === undefined ) options.substitute = '';
  if( options.withHeader === undefined ) options.withHeader = 1;

  //console.log( 'options',options );

  if( options.withHeader )
  {
    _.eachRecursive( options.header,function( e,k,i ){
      result += e + options.cellSeparator;
    });
    result = result.substr( 0,result.length-options.cellSeparator.length ) + options.rowSeparator;
  }

  _.each( src,function( row )
  {

    var rowString = '';

    _.each( options.header,function( key )
    {

      var element = _.entityWithKeyRecursive( row,key );
      if( element === undefined ) element = '';
      element = String( element );
      if( element.indexOf( options.rowSeparator ) !== -1 ) element = _.strReplaceAll( element,options.rowSeparator,options.substitute );
      if( element.indexOf( options.cellSeparator ) !== -1 ) element = _.strReplaceAll( element,options.cellSeparator,options.substitute );

      rowString += element + options.cellSeparator;

    });

    result += rowString.substr( 0,rowString.length-options.cellSeparator.length ) + options.rowSeparator;

  });

  return result;
}


//

var strCamelize = function( srcStr )
{
  var result = srcStr;
  var regexp = /\.\w|-\w|_\w|\/\w/g;

  var result = result.replace( regexp,function( match )
  {
    return match[ 1 ].toUpperCase();
  });

  return result;
}

//

var strFilenameFor = function( srcStr,options )
{
  var result = srcStr;
  var options = options || {};
  if( options.separator === undefined )
  options.separator = '_';

  var regexp = /<|>|:|"|'|\/|\\|\||\&|\?|\*|\n|\s/g;

  var result = result.replace( regexp,function( match )
  {
    return options.separator;
  });

  return result;
}

// --
// prototype
// --

var Proto =
{

  toStrMethods: toStrMethods,
  toStrFields: toStrFields,

  toStrFine_gen: toStrFine_gen,
  _toStrFine: _toStrFine,

  _toStrShort: _toStrShort,
  _toStrFromNumber: _toStrFromNumber,
  _toStrFromStr: _toStrFromStr,
  _toStrFromArray: _toStrFromArray,
  _toStrFromObject: _toStrFromObject,
  _toStrFromContainer: _toStrFromContainer,
  _toStrIsSimpleElement: _toStrIsSimpleElement,

  toStrForRange: toStrForRange,
  toStrForCall: toStrForCall,

  strCapitalize: strCapitalize,
  strTimes: strTimes,
  strLineCount: strLineCount,
  strSplitStrNumber: strSplitStrNumber,
  strSplitChunks: strSplitChunks,

  strInhalf: strInhalf,
  strSplit: strSplit,
  strStrip: strStrip,
  strRemoveAllSpaces: strRemoveAllSpaces,
  strStripEmptyLines: strStripEmptyLines,

  strIron: strIron,

  strReplaceAll: strReplaceAll,
  strReplaceNames: strReplaceNames,

  strJoin: strJoin,
  strUnjoin: strUnjoin,

  strDropPrefix: strDropPrefix,
  strDropPostfix: strDropPostfix,

  strDifference: strDifference,
  strSimilarity: strSimilarity,
  strLattersSpectre: strLattersSpectre,
  lattersSpectreComparison: lattersSpectreComparison,

  strToDom: strToDom,
  strHtmlEscape: strHtmlEscape,

  strToConfig: strToConfig,

  strIndentation: strIndentation,
  strNumberLines: strNumberLines,

  strCount: strCount,

  strToBytes: strToBytes,

  strTimeFormat: strTimeFormat,
  strMetricFormat: strMetricFormat,
  strMetricFormatBytes: strMetricFormatBytes,

  strCsvFrom: strCsvFrom,

  strCamelize: strCamelize,
  strFilenameFor: strFilenameFor,

}

_.mapExtend( Self, Proto );

//

var toStrFine = Self.toStrFine = Self.toStrFine_gen();
var toStr = Self.toStr = Self.strFrom = toStrFine;

//

if( typeof module !== 'undefined' && module !== null )
{
  module[ 'exports' ] = Self;
}

})();
