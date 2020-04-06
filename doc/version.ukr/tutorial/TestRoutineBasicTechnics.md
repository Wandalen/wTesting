# Техніка розробки тестів

Описано базові навички написання тест рутин та найпоширеніші помилки.

При написанні тест рутини слід орієнтуватись на приведену інформацію. Описані техніки показують як підвищити якість покриття та зберегти зручність роботи з тест рутиною.

Перелік технік і прийомів:

- Відсутність взаємозалежності між тест кейсами
- Відстуність збитковості
- Вибір форматування даних
- Відсутність груп тест кейсів занесених в структуру даних
- Відсутність функціональних адаптерів

### Відсутність взаємозалежності між тест кейсами

Кожен тест кейс має тестувати лише один тестовий випадок використовуючи власний набір вхідних даних.

#### Відсутність взаємозалежності між змінними

Для тест кейсів мають використовуватись власні незалежні змінні, що дозволяє ізолювати окремий тест кейс і тестувати його окремо.

```js
test.case = 'src is positive integer';
var src = 5;
var got = _.numberIs( src );
var expected = true;
test.identical( got, expected );

test.case = 'src is positive float';
var src = src / 3;
var got = _.numberIs( src );
test.identical( got, expected );
```

#### Відсутність змішування двох тест кейсів

Змішування двох тест кейсів ( двох тест юнітів ) зменшує інформативність окремого тест кейса і ускладнює аналіз покриття тест юніта.

```js
test.case = 'expects empty array';
var dst1 = [];
var dst2 = [ 1, 1, 1 ];
var got = _.arrayRemove( dst1, 1 );
var expected = [];
test.identical( got, expected );
test.is( got === dst1 );
var got = _.arrayRemove( dst2, 1 );
test.identical( got, expected );
test.is( got === dst2 );
```

Приведений тест кейс має бути розділеним:

```js
test.case = 'dst is empty array, expects empty array';
var dst = [];
var got = _.arrayRemove( dst, 1 );
var expected = [];
test.identical( got, expected );
test.is( got === dst );

test.case = 'dst contains only searched element, expects empty array';
var dst = [ 1, 1, 1 ];
var got = _.arrayRemove( dst2, 1 );
var expected = [];
test.identical( got, expected );
test.is( got === dst2 );
```

#### Правильне розміщення змінних тест кейсів

Розміщення змінних, що відносяться до одного з декількох тест кейсів поза межами даного тест кейса, а також розкидування даних тест кейсу по тест рутині небажане - це погіршує читабельність і потребує зайвої навігації по коду для того, щоб скласти повне уявлення про тест кейс.

Приклад розміщення змінних поза межами тест кейсу.

```js
function prefixGet( test )
{
  var path1 = '',
      path2 = 'some.txt',
      // other paths
      expected1 = '',
      expected2 = 'some',
      // other expected values

  /* */

  test.case = 'empty path';
  var got = _.path.prefixGet( path1 );
  test.identical( got, expected1 );

  test.case = 'txt extension';
  var got = _.path.prefixGet( path2 );
  test.identical( got, expected2 );

  // other test cases
```

Контекст виконання тест рутини - колбеки, інстанси класів котрі не змінюються або створюють спеціальні умови виконання тестування, можуть бути розміщені на початку або в кінці тест рутини. Контекст завжди використовується більш ніж одним тест кейсом, його багаторазове об'явлення може ускладнити роботу з тест рутиною.

```js
function srcOnly( filePath, it )
{
  if( filePath === null )
  _.assert( 0 );

  if( it.side === 'dst' )
  return '';
  return filePath;
}
```

### Відстуність збитковості

Збитковість ( надлишковість ) - створення і використання непотрібного коду.

#### Збитковість тест кейсів

Збитковість тест кейсів проявляється у випадках, коли багаторазово тестуються однотипні дані.

```js
test.case = 'src is 5';
var src = 5;
var got = _.numberIs( src );
var expected = true;
test.identical( got, expected );

test.case = 'src is 10';
var src = 10;
var got = _.numberIs( src );
var expected = true;
test.identical( got, expected );
```

#### Збитковість тест перевірок

