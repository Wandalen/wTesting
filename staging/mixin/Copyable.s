( function(){

'use strict';

var _ = wTools;

if( typeof module !== 'undefined' )
{
  try
  {
    require( 'wProto' );
  }
  catch( err )
  {
    require( '../component/Proto.s' );
  }
}

//

/**
 * Mixin this into prototype of another object.
 * @param {object} dst - prototype of another object.
 * @method mixin
 * @memberof wCopyable#
 */

var mixin = function( dst )
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

  var forbid =
  {
    Type : 'Type',
    type : 'type',
  }

  _.assertMapOwnAll( dst,has );
  /*_.assertMapOwnNone( dst,hasNot );*/
  _.accessorForbidOnce( dst,forbid );

  _.assert( dst.hasOwnProperty( 'constructor' ),'prototype of object should has own constructor' );

  //

  _.mixin
  ({
    name : 'Copyable',
    dst : dst,
    Proto : Proto,
  });

  //

  var accessor =
  {
    className : 'className',
    classIs : 'classIs',
    nickName : 'nickName',
    Parent : 'Parent',
    Self : 'Self',
  }

  var forbid =
  {
    nickname : 'nickname',
  }

  _.accessorReadOnly
  ({
    object : dst,
    names : accessor,
    preserveValues : 0,
  });

  _.accessorForbid
  ({
    object : dst,
    names : forbid,
    preserveValues : 0,
  });

  if( dst.finit.name === 'finitEventHandler' )
  throw _.err( 'EventHandler mixin should goes after Copyable mixin.' );

}

//

/**
 * Init functor.
 * @param {object} options - options.
 * @method init
 * @memberof wCopyable#
 */

var init = function( Prototype )
{

  var originalInit = Prototype.init;

  return function init( options )
  {
    var self = this;

/*
    _.mapExtendFiltering( _.filter.cloningOwn(),self,Composes );
    _.mapExtendFiltering( _.filter.cloningOwn(),self,Aggregates );

    if( options )
    self.copy( options );
*/

    throw _.err( 'Not implemented' );

    _.assert( _.objectIs( dst ) );

    return originalInit.apply( self,arguments );
  }

}

//
/*
var init = function( options )
{
  var self = this;

  _.mapExtendFiltering( _.filter.cloningOwn(),self,Composes );
  _.mapExtendFiltering( _.filter.cloningOwn(),self,Aggregates );

  if( options )
  self.copy( options );

}

//

var init = function( options )
{
  var self = this;

  _.mapExtendFiltering( _.filter.notAtomicCloningOwn(),self,Composes );
  _.mapExtendFiltering( _.filter.notAtomicCloningOwn(),self,Aggregates );

  if( options )
  self.copy( options );

}
*/

//

  /**
   * Object descturctor.
   * @method finit
   * @memberof wCopyable#
   */

  var finit = function()
  {
    var self = this;
    _.assert( !Object.isFrozen( self ) );
    Object.freeze( self );
  }

//

/**
 * Copy data from another instance.
 * @param {object} src - another isntance.
 * @method copy
 * @memberof wCopyable#
 */

var copy = function( src )
{
  var self = this;

  return self.copyCustom
  ({

    src : src,
    constitutes : true,
    copyAggregates : true,

  });

}

//

/**
 * Copy data from another instance.
 * @param {object} src - another isntance.
 * @method copy
 * @memberof wCopyable#
 */

var copy = function( src )
{
  var self = this;

  return self.copyCustom
  ({

    src : src,
    constitutes : true,
    copyAggregates : true,

  });

}

//

/**
 * Copy data from one instance to another. Customizable static function.
 * @param {object} options - options.
 * @param {object} options.Prototype - prototype of the class.
 * @param {object} options.src - src isntance.
 * @param {object} options.dst - dst isntance.
 * @param {object} options.constitutes - to constitute or not fields, should be off for serializing and on for deserializing.
 * @method copyCustom
 * @memberof wCopyable#
 */

var copyCustom = function( options )
{
  var self = this;
  var options = options || {};

  _.assert( options.constitutes !== undefined );
  _.assert( options.constitutes || options.copyAggregates !== undefined,'expects options.copyAggregates' )
  _.assertMapNoUndefine( options );
  _.assertMapOnly( options,copyCustom.defaults );
  _.mapSupplement( options,copyCustom.defaults );

  // var

  options.Prototype = options.Prototype || self.__proto__;

  var Prototype = options.Prototype;
  var Composes = Prototype.Composes || {};
  var Aggregates = Prototype.Aggregates || {};
  var Restricts = Prototype.Restricts || {};

  var constitutes = options.constitutes;
  var src = options.src;
  var dst = options.dst || self;
  var drop = options.drop || {};

  // verification

  _.assert( arguments.length == 1 );
  _.assert( _.objectIs( options ) );
  _.assert( src );
  _.assert( dst );
  _.assert( _.objectIs( Prototype ) );
  _.assert( drop );
  _.assert( !options.drop || ( options.drop && !constitutes ),'Not implemented' );

  _.assertMapOwnOnly( src, Composes, Aggregates, Restricts );

  //

  var copyFacets = function( screen,cloning )
  {

    var filter;

    if( constitutes )
    {
      filter = _.routineJoin( undefined,_copyFieldConstituting,[ Prototype.Constitutes || {}, cloning ] );
      filter.functionKind = 'field-mapper';
    }
    else if( !cloning )
    {
      filter = _.filter.bypass();
    }
    else
    {
      filter = _.routineJoin( undefined,_copyFieldNotConstituting,[ Prototype.Constitutes || {} ] );
      filter.functionKind = 'field-mapper';
    }


    if( options.drop )
    filter = _.filter.and( _.filter.drop( drop ),filter );

    _._mapScreen
    ({
      filter : filter,
      screenObjects : screen,
      dstObject : dst,
      srcObjects : src,
    });

  }

  // copy constitutes
/*
  if( options.copyConstitutes && Object.keys( Prototype.Constitutes ).length )
  {
    debugger;
    copyFacets( Prototype.Constitutes,false );
  }
*/
  // copy composes

  if( options.copyComposes || options.copyConstitutes )
  {

    if( options.copyComposes && options.copyConstitutes )
    copyFacets( _.mapExtend( {},Prototype.Constitutes,Prototype.Composes ),true );
    else if( options.copyComposes )
    copyFacets( Prototype.Composes,true );
    else if( options.copyConstitutes )
    copyFacets( Prototype.copyConstitutes,true );

  }

  // copy aggregates

  if( options.copyAggregates )
  {

    copyFacets( Prototype.Aggregates,false );

/*
    var filter = _.filter.bypass();
    if( options.drop )
    {
      debugger;
      filter = _.filter.drop( drop );
    }

    _._mapScreen
    ({
      filter : _.filter.drop( drop ),
      screenObjects : Prototype.Aggregates,
      dstObject : dst,
      srcObjects : src,
    });
*/

  }

  // copy restricts

  if( options.copyRestricts )
  {
    copyFacets( Prototype.Aggregates,false );
    throw _.err( 'not tested' );
  }

  // constitutes

  if( constitutes && Prototype.Constitutes )
  for( var c in Prototype.Constitutes )
  {

    var constitution = Prototype.Constitutes[ c ];
    self.constituteField( dst,c );

  }

  return dst;
}

copyCustom.defaults =
{
  src : null,
  dst : null,
  drop : null,
  Prototype : null,
  copyComposes : true,
  copyAggregates : true,
  copyRestricts : false,
  copyConstitutes : false,
  constitutes : true,
}

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method cloneData
 * @memberof wCopyable#
 */

var cloneData = function( options )
{
  var self = this;
  var options = options || {};

  _.assert( arguments.length === 0 || arguments.length === 1 );

  var def =
  {
    src : self,
    dst : {},
    constitutes : false,
    copyComposes : true,
    copyAggregates : false,
    copyConstitutes : true,
  }

  _.mapSupplement( options,def );

  return self.copyCustom( options );
}

//

/**
 * Clone instance.
 * @method clone
 * @param {object} [self] - optional destination
 * @memberof wCopyable#
 */

var clone = function( dst )
{
  var self = this;

  _.assert( arguments.length <= 1 );

  if( !dst )
  {
    dst = new self.constructor( self );
    if( dst === self )
    {
      dst = new self.constructor();
      dst.copy( self );
    }
  }
  else
  {
    dst.copy( self );
  }

  return dst;
}

//

var _copyFieldConstituting = function _copyFieldConstituting( Constitutes,cloning,dstContainer,srcContainer,key )
{

  if( Constitutes[ key ] && !dstContainer[ key ] && _.mapIs( srcContainer[ key ] ) )
  {
    dstContainer[ key ] = Constitutes[ key ]( srcContainer[ key ],dstContainer );
  }
  else
  {
    if( cloning )
    _.entityCopyField( dstContainer,srcContainer,key );
    else dstContainer[ key ] = srcContainer[ key ];
  }

}

//

var _copyFieldNotConstituting = function _copyFieldNotConstituting( Constitutes,dstContainer,srcContainer,key )
{
  var src = srcContainer[ key ];

/*
  if( !cloning )
  {
    dstContainer[ key ] = srcContainer[ key ]
    return;
  }
*/

/*
  if( dropContainer[ key ] !== undefined )
  return;
*/

  if( _.atomicIs( src ) )
  {

    dstContainer[ key ] = src;

  }
  else if( src.copyCustom )
  dstContainer[ key ] = src.copyCustom
  ({
    dst : {},
    src : src,

    constitutes : false,
    copyComposes : true,
    copyAggregates : false,
    copyConstitutes : true,

  })
  else
  {
    _.entityCopyField( dstContainer,srcContainer,key );

/*
    var dst = src.constructor();
    _.each( src,function( e,k )
    {

      _copyFieldNotConstituting( {},dst,src,k );

    });
    dstContainer[ key ] = dst;
*/

  }

}

//

/**
 * Make sure src does not have redundant fields.
 * @param {object} src - source object of the class.
 * @method doesNotHaveRedundantFields
 * @memberof wCopyable#
 */

var doesNotHaveRedundantFields = function( src )
{
  var self = this;

  var Composes = self.Composes || {};
  var Aggregates = self.Aggregates || {};
  var Restricts = self.Restricts || {};
  _.assertMapOwnOnly( src, Composes, Aggregates, Restricts );

  return dst;
}

//

/**
 * Constitutes field.
 * @param {object} fieldName - src isntance.
 * @method constituteField
 * @memberof wCopyable#
 */

var constituteField = function( dst,fieldName )
{
  var self = this;
  var Prototype = self.__proto__ || options.prototype;
  var constitution = Prototype.Constitutes[ fieldName ];

  if( !constitution )
  return;

  if( dst[ fieldName ] === undefined || dst[ fieldName ] === null )
  return;

  //

  var constituteIt = function( constitution,src,dstContainer,key )
  {

    if( src.Composes )
    return;

    _.assert( constitution.length === 2 );
    var n = constitution( src,self );
    if( n !== undefined )
    dstContainer[ key ] = n;
    else throw _.err( 'not tested' );

  }

  //

  if( _.objectIs( constitution ) )
  {

    for( var a in dst[ fieldName ] )
    constituteIt( constitution[ 0 ],dst[ fieldName ][ a ],dst[ fieldName ],a );

  }
  else if( _.arrayIs( constitution ) )
  {
    throw _.err( 'Not tested' );

    for( var a = 0 ; a < dst[ fieldName ].length ; a++ )
    constituteIt( constitution[ 0 ],dst[ fieldName ][ a ],dst[ fieldName ],a );

  }
  else
  {

    constituteIt( constitution,dst[ fieldName ],dst,fieldName );

  }

}

//

/**
 * Iterate through classes.
 * @param {object} classObject - class object
 * @method classEachParent
 * @memberof wCopyable#
 */

var classEachParent = function( classObject,onEach )
{

  _.assert( arguments.length === 2 );

  do
  {

    onEach.call( this,classObject );

    classObject = classObject.Parent ? classObject.Parent.prototype : null;

    if( classObject.constructor === Object )
    classObject = null;

  }
  while( classObject );

}

//

/**
 * Is this instance finited.
 * @method isFinited
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

var isFinited = function()
{
  var self = this;

  return Object.isFrozen( self );
}

//

/**
 * Is this instance identical with another one. Use composes and aggregates to compare.
 * @method isIdentical
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

var isIdentical = function( ins )
{
  var self = this;

  _.assert( arguments.length <= 1 );

  if( !ins )
  return false;

  if( ins.Composes !== self.Composes )
  return false;

  for( var c in self.Composes )
  {
    if( !_.entitySame( self[ c ],ins[ c ] ) )
    return false;
  }

  for( var c in self.Aggregates )
  {
    if( self[ c ] !== ins[ c ] )
    return false;
  }

  return true;
}

//

/**
 * Nickname of the object.
 * @method _nickNameGet
 * @memberof wCopyable#
 */

var _nickNameGet = function()
{
  var self = this;
  return self.className + '( ' + ( self.key || self.name || self.id || 0 ) + ' )';
}

//

/**
 * Return own constructor.
 * @method _SelfGet
 * @memberof wCopyable#
 */

var _SelfGet = function _SelfGet()
{
  _.assert( !this.__proto__ || this.__proto__.hasOwnProperty( 'constructor' ) );
  return this.constructor;
}

//

/**
 * Return parent's constructor.
 * @method _ParentGet
 * @memberof wCopyable#
 */

var _ParentGet = function _ParentGet()
{
  _.assert( !this.__proto__ || this.__proto__.hasOwnProperty( 'constructor' ) );
  return this.constructor.prototype.__proto__.constructor;
}

//

/**
 * Return name of class constructor.
 * @method _classNameGet
 * @memberof wCopyable#
 */

var _classNameGet = function _classNameGet()
{
  _.assert( this.constructor === null || this.constructor.name || this.constructor._name );
  return this.constructor ? this.constructor.name || this.constructor._name : '';
}

//

/**
 * Is this class prototype or instance.
 * @method _classIsGet
 * @memberof wCopyable#
 */

var _classIsGet = function _classIsGet()
{
  throw _.err( 'Not tested' );
  return this.hasOwnProperty( 'constructor' );
}

// --
// relationships
// --

var Composes =
{
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

  finit: finit,
  copyCustom: copyCustom,
  copy: copy,

  cloneData: cloneData,
  clone: clone,

  _copyFieldConstituting: _copyFieldConstituting,
  _copyFieldNotConstituting: _copyFieldNotConstituting,

  doesNotHaveRedundantFields: doesNotHaveRedundantFields,
  constituteField: constituteField,
  classEachParent: classEachParent,

  isFinited: isFinited,
  isIdentical: isIdentical,

  '_SelfGet': _SelfGet,
  '_ParentGet': _ParentGet,
  '_classNameGet': _classNameGet,
  '_classIsGet': _classIsGet,
  '_nickNameGet': _nickNameGet,

  Composes: Composes,
  Aggregates: Aggregates,
  Restricts: Restricts,

}

var Self =
{

  mixin: mixin,

}

_.mapExtend( Self,Proto );

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_.wCopyable = wTools.Copyable = Self;

return Self;

})();
