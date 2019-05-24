# Контроль рівня вербальності

Зміна кількості виведеної інформації опцією verbosity.

При проведенні тестування великого об'єму коду, детальний звіт може ускладнити пошук необхідної інформації. І, навпаки, при проведенні тестування в окремих тест рутинах може бути недостатньо інформації в короткому звіті. Тому, утиліта може регулювати кількість виведеної інформації про результати тестування. Для цього використовується опція `verbosity`.

Опція `verbosity` приймає значення від "0" до "9". Значення "0" відповідає найнижчому рівню і не виводить інформації про тестування. Значення "9", відповідно, відповідає найвищому рівню вербальності і виводить максимум інформації про результати тестування.

### Об'єкт тестування і тестовий файл

Використайте тестовий модуль з [туторіалу про створення тест файлу](HelloWorld.md). Якщо ви не маєте файлів, завантажте їх за [посиланням](https://github.com/Wandalen/wTesting/tree/master/sample/helloWorld).
Для завершення підготовки виконайте встановлення залежностей `NodeJS`. Для цього відкрийте директорію з файлами в терміналі та введіть `npm install`. Після встановлення залежностей модуль готовий до тестування.

### Тестування з різними рівнями вербальності

Для використання параметру `verbosity` його потрібно указати після назви тесту, директорії або рутини. Опція має скорочену форму запису - `v`.

При значенні "0" утиліта не виводить жодного рядка тому, застосування його недоцільне. Введіть команду 
```
wtest Join.test.js verbosity:1
```
Порівняйте результат виводу з приведеним.

<details>
  <summary><u>Вивід команди <code>wtest Join.test.js verbosity:1</code></u></summary>

```
[user@user ~]$ wtest Join.test.js verbosity:1

  Testing ... in 0.278s ... failed

```

</details>

При значенні `verbosity:1` в консоль виведено один рядок з підсумком проходження тесту. Якщо утиліта тестувала б групу тест сюітів в директорії, то вивід містив би підсумок тестування на основі результатів по кожному з них.

<details>
  <summary><u>Вивід команди <code>wtest Join.test.js v:4</code></u></summary>

```
[user@user ~]$ wtest Join.test.js v:4

  Includes tests from : /.../testCreation/Join.test.js

  Launching several ( 1 ) test suites ..

    Running test suite ( Join ) ..
    at  /.../testCreation/Join.test.js:39

      Passed test routine ( Join / routine1 ) in 0.056s
        Test check ( Join / routine2 / fail # 2 ) ... failed
      Failed test routine ( Join / routine2 ) in 0.074s

    Passed test checks 2 / 3
    Passed test cases 1 / 2
    Passed test routines 1 / 2
    Test suite ( Join ) ... in 0.252s ... failed



  ExitCode : -1
  Passed test checks 2 / 3
  Passed test cases 1 / 2
  Passed test routines 1 / 2
  Passed test suites 0 / 1
  Testing ... in 0.344s ... failed

```

</details>

Підвищіть рівень вербальності до "4". Для цього виконайте команду `wtest Join.test.js v:4` зі скороченою формою запису опції. Порівняйте з виводом приведеним вище.

В консолі виводиться інформація про проходження тесту рутиною `routine1` та провал тесту в рутині `routine2`. Також, указано, що тест перевірка тест кейсу `fail` другої тест рутини провалена. Вивід містить звіт по тест сюіту і загальний звіт. Загальний звіт повторює звіт по тест сюіту `Join` тому, що тестувався тільки один файл.

Цієї інформації достатньо при виконанні значного об'єму тестів.


<details>
  <summary><u>Вивід команди <code>wtest Join.test.js verbosity:6</code></u></summary>

```
[user@user ~]$ wtest Join.test.js verbosity:6
Includes tests from : /.../testCreation/Join.test.js

Tester Settings :
{
  scenario : test,
  sanitareTime : 500,
  fails : null,
  beeping : true,
  coloring : 1,
  timing : 1,
  rapidity : 3,
  routine : null,
  importanceOfNegative : null,
  routineTimeOut : null,
  concurrent : null,
  verbosity : 6,
  silencing : null,
  shoulding : null,
  accuracy : null
}

  Launching several ( 1 ) test suites ..
  /.../testCreation/Join.test.js:39 - enabled
  1 test suite

    Running test suite ( Join ) ..
    at  /.../testCreation/Join.test.js:39

      Running test routine ( routine1 ) ..


        /.../testCreation/Join.test.js:9
            5 : //
            6 :
            7 : function routine1( test )
            8 : {
            9 :   test.identical( Join.join( 'Hello ', 'world!' ), 'Hello world!' );  
        Test check ( Join / routine1 /  # 1 ) ... ok

      Passed test routine ( Join / routine1 ) in 0.091s
      Running test routine ( routine2 ) ..


        /.../testCreation/Join.test.js:18
            14 : function routine2( test )
            15 : {
            16 :
            17 :   test.case = 'pass';
            18 :   test.identical( Join.join( 1, 3 ), '13' );  
        Test check ( Join / routine2 / pass # 1 ) ... ok


        - got :
          '13'
        - expected :
          13
        - difference :
          *

        /.../testCreation/Join.test.js:21
            17 :   test.case = 'pass';
            18 :   test.identical( Join.join( 1, 3 ), '13' );
            19 :
            20 :   test.case = 'fail';
            21 :   test.identical( Join.join( 1, 3 ), 13 );  
        Test check ( Join / routine2 / fail # 2 ) ... failed

      Failed test routine ( Join / routine2 ) in 0.098s

    Passed test checks 2 / 3
    Passed test cases 1 / 2
    Passed test routines 1 / 2
    Test suite ( Join ) ... in 0.294s ... failed



  ExitCode : -1
  Passed test checks 2 / 3
  Passed test cases 1 / 2
  Passed test routines 1 / 2
  Passed test suites 0 / 1
  Testing ... in 0.389s ... failed


```

</details>

Введіть команду `wtest Join.test.js verbosity:6`. Перегляньте вивід та порівняйте з приведеним.

З рівнем вербальності "6" утиліта виводить секцію з налаштуваннями тестера (опції тестування) і звіт щодо окремих тест перевірок. 

На початку виводу вказуються всі встановлені [опції тестування](Help.md#Опції-запуску-та-опції-сюіта). Оскільки в тест сюіті не вказано опцій тестування, а в команді лише опція `verbosity`, то всі інші опції мають налаштування за замовчуванням.

Звіт по тест перевіркам зі статусом `ok` включає:
- шлях до тест файлу;
- номер рядка з тест перевіркою; 
- код тест сюіта з тест перевіркою;
- результат проходження.

Звіт по тест перевіркам зі статусом `failed` додатково містить секцію з указанням помилки. Наприклад, в приведеному звіті це секція 

```
        - got :
          '13'
        - expected :
          13
        - difference :
          *
```
яка вказує на різницю між отриманим і очікуваним значенням.

<details>
  <summary><u>Вивід команди <code>wtest Join.test.js routine:routine2 v:9</code></u></summary>

```
[user@user ~]$ wtest Join.test.js routine:routine2 v:9
Includes tests from : /.../testCreation/Join.test.js

Tester Settings :
{
  scenario : test,
  sanitareTime : 500,
  fails : null,
  beeping : true,
  coloring : 1,
  timing : 1,
  rapidity : 3,
  routine : routine2,
  importanceOfNegative : null,
  routineTimeOut : null,
  concurrent : null,
  verbosity : 9,
  silencing : null,
  shoulding : null,
  accuracy : null
}

  Launching several ( 1 ) test suites ..
  /.../testCreation/Join.test.js:39 - enabled
  1 test suite

    Running test suite ( Join ) ..
    at  /.../testCreation/Join.test.js:39

    wTestSuite( Join#in0 )
    {
      name : 'Join',
      verbosity : 8,
      importanceOfDetails : 0,
      importanceOfNegative : 1,
      silencing : null,
      shoulding : 1,
      routineTimeOut : 5000,
      concurrent : 0,
      routine : 'routine2',
      platforms : null,
      suiteFilePath : [ '/path_to_' ... 'reation/Join.test.js' ],
      suiteFileLocation : [ '/path_to_' ... 'tion/Join.test.js:39' ],
      tests : [ Map:Pure with 2 elements ],
      abstract : 0,
      enabled : 1,
      takingIntoAccount : 1,
      usingSourceCode : 1,
      ignoringTesterOptions : 0,
      accuracy : 1e-7,
      report : [ Map:Pure with 9 elements ],
      debug : 0,
      override : [ Map:Pure with 0 elements ],
      _routineCon : [ routine bound anonymous ],
      _inroutineCon : [ routine bound anonymous ],
      onRoutineBegin : [ routine onRoutineBegin ],
      onRoutineEnd : [ routine onRoutineEnd ],
      onSuiteBegin : [ routine onSuiteBegin ],
      onSuiteEnd : [ routine onSuiteEnd ]
    }
      Running test routine ( routine1 ) ..

          
        /.../testCreation/Join.test.js:9
            5 : //
            6 : 
            7 : function routine1( test )
            8 : {
            9 :   test.identical( Join.join( 'Hello ', 'world!' ), 'Hello world!' );  
        Test check ( Join / routine1 /  # 1 ) ... ok

      Passed test routine ( Join / routine1 ) in 0.066s
      Running test routine ( routine2 ) ..


        /.../testCreation/Join.test.js:18
            14 : function routine2( test )
            15 : {
            16 :
            17 :   test.case = 'pass';
            18 :   test.identical( Join.join( 1, 3 ), '13' );  
        Test check ( Join / routine2 / pass # 1 ) ... ok


        - got :
          '13'
        - expected :
          13
        - difference :
          *

        /.../testCreation/Join.test.js:21
            17 :   test.case = 'pass';
            18 :   test.identical( Join.join( 1, 3 ), '13' );
            19 :
            20 :   test.case = 'fail';
            21 :   test.identical( Join.join( 1, 3 ), 13 );  
        Test check ( Join / routine2 / fail # 2 ) ... failed

      Failed test routine ( Join / routine2 ) in 0.147s

    Passed test checks 1 / 2
    Passed test cases 1 / 2
    Passed test routines 0 / 1
    Test suite ( Join ) ... in 0.226s ... failed



  ExitCode : -1
  Passed test checks 1 / 2
  Passed test cases 1 / 2
  Passed test routines 0 / 1
  Passed test suites 0 / 1
  Testing ... in 0.323s ... failed

```

</details>

Протестуйте рутину `routine2` з найвищим рівнем вербальності. Використайте команду `wtest Join.test.js routine:routine2 v:9`.

Вивід тестування найбільш повний. Він включає загальну інформацію по опціям тестування та додаткову інформацію по налаштуванням тест сюіту `Join`. Вивід консолі про результати тестування допоможе розробнику знайти і усунути помилку.

### Елементи звіту, що виводятся при зміні вербальності

| Рівень вербальності                       | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
|-------------------------------------------|---|---|---|---|---|---|---|---|---|---|
| Загальний підсумок тестування             | - | + | + | + | + | + | + | + | + | + |
| Детальний підсумок тестування             | - | - | + | + | + | + | + | + | + | + |
| Загальний підсумок проходження тест сюіта | - | - | + | + | + | + | + | + | + | + |
| Детальний підсумок проходження тест сюіта | - | - | - | + | + | + | + | + | + | + |
| Успішно пройдені тест рутини              | - | - | - | - | + | + | + | + | + | + |
| Провалені тест рутини                     | - | - | - | + | + | + | + | + | + | + |
| Успішно пройдені тест перевірки           | - | - | - | - | - | + | + | + | + | + |
| Провалені тест перевірки                  | - | - | - | - | + | + | + | + | + | + |
| Опції тестування                          | - | - | - | - | - | + | + | + | + | + |
| Помилка тест перевірки, різниця між отриманим і очікуваним значенням                                                                           | - | - | - | - | - | + | + | + | + | + |
| Код успішно пройденої тест перевірки      | - | - | - | - | - | - | + | + | + | + |
| Код проваленої тест перевірки             | - | - | - | - | - | + | + | + | + | + |
| Шлях до файла та номер рядка успішно пройденої тест перевірки                                                                                   | - | - | - | - | - | - | + | + | + | + |
| Шлях до файла та номер рядка проваленої тест перевірки                                                                                         | - | - | - | - | - | + | + | + | + | + |
| Опції і налаштування тест сюіта           | - | - | - | - | - | - | - | + | + | + |
| Вивід в консоль об'єкта тестування або тест сюіта [[1]](#1) (маркується іншим кольором)                                                         | - | - | - | - | - | - | - | + | + | + |

<a name="1">[1]</a> Щодо виводу в консоль об'єкта тестування можна дізнатись в туторіалі про [фільтрування звіту від сторонніх включень](OptionSilencing.md).

### Підсумок

- Для встановлення рівня вербальності звіту тестування використовується опція `verbosity`.
- Опція приймає значення від `0` до `9`.
- При значенні `0` не виводиться жодного рядка.
- Для тествування значного об'єму коду використовуйте значення опції, які нижче 4.
- При використанні значень від `5` і більше, утиліта виводить детальний звіт.
- При значеннях від `7` до `9` виводиться максимум інформації.
