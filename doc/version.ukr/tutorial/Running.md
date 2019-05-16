# Запуск тестів

Як запускати окремі тестування окремих тест сюітів та скопом.

### Завантаження

Для запуску тестування потрібні готові тест сюіти, котрі можна знайти в модулі [`wTools`](<https://github.com/Wandalen/wTools>).

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

Склонуйте репозиторій модуля виконавши команду `git clone https://github.com/Wandalen/wTools.git`.

Після клонування перейдіть в директорію із модулем та виконайте команду

```
npm install
```

Це встановило залежності модуля.

Виконайте команду `wtest scenario:suites.list` щоб отримати інформацію про доступні тест сюіти.

<details>
  <summary><u>Вивід команди <code>wtest scenario:suites.list</code></u></summary>

```
[user@user ~]$ wtest . scenario:suites.list

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

Згідно виводу утиліта має 10 тест сюітів. Іншими словами, 10 тест файлів так як в кожному файлі знаходиться один тест сюіт. Дев'ять із них знаходяться в директорії `proto` i один в `sample`.

### Тестування окремого тест сюіта

Для проведення тестування окремого файла використовуються команди `wtest` i `node`. Аргументом команди передається повний відносний ( абсолютний ) шлях до тест файла.

<details>
  <summary><u>Вивід команди <code>wtest proto/dwtools/abase/l1.test/Diagnostics.test.s</code></u></summary>

```
[user@user ~]$ wtest proto/dwtools/abase/l1.test/Diagnostics.test.s

Running test suite ( Tools/base/l1/Diagnostics ) ..
    at  /.../sources/wTools/proto/dwtools/abase/l1.test/Diagnostics.test.s:309

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

Використайте тест файл `Diagnostics.test.s`. Для запуску тестування введіть команду `wtest proto/dwtools/abase/l1.test/Diagnostics.test.s`.

<details>
  <summary><u>Вивід команди <code>node proto/dwtools/abase/l1.test/Diagnostics.test.s</code></u></summary>

```
[user@user ~]$ node proto/dwtools/abase/l1.test/Diagnostics.test.s

Running test suite ( Tools/base/l1/Diagnostics ) ..
    at  /.../sources/wTools/proto/dwtools/abase/l1.test/Diagnostics.test.s:309

      Passed test routine ( Tools/base/l1/Diagnostics / _err ) in 0.121s
      Passed test routine ( Tools/base/l1/Diagnostics / err ) in 0.079s
      Passed test routine ( Tools/base/l1/Diagnostics / errLog ) in 0.080s
      Passed test routine ( Tools/base/l1/Diagnostics / assert ) in 0.061s
      Passed test routine ( Tools/base/l1/Diagnostics / diagnosticStack ) in 0.048s

    Passed test checks 34 / 34
    Passed test cases 30 / 30
    Passed test routines 5 / 5
    Test suite ( Tools/base/l1/Diagnostics ) ... in 1.122s ... ok


  Testing ... in 1.725s ... ok

```

</details>

Виконайте тестування файла `Diagnostics.test.s` ввівши команду `node proto/dwtools/abase/l1.test/Diagnostics.test.s`. Порівняйте виводи команд `wtest proto/dwtools/abase/l1.test/Diagnostics.test.s` i `node proto/dwtools/abase/l1.test/Diagnostics.test.s`

Звіт тестування при виконанні тесту повністю співпадає. Незначна похибка в часі проведення тесту визначається потужністю і завантаженістю машини.

### Тестування окремої рутини

Тестування цілого тест сюіту не завжди доцільне - воно займає більше часу і виконує зайву роботу. Якщо розробник грамотно оформив код, то зміни в окремому модулі не повинні впливати на інші частини коду. Тому, розробник може протестувати лише внесені зміни використавши окрему рутину тест сюіта.

Для запуску окремої тест рутини виконуються команди `wtest path/to/testSuite.js routine:someRoutine` або `node path/to/testSuite.js routine:someRoutine`. Тобто, опцією `routine` можна указати рутину для тестування. Опція `routine` має скорочену форму запису - `r`.

<details>
  <summary><u>Вивід команди <code>wtest proto/dwtools/abase/l1.test/Diagnostics.test.s routine:err</code></u></summary>

```
[user@user ~]$ wtest proto/dwtools/abase/l1.test/Diagnostics.test.s routine:err

Running test suite ( Tools/base/l1/Diagnostics ) ..
    at  /.../sources/wTools/proto/dwtools/abase/l1.test/Diagnostics.test.s:309

       Passed test routine ( Tools/base/l1/Diagnostics / err ) in 0.121s

    Passed test checks 9 / 9
    Passed test cases 9 / 9
    Passed test routines 1 / 1
    Test suite ( Tools/base/l1/Diagnostics ) ... in 0.765s ... ok


  Testing ... in 1.346s ... ok

```

</details>

Проведіть тестування рутини `err` в файлі `Diagnostics.test.s`. Для запуску тестування введіть команду `wtest proto/dwtools/abase/l1.test/Diagnostics.test.s routine:err`.

Було проведено тестування лише одніє рутини. В тест рутині `err` успішно пройдено дев'ять тест перевірок в дев'яти кейсах. Загальний підсумок тестування рутини - пройдено.

<details>
  <summary><u>Вивід команди <code>wtest proto/dwtools/abase/l1.test/Diagnostics.test.s r:assert</code></u></summary>

```
[user@user ~]$ wtest proto/dwtools/abase/l1.test/Diagnostics.test.s routine:assert

Running test suite ( Tools/base/l1/Diagnostics ) ..
    at  /.../sources/wTools/proto/dwtools/abase/l1.test/Diagnostics.test.s:309

       Passed test routine ( Tools/base/l1/Diagnostics / assert ) in 0.068s

    Passed test checks 3 / 3
    Passed test cases 3 / 3
    Passed test routines 1 / 1
    Test suite ( Tools/base/l1/Diagnostics ) ... in 0.714s ... ok


  Testing ... in 1.290s ... ok

```

</details>

Проведіть тестування рутини `assert` в файлі `Diagnostics.test.s`. Для запуску тестування використайте `NodeJS` і скорочену форму запису опції `routine`. Введіть команду `node proto/dwtools/abase/l1.test/Diagnostics.test.s r:assert`. Порівняйте результати виводу.

Тестування пройдено, тестер виконав одну тест рутину `assert` з трьома тест кейсами і трьома перевірками. Прямий запуск через `NodeJS` також вміє обирати одну тест рутину.

### Тестування скопом

Запуск групи тестів можливий з використанням утиліти `wTesting`, котра встановлена глобально в системі. Для проведення групового тестування використовується команда `wtest` в аргумент якої передається назва директорії з тестами.

<details>
  <summary><u>Вивід команди <code>wtest proto</code></u></summary>

```
[user@user ~]$ wtest proto

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

Запустіть тестування в директорії `proto` виконавши команду `wtest proto`. В виводі консолі, приведеному вище, частина рядків замінена на `...` для зменшення об'єму.

Утиліта по черзі виконала тестування в файлах згідно списку виданого командою `wtest scenario:suites.list`. На тестування було використано 75.676s, результат тестування - провалене. Чотири тест кейса в файлі `Entyty.test.s`, що пройшли тестування з помилкою, сформували загальний результат тестування. Навіть при одній проваленій тест перевірці тестування вважалось би проваленим. Інформативний вивід дає розробнику інформацію про ті функціональності які потрібно виправити.

На момент проведення вашого тестування даних помилок може не виникнути.

### Підсумок

- Запуск тестів можливий через утиліту `Testing` i через інтерпретатор `NodeJS`.
- Утиліта здатна запускати окремі тест сюіти.
- Утиліта здатна запускати окремі рутини тест сюіта.
- Перевагою встановлення утиліти `Testing` в використанні довідки і виконанні тестів над групою тест сюітів.

[Повернутись до змісту](../README.md#Туторіали)
