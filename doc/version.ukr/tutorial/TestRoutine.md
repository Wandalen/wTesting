# Як писати тест рутину

Основні правила написання тест рутин.

Тест рутини призначені для тестування окремих аспектів тест юніта, або, навіть, повного тестування тест юніта. Від правивильної побудови тест рутини залежатиме зручність підтримки та розширення тестів.

### Алгоритм розробки теста

- Перед початком написання тест кейсів необхідно визначити призначення тест юніта і загальні закономірності функціонування.
- Визначити обмеження з якими працюватиме тест юніт.
- Написати юніт тести, котрі охоплюють базовий функціонал.
- Написати код, що забезпечує базовий функціонал.
- Розширювати код тест юніта і код тест рутини до забезпечення повної відповідності коду поставленими вимогам.
- У випадку необхідності згрупувати тест кейси в тест групи.
- За необхідності розширення поведінки тест юніта або знаходження багу, необхідно розширити тест рутину та внести зміни в код.

### Формальні вимоги

- Для обраної рутини ( чи іншої функціональності ) тест юніта створюється окрема тест рутина.
- Якщо функціональність складна, можна розділити її між декількома тест рутинами.
- Тест рутина складається з окремих тест перевірок, тест кейсів та тест груп.
- Для кожного тестового випадку створюється власний тест кейс або тест перевірка.
- Тест кейс має бути максимально простим. При цьому тест кейс чи тест перевірка повинні тестувати всі необхідні результати після виконання тестового випадку.
- Тест група повинна містити більше ніж один тест кейс або тест перевірку.
- Тест кейси і тест групи повинні бути незалежними - якщо закоментувати один з них, інші тест кейси і тест рутина повинні продовжити свою роботу без змін.

### Структура

Тест рутину є сенс поділити на дві частини - для позитивного тестування і для тестування правильності обробки помилкових вхідних даних об'єктом тестування.

- Частина з позитивним тестуванням є обов'язковою та розташовується першою в тест рутині.
- При позитивному тестуванні не допускається передача об'єкту тестування помилкових вхідних даних.
- На один тестовий випадок передбачається принаймні одна тест перевірка.
- Збільшення кількості тест кейсів і тест перевірок може покращити тестове покриття.
- При написанні тест кейсів ефективно використовувати граничні значення вводу.
- В рамках тест рутини або тест групи зміна тестових випадків може мати наступні сценарії: від найпростіших до найсладніших; за зміною кількості або типу аргументів; за кодом рутини тест юніта.
- Тест кейси і тест перевірки можуть об'єднуватись у тест групи, що формуються за специфічним критерієм. Наприклад, за кількістю вхідних аргументів, за типом вхідних аргументів, за очікуваним результатом, тощо.
- Якщо рутина тест юніта не викидає виключень і помилок, частина коду для тестування помилкових вхідних даних може бути відсутньою.
- Перед переходом до виконання коду з помилковими вхідними даними, бажано встановити перевірку встановлення опції `debug`:

```js
if( Config.debug )
{
  // some tests
}
```
або

```js
if( !Config.debug )
return;

// some tests
```

- Тестування поведінки тест юніта при вводі помилкових вхідних даних проводиться з допомогою спеціальних тест перевірок.

### Оформлення

- Для зручності назва тест рутини обирається аналогічно до назви рутини тест юніта. Якщо декілька тест рутин тестують один аспект тест об'єкта у них має бути спільний початок назви.
- Використанню тест кейсів і тест груп віддається перевага над окремими тест перевірками.
- Тест кейси включають опис тест кейсу, змінні для здійснення тестового випадку, тестовий випадок та тест перевірки. Всі елементи йдуть послідовно, кожен з нового рядка, при необхідності, окремі елементи можуть відділятись порожнім рядком. При цьому не має бути конфліктів з іншими частинами форматування рутини.

```js
test.case = 'ins is number';
var equalizer = ( el, arrEl ) => el === arrEl[ 0 ];
var got = _.arrayRemove( [ 1, 2, 3 ], 3, equalizer );
var expected = [ 1, 2, 3 ];
test.identical( got, expected );
```

