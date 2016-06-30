(function(){

'use strict';

var Self = function Printer()
{
  Self.prototype.init.apply( this,arguments );
};

var Parent = null;
var _ = wTools;

//

var init = function( options )
{

  var self = _.mapExtend( this,options );
  self.format = _.entityClone( self.format );

}

//

var bindWriter = function( name,routine,context )
{

  //

  var write = function()
  {

    var args = Array.prototype.slice.call( arguments,0 );

    //if( this.format.prefix.current )
    for( var a = 0 ; a < args.length ; a++ )
    {
      var arg = args[ a ];
      if( !_.strIs( arg ) )
      arg = _.toStr( arg );
      args[ a ] = arg.split( '\n' ).join( '\n' + this.format.prefix.current );
    }

    if( args.length === 0 )
    args = [ '' ];

    args[ 0 ] = this.format.prefix.current + args[ 0 ];
    args[ args.length-1 ] += this.format.postfix.current;

/*
    args.unshift( this.format.prefix.current );
    args.push( this.format.postfix.current );
*/
/*
    if( name === 'error' )
    debugger;
*/
    return context[ name ].apply( context,args );
    //return routine.apply( context,args );
  }

  //

  var writeUp = function()
  {

    //console.log( 'up' );

    var result = this[ name ].apply( this,arguments );
    this.up();
    return result;

  }

  //

  var writeDown = function()
  {

    //console.log( 'down' );

    this.down();
    if( arguments.length )
    var result = this[ name ].apply( this,arguments );
    return result;

  }

  this[ name ] = write;
  this[ name + 'Up' ] = writeUp;
  this[ name + 'Down' ] = writeDown;

}

//

var up = function( delta )
{

  if( delta === undefined ) delta = 1;
  for( var d = 0 ; d < delta ; d++ )
  {
    var fix = this.format.prefix;
    if( _.strIs( fix.up ) ) fix.current += fix.up;
    else if( _.arrayIs( fix.up ) ) fix.current = fix.current.substring( fix.up[0],fix.current.length - fix.up[1] );

    var fix = this.format.postfix;
    if( _.strIs( fix.up ) ) fix.current += fix.up;
    else if( _.arrayIs( fix.up ) ) fix.current = fix.current.substring( fix.up[0],fix.current.length - fix.up[1] );

    this.format.level++;
  }

}

//

var down = function( delta )
{

  if( delta === undefined ) delta = 1;
  for( var d = 0 ; d < delta ; d++ )
  {
    this.format.level--;
    var fix = this.format.prefix;
    if( _.strIs( fix.down ) ) fix.current += fix.down;
    else if( _.arrayIs( fix.down ) ) fix.current = fix.current.substring( fix.down[0],fix.current.length - fix.down[1] );
    var fix = this.format.postfix;
    if( _.strIs( fix.down ) ) fix.current += fix.down;
    else if( _.arrayIs( fix.down ) ) fix.current = fix.current.substring( fix.down[0],fix.current.length - fix.down[1] );
  }

}

//

var levelGet = function()
{
  var self = this;
  return self.format.level;
}

//

var levelSet = function( level )
{
  var self = this;
  _.assert( _.numberIs( level ) );
  self.format.level = level;
  self.format.prefix.current = _.strTimes( self.format.prefix.up,level );
  self.format.postfix.current = _.strTimes( self.format.postfix.up,level );
}

// --
// var
// --

var format =
{
  level : 0,
  prefix:
  {
    current: '',
    up: '  ',
    down: [2,0]
  },
  postfix:
  {
    current: '',
    up: '',
    down: ''
  }
}

// --
// prototype
// --

var Proto =
{

  // routine

  init: init,
  bindWriter: bindWriter,

  up: up,
  down: down,

  levelGet: levelGet,
  levelSet: levelSet,


  // var

  format: format,

};

Self.prototype = Proto;

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_.wPrinter = wTools.Printer = Self;

return Self;

})();
