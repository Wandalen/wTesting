# Додаткові опції тестування

Застосування опцій для налаштування проходження тестів.

### Конфігурація 

<details>
  <summary><u>Структура файлів</u></summary>

```
testOptions
     ├── Join.js
     ├── Join.test.js
     ├── Multiply.js
     ├── Multiply.test.js
     ├── Sum.js
     ├── Sum.test.js
     └── package.json

```

</details>

Для дослідження опцій тестування створіть структуру файлів в директорії `testOptions` як приведено вище.

<details>
    <summary><u>Код файла <code>Join.js</code></u></summary>

```js    
module.exports.join = function( a, b )
{
  return String( a ) + String( b );
};

```

</details>

З допомогою функції в файлі `Join.js` проводиться конкатенація двох чисел.

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

var Self =
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

В приведеному тесті виконується тестування однієї тест рутини з двома кейсами. Один має дві перевірки що пройдуть, а другий - `fail` містить перевірку з помилкою. 

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
    <summary><u>Код файла <code>Multiply.test.js</code></u></summary>

```js    
let _ = require( 'wTesting' );
let Mul = require( './Multiply.js' );

//

function routine1( test )
{
  test.equivalent( Mul.mul( 1, 2 ), 2 );
  test.equivalent( Mul.mul( 1, -2 ), -2 );
  test.shouldThrowError( () => Mul.mul( a, 1 ) );
}

//

var Self =
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

Тест має одну тест рутину з трьома перевірками. Виконується операція множення з додатніми числами, від'ємними і один тест з рядковим значенням. Тест з рядковим значенням повинен видати помилку.

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
  test.shouldThrowError( () => Sum.sum( a, 1 ) );
}

//

var Self =
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

Тест має одну тест рутину `routine1` з трьома перевірками. Виконується операція додавання з додатніми числами, від'ємними числами і один тест з рядковим значенням. Тест з рядковим значенням повинен видати помилку.

### Опція `sanitareTime`

Визначає час затримки між завершенням тесту однієї тест рутини та запуском наступної. Цей час призначений для завершення виконання асинхронних функцій рутини. 

<details>
  <summary><u>Вивід команди <code>wtest . sanitareTime:1000</code></u></summary>

```
[user@user ~]$ wtest . sanitareTime:1000
Running test suite ( Join ) ..
    at  /path_to_module/testCreation/Join.test.js:40
      
      Test check ( Join / routine1 / fail # 3 ) ... failed
      Failed test routine ( Join / routine1 ) in 0.088s

    Passed test checks 2 / 3
    Passed test cases 1 / 2
    Passed test routines 0 / 1
    Test suite ( Join ) ... in 0.170s ... failed

    Passed test checks 2 / 3
    Passed test cases 1 / 2
    Passed test routines 1 / 2
    Test suite ( Join ) ... in 0.280s ... failed

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
    Test suite ( Sum ) ... in 1.120s ... ok



  Testing ... in 2.695s ... failed

```

</details>

Виконайте тестування всіх рутин в директорії `testOptions` командою `wtest . sanitareTime:1000`. Порівняйте результат з приведеним.

Всі тести були виконані за 2.695s з урахуванням затримки в одну секунду між окремими тест сюітами. Збільшіть час до трьох секунд і порівняйте з попереднім результатом.

### Опція `timing`

Призначена для включення підрахунку часу виконання тестів. При вводі `timing:0` вивід не буде містити дані про час виконання. За замовчуванням значення опції "1" - виводити час виконання.

<details>
  <summary><u>Вивід команди <code>wtest . sanitareTime:1000 timing:0</code></u></summary>

```
[user@user ~]$ wtest . sanitareTime:1000 timing:0
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
      
      Passed test routine ( Multiply / routine1 ) in 0.060s

    Passed test checks 3 / 3
    Passed test cases 0 / 0
    Passed test routines 1 / 1
    Test suite ( Multiply ) ... ok

    Running test suite ( Sum ) ..
    at  /path_to_module/testCreation/Sum.test.js:27
      
      Passed test routine ( Sum / routine1 ) in 0.058s

    Passed test checks 3 / 3
    Passed test cases 0 / 0
    Passed test routines 1 / 1
    Test suite ( Sum ) ... ok



  Testing ... failed

```

</details>

Для наочності результату використайте комбінацію параметрів `sanitareTime` i `timing`. Виконайте тестування командою `wtest . sanitareTime:1000 timing:0`. 

В порівнянні з виводом без `timing:0` утиліліта не вивела сумарний час проходження тесту який був штучно збільшений з допомогою опції `sanitareTime`.

### Опція `routineTimeOut`

Обмежує час на виконання тест рутини, вказується в мілісекундах. Якщо тест рутина не була повністю протестована за встановлений час, то вона повертає помилку тестування. Вказаний параметр застосовується до кожної тест рутини і переписує попереднє значення, якщо таке було встановлено. За замовчуванням встановлено 5000мс.

<details>
  <summary><u>Вивід команди <code>wtest . routineTimeOut:5</code></u></summary>

```
[user@user ~]$ wtest . routineTimeOut:5
Running test suite ( Join ) ..
    at  /path_to_module/testCreation/Join.test.js:40
        
        Test check ( Join / routine1 /  # 1 ) ... failed throwing error
      Failed test routine ( Join / routine1 ) in 0.067s

    Thrown 1 error(s)
    Passed test checks 0 / 1
    Passed test cases 0 / 0
    Passed test routines 0 / 1
    Test suite ( Join ) ... in 0.160s ... failed

    Running test suite ( Multiply ) ..
    at  /path_to_module/testCreation/Multiply.test.js:27
        
        Test check ( Multiply / routine1 /  # 2 ) ... failed throwing error
      Failed test routine ( Multiply / routine1 ) in 0.057s

    Thrown 1 error(s)
    Passed test checks 1 / 2
    Passed test cases 0 / 0
    Passed test routines 0 / 1
    Test suite ( Multiply ) ... in 0.121s ... failed

    Running test suite ( Sum ) ..
    at  /path_to_module/testCreation/Sum.test.js:27
        
        Test check ( Sum / routine1 /  # 2 ) ... failed throwing error
      Failed test routine ( Sum / routine1 ) in 0.054s

    Thrown 1 error(s)
    Passed test checks 1 / 2
    Passed test cases 0 / 0
    Passed test routines 0 / 1
    Test suite ( Sum ) ... in 0.121s ... failed



  Testing ... in 0.703s ... failed

```

</details>

Щоб дослідити поведінку тестера при зміні часу проходження рутини встановіть час набагато менший від середнього часу проходження. Наприклад, п'ять мілісекунд, для цього введіть команду `wtest . routineTimeOut:5`. Порівняйте з приведеними результатами.

Через те, що рутини не могли пройти тестування за встановлений час отримано провал тесту в кожній із них. 

Використовуючи даний параметр слідкуйте за об'ємом тест рутин. Помилки можуть виникнути через недостатній час на тестування.

### Опція `shoulding`

Призначена для ввімкнення тест перевірок, що починаються з `should*`. При значенні "0" опція вимикає перевірки з `should`, при "1" - вмикає. Значення за замовчуванням - "1".

<details>
  <summary><u>Вивід команди <code>wtest . shoulding:0</code></u></summary>

```
[user@user ~]$ wtest . shoulding:0
Running test suite ( Join ) ..
    at  /path_to_module/testCreation/Join.test.js:40
      
      Test check ( Join / routine1 / fail # 3 ) ... failed
      Failed test routine ( Join / routine1 ) in 0.087s

    Passed test checks 2 / 3
    Passed test cases 1 / 2
    Passed test routines 0 / 1
    Test suite ( Join ) ... in 0.175s ... failed

    Running test suite ( Multiply ) ..
    at  /path_to_module/testCreation/Multiply.test.js:27
      
      Passed test routine ( Multiply / routine1 ) in 0.046s

    Passed test checks 2 / 2
    Passed test cases 0 / 0
    Passed test routines 1 / 1
    Test suite ( Multiply ) ... in 0.605s ... ok

    Running test suite ( Sum ) ..
    at  /path_to_module/testCreation/Sum.test.js:27
      
      Passed test routine ( Sum / routine1 ) in 0.045s

    Passed test checks 2 / 2
    Passed test cases 0 / 0
    Passed test routines 1 / 1
    Test suite ( Sum ) ... in 0.608s ... ok



  Testing ... in 1.638s ... failed

```

</details>

Протестуйте роботу опції виконавши команду `wtest . shoulding:0`. Порівняйте результати виводу.

Згідно отриманого виводу в тест сюіті `Join` виконано всі перевірки, адже тест не мав перевірок з `should*`. А в сюітах `Multiply` i `Sum` було проведено на одну перевірку менше.  

### Опція `silencing`

Призначена для вимкнення з виводу додаткових повідомлень внесених розробником. Опція призначена для генерування чистого звіту тестування без додаткових включень. Приймає два значення: "0" - включити вивід в консоль, "1" - виключити вивід. Значення за замовчуванням "0".

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
  console.log( Join.join(1, 2));  
  test.identical( Join.join( 1, 2 ), '12' );

  test.case = 'fail';
  test.identical( Join.join( 1, 3 ), 13 );

}

//

var Self =
{
  name : 'Join',
  silencing : 1,
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

Для перевірки опції `silencing` потрібно внести вивід в консоль. Змініть файл `Join.test.js` згідно представленого вище коду. В тесті додано рядок для виводу результату об'єднання двох чисел, а в налаштування тест сюіта внесено опцію `silencing : 1`, котра вимикає вивід.

<details>
  <summary><u>Вивід команди <code>wtest Join.test.js</code></u></summary>

```
[user@user ~]$ wtest Join.test.js
Running test suite ( Join ) ..
    at  /path_to_module/testCreation/Join.test.js:40
        
        Test check ( Join / routine1 / fail # 3 ) ... failed
      Failed test routine ( Join / routine1 ) in 0.091s

    Passed test checks 2 / 3
    Passed test cases 1 / 2
    Passed test routines 0 / 1
    Test suite ( Join ) ... in 0.197s ... failed



  Testing ... in 0.272s ... failed

```

</details>

Виконайте тестування в файлі `Join.test.js` без застосування опції `silencing`. Для цього введіть команду `wtest Join.test.js`. Порівняйте вивід.

Отримано звичайний вивід без повідомлення в консоль.

<details>
  <summary><u>Вивід команди <code>wtest Join.test.js silencing:0</code></u></summary>

```
[user@user ~]$ wtest Join.test.js silencing:0
Running test suite ( Join ) ..
    at  /path_to_module/testCreation/Join.test.js:40
12
        
        Test check ( Join / routine1 / fail # 3 ) ... failed
      Failed test routine ( Join / routine1 ) in 0.097s

    Passed test checks 2 / 3
    Passed test cases 1 / 2
    Passed test routines 0 / 1
    Test suite ( Join ) ... in 0.194s ... failed



  Testing ... in 0.261s ... failed

```

</details>

Використайте опцію `silencing:0` для зміни його значення при виконанні тест сюіта. Введіть команду `wtest Join.test.js silencing:0` і порівняйте вивід. 

Отриманий звіт містить рядок зі згенерованим значенням. Таким чином, ввід опцій тестування в команду змінює поведінку проходження тесту, при цьому, тест сюіт не змінюється. 

Якщо при проведенні тестування використовується [опція `verbosity`](Verbosity.md) зі значенням "7" і більше, то повідомлення виводятся. В звіті вони маркуються іншим кольором.

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

Вивід консолі свідчить про те, що тести в `routine1` провалені. А тести в рутині `routine2` успішно виконані через врахування нового значення похибки.

### Підсумок

- Опції тестування допомагають налаштувати проходження тестів. 
- Опції тестування вказуються після назви тесту або директорії з тестами.
- Опції тестування можна комбінувати.
- Опції тестування переписують значення за замовчуванням та ті, що встановлені в тест сюіті.
- Указані налаштування тест рутин не змінюються при вводі тест опції. 
