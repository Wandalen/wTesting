# Базові техніки

Описано основні особливості тест рутин та найпоширеніші помилки при їх написанні.

### Покроковість

Приклад [перших тест кейсів](./TestRoutineStepByStep.md#Тести-що-перевіряють-штатну-поведінку) рутини `numberIs` показовий тим, що базовими випадками є перевірка звичайних числових значень - цілих чисел та чисел з плаваючою комою, додатніх і від'ємних. Далі йде поступове ускладнення тест рутини іншими значеннями такими як числа у іншій системі числення, спеціальні значення `JavaScript` і числа створені конструктором i т.д.

### Один тест кейс для тестування одного аспекту

```js
test.case = 'array and unroll';
var src1 = _.arrayMake( 3 );
var src2 = _.unrollMake( 3 );
var got = _.argumentsArrayFrom( src1 );
var expected = _.argumentsArrayMake( [ undefined, undefined, undefined ] )
test.identical( got, expected );
var got = _.argumentsArrayFrom( src2 );
test.identical( got, expected );
```

### Опис тест кейсу мають пояснювати, що перевіряється чи яким має бути результат

Поганий опис кейсу

```js
test.case = 'null, null';
var got = _.arrayAppend( null, null );
var expected = [ null ];
test.identical( got, expected );
```

Хороший опис кейсу
```js
test.case = 'dst is null, ins is primitive';
var got = _.arrayAppend( null, null );
var expected = [ null ];
test.identical( got, expected );
```

### Опис тест кейсу має описувати різницю між цим тест кейсом та іншим

Опис відмінностей в початкових даних

```js
test.case = 'range[ 0 ] - 0, range[ 0 ] < range[ 1 ]';
// code of test case

test.case = 'range[ 0 ] - 0, range[ 0 ] === range[ 1 ]';
// code of test case
```

Опис відмінностей в результаті

```js
test.case = 'expects empty array';
// code of test case

test.case = 'saves 2 elements from start';
// code of test case
```

### Опис тест рутини повинен вказувати на те, що вона тестує

Є рутина `longHasAny`, вона може приймати колбеки `evaluator` i `equalizer`.
<!-- Dmytro : пошукати з опціями, буде краще -->

Погані назви для тест рутин
`longHasAny1,
 longHasAny2,`

Хороші назви для тест рутин
`longHasAnyWithoutCallback,
 longHasAnyWithCallback,`

### Окремі змінні для кожного тест кейсу

Неправильний

```js
test.case = 'src is positive integer';
var src = 5;
var got = num.numberIs( src );
var expected = true;
test.identical( got, expected );

test.case = 'src is negative integer';
var src = -1 * src;
var got = num.numberIs( src );
test.identical( got, expected );
```

### Збитковість тест кейсів

```js
test.case = 'src is 5';
var src = 5;
var got = num.numberIs( src );
var expected = true;
test.identical( got, expected );


test.case = 'src is 1000';
var src = 1000;
var got = num.numberIs( src );
var expected = true;
test.identical( got, expected );
```

### Збитковість тест перевірок

```js
test.case = 'dst is null, ins is empty array';
var dst = null;
var ins = [];
var got = _.arrayAppend( dst, ins );
var expected = [ [] ];
test.identical( got, expected );
test.is( got !== dst );
test.is( got !== ins );
test.is( got[ 0 ] === ins );
```

### Рутина має бути читабельною, розміщення змінних на початку або в кінці

Розміщення змінних на початку або в кінці рутини.

```js
var dst1 = null;
var dst2 = [];
var dst3 = [ 1, 2, 3 ];
var dst4 = [ [ 1 ], [ 2 ], [ 3 ] ];
// other variables

/*
  many test cases
*/

test.case = 'dst has complex data types, append identical';
var got = _.arrayAppend( dst4, ins4 );
test.identical( got, expected4 );
```

Виключення. Колбеки значного об'єму

```js
test.case = 'description of test case';
function longCallbac( src )
{
  if( _.numberIs( src ) )
  return 1;
  if( _.strIs( src ) )
  return 2;
  if( _.boolIs( src ) )
  return 3;
}
// code of test case
```

Дублювання такого колбеку не додає функціональності, проте погіршує читабельність.

### Кейс має бути читабельним, зайві елементи

```js
test.case = 'too many elements in container';
var src = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ];
var got = _.arrayAppend( src, 1 );
```

### Кейс має бути читабельним, нечитабельні результати

```js
test.case = 'unreadable expected variable';
var got = _.arrayMake( 3 );
var expected = [ ,, ];
```

### Діагностична інформація має бути інформативна, використання циклів

```js
var src =
[
  null,
  undefined,
  1,
  true,
  false,
  [],
  {}
];

for( let i = 0 ; i < src.length ; i++ )
{
  test.case = `src - ${ typeof src[ i ] }, expected - false`;
  var got = _.strIs( src[ i ] );
  test.identical( got, false );
}
```

### Уникати функціональних адаптерів

```js
test.case = 'src is number';
var got = _.argumentsArrayFrom( [ 1, 2, 3 ] );
var expected = [ 1, 2, 3 ];
test.equivalent( got, expected );
```