- Якщо використовуються окремі тест перевірки, їх потрібно описати так же як і тест кейс, з допомогою функціоналу утиліти.

```js
test.description = 'one character';
test.identical( _.strCount( 'abc', 'a' ), 1 );
```
- Всі описи тест перевірок, тест кейсів і тест груп повинні бути максимально короткими і передавати суть тесту.
- В описі тест кейсів і тест перевірок указується те, чим даний тест кейс чи перевірка відрізняються від інших.
- Опис тест групи створюється за критерієм формування групи.

Розділення елементів тест рутин

- Тест рутини відділяються одна від одної використанням коментаря `//`, поміщеного між двома порожніми рядками.

```js
function test1( test )
{
  // some tests
}

//

function test2( test )
```

- Тест кейси відділяються один від одного порожнім рядком або рядком з коментарем `/* */`, котрий поміщений між двох порожніх рядків.

```js
test.case = 'ins is number';
var got = _.arrayRemove( [ 1, 2, 3 ], 3 );
var expected = [ 1, 2 ];
test.identical( got, expected );

test.case = 'ins is string';
var got = _.arrayRemove( [ 1, 2, 3 ], '3' );
var expected = [ 1, 2, 3 ];
test.identical( got, expected );

/* */

test.case = 'ins is array';
```

- Окремі тест перевірки відділяються як і тест кейси.
- Тест групи відділяються одна від іншої використанням коментаря `/* - */`, відділеного двома порожніми рядками.

```js
test.close( 'one argument' );

/* - */

test.open( 'two arguments' );
```

### Неформальні рекомендації

- Форматування окремих елементів тест рутини має бути однаковим.
- Порядок об'явлення і використання змінних має бути однаковим.
- Після здійснення тестового випадку бажано перевіряти як результат, так і джерело вхідних даних.
- У випадку використання складних операцій з множиною елементів бажано розбивати тест кейс на послідовніть простих операцій з двома елементами. Наприклад, послідовність тестів

```js
var result1 = _.arraySlice( [ 1, 2, 3, 4 ], 1, 4 );
var result2 = _.arrayRemove( result1, 0, 2 );
var result3 = _.arrayRemove( result2, 0, 1 );
test.identical( result1, [ 2, 3, 4 ] );
test.identical( result2, [ 2, 3 ] );
test.identical( result3, [ 2 ] );
```

може бути перетворена в окремі тести

```js
var result = _.arraySlice( [ 1, 2, 3, 4 ], 1, 4 );
test.identical( result, [ 2, 3, 4 ] );

var result = _.arrayRemove( [ 2, 3, 4 ], 0, 2 );
test.identical( result, [ 2, 3 ] );

var result = _.arrayRemove( [ 2, 3 ], 0, 1 );
test.identical( result, [ 2 ] );
```

- Іноді, додаткові змінні та колбеки використовуються в більш ніж одному тест кейсі. В такому разі, загальною рекомендацією є дублювання змінних і колбеків для кожного тест кейсу. У випадку, якщо дублювання призведе до невипраданого збільшення тест рутини, можна винести окремі змінні або колбеки на початок або в кінець рутини.

### Приклади тест рутин без тест груп

<details>
  <summary><u>Код тест рутини <code>arrayIs</code></u></summary>

```js
function arrayIs( test )
{

  test.case = 'an empty array';
  var got = _.arrayIs( [] );
  var expected = true;
  test.identical( got, expected );

  test.case = 'an array';
  var got = _.arrayIs( [ 1, 2, 3 ] );
  var expected  = true;
  test.identical( got, expected );

  test.case = 'object';
  var got = _.arrayIs( {} );
  var expected  = false;
  test.identical( got, expected );

  test.case = 'number';
  var got = _.arrayIs( 6 );
  var expected  = false;
  test.identical( got, expected );

  test.case = 'string';
  var got = _.arrayIs( 'abc' );
  var expected  = false;
  test.identical( got, expected );

  test.case = 'boolean';
  var got = _.arrayIs( true );
  var expected  = false;
  test.identical( got, expected );

  test.case = 'function';
  var got = _.arrayIs( function(){  } );
  var expected  = false;
  test.identical( got, expected );

  test.case = 'a pseudo array';
  var got = ( function()
  {
    return _.arrayIs( arguments );
  } )('Hello there!');
  var expected = false;
  test.identical( got, expected );

  test.case = 'no argument';
  var got = _.arrayIs();
  var expected  = false;
  test.identical( got, expected );

  test.case = 'null';
  var got = _.arrayIs( null );
  var expected  = false;
  test.identical( got, expected );

  /* - */

  if( !Config.debug )
  return;

}
```

