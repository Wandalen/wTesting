# Запуск тестів

Як запускати тестування окремих тест сюітів та тестування скопом.

### Завантаження

В модулі [`wTools`](<https://github.com/Wandalen/wTools>) є готові тест сюіти. Використайте їх щоб побачити як працює фреймворк для тестування. Склонуйте репозиторій модуля виконавши команду `git clone https://github.com/Wandalen/wTools.git`.

Код цього модуля включно із тестами знаходиться в директорії `proto`.

Після клонування перейдіть в директорію із модулем та виконайте команду

```
npm install
```

Це встановило залежності модуля.

Виконайте команду

```
tst .suites.list
```

щоб отримати інформацію про доступні тест сюіти.

<details>
  <summary><u>Вивід команди <code>tst .suites.list</code></u></summary>

```
$ tst .suites.list

/.../wTools/proto/wtools/abase/l1.test/Diagnostics.test.s:309 - enabled
/.../wTools/proto/wtools/abase/l1.test/Entity.test.s:808 - enabled
/.../wTools/proto/wtools/abase/l1.test/Long.test.s:19500 - enabled
/.../wTools/proto/wtools/abase/l1.test/Map.test.s:4034 - enabled
/.../wTools/proto/wtools/abase/l1.test/Regexp.test.s:1749 - enabled
/.../wTools/proto/wtools/abase/l1.test/Routine.test.s:1558 - enabled
/.../wTools/proto/wtools/abase/l1.test/String.test.s:3887 - enabled
/.../wTools/proto/wtools/abase/l1.test/Typing.test.s:97 - enabled
/.../wTools/proto/wtools/abase/l2.test/StringTools.test.s:10462 - enabled
/.../wTools/sample/Sample.test.s:92 - enabled
10 test suites
```

</details>

Згідно виводу модуль `Tools` має 10 тест сюітів. Іншими словами, 10 тест файлів, так як під кожен тест сюіт відведено окремий файл. Вісім із них знаходяться в `proto/wtools/abase/l1.test`, один в `proto/wtools/abase/l2.test` i один в `sample`.

### Тестування окремого тест сюіта

Виконати тестування можливо запустивши файл із тест сюітом інтерпретатором `NodeJS`.

Введіть команду:

```
node proto/wtools/abase/l1.test/Long.test.s
```

В результаті виконання буде виконано тестування і виведено звіт.

<details>
  <summary><u>Вивід команди <code>node proto/wtools/abase/l1.test/Long.test.s</code></u></summary>

```
$ node proto/wtools/abase/l1.test/Long.test.s

Running test suite ( Tools/base/l1/Long ) ..
    at  /.../wTools/proto/wtools/abase/l1.test/Long.test.s:19500

      Passed test routine ( Tools/base/l1/Long / bufferFrom ) in 0.358s
      Passed test routine ( Tools/base/l1/Long / bufferRelen ) in 0.091s
      Passed test routine ( Tools/base/l1/Long / bufferRetype ) in 0.080s
      Passed test routine ( Tools/base/l1/Long / bufferRawFrom ) in 0.118s
      Passed test routine ( Tools/base/l1/Long / bufferBytesFrom ) in 0.104s
      Passed test routine ( Tools/base/l1/Long / bufferNodeFrom ) in 0.180s
      Passed test routine ( Tools/base/l1/Long / bufferRawFromTyped ) in 0.080s
      Passed test routine ( Tools/base/l1/Long / arrayIs ) in 0.109s
      Passed test routine ( Tools/base/l1/Long / longIs ) in 0.122s
      ...
      Passed test routine ( Tools/base/l1/Long / arraySetContainAny ) in 0.608s
      Passed test routine ( Tools/base/l1/Long / arraySetIdentical ) in 0.422s

    Passed test checks 4293 / 4293
    Passed test cases 1891 / 1891
    Passed test routines 173 / 173
    Test suite ( Tools/base/l1/Long ) ... in 41.251s ... ok

Testing ... in 41.851s ... ok
```

</details>

Об'єктом тестування тест сюіта `Long.test.s` є рутини `_.array*` та `_.buffer*` для роботи із масивами та буферами.

Звіт говорить про те, що всі перевірки було пройдено успішно `Test suite ( Tools/base/l1/Long ) ... in 41.251s ... ok`. Тестування тривало 42-ві секунди та було запущено 173-ри тест рутини. Під час тестування було здійснено 4293-и перевірки, котрі були згруповані розробником в 1891-ин тест кейс. Деталізація звіту залежить від [встановленого рівня вербальності](Verbosity.md).

Тривалість першої тест рутина `bufferFrom` 0.358 секунди і згідно звіту вона, як і решта, пройшла тестування. Пройдені етапи тестування у звіті позначаються зеленим кольором. Провалені етапи тестування позначаються червоним кольором. Достатньо однієї проваленої перевірки щоб увесь тест сюіт вважався проваленим.

Другим способом є використання команди `tst`. Введіть команду

```
tst .run proto/wtools/abase/l1.test/Long.test.s
```

<details>
  <summary><u>Вивід команди <code>tst .run proto/wtools/abase/l1.test/Long.test.s</code></u></summary>

```
$ tst .run proto/wtools/abase/l1.test/Long.test.s

Running test suite ( Tools/base/l1/Long ) ..
    at  /.../wTools/proto/wtools/abase/l1.test/Long.test.s:19500

      Passed test routine ( Tools/base/l1/Long / bufferFrom ) in 0.358s
      Passed test routine ( Tools/base/l1/Long / bufferRelen ) in 0.091s
      Passed test routine ( Tools/base/l1/Long / bufferRetype ) in 0.080s
      Passed test routine ( Tools/base/l1/Long / bufferRawFrom ) in 0.118s
      Passed test routine ( Tools/base/l1/Long / bufferBytesFrom ) in 0.104s
      Passed test routine ( Tools/base/l1/Long / bufferNodeFrom ) in 0.180s
      Passed test routine ( Tools/base/l1/Long / bufferRawFromTyped ) in 0.080s
      Passed test routine ( Tools/base/l1/Long / arrayIs ) in 0.109s
      Passed test routine ( Tools/base/l1/Long / longIs ) in 0.122s
      ...
      Passed test routine ( Tools/base/l1/Long / arraySetContainAny ) in 0.608s
      Passed test routine ( Tools/base/l1/Long / arraySetIdentical ) in 0.422s

    Passed test checks 4293 / 4293
    Passed test cases 1891 / 1891
    Passed test routines 173 / 173
    Test suite ( Tools/base/l1/Long ) ... in 40.622s ... ok



Testing ... in 41.124s ... ok
```

</details>

Читайти команду як: Знайти і запустити всі тести в директорій `proto/wtools/abase/l1.test/Long.test.s`. Порівняйте отриманий вивід з попереднім. Звіт тестування при виконанні теста схожий. Відмінність в часі, який може варіюватися від запуску до запуску.

### Порівняння викликів

Отже, прогнати тест сюіт можливо запустивши `JavaScript` файл на виконання інтерпретатором. Для цього інтерпретатору передається шлях до файла в якості аргумента

```
node File.test.js
```
або передавши цей шлях в якості аргумента утиліті

```
tst File.test.js
```

### Тестування окремої рутини

Тест сюіт розбивається на тест рутини, котрі виконуються послідовно або паралельно й незалежно одна від одної. Тестування цілого тест сюіту не завжди доцільне - це займає більше часу ніж тестування окремої тест рутини.

Для запуску окремої тест рутини використовуйте опцію `routine`.

```
node path/to/TestSuite.js routine:someRoutine
```
або

```
tst .imply routine:someRoutine path/to/TestSuite.js
```

Такий виклик запустить виконання тест рутини `someRoutine` файла `TestSuite.js`.

Запуск тестування із вказанням назви бажаної тест рутини в опції `routine`, обмежує тестування до вказаної тест рутини. Решта тест рутин при такому запуску виконуваться не буде. Опція `routine` має скорочену форму запису - `r`, а також крім повної назви рутини може приймати ґлоб.

Запустіть тест рутину `bufferFrom` сюіта `Long.test.s`. Для запуску тестування введіть команду

```
tst proto/wtools/abase/l1.test/Long.test.s routine:bufferFrom
```

<details>
  <summary><u>Вивід команди <code>tst proto/wtools/abase/l1.test/Long.test.s routine:bufferFrom</code></u></summary>

```
$ tst proto/wtools/abase/l1.test/Long.test.s routine:bufferFrom

Running test suite ( Tools/base/l1/Long ) ..
    at  /.../wTools/proto/wtools/abase/l1.test/Long.test.s:19500

      Passed test routine ( Tools/base/l1/Long / bufferFrom ) in 0.220s

    Passed test checks 18 / 18
    Passed test cases 18 / 18
    Passed test routines 1 / 1
    Test suite ( Tools/base/l1/Long ) ... in 3.645s ... ok


  Testing ... in 5.164s ... ok
```

</details>

Із звіту очевидно, що тестувалася лише одна тест рутина `bufferFrom`. В рамках цієї тест рутини було успішно пройдено 18-ть тест перевірок в 18-ти тест кейсах.

### Тестування скопом

Для тестування тест сюітів скопом потрібно, щоб утиліта `Testing` була [встановлена глобально](Installation.md). Щоб запустити тестування скопом після вводу команди `tst .run` укажіть директорію з тест файлами.

Виконайте тестування в директорії `proto` ввівши команду

```
tst .run proto
```

<details>
  <summary><u>Вивід команди <code>tst .run proto</code></u></summary>

```
$ tst .run proto

    Running test suite ( Tools/base/l1/Diagnostics ) ..
    at  /.../sources/wTools/proto/wtools/abase/l1.test/Diagnostics.test.s:309

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
    at  /.../sources/wTools/proto/wtools/abase/l1.test/Entity.test.s:808

      Passed test routine ( Tools/base/l1/Entity / eachSample ) in 0.070s
      Passed test routine ( Tools/base/l1/Entity / entityMap ) in 0.094s
      Passed test routine ( Tools/base/l1/Entity / entityFilter ) in 0.073s
      ...

    Passed test checks 84 / 84
    Passed test cases 80 / 80
    Passed test routines 10 / 10
    Test suite ( Tools/base/l1/Entity ) ... in 1.089s ... ok

    Running test suite ( Tools/base/l1/Long ) ..
    at  /.../sources/wTools/proto/wtools/abase/l1.test/Long.test.s:19500

      Passed test routine ( Tools/base/l1/Long / bufferFrom ) in 0.145s
      Passed test routine ( Tools/base/l1/Long / bufferRelen ) in 0.073s
      Passed test routine ( Tools/base/l1/Long / bufferRetype ) in 0.071s
      ...

    Passed test checks 4293 / 4293
    Passed test cases 1891 / 1891
    Passed test routines 173 / 173
    Test suite ( Tools/base/l1/Long ) ... in 44.598s ... ok

    Running test suite ( Tools/base/l1/Map ) ..
    at  /.../sources/wTools/proto/wtools/abase/l1.test/Map.test.s:4034

      Passed test routine ( Tools/base/l1/Map / mapIs ) in 0.062s
      Passed test routine ( Tools/base/l1/Map / mapCloneAssigning ) in 0.081s
      Passed test routine ( Tools/base/l1/Map / mapExtendConditional ) in 0.072s
      ...

    Passed test checks 686 / 686
    Passed test cases 355 / 355
    Passed test routines 45 / 45
    Test suite ( Tools/base/l1/Map ) ... in 6.329s ... ok

    Running test suite ( Tools/base/l1/Regexp ) ..
    at  /.../sources/wTools/proto/wtools/abase/l1.test/Regexp.test.s:1749

      Passed test routine ( Tools/base/l1/Regexp / regexpIdentical ) in 0.069s
      Passed test routine ( Tools/base/l1/Regexp / regexpsSources ) in 0.143s
      Passed test routine ( Tools/base/l1/Regexp / regexpsJoin ) in 0.103s
      ...

    Passed test checks 237 / 237
    Passed test cases 211 / 211
    Passed test routines 15 / 15
    Test suite ( Tools/base/l1/Regexp ) ... in 2.755s ... ok

    Running test suite ( Tools/base/l1/Routine ) ..
    at  /.../sources/wTools/proto/wtools/abase/l1.test/Routine.test.s:1558

      Passed test routine ( Tools/base/l1/Routine / _routineJoin ) in 0.084s
      Passed test routine ( Tools/base/l1/Routine / constructorJoin ) in 0.165s
      Passed test routine ( Tools/base/l1/Routine / routineJoin ) in 0.075s
      ...

    Passed test checks 259 / 259
    Passed test cases 71 / 71
    Passed test routines 9 / 9
    Test suite ( Tools/base/l1/Routine ) ... in 2.290s ... ok

    Running test suite ( Tools/base/l1/String ) ..
    at  /.../sources/wTools/proto/wtools/abase/l1.test/String.test.s:3887

      Passed test routine ( Tools/base/l1/String / strLeft ) in 0.500s
      Passed test routine ( Tools/base/l1/String / strRight ) in 0.552s
      Passed test routine ( Tools/base/l1/String / strEquivalent ) in 0.075s
      ...

    Passed test checks 714 / 714
    Passed test cases 298 / 298
    Passed test routines 19 / 19
    Test suite ( Tools/base/l1/String ) ... in 4.814s ... ok

    Running test suite ( Tools/base/l1/Typing ) ..
    at  /.../sources/wTools/proto/wtools/abase/l1.test/Typing.test.s:97

      Passed test routine ( Tools/base/l1/Typing / objectLike ) in 0.074s
      Passed test routine ( Tools/base/l1/Typing / promiseIs ) in 0.042s
      Passed test routine ( Tools/base/l1/Typing / consequenceLike ) in 0.041s

    Passed test checks 20 / 20
    Passed test cases 2 / 2
    Passed test routines 3 / 3
    Test suite ( Tools/base/l1/Typing ) ... in 0.756s ... ok

    Running test suite ( Tools/base/l2/String ) ..
    at  /.../sources/wTools/proto/wtools/abase/l2.test/StringTools.test.s:10462

      Passed test routine ( Tools/base/l2/String / strRemoveBegin ) in 0.216s
      Passed test routine ( Tools/base/l2/String / strRemoveEnd ) in 0.226s
      Passed test routine ( Tools/base/l2/String / strRemove ) in 0.204s
      ...

    Passed test checks 1311 / 1311
    Passed test cases 930 / 930
    Passed test routines 40 / 40
    Test suite ( Tools/base/l2/String ) ... in 10.201s ... ok



  Testing ... in 75.676s ... ok
```

</details>

Утиліта послідовно виконала тестування кожного тест сюіта, що знайшла в директорії `./proto`. Звіт виводиться по мірі готовності.

Загальний підсумок тестування приведений в останньому рядку `Testing ... in 75.676s ... ok` говорить про те, що всі тест сюіти було пройдено успішно і тестування тривало 76 секунд.

Для того щоб [отримати перелік](Help.md) тест сюітів в директорії використайте команду

```
tst .suites.list
```

### Підсумок

- Запуск тестів можливий через команду `tst .run ./Suite.test.js` або через команду `node ./Suite.test.js`.
- Можливо запускати окремі тест сюіти, окремі тест рутини або всі тест сюіти в директорії скопом.
- Для тестування скопом потрібно встановити утиліту `Testing` глобально.
- Інформація щодо провалених тестів допомагає знайти помилки в коді об'єкту тестування.

[Повернутись до змісту](../README.md#Туторіали)
