# Як писати тест рутину

Основні правила написання тест рутин

Структурно тест сюіт складається з тест рутин. Тест рутини призначені для тестування окремих аспектів тест об'єкта. Від правивильної побудови тест рутини залежатиме зручність підтримки та розширення модуля.

### Загальні рекомендації щодо написання тест рутин

- Для окремої рутини ( чи іншої функціональності ) тест об'єкта створюється принаймні одна тест рутина з назвою аналогічній до рутини тест об'єкту.
- Якщо функціональність складна, можна розділити її між декількома тест рутинами з назвами, що мають спільний початок.
- Тест рутина може містити тест кейси та окремі тест перевірки. Використанню тест кейсів віддається перевага.
- Для кожного тестового випадку створюється власний тест кейс або тест перевірка.
- Якщо використовуються окремі тест перевірки, їх потрібно описати так же як і тест кейс, з допомогою функціоналу утиліти.
- Тест кейси можуть об'єднуватись у тест групи, що формуються за специфічним критерієм. Наприклад, за кількістю вхідних аргументів, за типом вхідних аргументів, за очікуваним результатом, тощо.
- Опис тест групи створюється за критерієм формування групи.
- Для створення тест групи в неї потрібно помістити більше ніж один тест кейс.
- В описі тест кейсів і тест перевірок указується те, чим даний тест кейс чи перевірка відрізняються від інших.
- Іноді, додаткові змінні та колбеки використовуються в більш ніж одному тест кейсі. В такому разі, загальною рекомендацією є дублювання змінних і колбеків для кожного тест кейсу. У випадку, якщо дублювання призведе до невипраданого збільшення тест рутини, можна винести окремі змінні або колбеки на початок або в кінець рутини.

### Візуальне розділення елементів тест рутини

- Тест рутини відділяються одна від одної коментарем `//`.

```js
function test1( test )
{
  // some tests
}

//

function test2( test )
```

- Тест кейси включають опис тест кейсу, змінні для здійснення тестового випадку, тестовий випадок та тест перевірки. Всі елементи йдуть послідовно, кожен з нового рядка, при необхідності, окремі елементи можуть відділятись порожнім рядком. При цьому не має бути конфліктів з іншими частинами форматування рутини.

```js
test.case = 'ins is number`;
var equalizer = ( el, arrEl ) => el === arrEl[ 0 ];
var got = _.arrayRemove( [ 1, 2, 3 ], 3, equalizer );
var expected = [ [ 1, 2 ] ];
test.identical( got, expected );
```

- Тест кейси відділяються один від одного порожнім рядком або рядком з коментарем `/* */`, котрий поміщений між двох порожніх рядків.

```js
test.case = 'ins is number`;
var got = _.arrayRemove( [ 1, 2, 3 ], 3 );
var expected = [ [ 1, 2 ] ];
test.identical( got, expected );

test.case = 'ins is string';
var got = _.arrayRemove( [ 1, 2, 3 ], '3' );
var expected = [ [ 1, 2, 3 ] ];
test.identical( got, expected );

/* */

test.case = 'ins is array';
```

- Тест групи відділяються одна від іншої використанням коментаря `/* - */`, відділеного двома порожніми рядками.

```js
test.close( 'one argument' );

/* - */

test.open( 'two arguments' );
```

- Окремі тест перевірки відділяються як і тест кейси.

### Послідовність заповнення покриття тест об'єкта

Тест рутину є сенс поділити на дві частини для позитивно тестування і для тестування правильності обробки помилкових віхдних даних об'єктом тестування.

- Розробнику на етапі створення тест рутини потрібно вирішити за якою схемою вона буде будуватись - виключно із тест кейсів, чи з використанням тест груп. Одночасно з цим, будь-яка послідовність тест кейсів може утворити тест групу.
- Першою секцією є тестування штатної роботи тест об'єкту.
- В секції не допускається некоректний ввід.
- На один тестовий випадок передбачається принаймні одна тест перевірка.
- Збільшення кількості тест кейсів і тест перевірок може покращити тестове покриття.
- При написанні тест кейсів ефективно використовувати граничні значення вводу.
- В рамках тест рутини або тест групи зміна тестових випадків може мати наступні сценарії: від найпростіших до найсладніших; за зміною кількості або типу аргументів; за кодом рутини тест об'єкта.

- Другою секцією є негативне тестування.
- Якщо рутина тест об'єкта не викидає виключень і помилок, секція може бути відсутньою.
- Перед переходом до виконання коду секції, бажано використати перевірку встановленої системної опції `debug`:

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

- Тестування проводиться з допомогою тест перевірок для негативного тестування.

### Приклади оформлених тест рутин

<details>
  <summary><u>Код тест рутини <code>arrayFromRange</code></u></summary>

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

Код рутини `arrayIs` модуля [`Tools`](https://github.com/Wandalen/wTools). Оригінал тест рутини знаходиться в файлі [`Long.test.s`](https://github.com/Wandalen/wTools/blob/master/proto/dwtools/abase/l1.test/Long.test.s).

Тест рутина `arrayIs` містить лише секцію з тестуванням штатної поведінки рутини `arrayIs` модуля `Tools` оскільки рутина не викидає помилок. При зміні тестових випадків в рутину передавались різні типи аргументів. Тест кейси відділені одним порожнім рядком тому, що сам тест кейс короткий - чотири рядки. В такому разі тест кейси зручно проглядати.

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

Код рутини `arrayFromRange` модуля [`Tools`](https://github.com/Wandalen/wTools). Оригінал тест рутини знаходиться в файлі [`Long.test.s`](https://github.com/Wandalen/wTools/blob/master/proto/dwtools/abase/l1.test/Long.test.s).

Тест рутина `arrayFromRange` включає як позитивне тестування, так і негативне. В тест кейсах обрано зміну аргументу `range` при чому змінюється результат. Відповідно, тест кейси описуються як за результатом, так і за діапазоном вхідних даних. Згідно приведеного коду очевидно, що на один загальний тестовий випадок з указанням діапазону для масиву є по декілька тест кейсів. Для негативного тестування обрано лише по одному тестовому випадку, що призведе до викидування помилки.

[Повернутись до змісту](../README.md#tutorials)
