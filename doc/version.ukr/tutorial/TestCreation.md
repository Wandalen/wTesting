# Створення модульного тесту

Створення модульного тесту димового тестування та санітарного тестування.


### Розташуванння окремих тест рутин та їх реалізацій

Окремі тест рутини розташовані в директорії `wTools/proto/dwtools/abase`

Вони мають вигляд (на прикладі Тест рутини mapIdentical):

```javascript
var Self =
{

  /* options of the test suit */
  name : 'MapTest',
  silencing : 1,

  /* map of test routines available in the test suit */
  tests :
  {

    mapIdentical : mapIdentical,

  }

}
```

Тест рутина `mapIdentical` має таку реалізацію:

```javascript

function mapIdentical( test )
{

  test.description = 'same values';
  var got = _.mapIdentical( { a : 7, b : 13 }, { a : 7, b : 13 } );
  var expected = true;
  test.identical( got, expected );

  test.description = 'not the same values in'
  var got = _.mapIdentical( { 'a' : 7, 'b' : 13 }, { 'a' : 7, 'b': 14 } );
  var expected = false;
  test.identical( got, expected );

  test.description = 'different number of keys, more in the first argument'
  var got = _.mapIdentical( { 'a' : 7, 'b' : 13, 'с' : 15 }, { 'a' : 7, 'b' : 13 } );
  var expected = false;
  test.identical( got, expected );

  test.description = 'different number of keys, more in the second argument'
  var got = _.mapIdentical( { 'a' : 7, 'b' : 13 }, { 'a' : 7, 'b' : 13, 'с' : 15 } );
  var expected = false;
  test.identical( got, expected );

  /* special cases */

  test.description = 'empty maps, standrard'
  var got = _.mapIdentical( {}, {} );
  var expected = true;
  test.identical( got, expected );

  test.description = 'empty maps, pure'
  var got = _.mapIdentical( Object.create( null ), Object.create( null ) );
  var expected = true;
  test.identical( got, expected );

  test.description = 'empty maps, one standard another pure'
  var got = _.mapIdentical( {}, Object.create( null ) );
  var expected = true;
  test.identical( got, expected );

  /* bad arguments */

  if( !Config.debug )
  return;

  test.description = 'no arguments';
  test.shouldThrowError( function()
  {
    _.mapIdentical();
  });

  test.description = 'not object-like arguments';
  test.shouldThrowError( function()
  {
    _.mapIdentical( [ 'a', 7, 'b', 13 ], [ 'a', 7, 'b', 14 ] );
  });
  test.shouldThrowError( function()
  {
    _.mapIdentical( 'a','b' );
  });
  test.shouldThrowError( function()
  {
    _.mapIdentical( 1,3 );
  });
  test.shouldThrowError( function()
  {
    _.mapIdentical( null,null );
  });
  test.shouldThrowError( function()
  {
    _.mapIdentical( undefined,undefined );
  });

  test.description = 'too few arguments';
  test.shouldThrowError( function()
  {
    _.mapIdentical( {} );
  });

  test.description = 'too much arguments';
  test.shouldThrowError( function()
  {
    _.mapIdentical( {}, {}, 'redundant argument' );
  });

}

```
Тест рутина `mapIdentical` прокиває ( тестує ) рутину із аналогічною назвою `mapIdentical` та такою реалізацією:

```javascript

function mapIdentical( src1,src2 )
{

  _.assert( arguments.length === 2 );

  if( Object.keys( src1 ).length !== Object.keys( src2 ).length )
  return fale;

  for( var s in src1 )
  {
    if( src1[ s ] !== src2[ s ] )
  return false;
  }

  return true;
}

```

<a name="unit-testing-anatomy"/>

## Анатомія модульного теста

Кожний модульний тест має наступну структуру :

1. Налаштування теста

2. Виклик тестуємого метода

3. Твердження

Для прикладу розглянемо слідуючий модульний тест arraySetBut - він розташований в файлі `wTools/proto/dwtools/abase/layer1.test/Array.test.s` :

```javascript
  test.description = 'first argument has single extra element, second argument has single extra element either';
  var a = [ 1, 2, 3, 4, 15 ];
  var b = [ 1, 2, 3, 4, 5 ];
  var got = _.arraySetBut( a, b );
  var expected = [ 15 ];
  test.identical( got, expected );
  test.shouldBe( got !=== a );
  test.shouldBe( got !=== b );
```

В налаштуваннях він має :

1. Короткий опис - `  test.description = 'first argument has single extra element, second argument has single extra element either';`

2. Значення параметрів :
```javascript
  var a = [ 1, 2, 3, 4, 15 ];
  var b = [ 1, 2, 3, 4, 5 ];
```

Виклик тестуємого метода :

```javascript
  var got = _.arraySetBut( a, b );
```

Твердження :

```javascript
  test.identical( got, expected );
```
