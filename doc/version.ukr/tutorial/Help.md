# Як отримати довідку

Як отримати загальну довідку чи дізнатись інформацію про тест-сюіти.

Для отримання підказки по опціям запустіть утиліту без аргументів

```
wtest
```

<details>
  <summary><u>Вивід команди <code>wtest</code></u></summary>

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

Довідка ділиться на дві секції. В секції `Scenarios` виводиться інформація щодо тест сценаріїв. В секції `Tester options` виводится список доступних опцій тестування для управління процесом тестування.

### Сценарії утиліти `Testing`

Сценарій - поведінка утиліти при виконанні команди. В приведеному виводі довідки, секція `Scenarios` налічує п'ять сценаріїв виконання. 

| Сценарії         | Опис                                      |
|:-----------------|:------------------------------------------|
| `test`           | Встановлений за замовчуванням для операцій над файлами. Запускає тестування у вказаній директорії чи файлі. Якщо в команді [запуску тестування](Running.md) не вказати даний сценарій, то поведінка команди не зміниться |
| `help`           | Виводить довідку по наявним сценаріям і опціям утиліти. Сценарій виконується у будь-якій директорії операційної системи. Запуск утиліти без аргументів призводить до запуску сценарію `help` |
| `options.list`   | Виводить довідку по опціям утиліти - секцію `Tester options` загальної довідки. Сценарій виконується у будь-якій директорії операційної системи |
| `scenarios.list` | Виводить довідку по сценаріям утиліти - секцію `Scenarios` загальної довідки. Сценарій виконується у будь-якій директорії операційної системи |
| `suits.list`     | Виводить список наявних тест сюітів ( файлів ) у вказаній директорії |

### Які є опції тестера

В наявності наступні опції:

| Опція             | Виконувана дія                                                        |
|:------------------|:----------------------------------------------------------------------|
| scenario          | Ім'я сценарію для запуску                                             |
| sanitareTime      | Затримка перед запуском наступного тест сюіта                         |
| usingBeep         | дзвінок після закінчення тесту                                        |
| routine           | Iм'я рутини для виконання                                             |
| fails             | Максимальне число хибних тестів перед тим, як закінчити               |
| silencing         | Дозволяє ловити вихід консолі, який виникає під час тестового запуску |
| testRoutineTimeOut| Лімітує час,який кожна рутина має працювати                           |
| concurrent        | Виконання тест сюітів параллельно з іншими тест сюітами               |
| verbosity         | Кількість вихідної інформації                                         |


### Як отримати перелік тест сюітів

Щоб отримати перелік тест сюітів не запускаючи їх виконання використовується сценарій `suits.list`. Для його запуску потрібні готові тест сюіти, котрі можна знайти в модулі [`wTools`](<https://github.com/Wandalen/wTools>).

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

Після клонування перейдіть в директорію із модулем виконавши команду `cd wTools`.

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

Згідно виводу утиліта має 10 тест сюітів. Іншими словами, 10 тест файлів так як в кожному файлі знаходиться один тест сюіт. Дев'ять із них знаходяться в директорії `proto` i один в `sample`.

Вивід показує повний шлях до файлу, його назву та кількість рядків. Наприклад, починаючи від директорії `wTools`, відносний шлях до файла `Array.test.s` виглядає `./proto/dwtools/abase/l1.test/`. Вказаний тест файл містить 19500 рядків.
