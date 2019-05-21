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

### Сценарій `test`

Встановлений за замовчуванням якщо при виклику передано шлях до тестів. Запускає тестування тест сюітів у вказаній директорії. Приклад: `tst path/to/dir scenario:test`, що аналогічно `tst path/to/dir`

### Сценарій `help`

Встановлений за замовчуванням якщо при виклику не передано шляху до тестів. Виводить перелік сценаріїв та опцій. Не робить читання або запис файлів. Приклад виклику: `tst scenario:help`, що аналогічно виклику `tst`. 

### Сценарій `options.list`

Виводить довідку по опціям утиліти. Не робить читання або запис файлів. Приклад виклику: `tst scenario:options.list`

### Сценарій `scenarios.list`

Виводить довідку по сценаріям утиліти. Не робить читання або запис файлів. Приклад виклику: `tst scenario:scenarios.list` 

### Сценарій `suites.list`

Знаходить і перераховує всі тест сюіти у вказаній директорії. Запуск тестування не здійснюється. Приклад виклику: `tst path/to/dir scenario:suites.list`

### Опції тестера

Опції тестера призначені для управління процесом тестування.

### Опція `scenario`

Здійснює запуск обраного сценарію утиліти згідно списку в секції `Scenarios`. Список і опис сценаріїв приведено вище.

Приклад виклику: `tst scenario:help`, `tst path/to/dir scenario:suites.list`, тощо.

### Опція `sanitareTime`

Встановлює затримку між завершенням тест сюіта і запуском наступного. 

Опція призначена для завершення виконання перевірок з асинхронними функціями. Вказується в мілісекундах. За замовчуванням встановлено 500мс.

Приклад: `tst path/to/dir sanitareTime:1000`. Команда здійснить тестування в указаній директорії, затримка перед запуском наступного тест сюіта встановлена в одну секунду.

### Опція `fails`

Встановлює кількість отриманих помилок для дострокового завершення тестування. 

При досягненні указаного числа помилок утиліта завершує тестування. За замовчуванням кількість помилок не обмежена. 

Приклад: `tst path/to/dir fails:5`. Команда здійснить тестування в указаній директорії, якщо при тестуванні буде провалено п'ять тестів, то тестування завершиться.

### Опція `beeping` 

Призначена для ввімкнення звукового оповіщення про закінчення тестування. 

Опція має два значення: 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 1. 

Приклад: `tst path/to/dir beeping:0`. Після завершення тестування утиліта не просигналізує звуковим сигналом.

### Опція `coloring`

Призначена для ввімкнення кольорового маркування звіту тестування. 

Опція має два значення: 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 1.

Приклад: `tst path/to/dir coloring:0`. Вивід звіту тестування буде простим, без кольорового маркування результатів.

### Опція `timing`

Призначена для ввімкнення виводу сумарного часу проходження тестування. 

Опція має два значення: 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 1.

Приклад: `tst path/to/dir timing:0`. Після завершення тестування у звіті буде відсутні дані про час тестування.

### Опція `rapidity`

Опція встановлює швидкість проходження тестових перевірок. 

Приймає значення від 1 до 5, де 1 - найповільніше тестування, 5 - найшвидше. За замовчуванням - 3. 

Приклад: `tst path/to/dir rapidity:1`. Вказана команда здійснить тестування на найменшій швидкості.

### Опція `testRoutineTimeOut`

Опція обмежує час, за який кожна рутина тест сюіту має пройти тестування. 

Якщо рутина не була протестована за вказаний час, то вона позначається як провалена (червоним).

Вказується в мілісекундах. За замовчуванням встановлено 5000мс.

Приклад: `tst path/to/dir testRoutineTimeOut:1000`. Після вводу команди на виконання однієї тест рутини буде відведено одну секунду.

### Опція `concurrent`

Призначена для ввімкнення паралельного виконання тест сюітів в указаній директорії. 

При наявності в одній директорії декількох тест сюітів, утиліта може виконувати їх одночасно. 

Має два значення: 1 - ввімкнене, 0 - вимкнене, тестування проходить по черзі. За замовчуванням - 0.

Приклад: `tst path/to/dir concurrent:1`. Якщо в директорії за вказаним шляхом знаходиться декілька тест сюітів, то утиліта буде виконувати їх одночасно.

### Опція `verbosity` 

Призначена для управління багатослівністю звіту тестування, тобто, кількістю виведеної інформації. 

Приймає значення від 0 до 9. При встановленому значенні 0 не виводить жодного рядка. При значенні 9 звіт максимально повний. За замовчуванням - 4.

Приклад: `tst path/to/dir verbosity:5`. Виведений звіт буде повнішим, в порівнянні з тим, що встановлено за замовчуванням.

### Опція `importanceOfNegative`

Призначена для обмеження виводу інформації по рутинам зі статусом `pass` і збільшення об'єму інформації про перевірки зі статусом `failed`. 

Приймає значення від 0 до 9. За замовчуванням - 2.

Приклад: `tst path/to/dir importanceOfNegative:3`. Виведений звіт матиме більше інформації про провалені перевірки.

### Опція `silencing` 

Дозволяє фільтрувати звіт тестування в консолі.

Відладочний код в тест сюіті може вносити власні рядки в тестовий звіт. Опція прибирає ці артефакти з тестового звіту. 

Опція має два значення: 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 0.

Приклад: `tst path/to/dir silencing:1`. При виконанні команди звіт не міститиме додаткових повідомлень внесених розробником в тест файл.

### Опція `shoulding` 

Призначена  для ввімкнення тест перевірок, що починаються з `should*`.

Опція має два значення: 1 - ввімкнене, 0 - вимкнене. За замовчуванням - 1.

Приклад: `tst path/to/dir shoulding:0`. Якщо в тест сюіті є перевірки, що починаються з `should`, вони будуть пропущені.

### Опція `accuracy`

Опція встановлює числове відхилення для тест перевірок, що при порівнянні аргументів з числовим значенням враховують відхилення. 

За замовчуванням встановлено 1е-7. 

Приклад: тест сюіт має перевірку
```js 
test.equivalent( 1, 1.00001 );
``` 
якщо числове відхилення не указане, то вона буде провалена, оскільки значення відрізняються на 1е-5. При виконанні команди `tst path/to/dir accuracy:1e-4` указану перевірку буде пройдено.

### Як отримати перелік тест сюітів

Щоб отримати перелік тест сюітів не запускаючи тестування використовується сценарій `suits.list`. Для його запуску потрібні готові тест сюіти, котрі можна знайти в модулі [`Tools`](<https://github.com/Wandalen/wTools>). Склонуйте репозиторій модуля виконавши команду `git clone https://github.com/Wandalen/wTools.git`.

<details>
  <summary><u>Структура файлів модуля <code>Tools</code></u></summary>

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
- Сценарій `suites.list` перераховує тест сюіти в указаній директорії.
