# Експериментальна тест рутина

Створення експериментальних тест рутин для тестування нового функціоналу.

Експериментальні тест рутини призначені для тестування частин коду, які вводяться в експериментальний функціонал тест об'єкта.

<details>
  <summary><u>Структура модуля</u></summary>

```
testExperiment
        ├── Math.js
        ├── Experiment.test.js
        └── package.json
```

</details>

Створіть приведену вище структуру файлів для дослідження наслідування тест сюітів.

### Об'єкт тестування

В приведеному модулі використовується один файл з об'єктами тестування.

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

Внесіть приведений вище код в файл `Math.js`.

Функція `sum` виконує додавання двох числових значень, функція `mul` повертає добуток двох числових значень. Вони експортуються для використання.

### Тестові файли

Модуль має один тестовий файл - `Expriment.test.js` в якому буде поміщено дві тест рутини - одну звичайну, іншу експериментальну.

<details>
    <summary><u>Код файла <code>Experiment.test.js</code></u></summary>

```js
let _ = require( 'wTesting' );
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
mulTest.experimental = 1;

//

var Self =
{
  name : 'Experiment',
  tests :
  {
    sumTest,
    mulTest,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
```

</details>

Внесіть приведений вище код в файл `Expriment.test.js`.

Вимоги, які ставляться до написання експериментальних тест рутин відповідають [вимогам до звичайних тест рутин](./TestRoutine.md). Одночасно з цим, для того, щоб зробити тест рутину експериментальною потрібно додати властивість `experimental`, як в коді приведеному вище.

```js 
mulTest.experimental = 1;
```

### Встановлення залежностей

В приведеному тест сюіті є одна зовнішня залежність - утиліта `Testing` для здійснення тесту.

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

Внесіть приведений код з залежностями для тестування. Їх завантаження здійснюється командою `npm install` в директорії модуля.

### Тестування

Для дослідження особливостей експериментальних тест рутин виконайте тестування в директорії `testExperiment`.

<details>
  <summary><u>Вивід команди <code>tst .run . v:5</code></u></summary>

```
[user@user ~]$ tst .run . v:5
Launching several ( 1 ) test suite(s) ..
  /.../testExperiment/Experiment.test.js:43 - enabled
  1 test suite
    Running test suite ( Experiment ) ..
    Located at /.../testExperiment/Experiment.test.js:43
      
      Running TestSuite::Experiment / TestRoutine::sumTest ..
        Test check ( TestSuite::Experiment / TestRoutine::sumTest / integer # 1 ) ... ok
        Test check ( TestSuite::Experiment / TestRoutine::sumTest / float # 2 ) ... ok
        Test check ( TestSuite::Experiment / TestRoutine::sumTest / negative # 3 ) ... ok
      Passed TestSuite::Experiment / TestRoutine::sumTest in 0.064s
    Passed test checks 3 / 3
    Passed test cases 3 / 3
    Passed test routines 1 / 1
    Test suite ( Experiment ) ... in 0.637s ... ok

  
  Passed test checks 3 / 3
  Passed test cases 3 / 3
  Passed test routines 1 / 1
  Passed test suites 1 / 1
  Testing ... in 1.200s ... ok
```

</details>

Введіть команду `tst .run . v:5` в директорії модуля. Перевірте результати виводу з приведеними вище.

Приведений звіт показує, що було протестовано одну тест рутину `sumTest`, а експериментальну `mulTest` - ні. Щоб протестувати експериментальну тест рутину, потрібно [запустити її окремо](./Running.md).

<details>
  <summary><u>Вивід команди <code>tst .run ./Experiment.test.js v:5 r:mulTest</code></u></summary>

```
[user@user ~]$ tst .run . v:5
Launching several ( 1 ) test suite(s) ..
  /.../testExperiment/Experiment.test.js:43 - enabled
  1 test suite
    Running test suite ( Experiment ) ..
    Located at /.../testExperiment/Experiment.test.js:43
      
      Running TestSuite::Experiment / TestRoutine::mulTest ..
        Test check ( TestSuite::Experiment / TestRoutine::mulTest / integer # 1 ) ... ok
        Test check ( TestSuite::Experiment / TestRoutine::mulTest / float # 2 ) ... ok
        Test check ( TestSuite::Experiment / TestRoutine::mulTest / negative # 3 ) ... ok
      Passed TestSuite::Experiment / TestRoutine::mulTest in 0.068s
    Passed test checks 3 / 3
    Passed test cases 3 / 3
    Passed test routines 1 / 1
    Test suite ( Experiment ) ... in 0.640s ... ok

  
  Passed test checks 3 / 3
  Passed test cases 3 / 3
  Passed test routines 1 / 1
  Passed test suites 1 / 1
  Testing ... in 1.204s ... ok
```

</details>

Введіть команду `tst .run ./Experiment.test.js v:5 r:mulTest` в директорії модуля. Перевірте результати виводу з приведеними вище.

При індивідуальному запуску тест рутини `mulTest`, тестування було виконано. Всі тести пройдено.

Індивідуальний запуск експериментальної тест рутини дозволяє розробнику писати тести для основного функціоналу і експериментального в одному місці. При цьому в результати загального тестування не будуть включені експериментальні тест рутини. 

Окремо потрібно позначити, що експериментальні тест рутини зручно використовувати для дебагінгу та уточнення поведінки тест об'єкта. Адже, в експериментальну тест рутину можна окремо помістити необхідний тест кейс, який тестує один окремий випадок.

### Підсумок

- При проведенні загального тестування експериментальні тест рутини не виконуються.
- Для проведення тестування в експериментальній тест рутині її потрібно викликати окремо. 
- Для створення експериментальної тест рутини потрібно встановити властивість `experimental`.
- Експериментальні тест рутини призначені для тестування експериментального функціоналу тест об'єкта.
- Експериментальні тест рутини можуть використовуватись при дебагінгу та уточненні поведінки тест об'єкта.

[Повернутись до змісту](../README.md#tutorials)

