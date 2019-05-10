# Умови проходження тестування

Як задати умови проходження тестових перевірок певної функціональності.

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
  test.case = 'single zero';
  test.will = 'sum1';
  var got = math.sum( 1, 2);
  var expected =  2 ;
  test.ni( got,expected );
}

var Self =
{
  name : 'Sample/Trivial',
  silencing : 1,

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
Указаний тест складається з п'яти головних частин.
- ініціалізація утиліти `wTools` і модулів для проведення тестування; 
- позначення глобальних змінних тест-сюіта;
- тест-рутини;
- встановлення об'єкту тестування - тест сюіта з набором тест рутин;
- ініціалізатор запуску тестування.

### Ініціалізація модулів для тестування

Для того, щоб утиліта `wTestesting` змогла провести тестування рутини вона має бути підключеною в тест-файлі. Це здійснюється з допомогою привдеденого нижче коду:
    
```js    
if( typeof module !== 'undefined' )
{
  let _ = require( 'wTools' );

  if( typeof _realGlobal_ === 'undefined' || !_realGlobal_.wTester || !_realGlobal_.wTester._isReal_ )

  _.include( 'wLogger' );
  _.include( 'wTesting' );
}

```

Таким чином, для проведення тестування необхідно мати