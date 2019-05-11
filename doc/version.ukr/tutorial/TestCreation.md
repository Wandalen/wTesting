#  Створення тесту "Hello World!"

Створення модульного тесту для тестування функції конкатенації.

### Тестування . Конфігурація

<details>
  <summary><u>Структура модуля</u></summary>

```
testModule
   └── proto
        ├── hello.js
        └── test.hello.js    

```

</details>

Для проведення простого тесту достатньо одного файлу в якому буде поміщатись тестована рутина і її тест. Для чистоти коду в прикладі використовується два файла. Перший, з назвою `hello.js` має рутину для тестування, а другий, з назвою `test.hello.js` включає тест сюіт для тестування функції першого файла. 

<details>
    <summary><a href="./tutorial/Criterions.md">Код файла math.js</a></summary>
    
```js    
module.exports.hello = function(a,b)
{
    return a + b;
}

```
  
</details>

Внесіть приведений вище код для тестування. За призначенням ця функція має конкатенувати два значення, що подані на вхід. Для того, щоб рутину можна було протестувати вона повинна бути експортованою.  

<details>
    <summary><a href="./tutorial/Criterions.md">Код файла test.math.js</a></summary>
    
```js    
if( typeof module !== 'undefined' )
{
  let _ = require( '../Tools.s' );

  if( typeof _realGlobal_ === 'undefined' || !_realGlobal_.wTester || !_realGlobal_.wTester._isReal_ )

  _.include( 'wLogger' );
  _.include( 'wTesting' );

}

let a = require('./hello.js');
var _global = _global_;
var _ = _global_.wTools;

//

function hello(test)
{
  test.case = 'test output';
  test.will = 'hello';
  var got = a.hello("Hello, ", "World!" );
  var expected = "Hello, World!";
  test.identical( got, expected );
}

function integers(test)
{
  test.case = 'test output2';
  test.will = 'integers';
  var got = a.hello( 1, 2 );
  var expected = 12;
  test.identical( got, expected );
}

//

var Self =
{
  name : 'Sample/Trivial',
  silencing : 0,

  tests :
  {
    hello : hello,
    integers : integers,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name ); 

```
  
</details>

Внесіть приведений код в файл `test.math.js`.

Приведений тест має один `тест сюіт` з назвою `Sample`. При виконанні `тест сюіту` виконується дві `тест рутини` - `sum1` і `sum2`. Кожна із `тест рутин` має по одному `тест кейсу`, який об'єднує дві `тест перевірки`. `Тест перевірки` `sum1` і `sum3` перевіряють на співпадіння отриманого результату при сумуванні двох чисел і передбачуваного результату. `Тест перевірки` `sum2` і `sum4` перевіряють чи не співпадає отриманий при сумуванні результат і передбачуваний. В перевірці `sum2` навмисне допущена помилка для отримання повідомлення про провал тесту.

### Запуск тесту

Приведений код вказує, що для виконання тестування необхідно встановити залежності. Потрібно встановити локально утиліту `wTools` i утиліту `wLogger` при умові, що утиліта `wTesting` у вас уже [встановлена](Installation.md).

<details>
  <summary><u>Вивід команди npm install wTools wLogger</u></summary>

```
[user@user ~]$ npm install wTools wLogger
+ wLogger@0.5.172
+ wTools@0.8.454
added 27 packages from 3 contributors and audited 53 packages in 2.19s

```

</details>

Встановіть указані залежності виконавши команду `npm install wTools wLogger` в директорії `testModule`.

<details>
  <summary><u>Структура файлів після завантаження залежностей</u></summary>

```
testModule
   ├── node_modules
   │        ├── wLogger
   │        ├── wTools
   │        ├──...
   │        ├──
   ├── proto
   │    ├── math.js
   │    └── test.math.js
   │
   └── package-lock.json     

```

</details>

Після завантаження залежностей структура файлів має виглядати як приведено вище. 

Існують три способа запуска тестів з наступними командами:  
- використовуючи утиліту `wTesting` з допомогою команди `wtest`;
- використовуючи пакетний менеджер NPM, командою `npm test`;
- використовучи NodeJS, указавши шлях до файла.

Для запуску тесту з довільного тест-файла використовуйте команду `wtest`. Для цього аргументом команди має бути шлях до тест файла.

<details>
  <summary><u>Вивід команди wtest proto/test.math.js</u></summary>

```
[user@user ~]$ wtest proto/test.math.js
at  /path_to_test/testModule/proto/test.math.js:40
        
        Test check ( Sample / sum1 / sum integers < sum2 # 2 ) ... failed
      Failed test routine ( Sample / sum1 ) in 0.076s
      Passed test routine ( Sample / sum2 ) in 0.056s

    Passed test checks 3 / 4
    Passed test cases 1 / 2
    Passed test routines 1 / 2
    Test suite ( Sample ) ... in 0.266s ... failed



  Testing ... in 0.333s ... failed

```

</details>

Запустіть команду `wtest proto/test.math.js` знаходячись в директорії `testModule`.

