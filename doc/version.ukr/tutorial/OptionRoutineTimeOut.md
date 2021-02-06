# Опція `routineTimeOut`

Як задати час на виконання тест рутини.

Опція обмежує час, за який кожна тест рутина має пройти тестування. Кожна тест рутина може мати власний `timeOut`. Якщо тест рутина має власний `timeOut` то значення опції запуску `routineTimeOut` не впливає на неї. Якщо тест рутина не була повністю протестована за встановлений час, то вона вважається проваленою.

Значення опції вказується в мілісекундах. За замовчуванням встановлено 5000мс.

<details>
  <summary><u>Структура файлів</u></summary>

```
routineTimeOut
        ├── Join.js
        ├── Join.test.js
        └── package.json
```

</details>

Для дослідження опції `routineTimeOut` створіть структуру файлів в директорії `routineTimeOut` як приведено вище.

### Об'єкт тестування

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

Для дослідження поведінки тестера проведіть перше тестування без застосування опції. При цьому за замовчуванням на тест рутину відводиться 5000мс.

<details>
  <summary><u>Вивід команди <code>tst .run Join.test.js</code></u></summary>

```
$ tst .run Join.test.js
Running test suite ( Join ) ..
    at  /.../Join.test.js:40

      Passed test routine ( Join / routine1 ) in 0.067s

    Passed test checks 2 / 2
    Passed test cases 1 / 1
    Passed test routines 1 / 1
    Test suite ( Join ) ... in 0.669s ... ok


  Testing ... in 1.250s ... ok
```

</details>

Тест успішно пройдений. Загальний час виконання 1.250s, а час виконання рутини - 0.067s.

Тепер, встановіть час набагато менший від часу проходження. Наприклад, п'ять мілісекунд, для цього введіть команду

```
tst .imply routineTimeOut:5 .run .
```

При цьому знак `.` позначає поточну директорію модуля. Порівняйте з приведеними результатами.

<details>
  <summary><u>Вивід команди <code>tst .imply routineTimeOut:5 .run .</code></u></summary>

```
$ tst .imply routineTimeOut:5 .run .
Running test suite ( Join ) ..
    at  /.../Join.test.js:40

        Test check ( Join / routine1 /  # 1 ) ... failed throwing error
      Failed test routine ( Join / routine1 ) in 0.069s

    Thrown 1 error(s)
    Passed test checks 0 / 1
    Passed test cases 0 / 0
    Passed test routines 0 / 1
    Test suite ( Join ) ... in 0.176s ... failed



  Testing ... in 0.239s ... failed
```

</details>

Через те, що рутина не могла пройти тестування за встановлений час отримано провал тесту. Це штучне заниження часу виконання, зазвичай, час проходження тест рутин збільшують.

Одним із варіантів, що забезпечить достатній час на проходження тестування, є застосування опції `timeOut` в тест рутині.

<details>
    <summary><u>Код файла <code>Join.test.js</code> з опцією <code>timeOut</code></u></summary>

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
routine1.timeOut = 6000;

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

Замініть код тест файла на приведений вище. В файл внесена опція `timeOut` зі значенням 6000мс, значення вибрано більшим від встановленого за замовчуванням.

Повторіть останню введену команду (`tst .imply routineTimeOut:5 .run Join.test.js`). Порівняйте результат з приведеним.

<details>
  <summary><u>Вивід команди <code>tst .imply routineTimeOut:5 .run Join.test.js</code></u></summary>

```
$ tst .imply routineTimeOut:5 .run Join.test.js
Running test suite ( Join ) ..
    at  /.../Join.test.js:41

      Passed test routine ( Join / routine1 ) in 0.062s

    Passed test checks 2 / 2
    Passed test cases 1 / 1
    Passed test routines 1 / 1
    Test suite ( Join ) ... in 0.659s ... ok


  Testing ... in 1.241s ... ok
```

</details>

В опції запуску був встановлений час, якого недостатньо для проходження рутини. Завдяки опції `timeOut`, встановленій в рутині, тест був пройдений.

### Підсумок

- Опція запуску `routineTimeOut` призначена для обмеження часу виконання тест рутини.
- Опція запуску переписує значення встановлене за замовчуванням, а також опцію тест сюіта.
- Значення `timeOut` за замовчуванням - 5000мс.
- Опція тест рутини `timeOut` не переписується опцією запуску або опцією тест сюіта.

[Повернутись до змісту](../README.md#tutorials)
