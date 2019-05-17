# Контроль рівня вербальності

Зміна кількості виведеної інформації опцією <code>verbosity</code>.

При проведенні тестування великого об'єму коду, детальна інформація про виконання тесту ускладнює роботу з тестами і пошуком несправностей. І, навпаки, при проведенні тестування в окремих тест рутинах може бути недостатньо інформації в короткому виводі. Тому, утиліта може регулювати кількість інформації про результати тестування. Для цього використовується параметр `verbosity`.

Параметр `verbosity` приймає значення від "0" до "9". Значення "0" відповідає найнижчому рівню і не виводить інформації про тестування. Значення "9", відповідно, відповідає найвищому рівню вербальності і виводить максимум інформації про результати тестування.

### Конфігурація

Використайте конфігурацію з [туторіалу](HelloWorld.md). Якщо ви не маєте файлів, завантажте їх за [посиланням](https://github.com/Wandalen/wTesting/tree/master/sample/helloWorld).
Для завершення підготовки виконайте встановлення залежностей `NodeJS`. Для цього відкрийте директорію з файлами в терміналі та введіть `npm install`. Після встановлення залежностей модуль готовий до тестування.

### Тестування з різними рівнями вербальності

Для використання параметру `verbosity` його потрібно указати після назви тесту, директорії або рутини. Параметр має скорочену форму запису - `v`.

<details>
  <summary><u>Вивід команди <code>wtest Join.test.js verbosity:1</code></u></summary>

```
[user@user ~]$ wtest Join.test.js verbosity:1

  Testing ... in 0.278s ... failed

```

</details>

Введіть команду `wtest Join.test.js verbosity:1`. Порівняйте результат виводу з приведеним вище.

При значенні "0" утиліта не виводить жодного рядка тому, застосування його недоцільне. А при значенні `verbosity:1` в консоль виведено один рядок з підсумком проходження тесту.

<details>
  <summary><u>Вивід команди <code>wtest Join.test.js v:4</code></u></summary>

```
[user@user ~]$ wtest Join.test.js v:4

  Includes tests from : /path_to_module/testCreation/Join.test.js

  Launching several ( 1 ) test suites ..

    Running test suite ( Join ) ..
    at  /path_to_module/testCreation/Join.test.js:39

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

Підвищіть рівень вербальності до "4". Для цього виконайте команду `wtest Join.test.js v:4` зі скороченою формою запису параметра. Порівняйте з виводом приведеним вище.

В консолі виводиться інформація про проходження тесту рутиною `routine1` та провал тесту в рутині `routine2`. Також, виводиться інформація про помилки в тест перевірці кейсу другої тест рутини, а також, підсумок тестування. Цієї інформації достатньо при виконанні значного об'єму тестів.


<details>
  <summary><u>Вивід команди <code>wtest Join.test.js verbosity:6</code></u></summary>

```
[user@user ~]$ wtest Join.test.js verbosity:6
Includes tests from : /path_to_module/testCreation/Join.test.js

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
  /path_to_module/testCreation/Join.test.js:39 - enabled
  1 test suite

    Running test suite ( Join ) ..
    at  /path_to_module/testCreation/Join.test.js:39

      Running test routine ( routine1 ) ..


        /path_to_module/testCreation/Join.test.js:9
            5 : //
            6 :
            7 : function routine1( test )
            8 : {
            9 :   test.identical( Join.join( 'Hello ', 'world!' ), 'Hello world!' );  
        Test check ( Join / routine1 /  # 1 ) ... ok

      Passed test routine ( Join / routine1 ) in 0.091s
      Running test routine ( routine2 ) ..


        /path_to_module/testCreation/Join.test.js:18
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

        /path_to_module/testCreation/Join.test.js:21
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

З рівнем вербальності "6" утиліта виводить інформацію, якої достатньо для дослідження окремих тест перевірок коду.

На початку виводу вказуються всі встановлені [опції тестування](TestOptions.md) після чого виводиться інформація про тестування окремих рутин. Вивід включає код тест файла, що спрощує роботу по аналізу помилок.

<details>
  <summary><u>Вивід команди <code>wtest Join.test.js routine:routine2 v:9</code></u></summary>

```
[user@user ~]$ wtest Join.test.js routine:routine2 v:9
Includes tests from : /path_to_module/testCreation/Join.test.js

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
  /path_to_module/testCreation/Join.test.js:39 - enabled
  1 test suite

    Running test suite ( Join ) ..
    at  /path_to_module/testCreation/Join.test.js:39

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
      Running test routine ( routine2 ) ..


        /path_to_module/testCreation/Join.test.js:18
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

        /path_to_module/testCreation/Join.test.js:21
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

### Підсумок

- Для встановлення кількості виведеної інформації про результати тестування використовується параметр `verbosity`.
- Параметр приймає значення від "0" до "9".
- При значенні "0" не виводиться жодного рядка - застосування недоцільне.
- Для тествування значного об'єму коду використовуйте значення параметра, які нижче 4.
- Використання значень параметра `verbosity`, починаючи від "5" і більше, доцільні для тестування невеликого об'єму коду.
- При значеннях `verbosity` більше "6" виводиться інформація про опції тестування. Ця інформація корисна для налаштування тесту.
