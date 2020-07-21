let _ = require( 'wTools' );

function numberIs( src )
{
  _.assert( arguments.length === 1, 'Expects single argument {-src-}' );
  return typeof src === 'number';
}

module.exports.numberIs = numberIs;
console.log( 'numberIs' );
