# Опція accuracy

Як врахувати точність обчислень при порівнянні числових значень.

Опція встановлює допустиме числове відхилення при порівнянні числових значень. Кожна тест рутина може встановити власну похибку, яку ця опція не змінює.

За замовчуванням встановлено відхилення в `1е-7`.

<details>
  <summary><u>Структура файлів</u></summary>

```
accuracy
    ├── Sum.js
    ├── Sum.test.js
    └── package.json
```

</details>

Для дослідження опції `accuracy` створіть структуру файлів в директорії `accuracy` як приведено вище.

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

Для перевірки опції `accuracy` потрібно, щоб тест перевірка враховувала числові відхилення при порівнянні значень.

<details>
    <summary><u>Код файла <code>Sum.test.js</code></u></summary>

```js
let _ = require( 'wTesting' );
let Sum = require( './Sum.js' );

//

function routine1( test )
{
  test.equivalent( Sum.sum( 1, 1 ), 2.003 );
  test.equivalent( Sum.sum( 2, -1 ), 1.004 );
}
routine1.accuracy = 1e-2

//

function routine2( test )
{
  test.equivalent( Sum.sum( 1, 1 ), 2.00001 );
  test.equivalent( Sum.sum( 2, -1 ), 0.99999 );
}

//

let Self =
{
  name : 'Sum',
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

Помістіть в  файл `Sum.test.js` приведений вище код.

Тест сюіт `Sum` включає дві рутини. В рутині `routine1` встановлена опція `accuracy` з допустимим відхиленням 0.01. В рутині `routine2` не встановлюється точність обчислення. В тест рутинах `routine1` i `routine2` використовується перевірка `equivalent` тому, що вона враховує числове відхилення.

Проведіть тестування в тест сюіті виконавши команду

```
tst .run Sum.test.js
```

Порівняйте з указаними результатами.

<details>
  <summary><u>Вивід команди <code>tst .run Sum.test.js</code></u></summary>

```
$ tst .run Sum.test.js
Running test suite ( Sum ) ..
    at  /path_to_module/testCreation/Sum.test.js:35

      Passed test routine ( Sum / routine1 ) in 0.069s
        Test check ( Sum / routine2 /  # 1 ) ... failed
        Test check ( Sum / routine2 /  # 2 ) ... failed
      Failed test routine ( Sum / routine2 ) in 0.080s

    Passed test checks 2 / 4
    Passed test cases 0 / 0
    Passed test routines 1 / 2
    Test suite ( Sum ) ... in 0.277s ... failed



  Testing ... in 0.347s ... failed
```

</details>

Проглянувши звіт видно, що перша тест рутина пройдена успішно. В рутині `routine1` встановлено опцію `accuracy` зі значенням 0.01, а обидві тест перевірки мають відхилення на порядок менше. В цей же час, рутина `routine2` не має встановленого відхилення і тому використовується значення за замовчуванням - 1е-7. Відповідно, перевірки рутини `routine2` провалюються.

Можливо змінити результат використавши опцію запуску `accuracy`.

<details>
  <summary><u>Вивід команди <code>tst .imply accuracy:1e-5 .run Sum.test.js</code></u></summary>

```
$ tst .imply accuracy:1e-5 .run Sum.test.js
Running test suite ( Sum ) ..
    at  /path_to_module/testCreation/Sum.test.js:35

      Passed test routine ( Sum / routine1 ) in 0.068s
      Passed test routine ( Sum / routine2 ) in 0.042s

    Passed test checks 4 / 4
    Passed test cases 0 / 0
    Passed test routines 2 / 2
    Test suite ( Sum ) ... in 0.752s ... ok


  Testing ... in 1.341s ... ok
```

</details>

Виконайте тестування в файлі `Sum.test.js` встановивши похибку значенням `2e-5`. Для цього введіть команду `tst .imply accuracy:1e-5 .run Sum.test.js`. Порівняйте результати виводу.

Тест пройдено успішно. Указана опція переписала значення відхилення за замовчуванням і перевірки в тест рутині `routine2` були пройдені. В цей же час, встановлене в тест рутині `routine1` відхилення не змінилось, інакше вона була б провалена.

### Підсумок

- Опція `accuracy` встановлює допустиме числове відхилення при порівнянні числових аргументів.
- Кожна тест рутина може мати власне числове відхилення.
- Опція `accuracy` тест рутини має пріоритет над аналогічною опцією запуска і опцією тест сюіта.

[Повернутись до змісту](../README.md#tutorials)
