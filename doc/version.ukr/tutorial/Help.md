# Як отримати довідку

Як отримати загальну довідку чи дізнатись інформацію про тест-сюіти.

Для отримання довідку запустіть утиліту без аргументів командою

```
tst
```

<details>
  <summary><u>Вивід команди <code>tst</code></u></summary>

```
[user@user ~]$ tst
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

Виводиться довідка про сценарії виконання та опції процесу тестування. Наприклад, сценарій `suites.list` виводить перелік доступних сюітів без виконання фактичного тестування, а опція `verbosity` дає можливість керувати рівнем вербальності звітів.

### Сценарії утиліти `Testing`

Сценарій - опція, яка визначає поведінку утиліти при виконанні команди над файлами. Секція `Scenarios` довідки налічує п'ять сценаріїв.

| Сценарії         | Опис                                      |
|:-----------------|:------------------------------------------|
| `test`           | Встановлений за замовчуванням якщо при виклику передано шлях до тестів. Запускає тестування тест сюітів у вказаній директорії. Приклад: `tst path/to/dir scenario:test`, що аналогічно `tst path/to/dir` |
| `help`           | Встановлений за замовчуванням якщо при виклику не передано шляху до тестів. Виводить перелік сценаріїв та опцій. Не робить читання або запис файлів. Приклад виклику: `tst scenario:help`, що аналогічно виклику `tst`. |
| `options.list`   | Виводить довідку по опціям утиліти. Не робить читання або запис файлів. Приклад виклику: `tst scenario:options.list` |
| `scenarios.list` | Виводить довідку по сценаріям утиліти. Не робить читання або запис файлів. Приклад виклику: `tst scenario:scenarios.list` |
| `suites.list`     | Знаходить і перераховує всі тест сюіти у вказаній директорії. Запуск тестування не здійснюється. Приклад виклику: `tst path/to/dir scenario:suites.list` |

### Опції тестера

В наявності такі опції:

| Опція               | Виконувана дія                                                        |
|:--------------------|:----------------------------------------------------------------------|
| `scenario`          | Запуск обраного сценарію утиліти згідно списку в секції `Scenarios`   |
| `sanitareTime`      | Затримка перед запуском наступного тест сюіта. Вказується в мілісекундах. За замовчуванням встановлено 500мс |
| `fails`             | Встановлює кількість отриманих помилок для дострокового завершення тестування |
| `beeping`           | Звукове повідомлення після закінчення тесту. 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 1 |
| `coloring`          | Вимкнення кольорового звіту тестування. 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 1 |
| `timing`            | Вимкнення виводу сумарного часу проходження тестування. 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 1 |
| `rapidity`          | Встановлює швидкість проходження тесту. Повільне тестування при значенні 1, найшвидше - при 5. За замовчуванням - 3 |
| `testRoutineTimeOut`| Лімітує час,який кожна рутина має працювати. Вказується в мілісекундах. За замовчуванням встановлено 5000мс |
| `concurrent`        | Вмикає паралельне виконання тест сюітів в указаній директорії. 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 0 |
| `verbosity`         | Керує кількістю вихідної інформації звіту тестування. Значення від 0 до 9. За замовчуванням - 5 |
| `importanceOfNegative` | Обмежує вивід інформаю по рутинам зі статусов `pass` і збільшує об'єм інформації про помилки. Приймає значення від 0 до 9. За замовчуванням - 2 |
| `silencing`         | Дозволяє фільтрувати звіт в консолі, який виникає під час тестового запуску. 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 0 |
| `shoulding`         | Вимкнення перевірок що починаються з `should*`. 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 0 |
| `accuracy`          | Встановлює числове відхилення для тест перевірок при порівнянні числових значень. За замовчуванням 1е-7 |

Частина тест опцій є експериментальною і може працювати некоректно.

### Як отримати перелік тест сюітів

Щоб отримати перелік тест сюітів не запускаючи тестування використовується сценарій `suits.list`. Для його запуску потрібні готові тест сюіти, котрі можна знайти в модулі [`wTools`](<https://github.com/Wandalen/wTools>). Склонуйте репозиторій модуля виконавши команду `git clone https://github.com/Wandalen/wTools.git`.

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

Після клонування перейдіть в директорію із модулем виконавши команду `cd wTools`.

<details>
  <summary><u>Вивід команди <code>tst proto scenario:suites.list</code></u></summary>

```
[user@user ~]$ tst proto scenario:suites.list

/.../wTools/proto/dwtools/abase/l1.test/Array.test.s:19500 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Diagnostics.test.s:309 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Entity.test.s:808 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Map.test.s:4034 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Regexp.test.s:1749 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Routine.test.s:1558 - enabled
/.../wTools/proto/dwtools/abase/l1.test/String.test.s:3887 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Typing.test.s:97 - enabled
/.../wTools/proto/dwtools/abase/l2.test/StringTools.test.s:10462 - enabled
9 test suites

```

</details>

Виконайте команду `tst proto scenario:suites.list` щоб отримати інформацію про всі доступні тести в директорії `proto`. Порівняйте з приведеним виводом.

Вивід команди показує повний шлях до файлу, його назву та кількість рядків. Наприклад, починаючи від директорії `wTools`, відносний шлях до файла `Array.test.s` виглядає `./proto/dwtools/abase/l1.test/`. Вказаний тест файл містить 19500 рядків.

Згідно виводу модуль має 9 тест сюітів розміщених в директорії `proto`. Іншими словами, 9 тест файлів так як під кожен тест сюіт відведено один файл. Вісім тест сюітів знаходяться за шляхом `/proto/dwtools/abase/l1.test/`, а один в директорії за шляхом `/proto/dwtools/abase/l2.test/`.  

Тепер вам відома структура розташування тестових файлів. Ви можете дізнатись про тест сюіти в обраній директорії. Наприклад, замість директорії `proto` указати шлях `proto/dwtools/abase/l1.test`:

<details>
  <summary><u>Вивід команди <code>tst proto/dwtools/abase/l1.test scenario:suites.list</code></u></summary>

```
[user@user ~]$ tst proto/dwtools/abase/l1.test scenario:suites.list

/.../wTools/proto/dwtools/abase/l1.test/Array.test.s:19500 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Diagnostics.test.s:309 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Entity.test.s:808 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Map.test.s:4034 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Regexp.test.s:1749 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Routine.test.s:1558 - enabled
/.../wTools/proto/dwtools/abase/l1.test/String.test.s:3887 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Typing.test.s:97 - enabled
8 test suites

```

</details>

На відміну від попереднього пошуку, утиліта вивела список тест сюітів які поміщені в директорію `l1.test`.

### Підсумок

- Для отримання довідки використовується сценарій `help`. Він виконується при запуску утиліти без аргументів або з указанням аргумента `scenario:help`.
- Для отримання списку тест сюітів використовується сценарій `suites.list`.
- Сценарій `suites.list` перераховує тест сюіти в указані директорії.
