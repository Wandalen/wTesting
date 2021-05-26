# Наслідування тест сюіта

<!-- aaa for Dmytro : review and keep it short and stupid --> <!-- Dmytro : reviewed, removed redundant text, updated descriptons -->

Наслідування одного тест сюіта іншим.

Концепція наслідування використовується при побудові тест сюітів - будь-який тест сюіт може наслідувати один або декілька інших абстрактних тест сюітів.

При наслідуванні, тест рутини абстрактного ( батьківського ) сюіта зберігаються - ці тест рутини можуть бути переписані одним із нащадків.

### Об'єкт тестування

Для зручності всі файли туторіала розміщені в одній директорії.

Файл з об'єктами тестування має наступний код:

<details>
    <summary><u>Код файла <code>Math.js</code></u></summary>

```js
module.exports.sum = function( a, b )
{
  return Number( a ) + Number( b );
};

//

module.exports.mul = function( a, b )
{
  return Number( a ) * Number( b );
};
```

</details>

Функція `sum` виконує додавання двох числових значень, функція `mul` повертає добуток двох числових значень. Рутини експортуються для використання.

### Тестові файли

Модуль матиме два тестових файла - `Positive.test.js` i `Negative.test.js`. Перший - батьківський тест сюіт, а другий - нащадок.

<details>
    <summary><u>Код файла <code>Positive.test.js</code></u></summary>

```js
let Math = require( './Math.js' );

//

function sum( test )
{
  test.case = 'integer';
  test.equivalent( Math.sum( 1, 1 ), 2 );

  test.case = 'float';
  test.equivalent( Math.sum( 1.01, 2.21 ), 3.22 );

  test.case = 'negative';
  test.equivalent( Math.sum( -1, -2 ), -3 );
}

//

function mul( test )
{
  test.case = 'integer';
  test.equivalent( Math.mul( 1, 1 ), 1 );

  test.case = 'float';
  test.equivalent( Math.mul( 2.5, 2.5 ), 6.25 );

  test.case = 'negative';
  test.equivalent( Math.mul( -1, -2 ), 2 );
}

//

function shouldBeFailed( test )
{
  test.equivalent( Math.mul( -1, -2 ), 3 );
}

//

var Self =
{
  name : 'Positive',
  abstract : 1,
  tests :
  {
    sum,
    mul,
    shouldBeFailed,
  }
}

//

Self = wTestSuite( Self );
```

</details>

Тест файл `Positive.test.js` в секції об'явлення тест сюіта має поле `abstract : 1`. Це спеціальне поле, указанння якого робить тест сюіт абстрактним - доступним для наслідування та недоступним для виконання. При значенні `abstract : 1` утиліта не зможе виконати тестування в файлі `Positive.test.js` командою `tst .run ./Positive.test.js`.

В секції запуску тест сюіта присутній рядок з формуванням тест сюіта