Після проходження тесту утиліта вивела повну інформацію про результати тестування. Згідно виводу отримана помилка в `тест перевірці` `sum2`. Загальний підсумок: пройдено 3 `тест перевірки` з 4, один з двох `тест кейсів`, одна з двох `тест рутин`. Загальний висновок по `тест сюіту` - провалений.

### Запуск окремої тест рутини


### Підсумок


### Розташуванння окремих тест рутин та їх реалізацій

Окремі тест рутини розташовані в директорії `wTools/proto/dwtools/abase`

Вони мають вигляд (на прикладі Тест рутини mapIdentical):

```javascript
var Self =
{

  /* options of the test suit */
  name : 'MapTest',
  silencing : 1,

  /* map of test routines available in the test suit */
  tests :
  {

    mapIdentical : mapIdentical,

  }

}
```

Тест рутина `mapIdentical` має таку реалізацію:

```javascript

function mapIdentical( test )
{

  test.description = 'same values';
  var got = _.mapIdentical( { a : 7, b : 13 }, { a : 7, b : 13 } );
  var expected = true;
  test.identical( got, expected );

  test.description = 'not the same values in'
  var got = _.mapIdentical( { 'a' : 7, 'b' : 13 }, { 'a' : 7, 'b': 14 } );
  var expected = false;
  test.identical( got, expected );

  test.description = 'different number of keys, more in the first argument'
  var got = _.mapIdentical( { 'a' : 7, 'b' : 13, 'с' : 15 }, { 'a' : 7, 'b' : 13 } );
  var expected = false;
  test.identical( got, expected );

  test.description = 'different number of keys, more in the second argument'
  var got = _.mapIdentical( { 'a' : 7, 'b' : 13 }, { 'a' : 7, 'b' : 13, 'с' : 15 } );
  var expected = false;
  test.identical( got, expected );

  /* special cases */

  test.description = 'empty maps, standrard'
  var got = _.mapIdentical( {}, {} );
  var expected = true;
  test.identical( got, expected );

  test.description = 'empty maps, pure'
  var got = _.mapIdentical( Object.create( null ), Object.create( null ) );
  var expected = true;
  test.identical( got, expected );

  test.description = 'empty maps, one standard another pure'
  var got = _.mapIdentical( {}, Object.create( null ) );
  var expected = true;
  test.identical( got, expected );

  /* bad arguments */

  if( !Config.debug )
  return;

  test.description = 'no arguments';
  test.shouldThrowError( function()
  {
    _.mapIdentical();
  });

  test.description = 'not object-like arguments';
  test.shouldThrowError( function()
  {
    _.mapIdentical( [ 'a', 7, 'b', 13 ], [ 'a', 7, 'b', 14 ] );
  });
  test.shouldThrowError( function()
  {
    _.mapIdentical( 'a','b' );
  });
  test.shouldThrowError( function()
  {
    _.mapIdentical( 1,3 );
  });
  test.shouldThrowError( function()
  {
    _.mapIdentical( null,null );
  });
  test.shouldThrowError( function()
  {
    _.mapIdentical( undefined,undefined );
  });

  test.description = 'too few arguments';
  test.shouldThrowError( function()
  {
    _.mapIdentical( {} );
  });

  test.description = 'too much arguments';
  test.shouldThrowError( function()
  {
    _.mapIdentical( {}, {}, 'redundant argument' );
  });

}

```
Тест рутина `mapIdentical` прокиває ( тестує ) рутину із аналогічною назвою `mapIdentical` та такою реалізацією:

```javascript

function mapIdentical( src1,src2 )
{

  _.assert( arguments.length === 2 );

  if( Object.keys( src1 ).length !== Object.keys( src2 ).length )
  return fale;

  for( var s in src1 )
  {
    if( src1[ s ] !== src2[ s ] )
  return false;
  }

  return true;
}

```

<a name="unit-testing-anatomy"/>

## Анатомія модульного теста

Кожний модульний тест має наступну структуру :

1. Налаштування теста

2. Виклик тестуємого метода

3. Твердження

Для прикладу розглянемо слідуючий модульний тест arraySetBut - він розташований в файлі `wTools/proto/dwtools/abase/layer1.test/Array.test.s` :

```javascript
  test.description = 'first argument has single extra element, second argument has single extra element either';
  var a = [ 1, 2, 3, 4, 15 ];
  var b = [ 1, 2, 3, 4, 5 ];
  var got = _.arraySetBut( a, b );
  var expected = [ 15 ];
  test.identical( got, expected );
  test.shouldBe( got !=== a );
  test.shouldBe( got !=== b );
```

В налаштуваннях він має :

1. Короткий опис - `  test.description = 'first argument has single extra element, second argument has single extra element either';`

2. Значення параметрів :
```javascript
  var a = [ 1, 2, 3, 4, 15 ];
  var b = [ 1, 2, 3, 4, 5 ];
```

Виклик тестуємого метода :

```javascript
  var got = _.arraySetBut( a, b );
```

Твердження :

```javascript
  test.identical( got, expected );
```
