# Як отримати список тест сюітів

Як отримати інформацію про тест-сюіти.

Для отримання списку тест сюітів використовується сценарій `suites.list`. Він шукає тест файли в указаній директорії.

### Завантаження

В модулі [`wTools`](<https://github.com/Wandalen/wTools>) є готові тест сюіти. Використайте їх для дослідження сценарію. Склонуйте репозиторій модуля виконавши команду `git clone https://github.com/Wandalen/wTools.git`.

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
tst ./proto scenario:suites.list
```

Утиліта просканує директорію прото і видасть список тест файлів.

<details>
  <summary><u>Вивід команди <code>tst ./proto scenario:suites.list</code></u></summary>

```
[user@user ~]$ tst ./proto scenario:suites.list

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

Згідно виводу модуль `Tools` має 10 тест сюітів. Іншими словами, 10 тест файлів так як під кожен тест сюіт відведено окремий файл. Вісім із них знаходяться в `proto/dwtools/abase/l1.test` і один в `proto/dwtools/abase/l2.test`.

Вивід інформації про тест сюіти включає шлях до тест файла, його назву, кількість рядків в тест сюіті та можливість його виконання. Наприклад, перший рядок звіту говорить: файл `Array.test.s` знаходиться за шляхом `/.../wTools/proto/dwtools/abase/l1.test/`, він містить 19500 рядків та доступний для тестування.

В модулі `wTools` всі тест сюіти  можуть виконуватись - `enabled`. Тест файли, котрі вимкнені з тестування мають статус `disabled`.

Якщо виконати команду `tst ./proto/dwtools/abase/l1.test scenario:suites.list`, то утиліта виведе список із восьми тест файлів в указаній директорії. 

В цей же час, можна визначити всі тест файли модуля `wTools`. Для цього використайте команду 

```
tst . scenario:suites.list
```

Крапка в команді позначає, що пошук буде вестись починаючи з поточної директорії.

<details>
  <summary><u>Вивід команди <code>tst . scenario:suites.list</code></u></summary>

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

Утиліта додатково знайшла файл `Sample.test.s` в директорії `sample`. Всі файли в модулі доступні для тестування.

### Підсумок

- Сценарій `suites.list` використовується щоб дізнатись список тест сюітів.
- Утиліта веде пошук тест сюітів в указаній директорії.
- Тест сюіти, доступні для тестування мають статус `enabled`, а вимкнені - `disabled`.
