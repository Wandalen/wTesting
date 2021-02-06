# Опція shoulding

Як вимкнути перевірки з should*.

Призначена для вимкнення негативного тестування. Тест перевірки, що починаються з `should*` можуть бути вимкнені цією опцією.

Опція має два значення: 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 1.

<details>
  <summary><u>Структура файлів</u></summary>

```
shoulding
     ├── Multiply.js
     ├── Multiply.test.js
     └── package.json
```

</details>

Для дослідження опції `shoulding` створіть структуру файлів в директорії `shoulding` як приведено вище.

### Об'єкт тестування

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

### Тестовий файл

Назва тест файла починається як і назва файла з рутиною, вона містить суфікс `.test`, щоб утиліта могла виконати тестування.

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

### Встановлення залежностей

В тест сюіті є одна зовнішня залежність - утиліта `Testing` для здійснення тесту.

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

### Використання опції

Опція має два значення. Перевірте роботу тестера при використанні значення за замовчуванням. Для цього введіть команду

```
tst .run Multiply.test.js
```

Порівняйте з приведеним виводом

<details>
  <summary><u>Вивід команди <code>tst .run Multiply.test.js</code></u></summary>

```
$ tst .run Multiply.test.js
Running test suite ( Multiply ) ..
    at  /.../Multiply.test.js:27

      Passed test routine ( Multiply / routine1 ) in 0.096s

    Passed test checks 3 / 3
    Passed test cases 0 / 0
    Passed test routines 1 / 1
    Test suite ( Multiply ) ... in 0.697s ... ok


  Testing ... in 1.271s ... ok
```

</details>

Всі три тест перевірки в тест рутині було успішно пройдено за 0.096s. Очевидно, що рутина, передана в перевірку `shouldThrowErrorOfAnyKind` викинула помилку.

В випадках, коли програма перевіряється на очікувану поведінку, краще пропустити негативні перевірки. Це можливо відлючивши перевірки з `should`.

<details>
  <summary><u>Вивід команди <code>tst .imply shoulding:0 .run Multiply.test.js</code></u></summary>

```
$ tst .imply shoulding:0 .run Multiply.test.js
Running test suite ( Multiply ) ..
    at  /.../Multiply.test.js:27

       Passed test routine ( Multiply / routine1 ) in 0.080s

    Passed test checks 2 / 2
    Passed test cases 0 / 0
    Passed test routines 1 / 1
    Test suite ( Multiply ) ... in 0.683s ... ok


  Testing ... in 1.257s ... ok
```

</details>

Протестуйте роботу опції виконавши команду `tst .imply shoulding:0 .run Multiply.test.js`. Порівняйте результати виводу.

В отриманому звіті зазначається дві пройдені перевірки, а перевірка `shouldThrowErrorOfAnyKind` пропущена. Застосування опції скоротило час виконання рутини до 0.08s.

### Підсумок

- Опція `shoulding` призначена для вимкнення перевірок, що починаються на `should`.
- Перевірки з `should` тестують поведінку модуля при нестандартному вводі.
- При значенні `shoulding:0` утиліта перевіряє поведінку модуля в нормальних умовах.

[Повернутись до змісту](../README.md#tutorials)
