# Експериментальна тест рутина

Створення експериментальних тест рутин для тестування нового функціоналу.

Експериментальні тест рутини призначені для тестування частин коду, які вводяться в експериментальний функціонал тест об'єкта.

<details>
  <summary><u>Структура модуля</u></summary>

```
testExperiment
        ├── Experiment.test.js
        └── package.json
```

</details>

Створіть приведену вище структуру файлів для дослідження наслідування тест сюітів.

### Тестовий файл

Модуль має один тестовий файл - `Expriment.test.js` в якому поміщено тест об'єкт - рутину `sum` i дві тест рутини - одну звичайну, іншу експериментальну.

<details>
    <summary><u>Код файла <code>Experiment.test.js</code></u></summary>

```js
let _ = require( 'wTesting' );

//

function sum( a, b )
{
  return a + b;
}

//

function sumTest( test )
{
  test.case = 'integer';
  test.equivalent( sum( 1, 1 ), 2 );
  test.case = 'float';
  test.equivalent( sum( 1.01, 2.21 ), 3.22 );
  test.case = 'negative';
  test.equivalent( sum( -1, -2 ), -3 );
}

//

function sumTestExperiment( test )
{
  test.case = 'strings';
  test.equivalent( sum( 'a', 'b' ), NaN );
}
sumTestExperiment.experimental = 1;

//

var Self =
{
  name : 'Experiment',
  tests :
  {
    sumTest,
    sumTestExperiment,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
```

</details>

Внесіть приведений вище код в файл `Expriment.test.js`.

Функція `sum` виконує додавання двох значень. Тест рутина `sumTest` виконує тестування основного функціоналу при використанні числових значень, а рутина `sumTestExperiment` виконує спеціальний експеримент, котрий показує бажану поведінку рутини `sum`. Тест рутина `sumTestExperiment` провалиться, адже, рутина `sum` проведе конкатенування рядкових значень.

Вимоги, які ставляться до написання експериментальних тест рутин відповідають [вимогам до звичайних тест рутин](./TestRoutine.md). Одночасно з цим, для того, щоб зробити тест рутину експериментальною потрібно додати властивість `experimental`, як в коді приведеному вище.

```js 
sumTestExperiment.experimental = 1;
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
    Located at /.../testExperiment/Experiment.test.js:45
      
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

Приведений звіт показує, що було протестовано одну тест рутину `sumTest`, а експериментальну `sumTestExperiment` - ні. Щоб протестувати експериментальну тест рутину, потрібно [запустити її окремо](./Running.md).

<details>
  <summary><u>Вивід команди <code>tst .run ./Experiment.test.js v:5 r:sumTestExperiment</code></u></summary>

```
[user@user ~]$ tst .run . v:5
Launching several ( 1 ) test suite(s) ..
  /.../testExperiment/Experiment.test.js:43 - enabled
  1 test suite
    Running test suite ( Experiment ) ..
    Located at /.../testExperiment/Experiment.test.js:45
      
      Running TestSuite::Experiment / TestRoutine::sumTestExperiment ..
        - got :
          'ab'
        - expected :
          NaN 
        - difference :
          *
        with accuracy 1e-7
        
          
        /home/dmytry/Documents/UpWork/IntellectualServiceMysnyk/sources/wPathFundamentals/sample/Experiment.test.js:27
          23 : 
          24 : function sumTestExperiment( test )
          25 : {
          26 :   test.case = 'strings';
        * 27 :   test.equivalent( sum( 'a', 'b' ), NaN );
          
        Test check ( TestSuite::Experiment / TestRoutine::sumTestExperiment / strings # 1 ) ... failed
      Failed TestSuite::Experiment / TestRoutine::sumTestExperiment in 0.070s
    Passed test checks 0 / 1
    Passed test cases 0 / 1
    Passed test routines 0 / 1
    Test suite ( Experiment ) ... in 0.137s ... failed


  
  Passed test checks 0 / 1
  Passed test cases 0 / 1
  Passed test routines 0 / 1
  Passed test suites 0 / 1
  Testing ... in 0.198s ... failed```

</details>

Введіть команду `tst .run ./Experiment.test.js v:5 r:sumTestExperiment` в директорії модуля. Перевірте результати виводу з приведеними вище.

При індивідуальному запуску тест рутини `sumTestExperiment`, тестування було виконано. Як було указано раніше, тест рутина провалена.

Експериментальні тест рутини зручно використовувати для відладки та уточнення поведінки тест об'єкта. Адже, в експериментальну тест рутину можна окремо помістити необхідний тест кейс, який тестує один окремий випадок.

Індивідуальний запуск експериментальної тест рутини дозволяє розробнику писати тести для основного функціоналу і експериментального в одному місці. При цьому в результати загального тестування не будуть включені експериментальні тест рутини.

### Підсумок

- При проведенні загального тестування експериментальні тест рутини не виконуються.
- Для проведення тестування в експериментальній тест рутині її потрібно викликати окремо. 
- Для створення експериментальної тест рутини потрібно встановити властивість `experimental`.
- Експериментальні тест рутини призначені для тестування експериментального функціоналу тест об'єкта.
- Експериментальні тест рутини можуть використовуватись при дебагінгу та уточненні поведінки тест об'єкта.

[Повернутись до змісту](../README.md#tutorials)

