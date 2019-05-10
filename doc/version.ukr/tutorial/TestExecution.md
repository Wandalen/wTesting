# Запуск тестів

Як запускати <code>тест кейси</code>, <code>тест рутини</code>, <code>тест сюіти</code>. 

Для початку тестування потрібно мати три складові: 
- людину, що буде тестувати;
- код (програму, модуль, тощо), що треба тестувати;
- чим тестувати - спеціальне програмне забезпечення, тест рутини, фізичні пристрої, тощо. 

З першим пунктом все гаразд. Виконаємо наступні дві частини перед запуском. 

### Довільна рутина для тестування. Конфігурація

<details>
  <summary><u>Структура модуля</u></summary>

```
testModule
   └── proto
        ├── math.js
        └── test.math.js    

```

</details>

Для проведення простого тесту достатньо одного файлу в якому буде поміщатись тестована рутина і її тест. Для чистоти коду в прикладі використовується два файла. Перший, з назвою `math.js` має рутину для тестування, а другий, з назвою `test.math.js` включає `тест сюіт` для тестування першого файла. 

<details>
    <summary><a href="./tutorial/Criterions.md">Код файла <code>math.js</code></a></summary>
    
```js    
module.exports.sum = function(a,b){
  return a + b;
}

```
  
</details>

Внесіть приведений вище код для тестування. Це операція додавання двох чисел з назвою `sum`. Для того, щоб рутину можна було протестувати вона повинна бути експортованою.  

<details>
    <summary><a href="./tutorial/Criterions.md">Код файла <code>test.math.js</code></a></summary>
    
```js    
if( typeof module !== 'undefined' )
{
  let _ = require( 'wTools' );

  if( typeof _realGlobal_ === 'undefined' || !_realGlobal_.wTester || !_realGlobal_.wTester._isReal_ )

  _.include( 'wLogger' );
  _.include( 'wTesting' );
}

let math = require('./math.js');
var _global = _global_;
var _ = _global_.wTools;

function sum(test)
{
  test.case = 'sum integers';
  test.will = 'sum1';
  var got = math.sum( 1, 2);
  var expected =  3 ;
  test.identical( got,expected );
 
  test.will = 'sum2';
  var got = math.sum( 1, 2);
  var expected =  3 ;
  test.notIdentical( got,expected );
}

var Self =
{
  name : 'Sample',

  tests :
  {
    sum : sum,
  }
}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

```
  
</details>

Внесіть приведений код в файл `test.math.js`.

Приведений тест має один тест сюіт з назвою `Sample`. При виконанні тест сюіту виконується одна тест рутина `sum` з двома перевірками. Тест перевірка `sum1` перевіряє на співпадіння отриманого результату при сумуванні двох чисел і передбачуваного результату. Тест перевірка `sum2` перевіряє чи не співпадає отриманий при сумуванні результат і передбачуваний. В перевірці навмисне допущена помилка для отримання повідомлення про провал тесту.

### Запуск тесту

Приведений код вказує, що для виконання тестування необхідно встановити залежності. Потрібно встановити локально утиліти `wTools` i `wLogger` при умові, що утиліта `wTesting` у вас уже [встановлена](Installation.md).

<details>
    <summary><a href="./tutorial/Criterions.md">Код файла <code>math.js</code></a></summary>
    
```js    
npm install wTools
+ wTools@0.8.454
added 14 packages from 3 contributors in 11.159s
dmytry@dmytry:~/Documents/UpWork/IntellectualServiceMysnyk/willbe_src/sample$ npm install wLogger
+ wLogger@0.5.172
added 13 packages from 3 contributors, updated 1 package and audited 53 packages in 5.044s
found 0 vulnerabilities

```
  
</details>





Існують три способа запуска тестів з наступними командами

|N п/п      | Спосіб запуску                                              | Команда                                              |
|:----------|:------------------------------------------------------------|:-----------------------------------------------------|
|[1](#1)    | Безпосередньо через npm                                     | `npm test`                                           |
|[2.1](#2.1)| Альтернативний спосіб запуску                               | `wtest proto`                                      |
|[2.2](#2.2)| Альтернативний спосіб запуску використовуючи файл тест сюіта| `wtest proto/dwtools/abase/layer1.test/Map.test.s` |
|[3](#3)    | Використовуючи файл тест сюіта                              | `node proto/dwtools/abase/layer1.test/Map.test.s`  | 