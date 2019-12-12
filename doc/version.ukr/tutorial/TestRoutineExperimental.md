# Експериментальна тест рутина

Створення експериментальних тест рутин як засобу для поліпшення розуміння коду і комунікації між членами команди розробників.

Відстань між окремими членами команди розробників, а також складність пояснень можуть погіршити розуміння між членами команди і зменшити ефективність розробки в цілому. Експериментальні тест рутини призначені для покращення діалогу між розробниками при виникненні незрозумілих деталей реалізації певного функціоналу програми.

<details>
  <summary><u>Структура модуля</u></summary>

```
testExperiment
        ├── Experiment.test.js
        └── package.json
```

</details>

Створіть приведену вище структуру файлів для дослідження експериментальних тест рутин в тест сюіті.

### Тестовий файл

Модуль має один тестовий файл - `Expriment.test.js` в якому поміщено дві тест рутини - одну звичайну та другу - експериментальну.

<details>
    <summary><u>Код файла <code>Experiment.test.js</code></u></summary>

```js
let _ = require( 'wTesting' );

//

function sqrtTest( test )
{
  test.case = 'integer';
  test.equivalent( Math.sqrt( 4 ), 2 );
}

//

function sqrtTestExperiment( test )
{
  test.case = 'strings';
  test.equivalent( sum( -4 ), 'Complex value' );
}
sqrtTestExperiment.experimental = true;

//

var Self =
{
  name : 'Experiment',
  tests :
  {
    sqrtTest,
    sqrtTestExperiment,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
```

</details>

Внесіть приведений вище код в файл `Expriment.test.js`.

Метод `Math.sqrt` визначає квадратний корінь числа. Тест рутина `sqrtTest` виконує тестування при використанні позитивних числових значень, а рутина `sqrtTestExperiment` виконує експеримент, котрий показує бажану поведінку при використанні  негативних чисел. Тест рутина `sqrtTestExperiment` провалиться, адже, `Math.sqrt` поверне значення `NaN`.

З коду тест файла видно, що вимоги, які ставляться до написання експериментальних тест рутин відповідають [вимогам до звичайних тест рутин](./TestRoutine.md). A для того, щоб зробити тест рутину експериментальною потрібно призначити полю `experimental` тест рутини `true`.

```js 
sqrtTestExperiment.experimental = true;
```

### Тестування

Для дослідження особливостей експериментальних тест рутин виконайте тестування в директорії `testExperiment`.

<details>
  <summary><u>Вивід команди <code>tst .run ./Experiment.test.js</code></u></summary>

```
[user@user ~]$ tst .run Experiment.test.js
Launching several ( 1 ) test suite(s) ..
  /.../testExperiment/Experiment.test.js:43 - enabled
  1 test suite
    Running test suite ( Experiment ) ..
    Located at /.../testExperiment/Experiment.test.js:34
      
      Passed TestSuite::Experiment / TestRoutine::sqrtTest in 0.031s
    Passed test checks 1 / 1
    Passed test cases 1 / 1
    Passed test routines 1 / 1
    Test suite ( Experiment ) ... in 0.601s ... ok

  
  Passed test checks 1 / 1
  Passed test cases 1 / 1
  Passed test routines 1 / 1
  Passed test suites 1 / 1
  Testing ... in 1.159s ... ok
```

</details>

Введіть команду `tst .run ./Experiment.test.js` в директорії модуля. Перевірте результати виводу з приведеними вище.

Приведений звіт показує, що було протестовано одну тест рутину `sqrtTest`, а експериментальну `sqrtTestExperiment` - ні. Щоб протестувати експериментальну тест рутину, потрібно [запустити її окремо](./Running.md).

<details>
  <summary><u>Вивід команди <code>tst .run ./Experiment.test.js r:sumTestExperiment</code></u></summary>

```
[user@user ~]$ tst .run ./Experiment.test.js r:sumTestExperiment
Launching several ( 1 ) test suite(s) ..
  /.../testExperiment/Experiment.test.js:43 - enabled
  1 test suite
    Running test suite ( Experiment ) ..
    Located at /.../testExperiment/Experiment.test.js:34
      
      Test check ( TestSuite::Experiment / TestRoutine::sqrtTestExperiment / strings # 1 ) ... failed, throwing error
      Failed ( thrown error ) TestSuite::Experiment / TestRoutine::sqrtTestExperiment in 0.050s
    Thrown 1 error(s)
    Passed test checks 0 / 1
    Passed test cases 0 / 1
    Passed test routines 0 / 1
    Test suite ( Experiment ) ... in 0.117s ... failed


  
  Thrown 1 error(s)
  Passed test checks 0 / 1
  Passed test cases 0 / 1
  Passed test routines 0 / 1
  Passed test suites 0 / 1
  Testing ... in 0.167s ... failed
```

</details>

Введіть команду `tst .run ./Experiment.test.js r:sqrtTestExperiment` в директорії модуля. Перевірте результати виводу з приведеними вище.

При індивідуальному запуску тест рутини `sqrtTestExperiment`, тестування було виконано. Як було указано раніше, тест рутина провалена. Після уточнення деталей поведінки рутини `Math.sqrt` розробник може розширити метод або використати інший підхід для вирішення задачі. 

Експериментальні тест рутини зручно використовувати для відлагодження та уточнення поведінки тест об'єкта. Адже, в експериментальну тест рутину можна окремо помістити необхідний тест кейс з одним окремим випадком. Відповідно, іншому розробнику буде легко знайти експериментальну тест рутину і дати пояснення щодо поведінки. А відсутність результатів тестування експериментальних тест рутин в загальному звіті, дозволяє розробнику писати тести для основного функціоналу і експериментального в одному місці.

### Підсумок

- При проведенні загального тестування експериментальні тест рутини не виконуються.
- Для проведення тестування в експериментальній тест рутині її потрібно викликати окремо. 
- Для створення експериментальної тест рутини потрібно встановити властивість `experimental`.
- Експериментальні тест рутини призначені спрощення взаємодії між командою розробників при використанні спільного коду, для уточнення деталей реалізації і поведінки коду.

[Повернутись до змісту](../README.md#tutorials)

