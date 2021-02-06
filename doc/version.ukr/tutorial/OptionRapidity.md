# Опція rapidity

Як встановити пріоритет виконання тест рутини та керувати проходженням тестування.

Опція регулює час затрачений на тестування. Кожна тест рутина може мати власну опцію `rapidity` зі значенням від `1` до `5`. За замовчуванням опція `rapidity` має значення `3`. При виконанні тестування зі значенням опцієї запуску `rapidity` вищим за `rapidity` рутини така рутина просто не виконується.

Опція приймає значення від 1 до 5, де 1 - найповільніше тестування, 5 - найшвидше. За замовчуванням - 3.

<details>
  <summary><u>Структура файлів</u></summary>

```
rapidity
    ├── Sum.js
    ├── Sum.test.js
    └── package.json
```

</details>

Для дослідження опції `rapidity` створіть структуру файлів в директорії `rapidity` як приведено вище.

### Об'єкт тестування

<details>
    <summary><u>Код файла <code>Sum.js</code></u></summary>

```js
module.exports.sum = function( a, b )
{
  return Number( a ) + Number( b );
};
```

</details>

В файлі `Sum.js` поміщена функція додавання двох чисел.

### Тестовий файл

Для перевірки опції `rapidity` потрібно, щоб тест тест рутини мали власну опцію `rapidity`.

<details>
    <summary><u>Код файла <code>Sum.test.js</code></u></summary>

```js
let _ = require( 'wTesting' );
let Sum = require( './Sum.js' );

//

function routine1( test )
{
  test.shouldThrowErrorOfAnyKind( () => Sum.sum( a, 1 ) );
}
routine1.rapidity = 1

//

function routine2( test )
{
  test.equivalent( Sum.sum( -1, -1 ), -2 );
}
routine2.rapidity = 2

//

function routine3( test )
{
  test.equivalent( Sum.sum( 1, 1 ), 2 );
}

//

function routine4( test )
{
  test.notEquivalent( Sum.sum( 1, 1 ), 2.003 );
}
routine4.rapidity = 4

//

function routine5( test )
{
  test.equivalent( Sum.sum( 1 + 1e-8, 1 ), 2 );
}
routine5.rapidity = 5

//

let Self =
{
  name : 'Sum',
  tests :
  {
    routine1,
    routine2,
    routine3,
    routine4,
    routine5,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
```

</details>

Помістіть в  файл `Sum.test.js` приведений вище код.

Тест сюіт містить п'ять тест рутин - від `routine1` до `routine5`. Значення опції `rapidity` встановлено згідно номеру рутини. В рутині `routine3` опція не встановлена тому, що за замовчуванням рутина має значення опції рівне `3`.

Всі тест рутини розташовано в порядку пріоритету виконання. Найменший пріоритет має негативне тестування в рутині `routine1`, а найвище - в `routine5` - перевірка того, що враховується числове відхилення.

### Тестування з урахуванням пріоритету рутин

Тестування згідно пріоритету відповідає конкретним тестовим ситуаціям. Найповільніше, з рівнем 1 - для повного тестування програми, а найшвидше, з рівнем 5 - для основного функціоналу.

Проведіть повне тестування використавши команду

```
tst .imply rapidity:1 .run Sum.test.js
```

Порівняйте з указаними результатами.

<details>
  <summary><u>Вивід команди <code>tst .imply rapidity:1 .run Sum.test.js</code></u></summary>

```
$ tst .imply rapidity:1 .run Sum.test.js
Running test suite ( Sum ) ..
    at  /.../Sum.test.js:60

      Passed test routine ( Sum / routine1 ) in 0.075s
      Passed test routine ( Sum / routine2 ) in 0.043s
      Passed test routine ( Sum / routine3 ) in 0.037s
      Passed test routine ( Sum / routine4 ) in 0.042s
      Passed test routine ( Sum / routine5 ) in 0.040s

    Passed test checks 5 / 5
    Passed test cases 0 / 0
    Passed test routines 5 / 5
    Test suite ( Sum ) ... in 0.963s ... ok


  Testing ... in 1.575s ... ok
```

</details>

Утиліта протестувала всі п'ять тест перевірок. Результат тестування - пройдене, час виконання - 1.575s.

<details>
  <summary><u>Вивід команди <code>tst .run Sum.test.js</code></u></summary>

```
$ tst .run Sum.test.js
Running test suite ( Sum ) ..
    at  /.../Sum.test.js:60

      Passed test routine ( Sum / routine3 ) in 0.054s
      Passed test routine ( Sum / routine4 ) in 0.047s
      Passed test routine ( Sum / routine5 ) in 0.038s

    Passed test checks 3 / 3
    Passed test cases 0 / 0
    Passed test routines 3 / 3
    Test suite ( Sum ) ... in 0.864s ... ok


  Testing ... in 1.480s ... ok
```

</details>

Здійсніть тестування за замовчуванням - без указання опції `rapidity`. Введіть команду `tst Sum.test.js` і порівняйте результати.

В звіті указано, що пройдено тестування в рутинах від `routine3` до `routine5`. В рутині `routine3` опція не указана, тож, використано значення за замовчуванням.

<details>
  <summary><u>Вивід команди <code>tst .imply rapidity:5 .run Sum.test.js</code></u></summary>

```
$ tst .imply rapidity:5 .run Sum.test.js
Running test suite ( Sum ) ..
    at  /.../Sum.test.js:60

      Passed test routine ( Sum / routine5 ) in 0.056s

    Passed test checks 1 / 1
    Passed test cases 0 / 0
    Passed test routines 1 / 1
    Test suite ( Sum ) ... in 0.731s ... ok


  Testing ... in 1.335s ... ok
```

</details>

Уявіть, що потрібно провести тестування лише основного функціоналу, тобто, зі значенням `rapidity:5`. Введіть команду `tst .imply rapidity:5 .run Sum.test.js ` і порівняйте результати.

Утиліта протестувала рутину `routine5`, час проходження тесту 1.335s. При різниці в чотири перевірки, час виконання скоротився на 0.2s. Таким чином опція `rapidity` дозволяє сортувати рутини за пріоритетом і проводити тестування з різною швидкістю.

### Підсумок

- Опція `rapidity` регулює час на проходження тест сюіту.
- Опція `rapidity` встановлює пріоритет виконання тест рутини.
- Пріоритет виконання має значення від 1 до 5. 1 - найнижчий пріоритет, найбільш повільне тестування; 5 - найвищий пріоритет, найшвидше тестування.

[Повернутись до змісту](../README.md#tutorials)
