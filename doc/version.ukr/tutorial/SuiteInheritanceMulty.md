# Наслідування декількох тест сюітів

Як використовувати наслідування від декількох тест сюітів.

Утиліта дозволяє тест сюіту [наслідувати](SuiteInheritance.md) від декількох інших тест сюітів.

Наслідування від декількох тест сюітіва дозволяє розробнику розбити тест сюіт на модулі і працювати з ними окремо.

### Об'єкт тестування

В даному модулі використовується один файл з об'єктами тестування.

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

Внесіть код в файл `Math.js`.

Функція `sum` виконує додавання двох числових значень, функція `mul` повертає добуток двох числових значень. Вони експортуються для використання.

### Тестові файли

В тест модулі використовується розділення функціональностей між абстрактними тест сюітами, котрі знаходяться в файлах `Positive.test.js` i `Negative.test.js`. Тест сюіт в файлі `All.test.js` є сюітом-нащадком.


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

Тест сюіт `Positive` позначено абстракним, через указання опції `abstract : 1`.
В секції запуску тест сюіта присутній рядок з формуванням тест сюіта, [рядки запуску](HelloWorld.md) відсутні.

Тест сюіт `Positive` має три тест рутини, які проводять тестування функцій файла `Math.js`. Тест рутини `sum` i `mul` мають пройти. Тест рутина `shouldBeFailed` в разі запуску має провалитись так, як `Math.mul( -1, -2 )` повертає значення 2, що не еквівалентно значенню 3.

<details>
    <summary><u>Код файла <code>Negative.test.js</code></u></summary>

```js
let Math = require( './Math.js' );

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
  abstract : 1,
  tests :
  {
    sumThrowError,
    mulThrowError,
    shouldBeFailed,
  }
}

//

Self = wTestSuite( Self );
```

</details>

Тест сюіт `Negative` також абстракний, його можна наслідувати.

Тест сюіт `Negative` складається з трьох тест рутин - `sumThrowError`, `mulThrowError`, `shouldBeFailed`. Тест рутини `sumThrowError` i `mulThrowError` перевіряють поведінку функцій `sum` i `mul` при некоректному вводі. Тест рутина `shouldBeFailed` має таку ж назву як і рутина в файлі `Positive.test.js`, проте результат виконання цієї рутини має бути `Passed`.

<details>
    <summary><u>Код файла <code>All.test.js</code></u></summary>

```js
let _ = require( 'wTesting' );
require( './Positive.test.js' );
require( './Negative.test.js' );

//

let Parent = wTests[ 'Positive' ];
let Parent1 = wTests[ 'Negative' ];

//

function shouldBeFailed( test )
{
  test.identical( 1, true );
}

//

var Self =
{
  name : 'All',
  abstract : 0,
  tests :
  {
    shouldBeFailed,
  }
}

//

Self = wTestSuite( Self ).inherit( Parent ).inherit( Parent1 );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
```

</details>

Тест сюіт `All` наслідує від абстрактних тест сюітів, тому він має опцію `abstract : 0`.

Для наслідування від декількох тест сюітів застосовується рутина `inherit()`. Рядок

```js
Self = wTestSuite( Self ).inherit( Parent1 ).inherit( Parent );
```

можна прочитати як: тест сюіт `All`, наслідує від тест сюіту `Parent1`, котрий, в свою чергу, наслідує від тест сюіта `Parent`. Змінні `Parent` i `Parent1` позначені відразу після секції підключення залежностей. Це, відповідно, сюіти `Positive` i `Negative`.

Тест сюіт `All` включає одну тест рутину `shouldBeFailed`. Її назва повторює рутини в тест сюітах `Positive` i `Negative`. Результат проходження рутини повинен бути `failed` тому, що [`1` i `true` не ідентичні](../concepts/TestCheck.md).

### Тестування

<details>
  <summary><u>Вивід команди <code>tst .imply v:6 .run All.test.js</code></u></summary>