</details>

Код тест рутини `arrayIs` модуля [`Tools`](https://github.com/Wandalen/wTools). Оригінал тест рутини знаходиться в файлі [`Long.test.s`](https://github.com/Wandalen/wTools/blob/master/proto/wtools/abase/l1.test/Long.test.s).

Тест рутина `arrayIs` містить лише секцію з тестуванням штатної поведінки рутини `arrayIs` оскільки рутина не викидає помилок. При зміні тестових випадків в рутину передавались різні типи аргументів, що відображено в описі тест кейсів. Тест кейси відділені одним порожнім рядком тому, що сам тест кейс короткий - чотири рядки. В такому разі тест кейси зручно проглядати.

<details>
  <summary><u>Код тест рутини <code>arrayFromRange</code></u></summary>

```js
function arrayFromRange( test )
{

  test.case = 'single zero';
  var got = _.arrayFromRange( [ 0, 1 ] );
  var expected = [ 0 ];
  test.identical( got, expected );

  test.case = 'nothing';
  var got = _.arrayFromRange( [ 1, 1 ] );
  var expected = [];
  test.identical( got, expected );

  test.case = 'single not zero';
  var got = _.arrayFromRange( [ 1, 2 ] );
  var expected = [ 1 ];
  test.identical( got, expected );

  test.case = 'couple of elements';
  var got = _.arrayFromRange( [ 1, 3 ] );
  var expected = [ 1, 2 ];
  test.identical( got, expected );

  test.case = 'single number as argument';
  var got = _.arrayFromRange( 3 );
  var expected = [ 0, 1, 2 ];
  test.identical( got, expected );

  test.case = 'complex case';
  var got = _.arrayFromRange( [ 3, 9 ] );
  var expected = [ 3, 4, 5, 6, 7, 8 ];
  test.identical( got, expected );

  /**/

  if( !Config.debug )
  return;

  test.case = 'extra argument';
  test.shouldThrowErrorSync( function()
  {
    _.arrayFromRange( [ 1, 3 ], 'wrong arguments' );
  });

  test.case = 'argument not wrapped into array';
  test.shouldThrowErrorSync( function()
  {
    _.arrayFromRange( 1, 3 );
  });

  test.case = 'wrong type of argument';
  test.shouldThrowErrorSync( function()
  {
    _.arrayFromRange( 'wrong arguments' );
  });

  test.case = 'no arguments'
  test.shouldThrowErrorSync( function()
  {
    _.arrayFromRange();
  });

};

```

</details>

Код тест рутини `arrayFromRange` модуля [`Tools`](https://github.com/Wandalen/wTools). Оригінал тест рутини знаходиться в файлі [`Long.test.s`](https://github.com/Wandalen/wTools/blob/master/proto/wtools/abase/l1.test/Long.test.s).

Тест рутина `arrayFromRange` включає як позитивне тестування, так і тестування при передачі помилкових вхідних даних. В тест кейсах змінюються дані в аргументі `range`, що по-різному відображається в результаті. Відповідно, опис до тест кейсів містить позначення як результату, так і на діапазону вхідних даних. Згідно приведеного коду очевидно, що на один загальний тестовий випадок - указанням діапазону для масиву - є по декілька тест кейсів. Для тестування при вводі помилкових даних обрано лише по одному тестовому випадку.

### Приклад тест рутини з тест групами

<details>
  <summary><u>Код тест рутини <code>strCount</code></u></summary>

```js
function strCount( test )
{

  test.open( 'string' );

  test.case = 'none';
  var got = _.strCount( 'abc', 'z' );
  var expected = 0;
  test.identical( got, expected );

  test.case = 'nl';
  var got = _.strCount( 'abc\ndef\nghi', '\n' );
  var expected = 2;
  test.identical( got, expected );

  test.case = 'simple string';
  var got = _.strCount( 'ababacabacabaaba','aba' );
  var expected = 4;
  test.identical( got, expected );

  test.case = 'empty src';
  var got = _.strCount( '', 'abc' );
  var expected = 0;
  test.identical( got, expected );

  test.case = 'empty ins';
  var got = _.strCount( 'abc', '' );
  var expected = 3;
  test.identical( got, expected );

  test.close( 'string' );

  /* - */

  test.open( 'regexp' );

  test.case = 'none';
  var got = _.strCount( 'abc', /z/ );
  var expected = 0;
  test.identical( got, expected );

  test.case = 'nl';
  var got = _.strCount( 'abc\ndef\nghi', /\n/m );
  var expected = 2;
  test.identical( got, expected );

  test.case = 'simple string';
  var got = _.strCount( 'ababacabacabaaba', /aba/ );
  var expected = 4;
  test.identical( got, expected );

  test.case = 'empty src';
  var got = _.strCount( '', /a/ );
  var expected = 0;
  test.identical( got, expected );

  test.case = 'empty ins';
  var got = _.strCount( 'abc', RegExp( '' ) );
  var expected = 3;
  test.identical( got, expected );

  test.close( 'regexp' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'no arguments';
  test.shouldThrowErrorOfAnyKind( function( )
  {
    _.strCount( );
  } );

  test.case = 'first argument is wrong';
  test.shouldThrowErrorOfAnyKind( function( )
  {
    _.strCount( [  ], '\n' );
  } );

  test.case = 'second argument is wrong';
  test.shouldThrowErrorOfAnyKind( function( )
  {
    _.strCount( 'abc\ndef\nghi', 13 );
  } );

  test.case = 'not enough arguments';
  test.shouldThrowErrorOfAnyKind( function( )
  {
    _.strCount( 'abc\ndef\nghi' );
  } );

  test.case = 'invalid arguments count';
  test.shouldThrowErrorOfAnyKind( function()
  {
    _.strCount( '1', '2', '3' );
  });

  test.case = 'invalid first argument type';
  test.shouldThrowErrorOfAnyKind( function()
  {
    _.strCount( 123, '1' );
  });

  test.case = 'invalid second arg type';
  test.shouldThrowErrorOfAnyKind( function()
  {
    _.strCount( 'one two', 123 );
  });

  test.case = 'no arguments';
  test.shouldThrowErrorOfAnyKind( function()
  {
    _.strCount();
  });

}

```

</details>

Код тест рутини `strCount` модуля [`Tools`](https://github.com/Wandalen/wTools). Оригінал тест рутини знаходиться в файлі [`StringTools.test.s`](https://github.com/Wandalen/wTools/blob/master/proto/wtools/abase/l2.test/StringTools.test.s).

Тест групи в указаній тест рутині формуються за типом аргументу для пошуку в рядку. Перша група - `string` - використовує аргумент типу `String`, а `regexp`, відповідно, `RegExp`.

### Підсумок

- Для окремої рутини ( функціональності ) тест юніта створюється принаймні одна тест рутина.
- Написання тест рутини і основного коду - паралельний процес.
- Для якісного тестового покриття необхідно знати призначення і закономірності функціонування тест юніта.
- Тест рутина складається з тест перевірок, тест кейсів і тест груп.
- Тест кейси і тест перевірки можна об'єднати в тест групи.
- Тест рутина умовно ділиться на дві частини - тестування штатної поведінки тест юніта і тестування при вводі помилкових тестових даних.
- Тестування штатної поведінки обов'язкове, а при вводі помилкових вхідних даних - опціональне.

[Повернутись до змісту](../README.md#tutorials)
