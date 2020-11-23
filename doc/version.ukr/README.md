## Швидкий старт

Для швидкого старту [встановіть](<./tutorial/Installation.md>) утиліту `Testing`, ознайомтеся із тим [як запускать тестування](<./tutorial/Running.md>) та створіть ваш перший тест сюіт ["Hello World"](<./tutorial/HelloWorld.md>). Прочитатйе [загальну інформацію](<./tutorial/Abstract.md>) якщо вам цікаво дізнатися більше про призначення та філософію утиліти `Testing`.

Для плавного заглиблення в предмет використовуйте туторіали. Для отримання вичерпного розуміння якогось із аспектів використайте перелік концепцій щоб знайти потрібну і ознайомтеся із нею.

## Концепції

<details>
  <summary><a href="./concept/TestObject.md">
    Об'єкт тестування
  </a></summary>
    Об'єкт тестування - система, коректна робота, якої тестується.
</details>

<details>
  <summary><a href="./concept/TestSuite.md">
    Тест сюіт
  </a></summary>
    Тест сюіт ( тестовий комлект, тестовий набір ) - це набір тест рутин, та тестових данних для тестування об'єкту тестування.
</details>

<details>
  <summary><a href="./concept/TestRoutine.md">
    Тест рутина
  </a></summary>
    Тест рутина - рутина ( функція, метод ) розроблена для тестування, якогось із аспектів об'кту тестування. Тест сюіт розбивається на тест рутини, кожна із котрих виконується незалежно одна від одної. Інструкції тест рутини виконується послідовно та містять в собі тест перевірки, котрі можуть об'єднуватися в тест кейси та можуть мати опис.
</details>

<details>
  <summary><a href="./concept/TestCheck.md">
    Тест перевірка
  </a></summary>
    Тест перевірка - очікування розробника стосовно поведінки об'єкту, що тестується виражене якоюсь умовою. Це найнижча структурна одиниця тестування.
</details>

<details>
  <summary><a href="./concept/TestCase.md">
    Тест кейс
  </a></summary>
    Тест кейс або група тест перевірок - це одна або декілька тест перевірок із супровідним кодом поєднаних в логічну структурну одиницю для перевірки функціональності якогось аспекту об'єкту, що тестується.
</details>

<details>
  <summary><a href="./concept/TestCase.md">
    Група тест перевірок
  </a></summary>
    Тест кейс або група тест перевірок - це одна або декілька тест перевірок із супровідним кодом поєднаних в логічну структурну одиницю для перевірки функціональності якогось аспекту об'єкту, що тестується.
</details>

<details>
  <summary><a href="./concept/TestCoverage.md">
    Тестове покриття
  </a></summary>
    Тестове покриття — метрика тестування програмного забезпечення, що визначається відсотком тестованого вихідного коду програми.
</details>

<details>
  <summary><a href="./concept/TestCheck.md#Позитивне-тестування">
    Позитивне тестування
  </a></summary>
    Тестування коректності роботи об'єкта тестування за нормальних умов, при відсутності помилок в вхідних даних та нормальному стані.
</details>

<details>
  <summary><a href="./concept/TestCheck.md#Негативне-тестування">
    Негативне тестування
  </a></summary>
    Тестування коректності обробки об'єктом тестування помилкових даних чи помилкового стану.
</details>

<details>
  <summary><a href="./concept/TestingStatus.md#Помилка-тестування">
    Помилка тестування
  </a></summary>
    Подія чи умова, яка призвела до провалу тестування.
</details>

<details>
  <summary><a href="./concept/TestingStatus.md#Пройдене-тестування">
    Пройдене тестування
  </a></summary>
    Результат проходження тестування, котрий не містить помилок тестування.
</details>

<details>
  <summary><a href="./concept/TestingStatus.md#Провалене-тестування">
    Провалене тестування
  </a></summary>
    Результат виконання тестування, котрий містить принаймні одну помилку тестування.
</details>

<details>
  <summary><a href="./concept/TestOption.md#Опція-запуска">
    Опція запуска
  </a></summary>
    Параметр для керування процесом тестування, який передається через команду запуску. Опції тестування застосовується до кожного тест сюіта.
</details>

<details>
  <summary><a href="./concept/TestOption.md#Опція-тест-сюіта">
    Опція тест сюіта
  </a></summary>
    Параметр для керування процесом тестування, який вказується в коді визначення тест сюіта. Такі опції переписують значення за замовучуванням і, в свою чергу, можуть бути переписані опціями запуску.
</details>

<details>
  <summary><a href="./concept/TestOption.md#Опція-тест-рутини">
    Опція тест рутини
  </a></summary>
    Параметр для керування процесом тестування заданий в окремій тест рутині.
</details>

## Туторіали

<details>
  <summary><a href="./tutorial/Abstract.md">
    Загальна інформація
  </a></summary>
    Загальна інформація про утиліту Testing.
</details>

<details>
  <summary><a href="./tutorial/Installation.md">
    Встановлення
  </a></summary>
    Процедура встановлення утиліти Testing.
