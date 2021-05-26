# Як отримати довідку

Як отримати загальну довідку.

В утиліті всі команди починаються з вводу `tst .`, тому введіть команду в консолі і порівняйте.

<details>
  <summary><u>Вивід команди <code>tst .</code></u></summary>

```
$ tst .
Command "."
Ambiguity. Did you mean?
  .help - Get help.
  .version - Get current version.
  .imply - Change state or imply value of a variable.
  .run - Run test suites found at a specified path.
  .suites.list - Find test suites at a specified path.
```

</details>

Утиліта вивела короткий список доступних команд. Для отримання повної довідки введіть команду

```
tst .help
```

<details>
  <summary><u>Вивід команди <code>tst</code></u></summary>

```
$ tst .help
Command ".help"
Known commands
  .help - Get help.
  .version - Get current version.
  .imply - Change state or imply value of a variable.
  .run - Run test suites found at a specified path.
  .suites.list - Find test suites at a specified path.
Tester options
  verbosity : Sets the verbosity of report. Accepts a value from 0 to 9. Default value is 4.
  suite : Testing of separate test suite. Accepts name of test suite or a glob.
  routine : Testing of separate test routine. Accepts name of test routine or a glob.
  testRoutineTimeOut : Limits the testing time for test routines. Accepts time in milliseconds. Default value is 5000ms.
  onSuiteEndTimeOut : Limits the execution time for onSuiteEnd handler. Accepts time in milliseconds. Default value is 15000ms.
  accuracy : Sets the numeric deviation for the comparison of numerical values. Accepts numeric values of deviation. Default value is 1e-7.
  sanitareTime : Sets the delay between completing the test suite and running the next one. Accepts time in milliseconds. Default value is 2000ms.
  negativity : Restricts the console output of passed routines and increases output of failed test checks. Accepts a value from 0 to 9. Default value is 1.
  silencing : Enables hiding the console output from the test unit. Accepts 0 or 1. Default value is 0.
  shoulding : Disables negative testing. Accepts 0 or 1. Default value is 0.
  fails : Sets the number of errors received to interrupt the test. Accepts number of fails. By default is unlimited.
  beeping : Disables the beep after test completion. Accepts 0 or 1. Default value is 1.
  coloring : Makes report colourful. Accepts 0 or 1. Default value is 1.
  timing : Disables measurement of time spent on testing. Accepts 0 or 1. Default value is 1.
  debug : Sets value of Config.debug. Accepts 0 or 1. Default value is null, utility does not change debug mode of test unit.
  rapidity : Controls the amount of time spent on testing. Accepts values from -9 to +9. Default value is 0.
  concurrent : Enables parallel execution of test suites. Accepts 0 or 1. Default value is 0.
```

</details>

Виводиться довідка як про команди, так і про опції процесу тестування. Наприклад, команда `.suites.list` виводить перелік доступних сюітів без виконання фактичного тестування, а опція `verbosity` дає можливість керувати рівнем вербальності звітів.

Також, для окремої команди можна отримати довідку. Для цього після вводу `tst .help` потрібно вказати назву команди, наприклад, `tst .help .suites.list`.

### Підсумок

- Всі команди тестера починаються з вводу `tst .`.
- Для отримання довідки використовуються команди `tst .` або `tst .help`.
- Для отримання довідки про окрему команду використовується синтаксис `tst .help [command]`.
- Для отримання списку тест сюітів використовується команда `.suites.list`.

[Повернутись до змісту](../README.md#tutorials)