```
$ tst .imply v:6 .run All.test.js
Command ".imply v:6 .run All.test.js"
Includes tests from : /home/user/.../

Tester Settings :
{
  routine : null,
  routineTimeOut : null,
  suiteEndTimeOut : null,
  concurrent : null,
  verbosity : 6,
  negativity : null,
  silencing : null,
  shoulding : null,
  accuracy : null,
  sanitareTime : 500,
  fails : null,
  beeping : true,
  coloring : 1,
  debug : null,
  timing : 1,
  rapidity : 0,
  suite : null
}

Launching several ( 1 ) test suite(s) ..
  /home/user/.../All.throwing.test.s:32:12 - enabled
  1 test suite
    Running test suite ( All ) ..
    Located at /home/user/.../All.throwing.test.s:32:12

      Running TestSuite::All / TestRoutine::shouldBeFailed ..
        - got :
          1
        - expected :
          true
        - difference :
          *

        /home/user/.../All.throwing.test.s:15:8
          11 :
          12 : function shouldBeFailed( test )
          13 : {
          14 :   test.case = 'throwing'
        * 15 :   test.identical( 1, true );

        Test check ( TestSuite::All / TestRoutine::shouldBeFailed / throwing # 1 ) ... failed
      Failed TestSuite::All / TestRoutine::shouldBeFailed in 0.028s
      Running TestSuite::All / TestRoutine::sumThrowError ..
        a is not defined
        Error throwen synchronously

        /home/user/.../Negative.test.s:8:8
           6 : function sumThrowError( test )
           7 : {
        *  8 :   test.shouldThrowErrorSync( () => Math.sum( a, 1 ) );
           9 : }
          10 :

        Test check ( TestSuite::All / TestRoutine::sumThrowError /  # 1 ) : error thrown synchronously as expected ... ok
      Passed TestSuite::All / TestRoutine::sumThrowError in 0.030s
      Running TestSuite::All / TestRoutine::mulThrowError ..
        a is not defined
        Error throwen synchronously

        /home/user/.../Negative.test.s:15:8
          13 : function mulThrowError( test )
          14 : {
        * 15 :   test.shouldThrowErrorSync( () => Math.mul( a, 1 ) );
          16 : }
          17 :

        Test check ( TestSuite::All / TestRoutine::mulThrowError /  # 1 ) : error thrown synchronously as expected ... ok
      Passed TestSuite::All / TestRoutine::mulThrowError in 0.027s
      Running TestSuite::All / TestRoutine::sum ..

        /home/user/.../Positive.test.s:9:8
          5 :
          6 : function sum( test )
          7 : {
          8 :   test.case = 'integer';
        * 9 :   test.equivalent( Math.sum( 1, 1 ), 2 );

        Test check ( TestSuite::All / TestRoutine::sum / integer # 1 ) ... ok

        /home/user/.../Positive.test.s:12:8
           8 :   test.case = 'integer';
           9 :   test.equivalent( Math.sum( 1, 1 ), 2 );
          10 :
          11 :   test.case = 'float';
        * 12 :   test.equivalent( Math.sum( 1.01, 2.21 ), 3.22 );

        Test check ( TestSuite::All / TestRoutine::sum / float # 2 ) ... ok

        /home/user/.../Positive.test.s:15:8
          11 :   test.case = 'float';
          12 :   test.equivalent( Math.sum( 1.01, 2.21 ), 3.22 );
          13 :
          14 :   test.case = 'negative';
        * 15 :   test.equivalent( Math.sum( -1, -2 ), -3 );

        Test check ( TestSuite::All / TestRoutine::sum / negative # 3 ) ... ok
      Passed TestSuite::All / TestRoutine::sum in 0.034s
      Running TestSuite::All / TestRoutine::mul ..

        /home/user/.../Positive.test.s:23:8
          19 :
          20 : function mul( test )
          21 : {
          22 :   test.case = 'integer';
        * 23 :   test.equivalent( Math.mul( 1, 1 ), 1 );

        Test check ( TestSuite::All / TestRoutine::mul / integer # 1 ) ... ok

        /home/user/.../Positive.test.s:26:8
          22 :   test.case = 'integer';
          23 :   test.equivalent( Math.mul( 1, 1 ), 1 );
          24 :
          25 :   test.case = 'float';
        * 26 :   test.equivalent( Math.mul( 2.5, 2.5 ), 6.25 );

        Test check ( TestSuite::All / TestRoutine::mul / float # 2 ) ... ok

        /home/user/.../Positive.test.s:29:8
          25 :   test.case = 'float';
          26 :   test.equivalent( Math.mul( 2.5, 2.5 ), 6.25 );
          27 :
          28 :   test.case = 'negative';
        * 29 :   test.equivalent( Math.mul( -1, -2 ), 2 );

        Test check ( TestSuite::All / TestRoutine::mul / negative # 3 ) ... ok
      Passed TestSuite::All / TestRoutine::mul in 0.035s
    ExitCode : -1
    Passed test checks 8 / 9
    Passed test cases 6 / 7
    Passed test routines 4 / 5
    Test suite ( All ) ... in 0.265s ... failed



  ExitCode : -1
  Passed test checks 8 / 9
  Passed test cases 6 / 7
  Passed test routines 4 / 5
  Passed test suites 0 / 1
  Testing ... in 0.395s ... failed
```

</details>

Введіть команду `tst .imply v:6 .run All.test.js` в директорії модуля. Збільшення багатослівності виводу необхідне для слідкування за проходженням тестування. Порівняйте результати.

Підвищений рівень багатослівності виводу показує, що рутина `shouldBeFailed` провалена, її виконано з файла `All.test.js`, тобто, вона переписана останнім нащадком. Якщо тест сюіт `All` не містив би рутини `shouldBeFailed`, то вона була б переписана сюітом `Negative` і результат виконання був би `Passed`.

Крім цього, утиліта виводила код з перевірками згідно файлів розташування, а сама перевірка належить сюіту-нащадку. Наприклад:

```
        /home/user/.../Positive.test.s:29:8
          25 :   test.case = 'float';
          26 :   test.equivalent( Math.mul( 2.5, 2.5 ), 6.25 );
          27 :
          28 :   test.case = 'negative';
        * 29 :   test.equivalent( Math.mul( -1, -2 ), 2 );

        Test check ( TestSuite::All / TestRoutine::mul / negative # 3 ) ... ok
```

Перевірка знаходиться в 29-му рядку файла `Positive.test.js`, а результат проходження відноситься до тест сюіта `All`.

### Підсумок

- Наслідування від декількох сюітів дозволяє створити тест сюіт модульно - з окремих частин.
- Тест сюіти, що наслідуються мають бути абстрактними.
- В тест сюіті, що наслідує, указується опція `abstract : 0`.
- Якщо в батьківському і дочірніх тест сюітах є рутина з однаковим іменем, то така рутина переписується останнім нащадком.
- При наслідуванні всі тест рутини вважаються рутинами сюіта-нащадка.

[Повернутись до змісту](../README.md#tutorials)
