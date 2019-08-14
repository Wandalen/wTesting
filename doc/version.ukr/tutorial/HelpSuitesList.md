# Як отримати список тест сюітів

Як отримати інформацію про тест-сюіти.

Для отримання списку тест сюітів використовується команда `.suites.list`. Вона використовується для пошуку тест файлів в указаній директорії. Тест файли мають суфікс `.test`.

### Завантаження

В модулі [`wTools`](<https://github.com/Wandalen/wTools>) є готові тест сюіти. Використайте їх для дослідження сценарію пошуку. Склонуйте репозиторій модуля виконавши команду `git clone https://github.com/Wandalen/wTools.git`.

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

Код модуля, а також файли з тестами знаходяться в директоріїя `proto`. Директорія `sample` також може містити приклади з тестами.

### Запуск сценарію

Виконайте команду

```
tst .suites.list ./proto
```

Утиліта просканує директорію `proto` і видасть список тест сюітів.

<details>
  <summary><u>Вивід команди <code>tst .suites.list ./proto</code></u></summary>

```
[user@user ~]$ tst .suites.list ./proto

/.../wTools/proto/dwtools/abase/l1.test/Diagnostics.test.s:309 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Entity.test.s:808 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Long.test.s:19500 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Map.test.s:4034 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Regexp.test.s:1749 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Routine.test.s:1558 - enabled
/.../wTools/proto/dwtools/abase/l1.test/String.test.s:3887 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Typing.test.s:97 - enabled
/.../wTools/proto/dwtools/abase/l2.test/StringTools.test.s:10462 - enabled
9 test suites
```

</details>

Згідно виводу модуль `Tools` має 9 тест сюітів. Кожному тест сюіту відведено окремий файл. Вісім із них знаходяться в `proto/dwtools/abase/l1.test` і один в `proto/dwtools/abase/l2.test`.

Вивід інформації про тест сюіти включає шлях до тест файла, його назву та можливість його виконання.

В модулі `Tools` всі тест сюіти увімкнені тому можуть бути запущені на виконання - `enabled:1`. Тест файли, котрі вимкнені з тестування мають статус `enabled:0`.

Якщо виконати команду `tst .suites.list ./proto/dwtools/abase/l1.test`, то утиліта виведе список тест файлів в цій директорії `./proto/dwtools/abase/l1.test`. В ній вісім тест файлів.

### Підсумок

- Команда `.suites.list` використовується щоб дізнатись список тест сюітів.
- Утиліта веде пошук тест сюітів в указаній директорії на всіх рівнях вкладеності.
- Тест сюіти, доступні для тестування мають статус `enabled:1`, а вимкнені - `enabled:0`.

[Повернутись до змісту](../README.md#tutorials)
