# Опція timing

Ввімкнення підрахунку часу тестування.

Призначена для ввімкнення замірів часу витраченого на тестування.

Опція приймає два значення - `0` i `1`. При значенні `0` звіт не буде містити дані про сумарний час виконання. За замовчуванням опція має значення `1` і виводить час.

<details>
  <summary><u>Структура файлів</u></summary>

```
timing
   ├── Join.js
   ├── Join.test.js
   └── package.json
```

</details>

Для дослідження опції `timing` створіть структуру файлів в директорії `timing`, як приведено вище.

### Об'єкт тестування

Внесіть в файл `Join.js` приведений код.

<details>
    <summary><u>Код файла <code>Join.js</code></u></summary>

```js
module.exports.join = function( a, b )
{
  return String( a ) + String( b );
};
```

</details>

Функція `join`, в файлі `Join.js`, виконує конкатенацію двох значень. Функція експортована для проведення тестування.

### Тестовий файл

Тестування рутини здійснюється в файлі `Join.test.js`.

<details>
    <summary><u>Код файла <code>Join.test.js</code></u></summary>

```js
let _ = require( 'wTesting' );
let Join = require( './Join.js' );

//

function routine1( test )
{
  test.case = 'pass';
  test.identical( Join.join( 'Hello ', 'world!' ), 'Hello world!' );
  test.identical( Join.join( 1, 2 ), '12' );
}

//

let Self =
{
  name : 'Join',
  tests :
  {
    routine1,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
```

</details>

Тест сюіт `Join` має одну тест рутину `routine1`, в яку поміщений тест кейс `pass` з двома перевірками. Перша перевірка використовує рядкові значення, друга - числові. Обидві перевірки мають пройти.

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

Внесіть приведений код з залежностю для тестування. Завантаження залежностей здійснюється командою `npm install` в директорії модуля.

### Використання опції

Опція має два значення. Для використання значення за замовчуванням, введіть команду без опції

```
tst .run Join.test.js
```
Порівняйте вивід звіту тестування.

<details>
  <summary><u>Вивід команди <code>tst .run Join.test.js</code></u></summary>

```
$ tst .run Join.test.js
Running test suite ( Join ) ..
    at  /path_to_module/testCreation/Join.test.js:26

      Passed test routine ( Join / routine1 ) in 0.087s

    Passed test checks 2 / 2
    Passed test cases 1 / 1
    Passed test routines 1 / 1
    Test suite ( Join ) ... in 0.691s ... ok


  Testing ... in 1.270s ... ok
```

</details>

Після виконання тест сюіту звіт містить інформацію щодо часу проходження тест рутин, тест сюіту і загальний час виконання.

  <summary><u>Вивід команди <code>tst .imply timing:0 .run Join.test.js</code></u></summary>

```
$ tst .imply timing:0 .run Join.test.js
Running test suite ( Join ) ..
    at  /path_to_module/testCreation/Join.test.js:26

      Passed test routine ( Join / routine1 ) in 0.083s

    Passed test checks 2 / 2
    Passed test cases 1 / 1
    Passed test routines 1 / 1
    Test suite ( Join ) ... ok


  Testing ... ok
```

</details>

Виконайте тестування вимкнувши вивід часу. Для цього введіть команду `tst .imply timing:0 .run Join.test.js`.

Порівнявши з попереднім виводом видно, що звіт не містить часу проходження тест сюіту і загального часу виконання тесту. Час проходження тест рутин указується.

### Підсумок

- Опція `timing` призначена для ввімкнення виводу часу тестування в звіті.
- За замовчуванням утиліта виводить інформацію про час тестування.
- При значенні `timing:0` звіт не містить інформації про час виконання окремих тест сюітів і загальний час тестування.

[Повернутись до змісту](../README.md#tutorials)