Збитковість тест перевірок проявляється в використанні додаткових перевірок, що не мають сенсу в представленому контексті.

```js
test.case = 'dst is null, ins is primitive';
var dst = null;
var ins = 'str';
var got = _.arrayAppend( dst, ins );
var expected = [ 'str' ];
test.identical( got, expected );
test.is( got !== dst );
test.is( got !== ins );
test.is( got[ 0 ] === ins );
```

#### Збитковість вхідних даних

Збитковість вхідних даних проявляється в створенні надлишкових змінних, а також в виборі невиправдано великого об'єму даних в структурах даних.

```js
test.case = 'remove single element';
var dst = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ];
var got = _.arrayRemove( dst, 3 );
var expected = [ 1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 12 ];
```

Зчитування інформації ускладнене через значний об'єм даних при цьому інформативність тест кейса не збільшилась. Для подібних тест кейсів достатньо обрати 3-5 елементів.

```js
test.case = 'remove single element';
var dst = [ 1, 2, 3, 4 ];
var got = _.arrayRemove( dst, 3 );
var expected = [ 1, 2, 4 ];
```

### Вибір форматування даних

Однотипне оптимізоване форматування даних тест кейсів підвищує швидкість роботи з тест рутиною.

#### Форматування великого об'єму даних

Тест кейси, котрі потребують значного об'єму вхідних або вихідних даних форматуються так, щоб окремі елементи були легко доступні для перегляду.

Неправильне форматування:

```js
test.case = 'full uri with all components, primitiveOnly';
var uri = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
var expected = { 'protocol' : 'http', 'host' : 'www.site.com', 'port' : 13, 'localWebPath' : '/path/name', 'query' : 'query=here&and=here', 'hash' : 'anchor', 'longPath' : 'www.site.com:13/path/name', 'protocols' : [ 'http' ], 'hostWithPort' : 'www.site.com:13', 'origin' : 'http://www.site.com:13', 'full' : 'http://www.site.com:13/path/name?query=here&and=here#anchor' };
var got = _.uri.parseFull( uri );
test.identical( got, expected );
```

Відформатований кейс:

```js
test.case = 'full uri with all components, primitiveOnly';

var uri = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
var expected =
{
  'protocol' : 'http',
  'host' : 'www.site.com',
  'port' : 13,
  'localWebPath' : '/path/name',
  'query' : 'query=here&and=here',
  'hash' : 'anchor',
  'longPath' : 'www.site.com:13/path/name',
  'protocols' : [ 'http' ],
  'hostWithPort' : 'www.site.com:13',
  'origin' : 'http://www.site.com:13',
  'full' : 'http://www.site.com:13/path/name?query=here&and=here#anchor'
};
var got = _.uri.parseFull( uri );
test.identical( got, expected );
```

#### Відсутність неявного позначення

Дані можуть предтавляються у неявному вигляді, що легко пропустити.

```js
test.case = 'unreadable expected variable';
var got = _.arrayMake( 3 );
var expected = [ ,, ];
test.identical( got, expected );
```

### Відсутність груп тест кейсів занесених в структури даних

Розробник може помістити якісь однотипні тест кейси в структуру даних ( масив, мапу ) і провести тестування скопом. Це погіршує читабельність рутини через необхідність співвіднесення даних структур і кейсу. В разі виникнення помилки, погіршується інформативність сервісної інформації бо може багаторазово повторюватись однаковий вивід.

```js
var src =
[
  null,
  undefined,
  1,
  // ohter elements
];

for( let i = 0 ; i < src.length ; i++ )
{
  test.case = `src - ${ typeof src[ i ] }, expected - false`;
  var got = _.strIs( src[ i ] );
  test.identical( got, false );
}
```

### Відсутність функціональних адаптерів

Негативною стороною використання функціональних адаптерів в погіршенні виводу сервісної інформації при виникненні помилки в декількох тест кейсах.

```js
function eq( ins1, ins2 )
{
  test.identical( Math.abs( ins1 - ins2 ) < epsilon );
}

test.case = 'identical values';
eq( 1, 1 );

test.case = 'equivalent values';
eq( 1, 1.00000001 )
```

[Повернутись до змісту](../README.md#Туторіали)
