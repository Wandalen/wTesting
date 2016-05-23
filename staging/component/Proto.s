(function(){

'use strict';

var Self = wTools;
var _ = wTools;

var _ArraySlice = Array.prototype.slice;
var _FunctionBind = Function.prototype.bind;
var _ObjectToString = Object.prototype.toString;
var _ObjectHasOwnProperty = Object.hasOwnProperty;

var _assert = _.assert;
var _arraySlice = _.arraySlice;
var nameFielded = _.nameFielded;

// --
// property
// --

var _accessorOptions = function( object,names )
{
  var options = arguments.length === 1 ? arguments[ 0 ] : {};

  if( arguments.length === 1 )
  {
    object = options.object;
    names = options.names;
  }
  else
  {
    options.object = object;
  }

  if( !options.methods )
  options.methods = object;

  var names = options.names = nameFielded( names );

  if( arguments.length > 2 )
  {
    options.args = _.arraySlice( arguments,2 );
  }

  return options;
}

//

var _accessor = function( options )
{
  var object = options.object;
  var names = options.names;
  var methods = options.methods;

  _assert( !_.atomicIs( object ) );
  _assert( !_.atomicIs( methods ) );

  if( options.strict === undefined )
  options.strict = true;

  if( options.enumerable === undefined )
  options.enumerable = true;

  // verification

  if( options.strict && !options.noField /*&& !object[ '_SelfGet' ]*/ )
  {

    var has =
    {
      constructor : 'constructor',
    }

    var hasNot =
    {
      Type : 'Type',
      type : 'type',
    }

    _.assertMapOwnAll( object,has );
    /*_.assertMapOwnNone( object,hasNot );*/
    _.accessorForbidOnce( object,hasNot );

  }

  _assert( _.objectLike( object ),'_.accessor:','expects object as argument but got', object );
  _assert( _.objectIs( names ),'_.accessor:','expects object names as argument but got', names );

  //

  var _name = names;
  for( var n in _name )
  {

    (function _accessor()
    {

      var encodedName = n;
      var rawName = _name[ n ];

      var redefinition = false;
      var parent = object.constructor ? object.constructor.prototype.__proto__ : null;
      if( parent )
      redefinition = parent[ rawName + 'Get' ] !== undefined || parent[ '_' + rawName + 'Get' ] !== undefined;

      var setter = methods[ '_' + rawName + 'Set' ] ? methods[ '_' + rawName + 'Set' ] : methods[ rawName + 'Set' ];
      var getter = methods[ '_' + rawName + 'Get' ] ? methods[ '_' + rawName + 'Get' ] : methods[ rawName + 'Get' ];

/*
      if( rawName === 'Parent' )
      console.log( 'rawName:',rawName );
*/

      var fieldName = '_' + rawName;
      var fieldSymbol = Symbol.for( rawName );
      var needPrivateField = !_ObjectHasOwnProperty.call( object,fieldName );
      var message = options.args;

      if( !options.noField )
      if( _ObjectHasOwnProperty.call( object,encodedName ) )
      object[ fieldSymbol ] = object[ encodedName ];

      // setter

      if( !setter && !options.readOnly )
      if( message )
      setter = function setter( src )
      {
        console.info.apply( console,message );
        this[ fieldSymbol ] = src;
      }
      else
      setter = function setter( src )
      {
        this[ fieldSymbol ] = src;
      }

      _assert( !setter || !options.readOnly,'accessor:','readOnly but setter found in',object );

      // getter

      if( !getter )
      if( message )
      getter = function getter()
      {
        console.info.apply( console,message );
        return this[ fieldSymbol ];
      }
      else
      getter = function getter()
      {
        return this[ fieldSymbol ];
      }

      // define accessor

      Object.defineProperty( object, encodedName,
      {
        set : setter,
        get : getter,
        enumerable : options.enumerable,
        configurable : false,
      });

      // define private field

      if( !options.noField && !redefinition )
      {
        var m =
        [ 'use Symbol.for( \'' + rawName + '\' ) ',
          'to get direct access to property\'s field, ',
          'not ' + fieldName,
        ].join( '' );
        _.accessorForbid( object,fieldName,m );
      }

      // cache private field

    })();

  }

  //goog.exportProperty( object,names );
  //goog.exportProperty( object,names + 'Set',object[ names + 'Set' ] );
  //goog.exportProperty( object,names + 'Get',object[ names + 'Get' ] );

  //goog.exportSymbol( names );
  //goog.exportSymbol( names + 'Set',object[ names + 'Set' ] );
  //goog.exportSymbol( names + 'Get',object[ names + 'Get' ] );

  //ex. goog.exportSymbol('public.path.Foo.prototype.myMethod',
  //                      Foo.prototype.myMethod);
  //    new public.path.Foo().myMethod();

  // * ex. goog.exportSymbol('public.path.Foo.staticFunction', Foo.staticFunction);
  // *     public.path.Foo.staticFunction();

}

//

var accessor = function accessor( object,names )
{
  var options = _accessorOptions.apply( this,arguments );
  return _accessor( options );
}

//

var accessorForbid = function accessorForbid( object,names )
{
  var options = _accessorOptions.apply( this,arguments );
  var object = options.object;
  var names = options.names;

  if( options.override === undefined )
  options.override = false;

  // verification

  _assert( _.objectLike( object ),'_.accessor:','expects object as argument but got', object );
  _assert( _.objectIs( names ),'_.accessor:','expects object names as argument but got', names );


  // message

  _assert( object.constructor === null || object.constructor.name || object.constructor._name,'accessorForbid:','object should have name' );
  var protoName = ( object.constructor ? ( object.constructor.name || object.constructor._name || '' ) : '' ) + '.';
  var message = 'is deprecated';
  if( options.args )
  message = options.args.join( ' : ' );


  // property

  /*var stack = _.stack();*/
  var methods = {};
  for( var n in names )
  {

    var encodedName = n;
    var rawName = names[ n ];

    var setterName = '_' + rawName + 'Set';
    var getterName = '_' + rawName + 'Get';

    (function _accessorForbid()
    {

      var messageLine = protoName + rawName + ': ' + message;
      var handler = function forbidden()
      {
        /*console.log( 'stack :\n' + stack );*/
        /*_.errLog( messageLine );*/
        throw _.err( messageLine );
      }

      handler.forbid = true;

/*
      Object.defineProperty( object, setterName,
      {
        value : handler,
        enumerable : false,
        writable : false,
      });

      Object.defineProperty( object, getterName,
      {
        value : handler,
        enumerable : false,
        writable : false,
      });
*/

      methods[ setterName ] = handler;
      methods[ getterName ] = handler;

      if( !options.override )
      if( _ObjectHasOwnProperty.call( object,encodedName ) )
      {
        var descriptor = Object.getOwnPropertyDescriptor( object,encodedName );
        if( _.routineIs( descriptor.get ) && descriptor.get.name === _.nameUnfielded({ forbidden : 'forbidden' }).coded )
        delete names[ n ];
        else
        handler();
      }

    })();

  }

  options.noField = true;
  options.enumerable = false;
  options.names = names;
  options.object = object;
  options.methods = methods;

  return _accessor( options );
}

//

var accessorForbidOnce = function( object,names )
{
  var options = _accessorOptions.apply( this,arguments );
  var object = options.object;
  var names = options.names;

  //

  for( var n in names )
  {

    var encodedName = n;
    var rawName = names[ n ];
    var getterName = object[ rawName + 'Get' ] ? rawName + 'Get' : '_' + rawName + 'Get';

    var descriptor = Object.getOwnPropertyDescriptor( object,encodedName );

    if( !descriptor )
    continue;
    if( !descriptor.set )
    continue

    if( descriptor.set.forbid )
    delete names[ n ];

  }

  //

  return accessorForbid( options );
}

//

var accessorReadOnly = function accessorReadOnly( object,names )
{
  var options = _accessorOptions.apply( this,arguments );
  options.readOnly = true;
  return accessor( options );
}

//

/**
 * Makes constants properties.
 * @param {object} protoObject - prototype of class which will get new constant property.
 * @param {object} namesObject - name/value map of constants.
 * @method constant
 * @memberof _.Property#
 */

var constant = function( protoObject,namesObject )
{

  _assert( arguments.length === 2 );
  _assert( _.objectLike( protoObject ),'_.constant:','namesObject is needed:', protoObject );
  _assert( _.mapIs( namesObject ),'_.constant:','namesObject is needed:', namesObject );

  for( var n in namesObject )
  {

    var encodedName = n;
    var value = namesObject[ n ];

    Object.defineProperty( protoObject, encodedName,
    {
      value : value,
      enumerable : true,
      writable : false,
    });

  }

}

//

/**
 * Mixin methods and fields into prototype of another object.
 * @param {object} options - options.
 * @method mixin
 * @memberof wTools#
 */

var mixin = function( options )
{

  var dst = options.dst;
  var Functors = options.Functors;
  var Proto = options.Proto;

  _assert( arguments.length === 1 );
  _assert( _.objectIs( dst ) );
  _assert( _.strIs( options.name ) );
  _assert( _.mapIs( options.Proto ) );
  _.assertMapOnly( options,mixin.defaults );

  if( !_.mapIs( dst ) )
  {
    _assert( dst.constructor.prototype === dst,'mixin:','expects prototype with own constructor field' );
    _assert( dst.constructor.name.length > 0 || dst.constructor._name.length,'mixin:','constructor should has name' );
    _assert( _.routineIs( dst.init ) );
  }

  //

  _.mapComplement( dst,Proto );

  //

  if( options.Proto.Composes )
  propertyAddOwnComposes( dst,options.Proto.Composes,{ override : false } );

  if( options.Proto.Aggregates )
  propertyAddOwnAggregates( dst,options.Proto.Aggregates,{ override : false } );

  if( options.Proto.Restricts )
  propertyAddOwnRestricts( dst,options.Proto.Restricts,{ override : false } );

  //

  if( Functors )
  for( var m in Functors )
  dst[ m ] = Functors[ m ]( dst );

  //

  if( !dst._mixins )
  dst._mixins = {};

  _.assert( !dst._mixins[ options.name ],'same mixin enclountered several times' );

  dst._mixins[ options.name ] = 1;

}

mixin.defaults =
{
  dst : null,
  Proto : null,
  Functors : null,
  name : null,
}

//

/**
 * Add own defaults to object. Create new defaults container, if there is no such own.
 * @param {object} defaultsName - name of defualts container.
 * @param {object} dstProto - prototype of class which will get new constant property.
 * @param {object} srcDefaults - name/value map of defaults.
 * @param {object} options - options.
 * @param {bool} options.override - to override defaults if exist.
 * @method _propertyAddOwnDefaults
 * @memberof _.wTools#
 */

var _propertyAddOwnDefaults = function( defaultsName,dstProto,srcDefaults,options )
{
  var options = options || {};

  _assert( _.objectIs( srcDefaults ),'_.constant:','srcDefaults is needed:', srcDefaults );

  var defaultsName = _.nameUnfielded( defaultsName );

  if( !_ObjectHasOwnProperty.call( dstProto,defaultsName.coded ) )
  {
    var container = dstProto[ defaultsName.coded ];
    dstProto[ defaultsName.coded ] = {};
    if( container )
    dstProto[ defaultsName.coded ].__proto__ = container;
  }

  var container = dstProto[ defaultsName.coded ];

  for( var n in srcDefaults )
  {

    if( options.override === false )
    if( n in container )
    continue;

    container[ n ] = srcDefaults[ n ];

  }

}

//

/**
 * Add own defaults to object. Create new defaults container, if there is no such own.
 * @param {object} protoObject - prototype of class which will get new constant property.
 * @param {object} defaultsObject - name/value map of defaults.
 * @param {object} options - options.
 * @param {bool} options.override - to override defaults if exist.
 * @method propertyAddOwnComposes
 * @memberof _.Property#
 */

var propertyAddOwnComposes = function( protoObject,defaultsObject,options )
{

  var name = { Composes : 'Composes' };
  return _propertyAddOwnDefaults( name,protoObject,defaultsObject,options );

}

//

/**
 * Add own aggregates to object. Create new aggregates container, if there is no such own.
 * @param {object} protoObject - prototype of class which will get new constant property.
 * @param {object} aggregatesObject - name/value map of aggregates.
 * @param {object} options - options.
 * @param {bool} options.override - to override defaults if exist.
 * @method propertyAddOwnAggregates
 * @memberof _.wTools#
 */

var propertyAddOwnAggregates = function( protoObject,defaultsObject,options )
{

  var name = { Aggregates : 'Aggregates' };
  return _propertyAddOwnDefaults( name,protoObject,defaultsObject,options );

}

//

/**
 * Add own restricts to object. Create new restricts container, if there is no such own.
 * @param {object} protoObject - prototype of class which will get new constant property.
 * @param {object} restrictsObject - name/value map of restricts.
 * @param {object} options - options.
 * @param {bool} options.override - to override defaults if exist.
 * @method propertyAddOwnRestricts
 * @memberof _.wTools#
 */

var propertyAddOwnRestricts = function( protoObject,defaultsObject,options )
{

  var name = { Restricts : 'Restricts' };
  return _propertyAddOwnDefaults( name,protoObject,defaultsObject,options );

}

// --
// prototype
// --

/**
 * Append prototype to object. Find archi parent and replace its proto.
 * @param {object} dstObject - dst object to append proto.
 * @method protoAppend
 * @memberof wTools#
 */

var protoAppend = function( dstObject )
{

  _assert( _.objectIs( dstObject ) );

  for( var a = 1 ; a < arguments.length ; a++ )
  {
    var proto = arguments[ a ];

    _assert( _.objectIs( proto ) );

    var parent = _.protoArchy( dstObject );
    parent.__proto__ = proto;

  }

  return dstObject;
}

//

/**
 * Does srcProto has insProto as prototype.
 * @param {object} srcProto - proto stack to investigate.
 * @param {object} insProto - proto to look for.
 * @method protoHas
 * @memberof wTools#
 */

var protoHas = function( srcProto,insProto )
{

  do
  {
    if( srcProto === insProto ) return true;
    srcProto = srcProto.__proto__;
  }
  while( srcProto !== Object.prototype );

  return false;
}

//

/**
 * Return proto owning names.
 * @param {object} srcObject - src object to investigate proto stack.
 * @method protoOwning
 * @memberof wTools#
 */

var protoOwning = function( srcObject,names )
{
  var names = _.nameFielded( names );
  _assert( _.objectIs( srcObject ) );

  do
  {
    var has = true;
    for( var n in names )
    if( !_ObjectHasOwnProperty.call( srcObject,n ) )
    {
      has = false;
      break;
    }
    if( has )
    return srcObject;

    srcObject = srcObject.__proto__;
  }
  while( srcObject !== Object.prototype );

  return null;
}

//

/**
 * Returns parent which has default proto.
 * @param {object} srcObject - dst object to append proto.
 * @method protoArchy
 * @memberof wTools#
 */

var protoArchy = function( srcObject )
{

  _assert( _.objectIs( srcObject ) );

  while( srcObject.__proto__ !== Object.prototype )
  srcObject = srcObject.__proto__;

  return srcObject;
}

//

/**
 * Make prototype for constructor repairing relationship: Composes,Aggregates,Restricts.
 * Execute optional extend / supplement if such options present.
 * @param {object} options - options.
 * @param {routine} options.constructor - constructor for which prototype is needed.
 * @param {routine} [options.parent] - constructor of parent class.
 * @param {object} [options.extend] - extend prototype by this map.
 * @param {object} [options.supplement] - supplement prototype by this map.
 * @method protoMake
 * @memberof wTools#
 */

/*
  Self.prototype = Object.create( Parent.prototype );
  _.mapExtend( Self.prototype,Proto );
  _.mapSupplement( Self.prototype,Original.prototype );
*/

/*
_.protoMake
({
  constructor : Self,
  parent : Parent,
  extend : Proto,
  supplement : Original.prototype,
  usingAtomicExtension : true,
  usingGlobalName : true,
  wname : { Bitmask : 'Bitmask' },
});
*/

var ClassFacility =
{
  Composes : 'Composes',
  Aggregates : 'Aggregates',
  Restricts : 'Restricts',
  Constitutes : 'Constitutes',
}

var protoMake = function( options )
{

  var has =
  {
    constructor : 'constructor',
  }

  var hasNot =
  {
    Parent : 'Parent',
    Self : 'Self',
    Type : 'Type',
    type : 'type',
  }

  _assert( arguments.length === 1 );
  _assert( _.objectIs( options ) );

  _assert( _.routineIs( options.constructor ) );
  _assert( options.constructor.name );
  _assert( _ObjectHasOwnProperty.call( options.constructor.prototype,'constructor' ) );
  _.assertMapOwnAll( options.constructor.prototype,has );
  _.assertMapOwnNone( options.constructor.prototype,hasNot );

  _assert( _.routineIs( options.parent ) || options.parent === undefined || options.parent === null );
  _assert( _.objectIs( options.extend ) || options.extend === undefined );
  _assert( _.objectIs( options.supplement ) || options.supplement === undefined );
  _.assertMapOnly( options,protoMake.defaults );
  _.assertMapNoUndefine( options );
  _.mapSupplement( options,protoMake.defaults );

  if( options.overrideOriginal && options.extend )
  _assert( !_ObjectHasOwnProperty.call( options.extend,'constructor' ) );

  var prototype;

  if( options.overrideOriginal )
  prototype = options.constructor.prototype;
  else
  prototype = options.constructor.prototype = Object.create( options.parent ? options.parent.prototype : Object.prototype );

  _.protoExtend
  ({
    constructor : options.constructor,
    extend : options.extend,
    supplement : options.supplement,
    usingAtomicExtension : options.usingAtomicExtension,
    overrideOriginal : options.overrideOriginal,
  });

  // extend fields and methods
/*
  if( options.extend )
  {
    var extend = _.mapBut( options.extend,ClassFacility );
    _.mapExtend( prototype,extend );
  }

  if( options.supplement )
  _.mapSupplement( prototype,options.supplement );

  // extend relationships

  var ParentPrototype = prototype.__proto__;
  if( options.overrideOriginal )
  {

    for( var f in ClassFacility )
    if( options.extend[ f ] )
    _propertyAddOwnDefaults( f,prototype,options.extend[ f ],{ override : true } );

  }
  else
  {

    for( var f in ClassFacility )
    if( prototype.hasOwnProperty( f ) && ParentPrototype[ f ] )
    {
      _assert( prototype[ f ].constructor === ParentPrototype[ f ].constructor || prototype[ f ] === Object );
      prototype[ f ].__proto__ = ParentPrototype[ f ];
    }

  }

  // atomic extension

  if( options.usingAtomicExtension )
  {
    if( _.mapOwn( prototype,{ Composes : 'Composes' } ) )
    _.mapExtendFiltering( _.filter.atomicOwn(),prototype,prototype.Composes );
    if( _.mapOwn( prototype,{ Aggregates : 'Aggregates' } ) )
    _.mapExtendFiltering( _.filter.atomicOwn(),prototype,prototype.Aggregates );
  }
*/

  // name

  if( options.usingGlobalName )
  _global_[ options.constructor.name ] = options.constructor;

  if( options.wname )
  wTools[ _.nameUnfielded( options.wname ).coded ] = options.constructor;

  //

  return prototype;
}

protoMake.defaults =
{
  constructor : null,
  parent : null,
  extend : null,
  supplement : null,
  wname : null,
  usingGlobalName : false,
  usingAtomicExtension : false,
  overrideOriginal : false,
}

//

/**
 * Make prototype for constructor repairing relationship: Composes,Aggregates,Restricts.
 * Execute optional extend / supplement if such options present.
 * @param {object} options - options.
 * @param {routine} options.constructor - constructor for which prototype is needed.
 * @param {routine} [options.parent] - constructor of parent class.
 * @param {object} [options.extend] - extend prototype by this map.
 * @param {object} [options.supplement] - supplement prototype by this map.
 * @method protoExtend
 * @memberof wTools#
 */

var protoExtend = function( options )
{

/*
  var hasNot =
  {
    Parent : 'Parent',
    Self : 'Self',
    Type : 'Type',
    type : 'type',
  }
*/

  _assert( arguments.length === 1 );
  _assert( _.objectIs( options ) );

  _assert( _.routineIs( options.constructor ) );
  _assert( options.constructor.name );
  /*_.assertMapOwnNone( options.constructor.prototype,hasNot );*/

  _assert( _.routineIs( options.parent ) || options.parent === undefined || options.parent === null );
  _assert( _.objectIs( options.extend ) || options.extend === undefined || options.extend === null );
  _assert( _.objectIs( options.supplement ) || options.supplement === undefined || options.supplement === null );
  _.assertMapOnly( options,protoExtend.defaults );
  _.assertMapNoUndefine( options );
  _.mapSupplement( options,protoExtend.defaults );

  if( options.overrideOriginal && options.extend )
  _assert( !_ObjectHasOwnProperty.call( options.extend,'constructor' ) );

  var prototype;

  //if( options.overrideOriginal )
  prototype = options.constructor.prototype;
  //else
  //prototype = options.constructor.prototype = Object.create( options.parent ? options.parent.prototype : Object.prototype );

  // extend fields and methods

  if( options.extend )
  {
    var extend = _.mapBut( options.extend,ClassFacility );
    _.mapExtend( prototype,extend );
    if( _ObjectHasOwnProperty.call( options.extend,'constructor' ) )
    prototype.constructor = options.extend.constructor;
  }

  if( options.supplement )
  _.mapSupplement( prototype,options.supplement );

  // extend relationships

  var ParentPrototype = prototype.__proto__;
  if( options.overrideOriginal || 1 )
  {

    if( options.extend )
    for( var f in ClassFacility )
    if( options.extend[ f ] )
    _propertyAddOwnDefaults( f,prototype,options.extend[ f ],{ override : true } );

    if( options.supplement )
    for( var f in ClassFacility )
    if( options.supplement[ f ] )
    _propertyAddOwnDefaults( f,prototype,options.supplement[ f ],{ override : false } );

  }
  else
  {
/*
    for( var f in ClassFacility )
    if( _ObjectHasOwnProperty.call( prototype,f ) && ParentPrototype[ f ] )
    {
      _assert( prototype[ f ].constructor === ParentPrototype[ f ].constructor || prototype[ f ] === Object );
      prototype[ f ].__proto__ = ParentPrototype[ f ];
    }
*/
  }

  // atomic extension

  if( options.usingAtomicExtension )
  {
    if( _.mapOwn( prototype,{ Composes : 'Composes' } ) )
    _.mapExtendFiltering( _.filter.atomicOwn(),prototype,prototype.Composes );
    if( _.mapOwn( prototype,{ Aggregates : 'Aggregates' } ) )
    _.mapExtendFiltering( _.filter.atomicOwn(),prototype,prototype.Aggregates );
  }

  //

  return prototype;
}

protoExtend.defaults =
{
  constructor : null,
  extend : null,
  supplement : null,
  usingAtomicExtension : false,
  overrideOriginal : false,
}

//

/**
 * Make united interface for several maps. Access to single map cause read and write to original maps.
 * @param {array} protos - maps to united.
 * @return {object} united interface.
 * @method protoMake
 * @memberof wTools#
 */

var protoUnitedInterface = function( protos )
{
  var result = {};
  var unitedArraySymbol = Symbol.for( '_unitedArray_' );
  var unitedMapSymbol = Symbol.for( '_unitedMap_' );
  var protoMap = {};

  _assert( arguments.length === 1 );
  _assert( _.arrayIs( protos ) );

  //

  var get = function( fieldName )
  {
    return function unitedGet()
    {
      return this[ unitedMapSymbol ][ fieldName ][ fieldName ];
    }
  }
  var set = function( fieldName )
  {
    return function unitedSet( value )
    {
      this[ unitedMapSymbol ][ fieldName ][ fieldName ] = value;
    }
  }

  //

  for( var p = 0 ; p < protos.length ; p++ )
  {
    var proto = protos[ p ];
    for( var f in proto )
    {
      if( f in protoMap )
      throw _.err( 'protoUnitedInterface:','several objects try to unite have same field:',f );
      protoMap[ f ] = proto;

      var methods = {}
      methods[ f + 'Get' ] = get( f );
      methods[ f + 'Set' ] = set( f );
      var names = {};
      names[ f ] = f;
      _.accessor
      ({
        object : result,
        names : names,
        methods : methods,
        strict : false,
      });

    }
  }

  /*result[ unitedArraySymbol ] = protos;*/
  result[ unitedMapSymbol ] = protoMap;

  return result;
}

// --
// prototype
// --

var Proto =
{

  // property

  _accessorOptions: _accessorOptions,
  _accessor: _accessor,
  accessor: accessor,
  accessorForbid: accessorForbid,
  accessorForbidOnce: accessorForbidOnce,
  accessorReadOnly: accessorReadOnly,

  constant: constant,
  mixin: mixin,

  _propertyAddOwnDefaults: _propertyAddOwnDefaults,
  propertyAddOwnComposes: propertyAddOwnComposes,
  propertyAddOwnAggregates: propertyAddOwnAggregates,
  propertyAddOwnRestricts: propertyAddOwnRestricts,


  // prototype

  protoAppend: protoAppend,
  protoHas: protoHas,
  protoOwning: protoOwning,
  protoArchy: protoArchy,

  protoMake: protoMake,
  protoExtend: protoExtend,

  protoUnitedInterface: protoUnitedInterface,

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
