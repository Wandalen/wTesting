# Запуск тестів

Як запускати тестування окремих тест сюітів та тестування скопом.

### Завантаження

Для запуску тестування потрібні готові тест сюіти, котрі можна знайти в модулі [`wTools`](<https://github.com/Wandalen/wTools>). Склонуйте репозиторій модуля виконавши команду `git clone https://github.com/Wandalen/wTools.git`.

<details>
  <summary><u>Структура файлів модуля <code>wTools</code></u></summary>

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

Код включно із тестами знаходиться в директорії `proto`.

Після клонування перейдіть в директорію із модулем та виконайте команду

```
npm install
```

Це встановило залежності модуля.

Виконайте команду `tst scenario:suites.list` щоб отримати інформацію про доступні тест сюіти.

<details>
  <summary><u>Вивід команди <code>tst scenario:suites.list</code></u></summary>

```
[user@user ~]$ tst . scenario:suites.list

/.../wTools/proto/dwtools/abase/l1.test/Array.test.s:19500 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Diagnostics.test.s:309 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Entity.test.s:808 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Map.test.s:4034 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Regexp.test.s:1749 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Routine.test.s:1558 - enabled
/.../wTools/proto/dwtools/abase/l1.test/String.test.s:3887 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Typing.test.s:97 - enabled
/.../wTools/proto/dwtools/abase/l2.test/StringTools.test.s:10462 - enabled
/.../wTools/sample/Sample.test.s:92 - enabled
10 test suites

```

</details>

Згідно виводу модуль `Tools` має 10 тест сюітів. Іншими словами, 10 тест файлів так як під кожен тест сюіт відведено окремий файл. Вісім із них знаходяться в `proto/dwtools/abase/l1.test`, один в `proto/dwtools/abase/l2.test` i один в `sample`.

### Тестування окремого тест сюіта

Здійснити запуск тестування в окремому файлі можна використавши команду `node`, а також, якщо утиліта `Testing` встановлена глобально, командою `tst`. Для запуску тестування після команди вказується абсолютний або відносний шлях до тест сюіта.

<details>
  <summary><u>Вивід команди <code>node proto/dwtools/abase/l1.test/Array.test.s</code></u></summary>

```
[user@user ~]$ node proto/dwtools/abase/l1.test/Array.test.s

Running test suite ( Tools/base/l1/Array ) ..
    at  /.../wTools/proto/dwtools/abase/l1.test/Array.test.s:19500
      
      Passed test routine ( Tools/base/l1/Array / bufferFrom ) in 0.358s
      Passed test routine ( Tools/base/l1/Array / bufferRelen ) in 0.091s
      Passed test routine ( Tools/base/l1/Array / bufferRetype ) in 0.080s
      Passed test routine ( Tools/base/l1/Array / bufferRawFrom ) in 0.118s
      Passed test routine ( Tools/base/l1/Array / bufferBytesFrom ) in 0.104s
      Passed test routine ( Tools/base/l1/Array / bufferNodeFrom ) in 0.180s
      Passed test routine ( Tools/base/l1/Array / bufferRawFromTyped ) in 0.080s
      Passed test routine ( Tools/base/l1/Array / arrayIs ) in 0.109s
      Passed test routine ( Tools/base/l1/Array / longIs ) in 0.122s
      Passed test routine ( Tools/base/l1/Array / constructorLikeArray ) in 0.132s
      Passed test routine ( Tools/base/l1/Array / hasLength ) in 0.092s
      Passed test routine ( Tools/base/l1/Array / argumentsArrayMake ) in 0.246s
      Passed test routine ( Tools/base/l1/Array / argumentsArrayFrom ) in 0.339s
      Passed test routine ( Tools/base/l1/Array / unrollMake ) in 0.411s
      Passed test routine ( Tools/base/l1/Array / unrollFrom ) in 0.417s
      Passed test routine ( Tools/base/l1/Array / longMake ) in 0.739s
      Passed test routine ( Tools/base/l1/Array / longMakeZeroed ) in 0.619s
      Passed test routine ( Tools/base/l1/Array / arrayMake ) in 0.387s
      Passed test routine ( Tools/base/l1/Array / arrayFrom ) in 0.437s
      ...
      Passed test routine ( Tools/base/l1/Array / arraySetContainAny ) in 0.608s
      Passed test routine ( Tools/base/l1/Array / arraySetIdentical ) in 0.422s

    Passed test checks 4293 / 4293
    Passed test cases 1891 / 1891
    Passed test routines 173 / 173
    Test suite ( Tools/base/l1/Array ) ... in 41.251s ... ok
    
    
    
Testing ... in 41.851s ... ok

```

</details>

Виконайте тестування файла `Array.test.s` ввівши команду `node proto/dwtools/abase/l1.test/Array.test.s`. Порівняйте результат тестування з приведеним вище.

Після того, як утиліта запустила тестування у файлі `Array.test.s`, вивід інформував про статус проходження кожної тест рутини. Першою протестовано рутину `bufferFrom` і завершено тестування на рутині `arraySetIdentical`. Для зручності, частина виводу тесту замінена на `...`.

Після прохождення тест сюіту виведено загальний звіт тестування: кількість пройдених тест перевірок, тест кейсів, тест рутин і загальний підсумок. Оскільки всі тест перевірки були пройдені тест сюіт вважається пройденим. На виконання тестування використано 41.251s.

<details>
  <summary><u>Вивід команди <code>tst proto/dwtools/abase/l1.test/Array.test.s</code></u></summary>

```
[user@user ~]$ tst proto/dwtools/abase/l1.test/Array.test.s

Running test suite ( Tools/base/l1/Array ) ..
    at  /.../wTools/proto/dwtools/abase/l1.test/Array.test.s:19500
      
     Passed test routine ( Tools/base/l1/Array / bufferFrom ) in 0.358s
      Passed test routine ( Tools/base/l1/Array / bufferRelen ) in 0.091s
      Passed test routine ( Tools/base/l1/Array / bufferRetype ) in 0.080s
      Passed test routine ( Tools/base/l1/Array / bufferRawFrom ) in 0.118s
      Passed test routine ( Tools/base/l1/Array / bufferBytesFrom ) in 0.104s
      Passed test routine ( Tools/base/l1/Array / bufferNodeFrom ) in 0.180s
      Passed test routine ( Tools/base/l1/Array / bufferRawFromTyped ) in 0.080s
      Passed test routine ( Tools/base/l1/Array / arrayIs ) in 0.109s
      Passed test routine ( Tools/base/l1/Array / longIs ) in 0.122s
      Passed test routine ( Tools/base/l1/Array / constructorLikeArray ) in 0.132s
      Passed test routine ( Tools/base/l1/Array / hasLength ) in 0.092s
      Passed test routine ( Tools/base/l1/Array / argumentsArrayMake ) in 0.246s
      Passed test routine ( Tools/base/l1/Array / argumentsArrayFrom ) in 0.339s
      Passed test routine ( Tools/base/l1/Array / unrollMake ) in 0.411s
      Passed test routine ( Tools/base/l1/Array / unrollFrom ) in 0.417s
      Passed test routine ( Tools/base/l1/Array / longMake ) in 0.739s
      Passed test routine ( Tools/base/l1/Array / longMakeZeroed ) in 0.619s
      Passed test routine ( Tools/base/l1/Array / arrayMake ) in 0.387s
      Passed test routine ( Tools/base/l1/Array / arrayFrom ) in 0.437s
      ...
      Passed test routine ( Tools/base/l1/Array / arraySetContainAny ) in 0.608s
      Passed test routine ( Tools/base/l1/Array / arraySetIdentical ) in 0.422s

    Passed test checks 4293 / 4293
    Passed test cases 1891 / 1891
    Passed test routines 173 / 173
    Test suite ( Tools/base/l1/Array ) ... in 40.622s ... ok
    
    
    
Testing ... in 41.124s ... ok

```

</details>

Другим способом є використання команди `tst`. Введіть команду `tst proto/dwtools/abase/l1.test/Array.test.s` та порівняйте отриманий вивід з попереднім.

Звіт тестування при виконанні тесту повністю співпадає. Незначна похибка в часі проведення тесту визначається потужністю і завантаженістю машини.

### Тестування окремої рутини

Тестування цілого тест сюіту не завжди доцільне - воно займає більше часу і виконує зайву роботу. Якщо код грамотно оформлений, то зміни в окремому модулі не повинні впливати на інші частини коду. Тому, розробник може протестувати внесені зміни використавши окрему рутину тест сюіта.

Для запуску окремої тест рутини виконуються команди `node path/to/testSuite.js routine:someRoutine` або `tst path/to/testSuite.js routine:someRoutine`. Тобто, опцією `routine` можна указати рутину для тестування. Опція `routine` має скорочену форму запису - `r`.

<details>
  <summary><u>Вивід команди <code>node proto/dwtools/abase/l1.test/Array.test.s routine:bufferFrom</code></u></summary>

```
[user@user ~]$ tst proto/dwtools/abase/l1.test/Array.test.s routine:bufferFrom

Running test suite ( Tools/base/l1/Array ) ..
    at  /.../wTools/proto/dwtools/abase/l1.test/Array.test.s:19500
      
      Passed test routine ( Tools/base/l1/Array / bufferFrom ) in 0.220s

    Passed test checks 18 / 18
    Passed test cases 18 / 18
    Passed test routines 1 / 1
    Test suite ( Tools/base/l1/Array ) ... in 3.645s ... ok


  Testing ... in 5.164s ... ok

```

</details>

Проведіть тестування рутини `bufferFrom` в файлі `Array.test.s`. Для запуску тестування введіть команду `node proto/dwtools/abase/l1.test/Array.test.s routine:err`.

Звіт містить результати тестування лише одніє рутини. В тест рутині `bufferFrom` успішно пройдено 18 тест перевірок в 18 кейсах. Загальний підсумок тестування рутини - пройдено.

<details>
  <summary><u>Вивід команди <code>tst proto/dwtools/abase/l1.test/Array.test.s r:arraySetIdentical</code></u></summary>

```
[user@user ~]$ tst proto/dwtools/abase/l1.test/Array.test.s r:arraySetIdentical

Running test suite ( Tools/base/l1/Array ) ..
    at  /.../wTools/proto/dwtools/abase/l1.test/Array.test.s:19500
      
      Passed test routine ( Tools/base/l1/Array / arraySetIdentical ) in 0.532s

    Passed test checks 36 / 36
    Passed test cases 17 / 17
    Passed test routines 1 / 1
    Test suite ( Tools/base/l1/Array ) ... in 3.942s ... ok


  Testing ... in 5.514s ... ok

```

</details>

Проведіть тестування рутини `arraySetIdentical` в файлі `Array.test.s`. Для запуску тестування використайте команду `tst` і скорочену форму запису опції `routine`. Введіть команду `tst proto/dwtools/abase/l1.test/Array.test.s r:assert`. Порівняйте результати виводу.

Тестування пройдено, тестер виконав одну тест рутину `arraySetIdentical` з 17 тест кейсами і 36 перевірками.



### Тестування скопом

Для виконання тестів в групі тестів сюітів потрібно, щоб утиліта `Testing` була встановлена глобально. Щоб запустити тестування скопом після вводу команди `tst` укажіть директорію з тест файлами.

<details>
  <summary><u>Вивід команди <code>tst proto</code></u></summary>

```
[user@user ~]$ tst proto

Running test suite ( Tools/base/l1/Array ) ..
    at  /.../sources/wTools/proto/dwtools/abase/l1.test/Array.test.s:19500

      Passed test routine ( Tools/base/l1/Array / bufferFrom ) in 0.145s
      Passed test routine ( Tools/base/l1/Array / bufferRelen ) in 0.073s
      Passed test routine ( Tools/base/l1/Array / bufferRetype ) in 0.071s
      ...

    Passed test checks 4293 / 4293
    Passed test cases 1891 / 1891
    Passed test routines 173 / 173
    Test suite ( Tools/base/l1/Array ) ... in 44.598s ... ok

    Running test suite ( Tools/base/l1/Diagnostics ) ..
    at  /.../sources/wTools/proto/dwtools/abase/l1.test/Diagnostics.test.s:309

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
    at  /.../sources/wTools/proto/dwtools/abase/l1.test/Entity.test.s:808

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
    at  /.../sources/wTools/proto/dwtools/abase/l1.test/Map.test.s:4034

      Passed test routine ( Tools/base/l1/Map / mapIs ) in 0.062s
      Passed test routine ( Tools/base/l1/Map / mapCloneAssigning ) in 0.081s
      Passed test routine ( Tools/base/l1/Map / mapExtendConditional ) in 0.072s
      ...

    Passed test checks 686 / 686
    Passed test cases 355 / 355
    Passed test routines 45 / 45
    Test suite ( Tools/base/l1/Map ) ... in 6.329s ... ok

    Running test suite ( Tools/base/l1/Regexp ) ..
    at  /.../sources/wTools/proto/dwtools/abase/l1.test/Regexp.test.s:1749

      Passed test routine ( Tools/base/l1/Regexp / regexpIdentical ) in 0.069s
      Passed test routine ( Tools/base/l1/Regexp / regexpsSources ) in 0.143s
      Passed test routine ( Tools/base/l1/Regexp / regexpsJoin ) in 0.103s
      ...

    Passed test checks 237 / 237
    Passed test cases 211 / 211
    Passed test routines 15 / 15
    Test suite ( Tools/base/l1/Regexp ) ... in 2.755s ... ok

    Running test suite ( Tools/base/l1/Routine ) ..
    at  /.../sources/wTools/proto/dwtools/abase/l1.test/Routine.test.s:1558

      Passed test routine ( Tools/base/l1/Routine / _routineJoin ) in 0.084s
      Passed test routine ( Tools/base/l1/Routine / constructorJoin ) in 0.165s
      Passed test routine ( Tools/base/l1/Routine / routineJoin ) in 0.075s
      ...

    Passed test checks 259 / 259
    Passed test cases 71 / 71
    Passed test routines 9 / 9
    Test suite ( Tools/base/l1/Routine ) ... in 2.290s ... ok

    Running test suite ( Tools/base/l1/String ) ..
    at  /.../sources/wTools/proto/dwtools/abase/l1.test/String.test.s:3887

      Passed test routine ( Tools/base/l1/String / strLeft ) in 0.500s
      Passed test routine ( Tools/base/l1/String / strRight ) in 0.552s
      Passed test routine ( Tools/base/l1/String / strEquivalent ) in 0.075s
      ...

    Passed test checks 714 / 714
    Passed test cases 298 / 298
    Passed test routines 19 / 19
    Test suite ( Tools/base/l1/String ) ... in 4.814s ... ok

    Running test suite ( Tools/base/l1/Typing ) ..
    at  /.../sources/wTools/proto/dwtools/abase/l1.test/Typing.test.s:97

      Passed test routine ( Tools/base/l1/Typing / objectLike ) in 0.074s
      Passed test routine ( Tools/base/l1/Typing / promiseIs ) in 0.042s
      Passed test routine ( Tools/base/l1/Typing / consequenceLike ) in 0.041s

    Passed test checks 20 / 20
    Passed test cases 2 / 2
    Passed test routines 3 / 3
    Test suite ( Tools/base/l1/Typing ) ... in 0.756s ... ok

    Running test suite ( Tools/base/l2/String ) ..
    at  /.../sources/wTools/proto/dwtools/abase/l2.test/StringTools.test.s:10462

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

Виконайте тестування в директорії `proto` ввівши команду `tst proto`. В приведеному виводі консолі  частина рядків замінена на `...` для зручності використання.

Утиліта по черзі виконала тестування в файлах згідно списку виданого командою `tst scenario:suites.list`. 

На тестування було використано 75.676s, а остаточний результат тестування - провалене. Чотири тест кейса в файлі `Entyty.test.s` провалили тестування та сформували загальний результат тестування. Навіть при одній проваленій тест перевірці тестування вважалось би проваленим. 

На момент проведення вашого тестування даних помилок може не виникнути.

### Підсумок

- Запуск тестів можливий через команду `tst` або через команду `node`.
- Можливо запускати окремі тест сюіти, окремі тест рутини або всі тест сюіти в директорії.
- Для тестування скопом потрібно щоб утиліту `Testing` було встановлено глобально.
- Інформація щодо провалених тестів допомагає знайти помилки в коді об'єкту тестування.

[Повернутись до змісту](../README.md#Туторіали)
