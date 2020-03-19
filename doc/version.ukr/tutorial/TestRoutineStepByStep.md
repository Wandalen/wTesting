# Покрокове написання тест рутини

Написання тестового покриття до рутини <code>numberIs</code>.

На прикладі імплементації рутини `numberIs`, котра перевіряє чи є переданий аргумент числом, напишемо просту тест рутину.

### Вимоги до рутини

Для того, щоб написати якісне покриття потрібно точно визначити вимоги, які ставляться до об'єкту тестування. В даному випадку, до рутини `numberIs`.

Рутина `numberIs` повинна відповідати наступним вимогам:

- рутина має приймати лише один аргумент, назва параметру `src`;
- перевіряти чи є переданий аргумент числом;
- повертати булеве значення ( `boolean` );
- якщо рутина викликана без аргументів, або передано більш ніж один аргумент, викинути помилку.

### Тести, що перевіряють штатну поведінку

Виходячи з перших трьох умов можна визначити, що якщо передати на вхід рутини `numberIs` числове значення, то маємо отримати на виході `true`.

До чисел відносяться позитивні і негативні числа, цілі та з плаваючою комою. Тож, можна записати перші тест кейси

<details>
  <summary><u>Код тест кейсів</u></summary>

```js
  test.case = 'src is positive integer';
  var src = 5;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is negative integer';
  var src = -5;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is positive float';
  var src = 1.234;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is negative float';
  var src = -1.234;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is zero';
  var src = 0;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );
```

</details>

Кожен тест кейс має стандартну форму. В першому рядку окремому тест кейсу призначається назва. Для того, щоб було зрозуміло що рутина має параметр `src`, назва кожного рядка починається з `src is`. В наступних рядках присвоюються значення змінним. Змінна `src` позначає аргумент, що буде передано в рутину `numberIs` ( гарною практикою є використання назв параметрів рутини для назв змінних ). Змінній `got` присвоюється результат виконання рутини `numberIs`. Змінна `expected` визначає очікуваний результат. Перевірка співпадіння отриманого і очікуваного значення відбувається в тест перевірці `identical`.

Зверніть увагу, що для кожного тест кейсу всі змінні призначаються знову і вони не використовують результати попередніх тест кейсів. Це робить кожен тест кейс незалежним, його можна тестувати окремо.

<details>
  <summary><u>Код залежних тест кейсів</u></summary>

```js
  test.case = 'src is positive integer ( independent )';
  var src = 5;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is negative integer ( dependent )';
  var src = -1 * src;
  var got = num.numberIs( src );
  test.identical( got, expected );
```

</details>

Прогляньте приведену пару тест кейсів. Перший з них повністю незалежний, якщо видалити другий, нічого не зміниться. Проте, другий повністю залежить від першого. Вхідні дані кейсу базуються на першого тест кейса, а також для перевірки результату використовується спільна змінна `expected`. Якщо виникне помилка в другому тест кейсі, то його ізолювати буде неможливо. 

Числа мають і інші форми запису. Якщо число з плаваючою комою перед крапкою має цифру `0`, то вона може бути упущеною. Також, числа можуть записуватись у бінарній, восьмеричній, шістнадцятиричній системі числення. Додамо відповідні тест кейси.

<details>
  <summary><u>Код тест кейсів з бінарним, восьмеричним і шістнадцятиричним числом</u></summary>

```js
  test.case = 'src is positive float without zero';
  var src = .123;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is negative float without zero';
  var src = -.123;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is binary number';
  var src = 0b1010;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is binary number';
  var src = 0o31;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is hex number';
  var src = 0xAB;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );
```

</details>

Крім простих числових значень в `JavaScript` є декілька особливих. До них відносяться `+0`, `-0`, `Infinity`, `-Infinity`, `NaN`.

<details>
  <summary><u>Код тест кейсів з особливими видами чисел</u></summary>

```js
  test.case = 'src is positive zero';
  var src = +0;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is negative zero';
  var src = -0;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is Infinity';
  var src = Infinity;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is -Infinity';
  var src = -Infinity;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is NaN';
  var src = NaN;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );
```

</details>

Більше числових значень немає. Для повноти тестування можна додати один випадок в якому значення буде згенероване через конструктор `Number`.

<details>
  <summary><u>Код тест кейсу перевірки числа створеного через конструктор <code>Number</code></u></summary>

```js
  test.case = 'src is number created by Number constructor';
  var src = Number( '1' );
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );
```

</details>

