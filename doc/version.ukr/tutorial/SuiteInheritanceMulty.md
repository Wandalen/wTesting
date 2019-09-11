# Наслідування декількох тест сюітів

Як використовувати наслідування від декількох тест сюітів.

Утиліта дозволяє тест сюіту [наслідувати](SuiteInheritance.md) від декількох інших тест сюітів. В свою чергу, ця техніка дозволяє розробнику розбити тест сюіт на модулі і працювати з ними окремо.

<details>
  <summary><u>Структура тест модуля</u></summary>

```
suiteInheritanceMulty
        ├── Math.js
        ├── All.test.js
        ├── Negative.test.js
        ├── Positive.test.js
        └── package.json
```

</details>

Створіть приведену вище структуру файлів для дослідження наслідування тест сюітів.

### Об'єкт тестування

В даному модулі використовується один файл з об'єктами тестування.

<details>
    <summary><u>Код файла <code>Math.js</code></u></summary>

```js    
module.exports.sum = function( a, b )
{
  return Number( a ) + Number( b );
};

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

function sumTest( test )
{
  test.case = 'integer';
  test.equivalent( Math.sum( 1, 1 ), 2 );
  test.case = 'float';
  test.equivalent( Math.sum( 1.01, 2.21 ), 3.22 );
  test.case = 'negative';
  test.equivalent( Math.sum( -1, -2 ), -3 );
}

//

function mulTest( test )
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
    sumTest,
    mulTest,
    shouldBeFailed,
  }
}

//

Self = wTestSuite( Self );
```

</details>

Внесіть приведений вище код в файл `Positive.test.js`.

Тест сюіт `Positive` позначено абстракним, через указання опції `abstract : 1`.
В секції запуску тест сюіта присутній рядок з формуванням тест сюіта, [рядки запуску](HelloWorld.md) відсутні.

Тест сюіт `Positive` має три тест рутини, які проводять тестування функцій файла `Math.js` при вводі чисел. Тест рутини `sumTest` i `mulTest` мають пройти. Тест рутина `shouldBeFailed` в разі запуску має провалитись так, як `Math.mul( -1, -2 )` повертає значення 2, що не еквівалентно значенню 3.

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
  abstract : 0,
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

Внесіть приведений вище код в файл `Negative.test.js`.

Тест сюіт `Negative` також абстракний, його можна наслідувати.

Тест сюіт `Negative` складається з трьох тест рутин - `sumThrowError`, `mulThrowError`, `shouldBeFailed`. Тест рутини `sumThrowError` i `mulThrowError` перевіряють поведінку функцій `sum` i `mul` при некоректному вводі. Тест рутина `shouldBeFailed` має таку ж назву як і рутина в файлі `Positive.test.js`, проте результат виконання цієї рутини має бути `pass`.

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
  test.il( 1, true );
}

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

Тест сюіт `All` включає одну тест рутину `shouldBeFailed`. Її назва повторює рутини в тест сюітах `Positive` i `Negative`. Результат проходження рутини повинен бути `failed` тому, що [`1` i `true` не еквівалентні](../concepts/TestCheck.md).

### Встановлення залежностей

В тест сюіті є одна залежність - утиліта `Testing` для здійснення тесту.

<details>
    <summary><u>Код файла <code>package.json</code></u></summary>

```json    
{
  "dependencies": {
    "wTesting": ""
  }
}
```

</details>

Внесіть приведений код з залежністю для тестування. Її завантаження здійснюється командою `npm install` в директорії модуля.

### Тестування

З наявних в директорії `suiteInheritanceMulty` файлів лише `All.test.js` можна виконати утилітою.

<details>
  <summary><u>Вивід команди <code>tst .imply v:6 .run All.test.js</code></u></summary>

