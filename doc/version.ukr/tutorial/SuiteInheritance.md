# Наслідування тест сюіта

Наслідування одного тест сюіта іншим.

В об'єктно-орієнтованому програмуванні наслідування - це механізм утворення нових класів на основі використання існуючих. При цьому властивості та функціональність батьківського класу переходять до класу нащадка (дочірнього). Ця концепція використовується при побудові тест сюітів - будь-який тест сюіт може наслідувати один або декілька інших тест сюітів. При наслідуванні, тест рутини батьківського сюіта, зберігаються - ці тест рутини можуть бути змінені одним із нащадків.  

<details>
  <summary><u>Структура модуля</u></summary>

```
suiteInheritance
        ├── Math.js
        ├── Negative.test.js
        ├── Positive.test.js
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

Модуль має два тестових файла - `Positive.test.js` i `Negative.test.js`. Перший буде батьківським тест сюітом, а другий - нащадком.


<details>
    <summary><u>Код файла <code>Positive.test.js</code></u></summary>

```js    
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

//

function shouldBeFailed( test )
{
  test.equivalent( Math.mul( -1, -2 ), 3 );
}

//

var Self =
{
  name : 'Positive',
  abstract : 1,
  tests :
  {
    sumTest,
    mulTest,
    shouldBeFailed,
  }
}

//

Self = wTestSuite( Self );
```

</details>

Внесіть приведений вище код в файл `Positive.test.js`.

Тест файл `Positive.test.js` в секції об'явлення тест сюіта має поле `abstract : 1`. Це спеціальне поле, указанння якого робить тест сюіт абстрактним - доступним для наслідування та недоступним для виконання. При значенні `abstract : 1` утиліта не зможе виконати тестування в файлі `Positive.test.js` командою `tst Positive.test.js`.

В секції запуску тест сюіта присутній рядок з формуванням тест сюіта

```
Self = wTestSuite( Self );
```
[Рядки запуску](HelloWorld.md) відсутні.

В секції підключення залежностей присутній рядок з указанням файла з об'єктом тестування. Підключення тестера не потрібне.

Тест сюіт `Positive` має три тест рутини, які проводять тестування функцій файла `Math.js` при вводі чисел. Тест рутини `sumTest` i `mulTest` мають пройти. Тест рутина `shouldBeFailed` в разі запуску має провалитись так, як `Math.mul( -1, -2 )` повертає значення 2, що не еквівалентно значенню 3.

<details>
    <summary><u>Код файла <code>Negative.test.js</code></u></summary>

```js    
let _ = require( 'wTesting' );
let Math = require( './Math.js' );
require( './Positive.test.js' );

//

function sumThrowError( test )
{
  test.shouldThrowErrorOfAnyKind( () => Math.sum( a, 1 ) );
}

//

function mulThrowError( test )
{
  test.shouldThrowErrorOfAnyKind( () => Math.mul( a, 1 ) );
}

//

function shouldBeFailed( test )
{
  test.notEquivalent( Math.mul( -1, -2 ), 3 );
}

//

var Self =
{
  name : 'Negative',
  abstract : 0,
  tests :
  {
    sumThrowError,
    mulThrowError,
    shouldBeFailed,
  }
}

//

Self = wTestSuite( Self ).inherit( wTests[ 'Positive' ] );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
```

</details>

Внесіть приведений вище код в файл `Negative.test.js`.

Для наслідування від батьківського тест сюіту, в секції визначення указується опція `abstract` зі значенням `0`. Це дає утиліті зрозуміти, що тест сюіт наслідує від абстрактного тест сюіту.

В секції запуску здійснюється об'явлення наслідування:

```js
Self = wTestSuite( Self ).inherit( wTests[ 'Positive' ] );
```

Це читається так: тест сюіт `Negative` (`Self`) наслідує від тест сюіта `Positive`.

Складові:

- `Self` - змінна, що позначає тест сюіт.
- `wTestSuite( Self )` - об'являє, що тестер має формувати тест сюіт з об'єкту `Self` указаного вище.
- `inherit( ... )` - рутина, що здійснює механізм наслідування. В параметр передається батьківський тест сюіт.
- `wTests[ 'Positive' ]` - об'явлення тест сюіту для наслідування. Може бути винесене в змінну.

Щоб тест сюіт міг знайти батьківський тест сюіт, в секції підключення залежностей указано файл

```js
require( './Positive.test.js' );
```

Таким чином, абстрактний тест сюіт може наслідуватись іншими, якщо виконуються три умови:

- в секції об'явлення тест сюіта встановлено опцію `abstract : 0`;
- в секції запуску тест сюіту об'явлено наслідування через `inherit()`;
- в секції підключення залежностей указано батьківський тест сюіт.

Тест сюіт `Negative` складається з трьох тест рутин - `sumThrowError`, `mulThrowError`, `shouldBeFailed`. Тест рутини `sumThrowError` i `mulThrowError` перевіряють поведінку функцій `sum` i `mul` при некоректному вводі. Тест рутина `shouldBeFailed` має таку ж назву як і рутина в файлі `Positive.test.js`, проте результат виконання цієї рутини має бути `pass`.

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

Директорія `suiteInheritance` містить два тест файла, один з яких є абстрактним і не може бути запущений утилітою прямо.

<details>
  <summary><u>Вивід команди <code>tst .run .</code></u></summary>

```
[user@user ~]$ tst .run .
Running test suite ( Negative ) ..
    at  /.../suiteInheritance/Negative.test.js:42

      Passed test routine ( Negative / sumThrowError ) in 0.066s
      Passed test routine ( Negative / mulThrowError ) in 0.043s
      Passed test routine ( Negative / shouldBeFailed ) in 0.037s
      Passed test routine ( Negative / sumTest ) in 0.046s
      Passed test routine ( Negative / mulTest ) in 0.044s

    Passed test checks 9 / 9
    Passed test cases 6 / 6
    Passed test routines 5 / 5
    Test suite ( Negative ) ... in 0.958s ... ok


  Testing ... in 1.539s ... ok
```

</details>

Введіть команду `tst .run .` в директорії модуля. Перевірте результати виводу з приведеними вище.

Протестовано лише тест сюіт `Negative`. Звіт свідчить, що всі тест рутини пройдено успішно. Тобто, рутина `shouldBeFailed` переписана нащадком - рутиною в тест сюіті `Negative`.

Крім цього, при наслідуванні кожна тест рутина відноситься до сюіту-нащадка, в звіті це позначаєтся як:

```
      Passed test routine ( Negative / mulThrowError ) in 0.043s    # Рутина тест сюіту `Negative`
      Passed test routine ( Negative / shouldBeFailed ) in 0.037s   # Рутина тест сюіту `Negative`, що переписала рутину в тест сюітi `Positive`
      Passed test routine ( Negative / sumTest ) in 0.046s          # Рутина в тест сюіті `Positive`
```

### Підсумок

- Тест сюіт може наслідувати інший тест сюіт.
- Наслідування дозволяє повторно використовувати код тест сюіту.
- Тест сюіт, що наслідується має бути абстрактним. Для цього в ньому указується опція `abstract : 1`.
- В тест сюіті, що наслідує, указується опція `abstract : 0`.
- Тест рутини з однаковими назвами переписуються нащадком.
- При наслідуванні всі тест рутини вважаються рутинами сюіта-нащадка.

[Повернутись до змісту](../README.md#tutorials)