Всі тест кейси з числовими значеннями написано. Дублювання будь-яких з них небажане тому, що дублювання несуттєво збільшить покриття, але ефективний час на створення тесту і його виконання. Тобто, призведе до збитковості тест рутини.

<details>
  <summary><u>Код тест кейсів, що дублюють перевірку</u></summary>

```js
  test.case = 'src is 5';
  var src = 5;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );


  test.case = 'src is 1000';
  var src = 1000;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );
```

</details>

Вище приведено два тест кейси, котрі тестують один із аспектів об'єкту тестування. А саме перевіряють чи буде рутина повертати `true` якщо на вхід подано ціле додатнє число. Оскільки і перше, і друге число є додатнім та цілим, достатньо написати один тест кейс. 

Тепер потрібно переконатись, що при передачі нечислових значень рутина поверне `false`. Рутина `numberIs` не має обмежень по типу аргументів тому можна передати будь-який інший примітивний чи комплексний тип даних для перевірки. Список нечислових типів досить великий, тож в даному прикладі обрано спеціальний тип `BigInt`, а також `null`, `undefined`, масив і конструктор `Number`. Ви можете самостійно розширити тест рутину іншими типами.

<details>
  <summary><u>Код тест кейсів з нечисловими типами</u></summary>

```js
  test.case = 'src is BigInt';
  var src = 10n;
  var got = num.numberIs( src );
  var expected = false;
  test.identical( got, expected );

  test.case = 'src is null';
  var src = null;
  var got = num.numberIs( src );
  var expected = false;
  test.identical( got, expected );

  test.case = 'src is undefined';
  var src = undefined;
  var got = num.numberIs( src );
  var expected = false;
  test.identical( got, expected );

  test.case = 'src is an array';
  var src = [ 1, 2 ];
  var got = num.numberIs( src );
  var expected = false;
  test.identical( got, expected );

  test.case = 'src is constructor Number';
  var src = Number;
  var got = num.numberIs( src );
  var expected = false;
  test.identical( got, expected );
```

</details>

### Тестування нештатної поведінки

Рутина `numberIs` має обмеження по кількості переданих аргументів. У випадку, якщо кількість переданих аргументів відмінна від одного, рутина має викидати помилку.

<details>
  <summary><u>Код тест кейсів для перевірки виключень</u></summary>

```js
  if( !Config.debug )
  return;

  test.case = 'call without arguments';
  test.shouldThrowErrorSync( () => num.numberIs() );

  test.case = 'call with extra argument';
  test.shouldThrowErrorSync( () => num.numberIs( 1, 'extra' ) );
```

</details>

Прогляньте тест кейси, що будуть перевіряти виключення. Перед кейсами встановлена перевірка того, що інтерпретатор налаштовано в режим `debug`. Тест кейси використовують спеціальну [тест перевірку]( '../concept/TestCheck.md' ) `shouldThrowErrorSync`, що приймає аргументом колбек з викликом тестованої рутини.

Достатньо лише одного тест кейсу з зайвим аргументом, щоб підтвердити поведінку рутини. Бажано вибирати найменше число аргументів, що призведе до помилки.

### Написання рутини `numberIs`

Тест рутина готова. Можна імплементувати рутину `numberIs`.

Для того, щоб перевірити тип аргументу є спеціальна синтаксична конструкція - `typeof`. Переданий аргумент повинен мати тип `number`.


<details>
  <summary><u>Код файла <code>Number.js</code></u></summary>

```js
let _ = require( 'wTools' );

function numberIs( src )
{
  _.assert( arguments.length === 1, 'Expects single argument {-src-}' );

  return typeof src === 'number';
}

module.exports.numberIs = numberIs;
```

</details>

Щоб встановити обмеження на кількість аргументів використовується рутина `assert` модуля `Tools`. В першому аргументі задається умова, а в другому - повідомлення якщо умова не виконується.

Рутина `numberIs` - проста. Тому тестове покриття і відповідна рутина були написані за один цикл. Якщо необхідно створити більш складну рутину, тоді дана процедура розбивається на декілька циклів. В першому імплементується базовий функціонал, а в наступних він розширюється.

### Тестування

<details>
  <summary><u>Структура модуля</u></summary>

```
stepByStep
    ├── Number.js
    ├── Number.test.js    
    └── package.json
```

</details>

Для проведення тестування створіть модуль як приведено вище.

В файл `Number.js` помістіть відповідний код.

<details>
  <summary><u>Код файла <code>Number.test.js</code></u></summary>

