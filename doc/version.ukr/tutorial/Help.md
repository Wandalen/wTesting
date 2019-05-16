# Як отримати довідку

Як отримати загальну довідку чи дізнатись інформацію про тест-сюіти.

Для отримання підказки по опціям запустіть утиліту без аргументів командою

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

Довідка ділиться на дві секції. В секції `Scenarios` виводиться інформація щодо сценаріїв утиліти. В секції `Tester options` виводится список опцій тестування для налаштування процесу тестування.

[//]: # ( Пропоную створити концепцію "Сценарій тестера" і помістити туди приведені нижче таблиці. Це дозволить прибрати зайве з туторіала - таблиці що є більш довідковими. До того ж це дійсно концепція, я її не розумів поки ви не пояснили )

### Сценарії утиліти `Testing`

Сценарій - поведінка утиліти в залежності від умов виконання команди. В приведеному виводі довідки, секція `Scenarios` налічує п'ять сценаріїв. 

| Сценарії         | Опис                                      |
|:-----------------|:------------------------------------------|
| `test`           | Встановлений за замовчуванням для операцій над файлами. Запускає тестування у вказаній директорії чи файлі. Якщо в команді [запуску тестування](Running.md) не вказати даний сценарій, то поведінка команди не зміниться |
| `help`           | Виводить довідку по наявним сценаріям і опціям утиліти. Сценарій виконується у будь-якій директорії операційної системи. Запуск утиліти без аргументів призводить до запуску сценарію `help` |
| `options.list`   | Виводить довідку по опціям утиліти - секцію `Tester options` загальної довідки. Сценарій виконується у будь-якій директорії операційної системи |
| `scenarios.list` | Виводить довідку по сценаріям утиліти - секцію `Scenarios` загальної довідки. Сценарій виконується у будь-якій директорії операційної системи |
| `suits.list`     | Виводить список наявних тест сюітів ( файлів ) у вказаній директорії |

### Опції тестера

В наявності наступні опції:

| Опція             | Виконувана дія                                                        |
|:------------------|:----------------------------------------------------------------------|
| scenario          | Запуск обраного сценарію утиліти згідно списку в секції `Scenarios`   |
| sanitareTime      | Затримка перед запуском наступного тест сюіта. Вказується в мілісекундах |
| fails             | Встановлює кількість отриманих помилок для дострокового завершення тестування |
| beeping           | Звукове повідомлення після закінчення тесту. 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 1 |
| coloring          | Вимкнення кольорового звіту тестування. 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 1 |
| timing            | Вимкнення виводу сумарного часу проходження тестування. 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 1 |
| rapidity          | Швидкість проходження тесту. Значення від 1 до 5. За замовчуванням - 3 |
| testRoutineTimeOut| Лімітує час,який кожна рутина має працювати. Вказується в мілісекундах. За замовчуванням встановлено 5000мс |
| concurrent        | Виконання тест сюітів параллельно з іншими тест сюітами. 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 0 |
| verbosity         | Кількість вихідної інформації. Значення від 0 до 9. За замовчуванням - 5  |
| importanceOfNegative | Підвищує важливість звітів про помилки та ігнорує пройдені. За замовчуванням - 2 |
| silencing         | Дозволяє фільтрувати звіт в консолі, який виникає під час тестового запуску. 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 0 |
| shoulding         | Вимкнення перевірок що починаються з `should*`. 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 0 |
| accuracy          | Встановлює похибку для тест перевірок при порівнянні числових значень. За замовчуванням 1е-7 |

Частина тест опцій є експериментальною і може працювати некоректно. 

### Як отримати перелік тест сюітів

Щоб отримати перелік тест сюітів не запускаючи тестування використовується сценарій `suits.list`. Для його запуску потрібні готові тест сюіти, котрі можна знайти в модулі [`wTools`](<https://github.com/Wandalen/wTools>).

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

У розробника є два варіанти отримання довідки по тест сюітам. Перший, коли розробник не знає проекту і йому важливо дізнатись де знаходяться необхідні йому тести. Другий, коли розробник знає де знаходяться тест сюіти і хоче отримати про них інформацію. 

<details>
  <summary><u>Вивід команди <code>wtest scenario:suites.list</code></u></summary>

```
[user@user ~]$ wtest scenario:suites.list

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

Виконайте команду `wtest scenario:suites.list` щоб отримати інформацію про всі доступні тести в директорії `wTools`. Порівняйте з приведеним виводом.

Згідно виводу утиліта має 10 тест сюітів. Іншими словами, 10 тест файлів так як в кожному файлі знаходиться один тест сюіт. Дев'ять із них знаходяться в директорії `proto` i один в `sample`.  

Вивід команди показує повний шлях до файлу, його назву та кількість рядків. Наприклад, починаючи від директорії `wTools`, відносний шлях до файла `Array.test.s` виглядає `./proto/dwtools/abase/l1.test/`. Вказаний тест файл містить 19500 рядків.

Тепер вам відома структура розташування тестових файлів модуля `wTools`. Ви можете дізнатись про тест сюіти в обраній директорії.

<details>
  <summary><u>Вивід команди <code>wtest proto/dwtools/abase/l1.test scenario:suites.list</code></u></summary>

```
[user@user ~]$ wtest proto/dwtools/abase/l1.test scenario:suites.list

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

Введіть команду `wtest proto/dwtools/abase/l1.test scenario:suites.list`. Порівняйте виводи консолі.

На відміну від попереднього пошуку, утиліта вивела список тест сюітів які поміщені в директорію `l1.test`. 

### Підсумок

- Для отримання довідки використовується сценарій `help`. Він виконується при запуску утиліти без аргументів або з указанням аргумента `scenario:help`.
- Для отримання списку тест сюітів використовується сценарій `suites.list`.
- Сценарій `suites.list` може виконувати глобальний і локальний пошук тест сюітів.
- Якщо при запуску сценарію `suites.list` не була указана директорія, то пошук ведеться глобально, починаючи від директорії запуску.
- Сценарій `suites.list`.виводить інформацію про шлях до тест файла, його назву, кількість рядків і статус готовності до виконання.
