# Опція negativity

Як отримати більше інформації про провалені тести.

Призначена для обмеження виводу інформації по рутинам зі статусом `ok` / `pass` і збільшення об'єму інформації про перевірки зі статусом `failed`.

Опція має скорочену форму - `n`.

Приймає значення від 0 до 9. За замовчуванням - 1.

<details>
  <summary><u>Структура модуля</u></summary>

```
negativity
        ├── Join.js
        ├── Join.test.js
        └── package.json
```

</details>

Створіть приведену вище структуру файлів для дослідження опції `negativity`.

### Об'єкт тестування

<details>
    <summary><u>Код файла <code>Join.js</code></u></summary>

```js
module.exports.join = function( a, b )
{
  return String( a ) + String( b );
}
```

</details>

Внесіть приведений вище код в файл `Join.js`.

Функція `join` виконує конкатенацію двох рядочків. Вона експортується для використання.

### Тестовий файл

Тест сюіт `Join.test.js` має суфікс `.test` для того, щоб утиліта для тестування могла знайти його.

<details>
    <summary><u>Код файла <code>Join.test.js</code></u></summary>

```js
let _ = require( 'wTesting' );
let Join = require( './Join.js' );

//

function routine1( test )
{
  test.identical( Join.join( 'Hello ', 'world!' ), 'Hello world!' );
}

//

function routine2( test )
{

  test.case = 'pass';
  test.identical( Join.join( 1, 3 ), '13' );

  test.case = 'fail';
  test.identical( Join.join( 1, 3 ), 13 );

}

//

let Self =
{
  name : 'Join',
  tests :
  {
    routine1,
    routine2,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
```

</details>

Внесіть приведений вище код в файл `Join.test.js`.

Тест сюіт `Join` включає дві тест рутини. Тест рутина `routine1` виконує тест перевірку з рядковими значеннями. Тест рутина `routine2` включає два тест кейса, котрі містять по одній перевірці. Тест кейс `pass` пройде тому, що очікуване значення - рядок, а тест кейс `fail` провалиться, бо очікуване значення - число.

### Встановлення залежностей

В приведеному коді підключено дві залежності. Перша - утиліта `Testing` для здійснення тесту. Друга - файл `Join.js` з рутиною для тестування.

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

### Отримання інформації про помилку

Для того, щоб було помітніше різницю між використанням різних налаштувань опції `negativity` використовуйте її в комбінації з опцією `verbosity:5`.

<details>
  <summary><u>Вивід команди <code>tst .imply verbosity:5 .run Join.test.js</code></u></summary>

```
$
Includes tests from : /.../negativity

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
  /.../negativity/Join.test.js:38 - enabled
  1 test suite

    Running test suite ( Join ) ..
    at  /.../negativity/Join.test.js:38

      Running test routine ( routine1 ) ..
        Test check ( Join / routine1 /  # 1 ) ... ok
      Passed test routine ( Join / routine1 ) in 0.067s
      Running test routine ( routine2 ) ..
        Test check ( Join / routine2 / pass # 1 ) ... ok

        - got :
          '13'
        - expected :
          13
        - difference :
          *

        /.../negativity/Join.test.js:20
            16 :   test.case = 'pass';
            17 :   test.identical( Join.join( 1, 3 ), '13' );
            18 :
            19 :   test.case = 'fail';
            20 :   test.identical( Join.join( 1, 3 ), 13 );
        Test check ( Join / routine2 / fail # 2 ) ... failed

      Failed test routine ( Join / routine2 ) in 0.106s

    Passed test checks 2 / 3
    Passed test cases 1 / 2
    Passed test routines 1 / 2
    Test suite ( Join ) ... in 0.260s ... failed



  ExitCode : -1
  Passed test checks 2 / 3
  Passed test cases 1 / 2
  Passed test routines 1 / 2
  Passed test suites 0 / 1
  Testing ... in 0.335s ... failed
```

</details>

Введіть команду `tst .imply verbosity:5 .run Join.test.js`, це аналогічно до команди `tst .imply verbosity:5 negativity:1 .run Join.test.js`. Порівняйте з привденими вище результатами.

