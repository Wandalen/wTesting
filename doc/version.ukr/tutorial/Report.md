## Як читати звіт та групувати перевірки

Як читати звіт тестування та групувати тест перевірки в групи та тест кейси. Як опис відображається в звіті.

<details>
  <summary><u>Структура модуля</u></summary>

```
report
   ├── Join.js
   ├── Join.test.js    
   └── package.json

```

</details>

Створіть приведену вище структуру файлів для проведення тестування рутини.

### Об'єкт тестування

<details>
    <summary><u>Код файла <code>Join.js</code></u></summary>

```js    
module.exports.join = function( a, b )
{
  return String( a ) + String( b );
}

```

</details>

Внесіть приведений вище код в файл `Join.js`.

Функція `join` виконує конкатенацію двох рядків. Вона експортується для використання.

### Тестовий файл

Тест сюіт `Join.test.js` має суфікс `.test` для того, щоб утиліта для тестування могла знайти його.

<details>
    <summary><u>Код файла <code>Join.test.js</code></u></summary>

```js    
let _ = require( 'wTesting' );
let Join = require( './Join.js' );

//

function routine1( test )
{

  test.open( 'string' );

    test.case = 'trivial';
    test.identical( Join.join( 'a', 'b' ), 'ab' );

    test.case = 'empty';
    test.identical( Join.join( '', '' ), '' );

  test.close( 'string' );
  test.open( 'number' );

    test.case = 'trivial';
    test.identical( Join.join( 1, 3 ), '13' );

    test.case = 'zeroes';
    test.identical( Join.join( 0, 0 ), '00' );

  test.close( 'number' );
  test.open( 'mixed' );

    test.identical( Join.join( 'a', 3 ), 'a3' );

  test.close( 'mixed' );
 

}

//

var Self =
{
  name : 'Join',
  tests :
  {
    routine1,
  }
}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

```

</details>

Внесіть приведений вище код в файл `Join.test.js`.

Тестова рутина `routine1` має 2-ві групи перевірок `string` та `number`, а також тест кейс `mixed` з однією перевіркою. Їх було так згруповано по типу аргументів, що передаються функції, що тестується `Join.join`. Група `string` містить 2-ва тест кейси `trivial` та `empty`, в кожному із яких по одній перевірці. Група `number` має тест кейси `trivial` та `zeroes` із одною перевіркою в кожному. 

### Як читати звіт про тестування

Між структурою тест файла і виводом результатів тестування є пряма залежність.

Запустіть тестування в файлі `Join.test.js`, виконавши команду 
```
tst Join.test.js verbosity:5
```

Опцією `verbosity` встановлено кількість виводу інформації. Детальніше про опцію можете дізнатись в туторіалі про [контроль рівня вербальності](Verbosity.md). 

<details>
    <summary><u>Відповідність між звітом в консолі і вмістом файла <code>Join.test.js</code></u></summary>

![report.png](../../images/report.png)

</details>

