# Техніка розробки тестів

Описано базові навички написання тест рутин та найпоширеніші помилки.

При написанні тест рутини слід орієнтуватись на приведену інформацію. Описані техніки показують як підвищити якість покриття та зберегти зручність роботи з тест рутиною.

Перелік технік і прийомів:

- Вибір назви тест рутини
- Відсутність взаємозалежності між тест кейсами
- Опис умов чи результату тест кейса
- Опис різниці між тест кейсами
- Відсутність взаємозалежності між тест кейсами
- Відстуність збитковості
- Вибір форматування даних
- Відсутність локалізованого зберігання змінних
- Відсутність груп тест кейсів занесених в структуру даних
- Відсутність функціональних адаптерів

### Вибір назви тест рутини

Назва тест юніта і тест рутини мають співпадати. Це дозволяє зрозуміти який тест юніт тестується. Якщо покриття необхідно розділити на декілька тест рутин, їх назви повинні починатись з назви тест юніта і пояснювати суть тест рутини.

Погані назви для покриття тест рутини `strSplitInlined`:

```
strSplitInlined1
strSplitInlined2
```

Хорошими назвами є:

```
strSplitInlinedDefaultOptions,
strSplitInlinedOptionDelimeter,
strSplitInlinedOptionStripping,
```

### Відсутність взаємозалежності між тест кейсами

Для окремих тест кейсів мають використовуватись власні незалежні змінні. Це дозволяє ізолювати окремий тест кейс і тестувати його окремо.

```js
test.case = 'src is positive integer';
var src = 5;
var got = _.numberIs( src );
var expected = true;
test.identical( got, expected );

test.case = 'src is negative integer';
var src = -1 * src;
var got = _.numberIs( src );
test.identical( got, expected );
```

### Опис умов чи результату тест кейса

Опис тест кейсу чи тест перевірки має явно вказувати на те, що перевіряється, чи яким має бути результат перевірки.

Незрозумілий опис.

```js
test.case = 'null, null';
var got = _.arrayAppend( null, null );
var expected = [ null ];
test.identical( got, expected );
```

Опис через умов тест випадку

```js
test.case = 'dst is null, ins is primitive';
```

Опис очікуваного результату тест кейсу

```js
test.case = 'dst is null, primitive appends to new container';
```

### Опис різниці між тест кейсами

Опис окремих тест кейсів має вказувати на відмінність між конкретним тест кейсом від інших.

Приведені нижче описи демонструють відмінність у умовах проведення тесту.

```js
test.case = 'range[ 0 ] - 0, range[ 0 ] < range[ 1 ]';
// code of test case

test.case = 'range[ 0 ] - 0, range[ 0 ] === range[ 1 ]';
// code of test case
```

Відмінність між тест кейсами описана в очікуваному результаті.

```js
test.case = 'expects empty array';
// code of test case

test.case = 'saves 2 elements from start';
// code of test case
```

### Відсутність взаємозалежності між тест кейсами

Кожен тест кейс має тестувани лише один тестовий випадок. Змішування тестування декількох тестових випадків або змішування тестування декількох тест юнітів недопустиме.

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

Приведений тест кейс має змішування двох тест кейсів. Тест кейс має бути розділеним:

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

test.case = 'src is 1000';
var src = 1000;
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

Рутина `arrayRemove` котра видаляє указаний елемент з масиву. Вхідний масив містить 10 елементів, а видаляється один. Зчитування інформації ускладнене. Для подібних тест кейсів достатньо обрати 3-5 елементів.

```js
test.case = 'remove single element';
var dst = [ 1, 2, 3, 4 ];
var got = _.arrayRemove( dst, 3 );
var expected = [ 1, 2, 4 ];
```

### Вибір форматування даних

Деякі тест кейси потребують значного об'єму вхідних або вихідних даних. В такому разі важливо правильно відформатувати код.

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

Дані можуть предтавляються у неявному вигляді, що легко пропустити.

```js
test.case = 'unreadable expected variable';
var got = _.arrayMake( 3 );
var expected = [ ,, ];
test.identical( got, expected );
```

### Відсутність локалізованого зберігання змінних

Розміщення змінних в одному місці ( на початку або в кінці рутини ) небажане. Це погіршує читабельність тест рутини і потребує постійної навігації між тест кейсом та місцем об'явлення змінних.

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

Виключенням із цього антипатерну є створення контексту виконання тест рутини. Контекстом тест рутини можуть бути колбеки, інстанси класів котрі не змінюються або створюють спеціальні умови виконання тест рутини.

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

Для виконання ряду перевірок, дані в яких приводяться до деякого виду, розробник може створити функціональний адаптер з тест перевіркою. Негативною стороною використання функціональних адаптерів в погіршенні виводу сервісної інформації в разі виникнення помилки.

```js
function eq( ins1, ins2 )
{
  test.identical( Math.abs( ins1 - ins2 ) < epsilon );
}
```

[Повернутись до змісту](../README.md#Туторіали)