При використанні опції `verbosity:5` і вище, звіт містить детальну [інформацію про помилку](Verbosity.md#елементи-звіту-що-виводятся-при-зміні-вербальності). Тому в звіті присутня секція з отриманим і очікуваним значенням, а також, різницею між ними. Нижче приведена секцію з кодом проваленої перевірки.

<details>
  <summary><u>Вивід команди <code>tst .imply v:5 n:0 .run Join.test.js</code></u></summary>

```
$ tst .imply v:5 n:0 .run Join.test.js
Includes tests from : /.../negativity

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
  /.../negativity/Join.test.js:38 - enabled
  1 test suite

    Running test suite ( Join ) ..
    at  /.../negativity/Join.test.js:38

      Running test routine ( routine1 ) ..
        Test check ( Join / routine1 /  # 1 ) ... ok
      Passed test routine ( Join / routine1 ) in 0.067s
      Running test routine ( routine2 ) ..
        Test check ( Join / routine2 / pass # 1 ) ... ok
        Test check ( Join / routine2 / fail # 2 ) ... failed
      Failed test routine ( Join / routine2 ) in 0.106s

    Passed test checks 2 / 3
    Passed test cases 1 / 2
    Passed test routines 1 / 2
    Test suite ( Join ) ... in 0.260s ... failed



  ExitCode : -1
  Passed test checks 2 / 3
  Passed test cases 1 / 2
  Passed test routines 1 / 2
  Passed test suites 0 / 1
  Testing ... in 0.322s ... failed
```

</details>

При значенні `verbosity:5` зменшіть об'єм виводу про помилки. Для цього використовуйте команду `tst .imply v:5 n:0 .run Join.test.js`. Використання скороченої форми запису опцій зручніша в використанні тому і використанa в команді.

Звіт, на відміну від попереднього, не містить розгорнутої інформації про помилку. Зазначено лише те, що провалена одна тест перевірка.

У випадку, коли потрібно розкрити лише провалені тест перевірки, можна використати комбінацію опції `verbosity:0` i `negativity >= 3`. Якщо встановлено опцію `verbosity:0`, то утиліта [не виводить жодного рядка](Verbosity.md#елементи-звіту-що-виводятся-при-зміні-вербальності), якщо додати опцію `negativity` то рівень виводу інформації про помилки збільшується.

<details>
  <summary><u>Вивід команди <code>tst .imply v:0 n:3 .run Join.test.js</code></u></summary>

```
$ tst .imply v:0 n:3 .run Join.test.js

Failed test routine ( Join / routine2 ) in 0.051s
```

</details>

Введіть команду `tst .imply v:0 n:3 .run Join.test.js`. Після виконання тестування порівняйте результат.

Утиліта вивела один рядок з указанням тест рутини, що провалилась.

<details>
  <summary><u>Вивід команди <code>tst .imply v:0 n:5 .run Join.test.js</code></u></summary>

```
$ tst .imply v:0 n:5 .run Join.test.js

        - got :
          '13'
        - expected :
          13
        - difference :
          *

        /.../negativity/Join.test.js:20
            16 :   test.case = 'pass';
            17 :   test.identical( Join.join( 1, 3 ), '13' );
            18 :
            19 :   test.case = 'fail';
            20 :   test.identical( Join.join( 1, 3 ), 13 );
        Test check ( Join / routine2 / fail # 2 ) ... failed

      Failed test routine ( Join / routine2 ) in 0.100s
```

</details>

Підвищіть рівень виводу інформаці про помилки, введіть команду `tst .imply v:0 n:5 .run Join.test.js`.

Даний звіт дає розробнику звіт про помилку і повністю виключає інформацію про пройдені рутини.

### Підсумок

- Опція `negativity` призначена для збільшення об'єму звіту про провалені перевірки.
- Опцію `negativity` краще використовувати в комбінації з опцією `verbosity`.
- При значенні `0` опція `negativity` обмежує вивід інформації про помилки.
- При відключенні виводу опцією `verbosity:0` можна отримати звіт встановивши опцію `negativity` зі значенням від `3` і вище.

[Повернутись до змісту](../README.md#tutorials)
