# Запуск тестів

Як запускати тестування.

### Конфігурація

Ви вже [встановили](Installing.md) утиліту `wTesting` і тому можете приступити до дослідження її функцій. 

Першим кроком дослідіть як утиліта виконує тестування на готовому прикладі. Для цього використайте репозиторій утиліти [`wTools`](<https://github.com/Wandalen/wTools>).

<details>
  <summary><u>Структура файлів утиліти <code>wTools</code></u></summary>

```
wTools
   ├── .git
   ├── doc
   ├── out
   ├── proto
   ├── sample
   ├── ...
   └── package.json

```

</details>

Склонуйте репозиторій виконавши команду `git clone https://github.com/Wandalen/wTools.git`. Після клонування перейдіть в директорію утиліти (`cd wTools/`). 

Утиліта має залежності необхідні для її функціонування. Встановіть їх виконавши команду `npm install`.


<details>
  <summary><u>Вивід команди <code>wtest scenario:help</code></u></summary>

```
[user@user ~]$ wtest scenario:help
Scenarios :
  test : run tests, default scenario 
  help : get help 
  options.list : list available options 
  scenarios.list : list available scenarios 
  suites.list : list available suites 

Tester options
  scenario : Name of scenario to launch. To get scenarios list use scenario : "scenarios.list". Try: "node Some.test.js scenario:scenarios.list" 
  sanitareTime : Delay between runs of test suites and after the last to get sure nothing throwen asynchronously later. 
  fails : Maximum number of fails allowed before shutting down testing. 
  beeping : Make diagnosticBeep sound after testing to let developer know it's done. 
  coloring : Switch on/off coloring. 
  timing : Switch on/off measuing of time. 
  rapidity : How rapid teststing should be done. Increasing of the option decrase number of test routine to be executed. For rigorous testing 0 or 1 should be used. 5 for the fastest. Default is 3. 
  routineTimeOut : Limits the time that each test routine can use. If execution of routine takes too long time then fail will be reaported and error throwen. Default is 5000 ms. 
  concurrent : Runs test suite in parallel with other test suites. 
  verbosity : Level of details of report. Zero for nothing, one for single line report, nine for maximum verbosity. Default is 5. Short-cut: "v". Try: "node Some.test.js v:2" 
  importanceOfNegative : Increase verbosity of test checks which fails. It helps to see only fails and hide passes. Default is 9. Short-cut: "n". 
  silencing : Hooking and silencing of object's of testing console output to make clean report of testing. 
  shoulding : Switch on/off all should* tests checks. 
  accuracy : Change default accuracy. Each test routine could have own accuracy, which cant be overwritten by this option.

```

</details>

Загальну довідку по використанню утиліти можна отримати виконавши команду `wtest scenario:help`. Введіть її та порівняйте вивід з приведеним вище.

На даний момент необхідно дізнатись про доступні файли для виконання. 

<details>
  <summary><u>Вивід команди <code>wtest scenario:suites.list</code></u></summary>

```
[user@user ~]$ wtest scenario:suites.list

/path_to_utility/wTools/proto/dwtools/abase/l1.test/Array.test.s:19500 - enabled
/path_to_utility/wTools/proto/dwtools/abase/l1.test/Diagnostics.test.s:309 - enabled
/path_to_utility/wTools/proto/dwtools/abase/l1.test/Entity.test.s:808 - enabled
/path_to_utility/wTools/proto/dwtools/abase/l1.test/Map.test.s:4034 - enabled
/path_to_utility/wTools/proto/dwtools/abase/l1.test/Regexp.test.s:1749 - enabled
/path_to_utility/wTools/proto/dwtools/abase/l1.test/Routine.test.s:1558 - enabled
/path_to_utility/wTools/proto/dwtools/abase/l1.test/String.test.s:3887 - enabled
/path_to_utility/wTools/proto/dwtools/abase/l1.test/Typing.test.s:97 - enabled
/path_to_utility/wTools/proto/dwtools/abase/l2.test/StringTools.test.s:10462 - enabled
/path_to_utility/wTools/sample/Sample.test.s:92 - enabled
10 test suites

```

</details>

Виконайте команду `wtest scenario:suites.list` щоб отримати інформацію про доступні тести. Порівняйте з приведеним виводом.

Згідно виводу утиліта має 10 тест сюітів. Іншими словами, 10 тест файлів так як в кожному файлі знаходиться один тест сюіт. Девять із них знаходяться в директорії `proto` i один в `sample`.

Вивід показує повний шлях до файлу, його назву та кількість рядків. Наприклад, починаючи від директорії `wTools`, відносний шлях до файла `Array.test.s` виглядає `./proto/dwtools/abase/l1.test/`. Вказаний тест файл містить 19500 рядків.

### Проведення тестування

Запуск тестів можливий з використанням утиліти `wTesting`, котра встановлена глобально в системі, а також, напряму - використовуючи NodeJS. При використанні NodeJS утиліта `wTesting` являється локальною залежністю.

Перевагою глобального встановлення утиліти є можливість використання довідки тестування, [додаткових опцій тестування](TestOptions.md), а також, групового тестування.

##### Групове тестування

Для проведення групового тестування використовується команда `wtest` в аргумент якої передається назва директорії з тестами.

<details>
  <summary><u>Вивід команди <code>wtest proto</code></u></summary>

```
[user@user ~]$ wtest proto

Running test suite ( Tools/base/l1/Array ) ..
    at  /path_to_utility/sources/wTools/proto/dwtools/abase/l1.test/Array.test.s:19500
      
      Passed test routine ( Tools/base/l1/Array / bufferFrom ) in 0.145s
      Passed test routine ( Tools/base/l1/Array / bufferRelen ) in 0.073s
      Passed test routine ( Tools/base/l1/Array / bufferRetype ) in 0.071s
      ...

    Passed test checks 4293 / 4293
    Passed test cases 1891 / 1891
    Passed test routines 173 / 173
    Test suite ( Tools/base/l1/Array ) ... in 44.598s ... ok

    Running test suite ( Tools/base/l1/Diagnostics ) ..
    at  /path_to_utility/sources/wTools/proto/dwtools/abase/l1.test/Diagnostics.test.s:309
      
      Passed test routine ( Tools/base/l1/Diagnostics / _err ) in 0.174s
      Passed test routine ( Tools/base/l1/Diagnostics / err ) in 0.061s
      Passed test routine ( Tools/base/l1/Diagnostics / errLog ) in 0.054s
      Passed test routine ( Tools/base/l1/Diagnostics / assert ) in 0.041s
      Passed test routine ( Tools/base/l1/Diagnostics / diagnosticStack ) in 0.048s

    Passed test checks 34 / 34
    Passed test cases 30 / 30
    Passed test routines 5 / 5
    Test suite ( Tools/base/l1/Diagnostics ) ... in 1.030s ... ok

    Running test suite ( Tools/base/l1/Entity ) ..
    at  /path_to_utility/sources/wTools/proto/dwtools/abase/l1.test/Entity.test.s:808
      
      Passed test routine ( Tools/base/l1/Entity / eachSample ) in 0.070s
      Passed test routine ( Tools/base/l1/Entity / entityMap ) in 0.094s
      Passed test routine ( Tools/base/l1/Entity / entityFilter ) in 0.073s
      ...
        Test check ( Tools/base/l1/Entity / entitySize / atomic type # 2 ) ... failed
        Test check ( Tools/base/l1/Entity / entitySize / arraylike # 4 ) ... failed
        Test check ( Tools/base/l1/Entity / entitySize / object # 5 ) ... failed
        Test check ( Tools/base/l1/Entity / entitySize / empty call # 6 ) ... failed
      Failed test routine ( Tools/base/l1/Entity / entitySize ) in 0.120s

    Passed test checks 80 / 84
    Passed test cases 76 / 80
    Passed test routines 9 / 10
    Test suite ( Tools/base/l1/Entity ) ... in 1.089s ... failed

    Running test suite ( Tools/base/l1/Map ) ..
    at  /path_to_utility/sources/wTools/proto/dwtools/abase/l1.test/Map.test.s:4034
      
      Passed test routine ( Tools/base/l1/Map / mapIs ) in 0.062s
      Passed test routine ( Tools/base/l1/Map / mapCloneAssigning ) in 0.081s
      Passed test routine ( Tools/base/l1/Map / mapExtendConditional ) in 0.072s
      ...
      
    Passed test checks 686 / 686
    Passed test cases 355 / 355
    Passed test routines 45 / 45
    Test suite ( Tools/base/l1/Map ) ... in 6.329s ... ok

    Running test suite ( Tools/base/l1/Regexp ) ..
    at  /path_to_utility/sources/wTools/proto/dwtools/abase/l1.test/Regexp.test.s:1749
      
      Passed test routine ( Tools/base/l1/Regexp / regexpIdentical ) in 0.069s
      Passed test routine ( Tools/base/l1/Regexp / regexpsSources ) in 0.143s
      Passed test routine ( Tools/base/l1/Regexp / regexpsJoin ) in 0.103s
      ...

    Passed test checks 237 / 237
    Passed test cases 211 / 211
    Passed test routines 15 / 15
    Test suite ( Tools/base/l1/Regexp ) ... in 2.755s ... ok

    Running test suite ( Tools/base/l1/Routine ) ..
    at  /path_to_utility/sources/wTools/proto/dwtools/abase/l1.test/Routine.test.s:1558
      
      Passed test routine ( Tools/base/l1/Routine / _routineJoin ) in 0.084s
      Passed test routine ( Tools/base/l1/Routine / constructorJoin ) in 0.165s
      Passed test routine ( Tools/base/l1/Routine / routineJoin ) in 0.075s
      ...

    Passed test checks 259 / 259
    Passed test cases 71 / 71
    Passed test routines 9 / 9
    Test suite ( Tools/base/l1/Routine ) ... in 2.290s ... ok

    Running test suite ( Tools/base/l1/String ) ..
    at  /path_to_utility/sources/wTools/proto/dwtools/abase/l1.test/String.test.s:3887
      
      Passed test routine ( Tools/base/l1/String / strLeft ) in 0.500s
      Passed test routine ( Tools/base/l1/String / strRight ) in 0.552s
      Passed test routine ( Tools/base/l1/String / strEquivalent ) in 0.075s
      ...

    Passed test checks 714 / 714
    Passed test cases 298 / 298
    Passed test routines 19 / 19
    Test suite ( Tools/base/l1/String ) ... in 4.814s ... ok

    Running test suite ( Tools/base/l1/Typing ) ..
    at  /path_to_utility/sources/wTools/proto/dwtools/abase/l1.test/Typing.test.s:97
      
      Passed test routine ( Tools/base/l1/Typing / objectLike ) in 0.074s
      Passed test routine ( Tools/base/l1/Typing / promiseIs ) in 0.042s
      Passed test routine ( Tools/base/l1/Typing / consequenceLike ) in 0.041s

    Passed test checks 20 / 20
    Passed test cases 2 / 2
    Passed test routines 3 / 3
    Test suite ( Tools/base/l1/Typing ) ... in 0.756s ... ok

    Running test suite ( Tools/base/l2/String ) ..
    at  /path_to_utility/sources/wTools/proto/dwtools/abase/l2.test/StringTools.test.s:10462
      
      Passed test routine ( Tools/base/l2/String / strRemoveBegin ) in 0.216s
      Passed test routine ( Tools/base/l2/String / strRemoveEnd ) in 0.226s
      Passed test routine ( Tools/base/l2/String / strRemove ) in 0.204s
      ...

    Passed test checks 1311 / 1311
    Passed test cases 930 / 930
    Passed test routines 40 / 40
    Test suite ( Tools/base/l2/String ) ... in 10.201s ... ok



  Testing ... in 75.676s ... failed

```

</details>

Запустіть тестування в директорії `proto` виконавши команду `wtest proto`. В приведеному вище виводі консолі частина рядків замінена на `...` для зменшення об'єму. 

Утиліта по черзі виконала тестування в файлах згідно списку виданого командою `wtest scenario:suites.list`. На тестування було використано 75.676s, результат тестування - провалене. Чотири тест кейса в файлі `Entyty.test.s`, що пройшли тестування з помилкою, сформували загальний результат тестування. Навіть при одній проваленій тест перевірці тестування вважалось би проваленим. Інформативний вивід дає розробнику інформацію про ті функціональності які потрібно виправити.

На момент проведення вашого тестування даних помилок може не виникнути.

##### Тестування окремого тест сюіта

Для проведення тестування окремого файла використовуються команди `wtest` i `node`. Аргументом команди передається повний відносний шлях до тест файла.

<details>
  <summary><u>Вивід команди <code>wtest proto</code></u></summary>

```
[user@user ~]$ wtest proto

Running test suite ( Tools/base/l1/Array ) ..
    at  /path_to_utility/sources/wTools/proto/dwtools/abase/l1.test/Diagnostics.test.s:309
      
      Passed test routine ( Tools/base/l1/Diagnostics / _err ) in 0.133s
      Passed test routine ( Tools/base/l1/Diagnostics / err ) in 0.075s
      Passed test routine ( Tools/base/l1/Diagnostics / errLog ) in 0.071s
      Passed test routine ( Tools/base/l1/Diagnostics / assert ) in 0.060s
      Passed test routine ( Tools/base/l1/Diagnostics / diagnosticStack ) in 0.053s

    Passed test checks 34 / 34
    Passed test cases 30 / 30
    Passed test routines 5 / 5
    Test suite ( Tools/base/l1/Diagnostics ) ... in 1.088s ... ok


  Testing ... in 1.679s ... ok

```

</details>

Використайте тест файл `Diagnostics.test.s`. Для запуску тестування введіть команду `wtest proto/dwtools/abase/l1.test/Diagnostics.test.s`