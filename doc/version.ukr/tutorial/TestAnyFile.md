# Запуск тестування довільного JS-файла

Як запустити тестування в будь-якому JS-файлі користувача. 

### Довільна рутина для тестування. Конфігурація

Для початку тестування потрібно мати наступні складові: 
- код (програму, модуль, тощо), що треба тестувати;
- чим тестувати - утиліту `wTesting`, `тест рутини`, тощо. 

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
    <summary><a href="./tutorial/Criterions.md">Код файла math.js</a></summary>
    
```js    
module.exports.sum = function(a,b){
  return a + b;
}

```
  
</details>

Внесіть приведений вище код для тестування. Це операція додавання двох чисел з назвою `sum`. Для того, щоб рутину можна було протестувати вона повинна бути експортованою.  

<details>
    <summary><a href="./tutorial/Criterions.md">Код файла test.math.js</a></summary>
    
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

function sum1(test)
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

function sum2(test)
{
  test.case = 'sum integers2';
  test.will = 'sum3';
  var got = math.sum( 1, 2);
  var expected =  3 ;
  test.identical( got,expected );

  test.will = 'sum4';
  var got = math.sum( 1, 2);
  var expected =  2 ;
  test.notIdentical( got,expected );
}

var Self =
{
  name : 'Sample',
  silencing : 1,

  tests :
  {
    sum1 : sum1,
    sum2 : sum2,
  }
}

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