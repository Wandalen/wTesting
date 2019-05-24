# Run option

The control parameter of the testing that is passed to the run command. Run options are performed for each test suite.

The run option is specified after the utility command. For example, in the command

```
tst path/to/dir accuracy:1e-4
```

the `accuracy` option is specified, it sets the allowable numeric deviation. The specified option applies to each test suite in the `path/to/dir` directory.


Run options override test suite options. If the same option in the command and in the test code is used, then the command has a higher priority.

The command can use several run options at the same time. For example, a command with `verbosity` and` silencing` options can look like this:

```
tst path/to/dir verbosity:6 silencing:1
```

You can learn more about the list of run options by going to [tutorial](../tutorial/Help.md#Options-launch-and-options-suites).

# Test suite option

The control parameter of the testing that is specified in the test suite definition. These options override the default values, which in turn can be overridden by the run options.

Формулювання опцій запуску і опцій тест сюіта однакові. Опції тест сюіта мають нижчий пріоритет ніж опції запуску. Тому, якщо тест сюіт і команда запуску мають однакову опцію, то утиліта використовує опцію запуску й ігнорує опції тест сюіта.

![test.suite.options.png](../../images/test.suite.options.png)

На рисунку показана частина коду з визначенням тест сюіта. Після указання імені в тест сюіті позначаються опції тестування.

Тест сюіт має три опції: `silencing`, `verbosity` i `enabled`. При виконанні команди тестування без указаних опцій рівень вербальності звіту буде `5` і звіт не міститиме вивід об'єкту тестування. При застосуванні команд з опціями `silencing` i `verbosity` утиліта використає значення, що указане в команді. Наприклад, при використанні команди

```
tst path/to/dir verbosity:3
```

утиліта виведе звіт з рівнем вербальності `3`.

Деякі опції, як наприклад опція `enabled` (підкреслена червоним) присутня тільки в тест сюіті, вона призначена для вимкнення тест сюіту з тестування. Опція приймає значення `0` і `1`. При `0` - тестування не виконується, `1` - виконується. За замовчуванням встанолено `1`.