```
[user@user ~]$ tst .imply v:6 .run All.test.js
Includes tests from : /.../suiteInheritanceMulty

Tester Settings :
{
  scenario : test,
  sanitareTime : 2000,
  fails : null,
  beeping : true,
  coloring : 1,
  timing : 1,
  rapidity : 3,
  routine : null,
  negativity : null,
  routineTimeOut : null,
  concurrent : null,
  verbosity : 5,
  silencing : null,
  shoulding : null,
  accuracy : null
}

  Launching several ( 1 ) test suites ..
  /.../suiteInheritanceMulty/All.test.js:29 - enabled
  1 test suite

    Running test suite ( All ) ..
    at  /.../suiteInheritanceMulty/All.test.js:29

      Running test routine ( shouldBeFailed ) ..

        - got :
          1
        - expected :
          true
        - difference :
          *

        /.../suiteInheritanceMulty/All.test.js:14
            10 : //
            11 :
            12 : function shouldBeFailed( test )
            13 : {
            14 :   test.il( 1, true );  
        Test check ( All / shouldBeFailed /  # 1 ) ... failed

      Failed test routine ( All / shouldBeFailed ) in 0.088s
      Running test routine ( sumThrowError ) ..

         = Message
        a is not defined

         = Condensed calls stack
            at Proxy.test.shouldThrowErrorOfAnyKind (/.../suiteInheritanceMulty/Negative.test.js:7:42)
            ...

         = Catches stack
            caught at Proxy.exceptionReport @ /usr/lib/node_modules/wTesting/proto/dwtools/atop/tester/l5/Routine.s:2560

         = Source code from /.../suiteInheritanceMulty/Negative.test.js:7
            6 : {
            7 :   test.shouldThrowErrorOfAnyKind( () => Math.sum( a, 1 ) );
            8 : }

        Error throwen synchronously



        /.../suiteInheritanceMulty/Negative.test.js:7
            7 :   test.shouldThrowErrorOfAnyKind( () => Math.sum( a, 1 ) );
            8 : }
            9 :
            10 : //
            11 :   
        Test check ( All / sumThrowError /  # 1 ) : error thrown synchronously as expected ... ok

      Passed test routine ( All / sumThrowError ) in 0.078s
      Running test routine ( mulThrowError ) ..

         = Message
        a is not defined

         = Condensed calls stack
            at Proxy.test.shouldThrowErrorOfAnyKind (/.../suiteInheritanceMulty/Negative.test.js:14:42)
            ...

         = Catches stack
            caught at Proxy.exceptionReport @ /usr/lib/node_modules/wTesting/proto/dwtools/atop/tester/l5/Routine.s:2560

         = Source code from /.../suiteInheritanceMulty/Negative.test.js:14
            13 : {
            14 :   test.shouldThrowErrorOfAnyKind( () => Math.mul( a, 1 ) );
            15 : }

        Error throwen synchronously



        /.../suiteInheritanceMulty/Negative.test.js:14
            14 :   test.shouldThrowErrorOfAnyKind( () => Math.mul( a, 1 ) );
            15 : }
            16 :
            17 : //
            18 :   
        Test check ( All / mulThrowError /  # 1 ) : error thrown synchronously as expected ... ok

      Passed test routine ( All / mulThrowError ) in 0.077s
      Running test routine ( sumTest ) ..


        /.../suiteInheritanceMulty/Positive.test.js:8
            4 :
            5 : function sumTest( test )
            6 : {
            7 :   test.case = 'integer';
            8 :   test.equivalent( Math.sum( 1, 1 ), 2 );  
        Test check ( All / sumTest / integer # 1 ) ... ok



        /.../suiteInheritanceMulty/Positive.test.js:10
            6 : {
            7 :   test.case = 'integer';
            8 :   test.equivalent( Math.sum( 1, 1 ), 2 );
            9 :   test.case = 'float';
            10 :   test.equivalent( Math.sum( 1.01, 2.21 ), 3.22 );  
        Test check ( All / sumTest / float # 2 ) ... ok



        /.../suiteInheritanceMulty/Positive.test.js:12
            8 :   test.equivalent( Math.sum( 1, 1 ), 2 );
            9 :   test.case = 'float';
            10 :   test.equivalent( Math.sum( 1.01, 2.21 ), 3.22 );
            11 :   test.case = 'negative';
            12 :   test.equivalent( Math.sum( -1, -2 ), -3 );  
        Test check ( All / sumTest / negative # 3 ) ... ok

      Passed test routine ( All / sumTest ) in 0.089s
      Running test routine ( mulTest ) ..


        /.../suiteInheritanceMulty/Positive.test.js:20
            16 :
            17 : function mulTest( test )
            18 : {
            19 :   test.case = 'integer';
            20 :   test.equivalent( Math.mul( 1, 1 ), 1 );  
        Test check ( All / mulTest / integer # 1 ) ... ok



        /.../suiteInheritanceMulty/Positive.test.js:22
            18 : {
            19 :   test.case = 'integer';
            20 :   test.equivalent( Math.mul( 1, 1 ), 1 );
            21 :   test.case = 'float';
            22 :   test.equivalent( Math.mul( 2.5, 2.5 ), 6.25 );  
        Test check ( All / mulTest / float # 2 ) ... ok



        /.../suiteInheritanceMulty/Positive.test.js:24
            20 :   test.equivalent( Math.mul( 1, 1 ), 1 );
            21 :   test.case = 'float';
            22 :   test.equivalent( Math.mul( 2.5, 2.5 ), 6.25 );
            23 :   test.case = 'negative';
            24 :   test.equivalent( Math.mul( -1, -2 ), 2 );  
        Test check ( All / mulTest / negative # 3 ) ... ok

      Passed test routine ( All / mulTest ) in 0.089s

    Passed test checks 8 / 9
    Passed test cases 6 / 6
    Passed test routines 4 / 5
    Test suite ( All ) ... in 0.610s ... failed



  ExitCode : -1
  Passed test checks 8 / 9
  Passed test cases 6 / 6
  Passed test routines 4 / 5
  Passed test suites 0 / 1
  Testing ... in 0.699s ... failed
```

