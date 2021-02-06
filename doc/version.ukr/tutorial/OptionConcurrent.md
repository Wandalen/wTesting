# Опція concurrent

Як запустити паралельне виконання тест сюітів.

Призначена для ввімкнення паралельного виконання тест сюітів.

При наявності в одній директорії декількох тест сюітів, утиліта може виконувати їх одночасно.

Має два значення: 1 - ввімкнене, 0 - вимкнене, тестування проходить по черзі. За замовчуванням - 0.

### Тест модуль

В модулі [`wTools`](<https://github.com/Wandalen/wTools>) є готові тест сюіти. Використайте їх для дослідження опції. Склонуйте репозиторій модуля виконавши команду `git clone https://github.com/Wandalen/wTools.git`.

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

Код цього модуля включно із тестами знаходиться в директорії `proto`.

Після клонування перейдіть в директорію із модулем та виконайте команду

```
npm install
```

Це встановило залежності модуля.

### Тестування

Опція має два значення тому, використайте те, що встановлено за замовчуванням. Для цього введіть команду

```
tst .run proto
```

В команді не указано опцію, це аналогічно команді `tst .imply concurrent:0 .run proto`.

<details>
  <summary><u>Вивід команди <code>tst .run proto</code></u></summary>

```
$ tst .run proto

    Running test suite ( Tools/base/l1/Diagnostics ) ..
      at  /.../wTools/proto/wtools/abase/l1.test/Diagnostics.test.s:2036

      Passed test routine ( Tools/base/l1/Diagnostics / _err ) in 0.103s
      Passed test routine ( Tools/base/l1/Diagnostics / err ) in 0.070s
      Passed test routine ( Tools/base/l1/Diagnostics / errLog ) in 0.066s
      ...
    Passed test checks 290 / 290
    Passed test cases 142 / 142
    Passed test routines 21 / 21
    Test suite ( Tools/base/l1/Diagnostics ) ... in 2.949s ... ok

    Running test suite ( Tools/base/l1/Entity ) ..
    at  /.../wTools/proto/wtools/abase/l1.test/Entity.test.s:3276

      Passed test routine ( Tools/base/l1/Entity / eachSample ) in 0.472s
      Passed test routine ( Tools/base/l1/Entity / entityEach ) in 0.273s
      Passed test routine ( Tools/base/l1/Entity / entityEachKey ) in 0.234s
      ...

    Passed test checks 636 / 636
    Passed test cases 226 / 226
    Passed test routines 18 / 18
    Test suite ( Tools/base/l1/Entity ) ... in 4.334s ... ok

    Running test suite ( Tools/base/l1/Long ) ..
    at  /.../wTools/proto/wtools/abase/l1.test/Long.test.s:22325

      Passed test routine ( Tools/base/l1/Long / bufferRawIs ) in 0.145s
      Passed test routine ( Tools/base/l1/Long / bufferTypedIs ) in 0.146s
      Passed test routine ( Tools/base/l1/Long / bufferNodeIs ) in 0.122s
      ...

    Passed test checks 4285 / 4285
    Passed test cases 1883 / 1883
    Passed test routines 173 / 173
    Test suite ( Tools/base/l1/Long ) ... in 77.531s ... ok

    Running test suite ( Tools/base/l1/Map ) ..
    at  /.../wTools/proto/wtools/abase/l1.test/Map.test.s:4034

      Passed test routine ( Tools/base/l1/Map / mapIs ) in 0.062s
      Passed test routine ( Tools/base/l1/Map / mapCloneAssigning ) in 0.081s
      Passed test routine ( Tools/base/l1/Map / mapExtendConditional ) in 0.072s
      ...

    Passed test checks 686 / 686
    Passed test cases 355 / 355
    Passed test routines 45 / 45
    Test suite ( Tools/base/l1/Map ) ... in 6.329s ... ok

    Running test suite ( Tools/base/l1/Regexp ) ..
    at  /.../wTools/proto/wtools/abase/l1.test/Regexp.test.s:1749

      Passed test routine ( Tools/base/l1/Regexp / regexpIdentical ) in 0.069s
      Passed test routine ( Tools/base/l1/Regexp / regexpsSources ) in 0.143s
      Passed test routine ( Tools/base/l1/Regexp / regexpsJoin ) in 0.103s
      ...

    Passed test checks 237 / 237
    Passed test cases 211 / 211
    Passed test routines 15 / 15
    Test suite ( Tools/base/l1/Regexp ) ... in 4.755s ... ok

    Running test suite ( Tools/base/l1/Routine ) ..
    at  /.../wTools/proto/wtools/abase/l1.test/Routine.test.s:1558

      Passed test routine ( Tools/base/l1/Routine / _routineJoin ) in 0.084s
      Passed test routine ( Tools/base/l1/Routine / constructorJoin ) in 0.165s
      Passed test routine ( Tools/base/l1/Routine / routineJoin ) in 0.075s
      ...

    Passed test checks 259 / 259
    Passed test cases 71 / 71
    Passed test routines 9 / 9
    Test suite ( Tools/base/l1/Routine ) ... in 2.290s ... ok

    Running test suite ( Tools/base/l1/String ) ..
    at  /.../wTools/proto/wtools/abase/l1.test/String.test.s:3887

      Passed test routine ( Tools/base/l1/String / strLeft ) in 0.500s
      Passed test routine ( Tools/base/l1/String / strRight ) in 0.552s
      Passed test routine ( Tools/base/l1/String / strEquivalent ) in 0.075s
      ...

    Passed test checks 714 / 714
    Passed test cases 298 / 298
    Passed test routines 19 / 19
    Test suite ( Tools/base/l1/String ) ... in 6.814s ... ok

    Running test suite ( Tools/base/l1/Typing ) ..
    at  /.../wTools/proto/wtools/abase/l1.test/Typing.test.s:97

      Passed test routine ( Tools/base/l1/Typing / objectLike ) in 0.074s
      Passed test routine ( Tools/base/l1/Typing / promiseIs ) in 0.042s
      Passed test routine ( Tools/base/l1/Typing / consequenceLike ) in 0.041s

    Passed test checks 20 / 20
    Passed test cases 2 / 2
    Passed test routines 3 / 3
    Test suite ( Tools/base/l1/Typing ) ... in 0.756s ... ok

    Running test suite ( Tools/base/l2/String ) ..
    at  /.../wTools/proto/wtools/abase/l2.test/StringTools.test.s:10462

      Passed test routine ( Tools/base/l2/String / strRemoveBegin ) in 0.216s
      Passed test routine ( Tools/base/l2/String / strRemoveEnd ) in 0.226s
      Passed test routine ( Tools/base/l2/String / strRemove ) in 0.204s
      ...

    Passed test checks 1311 / 1311
    Passed test cases 930 / 930
    Passed test routines 40 / 40
    Test suite ( Tools/base/l2/String ) ... in 12.201s ... ok



  Testing ... in 85.676s ... ok
```

</details>

Згідно виводу утиліта проводила тестування по черзі від одного тест сюіту до іншого. В один момент часу проводились перевірки лише одного тест сюіту, після його завершення здійснювався запуск наступного.

Першим запущено і виконано тестування в тест сюіті `Tools/base/l1/Diagnostics`. Він знаходиться за шляхом `/.../wTools/proto/wtools/abase/l1.test/` в файлі `Diagnostics.test.s`. Тест сюіт налічує 2036 рядків.
Останнім було протестовано тест сюіт `Tools/base/l2/String` в директорії `wTools/proto/wtools/abase/l2.test`. Тест файл має назву `StringTools.test.s` і включає 10462 рядка.

Проведене тестування успішне.

<details>
  <summary><u>Вивід команди <code>tst .imply concurrent:1 .run proto</code></u></summary>

```
$ tst .imply concurrent:1 .run proto

  Running test suite ( Tools/base/l1/Diagnostics ) ..
  at  /.../wTools/proto/wtools/abase/l1.test/Diagnostics.test.s:309

    Passed test routine ( Tools/base/l1/Diagnostics / _err ) in 0.125s
    Running test suite ( Tools/base/l1/Entity ) ..
    at  /.../wTools/proto/wtools/abase/l1.test/Entity.test.s:808

      Passed test routine ( Tools/base/l1/Entity / eachSample ) in 0.070s
      Running test suite ( Tools/base/l1/Long ) ..
        at  /.../wTools/proto/wtools/abase/l1.test/Long.test.s:19500

          Passed test routine ( Tools/base/l1/Long / bufferFrom ) in 0.232s
          Running test suite ( Tools/base/l1/Map ) ..
          at  /.../wTools/proto/wtools/abase/l1.test/Map.test.s:4034

            Passed test routine ( Tools/base/l1/Map / mapIs ) in 0.068s
            Running test suite ( Tools/base/l1/Regexp ) ..
            at  /.../wTools/proto/wtools/abase/l1.test/Regexp.test.s:1749

              Passed test routine ( Tools/base/l1/Regexp / regexpIdentical ) in 0.078s
              Running test suite ( Tools/base/l1/Routine ) ..
              at  /.../wTools/proto/wtools/abase/l1.test/Routine.test.s:1558

                Passed test routine ( Tools/base/l1/Routine / _routineJoin ) in 0.103s
                Running test suite ( Tools/base/l1/String ) ..
                at  /.../wTools/proto/wtools/abase/l1.test/String.test.s:3887

                  Passed test routine ( Tools/base/l1/String / strLeft ) in 0.614s
                  Running test suite ( Tools/base/l1/Typing ) ..
                  at  /.../wTools/proto/wtools/abase/l1.test/Typing.test.s:97

                    Passed test routine ( Tools/base/l1/Typing / objectLike ) in 0.081s
                    Running test suite ( Tools/base/l2/String ) ..
                    at  /.../wTools/proto/wtools/abase/l2.test/StringTools.test.s:10502

                      Passed test routine ( Tools/base/l2/String / strRemoveBegin ) in 0.265s
                      Passed test routine ( Tools/base/l1/Long / bufferRelen ) in 0.074s
                      Passed test routine ( Tools/base/l1/Diagnostics / err ) in 0.070s
                      Passed test routine ( Tools/base/l1/Entity / entityMap ) in 0.107s
                      Passed test routine ( Tools/base/l1/Map / mapCloneAssigning ) in 0.084s
                      ...
                      Passed test routine ( Tools/base/l1/Map / mapComplement ) in 0.070s

                    Passed test checks 20 / 20
                    Passed test cases 2 / 2
                    Passed test routines 3 / 3
                    Test suite ( Tools/base/l1/Typing ) ... in 5.905s ... ok

                    Passed test routine ( Tools/base/l1/Regexp / regexpsAny ) in 0.091s
                    Passed test routine ( Tools/base/l1/Routine / routinesComposeAll ) in 0.094s
                    ...
                    Passed test routine ( Tools/base/l1/Map / mapFirstPair ) in 0.070s

                  Passed test checks 34 / 34
                  Passed test cases 30 / 30
                  Passed test routines 5 / 5
                  Test suite ( Tools/base/l1/Diagnostics ) ... in 9.168s ... ok

                  Passed test routine ( Tools/base/l1/Regexp / _regexpTest ) in 0.150s
                  Passed test routine ( Tools/base/l1/Routine / routinesChain ) in 0.083s
                  Passed test routine ( Tools/base/l1/String / strBeginOf ) in 0.133s
                  Passed test routine ( Tools/base/l2/String / strAppendOnce ) in 0.147s
                  Passed test routine ( Tools/base/l1/Long / longIs ) in 0.113s
some message
undefined
                  Passed test routine ( Tools/base/l1/Entity / entityLength ) in 0.073s
                  Passed test routine ( Tools/base/l1/Map / mapValWithIndex ) in 0.096s
                  Passed test routine ( Tools/base/l1/Regexp / regexpTest ) in 0.147s
                  ...
                  Passed test routine ( Tools/base/l1/Long / hasLength ) in 0.088s

                Passed test checks 84 / 84
                Passed test cases 80 / 80
                Passed test routines 10 / 10
                Test suite ( Tools/base/l1/Entity ) ... in 12.360s ... ok

                Passed test routine ( Tools/base/l1/Map / mapToStr ) in 0.086s
                Passed test routine ( Tools/base/l1/Regexp / regexpTestAny ) in 0.174s
                ...
                Passed test routine ( Tools/base/l1/Long / argumentsArrayFrom ) in 0.321s

              Passed test checks 259 / 259
              Passed test cases 71 / 71
              Passed test routines 9 / 9
              Test suite ( Tools/base/l1/Routine ) ... in 14.061s ... ok

Consider extending object by :

              Passed test routine ( Tools/base/l1/Map / mapKeys ) in 0.106s
              Passed test routine ( Tools/base/l1/Regexp / regexpsTestAll ) in 0.169s
              Passed test routine ( Tools/base/l1/String / strPrimitive ) in 0.053s
Consider extending object by :

              Passed test routine ( Tools/base/l2/String / strSplitFast ) in 0.756s
              Passed test routine ( Tools/base/l1/Long / unrollMake ) in 0.375s
Consider extending object by :

              Passed test routine ( Tools/base/l1/Map / mapOwnKeys ) in 0.100s
              Passed test routine ( Tools/base/l1/Regexp / regexpsTestAny ) in 0.163s
Consider extending object by :

Consider extending object by :

              Passed test routine ( Tools/base/l1/String / strIsolateLeftOrNone ) in 0.368s
              Passed test routine ( Tools/base/l2/String / strSplitFastRegexp ) in 0.579s
              Passed test routine ( Tools/base/l1/Long / unrollFrom ) in 0.349s
Consider extending object by :

              Passed test routine ( Tools/base/l1/Map / mapAllKeys ) in 0.094s
              Passed test routine ( Tools/base/l1/Regexp / regexpsTestNone ) in 0.147s
              Passed test routine ( Tools/base/l1/String / strIsolateLeftOrAll ) in 0.164s
              Passed test routine ( Tools/base/l2/String / strSplit ) in 0.975s
              Passed test routine ( Tools/base/l1/Long / longMake ) in 0.483s
Consider extending object by :

              Passed test routine ( Tools/base/l1/Map / mapVals ) in 0.102s
Consider extending object by :

Consider extending object by :

              Passed test routine ( Tools/base/l1/String / strIsolateRightOrNone ) in 0.373s
              Passed test routine ( Tools/base/l2/String / strSplitStrNumber ) in 0.083s
              Passed test routine ( Tools/base/l1/Long / longMakeZeroed ) in 0.382s
Consider extending object by :

              Passed test routine ( Tools/base/l1/Map / mapOwnVals ) in 0.091s
              Passed test routine ( Tools/base/l1/String / strIsolateRightOrAll ) in 0.191s

            Passed test checks 237 / 237
            Passed test cases 211 / 211
            Passed test routines 15 / 15
            Test suite ( Tools/base/l1/Regexp ) ... in 21.048s ... ok

            Passed test routine ( Tools/base/l2/String / strStrip ) in 0.242s
            Passed test routine ( Tools/base/l1/Long / arrayMake ) in 0.381s
Consider extending object by :

            Passed test routine ( Tools/base/l1/Map / mapAllVals ) in 0.091s
            Passed test routine ( Tools/base/l1/String / strIsolateInsideOrNone ) in 0.349s
            ...

          Passed test checks 714 / 714
          Passed test cases 298 / 298
          Passed test routines 19 / 19
          Test suite ( Tools/base/l1/String ) ... in 24.516s ... ok

Consider extending object by :

          Passed test routine ( Tools/base/l1/Map / mapProperties ) in 0.130s
          Passed test routine ( Tools/base/l2/String / strSub ) in 0.274s
            Test check ( Tools/base/l1/Long / scalarToVector / nothing # 1 ) ... failed throwing error
          Failed test routine ( Tools/base/l1/Long / scalarToVector ) in 0.042s
Consider extending object by :

          Passed test routine ( Tools/base/l1/Map / mapOwnProperties ) in 0.104s
          Passed test routine ( Tools/base/l2/String / strReplaceWords ) in 0.089s
          Passed test routine ( Tools/base/l1/Long / arrayFromRange ) in 0.128s
Consider extending object by :

          Passed test routine ( Tools/base/l1/Map / mapAllProperties ) in 0.152s
          Passed test routine ( Tools/base/l2/String / strJoin ) in 0.306s
          Passed test routine ( Tools/base/l1/Long / arrayAs ) in 0.091s
Consider extending object by :

          Passed test routine ( Tools/base/l1/Map / mapRoutines ) in 0.173s
          Passed test routine ( Tools/base/l2/String / strJoinPath ) in 0.258s
          Passed test routine ( Tools/base/l1/Long / arrayToMap ) in 0.091s
Consider extending object by :

          Passed test routine ( Tools/base/l1/Map / mapOwnRoutines ) in 0.127s
          Passed test routine ( Tools/base/l2/String / strUnjoin ) in 0.296s
          Passed test routine ( Tools/base/l1/Long / arrayToStr ) in 0.153s
Consider extending object by :

          Passed test routine ( Tools/base/l1/Map / mapAllRoutines ) in 0.171s
          Passed test routine ( Tools/base/l2/String / strUnicodeEscape ) in 0.073s
          Passed test routine ( Tools/base/l1/Long / longAreRepeatedProbe ) in 0.914s
Consider extending object by :

          Passed test routine ( Tools/base/l1/Map / mapFields ) in 0.167s
          Passed test routine ( Tools/base/l2/String / strCount ) in 0.152s
          Passed test routine ( Tools/base/l1/Long / longAllAreRepeated ) in 0.062s
Consider extending object by :

          Passed test routine ( Tools/base/l1/Map / mapOwnFields ) in 0.136s
          Passed test routine ( Tools/base/l2/String / strDup ) in 0.368s
          Passed test routine ( Tools/base/l1/Long / longAnyAreRepeated ) in 0.059s
[Object: null prototype] { length: 0, b: 1, __proto__: [] }
Consider extending object by :

          Passed test routine ( Tools/base/l1/Map / mapAllFields ) in 0.157s
Consider extending object by :

          Passed test routine ( Tools/base/l2/String / strLinesSelect ) in 0.265s
          Passed test routine ( Tools/base/l1/Long / longNoneAreRepeated ) in 0.061s
          Passed test routine ( Tools/base/l1/Map / mapOnlyPrimitives ) in 0.068s
          ...
Result [Object: null prototype] { splits: [], spans: [ 6, 6, 7, 7 ] }

Result [Object: null prototype] { splits: [], spans: [ 6, 6, 7, 7 ] }

Result [Object: null prototype] { splits: [], spans: [ 6, 6, 7, 7 ] }

Result [Object: null prototype] { splits: [], spans: [ 6, 6, 7, 7 ] }

Result [Object: null prototype] { splits: [], spans: [ NaN, NaN, NaN, NaN ] }

Result [Object: null prototype] { splits: [], spans: [ 3, 3, 5, 5 ] }

Result [Object: null prototype] { splits: [], spans: [ 3, 3, 5, 5 ] }

Result [Object: null prototype] { splits: [], spans: [ 3, 3, 5, 5 ] }

Result [Object: null prototype] { splits: [], spans: [ 6, 6, 9, 9 ] }

Result [Object: null prototype] { splits: [], spans: [ 6, 6, 9, 9 ] }

Result [Object: null prototype] { splits: [], spans: [ 6, 6, 9, 9 ] }

Result [Object: null prototype] { splits: [], spans: [ 6, 6, 9, 9 ] }

Result [Object: null prototype] { splits: [], spans: [ 6, 6, 9, 9 ] }

Result [Object: null prototype] { splits: [], spans: [ 4, 4, 11, 11 ] }

Result [Object: null prototype] { splits: [], spans: [ 4, 4, 11, 11 ] }

Result [Object: null prototype] { splits: [], spans: [ 4, 4, 11, 11 ] }

Result [Object: null prototype] { splits: [], spans: [ 4, 4, 11, 11 ] }

Result [Object: null prototype] { splits: [], spans: [ 4, 4, 11, 11 ] }

done1
done2
Result [Object: null prototype] { splits: [], spans: [ 4, 4, 11, 11 ] }

Result [Object: null prototype] { splits: [], spans: [ 4, 4, 11, 11 ] }

Result [Object: null prototype] { splits: [], spans: [ 4, 4, 11, 11 ] }

Result [Object: null prototype] { splits: [], spans: [ 4, 4, 11, 11 ] }

Result [Object: null prototype] { splits: [], spans: [ 4, 4, 11, 11 ] }

Result [Object: null prototype] { splits: [], spans: [ 4, 4, 11, 11 ] }

          Passed test routine ( Tools/base/l2/String / strLinesNearest ) in 0.496s
          Passed test routine ( Tools/base/l1/Long / longSlice ) in 2.073s
          Passed test routine ( Tools/base/l1/Map / mapOnly ) in 0.222s
          ...

        Passed test checks 1317 / 1317
        Passed test cases 936 / 936
        Passed test routines 40 / 40
        Test suite ( Tools/base/l2/String ) ... in 39.466s ... ok

        Passed test routine ( Tools/base/l1/Map / mapOwnAny ) in 0.105s
        Passed test routine ( Tools/base/l1/Long / arrayExtendScreening ) in 0.128s
        Passed test routine ( Tools/base/l1/Map / mapOwnNone ) in 0.083s
        ...

      Passed test checks 686 / 686
      Passed test cases 355 / 355
      Passed test routines 45 / 45
      Test suite ( Tools/base/l1/Map ) ... in 41.850s ... ok

      Passed test routine ( Tools/base/l1/Long / arrayLeft ) in 0.117s
      Passed test routine ( Tools/base/l1/Long / arrayCountElement ) in 0.220s
      Passed test routine ( Tools/base/l1/Long / arrayCountTotal ) in 0.313s
      ...
[object Object]
[object Object]
[object Object]
[object Object]
[object Object]
[object Object]
[object Object]
[object Object]
[object Object]
[object Object]
[object Object]
[object Object]
      Passed test routine ( Tools/base/l1/Long / arraySetContainAll ) in 0.563s
      Passed test routine ( Tools/base/l1/Long / arraySetContainAny ) in 0.530s
xxx
      Passed test routine ( Tools/base/l1/Long / arraySetIdentical ) in 0.376s

    Passed test checks 4285 / 4285
    Passed test cases 1883 / 1883
    Passed test routines 173 / 173
    Test suite ( Tools/base/l1/Long ) ... in 77.531s ... ok



  Testing ... in 80.436s ... ok
```

</details>

Запуск і виконання тестів були одночасними. Утиліта спочатку здійснила запуск всіх тест сюітів в директорії `proto`. Запуск проведний в алфавітному порядку починаючи з файла `Diagnostics.test.s` і закінчуючи файлом `StringTools.test.s`.

Вивід звіту про запуск тестування в кожному наступному тест сюіті відділяється від інших додатковим відступом. Після завершення тестування в одному з тест сюітів відступи зменшуються. Така форма звіту дозволяє легко знайти потрібну інформацію.

Згідно виводу першим було завершене тестування в тест сюіті `Tools/base/l1/Typing`. Файл `Typing.test.s` з вказаним тест сюітом було запущено восьмим від початку тестування. Завершилось тестування на тест сюіті `Tools/base/l1/Long`, файл з тест сюітом було запущено першим.

Крім цього, тестування окремих тест рутин виконувалось паралельно. Перегляньте уважніше декілька рядків зі звіту:

```
Passed test routine ( Tools/base/l1/String / strIsolateLeftOrNone ) in 0.368s
Passed test routine ( Tools/base/l2/String / strSplitFastRegexp ) in 0.579s
Passed test routine ( Tools/base/l1/Long / unrollFrom ) in 0.349s
```

Перша тест рутна `strIsolateLeftOrNone` поміщена в файлі `String.test.s`, що знаходиться за шляхом `wTools/proto/wtools/abase/l1.test`. Друга, `strSplitFastRegexp` - в файлі `String.test.s` за шляхом `wTools/proto/wtools/abase/l2.test`. А третя тест рутина `unrollFrom` в файлі `Long.test.s` за шляхом `wTools/proto/wtools/abase/l1.test`.

### Підсумок

- Запуск паралельного виконання тест сюітів можливий з опцією `concurrent`.
- За замовчуванням тестування відбувається по черзі, згідно алфавітного порядку.
- При паралельному тестуванні, звіт про запуск тест сюіту відділяється додатковими відступами.
- При завершенні тестування окремого тест сюіту величина відступів зменшується.
- Зміна відступів в звіті полегшує зчитування інформації.

[Повернутись до змісту](../README.md#tutorials)
