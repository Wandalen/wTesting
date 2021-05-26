# Опція beeping

Сигналізація про закінчення тестування.

Призначена для ввімкнення звукового оповіщення по завершенню тестування.

Опція має два значення: 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 1.

Для дослідження опції можна використати будь-який готовий приклад. Якщо ви його не маєте, створіть приведену структуру файлів.

<details>
  <summary><u>Структура модуля</u></summary>

```
beeping
    ├── Join.js
    ├── Join.test.js
    └── package.json
```

</details>

В директорію `beeping` поміщено три файла: об'єкт тестування `Join.js`, тестовий файл `Join.test.js` і файл з залежностями `package.json`.

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

Внесіть в файл `Join.test.js` приведений вище код.

Тест сюіт `Join` включає дві тест рутини. Тест рутина `routine1` виконує тест перевірку з рядковими значеннями. Тест рутина `routine2` включає два тест кейса, котрі містять по одній перевірці. Тест кейс `pass` пройде тому, що очікуване значення - рядок, а тест кейс `fail` провалиться, бо очікуване значення - число.

### Використання опції

За замовчуванням опція ввімкнена. Тому виконайте тестування командою без указання опції

```
tst .run Join.test.js
```

<details>
  <summary><u>Вивід команди <code>tst .run Join.test.js</code></u></summary>

```
$ tst .run Join.test.js
Running test suite ( Join ) ..
    at  /.../Join.test.js:38

      Passed test routine ( Join / routine1 ) in 0.056s
        Test check ( Join / routine2 / fail # 2 ) ... failed
      Failed test routine ( Join / routine2 ) in 0.059s

    Passed test checks 2 / 3
    Passed test cases 1 / 2
    Passed test routines 1 / 2
    Test suite ( Join ) ... in 0.246s ... failed



  Testing ... in 0.303s ... failed
```

</details>

Утиліта просигналізувала про завершення тестування. В виводі маємо очікуваний результат - пройдено дві перевірки з трьох.

Виконайте тестування командою

```
tst .imply beeping:0 Join.test.js
```

Прослідкуйте за виконанням тестування. Після його завершення звукового сигналу не повинно бути, а звіт повторює попередній.

Для користувачів `posix` операційних систем (`Linux`-дистрибутиви), звукового сигналу про завершення тестування може не бути. Звуковий сигнал, переважно, вимкнено в операційній системі. За бажанням ви можете налаштувати вашу операційну систему на видачу таких повідомлень.

### Підсумок

- За замовчуванням утиліта сигналізує про завершення тестування.
- Відключити сигнал можна використавши опцію `beeping`.

[Повернутись до змісту](../README.md#tutorials)