</details>

<details>
  <summary><a href="./tutorial/Help.md">
    Як отримати довідку
  </a></summary>
    Як отримати загальну довідку.
</details>

<details>
  <summary><a href="./tutorial/Options.md">
    Опції запуску та опції сюіта
  </a></summary>
    Опції для управління процесом тестування.
</details>

<details>
  <summary><a href="./tutorial/HelpSuitesList.md">
    Як отримати список тест сюітів
  </a></summary>
    Як отримати інформацію про тест-сюіти.
</details>

<details>
  <summary><a href="./tutorial/Running.md">
    Запуск тестів
  </a></summary>
    Як запускати тестування окремих тест сюітів та тестування скопом.
</details>

<details>
  <summary><a href="./tutorial/TestSuiteStructure.md">
    Огляд структурних одиниць
  </a></summary>
    Загальний опис структурних одиниць тест сюіта.
</details>

<details>
  <summary><a href="./tutorial/HelloWorld.md">
    Тест сюіт "Hello World!"
  </a></summary>
    Створення простого тест сюіта.
</details>

<details>
  <summary><a href="./tutorial/TestRoutineStepByStep.md">
    Покрокове написання тест рутини
  </a></summary>
    Написання тестового покриття до рутини <code>numberIs</code>.
</details>

<details>
  <summary><a href="./tutorial/TestRoutineBasicTechnics.md">
    Техніка розробки тестів
  </a></summary>
    Описано базові навички написання тест рутин та найпоширеніші помилки.
</details>

<details>
  <summary><a href="./tutorial/TestRoutineAdvancedTechnics.md">
    Розширені техніки
  </a></summary>
    Описано прийоми і техніки, що роблять тест рутину зручною для читання і підтримки.
</details>

<details>
  <summary><a href="./tutorial/Report.md">
    Як читати звіт та групувати перевірки
  </a></summary>
    Як читати звіт тестування та групувати тест перевірки в групи та тест кейси. Як опис відображається в звіті.
</details>

<details>
  <summary><a href="./tutorial/TestSuiteDesign.md">
    Оформлення тест сюіта
  </a></summary>
    Описано структуру тест сюіта, підхід в використанні елементів.
</details>

<details>
  <summary><a href="./tutorial/Verbosity.md">
    Контроль рівня вербальності
  </a></summary>
    Зміна кількості виведеної інформації опцією verbosity.
</details>

<details>
  <summary><a href="./tutorial/TestRoutineExperimental.md">
   Експериментальна тест рутина
  </a></summary>
    Створення експериментальних тест рутин як засобу для поліпшення розуміння коду і комунікації між членами команди розробників.
</details>

<details>
  <summary><a href="./tutorial/OptionSanitareTime.md">
    Опція sanitareTime
  </a></summary>
    Регулювання часу на завершення виконання асинхронних перевірок.
</details>

<details>
  <summary><a href="./tutorial/OptionBeeping.md">
    Опція beeping
  </a></summary>
    Сигналізація про закінчення тестування.
</details>

<details>
  <summary><a href="./tutorial/OptionTiming.md">
    Опція timing
  </a></summary>
    Ввімкнення підрахунку часу тестування.
</details>

<details>
  <summary><a href="./tutorial/OptionRoutineTimeOut.md">
    Опція routineTimeOut
  </a></summary>
    Як задати час на виконання тест рутини.
</details>

<details>
  <summary><a href="./tutorial/OptionRapidity.md">
    Опція rapidity
  </a></summary>
    Як встановити пріоритет виконання тест рутини та керувати проходженням тестування.
</details>

<details>
  <summary><a href="./tutorial/OptionShoulding.md">
    Опція shoulding
  </a></summary>
    Як вимкнути перевірки з should*.
</details>

<details>
  <summary><a href="./tutorial/OptionSilencing.md">
    Опція silencing
  </a></summary>
    Фільтрування звіту тестування від сторонніх включень.
</details>

<details>
  <summary><a href="./tutorial/OptionAccuracy.md">
    Опція accuracy
  </a></summary>
    Як врахувати точність обчислень при порівнянні числових значень.
</details>

<details>
  <summary><a href="./tutorial/OptionConcurrent.md">
    Опція concurrent
  </a></summary>
    Як запустити паралельне виконання тест сюітів.
</details>

<details>
  <summary><a href="./tutorial/Optionnegativity.md">
    Опція negativity
  </a></summary>
    Як отримати більше інформації про провалені тести.
</details>

<details>
  <summary><a href="./tutorial/SuiteInheritance.md">
    Наслідування тест сюіта
  </a></summary>
    Наслідування одного тест сюіта іншим.
</details>

<!--
<details>
  <summary><a href="./tutorial/OptionFails.md">
    Опція fails
  </a></summary>
    Як завершити тестування при досягненні деякого числа провалених тестів.
</details>

<details>
  <summary><a href="./tutorial/OptionColoring.md">
    Опція coloring
  </a></summary>
    Використання кольорового звіту.
</details>
-->