```
Self = wTestSuite( Self );
```
[Рядки запуску](HelloWorld.md#Cекція-запуску-тест-сюіта) відсутні.

В секції підключення залежностей присутній рядок з указанням файла з об'єктом тестування. Підключення тестера не потрібне.

Тест сюіт `Positive` має три тест рутини, які проводять тестування функцій файла `Math.js` при вводі чисел. Тест рутини `sum` i `mul` мають пройти. Тест рутина `shouldBeFailed` в разі запуску має провалитись так, як `Math.mul( -1, -2 )` повертає значення 2, що не еквівалентно значенню 3.

<details>
    <summary><u>Код файла <code>Negative.test.js</code></u></summary>

```js
let _ = require( 'wTesting' );
let Math = require( './Math.js' );
require( './Positive.test.js' );

//

function sumThrowError( test )
{
  test.shouldThrowErrorOfAnyKind( () => Math.sum( a, 1 ) );
}

//

function mulThrowError( test )
{
  test.shouldThrowErrorOfAnyKind( () => Math.mul( a, 1 ) );
}

//

function shouldBeFailed( test )
{
  test.notEquivalent( Math.mul( -1, -2 ), 3 );
}

//

var Self =
{
  name : 'Negative',
  abstract : 0,
  tests :
  {
    sumThrowError,
    mulThrowError,
    shouldBeFailed,
  }
}

//

Self = wTestSuite( Self ).inherit( wTests[ 'Positive' ] );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
```

</details>

Для наслідування від батьківського тест сюіту, в секції визначення указується опція `abstract` зі значенням `0`. Таким чином дочірній тест сюіт наслідує від абстрактного батьківського тест сюітa.

В секції запуску здійснюється об'явлення наслідування:

```js
Self = wTestSuite( Self ).inherit( wTests[ 'Positive' ] );
```

Складові:

- `Self` - змінна, що позначає тест сюіт.
- `wTestSuite( Self )` - об'являє, що тестер має формувати тест сюіт з мапи `Self` указаної вище.
- `inherit( ... )` - рутина, що здійснює механізм наслідування. В параметр передається батьківський тест сюіт.
- `wTests[ 'Positive' ]` - об'явлення абстрактного тест сюітa для наслідування за іменем тест сюіта.

Щоб дочірній тест сюіт міг знайти батьківський тест сюіт, в секції підключення залежностей указано файл

```js
require( './Positive.test.js' );
```

Таким чином, абстрактний тест сюіт може наслідуватись іншими, якщо виконуються три умови:

- в секції об'явлення тест сюіта встановлено опцію `abstract : 0`;
- в секції запуску тест сюіту об'явлено наслідування через `inherit()`;
- в секції підключення залежностей указано батьківський тест сюіт.

Тест сюіт `Negative` складається з трьох тест рутин - `sumThrowError`, `mulThrowError`, `shouldBeFailed`. Тест рутини `sumThrowError` i `mulThrowError` перевіряють поведінку функцій `sum` i `mul` при некоректному вводі. Тест рутина `shouldBeFailed` має таку ж назву як і рутина в файлі `Positive.test.js`, проте результат виконання цієї рутини має бути `Passed`.

<!-- aaa for Dmytro : redundant! --> <!-- Dmytro : removed -->

### Тестування

<details>
  <summary><u>Вивід команди <code>tst .run ./</code></u></summary>

```
$ tst .run .
Launching several ( 1 ) test suite(s) ..
    Running test suite ( Negative ) ..
    Located at /../Negative.test.s:42:8

      Passed TestSuite::Negative / TestRoutine::sumThrowError in 0.023s
      Passed TestSuite::Negative / TestRoutine::mulThrowError in 0.013s
      Passed TestSuite::Negative / TestRoutine::shouldBeFailed in 0.013s
      Passed TestSuite::Negative / TestRoutine::sum in 0.015s
      Passed TestSuite::Negative / TestRoutine::mul in 0.012s
    Passed test checks 9 / 9
    Passed test cases 6 / 6
    Passed test routines 5 / 5
    Test suite ( Negative ) ... in 0.699s ... ok


  Passed test checks 9 / 9
  Passed test cases 6 / 6
  Passed test routines 5 / 5
  Passed test suites 1 / 1
  Testing ... in 1.345s ... ok

```

</details>

Отримати результати тестування можна виконавши команду `tst .run ./` в директорії модуля.

Вивід показує, що протестовано лише тест сюіт `Negative`. Всі тест рутини пройдено успішно. Тобто, рутина `shouldBeFailed` переписана нащадком - рутиною в тест сюіті `Negative`.

Крім цього, при наслідуванні кожна тест рутина відноситься до сюіту-нащадка, в звіті це позначаєтся як:

```

      Passed TestSuite::Negative / TestRoutine::mulThrowError in 0.013s    # Рутина тест сюіту `Negative`
      Passed TestSuite::Negative / TestRoutine::shouldBeFailed in 0.013s   # Рутина тест сюіту `Negative`, що переписала рутину в тест сюітi `Positive`
      Passed TestSuite::Negative / TestRoutine::sum in 0.015s              # Рутина в тест сюіті `Positive`
```

### Підсумок

- Тест сюіт може наслідувати інший тест сюіт, це дозволяє повторно використовувати код тест сюітa.
- Тест сюіт, що наслідується має бути абстрактним. Для цього в ньому указується опція `abstract : 1`.
- В тест сюіті, що наслідує, указується опція `abstract : 0`.
- Тест рутини з однаковими назвами переписуються нащадком.
- При наслідуванні всі тест рутини вважаються рутинами сюіта-нащадка.

[Повернутись до змісту](../README.md#tutorials)
