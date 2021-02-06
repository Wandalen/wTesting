# Опція sanitareTime

Регулювання часу на завершення виконання асинхронних перевірок.

Опція встановлює затримку між завершенням тест сюіта і запуском наступного. Призначена для завершення виконання перевірок з асинхронними функціями. Вказується в мілісекундах. За замовчуванням встановлено 500мс.

<details>
  <summary><u>Структура файлів</u></summary>

```
sanitareTime
     ├── Join.js
     ├── Join.test.js
     ├── Multiply.js
     ├── Multiply.test.js
     ├── Sum.js
     ├── Sum.test.js
     └── package.json
```

</details>

Для дослідження опції `sanitareTime` створіть структуру файлів в директорії `testOptions` як приведено вище.

### Об'єкти тестування

<details>
    <summary><u>Код файла <code>Join.js</code></u></summary>

```js
module.exports.join = function( a, b )
{
  return String( a ) + String( b );
};
```

</details>

З допомогою функції `join`, в файлі `Join.js`, проводиться конкатенація двох значень. Функція експортована для тестування.

<details>
    <summary><u>Код файла <code>Multiply.js</code></u></summary>

```js
module.exports.multiply = function( a, b )
{
  return Number( a ) * Number( b );
};
```

</details>

Функція `mul` файла `Multiply.js`, виконує множення двох значень.

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

### Тестові файли

Для тестування окремих рутин були створені тестові файли. Їх назва починається як і назва файла з рутиною і містить суфікс `.test` щоб утиліта могла виконати тестування.

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
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
```

</details>

В приведеному тесті виконується тестування однієї тест рутини з двома кейсами - `pass` i `fail`. Перший має дві перевірки що пройдуть, а другий містить перевірку з помилкою.

<details>
    <summary><u>Код файла <code>Multiply.test.js</code></u></summary>

```js
let _ = require( 'wTesting' );
let Mul = require( './Multiply.js' );

//

function routine1( test )
{
  test.equivalent( Mul.mul( 1, 2 ), 2 );
  test.equivalent( Mul.mul( 1, -2 ), -2 );
  test.shouldThrowErrorOfAnyKind( () => Mul.mul( a, 1 ) );
}

//

let Self =
{
  name : 'Multiply',
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

Тест має одну тест рутину з трьома перевірками. Виконується операція множення з додатніми числами, з від'ємними числами і один тест з рядковим значенням. Тест з рядковим значенням повинен викинути помилку, тому він поміщений в перевірку `shouldThrowErrorOfAnyKind`.

<details>
    <summary><u>Код файла <code>Sum.test.js</code></u></summary>

```js
let _ = require( 'wTesting' );
let Sum = require( './Sum.js' );

//

function routine1( test )
{
  test.equivalent( Sum.sum( 1, 1 ), 2 );
  test.equivalent( Sum.sum( 2, -1 ), 1 );
  test.shouldThrowErrorOfAnyKind( () => Sum.sum( a, 1 ) );
}

//

let Self =
{
  name : 'Sum',
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

Тест має одну тест рутину `routine1` з трьома перевірками. Виконується операція додавання з додатніми числами, від'ємними числами і один тест з рядковим значенням. Тест з рядковим значенням повинен видати помилку, тому він поміщений в перевірку `shouldThrowErrorOfAnyKind`.

### Встановлення залежностей

В приведених тест сюітах є одна зовнішня залежність - утиліта `Testing` для здійснення тесту.

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

При тестуванні розробник може встановити очікуваний час за який рутина з асинхронною функцією може викинути помилку.

<details>
  <summary><u>Вивід команди <code>tst .imply sanitareTime:1000 .run .</code></u></summary>

```
$ tst .imply sanitareTime:1000 .run .
Running test suite ( Join ) ..
    at  /path_to_module/testCreation/Join.test.js:40

      Test check ( Join / routine1 / fail # 3 ) ... failed
      Failed test routine ( Join / routine1 ) in 0.088s

    Passed test checks 2 / 3
    Passed test cases 1 / 2
    Passed test routines 0 / 1
    Test suite ( Join ) ... in 0.170s ... failed

    Running test suite ( Multiply ) ..
    at  /path_to_module/testCreation/Multiply.test.js:27

      Passed test routine ( Multiply / routine1 ) in 0.059s

    Passed test checks 3 / 3
    Passed test cases 0 / 0
    Passed test routines 1 / 1
    Test suite ( Multiply ) ... in 1.116s ... ok

    Running test suite ( Sum ) ..
    at  /path_to_module/testCreation/Sum.test.js:27

      Passed test routine ( Sum / routine1 ) in 0.060s

    Passed test checks 3 / 3
    Passed test cases 0 / 0
    Passed test routines 1 / 1
    Test suite ( Sum ) ... in 0.120s ... ok



  Testing ... in 2.695s ... failed
```

</details>

Виконайте тестування всіх рутин в директорії `testOptions` командою `tst .imply sanitareTime:1000 .run .`. Це встановить затримку між виконанням рутин в одну секунду. Порівняйте результат з приведеним.

Всі тести були виконані за 2.695s з урахуванням затримки в одну секунду між окремими тест сюітами. На проходження окремого тест сюіту витрачався час менший від 0.250s.

### Підсумок

- Опція `sanitareTime` призначена для встановлення затримки між завершенням тестування однієї тест рутини і початком наступної.
- Час затримки призначений для завершення виконання перевірок асинхронних рутин.

[Повернутись до змісту](../README.md#tutorials)
