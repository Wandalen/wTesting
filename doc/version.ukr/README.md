# wTesting [![Build Status](https://travis-ci.org/Wandalen/wTesting.svg?branch=master)](https://travis-ci.org/Wandalen/wTesting)

## Швидкий старт

Для швидкого старту [встановіть](<./tutorial/Installation.md>) утиліту `wTesting`, [ознайомтеся](<./tutorial/CLI.md>) із інтрфейсом командного рядка та створіть ваш перший [модуль "Hello World"](<./tutorial/HelloWorld.md>). [Прочитатйе](<./tutorial/Abstract.md>) загальну інформацію якщо вам цікаво дізнатися більше про призначення та філософію утиліти `wTesting`.

Для плавного заглиблення в предмет використовуйте туторіали. Для отримання вичерпного розуміння якогось із аспектів використайте перелік концепцій щоб знайти потрібну і ознайомтеся із нею.

## Концепції

<details><summary><a href="./concept/TestingUnit.md">
      Модульне тестування
  </a></summary>
  Модульне тестування (юніт-тестування) - процес в програмуванні, що дозволяє перевірити на коректність окремі модулі вихідного коду програми.
</details>
<details><summary><a href="./concept/TestSuite.md">
      <code>Тест сюіт</code>
  </a></summary>
  <code>Тест сюіт</code> (тест комлект,тестовий набір) - це набір тест рутин, та тестових данних, необхідних для максимально повного тестування окремих частин задачі.
</details>
<details><summary><a href="./concept/TestRoutine.md">
      <code>Тест рутина</code>
  </a></summary>
    <code>Тест рутина</code> ( функція, метод ) - це набір тест кейсів, що виконуються послідовно одна за одною та поєднанні тим, що відносяться до одного модуля, що тестується або функціональності.
</details>
<details><summary><a href="./concept/TestCase.md">
      <code>Тест кейс</code>
  </a></summary>
    <code>Тест кейс</code> - це одна або декілька перевірок поєднаних із супровідним кодом для виявлення несправності лише одного аспекту об'єкту, що тестується.
</details>
<details><summary><a href="./concept/TestCheck.md">
      <code>Тест перевірка</code>
  </a></summary>
  <code>Тест перевірка</code> - це найменша структурна одиниця тестування, призначена для перевірки лише одного очікуваного результату виконання тесту.
</details>
<details><summary><a href="./concept/TestCoverage.md">
      Покриття теста
  </a></summary>
  Покриття теста (англ. code coverage, tests coverage) — міра, яка використовується при тестуванні програмного забезпечення. Вона визначається відсотком тестованого вихідного коду програми.
</details>
<details><summary><a href="./concept/TestPositiveAndNegative.md">
      Позитивне тестування
  </a></summary>
  Позитивне тестування - це тестування з застосуванням сценаріїв, які відповідають нормальній (штатній, очікуваній) поведінці системи.
</details>
<details><summary><a href="./concept/TestPositiveAndNegative.md">
      Негативне тестування
  </a></summary>
  Негативним називають тестування, в рамках якого застосовуються сценарії, які відповідають позаштатній поведінці тестованої системи.
</details>

## Туторіали

<details><summary><a href="./tutorial/Abstract.md">
      Загальна інформація
  </a></summary>
  Загальна інформація про утиліту <code>wTesting</code>.
</details>
<details><summary><a href="./tutorial/Installation.md">
      Встановлення
  </a></summary>
  Процедура встановлення утиліти <code>wTesting</code>.
</details>
<details><summary><a href="./concept/CommandHelp.md">
      Як отримати довідку про тести
  </a></summary>
  Як дізнатись інформацію про параметри тест-скрипта.
</details>
<details><summary><a href="./concept/TestRoutinePath.md">
      Роутинг в <code>тест рутинах</code>
  </a></summary>
    Як використовувати шляхи в початкових даних <code>тест рутини</code>.
</details>
<details><summary><a href="./concept/TestCheck.md">
      Умови проходження тестування
  </a></summary>
  Як задати умови проходження тестових перевірок певної функціональності.
</details>
<details><summary><a href="./tutorial/TestAnyFile.md">
      Запуск тестування довільного JS-файла
  </a></summary>
  Як запустити тестування в будь-якому JS-файлі користувача.
</details>
<details><summary><a href="./tutorial/TestExecution.md">
      Запуск тестів
  </a></summary>
  Як запускати <code>тест кейси</code>, <code>тест рутини</code>, <code>тест сюіти</code>.  
</details>
<details><summary><a href="./concept/TestCreation.md">
      Створення модульного тесту
  </a></summary>
  Створення модульного тесту димового тестування та санітарного тестування.
</details>
<details><summary><a href="./tutorial/Verbosity.md">
      Контроль рівня вербальності
  </a></summary>
  Зміна кількості виведеної інформації виконання тесту з опцією <code>verbosity</code>.
</details>
<details><summary><a href="./tutorial/TestOptions.md">
      Додаткові опції тестування
  </a></summary>
  Застосування опцій для налаштування проходження тестів.
</details>