```js
require( 'wTesting' );
let num = require( './Number.js' );

//

function numberIs( test )
{
  test.case = 'src is positive integer';
  var src = 5;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is negative integer';
  var src = -5;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is positive float';
  var src = 1.234;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is negative float';
  var src = -1.234;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is zero';
  var src = 0;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is positive float without zero';
  var src = .123;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is negative float without zero';
  var src = -.123;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is binary number';
  var src = 0b1010;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is binary number';
  var src = 0o31;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is hex number';
  var src = 0xAB;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is positive zero';
  var src = +0;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is negative zero';
  var src = -0;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is Infinity';
  var src = Infinity;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is -Infinity';
  var src = -Infinity;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is NaN';
  var src = NaN;
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is number created by Number constructor';
  var src = Number( '1' );
  var got = num.numberIs( src );
  var expected = true;
  test.identical( got, expected );

  test.case = 'src is BigInt';
  var src = 10n;
  var got = num.numberIs( src );
  var expected = false;
  test.identical( got, expected );

  test.case = 'src is null';
  var src = null;
  var got = num.numberIs( src );
  var expected = false;
  test.identical( got, expected );

  test.case = 'src is undefined';
  var src = undefined;
  var got = num.numberIs( src );
  var expected = false;
  test.identical( got, expected );

  test.case = 'src is an array';
  var src = [ 1, 2 ];
  var got = num.numberIs( src );
  var expected = false;
  test.identical( got, expected );

  test.case = 'src is constructor Number';
  var src = Number;
  var got = num.numberIs( src );
  var expected = false;
  test.identical( got, expected );

  if( !Config.debug )
  return;

  test.case = 'call without arguments';
  test.shouldThrowErrorSync( () => num.numberIs() );

  test.case = 'call with extra argument';
  test.shouldThrowErrorSync( () => num.numberIs( 1, 'extra' ) );
}

//

var Self =
{

  name : 'Number',
  enabled : 1,

  tests :
  {

    numberIs,

  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
```

</details>

Тест кейси приведені в туторіалі зібрані в тест рутині `numberIs`. Назва об'єкту тестування і тест рутини співпадають - це спрощує пошук необхідної тест рутини. Крім тест рутини в файлі підключено необхідні залежності і об'явлено тест сюіт. Помістіть приведений код в файл `Number.test.js`.

<details>
    <summary><u>Код файла <code>package.json</code></u></summary>

```json    
{
  "dependencies": {
    "wTools": "",
    "wTesting": ""
  }
}
```

</details>

В файл `package.json` внесіть відповідний код. Встановіть залежності командою `npm i` в директорії модуля.

Після встановлення залежностей можна провести тестування. Запустіть тест сюіт командою `tst .run ./Number.test.js`.

<details>
    <summary><u>Вивід команди <code>tst .run ./Number.test.js</code></u></summary>

```   
$ tst .run ./Number.test.js
Command ".run ./Number.test.js"
Includes tests from : ./Number.test.js

Launching several ( 1 ) test suite(s) ..
    Running test suite ( Number ) ..
    Located at ./Number.test.js:159:8

      Passed TestSuite::Number / TestRoutine::numberIs in 0.129s
    Passed test checks 23 / 23
    Passed test cases 23 / 23
    Passed test routines 1 / 1
    Test suite ( Number ) ... in 0.723s ... ok


  Passed test checks 23 / 23
  Passed test cases 23 / 23
  Passed test routines 1 / 1
  Passed test suites 1 / 1
  Testing ... in 1.293s ... ok
```

</details>

Порівняйте приведений вивід з отриманим.

### Підсумок

- Для написання якісної тест рутини потрібно знати всі вимоги до об'єкту тестування.
- Починати писати покриття бажано з простих тестових випадків поступово розширюючи тест рутину новими кейсами.
- Якщо функціонал об'єкта тестування складний, тоді написання тестів і самого тест об'єкту ділиться на декілька циклів. Спочатку імплементується базовий функціонал, потім він розширюється.
- Кожен тест кейс має бути повністю незалежним від інших. Це робить тест рутину зручною для читання і підтримки. Також, такі тест кейси можна тестувати ізольовано від рутини.
- Для ефективного тестування використовуються граничні значення. Щоб правильно використовувати граничні значення потрібно розуміти як можна згрупувати аргументи і які вони мають обмеження.
- Дублювання тест кейсів призводить до втрати часу на написання тестів і на проведення тестування. При цьому покриття збільшуєтсья незначною мірою.

[Повернутись до змісту](../README.md#tutorials)