</details>

Введіть команду `tst .imply v:6 .run All.test.js` в директорії модуля. Збільшення багатослівності виводу необхідне для слідкування за проходженням тестування. Порівняйте результати.

Підвищений рівень багатослівності виводу показує, що рутина `shouldBeFailed` провалена, її виконано з файла `All.test.js`, тобто, вона переписана останнім нащадком. Якщо тест сюіт `All` не містив би рутини `shouldBeFailed`, то вона була б переписана сюітом `Negative` і результат виконання був би `pass`.

Крім цього, утиліта виводила код з перевірками згідно файлів розташування, а сама перевірка належить сюіту-нащадку. Наприклад:

```
 /.../suiteInheritanceMulty/Positive.test.js:24
            20 :   test.equivalent( Math.mul( 1, 1 ), 1 );
            21 :   test.case = 'float';
            22 :   test.equivalent( Math.mul( 2.5, 2.5 ), 6.25 );
            23 :   test.case = 'negative';
            24 :   test.equivalent( Math.mul( -1, -2 ), 2 );  
        Test check ( All / mulTest / negative # 3 ) ... ok
```

Перевірка знаходиться в 24-му рядку файла `Positive.test.js`, а результат проходження відноситься до тест сюіта `All`.

### Підсумок

- Тест сюіт може наслідувати декількох тест сюітів.
- Наслідування від декількох сюітів дозволяє створити тест сюіт модульно - з окремих частин.
- Тест сюіти, що наслідуються мають бути абстрактними.
- В тест сюіті, що наслідує, указується опція `abstract : 0`.
- Якщо в батьківському і дочірніх тест сюітах є рутина з однаковим іменем, то така рутина переписується останнім нащадком.
- При наслідуванні всі тест рутини вважаються рутинами сюіта-нащадка.

[Повернутись до змісту](../README.md#tutorials)
