### Опція `accuracy`

Встановлює точність (похибку) з якою виконуються перевірки в математичних функціях. Опція переписує похибку, що встановлена за замовчуванням - 1е-7. Кожна тест рутина може встановити власну похибку, яку ця опція не змінює.

<details>
    <summary><u>Код файла <code>Sum.test.js</code></u></summary>

```js    
let _ = require( 'wTesting' );
let Sum = require( './Sum.js' );

//

function routine1( test )
{
  test.equivalent( Sum.sum( 1, 1 ), 2.03 );
  test.equivalent( Sum.sum( 2, -1 ), 1.04 );
}
routine1.accuracy = 1e-2

//

function routine2( test )
{
  test.equivalent( Sum.sum( 1, 1 ), 2.1 );
  test.equivalent( Sum.sum( 2, -1 ), 0.9 );
}

//

var Self =
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

Змініть файл `Sum.test.js` згідно приведеного вище коду. Тест сюіт `Sum` включає дві рутини. В рутині `routine1` встановлена похибка 0.01, а очікуваний результат виходить за рамки похибки. В рутині `routine2` не встановлюється точність обчислення.

Зверніть увагу, що перевірка `identical` перевіряє на абсолютну ідентичність значень і не враховує похибку. Для перевірки значень з похибкою використовується `equivalent`.

<details>
  <summary><u>Вивід команди <code>wtest Sum.test.js accuracy:0.2</code></u></summary>

```
[user@user ~]$ wtest Sum.test.js accuracy:0.2
Running test suite ( Sum ) ..
    at  /path_to_module/testCreation/Sum.test.js:35

        Test check ( Sum / routine1 /  # 1 ) ... failed
        Test check ( Sum / routine1 /  # 2 ) ... failed
      Failed test routine ( Sum / routine1 ) in 0.146s
      Passed test routine ( Sum / routine2 ) in 0.045s

    Passed test checks 2 / 4
    Passed test cases 0 / 0
    Passed test routines 1 / 2
    Test suite ( Sum ) ... in 0.333s ... failed



  Testing ... in 0.414s ... failed

```

</details>

Виконайте тестування в файлі `Sum.test.js` встановивши похибку значенням "0.2". Для цього введіть команду `wtest Sum.test.js accuracy:0.2`. Порівняйте результати виводу.

Вивід консолі свідчить про те, що тести в `routine1` провалені. Указана опція не змогла змінити налаштування рутини. Тести в рутині `routine2` успішно виконані через врахування нового значення похибки.

### Підсумок

- Опції тестування допомагають налаштувати проходження тестів.
- Опції тестування вказуються після назви тесту або директорії з тестами.
- Опції тестування можна комбінувати.
- Опції тестування переписують значення за замовчуванням та ті, що встановлені в тест сюіті.
- Указані налаштування тест рутин не змінюються опціями тестування.
